//
//  CashFlowViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/12.
//
//

#import "CashFlowViewController.h"
#import "BrokenLineObject.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "MMDrawerBarButtonItem.h"
#import "UUChart.h"
#import "UIViewController+MMDrawerController.h"
#import "PokcetExpenseAppDelegate.h"
#import "CashFlowTableViewCell.h"

@interface CashFlowViewController ()<UITableViewDataSource,UITableViewDelegate,UUChartDataSource>
{
    NSMutableArray  *_transactionByDateArray;
    NSDate *_cashStartDate;
    NSDate *_cashEndDate;
    UITableView *myTableView;
    
    UIView *menuView;
    NSInteger formerTag;
    UILabel *rightLabel;
    UILabel *timeLabel;
    
    UIView *backView;
}
@property (nonatomic, strong)NSFetchedResultsController     *fetchedResultsByDateController;

@end

@implementation CashFlowViewController
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [myTableView reloadData];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    
    __weak UIViewController *slf = self;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecongize=NO;
        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            CGPoint location = [touch locationInView:slf.view];
            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 100, SCREEN_HEIGHT), location);
            [appDelegate.menuVC reloadView];
        }
        
        return shouldRecongize;
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTimeLabel];
    [self getData];
    [self createTableView];
    [self createLineChart];
    [self initNav];
    [self createMenu];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

}
#pragma mark - 创建组件
-(void)createTimeLabel
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _cashStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
    _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-200, 5, 200, 15)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_cashStartDate];
    NSString *endSrting = [dateFormatter stringFromDate:_cashEndDate];

    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    timeLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:timeLabel];
    
}

-(void)createMenu
{
    backView=[[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick:)];
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    
    menuView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10, 5, 0, 0)];
    
    menuView.layer.cornerRadius=6;
    menuView.layer.masksToBounds=YES;
    
    NSArray *array=@[NSLocalizedString(@"VC_ThisYear", nil),NSLocalizedString(@"VC_LastYear", nil),NSLocalizedString(@"VC_Last12Months", nil)];
    for (int i=0; i<3; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 121, 44)];
        if (i!=2)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"button_background"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_background_click"] forState:UIControlStateHighlighted];
        }
        else
        {
            btn.backgroundColor=[UIColor whiteColor];
            [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]] forState:UIControlStateHighlighted];
        }
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        [btn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        
        menuView.clipsToBounds=YES;
        [menuView addSubview:btn];
    }
    [self.view addSubview:menuView];
}
-(void)initNav
{
    [self.navigationController.navigationBar  doSetNavigationBar];
    self.navigationItem.title =NSLocalizedString(@"VC_CashFlow", nil);
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chart_time"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnClick:)];
    rightButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appdelegate.menuVC reloadView];
}


-(void)createTableView
{
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT-150-64) style:UITableViewStylePlain];
    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    
    
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
}
#pragma mark - 选择按钮
-(void)rightBtnClick:(id)sender
{
    if (menuView.frame.size.height==0)
    {
        [self dateChooseShow];
    }
    else
    {
        [self dateChooseHide];
    }
}
-(void)dateBtnClick:(id)sender
{
    UIButton *btn=sender;
    if (formerTag==btn.tag)
    {
        [self dateChooseHide];
        return;
    }
    
    formerTag=btn.tag;
    
    //修改时间段
    [self changeDatePeriodTag:btn.tag];
    [self dateChooseHide];
    
    //重新获取数据
    [self getData];
    //重新加载视图
    [myTableView reloadData];
    [self createLineChart];
    
    [self.view bringSubviewToFront:backView];
    [self.view bringSubviewToFront:menuView];
    //修改时间段label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_cashStartDate];
    NSString *endSrting = [dateFormatter stringFromDate:_cashEndDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
}
-(void)changeDatePeriodTag:(NSInteger)tag
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    if (tag==0)
    {
        _cashStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    }
    else if (tag==1)
    {
        component.year = component.year-1;
        component.month = 1;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _cashStartDate = [cal dateFromComponents:component];
        _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    }
    else
    {
        component.year = component.year;
        component.month = component.month -11;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _cashStartDate = [cal dateFromComponents:component];
        NSDateComponents *comp2 = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:_cashStartDate];
        [comp2 setYear:1];
        [comp2 setMonth:0];
        [comp2 setDay:-1];
        [comp2 setHour:23];
        [comp2 setMinute:59];
        [comp2 setSecond:59];
        _cashEndDate =  [cal dateByAddingComponents:comp2 toDate:_cashStartDate options:0];

    }
    
}
-(void)dateChooseShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(SCREEN_WIDTH-121-10, 5, 121, 44*3);
    [UIView commitAnimations];
    backView.alpha=0.1;
}
-(void)dateChooseHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(SCREEN_WIDTH-10, 5, 0, 0);
    [UIView commitAnimations];
    backView.alpha=0;
}
#pragma mark - Data
- (NSFetchedResultsController *)fetchedResultsByDateController_getData{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError * error=nil;
    NSDictionary *subs;
    subs = [NSDictionary dictionaryWithObjectsAndKeys:_cashStartDate,@"startDate",_cashEndDate,@"endDate", nil];
    
    
    NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDate_ExceptTransfer" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController* fetchedResults;
    fetchedResults= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:appDelegete.managedObjectContext
                                                          sectionNameKeyPath:@"groupByMonthString"
                                                                   cacheName:@"Root"];
    self.fetchedResultsByDateController = fetchedResults;
    [fetchedResults performFetch:&error];
    
    return _fetchedResultsByDateController;
}

-(void)getData
{
    _transactionByDateArray=[NSMutableArray array];
    NSError *error = nil;
    if (![self fetchedResultsByDateController_getData])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    [_transactionByDateArray removeAllObjects];
    
    //创建cash report需要的最初的不带有值的数组存放于transactionByDateArray中
    [self createCashArray];
    
    //将获取的transaction替换掉最初的数据， 存储brokenline数组设置expense amount,income amount,transaction array
    [self calculateSortArrayandReplaceCashArray];

}
-(void)createCashArray
{
    [_transactionByDateArray removeAllObjects];
    
    unsigned flag1 = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    NSDateComponents *dateComponent =  [[NSCalendar currentCalendar]components:flag1 fromDate:_cashStartDate];
    
    for (int i=0; i<12; i++)
    {
        NSDate *oneDate = [[NSCalendar  currentCalendar]dateFromComponents:dateComponent];
        BrokenLineObject *oneBrokenLineObject = [[BrokenLineObject alloc]initWithDay:oneDate];
        [_transactionByDateArray addObject:oneBrokenLineObject];
        dateComponent.year = dateComponent.year;
        dateComponent.month = dateComponent.month + 1;
    }
}
-(void)calculateSortArrayandReplaceCashArray
{
    //获取数组的个数
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    double maxOfBarAmount = 0;
    for (long i=0; i<[[self.fetchedResultsByDateController sections] count]; i++)
    {
        //获取每个section的总expense amount,income amount
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsByDateController sections]objectAtIndex:i];
        double  itemTotalExpenseAmount = 0;
        double  itemTotalIncomeAmount = 0;
        
        for (long int k=0;k<[sectionInfo numberOfObjects]; k++)
        {
            Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:k];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"])
            {
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
            else if(oneTransaction.category == nil && oneTransaction.expenseAccount!= nil ){
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if (oneTransaction.category ==nil && oneTransaction.incomeAccount!= nil){
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
        }
        double maxBetwenExpenseandIncome = itemTotalExpenseAmount>itemTotalIncomeAmount?itemTotalExpenseAmount:itemTotalIncomeAmount;
        maxOfBarAmount = maxOfBarAmount>maxBetwenExpenseandIncome?maxOfBarAmount:maxBetwenExpenseandIncome;
    }
    
    
    for (long i=0; i<[[self.fetchedResultsByDateController sections] count]; i++)
    {
        //获取每个section的总expense amount,income amount
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsByDateController sections]objectAtIndex:i];
        double  itemTotalExpenseAmount = 0;
        double  itemTotalIncomeAmount = 0;
        
        for (long int k=0;k<[sectionInfo numberOfObjects]; k++)
        {
            Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:k];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"])
            {
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
            else if(oneTransaction.category == nil && oneTransaction.expenseAccount!= nil ){
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if (oneTransaction.category ==nil && oneTransaction.incomeAccount!= nil){
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
        }
        //将获取到的section信息 替换cash array中的数据
        Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:0];
        NSDate *oneDate = [appDelegate_iPhone.epnc getStartDateWithDateType:2 fromDate:oneTransaction.dateTime];
        for (int k=0; k<12; k++) {
            BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:k];
            if ([appDelegate_iPhone.epnc monthCompare:oneDate withDate:oneBrokenLineObject.dateTime]==0) {
                oneBrokenLineObject.expenseAmount = itemTotalExpenseAmount;
                oneBrokenLineObject.incomeAmount = itemTotalIncomeAmount;
                oneBrokenLineObject.maxAmount = maxOfBarAmount;
                break;
            }
        }
    }
}
#pragma mark - 折线图 部分
-(void)createLineChart
{
    for (UIView *view in _topView.subviews)
    {
        [view removeFromSuperview];
    }

    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _topView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_topView];
    
    float scrollViewToleft;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        scrollViewToleft=16;
    }
    else if (IS_IPHONE_6)
    {
        scrollViewToleft=15;
    }
    else if (IS_IPHONE_6PLUS)
    {
        scrollViewToleft=15;
    }
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-scrollViewToleft, 150-25)];
//    scrollView.contentSize=CGSizeMake((SCREEN_WIDTH-scrollViewToleft)*2, 150-25);
    scrollView.contentSize = CGSizeMake(SCREEN_WITH, 125);
    scrollView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    
    [self.topView addSubview:scrollView];

    UUChart *chartView=[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) withSource:self withStyle:UUChartLineStyle];
    chartView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [chartView showInView:scrollView];
    
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 150-1/SCREEN_SCALE, SCREEN_WIDTH, 1/SCREEN_SCALE)];
    bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [_topView addSubview:bottomLine];
    
    [self.view bringSubviewToFront:timeLabel];
    [self.view bringSubviewToFront:menuView];
}
-(NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    NSMutableArray *dateArray=[NSMutableArray array];
    for ( BrokenLineObject *object in _transactionByDateArray)
    {
        [dateArray addObject:[[dateFormatter stringFromDate:object.dateTime]uppercaseString]];
    }
    NSArray *array=[NSArray arrayWithArray:dateArray];
    return array;
}
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSMutableArray *valueInArray=[NSMutableArray array];
    NSMutableArray *valueOutArray=[NSMutableArray array];
    for (BrokenLineObject *object in _transactionByDateArray)
    {
        [valueInArray addObject:[NSNumber numberWithFloat:object.incomeAmount]];
        [valueOutArray addObject:[NSNumber numberWithFloat:object.expenseAmount]];
    }
    NSArray *array1=[NSArray arrayWithArray:valueInArray];
    NSArray *array2=[NSArray arrayWithArray:valueOutArray];
    
    return @[array1,array2];
}
-(NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    UIColor *green=[UIColor colorWithRed:29/255.0 green:200/255.0 blue:70/255.0 alpha:1];
    UIColor *red=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    return @[green,red];
}
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}
#pragma mark - UITabelView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _transactionByDateArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    CashFlowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CashFlowTableViewCell" owner:self options:nil]lastObject];
    }
    [self configureCell:cell indexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)configureCell:(CashFlowTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    BrokenLineObject *Object = [_transactionByDateArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    cell.dateLabel.text =  [[dateFormatter stringFromDate:Object.dateTime]uppercaseString];
    
    
    float expense=Object.expenseAmount;
    float income=Object.incomeAmount;
    
    if (Object.incomeAmount>999999999)
    {
        cell.flowInLabel.text = [NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:Object.incomeAmount/1000]];
    }
    else
    {
        cell.flowInLabel.text = [appDelegate.epnc formatterString:Object.incomeAmount];
    }
    
    if (Object.expenseAmount>999999999)
    {
        cell.flowOutLabel.text = [NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:Object.expenseAmount/1000]];
    }
    else
    {
        cell.flowOutLabel.text = [appDelegate.epnc formatterString:Object.expenseAmount];
    }
    
    cell.flowInLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    cell.flowOutLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    
    //计算百分比
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    if (indexPath.row != 0)
    {
        BrokenLineObject *lastObject=[_transactionByDateArray objectAtIndex:indexPath.row-1];
        
        
        float lastOut=lastObject.expenseAmount;
        float lastIn=lastObject.incomeAmount;

        //flowOut部分
        if (lastOut == 0 || expense == 0)
        {
            cell.flowOutPercentage.text=@"-";
        }
        else if (lastOut == expense)
        {
            cell.flowOutPercentage.text=@"-";
        }
        else
        {
            float outPercent;
            if (lastOut > expense)
            {
                outPercent=(lastOut - expense)/lastOut*100;
                cell.flowOutImage.image=[UIImage imageNamed:@"cashflow_arrow_red"];
            }
            else
            {
                outPercent=(expense - lastOut)/lastOut*100;
                cell.flowOutImage.image=[UIImage imageNamed:@"cashflow_arrow_green"];
            }
            NSString *str1=[NSString stringWithFormat:@"%.1f%%",outPercent];
            NSDictionary *attributes = @{NSFontAttributeName:font};
            CGRect titleSize=[str1 boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
            CGRect frame=cell.flowOutLabel.frame;
            [cell.flowOutLabel setFrame:CGRectMake(frame.origin.x, frame.origin.y, titleSize.size.width, frame.size.height)];
            cell.flowOutPercentage.text=str1;
        }
        
        //flowIn部分
        if (lastIn == 0 || income == 0)
        {
            cell.flowInPercentage.text=@"-";
        }
        else if (lastIn == income)
        {
            cell.flowInPercentage.text=@"-";
        }
        else
        {
            float inPercent;
            if (lastIn > income)
            {
                inPercent=(lastIn - income)/lastIn*100;
                cell.flowInImage.image=[UIImage imageNamed:@"cashflow_arrow_red"];
            }
            else
            {
                inPercent=(income - inPercent)/lastIn*100;
                cell.flowInImage.image=[UIImage imageNamed:@"cashflow_arrow_green"];
            }
            NSString *str2=[NSString stringWithFormat:@"%.1f%%",inPercent];
            NSDictionary *attributes = @{NSFontAttributeName:font};
            CGRect titleSize=[str2 boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
            CGRect frame=cell.flowInLabel.frame;
            [cell.flowInLabel setFrame:CGRectMake(frame.origin.x, frame.origin.y, titleSize.size.width, frame.size.height)];
            cell.flowInPercentage.text=str2;
        }
    }
    else
    {
        cell.flowInPercentage.text=@"-";
        cell.flowOutPercentage.text=@"-";
    }
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        cell.Right.constant=133;
        cell.flowinpercentToRight.constant=133;
    }
    else if (IS_IPHONE_6)
    {
        cell.Right.constant=160;
        cell.flowinpercentToRight.constant=160;
    }
    else if (IS_IPHONE_6PLUS)
    {
        cell.Right.constant=175;
        cell.flowinpercentToRight.constant=175;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor=[UIColor whiteColor];
    
    float flowinToRight;
    if (IS_IPHONE_5 ||IS_IPHONE_4)
    {
        flowinToRight=133;
    }
    else if (IS_IPHONE_6)
    {
        flowinToRight=160;
    }
    else if (IS_IPHONE_6PLUS)
    {
        flowinToRight=175;
    }
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(14, 8, 85, 15)];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50-flowinToRight, 8, 50, 15)];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-14-64, 8, 64, 15)];
    
    label1.text=@"MONTH";
    label2.text=@"FLOW IN";
    label3.text=@"FLOW OUT";
    
    label1.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    label2.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    label3.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    
    [label1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [label2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [label3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];

    
    [header addSubview:label1];
    [header addSubview:label2];
    [header addSubview:label3];
    
    
    return header;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

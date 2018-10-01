//
//  NetWorthViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/17.
//
//

#import "NetWorthViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "NetWorthTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate_iPhone.h"
@interface NetWorthViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDate *startDate;
    NSDate *endDate;
    NSMutableArray *netWorthArray;
    NSMutableArray *differenceArray;
    
    UILabel *rightLabel;
    UIView *menuView;
    
    UILabel *timeLabel;
    
    NSInteger formerTag;
    
    NSMutableArray *timeStrArray;
    
    UITableView *tableview;
    
    UIView *backView;
}
@end

@implementation NetWorthViewController
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
    endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:startDate];

    
    [self initNav];
    [self getData];
    [self createTableView];
    [self createMenu];
    [self createChart];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    __weak UIViewController *slf = self;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecongize=NO;
        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            CGPoint location = [touch locationInView:slf.view];
            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 150, SCREEN_HEIGHT), location);
            [appDelegate.menuVC reloadView];
        }
        
        return shouldRecongize;
    }];}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appdelegate.menuVC reloadView];
}
-(void)viewWillLayoutSubviews
{
    _bottomLineHeight.constant=SCREEN_SCALE;
    _middleLineHeight.constant=SCREEN_SCALE;
}
#pragma  mark - 创建控件
-(void)createTimeLabel
{
    //距有边界距离
    float toRight;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        toRight=15;
    }
    else if (IS_IPHONE_6)
    {
        toRight=13;
    }
    else if (IS_IPHONE_6PLUS)
    {
        toRight=14;
    }
    
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-toRight-200, 5, 200, 15)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:startDate];
    NSString *endSrting = [dateFormatter stringFromDate:endDate];
    
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    timeLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [self.topView addSubview:timeLabel];
    
    
}
-(void)initNav
{
    [self.navigationController.navigationBar  doSetNavigationBar];
    self.navigationItem.title =NSLocalizedString(@"VC_NetWorth", nil);
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
    
    NSArray *array=@[NSLocalizedString(@"VC_ThisYear", nil),NSLocalizedString(@"VC_Last12Months", nil)];
    for (int i=0; i<2; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 121, 44)];
        if (i==0)
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

-(void)createChart
{
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //清除所有原有子视图
    for (UIView *subview in self.topView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    
    float labelWidth;
    float labelIntervalLeft;
    float labelIntervalRight;
    float scrollViewToleft;

    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        labelWidth=36;
        labelIntervalLeft=6;
        labelIntervalRight=6;
        scrollViewToleft=16;
    }
    else if (IS_IPHONE_6)
    {
        labelWidth=45;
        labelIntervalLeft=6;
        labelIntervalRight=6.5;
        scrollViewToleft=15;
    }
    else if (IS_IPHONE_6PLUS)
    {
        labelWidth=49;
        labelIntervalLeft=7.5;
        labelIntervalRight=7.5;
        scrollViewToleft=15;
    }
    labelWidth = labelWidth/2 - 10;
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(scrollViewToleft+30, 25, SCREEN_WIDTH-scrollViewToleft*2-30, 150-25)];
//    scrollView.contentSize=CGSizeMake((SCREEN_WIDTH-scrollViewToleft*2)*2, 150-25);
    scrollView.contentSize = CGSizeMake(SCREEN_WITH - scrollViewToleft - 44, 125);
    scrollView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.topView addSubview:scrollView];
    
    
    //中线
    UIView *middleLine=[[UIView alloc]initWithFrame:CGRectMake(0, 50-EXPENSE_SCALE, SCREEN_WITH, EXPENSE_SCALE)];
    middleLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [scrollView addSubview:middleLine];
    
    
  
    double max=0;
    for (NSNumber *value in netWorthArray)
    {
        if (fabs(value.doubleValue)>max)
        {
            max=fabs(value.doubleValue);
        }
    }

    long long maxV=(long long)max;
    if (maxV %2 ==1)
    {
        maxV++;
    }
    max=(double)maxV;
    
    if (max==0)
    {
        max=2;
    }
    
  
    UIView *vertLine=[[UIView alloc]initWithFrame:CGRectMake(scrollViewToleft+30-EXPENSE_SCALE, 25, EXPENSE_SCALE, 100)];
    vertLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.topView addSubview:vertLine];
    
    for (int i=0; i<5; i++)
    {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(scrollViewToleft+30-EXPENSE_SCALE, 25+25*i, 5, EXPENSE_SCALE)];
        line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.topView addSubview:line];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    
    
    UILabel *firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 22, 37, 13)];
    firstLabel.textAlignment=NSTextAlignmentRight;
    firstLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    firstLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    firstLabel.text=[self getAmountWith:max inLabelTag:0];
    [self.topView addSubview:firstLabel];
    
    UILabel *secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 46, 37, 13)];
    secondLabel.textAlignment=NSTextAlignmentRight;
    secondLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    secondLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    secondLabel.text=[self getAmountWith:max inLabelTag:1];
    [self.topView addSubview:secondLabel];

    UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 68, 37, 13)];
    thirdLabel.textAlignment=NSTextAlignmentRight;
    thirdLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    thirdLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    thirdLabel.text=[self getAmountWith:max inLabelTag:2];
    [self.topView addSubview:thirdLabel];

    UILabel *forthLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 92, 37, 13)];
    forthLabel.textAlignment=NSTextAlignmentRight;
    forthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    forthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    forthLabel.text=[self getAmountWith:max inLabelTag:3];
    [self.topView addSubview:forthLabel];

    UILabel *fifthLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 115, 37, 13)];
    fifthLabel.textAlignment=NSTextAlignmentRight;
    fifthLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    fifthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    fifthLabel.text=[self getAmountWith:max inLabelTag:4];
    [self.topView addSubview:fifthLabel];

    
    
    
    for (int i=0; i<12; i++)
    {
        float netWorth=[[netWorthArray objectAtIndex:11-i]floatValue];
        
        if (max!=0)
        {
            //画柱状图
            if (netWorth>=0)
            {
                double labelHeight;
                if (netWorth/max*50<3)
                {
                    labelHeight=3;
                }
                else
                {
                    labelHeight=netWorth/max*50;
                }
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake((i+1)*labelIntervalLeft+i*labelIntervalRight+i*labelWidth, 50-labelHeight, labelWidth, labelHeight)];
                view.backgroundColor=[UIColor colorWithRed:92/255.0 green:203/255.0 blue:255/255.0 alpha:1];
                [scrollView addSubview:view];
                [self setCorner:view withTag:1];
            }
            else if(netWorth<0)
            {
                double labelHeight;
                if (netWorth/max*50>-3)
                {
                    labelHeight=3;
                }
                else
                {
                    labelHeight=-netWorth/max*50;
                }
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake((i+1)*labelIntervalLeft+i*labelIntervalRight+i*labelWidth, 50, labelWidth, labelHeight)];
                view.backgroundColor=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
                [scrollView addSubview:view];
                [self setCorner:view withTag:2];
            }

        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM"];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*(labelIntervalLeft+labelWidth+labelIntervalRight), 100, labelIntervalLeft+labelWidth+labelIntervalRight, 25)];
        label.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        NSDate *monthDate=[timeStrArray objectAtIndex:11-i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        label.text=[[dateFormatter stringFromDate:monthDate]uppercaseString];
        [scrollView addSubview:label];
        
    }
    

    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 149-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
    line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.topView addSubview:line];
    
    [self createTimeLabel];
}
-(NSString *)getAmountWith:(double)max inLabelTag:(NSInteger )tag
{
    NSString *amount;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    if (max<1000)
    {
        [formatter setPositiveFormat:@"###,##0.00;"];
    }
    else
    {
        [formatter setPositiveFormat:@"###,##0.0;"];

    }
    switch (tag)
    {
        case 0:
            max=max;
            break;
        case 1:
            max=max/2;
            break;
        case 2:
            max=0;
            break;
        case 3:
            max=-max/2;
            break;
        default:
            max=-max;
            break;
    }
    if (max<1000 && max>-1000)
    {
        amount=[formatter stringFromNumber:[NSNumber numberWithFloat:max]];
    }
    else if(max<1000000 && max>-1000000)
    {
        max=max/1000;
        amount=[NSString stringWithFormat:@"%@k",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    else if(max<1000000000 && max>-1000000000)
    {
        max=max/1000000;
        amount=[NSString stringWithFormat:@"%@m",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    else
    {
        max=max/1000000000;
        amount=[NSString stringWithFormat:@"%@b",[formatter stringFromNumber:[NSNumber numberWithFloat:max]]];
    }
    return amount;
}
-(void)createTableView
{
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 149, SCREEN_WIDTH, SCREEN_HEIGHT-216) style:UITableViewStylePlain];
    tableview.showsVerticalScrollIndicator=NO;
    tableview.delegate=self;
    tableview.dataSource=self;
    
    [self.view addSubview:tableview];
}
#pragma mark - 调用方法
//设置部分圆角
-(void)setCorner:(UIView *)view withTag:(NSInteger)tag
{
    UIBezierPath *maskPath;
    switch (tag)
    {
        case 1:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3,3)];
            break;
            
        default:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3,3)];
            break;
    }
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
#pragma  mark - 响应事件

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
    [self createChart];
    //重新加载tableview
    [tableview reloadData];

    
    //修改时间段label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:startDate];
    NSString *endSrting = [dateFormatter stringFromDate:endDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
}

-(void)dateChooseShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(SCREEN_WIDTH-121-10, 5, 121, 44*2);
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
-(void)changeDatePeriodTag:(NSInteger)tag
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    if (tag==0)
    {
        startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:startDate];
    }
    else
    {
        component.year = component.year;
        component.month = component.month -11;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        startDate = [cal dateFromComponents:component];
        NSDateComponents *comp2 = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:startDate];
        [comp2 setYear:1];
        [comp2 setMonth:0];
        [comp2 setDay:0];
        [comp2 setHour:0];
        [comp2 setMinute:0];
        [comp2 setSecond:-1];
        endDate =  [cal dateByAddingComponents:comp2 toDate:startDate options:0];
    }
    
}

#pragma mark - 获取数据

-(void)getData
{
    
    netWorthArray=[NSMutableArray array];
    differenceArray=[NSMutableArray array];
    timeStrArray=[NSMutableArray array];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];
    

    NSDate *date=endDate;
    
    for (int i=12; i>0; i--)
    {
        
        float allAccountsAmount=0;
        float surplus=0;
        for (Accounts *account in tmpAccountArray)
        {
            if([date compare:account.dateTime]==1)
            {
                allAccountsAmount+=[account.amount floatValue];
                NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[account.expenseTransactions allObjects]];
                [tmpArrays addObjectsFromArray:[[NSMutableArray alloc] initWithArray:[account.incomeTransactions allObjects]]];
                for (Transaction *transaction in tmpArrays)
                {
                    if ([date compare:transaction.dateTime]==1)
                    {
                        if ([transaction.state isEqualToString:@"1"])
                        {
                            if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
                            {
                                surplus+=[transaction.amount floatValue];
                            }
                            else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
                            {
                                surplus-=[transaction.amount floatValue];
                            }
                        }
                    }
                }
            }
        }
        float netWorth=allAccountsAmount+surplus;
        [netWorthArray addObject:[NSNumber numberWithFloat:netWorth]];
        
        NSLog(@"networtharray = %@",netWorthArray);
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
        [components setMonth:[components month]-1];
        date=[gregorian dateFromComponents:components];
        
        [timeStrArray addObject:date];
    }
    
    
    [differenceArray addObject:[NSNumber numberWithFloat:0]];
    for (int i=1; i<12; i++)
    {
        [differenceArray addObject:[NSNumber numberWithFloat:([[netWorthArray objectAtIndex:11-i] floatValue]-[[netWorthArray objectAtIndex:12-i] floatValue])]];
    }
    
}
-(void)configureCell:(NetWorthTableViewCell *)cell AtIndexpath:(NSIndexPath *)indexpath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    
    NSDate *date=[timeStrArray objectAtIndex:11-indexpath.row];
    
    NSString *dateStr=[dateFormatter stringFromDate:date];
    
    cell.monthLabel.text =  [dateStr uppercaseString];

    float value=[[netWorthArray objectAtIndex:11-indexpath.row] floatValue];
    if (value<0)
    {
        cell.netWorthLabel.textColor=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    }
    
    if (value>999999999||value<-999999999)
    {
        cell.netWorthLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString: value/1000]];
    }
    else
    {
        cell.netWorthLabel.text=[appDelegate.epnc formatterString:value];
    }
    
    float dif=[[differenceArray objectAtIndex:indexpath.row] floatValue];
    if (dif>999999999)
    {
        cell.differenceLabel.text=[NSString stringWithFormat:@"+%@k",[appDelegate.epnc formatterString:dif/1000]];
    }
    else if(dif>0)
    {
        cell.differenceLabel.text=[NSString stringWithFormat:@"+%@",[appDelegate.epnc formatterString:dif]];
    }
    else if (dif<-999999999)
    {
        cell.differenceLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:dif/1000]];
    }
    else
    {
        cell.differenceLabel.text=[appDelegate.epnc formatterString:dif];
    }
    
    cell.netWorthLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    cell.differenceLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
}
#pragma mark - Tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    NetWorthTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"NetWorthTableViewCell" owner:self options:nil]lastObject];
    }
    [self configureCell:cell AtIndexpath:indexPath];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor=[UIColor whiteColor];
    
    float networthToLeft;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        networthToLeft=125;
    }
    else if (IS_IPHONE_6)
    {
        networthToLeft=151;
    }
    else if (IS_IPHONE_6PLUS)
    {
        networthToLeft=172;
    }
    
    UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(14, 8, 45, 15)];
    month.text=@"MONTH";
    month.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    month.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [header addSubview:month];
    
    UILabel *netWorth=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-networthToLeft-75, 8, 75, 15)];
    netWorth.text=@"NET WORTH";
    netWorth.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    netWorth.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [netWorth setTextAlignment:NSTextAlignmentRight];
    [header addSubview:netWorth];
    
    UILabel *dif=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-14-90, 8, 90, 15)];
    dif.text=@"DIFFERENCE";
    dif.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    dif.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [dif setTextAlignment:NSTextAlignmentRight];
    [header addSubview:dif];
    
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
    [header addSubview:bottomLine];
    
    return header;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

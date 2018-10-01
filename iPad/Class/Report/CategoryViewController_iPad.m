//
//  CategoryViewController_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import "CategoryViewController_iPad.h"
#import "CategoryTableViewCell_iPad.h"
#import "CustomDateRangeViewController.h"

@interface CategoryViewController_iPad ()<UITableViewDataSource,UITableViewDelegate,PiChartViewDelegate>
{
    double totalCategoryExpenseAmount;
    double totalCategoryIncomeAmount;
    
    
    UITableView *myTableview;
    
    UIButton *_expenseBtn;
    UIButton *_incomeBtn;
    
    PiChartView *pichart;
    
    UILabel *expenseFrontLabel;
    UILabel *incomeFrontLabel;
    UILabel *expenseBackLabel;
    UILabel *incomeBackLabel;
    
    UIView *topView;
    UILabel *timeLabel;
    
    UIView *backView;
    UIView *menuView;
    
    NSInteger formerTag;
}
@end

@implementation CategoryViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
    _endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_startDate];
   
    [self createChart];
    [self getCategoryData];
    [self createTimeLabel];
    [self createTableView];
    [self createMenu];

    formerTag = -1;
}
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

#pragma mark - 创建控件
-(void)createTableView
{
    myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 344, IPAD_WIDTH, IPAD_HEIGHT-344) style:UITableViewStylePlain];
    myTableview.delegate=self;
    myTableview.dataSource=self;
    [self.view addSubview:myTableview];
}
-(void)createTimeLabel
{
    if (timeLabel != nil)
    {
        [timeLabel removeFromSuperview];
    }
    
    //时间调节按钮
    UIButton *timeChange=[[UIButton alloc]initWithFrame:CGRectMake(IPAD_WIDTH-40, 7, 30, 30)];
    [timeChange setImage:[UIImage imageNamed:@"chart_time"] forState:UIControlStateNormal];
    [timeChange addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:timeChange];
    //距有边界距离
    float toRight=49;
    
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(IPAD_WIDTH-toRight-300, 12, 300, 20)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_startDate];
    NSString *endSrting = [dateFormatter stringFromDate:_endDate];
    
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    timeLabel.textColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [topView addSubview:timeLabel];
    
    
}
-(void)createMenu
{
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPAD_WIDTH, IPAD_HEIGHT)];
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick:)];
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    
    menuView=[[UIView alloc]initWithFrame:CGRectMake(IPAD_WIDTH-15, 44, 0, 0)];
    
    menuView.layer.cornerRadius=6;
    menuView.layer.masksToBounds=YES;
    
    NSArray *array=@[NSLocalizedString(@"VC_ThisMonth", nil),NSLocalizedString(@"VC_LastMonth", nil),NSLocalizedString(@"VC_ThisQuarter", nil),NSLocalizedString(@"VC_LastQuarter", nil),NSLocalizedString(@"VC_ThisYear", nil),NSLocalizedString(@"VC_LastYear", nil),NSLocalizedString(@"VC_CustomRange", nil)];
    for (int i=0; i<7; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 121, 44)];
        if (i!=6)
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
    topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPAD_WIDTH, 344)];
    topView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:topView];
    
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPAD_WIDTH, 44)];
    grayView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [topView addSubview:grayView];
    
    pichart=[[PiChartView alloc]initWithFrame:CGRectMake(180, 40+60, 206, 206)];
    pichart.backgroundColor = [UIColor clearColor];
    pichart.canBetouch=false;
    pichart.delegate=self;
    pichart.whiteCycleR=65;
    pichart.categoryViewController=self;
    [pichart allocArray];
    
    
    [topView addSubview:pichart];
    
    _expenseBtn=[[UIButton alloc]initWithFrame:CGRectMake(IPAD_WIDTH-160-275, 92+60, 275, 45)];
    _expenseBtn.selected=YES;
    [_expenseBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1]] forState:UIControlStateSelected];
    [_expenseBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]] forState:UIControlStateNormal];
    [_expenseBtn.layer setCornerRadius:22.5];
    _expenseBtn.layer.masksToBounds=YES;
    _expenseBtn.tag=0;
    [_expenseBtn addTarget:self action:@selector(expenseOrIncomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_expenseBtn];
    
    _incomeBtn=[[UIButton alloc]initWithFrame:CGRectMake(IPAD_WIDTH-160-275, 92+30+45+60, 275, 45)];
    _incomeBtn.selected=NO;
    [_incomeBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:56/255.0 green:217/255.0 blue:95/255.0 alpha:1]] forState:UIControlStateSelected];
    [_incomeBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1] ] forState:UIControlStateNormal];
    [_incomeBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]] forState:UIControlStateNormal];
    [_incomeBtn.layer setCornerRadius:22.5];
    _incomeBtn.layer.masksToBounds=YES;
    _incomeBtn.tag=1;
    [_incomeBtn addTarget:self action:@selector(expenseOrIncomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_incomeBtn];
    
    expenseFrontLabel=[[UILabel alloc]initWithFrame:CGRectMake(538, 104+60, 100, 20)];
    expenseFrontLabel.text=NSLocalizedString(@"VC_Expense", nil);
    expenseFrontLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [expenseFrontLabel setTextColor:[UIColor whiteColor]];
    [topView addSubview:expenseFrontLabel];
    
    expenseBackLabel=[[UILabel alloc]initWithFrame:CGRectMake(IPAD_WIDTH-150-175, 104+60, 150, 20)];
    expenseBackLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [expenseBackLabel setTextColor:[UIColor whiteColor]];
    expenseBackLabel.textAlignment=NSTextAlignmentRight;
    [topView addSubview:expenseBackLabel];
    
    incomeFrontLabel=[[UILabel alloc]initWithFrame:CGRectMake(538, 179+60, 100, 20)];
    incomeFrontLabel.text=NSLocalizedString(@"VC_Income", nil);
    incomeFrontLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [incomeFrontLabel setTextColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1]];
    [topView addSubview:incomeFrontLabel];
    
    incomeBackLabel=[[UILabel alloc]initWithFrame:CGRectMake(IPAD_WIDTH-175-150, 179+60, 150, 20)];
    incomeBackLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [incomeBackLabel setTextColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1]];
    incomeBackLabel.textAlignment=NSTextAlignmentRight;
    [topView addSubview:incomeBackLabel];
    
}
- (void)PiChartViewDelegateByIndex:(NSInteger) i;
{
    ;
}

#pragma mark - getData
-(void)getCategoryData
{
    _piViewDateArray = [[NSMutableArray alloc] init];
    _piViewDateArray_Income = [[NSMutableArray alloc]init];
    _categoryArrayList = [[NSMutableArray alloc] init];
    
    
    totalCategoryExpenseAmount = 0;
    totalCategoryIncomeAmount = 0;
    [self getCategoryExpenseData];
    [self getCategoryIncomeData];
    
    if (_expenseBtn.selected)
        [pichart setCateData:_piViewDateArray ];
    else
        [pichart setCatdataArray:_piViewDateArray_Income];
    [pichart setNeedsDisplay];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *tmpExpenseAmount = [appDelegate.epnc formatterString:totalCategoryExpenseAmount];
    NSString *tmpIncomeAmount = [appDelegate.epnc formatterString:totalCategoryIncomeAmount];
    
    expenseBackLabel.text = tmpExpenseAmount;
    incomeBackLabel.text = tmpIncomeAmount;
    
    [myTableview reloadData];
}

//获取Expense类型的数据
-(void)getCategoryExpenseData
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [_piViewDateArray removeAllObjects];
    [_categoryArrayList removeAllObjects];//_categoryArrayList存放的是每个父category的交易信息
    int colorName=0;
    PiChartViewItem *tmpPiChartViewItem;
    NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc] init];
    
    
    //获取选中时间段Expense交易
    if (![self fetchedResultsControllerExpenseCategory:YES])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    for (int i=0;i<[[_fetchedResultsController sections] count];i++)
    {
        TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:i];
        cc.categoryName = [sectionInfo name];
        
        NSString *searchForMe = @":";
        NSRange range = [cc.categoryName rangeOfString : searchForMe];
        //1.如果这是一个二级category底下的transaction,那么就需要查找到父层的category,以及父层category下的所有交易
        if (range.location != NSNotFound)
        {
            NSArray * seprateSrray = [cc.categoryName componentsSeparatedByString:@":"];
            NSString *parName = [seprateSrray objectAtIndex:0];
            NSString *childName = [seprateSrray objectAtIndex:1];
            
            //获取父类的category
            NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
            NSFetchRequest *fetchRequest=	[appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //获取父类category的数组
            NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            
            if([tmpParCategoryArray count]>0)
            {
                //获取到父层的category
                Category *pc =  [tmpParCategoryArray lastObject];
                BOOL isFound = FALSE;
                
                //判断找到的这个category是不是在已经保存的有category数组中，如果没有的话，就需要网category数组中添加这个父category的相关信息
                
                for (int j=0; j<[_categoryArrayList count]; j++)
                {
                    TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:j];
                    
                    
                    if([pc.categoryName isEqualToString:cc.categoryName])
                    {
                        [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                        if(cc.c == nil){
                            cc.c = pc;
                        }
                        
                        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                        [cc.transcationArray sortUsingDescriptors:sorts];
                        
                        
                        //计算这个sction底下的金额(一个section代表一个category)
                        isFound = TRUE;
                        double amount =0.0;
                        for (int j=0; j<[[sectionInfo objects]  count];j++)
                        {
                            Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                            amount += [entry.amount doubleValue];
                            
                        }
                        if(amount >0)
                        {
                            ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                            ccc.fullName = [sectionInfo name] ;
                            ccc.categoryName = childName;
                            ccc.amount = amount;
                            [cc.childCateArray addObject:ccc];
                        }
                        break;
                    }
                }
                
                //1.1如果没发现父层category的话,由于这是一个子类，需要创建一个父类
                if(!isFound)
                {
                    TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
                    cc.categoryName = pc.categoryName ;
                    [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                    [_categoryArrayList addObject:cc];
                    if(cc.c == nil)
                    {
                        cc.c = pc;
                    }
                    
                    double amount =0.0;
                    
                    for (int j=0; j<[[sectionInfo objects]  count];j++)
                    {
                        Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                        amount += [entry.amount doubleValue];
                        
                    }
                    if(amount >0)
                    {
                        ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                        ccc.fullName = [sectionInfo name] ;
                        ccc.categoryName = childName;
                        ccc.amount = amount;
                        [cc.childCateArray addObject:ccc];
                    }
                }
            }
        }
        
        //2.这是一个父category
        else
        {
            
            [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
            if(cc.c == nil&&[cc.transcationArray count]>0)
            {
                Transaction *transaction = [cc.transcationArray objectAtIndex:0];
                cc.c = transaction.category;
            }
            [_categoryArrayList addObject:cc];
        }
    }
    
    
    //计算总的金额 以及 创建piViewDateArray
    double categoryTotalAmount = 0;
    for (int i=0;i<[_categoryArrayList count];i++)
    {
        //每一个父category
        TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:i];
        categoryTotalAmount =0;
        if([cc.transcationArray count] > 0)
        {
            for (int j=0; j<[cc.transcationArray  count];j++)
            {
                Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:j];
                categoryTotalAmount +=[entry.amount doubleValue];
                totalCategoryExpenseAmount += [entry.amount doubleValue];
            }
            
            //这里才是建立需要显示的数组
            if(categoryTotalAmount>0)
            {
                //创建圆环需要的数据
                tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:cc.categoryName==nil? @"Not Sure":cc.categoryName color:[UIColor clearColor] data:categoryTotalAmount];
                tmpPiChartViewItem.category = cc.c;
                tmpPiChartViewItem.indexOfMemArr =i;
                [tmpPiViewDateArray addObject:tmpPiChartViewItem];
                
            }
        }
    }
    
    //将获取到的圆环数据按照percent排序
    NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    [tmpPiViewDateArray sortUsingDescriptors:sorts];
    
    
    PiChartViewItem *tmpPiItem;
    [_piViewDateArray removeAllObjects];
    for (int i = 0; i<[tmpPiViewDateArray count];i++)
    {
        tmpPiItem =[tmpPiViewDateArray objectAtIndex:i];
        [_piViewDateArray addObject:tmpPiItem];
    }
    
    
    
    
    if(totalCategoryExpenseAmount == 0)
    {
        for (int i = 0; i<[_piViewDateArray count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = 1.0/[_piViewDateArray count];
            tmpPiItem.cColor = [appDelegete.epnc getExpColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getExpImage:colorName];
            colorName ++;
            
        }
    }
    else
    {
        for (int i = 0; i<[_piViewDateArray count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = tmpPiItem.cData/totalCategoryExpenseAmount;
            tmpPiItem.cColor =[appDelegete.epnc getExpColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getExpImage:colorName];
            
            colorName ++;
            
        }
    }
}

-(void)getCategoryIncomeData
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [_piViewDateArray_Income removeAllObjects];
    [_categoryArrayList removeAllObjects];//_categoryArrayList存放的是每个父category的交易信息
    int colorName=0;
    PiChartViewItem *tmpPiChartViewItem;
    NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc] init];
    
    
    //获取选中时间段Expense交易
    if (![self fetchedResultsControllerExpenseCategory:NO])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    for (int i=0;i<[[_fetchedResultsController sections] count];i++)
    {
        TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:i];
        cc.categoryName = [sectionInfo name];
        
        
        NSString *searchForMe = @":";
        NSRange range = [cc.categoryName rangeOfString : searchForMe];
        //1.如果这是一个二级category底下的transaction,那么就需要查找到父层的category,以及父层category下的所有交易
        if (range.location != NSNotFound)
        {
            NSArray * seprateSrray = [cc.categoryName componentsSeparatedByString:@":"];
            NSString *parName = [seprateSrray objectAtIndex:0];
            NSString *childName = [seprateSrray objectAtIndex:1];
            
            //获取父类的category
            NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
            NSFetchRequest *fetchRequest=	[appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //获取父类category的数组
            NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            
            if([tmpParCategoryArray count]>0)
            {
                //获取到父层的category
                Category *pc =  [tmpParCategoryArray lastObject];
                BOOL isFound = FALSE;
                
                //判断找到的这个category是不是在已经保存的有category数组中，如果没有的话，就需要网category数组中添加这个父category的相关信息
                
                for (int j=0; j<[_categoryArrayList count]; j++)
                {
                    TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:j];
                    
                    
                    if([pc.categoryName isEqualToString:cc.categoryName])
                    {
                        [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                        if(cc.c == nil){
                            cc.c = pc;
                        }
                        
                        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                        [cc.transcationArray sortUsingDescriptors:sorts];
                        
                        
                        //计算这个sction底下的金额(一个section代表一个category)
                        isFound = TRUE;
                        double amount =0.0;
                        for (int j=0; j<[[sectionInfo objects]  count];j++)
                        {
                            Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                            amount += [entry.amount doubleValue];
                            
                        }
                        if(amount >0)
                        {
                            ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                            ccc.fullName = [sectionInfo name] ;
                            ccc.categoryName = childName;
                            ccc.amount = amount;
                            [cc.childCateArray addObject:ccc];
                        }
                        break;
                    }
                }
                
                //1.1如果没发现父层category的话,由于这是一个子类，需要创建一个父类
                if(!isFound)
                {
                    TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
                    cc.categoryName = pc.categoryName ;
                    [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                    [_categoryArrayList addObject:cc];
                    if(cc.c == nil)
                    {
                        cc.c = pc;
                    }
                    
                    double amount =0.0;
                    
                    for (int j=0; j<[[sectionInfo objects]  count];j++)
                    {
                        Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                        amount += [entry.amount doubleValue];
                        
                    }
                    if(amount >0)
                    {
                        ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                        ccc.fullName = [sectionInfo name] ;
                        ccc.categoryName = childName;
                        ccc.amount = amount;
                        [cc.childCateArray addObject:ccc];
                    }
                }
            }
        }
        
        //2.这是一个父category
        else
        {
            
            [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
            if(cc.c == nil&&[cc.transcationArray count]>0)
            {
                Transaction *transaction = [cc.transcationArray objectAtIndex:0];
                cc.c = transaction.category;
            }
            [_categoryArrayList addObject:cc];
        }
    }
    
    
    //计算总的金额 以及 创建piViewDateArray
    double categoryTotalAmount=0;
    for (int i=0;i<[_categoryArrayList count];i++)
    {
        //每一个父category
        TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:i];
        categoryTotalAmount =0;
        if([cc.transcationArray count] > 0)
        {
            for (int j=0; j<[cc.transcationArray  count];j++)
            {
                Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:j];
                categoryTotalAmount +=[entry.amount doubleValue];
                totalCategoryIncomeAmount += [entry.amount doubleValue];
            }
            
            //这里才是建立需要显示的数组
            if(categoryTotalAmount>0)
            {
                //创建圆环需要的数据
                tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:cc.categoryName==nil? @"Not Sure":cc.categoryName color:[UIColor clearColor] data:categoryTotalAmount];
                tmpPiChartViewItem.category = cc.c;
                tmpPiChartViewItem.indexOfMemArr =i;
                [tmpPiViewDateArray addObject:tmpPiChartViewItem];
                
            }
        }
    }
    
    //将获取到的圆环数据按照percent排序
    NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    [tmpPiViewDateArray sortUsingDescriptors:sorts];
    
    
    PiChartViewItem *tmpPiItem;
    [_piViewDateArray_Income removeAllObjects];
    for (int i = 0; i<[tmpPiViewDateArray count];i++)
    {
        tmpPiItem =[tmpPiViewDateArray objectAtIndex:i];
        [_piViewDateArray_Income addObject:tmpPiItem];
    }
    
    
    
    
    if(totalCategoryIncomeAmount == 0)
    {
        for (int i = 0; i<[_piViewDateArray_Income count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray_Income objectAtIndex:i];
            tmpPiItem.cPercent = 1.0/[_piViewDateArray_Income count];
            tmpPiItem.cColor = [appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getIncImage:colorName];
            colorName ++;
            
        }
    }
    else
    {
        for (int i = 0; i<[_piViewDateArray_Income count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray_Income objectAtIndex:i];
            tmpPiItem.cPercent = tmpPiItem.cData/totalCategoryIncomeAmount;
            tmpPiItem.cColor =[appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getIncImage:colorName];
            colorName ++;
        }
    }
    
        [pichart setCateData:_piViewDateArray_Income ];
        [pichart setNeedsDisplay];
}
#pragma mark Fetched results controller
//------------------------获取起始时间下的交易数组，按照category分类
- (NSFetchedResultsController *)fetchedResultsControllerExpenseCategory:(BOOL)isExpenseCategory{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError * error=nil;
    NSDictionary *subs;
    if (isExpenseCategory)
    {
        subs = [NSDictionary dictionaryWithObjectsAndKeys:_startDate,@"startDate",_endDate,@"endDate",@"EXPENSE",@"TYPE", nil];
    }
    else
        subs = [NSDictionary dictionaryWithObjectsAndKeys:_startDate,@"startDate",_endDate,@"endDate",@"INCOME",@"TYPE", nil];
    
    NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDateandCategoryType" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController* fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:appDelegete.managedObjectContext
                                                                                       sectionNameKeyPath:@"category.categoryName"
                                                                                                cacheName:@"Root"];
    self.fetchedResultsController = fetchedResults;
    [fetchedResults performFetch:&error];
    
    return _fetchedResultsController;
}
#pragma mark - 响应方法
-(void)refreshView
{
    [self getCategoryData];
    [self dateChooseHide];

    [myTableview reloadData];
    [self createTimeLabel];
}
-(void)expenseOrIncomeBtnPressed:(UIButton *)sender
{
    if (sender.tag==0 && _incomeBtn.selected==YES)
    {
        _incomeBtn.selected=_expenseBtn.selected;
        _expenseBtn.selected=!_expenseBtn.selected;
        expenseFrontLabel.textColor=[UIColor whiteColor];
        expenseBackLabel.textColor=[UIColor whiteColor];
        incomeBackLabel.textColor=[UIColor colorWithRed: 149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
        incomeFrontLabel.textColor=[UIColor colorWithRed: 149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
    }
    else if(sender.tag==1 && _expenseBtn.selected==YES)
    {
        _expenseBtn.selected=_incomeBtn.selected;
        _incomeBtn.selected=!_incomeBtn.selected;
        incomeFrontLabel.textColor=[UIColor whiteColor];
        incomeBackLabel.textColor=[UIColor whiteColor];
        expenseFrontLabel.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
        expenseBackLabel.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
    }
    [self getCategoryData];
}
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
    if (formerTag==btn.tag && (formerTag !=6 && btn.tag !=6))
    {
        [self dateChooseHide];
        return;
    }
    
    formerTag=btn.tag;
    
    //修改时间段
    [self changeDatePeriodTag:btn.tag];
    if (btn.tag != 6) {
        [self dateChooseHide];
    }
    //重新获取数据
    [self getCategoryData];
    //重新加载tableview
    [myTableview reloadData];
    
    
    //修改时间段label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_startDate];
    NSString *endSrting = [dateFormatter stringFromDate:_endDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
}

-(void)dateChooseShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(IPAD_WIDTH-121-15, 44, 121, 44*7);
    [UIView commitAnimations];
    backView.alpha=0.1;
}
-(void)dateChooseHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(IPAD_WIDTH-15, 44, 0, 0);
    [UIView commitAnimations];
    backView.alpha=0;
}
-(void)changeDatePeriodTag:(NSInteger)tag
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *startcomponent = [[NSDateComponents alloc] init] ;
    NSDateComponents *endcomponent = [[NSDateComponents alloc] init] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    if (tag==0)
    {
        _startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
        _endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_startDate];
    }
    else if (tag==1)
    {
        [startcomponent setMonth:-1];
        [endcomponent setMonth:1];
        [endcomponent setDay:-1];
        NSDate *tmpStartDate = [cal dateByAddingComponents:startcomponent toDate:[NSDate date] options:0];
        _startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:tmpStartDate];
        _endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_startDate];
        
    }
    else if (tag==2)
    {
        if (component.month==1 || component.month==2 || component.month==3) {
            [component setMonth:1];
        }
        else if (component.month==4 || component.month==5 || component.month==6)
        {
            [component setMonth:4];
        }
        else if (component.month==7 || component.month==8 || component.month==9)
        {
            [component setMonth:7];
        }
        else
        {
            [component setMonth:10];
        }
        [component setDay:1];
        [component setHour:0];
        [component setMinute:0];
        [component setSecond:1];
        
        
        _startDate = [cal dateFromComponents:component];
        NSDateComponents *comp = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:_startDate];
        comp.year = comp.year;
        comp.month = comp.month + 3;
        comp.day = 0;
        comp.hour = 23;
        comp.minute = 59;
        comp.second = 59;
        _endDate = [cal dateFromComponents:comp];
    }
    else if (tag==3)
    {
        _startDate =[appDelegate.epnc getStartDate:@"Last Quarter"];
        _endDate = [appDelegate.epnc getEndDate:_startDate withDateString:@"Last Quarter"];
    }
    else if (tag==4)
    {
        _startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_startDate];
    }
    else if (tag==5)
    {
        component.year = component.year-1;
        component.month = 1;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _startDate = [cal dateFromComponents:component];
        _endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_startDate];
        
        
        
    }
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.pvt = dateRangePopup;
        CustomDateRangeViewController *customDateRangeViewController =[[CustomDateRangeViewController alloc] initWithNibName:@"CustomDateRangeViewController" bundle:nil];
        customDateRangeViewController.moduleString = @"ACCOUNT";
        customDateRangeViewController.categoryViewController = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customDateRangeViewController];
        appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
        appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,360.0);
        
//        appDelegate.AddPopoverController.delegate = self;
        [appDelegate.AddPopoverController presentPopoverFromRect:menuView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
}

#pragma mark - TableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_expenseBtn.selected)
    {
        return [_piViewDateArray count];
    }
    else
    {
        return [_piViewDateArray_Income count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    CategoryTableViewCell_iPad *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CategoryTableViewCell_iPad" owner:self options:nil]lastObject];
    }
    [self configureCategoryCell:cell atIndexPath:indexPath];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)configureCategoryCell:(CategoryTableViewCell_iPad *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    // Configure the cell
    PiChartViewItem *tmpPiItem;
    if (_expenseBtn.selected)
    {
        tmpPiItem= [_piViewDateArray objectAtIndex:indexPath.row];
    }
    else
        tmpPiItem= [_piViewDateArray_Income objectAtIndex:indexPath.row];
    //percent
    cell.percentLabel.text = [[NSString stringWithFormat: @"%.2f",tmpPiItem.cPercent*100] stringByAppendingString:@"%"];
    //category
    cell.nameLabel.text = tmpPiItem.cName;
    cell.colorView.backgroundColor = [UIColor colorWithPatternImage:tmpPiItem.cImage];
    [cell.colorView.layer setCornerRadius:7];
    cell.colorView.layer.masksToBounds=YES;
    
    cell.amountLabel.text = [appDelegate.epnc formatterString:tmpPiItem.cData];

    
    if (indexPath.row % 2==0)
    {
        cell.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }
    else
    {
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    if (indexPath.row!=_piViewDateArray.count-1)
    {
        [cell.bottomLine removeFromSuperview];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 95+424+424, 44)];
    header.backgroundColor=[UIColor whiteColor];
    
    float networthToLeft;
    networthToLeft=260;
    
    UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 224, 44)];
    month.text=@"CATEGORY";
    month.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    month.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    month.textAlignment=NSTextAlignmentCenter;
    [header addSubview:month];
    
    UILabel *netWorth=[[UILabel alloc]initWithFrame:CGRectMake(224, 0, 337, 44)];
    netWorth.text=@"PERCENT";
    netWorth.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    netWorth.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [netWorth setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:netWorth];
    
    UILabel *dif=[[UILabel alloc]initWithFrame:CGRectMake(224+337, 0, IPAD_WIDTH-224-337, 44)];
    dif.text=@"AMOUNT";
    dif.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    dif.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [dif setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:dif];
    
    return header;
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

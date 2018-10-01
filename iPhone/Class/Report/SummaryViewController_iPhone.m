//
//  SummaryViewController_iPhone.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/9.
//
//



#import "SummaryViewController_iPhone.h"

#import "PokcetExpenseAppDelegate.h"
#import "summaryTableviewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate_iPhone.h"
#import "EP_BillRule.h"
#import "Transaction.h"
#import "EP_BillItem.h"
#import "Payee.h"
@interface SummaryViewController_iPhone ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL hasBudget;
    BOOL hasUncleared;
    BOOL hasBills;
    
    UITableView *myTableView;
    
    NSMutableArray *accountArray;
    NSMutableArray *accountNameArray;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *billDataArray;
    NSMutableArray *billRuleArray;
    NSMutableArray *billItemArray;
    
    
    float billTotalAmount;
    float billUnpaid;
    float billPastdue;
    float billPaid;
    
    //循环Bill未支付金额
    float recurringBillTotalPast;
    float recurringBillTotal;
    
    NSMutableArray *transactionArray;
    NSMutableArray *unclearedNameArray;
    NSMutableArray *unclearedAmountArray;
    NSMutableDictionary *accountDic;
    
    UIView *menuView;
    UILabel *rightLabel;
    NSInteger formerTag;
    
    UILabel *timeLabel;
    
    UIView *backView;
    
    NSString *topLeftName;
    NSString *topSpendName;
}
@end

@implementation SummaryViewController_iPhone
#pragma mark - 方法
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    [self createTimeLabel];
    
    [self getData];
    
    
    [self createTableView];
    [self initNav];
    [self createMenu];
    
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
    
    NSArray *array=@[NSLocalizedString(@"VC_ThisMonth", nil),NSLocalizedString(@"VC_LastMonth", nil),NSLocalizedString(@"VC_ThisYear", nil),NSLocalizedString(@"VC_LastYear", nil)];
    for (int i=0; i<4; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*44, 121, 44)];
        if (i!=3)
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
    self.navigationItem.title =NSLocalizedString(@"VC_Summary", nil);
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
//    UIButton *tmpsetupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tmpsetupBtn.frame = CGRectMake(0, 0, 90, 44);
//    [tmpsetupBtn setImage:[UIImage imageNamed:@"chart_time"] forState:UIControlStateNormal];
//    [tmpsetupBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [tmpsetupBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:tmpsetupBtn];
//    self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];
    
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
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, SCREEN_HEIGHT-64-24) style:UITableViewStyleGrouped];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.showsVerticalScrollIndicator=NO;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor=[UIColor colorWithRed: 248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:myTableView];
    
}
-(void)createTimeLabel
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
    _endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_startDate];
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-200, 5, 200, 15)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_startDate];
    NSString *endSrting = [dateFormatter stringFromDate:_endDate];
    
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    timeLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:timeLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 24-1/SCREEN_SCALE, SCREEN_WIDTH, 1/SCREEN_SCALE)];
    line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.view addSubview:line];
    
}

#pragma mark - Menu Btn
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
-(void)dateChooseShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    menuView.frame=CGRectMake(SCREEN_WIDTH-121-10, 5, 121, 44*4);
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
    

    
    //修改时间段label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *startString = [dateFormatter stringFromDate:_startDate];
    NSString *endSrting = [dateFormatter stringFromDate:_endDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
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
    else if(tag==2)
    {
        _startDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _endDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_startDate];
    }
    else
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
}

#pragma mark - 获取数据
-(void)getData
{
    dataArray=[[NSMutableArray alloc]init];
    
    [self getGeneralData];
    [self getAccountData];
    [self getBudgetData];
    [self getBillData];
    [self getUnclearedData];
}
#pragma mark - getGeneralData
-(void)getGeneralData
{
    //初始化数据
    float expense=0;
    float income=0;
    float uncleared=0;
    float cleared=0;
    float netWorth=0;
    
    //获取transaction数据
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    request.entity=desc;
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *tmpArray=[appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    transactionArray=[NSMutableArray arrayWithArray:tmpArray];

    //获取account数据
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicateAccount =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicateAccount];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor2,nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *tmpAccounArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    accountArray=[NSMutableArray arrayWithArray:tmpAccounArray];
    
    //分析transaction数据
    for (Transaction *transaction in transactionArray)
    {
        
        if ([transaction.dateTime compare:_startDate]>=0 && [transaction.dateTime compare:_endDate]<=0)
        {
            if ([transaction.isClear boolValue])
            {
                if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
                {
                    income+=[transaction.amount floatValue];
                    cleared+=[transaction.amount floatValue];
                }
                else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
                {
                    expense-=[transaction.amount floatValue];
                    cleared-=[transaction.amount floatValue];
                }
            }
            else
            {
                if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
                {
                    uncleared+=[transaction.amount floatValue];
                }
                else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
                {
                    uncleared-=[transaction.amount floatValue];
                }
            }

        }
    }
    
    float accountAmount=0;
    
    for (Accounts *accounts in accountArray)
    {
        accountAmount+=[accounts.amount floatValue];
    }
    netWorth=accountAmount+cleared+uncleared;
    //先创建由NSNumber组成的第一个section数组，再添加进dataArray
    NSArray *firstSectionArray=[NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:expense],
                                [NSNumber numberWithFloat:income],
                                [NSNumber numberWithFloat:uncleared],
                                [NSNumber numberWithFloat:cleared],
                                [NSNumber numberWithFloat:netWorth],nil];
    [dataArray addObject:firstSectionArray];
}
#pragma mark - getAccountData
-(void)getAccountData
{
//    NSMutableArray *secondSectionArray=[NSMutableArray array];
//    accountNameArray=[NSMutableArray array];
//    for (Accounts *account in accountArray)
//    {
//        float value=[account.amount floatValue];
//        NSString *accountName=account.accName;
//        [secondSectionArray addObject:[NSNumber numberWithFloat:value]];
//        [accountNameArray addObject:accountName];
//    }
//    [dataArray addObject:secondSectionArray];
//    
//    for (Accounts *account in accountArray)
//    {
//        float accountAmount;
//        for (int i=0; i<accountNameArray.count; i++)
//        {
//            if ([account.accountType.typeName isEqualToString:[accountNameArray objectAtIndex:i]])
//            {
//                float num=[[secondSectionArray objectAtIndex:i] floatValue];
//                accountAmount = [self accountAnalysis:account];
//                num+=accountAmount;
//                
//            }
//        }
//    }
    accountDic=[NSMutableDictionary dictionary];
    for (Accounts *account in accountArray)
    {
        NSString *thisAccType=account.accountType.typeName;
        NSArray *keys=[accountDic allKeys];
        
        float surplusAmount=[self accountAnalysis:account];
        
        int i;
        for ( i=0; i<keys.count; i++)
        {
            NSString *accType=[keys objectAtIndex:i];
            if ([accType isEqualToString:thisAccType])
            {
                float formerValue=[[accountDic objectForKey:accType] floatValue];
                formerValue+=surplusAmount;
                
                NSNumber *value=[NSNumber numberWithFloat:formerValue];
                
                [accountDic setObject:value forKey:accType];
                break;
            }
        }
        if (i==keys.count)
        {
            NSNumber *value=[NSNumber numberWithFloat:surplusAmount];
            [accountDic setObject:value forKey:thisAccType];
        }
    }
    [dataArray addObject:[accountDic allValues]];
    
}
-(float )accountAnalysis:(Accounts *)account
{
    NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[account.expenseTransactions allObjects]];
    float amount=[account.amount floatValue];
    for (int j=0; j<[tmpArrays count];j++)
    {
        Transaction *transactions = (Transaction *)[tmpArrays objectAtIndex:j];
        if ([transactions.dateTime compare:_startDate]<0 || [transactions.dateTime compare:_endDate]>0)
        {
            continue;
        }
        
        if ([transactions.state isEqualToString:@"0"])
        {
            continue;
        }
        
        if (transactions.parTransaction != nil)
        {
            continue;
        }
        amount -= [transactions.amount doubleValue];
        
    }
    
    NSMutableArray *tmpArrays1 = [[NSMutableArray alloc] initWithArray:[account.incomeTransactions allObjects]];
    
    for (int j=0; j<[tmpArrays1 count];j++)
    {
        Transaction *transactions = (Transaction *)[tmpArrays1 objectAtIndex:j];
        if ([transactions.dateTime compare:_startDate]<0 && [transactions.dateTime compare:_endDate]>0)
        {
            continue;
        }
        
        if ([transactions.state isEqualToString:@"0"])
        {
            continue;
        }
        if (transactions.parTransaction != nil)
        {
            continue;
        }
        

        amount+=[transactions.amount doubleValue];
        
        
    }
    
    return amount;
}
#pragma mark - getBudgetData
-(void)getBudgetData
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];
    
    //判定是否存在Budget
    if (allBudgetArray.count==0)
    {
        hasBudget=NO;
        return;
    }
    hasBudget=YES;
    
    float totalBudgetAmount=0;
    float totalExpense=0;
    float totalLeft=0;
    float topLeft=0;
    float topSpend=0;
    
    topLeftName=[NSString string];
    topSpendName=[NSString string];
    
    NSDictionary *subs;
    for (int i = 0; i<[allBudgetArray count];i++)
    {
        
        float expense=0;
        float left=0;
        BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        
        BudgetItem *budgetTemplateCurrentItem =[[budgetTemplate.budgetItems allObjects] lastObject];
        
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
            
            
            //获取该budgetTemplate下 该段时间内的transaction,统计
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"] && [t.state isEqualToString:@"1"])
                {
                    expense +=[t.amount doubleValue];
                }
            }
            
            //获取该budgetTemplate下 该段时间内的transfer,统计
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
            for (int j = 0;j<[tmpArray1 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.endDate]<=0 && [bttmp.state isEqualToString:@"1"])
                {
                    expense +=[bttmp.amount doubleValue];
                }
                
            }
            
            
            
            ////////////////////获取子类category的交易
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound)
            {
                
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                expense +=[t.amount doubleValue];
                            }
                            
                        }
                        
                    }
                }
            }
        }
        //当前budget的剩余预算
        left=[budgetTemplate.amount floatValue] - expense;
        
        if (expense>=topSpend)
        {
            topSpend=expense;
            topSpendName=budgetTemplate.category.categoryName;
        }
        if (left>=topLeft)
        {
            topLeft=left;
            topLeftName=budgetTemplate.category.categoryName;
        }
        
        totalBudgetAmount +=[budgetTemplate.amount floatValue];
        totalExpense+=expense;
        totalLeft=totalBudgetAmount-totalExpense;
    }
    NSMutableArray *thirdSectionArray=[NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:totalBudgetAmount],
                                       [NSNumber numberWithFloat:totalExpense],
                                       [NSNumber numberWithFloat:totalLeft],
                                       [NSNumber numberWithFloat:topSpend],
                                       [NSNumber numberWithFloat:topLeft],nil];
    [dataArray addObject:thirdSectionArray];
}
#pragma mark - getBillData
-(void)getBillData
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSError *error;
    
    billRuleArray=[NSMutableArray array];
    billItemArray=[NSMutableArray array];
    
    billTotalAmount=0;
    billUnpaid=0;
    billPaid=0;
    billPastdue=0;
    recurringBillTotal=0;
    recurringBillTotalPast=0;
    
    //1.查询bill1中所有的bill
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch setPredicate:predicate];
    NSArray *bill1tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    [billRuleArray setArray:bill1tempArray];
    
    //2.查询bill2中所有数据
    NSFetchRequest *fetch2 = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch2 setEntity:entity2];
    NSPredicate * predicate2 =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch2 setPredicate:predicate2];
    NSArray *bill2tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch2 error:&error]];
    [billItemArray setArray:bill2tempArray];
    
    if (billRuleArray.count==0 && billItemArray.count==0 )
    {
        hasBills=NO;
        return;
    }
    hasBills=YES;
    
    [self useTemlateCreateBill];
    [self useBill2createRealAllArray];
    
}
-(void)useTemlateCreateBill
{
    for (int i=0; i<[billRuleArray count]; i++)
    {
        EP_BillRule *oneBill = [billRuleArray objectAtIndex:i];
        [self setBillFatherByBill:oneBill];
    }
}
-(void)setBillFatherByBill:(EP_BillRule *)bill
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"] )
    {
        double paymentAmount = 0.00;
        
        
        if ([appDelegate_iphone.epnc dateCompare:bill.ep_billDueDate withDate:_endDate]<=0 &&
            [appDelegate_iphone.epnc dateCompare:bill.ep_billDueDate withDate:_startDate]>=0)
        {
            //选择出在时间段内的bill
            
            
            billTotalAmount+=[bill.ep_billAmount floatValue];
            
            NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[bill.billRuleHasTransaction allObjects]];
            for (int n=0; n<[paymentarray count]; n++)
            {
                Transaction *onepayment = [paymentarray objectAtIndex:n];
                if ([onepayment.state isEqualToString:@"1"])
                {
                    paymentAmount = paymentAmount +[onepayment.amount doubleValue];
                    
                    //已支付金额 累加
                    billPaid+=[onepayment.amount floatValue];
                }
            }
            
            //支付的金额小于bill值
            if (paymentAmount<[bill.ep_billAmount doubleValue])
            {
                //未支付的部分 算进 unPaid中
                billUnpaid+=[bill.ep_billAmount floatValue]-paymentAmount;
                
                //如果应当支付日期在当前时间之前 算进 pastDue中
                if ([appDelegate_iphone.epnc dateCompare:bill.ep_billDueDate withDate:[NSDate date]]<0)
                {
                    billPastdue+=[bill.ep_billAmount floatValue]-paymentAmount;
                }
                
            }
        }
        
        return;
    }
    //如果是循环账单
    else
    {
        //如果账单开始的时间在 endDate 之后，过掉
        if ([appDelegate_iphone.epnc  dateCompare:bill.ep_billDueDate withDate:_endDate] == 1)
        {
            return;
        }
        
        //lastDate指代 循环分析 中的账单时间
        NSDate *lastDate = bill.ep_billDueDate ;
        
        //分析 账单 结束时间
        NSDate *endDateorBillEndDate = [appDelegate_iphone.epnc dateCompare:_endDate withDate:bill.ep_billEndDate]<0?_endDate : bill.ep_billEndDate;
        
        if ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]>0)
        {
            return;
        }
        else
        {
            //循环分析账单
            
            //账单时间要处在结束时间和起始时间之间
            while ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0
                   && [appDelegate_iphone.epnc dateCompare:lastDate withDate:_startDate]>=0)
            {
                
                billTotalAmount+=[bill.ep_billAmount floatValue];
                
                recurringBillTotal+=[bill.ep_billAmount floatValue];
                if ([appDelegate_iphone.epnc dateCompare:lastDate withDate:[NSDate date]]<0)
                {
                    recurringBillTotalPast+=[bill.ep_billAmount floatValue];
                }
                
                //获取下一次循环的时间
                lastDate= [appDelegate_iphone.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }

}
-(void)useBill2createRealAllArray
{
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    for (int i=0; i<[billItemArray count]; i++)
    {
        EP_BillItem *billObject = [billItemArray objectAtIndex:i];
        
        //在endDate之后,startDate之前的去掉
        if ([appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:_startDate]==1 && [appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:_endDate]<0)
            continue;
        else
        {
            
            //如果被删除了，就从all中删除这个数据
            if ([billObject.ep_billisDelete boolValue])
            {
                
            }
            else
            {
                double paymentAmount = 0.00;
                NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[billObject.billItemHasTransaction allObjects]];
                for (int n=0; n<[paymentarray count]; n++)
                {
                    Transaction *onepayment = [paymentarray objectAtIndex:n];
                    if ([onepayment.state isEqualToString:@"1"])
                    {
                        paymentAmount = paymentAmount +[onepayment.amount doubleValue];
                        billPaid+=[onepayment.amount floatValue];
                    }
                }
                
                if (paymentAmount < [billObject.ep_billItemAmount doubleValue])
                {
                    //去除已经支付的部分
                    recurringBillTotal -= paymentAmount;
                    
                    
                    if([appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:[NSDate date]]<0)
                    {
                        recurringBillTotalPast -= paymentAmount;
                    }
                 }
                else
                {
                    recurringBillTotal -= [billObject.ep_billItemAmount floatValue];
                    if ([appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:[NSDate date]]<0)
                    {
                        recurringBillTotalPast -= [billObject.ep_billItemAmount floatValue];
                    }
                }
            }
            
        }
        
    }
    
    billPastdue=billPastdue+recurringBillTotalPast;
    billUnpaid=billUnpaid+recurringBillTotal;
    
    billDataArray=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:billTotalAmount],[NSNumber numberWithFloat:billPastdue],[NSNumber numberWithFloat:billPaid],[NSNumber numberWithFloat: billUnpaid], nil];
    
    [dataArray addObject:billDataArray];
}
#pragma mark - getUnclearedData
-(void)getUnclearedData
{
    unclearedAmountArray=[NSMutableArray array];
    unclearedNameArray=[NSMutableArray array];
    
    for (Transaction *tran in transactionArray)
    {
        if (tran.parTransaction==nil)
        {
            if (![tran.isClear boolValue])
            {
                if ([tran.dateTime compare:_endDate]<=0 && [tran.dateTime compare:_startDate]>=0)
                {
                    //transfer数据
                    if (tran.incomeAccount!=nil && tran.expenseAccount!=nil)
                    {
                        NSString *transName=[NSString stringWithFormat:@"%@ > %@",tran.expenseAccount.accName,tran.incomeAccount.accName];
                        [unclearedNameArray addObject:transName];
                        
                        NSNumber *amount=tran.amount;
                        [unclearedAmountArray addObject:amount];
                    }
                    else if(tran.incomeAccount !=nil ||tran.expenseAccount!=nil)
                    {
                        NSString *transName=tran.payee.name;
                        if (transName!=nil)
                        {
                            [unclearedNameArray addObject:transName];
                        }
                        
                    }
                    if (tran.incomeAccount !=nil && tran.expenseAccount==nil)
                    {
                        NSNumber *amount=tran.amount;
                        [unclearedAmountArray addObject:amount];
                    }
                    if (tran.incomeAccount ==nil && tran.expenseAccount !=nil)
                    {
                        float value=-[tran.amount floatValue];
                        NSNumber *amount=[NSNumber numberWithFloat:value];
                        [unclearedAmountArray addObject:amount];
                    }
                }
            }
        }
        
    }
    
    if (unclearedAmountArray.count==0)
    {
        hasUncleared=NO;
        return;
    }
    hasUncleared=YES;
    
    [dataArray addObject:unclearedAmountArray];
}

#pragma mark - UITableView方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40-SCREEN_SCALE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREEN_SCALE;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num;
    if (section==0)
    {
        num=5;
    }
    if (section==1)
    {
        num=accountDic.count;
    }
    if (section==2)
    {
        if (hasBudget)
        {
            num=5;
        }
        else if(hasBills)
        {
            num=4;
        }
        else if(hasUncleared)
        {
            num=unclearedNameArray.count;
        }
    }
    if (section==3)
    {
        if (hasBudget)
        {
            if (hasBills)
            {
                num=4;
            }
            else if (hasUncleared)
            {
                num=unclearedNameArray.count;
            }
        }
        else
        {
            if (hasBills && hasUncleared)
            {
                num=unclearedNameArray.count;
            }
        }
    }
    if (section==4)
    {
        if (hasUncleared && hasBudget && hasBills)
        {
            num=unclearedNameArray.count;
        }
    }
    return num;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num=5;
    if (!hasUncleared)
    {
        num--;
    }
    if (!hasBudget)
    {
        num--;
    }
    if (!hasBills)
    {
        num--;
    }
    return num;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    summaryTableviewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"summaryTableviewCell" owner:self options:nil]lastObject];
    }
    [self configureSummaryCell:cell atIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *headerArray1=@[NSLocalizedString(@"VC_GENERAL", nil),
                            NSLocalizedString(@"VC_ACCOUNTS", nil),
                            NSLocalizedString(@"VC_BUDGET", nil),
                            NSLocalizedString(@"VC_BILLS", nil),
                            NSLocalizedString(@"VC_UNCLEARED", nil)];
    NSArray *headerArray2=@[NSLocalizedString(@"VC_GENERAL", nil),
                            NSLocalizedString(@"VC_ACCOUNTS", nil),
                            NSLocalizedString(@"VC_BILLS", nil),
                            NSLocalizedString(@"VC_UNCLEARED", nil)];
    NSArray *headerArray3=@[NSLocalizedString(@"VC_GENERAL", nil),
                            NSLocalizedString(@"VC_ACCOUNTS", nil),
                            NSLocalizedString(@"VC_BUDGET", nil),
                            NSLocalizedString(@"VC_UNCLEARED", nil)];
    NSArray *headerArray4=@[NSLocalizedString(@"VC_GENERAL", nil),
                            NSLocalizedString(@"VC_ACCOUNTS", nil),
                            NSLocalizedString(@"VC_UNCLEARED", nil)];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40-SCREEN_SCALE)];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 20)];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    headerLabel.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    
    if (hasBudget)
    {
        if (hasBills)
        {
            if (hasUncleared)
            {
                headerLabel.text=[headerArray1 objectAtIndex:section];
            }
            else
            {
                headerLabel.text=[headerArray1 objectAtIndex:section];
            }
        }
        else
        {
            if (hasUncleared)
            {
                headerLabel.text=[headerArray3 objectAtIndex:section];
            }
            else
            {
                headerLabel.text=[headerArray1 objectAtIndex:section];
            }
        }
    }
    else
    {
        if (hasBills)
        {
            if (hasUncleared)
            {
                headerLabel.text=[headerArray2 objectAtIndex:section];
            }
            else
            {
                headerLabel.text=[headerArray2 objectAtIndex:section];
            }
        }
        else
        {
            if (hasUncleared)
            {
                headerLabel.text=[headerArray4 objectAtIndex:section];
            }
            else
            {
                headerLabel.text=[headerArray1 objectAtIndex:section];
            }
        }
    }
    
    [headerView addSubview:headerLabel];
    
    headerView.backgroundColor=[UIColor whiteColor];
    
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 40-2*SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [headerView addSubview:bottomLine];
    
    
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footer.backgroundColor=[UIColor whiteColor];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    
    return line;
    
}
#pragma mark - 填充 cell 数据
- (void)configureSummaryCell:(summaryTableviewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    NSArray *cellTitle1=@[
  @[NSLocalizedString(@"VC_Expense", nil),NSLocalizedString(@"VC_Income", nil),NSLocalizedString(@"VC_Uncleared", nil),NSLocalizedString(@"VC_Cleared", nil),NSLocalizedString(@"VC_NetWorth", nil)],
  [accountDic allKeys],
  @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Spent", nil),NSLocalizedString(@"VC_Left", nil),NSLocalizedString(@"VC_Top Spent", nil),NSLocalizedString(@"VC_Top Left", nil)],
  @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Overdue", nil),NSLocalizedString(@"VC_Paid", nil),NSLocalizedString(@"VC_Unpaid", nil)],
  unclearedNameArray];
    NSArray *cellTitle2=@[
                          @[NSLocalizedString(@"VC_Expense", nil),NSLocalizedString(@"VC_Income", nil),NSLocalizedString(@"VC_Uncleared", nil),NSLocalizedString(@"VC_Cleared", nil),NSLocalizedString(@"VC_NetWorth", nil)],
                          [accountDic allKeys],
                          @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Spent", nil),NSLocalizedString(@"VC_Left", nil),NSLocalizedString(@"VC_Top Spent", nil),NSLocalizedString(@"VC_Top Left", nil)],
                          unclearedNameArray];
    NSArray *cellTitle3=@[
                          @[NSLocalizedString(@"VC_Expense", nil),NSLocalizedString(@"VC_Income", nil),NSLocalizedString(@"VC_Uncleared", nil),NSLocalizedString(@"VC_Cleared", nil),NSLocalizedString(@"VC_NetWorth", nil)],
                          [accountDic allKeys],
                          @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Overdue", nil),NSLocalizedString(@"VC_Paid", nil),NSLocalizedString(@"VC_Unpaid", nil)],
                          unclearedNameArray];
    NSArray *cellTitle4=@[
                          @[NSLocalizedString(@"VC_Expense", nil),NSLocalizedString(@"VC_Income", nil),NSLocalizedString(@"VC_Uncleared", nil),NSLocalizedString(@"VC_Cleared", nil),NSLocalizedString(@"VC_NetWorth", nil)],
                          [accountDic allKeys],
                          unclearedNameArray];
    
    
    

    UIColor *red=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    UIColor *green=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
    UIColor *gray=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    
    NSNumber *number=[[dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    float value=[number floatValue];
    
    NSString *amountText=[NSString string];
    
    if (value>=0)
    {
        amountText=[appDelegate_iPhone.epnc formatterString: value];
        cell.amount.textColor=gray;
    }
    else
    {
        amountText=[appDelegate_iPhone.epnc formatterString: value];
        cell.amount.textColor=red;
    }
    
    if (indexPath.section == 0 &&indexPath.row == 1)
    {
        cell.amount.textColor=green;
    }
    
    if (indexPath.section==2 && indexPath.row == 2)
    {
        if (value>=0)
        {
            cell.title.text=NSLocalizedString(@"VC_Left_Sum",nil);
            amountText=[appDelegate_iPhone.epnc formatterString:value];
        }
        else
        {
            cell.title.text=NSLocalizedString(@"VC_Over", nil);
            amountText=[appDelegate_iPhone.epnc formatterString:-value];
            cell.amount.textColor=gray;
        }
    }
    
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:14],NSFontAttributeName, nil];
    CGRect titleSize = [amountText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:tmpAttr context:nil];
    cell.amountLabelW.constant=titleSize.size.width+3;
    cell.amount.text=amountText;
    
    
    if (hasBudget)
    {
        if (hasBills)
        {
            if (hasUncleared)
            {
                cell.title.text=[[cellTitle1 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                if (indexPath.section==2 && indexPath.row==3)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topSpendName];
                }
                if (indexPath.section==2 && indexPath.row==4)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topLeftName];
                }
            }
            else
            {
                cell.title.text=[[cellTitle1 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                if (indexPath.section==2 && indexPath.row==3)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topSpendName];
                }
                if (indexPath.section==2 && indexPath.row==4)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topLeftName];
                }
            }
        }
        else
        {
            if (hasUncleared)
            {
                cell.title.text=[[cellTitle2 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                if (indexPath.section==2 && indexPath.row==3)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topSpendName];
                }
                if (indexPath.section==2 && indexPath.row==4)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topLeftName];
                }
            }
            else
            {
                cell.title.text=[[cellTitle1 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                if (indexPath.section==2 && indexPath.row==3)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topSpendName];
                }
                if (indexPath.section==2 && indexPath.row==4)
                {
                    cell.nameLabel.text=[NSString stringWithFormat:@"'%@'",topLeftName];
                }
            }
        }
    }
    else
    {
        if (hasBills)
        {
            if (hasUncleared)
            {
                cell.title.text=[[cellTitle3 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            }
            else
            {
                cell.title.text=[[cellTitle3 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if (hasUncleared)
            {
                cell.title.text=[[cellTitle4 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            }
            else
            {
                cell.title.text=[[cellTitle1 objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            }
        }
    }
    cell.amount.font=[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:14];
}

- (void)didReceiveMemoryWarning {
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

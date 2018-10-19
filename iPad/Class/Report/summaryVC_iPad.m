//
//  summaryVC_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import "summaryVC_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate_iPhone.h"
#import "EP_BillRule.h"
#import "Transaction.h"
#import "EP_BillItem.h"
#import "Payee.h"
#import "SummaryTableViewCell_iPad.h"
@import Firebase;
@interface summaryVC_iPad ()<UITableViewDataSource,UITableViewDelegate,ADEngineControllerBannerDelegate>
{
    BOOL hasBudget;
    BOOL hasUncleared;
    BOOL hasBills;
    
    
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
    
    UITableView *generalTableView;
    UITableView *accountTableView;
    UITableView *budgetTableView;
    UITableView *billTableView;
    UITableView *unclearedTableView;
    
    UILabel *accountCover;
    UILabel *budgetCover;
    UILabel *billCover;
    UILabel *unclearedCover;
}
@property(nonatomic, strong)UIView* adBannerView;
@property(nonatomic, strong)ADEngineController* adBanner;

@end

@implementation summaryVC_iPad
-(UIView *)adBannerView{
    if (!_adBannerView) {
        _adBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 90, self.view.width, 90)];
        _adBannerView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:_adBannerView];
        [self.view addSubview:_adBannerView];
    }
    
    return _adBannerView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2103 - iPad - Banner - AccountDetails" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
       
    }
}

#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
    }else{
        self.adBannerView.hidden = YES;;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
    _endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_startDate];
    
    
    [self getData];
    
    [self createTableViews];
    [self createTimeLabel];
    [self createMenu];
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [FIRAnalytics setScreenName:@"summary_main_view_ipad" screenClass:@"summaryVC_iPad"];
}
#pragma mark - 创建控件
-(void)createTableViews
{
    //GENERAL
    generalTableView=[[UITableView alloc]initWithFrame:CGRectMake(15, 44, 450, 264) style:UITableViewStylePlain];
    generalTableView.delegate=self;
    generalTableView.dataSource=self;
    generalTableView.tag=0;
    generalTableView.bounces=NO;
    generalTableView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:generalTableView];
    
    
    //ACCOUNT
    accountTableView=[[UITableView alloc]initWithFrame:CGRectMake(15+450+15, 44, 450, 264) style:UITableViewStylePlain];
    accountTableView.delegate=self;
    accountTableView.dataSource=self;
    accountTableView.tag=1;
    accountTableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:accountTableView];
    
    accountCover=[[UILabel alloc]initWithFrame:CGRectMake(15+450+15, 44+44, 450, 220)];
    [accountCover setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    accountCover.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    accountCover.text=@"No Accounts";
    accountCover.textAlignment=NSTextAlignmentCenter;
    accountCover.textColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:accountCover];
    if (accountDic.count==0)
    {
        accountCover.alpha=1;
    }
    else
    {
        accountCover.alpha=0;
    }
    
    
    
    //BUDGET
    budgetTableView=[[UITableView alloc]initWithFrame:CGRectMake(15, 44+264+15, 295, 264) style:UITableViewStylePlain];
    budgetTableView.delegate=self;
    budgetTableView.dataSource=self;
    budgetTableView.tag=2;
    budgetTableView.bounces=NO;
    budgetTableView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:budgetTableView];
    
    budgetCover=[[UILabel alloc]initWithFrame:CGRectMake(15, 44+44+264+15, 295, 220)];
    [budgetCover setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    budgetCover.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    budgetCover.text=@"No Budgets";
    budgetCover.textAlignment=NSTextAlignmentCenter;
    budgetCover.textColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:budgetCover];
    if (hasBudget==NO)
    {
        budgetCover.alpha=1;
    }
    else
    {
        budgetCover.alpha=0;
    }
    
    //BILL
    billTableView=[[UITableView alloc]initWithFrame:CGRectMake(15+295+15, 44+264+15, 295, 264) style:UITableViewStylePlain];
    billTableView.delegate=self;
    billTableView.dataSource=self;
    billTableView.tag=3;
    billTableView.bounces=NO;
    billTableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:billTableView];
    
    billCover=[[UILabel alloc]initWithFrame:CGRectMake(15+295+15, 44+44+264+15, 295, 220)];
    [billCover setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    billCover.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    billCover.text=@"No Bills";
    billCover.textAlignment=NSTextAlignmentCenter;
    billCover.textColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:budgetCover];
    if (hasBills==NO)
    {
        billCover.alpha=1;
    }
    else
    {
        billCover.alpha=0;
    }

    //UNCLEARED
    unclearedTableView=[[UITableView alloc]initWithFrame:CGRectMake(15+295+15+15+295, 44+264+15, 295, 264) style:UITableViewStylePlain];
    unclearedTableView.delegate=self;
    unclearedTableView.dataSource=self;
    unclearedTableView.tag=4;
    unclearedTableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:unclearedTableView];
    
    unclearedCover=[[UILabel alloc]initWithFrame:CGRectMake(15+295+15+15+295, 44+44+264+15, 295, 220)];
    [unclearedCover setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    unclearedCover.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    unclearedCover.text=@"No Uncleared Items";
    unclearedCover.textAlignment=NSTextAlignmentCenter;
    unclearedCover.textColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.view addSubview:unclearedCover];
    if (hasUncleared==NO)
    {
        unclearedCover.alpha=1;
    }
    else
    {
        unclearedCover.alpha=0;
    }
    
}
-(void)createTimeLabel
{
    
    //时间调节按钮
    UIButton *timeChange=[[UIButton alloc]initWithFrame:CGRectMake(IPAD_WIDTH-45, 7, 30, 30)];
    [timeChange setImage:[UIImage imageNamed:@"chart_time"] forState:UIControlStateNormal];
    [timeChange addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeChange];
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
    
    menuView=[[UIView alloc]initWithFrame:CGRectMake(IPAD_WIDTH-15, 44, 0, 0)];
    
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
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
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
    PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
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
                    else if(tran.incomeAccount !=nil || tran.expenseAccount !=nil)
                    {
                        NSString *transName=tran.payee.name;
                        if (transName==nil)
                        {
                            [unclearedNameArray addObject:@"-"];
                        }
                        else
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
    }
    else
    {
        hasUncleared=YES;
    }
    
    [dataArray addObject:unclearedAmountArray];
}
#pragma mark - 响应方法
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
    menuView.frame=CGRectMake(IPAD_WIDTH-121-15, 44, 121, 44*4);
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
    [generalTableView reloadData];
    [accountTableView reloadData];
    [budgetTableView reloadData];
    [billTableView reloadData];
    [unclearedTableView reloadData];
    
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

#pragma mark - Tableview 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num;
    switch (tableView.tag)
    {
        case 0:
            num=5;
            break;
        case 1:
            num=accountDic.count;
            break;
        case 2:
            num=5;
            break;
        case 3:
            num=4;
            break;
        default:
            num=unclearedAmountArray.count;
            break;
    }
    return num;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    SummaryTableViewCell_iPad *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SummaryTableViewCell_iPad" owner:self options:nil]lastObject];
    }
    NSInteger tag=tableView.tag;
    [self configureSummaryCell:cell atIndexPath:indexPath inTag:tag];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)configureSummaryCell:(SummaryTableViewCell_iPad *)cell atIndexPath:(NSIndexPath *)indexPath inTag:(NSInteger)tag
{
    PokcetExpenseAppDelegate *appDelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSArray *cellTitle=@[
                         @[NSLocalizedString(@"VC_Expense", nil),NSLocalizedString(@"VC_Income", nil),NSLocalizedString(@"VC_Uncleared", nil),NSLocalizedString(@"VC_Cleared", nil),NSLocalizedString(@"VC_NetWorth", nil)],
                         [accountDic allKeys],
                         @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Spent", nil),NSLocalizedString(@"VC_Left", nil),NSLocalizedString(@"VC_Top Spent", nil),NSLocalizedString(@"VC_Top Left", nil)],
                         @[NSLocalizedString(@"VC_Total", nil),NSLocalizedString(@"VC_Overdue", nil),NSLocalizedString(@"VC_Paid", nil),NSLocalizedString(@"VC_Unpaid", nil)],
                         unclearedNameArray];
    
    NSArray *nameArray=[cellTitle objectAtIndex:tag];
    
    cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
    
    NSNumber *num=[[dataArray objectAtIndex:tag]objectAtIndex:indexPath.row];
    float value=[num floatValue];
    
    UIColor *red=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    UIColor *green=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
    UIColor *gray=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    
//    if (tag==0)
//    {
//        if (value>=0)
//        {
//            cell.amountLabel.textColor=green;
//        }
//        else
//        {
//            cell.amountLabel.textColor=red;
//        }
//    }
//    else if ((tag==1 || tag==2) && value<0)
//    {
//        cell.amountLabel.textColor=red;
//    }
//    else
//    {
//        cell.amountLabel.textColor=gray;
//    }
    
    if (tag == 0 && indexPath.row == 1)
    {
        if (value>=0)
        {
            cell.amountLabel.textColor = green;
        }
        else
        {
            cell.amountLabel.textColor = red;
        }
    }
    else if (tag == 4)
    {
        if (value >= 0)
        {
            cell.amountLabel.textColor = green;
        }
        else
        {
            cell.amountLabel.textColor = red;
        }
    }
    else
    {
        if (value >= 0)
        {
            cell.amountLabel.textColor = gray;
        }
        else
        {
            cell.amountLabel.textColor = red;
        }
    }
    NSString *amountStr=[[appDelegate epnc]formatterString:value];
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:17],NSFontAttributeName, nil];
    CGRect titleSize = [amountStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:tmpAttr context:nil];
    cell.amountW.constant=titleSize.size.width+4;
    
    cell.amountLabel.text=amountStr;
    
    if (tag==2)
    {
        if (indexPath.row==3)
        {
            cell.addLabel.text=topSpendName;
        }
        else if (indexPath.row==4)
        {
            cell.addLabel.text=topLeftName;
        }
        else
        {
            cell.addLabel.text=@"";
        }
    }
    else
    {
        cell.addLabel.text=@"";
    }
    
    if (accountDic.count<6)
    {
        accountTableView.bounces=NO;
    }
    if (unclearedNameArray.count<6)
    {
        unclearedTableView.bounces=NO;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 450, 44)];
    header.backgroundColor=[UIColor whiteColor];
    
    UIView *barView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 44)];
    barView.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [header addSubview:barView];
    
    NSArray *titleArray=@[NSLocalizedString(@"VC_GENERAL", nil),
                          NSLocalizedString(@"VC_ACCOUNTS", nil),
                          NSLocalizedString(@"VC_BUDGET", nil),
                          NSLocalizedString(@"VC_BILLS", nil),
                          NSLocalizedString(@"VC_UNCLEARED", nil)];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    title.text=[titleArray objectAtIndex:tableView.tag];
    title.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    title.tintColor=[UIColor blackColor];
    [header addSubview:title];
    
    return header;
}
#pragma mark -

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

//
//  iPad_OverViewViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-8.
//
//

#import "iPad_OverViewViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "KalViewController.h"
#import "EventKitDataSource.h"
#import "KalView.h"
#import "BudgetCountClass.h"
#import "BrokenLineObject.h"
#import "AppDelegate_iPad.h"
#import "ipad_ADSDeatailViewController.h"


#import "XDPlanControlClass.h"
#import "XDChristmasLiteOneViewController.h"
#import "XDChristmasLitePlanAViewController.h"
#import "XDChristmasPlanAbViewController.h"
#import "XDChristmasPlanBbViewController.h"
#import <Parse/Parse.h>
#import "textView.h"

@import     Firebase;
#define TRANSACTIONHAS5Count @"transactionOver5Count"


@interface iPad_OverViewViewController ()<ADEngineControllerBannerDelegate>
@property (weak, nonatomic) IBOutlet UIView *adBannerView;

@property(nonatomic, strong)ADEngineController* adBanner;

@property(nonatomic, strong)XDOverviewChristmasViewA* christmasView;


@end

@implementation iPad_OverViewViewController
@synthesize calendarContainView,kalViewController,dataSource;
@synthesize expenseAmountLabel,incomeAmountLabel,netWorthAmountLabel;
@synthesize availableBudgetAmountLabel,budgetBtn;
@synthesize monthStartDate,monthEndDate,monthTransactionArray;
@synthesize leftLabel,noRecordLabel;

@synthesize cashFlowContainView,cahsFlowView,fetchedResultsByDateController,transactionByDateArray,cashFlowTransactionArray;
@synthesize categoryContainView,overviewCategoryViewController,iTransactionViewController;
@synthesize adsBtn,adsViewController;
@synthesize adsView,purchaseLabelText,noadsLabelText;
@synthesize budgetLabelText,cashFlowLabelText,categoryLabelText;
@synthesize expenseLabelText,incomeLabelText,networthLabelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPoint];
    [self hideorShowAds];
    
    [FIRAnalytics setScreenName:@"calendar_view_ipad" screenClass:@"iPad_OverViewViewController"];

    if ([XDPlanControlClass shareControlClass].needShow) {
        [self showChristmasView];
        calendarContainView.y = 152;
        calendarContainView.height = 674-137;
        kalViewController.kalView.bottomView.y = 533 - 137;

        
//        textView* view = [[[NSBundle mainBundle]loadNibNamed:@"textView" owner:self options:nil]lastObject];
//        view.frame = CGRectMake(0, 0, categoryContainView.width, 175);
//        
//        [categoryContainView addSubview:view];
    }
    
    
    
}

-(void)showChristmasView{
    self.christmasView = [[[NSBundle mainBundle] loadNibNamed:@"XDOverviewChristmasViewA" owner:self options:nil]lastObject];
    
    [XDPlanControlClass shareControlClass].christmasView = self.christmasView;
    [self.christmasView.christmasCancelBtn addTarget:self action:@selector(christmasViewCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.christmasView.christmasBtn addTarget:self action:@selector(presentChristmasVc) forControlEvents:UIControlEventTouchUpInside];
    self.christmasView.frame = CGRectMake(15, 15, calendarContainView.width, 137);
    
    
    [self.view addSubview:self.christmasView];
}

-(void)presentChristmasVc{
    NSInteger plan = [XDPlanControlClass shareControlClass].planType;
    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;
    
    
    if ( plan == ChristmasPlanA) {
        
        if(subPlan == ChristmasSubPlana){
            
            [FIRAnalytics logEventWithName:@"christmas_A_banner_B_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
            XDChristmasLitePlanAViewController* christmas = [[XDChristmasLitePlanAViewController alloc]initWithNibName:@"XDChristmasLitePlanAViewController" bundle:nil];
            christmas.modalPresentationStyle = UIModalPresentationFormSheet;
            christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            christmas.preferredContentSize = CGSizeMake(375, 667);
            
            [self presentViewController:christmas animated:YES completion:nil];
            
        }else if (subPlan == ChristmasSubPlanb){
            [FIRAnalytics logEventWithName:@"christmas_A_banner_b_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
            XDChristmasPlanAbViewController* christmas = [[XDChristmasPlanAbViewController alloc]initWithNibName:@"XDChristmasPlanAbViewController" bundle:nil];
            christmas.modalPresentationStyle = UIModalPresentationFormSheet;
            christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            christmas.preferredContentSize = CGSizeMake(375, 667);

            [self presentViewController:christmas animated:YES completion:nil];
        }
    }else{
        if(subPlan == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_a_banner_B_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
            XDChristmasLiteOneViewController* christmas = [[XDChristmasLiteOneViewController alloc]initWithNibName:@"XDChristmasLiteOneViewController" bundle:nil];
            christmas.modalPresentationStyle = UIModalPresentationFormSheet;
            christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            christmas.preferredContentSize = CGSizeMake(375, 667);

            [self presentViewController:christmas animated:YES completion:nil];
            
        }else if(subPlan == ChristmasSubPlanb){
            [FIRAnalytics logEventWithName:@"christmas_a_banner_b_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
            XDChristmasPlanBbViewController* christmas = [[XDChristmasPlanBbViewController alloc]initWithNibName:@"XDChristmasPlanBbViewController" bundle:nil];
            christmas.modalPresentationStyle = UIModalPresentationFormSheet;
            christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            christmas.preferredContentSize = CGSizeMake(375, 667);

            [self presentViewController:christmas animated:YES completion:nil];
            
        }
    }
}

-(void)christmasViewCancel{
    [UIView animateWithDuration:0.2 animations:^{
        self.christmasView.height = 0;
        calendarContainView.y = 15;
        kalViewController.kalView.bottomView.y = 533;
        calendarContainView.height = 674;
        
    }completion:^(BOOL finished) {
        [self.christmasView removeFromSuperview];
    }];
    
    
    NSInteger plan = [XDPlanControlClass shareControlClass].planType;
    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;
    
    
    if ( plan == ChristmasPlanA) {
        
        if(subPlan == ChristmasSubPlana){
            
            [FIRAnalytics logEventWithName:@"christmas_A_banner_B_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
        }else if (subPlan == ChristmasSubPlanb){
            [FIRAnalytics logEventWithName:@"christmas_A_banner_b_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }
    }else{
        if(subPlan == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_a_banner_B_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
        }else if(subPlan == ChristmasSubPlanb){
            [FIRAnalytics logEventWithName:@"christmas_a_banner_b_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{


    [super viewWillAppear:animated];
    [self refleshData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    kalViewController.view.height = calendarContainView.height;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];

//    calendarContainView.height = 674;
    
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2101 - iPad - Banner - Calendar" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
        kalViewController.kalView.bottomView.y = 533;
        if([XDPlanControlClass shareControlClass].needShow){
            kalViewController.kalView.bottomView.y = 533 - 137;

        }
    }
    
}

#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        
        kalViewController.kalView.bottomView.y = 533-60;
        calendarContainView.height = 616;
        if ([XDPlanControlClass shareControlClass].needShow) {
            
            kalViewController.kalView.bottomView.y = 533-60 - 137;
            calendarContainView.height = 616-137;
        }
    }else{
        self.adBannerView.hidden = YES;;
        kalViewController.kalView.bottomView.y = 533;
        calendarContainView.height = 674;
        
        if ([XDPlanControlClass shareControlClass].needShow) {
            
            kalViewController.kalView.bottomView.y = 533 - 137;
            calendarContainView.height = 674-137;
        }

    }
}


-(void)hideorShowAds{
     PokcetExpenseAppDelegate *appDelegate= (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //免费版，判断是否内购成功 .内购流程1：免费版未购买的，初始化内购管理类，访问内购商品信息
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    
    //判断免费版是否被购买了
    if ([defaults2 valueForKey:LITE_UNLOCK_FLAG])
    {
        appDelegate.isPurchased = YES;
    }
    else
    {
        appDelegate.isPurchased = NO;
    }
    
    if (appDelegate.isPurchased)
    {
        self.adsView.hidden = YES;

    }
    else
        self.adsView.hidden = NO;
}



-(void)refleshUI
{
    if (self.iTransactionViewController != nil)
    {
        [self.iTransactionViewController refleshUI];
    }
    else
    {
        [self refleshData];
    }
    
}

//当从bill页面切回来的时候，需要刷新一下，不然会出现日历显示不全的情况
-(void)refleshData
{
    [self checkTransactionCountOver5];

    self.iTransactionViewController = nil;

    //获取这一个月的交易，用户显示右边的expense,income统计与日历显示
    [self getthisMonthAllTransaction];

    //这一句是为了解决改变日历会将首页的日历弄坏的，bug怎么重现
//    [kalViewController showSelectedMonth];
    [kalViewController reloadData];
    
    
    [self getBudgetData];
    [self getFyChartViewData];
    [self getCategoryViewData];
    
}


#pragma mark Init
-(void)initPoint
{
    purchaseLabelText.text = NSLocalizedString(@"VC_Purchase", nil);
    noadsLabelText.text = NSLocalizedString(@"VC_iphone_ads", nil);
    budgetLabelText.text = [NSLocalizedString(@"VC_Budget", nil)uppercaseString];
    cashFlowLabelText.text = NSLocalizedString(@"VC_CASHFLOW", nil);
    categoryLabelText.text =  [NSLocalizedString(@"VC_Category", nil) uppercaseString];
    noRecordLabel.text = NSLocalizedString(@"VC_ipadNoRecords", nil);
    
    expenseLabelText.text = [NSLocalizedString(@"VC_EXPENSE", nil) uppercaseString];
    incomeLabelText.text = [NSLocalizedString(@"VC_INCOME", nil) uppercaseString];
    networthLabelText.text = NSLocalizedString(@"VC_NETWORTH", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [expenseAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:19]];
    [incomeAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:19]];
    [netWorthAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:19]];
    [_budgetRemainLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
    [_budgetExpenseLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
    [availableBudgetAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    
    monthTransactionArray = [[NSMutableArray alloc]init];
    
    //init calendar
    kalViewController=[[KalViewController alloc]init];
    dataSource = [[EventKitDataSource alloc] init];
    kalViewController.dataSource=dataSource;
    kalViewController.delegate=dataSource;
    kalViewController.view.tag = 1;
    [calendarContainView addSubview:kalViewController.view];
    
    
    [kalViewController.dataSource getCalendarView:dataSource];
    [kalViewController.dataSource getTableView:kalViewController.kalView.tableView];
    
    self.monthStartDate = [[self.kalViewController.kalView.logic.daysInSelectedMonth firstObject] NSDate];
    self.monthEndDate =  [appDelegate.epnc getEndDateDateType:2 withStartDate:self.monthStartDate];
    
    
    [self initFyChartView];
    
    [self initCategoreView];
    
    [budgetBtn addTarget:self action:@selector(budgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initFyChartView
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    cashFlowTransactionArray=[[NSMutableArray alloc]init];
    transactionByDateArray = [[NSMutableArray alloc]init];
    cahsFlowView=[[FYChartView alloc]initWithFrame:CGRectMake(15, 46, 491, 185)];
    cahsFlowView.backgroundColor = [UIColor clearColor];
    cahsFlowView.rectangleLineColor = [UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0];
    cahsFlowView.lineColor2 = [appDelegate.epnc getAmountRedColor];
    cahsFlowView.dataSource = self;
    [cashFlowContainView addSubview:cahsFlowView];
}

-(void)initCategoreView
{
    overviewCategoryViewController=[[OverViewcategoryViewController alloc]initWithNibName:@"OverViewcategoryViewController" bundle:nil];
    [categoryContainView addSubview:overviewCategoryViewController.view];
}

#pragma mark Btn Action
-(void)budgetBtnPressed:(UIButton *)sender
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [appDelegate_iPad.mainViewController budgetModuleBtnAction:nil];
}

-(IBAction)adsBtnPressed:(UIButton *)sender
{
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
//
//    adsViewController = [[ipad_ADSDeatailViewController alloc]initWithNibName:@"ipad_ADSDeatailViewController" bundle:nil];
//    adsViewController.view.backgroundColor = [UIColor clearColor];
//    adsViewController.isComeFromSetting = NO;
//      adsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    adsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    appDelegate1.mainViewController.popViewController = adsViewController;
//
//    [appDelegate1.mainViewController presentViewController:adsViewController animated:YES completion:nil];
//    adsViewController.view.superview.autoresizingMask =
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
    XDIpad_ADSViewController* adsDetailViewController = [[XDIpad_ADSViewController alloc]initWithNibName:@"XDIpad_ADSViewController" bundle:nil];
    //        adsDetailViewController.isComeFromSetting = NO;
    //        adsDetailViewController.pageNum = i;
    //        adsDetailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    appDelegate1.mainViewController.popViewController = adsDetailViewController;
    adsDetailViewController.preferredContentSize = CGSizeMake(390, 600);
    [appDelegate1.mainViewController presentViewController:adsDetailViewController animated:YES completion:nil];
    
    adsDetailViewController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
    
    adsDetailViewController.view.superview.backgroundColor = [UIColor clearColor];
    [appDelegate1.epnc setFlurryEvent_WithIdentify:@"22_AD_BANR"];
}

-(void)checkTransactionCountOver5
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDictionary *dic = [NSDictionary dictionary];
    
    NSFetchRequest *fetchTransaction =  [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscations" substitutionVariables:dic];
    NSError *error = nil;
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchTransaction error:&error];
    
    //如果是免费版的话，就判断是不是已经出现过了
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取当前设备上保存的版本号
    NSString *transactionCountMark = [userDefaults stringForKey:TRANSACTIONHAS5Count];
    
    self.adsView.hidden = YES;
    if (!appDelegate.isPurchased)
    {
        if ([transactionCountMark isEqualToString:@"1"]) {
            self.adsView.hidden = NO;
        }
        else if ([objects count]>=5)
        {
            self.adsView.hidden = NO;
            [userDefaults setObject:@"1" forKey:TRANSACTIONHAS5Count];
            [userDefaults synchronize];
        }
    }
}

-(void)resetCalendarStyle
{
    NSDate *tmpSelectedDate = kalViewController.selectedDate;
    id tmp = [kalViewController.logic  initForDate:tmpSelectedDate];
    [kalViewController.kalView resetWeekStyle:kalViewController.kalView.kalheaderView];
    [kalViewController.kalView jumpToSelectedMonth];
    NSLog(@"%@",tmp);
}

#pragma mark DataSource
//获取整个月的金额
-(void)getthisMonthAllTransaction
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error =nil;
    
    [monthTransactionArray removeAllObjects];
    
   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.monthStartDate,@"startDate",self.monthEndDate,@"endDate",nil];
    
 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    [monthTransactionArray setArray:objects1];

    
    double totalSpend = 0;
    double totalIncome =0;
    double netWorth = 0;
	for (int i=0; i<[monthTransactionArray count]; i++)
	{
 		Transaction *oneTransaction =[monthTransactionArray objectAtIndex:i];
        if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
            totalSpend += [oneTransaction.amount doubleValue];
        }
        else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
            totalIncome += [oneTransaction.amount doubleValue];
        }
        else if ([[oneTransaction.childTransactions allObjects]count]>0){
            totalSpend += [oneTransaction.amount doubleValue];
        }
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (totalSpend>999999999)
    {
        expenseAmountLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:totalSpend/1000]];
    }
    else
    {
        expenseAmountLabel.text=[appDelegate.epnc formatterString:totalSpend];
    }
    
    if (totalIncome>999999999)
    {
        incomeAmountLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:totalIncome/1000]];
    }
    else
    {
        incomeAmountLabel.text=[appDelegate.epnc formatterString:totalIncome];
    }
    
    netWorth = [appDelegate.epdc getSelectedMonthNetWorth:self.monthEndDate isMonthViewControllerBalance:YES];
    if (netWorth>999999999 || netWorth<-999999999)
    {
        netWorthAmountLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:netWorth/1000]];
    }
    else
    {
        netWorthAmountLabel.text=[appDelegate.epnc formatterString:netWorth];
    }
    if (netWorth < 0)
    {
        netWorthAmountLabel.textColor =[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    }
}

-(void)getBudgetData
{
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
 	// Edit the entity name as appropriate.
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    
    // Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    
 	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];
	
	
	double totalBudgetAmount = 0;
	double totalExpense = 0;
    double totalRollover = 0;
    
 	double totalIncome = 0;
    
	NSDictionary *subs;
	for (int i = 0; i<[allBudgetArray count];i++)
    {
		BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.monthStartDate,@"startDate",self.monthEndDate,@"endDate", nil];
            
            
            
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
          
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"])
                {
                    totalExpense +=[t.amount doubleValue];
                }
                else if([t.category.categoryType isEqualToString:@"INCOME"]){
                    totalIncome +=[t.amount doubleValue];
                }
                
            }
            
            ////////////////////get All child category
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
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.monthStartDate,@"startDate",self.monthEndDate,@"endDate", nil];
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
                                totalExpense +=[t.amount doubleValue];
                            }
                            else if([t.category.categoryType isEqualToString:@"INCOME"])
                            {
                                totalIncome +=[t.amount doubleValue];
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
	}
    
    double totalblance = totalBudgetAmount+totalRollover;
    

    if (totalblance==0) {
        leftLabel.hidden = YES;
        availableBudgetAmountLabel.text = [appDelegate.epnc formatterString:0.00];
        availableBudgetAmountLabel.frame = CGRectMake(availableBudgetAmountLabel.frame.origin.x, 67, availableBudgetAmountLabel.frame.size.width, availableBudgetAmountLabel.frame.size.height);

    }
    else
    {
        leftLabel.hidden = NO;
        availableBudgetAmountLabel.frame = CGRectMake(availableBudgetAmountLabel.frame.origin.x, 70, availableBudgetAmountLabel.frame.size.width, availableBudgetAmountLabel.frame.size.height);

        if ([appDelegate.settings.others19 isEqualToString:@"spent"]) {
            leftLabel.text = NSLocalizedString(@"VC_SPENT", nil);
            availableBudgetAmountLabel.text = [appDelegate.epnc formatterString:totalExpense];
        }
        else
        {
            leftLabel.text = NSLocalizedString(@"VC_LEFT", nil);
            availableBudgetAmountLabel.text = [appDelegate.epnc formatterString:(totalblance-totalExpense)];

        }
    }


    UIColor *gray=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    
    if (totalblance==0)
    {
        budgetBar_iPad *bar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(15, 59, 476, 15) type:@"overview" ratio:0 color:gray];
        [_budgetContainView addSubview:bar];
        _budgetRemainLabel.text=[[appDelegate epnc]formatterString:totalblance];

    }else if (totalExpense <= totalblance)
    {
        budgetBar_iPad *bar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(15, 59, 476, 15) type:@"overview" ratio:totalExpense/totalblance color:gray];
        [_budgetContainView addSubview:bar];
        _budgetRemainLabel.text=[[appDelegate epnc]formatterString:totalblance];
        
    }else
    {
        float ratio = 0;
        if (totalExpense == 0) {
            ratio = 0;
        }else{
            if (totalblance/totalExpense < 0) {
                if (totalblance/totalExpense < -1) {
                    ratio = 1;
                }else{
                    ratio = -(totalblance/totalExpense);
                }
            }else{
                if (totalblance/totalExpense > 1) {
                    ratio = 1;
                }else{
                    ratio = totalblance/totalExpense;
                }
            }
        }
        budgetBar_iPad *bar=[[budgetBar_iPad alloc]initWithFrame:CGRectMake(15, 59, 476, 15) type:@"overview" ratio:ratio color:red];
        [_budgetContainView addSubview:bar];
        _budgetRemainLabel.text=[[appDelegate epnc]formatterString:totalExpense];
    }
    
    NSString *budgetStr;
    if (totalExpense<=totalblance)
    {
        budgetStr=[appDelegate.epnc formatterString:totalExpense];
        
    }
    else
    {
        budgetStr=[appDelegate.epnc formatterString:totalblance];
    }
    
    
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:17],NSFontAttributeName, nil];
    CGRect budgetSize = [budgetStr boundingRectWithSize:CGSizeMake(150, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:tmpAttr context:nil];
    float budgetWidth=budgetSize.size.width;
    
    if (totalblance==0)
    {
        _budgetBottomToRight.constant=521-15-budgetWidth;
    }
    else if (totalExpense<=totalblance)
    {
        if (totalExpense/totalblance*476<budgetWidth)
        {
            _budgetBottomToRight.constant=521-15-budgetWidth;
        }
        else if (totalExpense/totalblance*476+budgetWidth>476)
        {
            _budgetBottomToRight.constant=30;
        }
        else
        {
            _budgetBottomToRight.constant=521-15-totalExpense/totalblance*476;
        }
    }
    else
    {
        if (totalblance/totalExpense*476<budgetWidth)
        {
            _budgetBottomToRight.constant=521-15-budgetWidth;
        }
        else if (totalblance/totalExpense*476+budgetWidth>476)
        {
            _budgetBottomToRight.constant=30;
        }
        else
        {
            _budgetBottomToRight.constant=521-15-totalblance/totalExpense*476;
        }
    }
    _budgetExpenseLabel.text=budgetStr;

}

-(void)getFyChartViewData
{
    [self createCashArray];
    [self calculateSortArrayandReplaceCashArray];
    [self configureFyChatrView];
    [cahsFlowView reloadData];
}

-(void)getCategoryViewData
{    overviewCategoryViewController.startDate=self.monthStartDate;
    overviewCategoryViewController.endDate=self.monthEndDate;
    [overviewCategoryViewController getDateSouce_category];
}

#pragma mark Cash Flow Method
- (NSFetchedResultsController *)getfetchedResultsByDateController{
	PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSError * error=nil;
  	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.monthStartDate,@"startDate",self.monthEndDate,@"endDate", nil];
    NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSFetchedResultsController* fetchedResults;
    fetchedResults= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:appDelegete.managedObjectContext
                                                          sectionNameKeyPath:@"groupByDetailDateString"
                                                                   cacheName:@"Root"];
    self.fetchedResultsByDateController = fetchedResults;
	[fetchedResults performFetch:&error];

	return fetchedResultsByDateController;
}

-(void)createCashArray{
    long int cycleNym = 0;
    
    [transactionByDateArray removeAllObjects];

    unsigned flag = NSCalendarUnitDay;
    
    NSDateComponents *dateComponent1 = [[NSCalendar currentCalendar]components:flag fromDate:self.monthStartDate toDate:self.monthEndDate options:0];
    //否则计算的是差值
    cycleNym = [dateComponent1 day]+1;
    
    unsigned flag1 = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDate  *thisCycleFirstDay = self.monthStartDate;
    
    NSDateComponents *dateComponent =  [[NSCalendar currentCalendar]components:flag1 fromDate:thisCycleFirstDay];
    
    //初始化 带有时间的数据，只是创建了一些BrokenlineObject数据，还缺少 expenseAmount,incomeAmount,transaction array
    for (long int i=0; i<cycleNym ; i++) {
        NSDate *oneDate = [[NSCalendar  currentCalendar]dateFromComponents:dateComponent];
        BrokenLineObject *oneBrokenLineObject =[[BrokenLineObject alloc]initWithDay:oneDate];
        [transactionByDateArray addObject:oneBrokenLineObject];
        
        dateComponent.year = dateComponent.year;
        dateComponent.month = dateComponent.month;
        dateComponent.day = dateComponent.day+1;
        dateComponent.minute = dateComponent.minute;
        dateComponent.second = dateComponent.second;
       
    }
}

//-----------.统计fetchController的分组数据，然后替换cash array中的数据
-(void)calculateSortArrayandReplaceCashArray{
    //获取这个月每天的数据
    [self getfetchedResultsByDateController];
    double totalCycleExpenseAmount = 0;
    double hightestExpense = 0;
    double lowestExpense = 0;
//    long int cycleNym = 0;
    
//    unsigned flag = NSCalendarUnitDay;
    
//    NSDateComponents *dateComponent1 = [[NSCalendar currentCalendar]components:flag fromDate:self.monthStartDate toDate:self.monthEndDate options:nil];
//    cycleNym = dateComponent1.day + 1;
    
    
    for (int i=0; i<[[self.fetchedResultsByDateController sections] count]; i++) {
        //获取每个section的总expense amount,income amount
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsByDateController sections]objectAtIndex:i];
        double  itemTotalExpenseAmount = 0;
        
        for (long int k=0;k<[sectionInfo numberOfObjects]; k++) {
            Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:k];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
        }
        lowestExpense = itemTotalExpenseAmount;
        
        if (itemTotalExpenseAmount > hightestExpense) {
            hightestExpense = itemTotalExpenseAmount;
        }
        if (itemTotalExpenseAmount < lowestExpense ) {
//            lowestExpense = itemTotalExpenseAmount;
        }
        totalCycleExpenseAmount += itemTotalExpenseAmount;
        
        
        Transaction *dayFirstTransaction =[[sectionInfo objects]objectAtIndex:0];
        unsigned int flag = NSCalendarUnitDay;
        NSDateComponents *tmpDateComp = [[NSCalendar currentCalendar]components:flag fromDate:self.monthStartDate toDate:dayFirstTransaction.dateTime options:0];
        BrokenLineObject *oneBrokenLineObject = [transactionByDateArray objectAtIndex:tmpDateComp.day];
        oneBrokenLineObject.expenseAmount = itemTotalExpenseAmount;
        [oneBrokenLineObject.thisDaytTransactionArray removeAllObjects];
        [oneBrokenLineObject.thisDaytTransactionArray setArray:[sectionInfo objects]];
    }
    
}

-(void)configureFyChatrView
{
    BOOL hasCashFlow = NO;
    [cashFlowTransactionArray removeAllObjects];
    for (int i = 0; i <[transactionByDateArray count]; i++)
    {
        BrokenLineObject *object=[transactionByDateArray objectAtIndex:i];
        
        [cashFlowTransactionArray addObject:[NSNumber numberWithDouble:object.expenseAmount]];
        if (object.expenseAmount >0) {
            hasCashFlow = YES;
        }
    }
    
    if (hasCashFlow) {
        noRecordLabel.hidden= YES;
    }
    else
        noRecordLabel.hidden = NO;
}

#pragma mark -FYChartViewDelegate
//number of value count
- (NSInteger)numberOfValue2ItemCountInChartView:(FYChartView *)chartView
{
    return cashFlowTransactionArray ?cashFlowTransactionArray.count:0;
}
//value at index
- (float)chartView:(FYChartView *)chartView value2AtIndex:(NSInteger)index
{
    return [((NSNumber *)cashFlowTransactionArray[index]) floatValue];
    
}
//horizontal title at index
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index
{
    //    if (index == 0 || index == self.fyChartValuesIncome.count - 1)
    //    {
    //        return [NSString stringWithFormat:@"%.2f", [((NSNumber *)self.fyChartValuesIncome[index]) floatValue]];
    //    }
    return [NSString stringWithFormat:@"%ld",(long)(index+1)];
    //   return nil;
}

//horizontal title alignment at index
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0)
    {
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == cashFlowTransactionArray.count - 1)
    {
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

//description view at index
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index
{   unsigned int flag=NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *components=[[NSCalendar currentCalendar] components:flag fromDate:[NSDate date]];
    [components setDay:index+1];
    NSDate *date=[[NSCalendar currentCalendar]dateFromComponents:components];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *dateStr=[dateFormatter stringFromDate:date];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString * tmpAmountStr = [appDelegate.epnc formatterString:[((NSNumber *)cashFlowTransactionArray[index]) floatValue]];
    
    NSString * infoStr=[NSString stringWithFormat:@"%@, %@",dateStr, tmpAmountStr];
 
    NSUInteger length=[infoStr length];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_pop_mid_1_24.png"]] ;
    imageView.frame=CGRectMake(0, 0, length*4, imageView.frame.size.height);
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(length*6, imageView.frame.size.height);
    imageView.frame = frame;
    UILabel *label = [[UILabel alloc]
                       initWithFrame:CGRectMake(.0f, .0f, imageView.frame.size.width, imageView.frame.size.height)] ;
    [label setTextColor:[UIColor whiteColor]];
    label.text = infoStr;
    label.numberOfLines = 1;
//    label.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    [label setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:11]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [imageView addSubview:label];
    
    UIImageView *leftArc=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_pop_left_5_24.png"]];
    CGSize leftSize=leftArc.frame.size;
    leftArc.frame=CGRectMake(-leftSize.width, 0, leftSize.width, leftSize.height);
    
    UIImageView *rightArc=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_pop_right_5_24.png"]];
    CGSize rightSize=rightArc.frame.size;
    rightArc.frame=CGRectMake(imageView.frame.size.width, 0, rightSize.width, rightSize.height);
    UIImageView *buttonArc=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_pop_arrow_8_4.png"]];
    CGSize buttonSize=buttonArc.frame.size;
    buttonArc.frame=CGRectMake(imageView.frame.size.width/2-buttonSize.width/2, imageView.frame.size.height, buttonSize.height, buttonSize.width);
    
    [imageView addSubview:leftArc];
    [imageView addSubview:rightArc];
    [imageView addSubview:buttonArc];
    
    
    return imageView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

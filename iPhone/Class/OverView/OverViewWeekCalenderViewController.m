//
//  OverViewWeekCalenderViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-3.
//
//

#import "OverViewWeekCalenderViewController.h"
#import "TransactionEditViewController.h"
#import "AppDelegate_iPhone.h"

#import "KalViewController_week.h"
#import "KalLogic_week.h"
#import "KalGridView_week.h"
#import "EventKitDataSource_week.h"
#import "KalDate_week.h"

#import "BudgetViewController.h"
#import "AccountSearchViewController.h"
#import "AccountsViewController.h"
#import "ExpenseViewController.h"
#import "BillsViewController.h"
#import "SettingViewController.h"
#import "OverViewMonthViewController.h"
#import "TransactionCategorySplitViewController.h"
#import "OverViewBudgetPiCharView.h"

#import "BudgetIntroduceViewController.h"
#import "BudgetViewController.h"
#import "ADSDeatailViewController.h"
#import "KalView_week.h"

#import "EPNormalClass.h"
#import "PlannerClass.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"
#import "UIViewController+MMDrawerController.h"

#import <ParseUI/ParseUI.h>
#import "XDCalendarView.h"
#import "XDTransicationTableViewController.h"
#import "SearchRelatedViewController.h"
#import "DuplicateTimeViewController.h"
#import "XDAddTransactionViewController.h"
#define TRANSACTIONHAS5Count @"transactionOver5Count"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface OverViewWeekCalenderViewController ()<XDCalendarViewDelegate,XDTransicationTableViewDelegate,DuplicateTimeViewControllerDelegate>
{
    NSMutableArray *topDataArray;
    UIView *backView;
}

@property(nonatomic, strong)XDTransicationTableViewController* transTableView;
@property(nonatomic, strong)XDCalendarView * calView;
@property(nonatomic, strong)NSDate * duplicateDate;
@property(nonatomic, strong)Transaction * currentTransication;


@end

@implementation OverViewWeekCalenderViewController

-(XDCalendarView *)calView{
    if (!_calView) {
        _calView = [[XDCalendarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 440)];
        _calView.delegate = self;

    }
    return _calView;
}

-(XDTransicationTableViewController *)transTableView{
    if (!_transTableView) {
        _transTableView = [[XDTransicationTableViewController alloc]initWithStyle:UITableViewStylePlain];
        _transTableView.selectedDate = [NSDate date];
        _transTableView.transcationDelegate = self;
        _transTableView.view.frame = CGRectMake(0, 440, self.view.width, self.view.height - 440);
    }
    return _transTableView;
}

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

    self.edgesForExtendedLayout = UIRectEdgeNone;

//    [self initNavStyle];
//    [self initXDtransicationTableView];
////    [self initPoint];
////    [self initCalenderView];
////    [self createAddBtn];
//    [self.view addSubview:self.calView];
//    self.title = [self monthFormatterWithSeletedMonth:[NSDate date]];
}
-(void)initXDtransicationTableView{
    [self.view addSubview:self.transTableView.tableView];
    
}

-(void)initCalenderView{
    _kalViewController = [[KalViewController_week alloc]init];
    _kalViewController.title = @"hello";
    self.calenderDataSource = [[EventKitDataSource_week alloc] init];
    _kalViewController.dataSource = self.calenderDataSource;
    _kalViewController.delegate = self.calenderDataSource;
    [_kalViewController.dataSource getCalendarView:self.calenderDataSource];
    [_kalContailView addSubview:_kalViewController.view];
    [_kalViewController.dataSource  getTableView:self.kalViewController.tableView];
}

-(void)initNavStyle
{
    
    //    UIImage *image1 = [UIImage imageNamed:@"calendar_nav.png"];
    //    UIImage *image = [[UIImage alloc]init];
    //    self.navigationController.navigationBar.shadowImage = image;
    //    [self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
    //    
    //    [self getTitleYearAndMonth];
    //    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    //    self.navigationItem.title = [monthFormatter stringFromDate:self.kalViewController.selectedDate ];
    //    
    //    
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1],
    //                                   NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17
    //                                                        ]}];
    
    //left bar
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    
    //rightbar
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_calander"] style:UIBarButtonItemStylePlain target:self action:@selector(monthContainBtnPressed:)];
    rightButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 5;
    
    UIBarButtonItem* searchBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    searchBarButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    self.navigationItem.rightBarButtonItems = @[rightButton,spaceItem,searchBarButton];
    
    
}
-(NSString*)monthFormatterWithSeletedMonth:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    return [formatter stringFromDate:date];
}

#pragma mark - XDTransicationTableViewDelegate
-(void)returnDragContentOffset:(CGFloat)offsetY{
    if (offsetY < 0) {
        if (self.calView.calendarType != CalendarMonth) {
            self.calView.calendarType = CalendarMonth;
        }
    }else{
        if (self.calView.calendarType != CalendarDay) {
            self.calView.calendarType = CalendarDay;
        }
    }
}
-(void)returnCellSelectedBtn:(Transaction *)transcation index:(NSInteger)index{
    self.currentTransication = transcation;
    
    if (index == 0) {
        SearchRelatedViewController *searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
        searchRelatedViewController.transaction = transcation;
        searchRelatedViewController.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:searchRelatedViewController animated:YES];
    }else if (index == 1){
        DuplicateTimeViewController* dupVc = [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController_iPhone" bundle:nil];
        dupVc.delegate = self;
        [self.view.window addSubview:dupVc.view];
        
    }else if (index == 2){
       
        
        
    }
}

#pragma mark DuplicateTimeViewController delegate
-(void)setDuplicateDateDelegate:(NSDate *)date{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (goon){
        
        Transaction *selectedTrans = self.currentTransication;
        
        [appDelegate.epdc duplicateTransaction:selectedTrans withDate:self.duplicateDate];
        
        [appDelegate_iPhone.overViewController resetAllDate];
    }
    else{
        
        [appDelegate_iPhone.overViewController resetAllDate];
        
    }
}
#pragma mark - XDCalendarViewDelegate
-(void)returnCurrentShowDate:(NSString *)date{
    self.title = date;
}

-(void)returnSelectedDate:(NSDate *)date{
    self.transTableView.selectedDate = date;
    
    self.ClickBlock(date);
}

-(void)returnCalendarFrame:(CGRect)rect{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transTableView.tableView.frame = CGRectMake(0, rect.size.height,self.view.width, self.view.height - rect.size.height);
    }];
}
//

#pragma mark -

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.translucent = NO;

    [self resetAllDate];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.customerTabbarView.hidden = NO;
    appDelegate.adsView.hidden = NO;
    [self resetStyleWithAds];

    __weak UIViewController *slf = self;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch)
    {
        BOOL shouldRecongize=NO;
        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            CGPoint location = [touch locationInView:slf.view];
            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 150, SCREEN_HEIGHT), location);

            [appDelegate.menuVC reloadView];
        }

        return shouldRecongize;
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}
-(void)reflashUI
{
    [self reflashData];
    
}

-(void)reflashData
{
    if (_billsViewController != nil)
    {
        [_billsViewController refleshUI];
    }
    else{
        [self resetAllDate];
        
        [self.kalViewController reloadData];
        
        //设置budget
//        [self setBudgetSouceAndLayOut_NS];
        
        
    }
}


-(void)initPoint
{
    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    _notransactionLabel.text = NSLocalizedString(@"VC_Main_NoTransaction", nil);

    self.oneDayStartDay =[appDelegete.epnc getStartDateWithDateType:0 fromDate:nil];
    self.oneDayEndDay =[appDelegete.epnc getEndDateDateType:0 withStartDate:self.oneDayStartDay];
    self.startDate =[appDelegete.epnc getStartDateWithDateType:1 fromDate:nil];
    self.endDate = [appDelegete.epnc getEndDateDateType:1 withStartDate:self.startDate];
//    self.monthStartDate = [appDelegete.epnc getStartDateWithDateType:2 fromDate:nil];
//	self.monthEndDate = [appDelegete.epnc getEndDateDateType:2 withStartDate:self.monthStartDate];
    
    self.monthStartDate = [appDelegete.epnc getStartDateWithDateType:2  fromDate:self.kalViewController.selectedDate];
    self.monthEndDate = [appDelegete.epnc getEndDateDateType:2 withStartDate:self.monthStartDate];
    
    _weekTransactionArray = [[NSMutableArray alloc]init];
    _monthTransactionArray = [[NSMutableArray alloc]init];
    _dayTransactionArray = [[NSMutableArray alloc]init];
    
    [self addSubviewsToHeaderView:_headerView withDate:self.monthStartDate];
    _isShowMonthCalendar = NO;
    
}



//获取整个月的金额
-(double)getSelectedMonthNetWorth:(NSDate *)date isMonthViewControllerBalance:(BOOL)isMonthViewControllerBalance
{
    
    //get account array
	NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity_account = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest_account setEntity:entity_account];
    NSPredicate * predicate_account =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest_account setPredicate:predicate_account];
    
    NSSortDescriptor *sortDescriptor_account = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray *sortDescriptors_account = [[NSArray alloc] initWithObjects:sortDescriptor_account, nil];
    
    [fetchRequest_account setSortDescriptors:sortDescriptors_account];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];

    
	double totalBalance =0;
//    if (!isMonthViewControllerBalance) {
//        for (int i=0; i<[tmpAccountArray count]; i++)
//        {
//            double oneIncome = 0;
//            Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
//            oneIncome = [tmpAccount.amount doubleValue];
//            totalBalance+=[tmpAccount.amount doubleValue];
//        }
//
//    }
//    else
//    {
//        for (int i=0; i<[tmpAccountArray count]; i++)
//        {
//            double oneIncome = 0;
//            Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
//            if ([appDelegate.epnc dateCompare:self.monthEndDate withDate:tmpAccount.dueDate]>=0)
//            {
//                oneIncome = [tmpAccount.amount doubleValue];
//                totalBalance+=[tmpAccount.amount doubleValue];
//            }
//           
//        }
//    }
    
    for (int i=0; i<[tmpAccountArray count]; i++)
    {
        double oneIncome = 0;
        Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
        
        if (!isMonthViewControllerBalance)
        {
            oneIncome = [tmpAccount.amount doubleValue];
            totalBalance+=[tmpAccount.amount doubleValue];
        }
        else if ([appDelegate.epnc dateCompare:date withDate:tmpAccount.dateTime]>=0)
        {
            oneIncome = [tmpAccount.amount doubleValue];
            totalBalance+=[tmpAccount.amount doubleValue];
        }
        
    }
    
    
   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:date,@"endDate", [NSNull null],@"EMPTY",nil];
    
 	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsBeforeDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    [_monthTransactionArray setArray:objects1];
    
    double totalSpend = 0;
	double totalIncome =0;
    double netWorth = 0;
	for (int i=0; i<[_monthTransactionArray count]; i++)
	{
 		Transaction *oneTransaction =[_monthTransactionArray objectAtIndex:i];
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
    netWorth = totalIncome - totalSpend + totalBalance;
    return netWorth;
}

//获取这一周所有的金额
-(void)getthisWeekAllTransaction
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error =nil;
    
    [_weekTransactionArray removeAllObjects];
    
   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"startDate",self.endDate,@"endDate",nil];
    
 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    [_weekTransactionArray setArray:objects1];
    
    [_kalViewController.kalView paidmarkTilesForDates:_weekTransactionArray withDates1:nil isTran:YES];
    [_kalViewController reloadData];
    [_kalViewController.kalView.tableView reloadData]; 
}

-(void)resetAllDate{
    self.accountSearchViewController = nil;
    self.settingViewController = nil;
    self.overViewMonthViewController=nil;
    
    //设置主页的ads

    
    //获取这一周的消费金额
    [self.kalViewController reloadData];
    
    
    //获取选中这一天所在的月份
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.monthStartDate = [appDelegate.epnc getStartDateWithDateType:2  fromDate:self.kalViewController.selectedDate];
    self.monthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.monthStartDate];
    
    
    if(_calViewController && _isShowMonthCalendar)
    {
        [_calViewController reloadTableView];
    }
}



-(void)leftDrawerButtonPress:(id)sender
{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    [appdelegate.menuVC reloadView];
    
    NSLog(@"leftDrawerButtonPress");
}



-(void)resetCalendarStyle
{
    NSDate *tmpSelectedDate = self.kalViewController.selectedDate;
    id tmp = [_kalViewController.logic initForDate:tmpSelectedDate];
//    [_kalViewController.kalView addSubviewsToHeaderView:_kalViewController.kalView.kalheaderView];
    
    [self addSubviewsToHeaderView:_headerView withDate:self.monthStartDate];
    [_kalViewController.kalView jumpToSelectedMonth];
    NSLog(@"%@",tmp);
}

//刷新日历起始日
-(void)reloadCalendarView
{
    [self initCalenderView];
}
-(void)resetStyleWithAds
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.isPurchased)
    {
        _overViewWeekView.frame = CGRectMake(_overViewWeekView.frame.origin.x, _overViewWeekView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    else
        _overViewWeekView.frame = CGRectMake(_overViewWeekView.frame.origin.x, _overViewWeekView.frame.origin.y, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height-64-15-SCREEN_WIDTH/7);

}
-(void)getTitleYearAndMonth
{
    NSString *str=[self.monthEndDate description];
    _titleYear=[NSString string];
    _titleYear=[str substringWithRange:NSMakeRange(0, 4)];
    NSString *month=[str substringWithRange:NSMakeRange(5, 2)];
    
    switch ([month intValue])
    {
        case 1:
            _titleMonth=@"January";
            break;
        case 2:
            _titleMonth=@"Febuary";
            break;
        case 3:
            _titleMonth=@"March";
            break;
        case 4:
            _titleMonth=@"April";
            break;
        case 5:
            _titleMonth=@"May";
            break;
        case 6:
            _titleMonth=@"June";
            break;
        case 7:
            _titleMonth=@"July";
            break;
        case 8:
            _titleMonth=@"August";
            break;
        case 9:
            _titleMonth=@"September";
            break;
        case 10:
            _titleMonth=@"October";
            break;
        case 11:
            _titleMonth=@"November";
            break;
        default:
            _titleMonth=@"December";
            break;
    }
}
#pragma mark add-btn
-(void)createAddBtn
{

    backView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70-64, SCREEN_WIDTH, 70)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-105)/2,10 , 105, 50)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button_addcategory"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button_addcategory_click"] forState:UIControlStateHighlighted];
    [backView addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(loadTransactionView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)loadTransactionView
{
    TransactionEditViewController *transVC = [[TransactionEditViewController alloc]initWithNibName:@"TransactionEditViewController" bundle:nil];
    transVC.typeoftodo = @"ADD";
    transVC.showMoreDetailsCell = NO;
    transVC.isFromHomePage = YES;
    
    transVC.transactionDate = self.kalViewController.selectedDate;
    UINavigationController *navigationViewController =[[UINavigationController alloc]initWithRootViewController:transVC];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}
#pragma mark Btn Action
-(void)searchBtnClick{
    
    AccountSearchViewController *searchVC = [[AccountSearchViewController alloc]initWithNibName:@"AccountSearchViewController" bundle:nil];
    [self presentViewController:searchVC  animated:YES completion:nil];
}

-(void)monthContainBtnPressed:(UIButton *)sender{
    
    NSLog(@"monthContainBtnPressed");
//    UIBarButtonItem *rightBarButton = (UIBarButtonItem *)sender;
//    if(_isShowMonthCalendar)
//    {
//        rightBarButton.image = [UIImage imageNamed:@"button_calander"];
//        self.kalViewController.logic.baseDate = [[NSDate date] cc_dateByMovingToFirstDayOfTheWeek];
//        //先把界面中的周显示出来，然后设置选中的那一天，然后跳到那个页面开始刷新数据
//        [self.kalViewController showCurrentMonth];
//        [self.kalViewController.kalView selectDate:[KalDate_week dateFromNSDate:[NSDate date]]];
//
//        [self.view insertSubview:self.overViewWeekView aboveSubview:self.scrollView];
//        _isShowMonthCalendar = NO;
//
//        _headerView.frame=CGRectMake(0, -49, SCREEN_WIDTH, 64);
//        [self createAddBtn];
//        return;
//    }
//    else
//    {
//        rightBarButton.image = [UIImage imageNamed:@"overview_button_calander_list"];
//    }
//    [self addSubviewsToHeaderView:_headerView withDate:self.monthStartDate];
////    [backView removeFromSuperview];
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_CALD"];
//
//
//
//
//    AppDelegate_iPhone *app = (AppDelegate_iPhone *)[UIApplication sharedApplication].delegate;
//    app.window.userInteractionEnabled = NO;
//
//    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
//    [yearFormatter setDateFormat:@"yyyy"];
//
//    [self performSelector:@selector(weekCalendartoMonthCalendar) withObject:nil afterDelay:0];
}

-(void)weekCalendartoMonthCalendar
{
    if(!_calViewController)
    {
        //初始化日历
        _calViewController = [[MonthCal2ViewController alloc] initWithNibName:@"MonthCal2ViewController" bundle:nil];
        _calViewController.delegate = self;
        _calViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
        _calViewController.view.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_calViewController.view];
    }
    else
    {
        [_calViewController reloadTableView:_kalViewController.selectedDate];
    }
    
    [self changeWeekCalendartoMonthCalendar:[_calViewController rectInShowCalendarView:_kalViewController.selectedDate]];
    _isShowMonthCalendar = YES;

}


-(void)monthCalendartoWeekCalendarAnimationfromRect:(CGRect) fromRect
{
    
    
    AppDelegate_iPhone *app = (AppDelegate_iPhone *)[UIApplication sharedApplication].delegate;
    fromRect = CGRectMake(fromRect.origin.x,
                          fromRect.origin.y - app.overViewController.calViewController._tableView.contentOffset.y  + app.overViewController.calViewController._tableView.top,
                          fromRect.size.width,
                          fromRect.size.height);
    
    double BottomHeight = 49;
    
    app.window.userInteractionEnabled = NO;
    
    //获取month calendar 的Image
    UIImage *oldImage = [PlannerClass getImageFromView:app.overViewController.scrollView size:app.overViewController.scrollView.frame.size];
    
    //获取上半部分的图片
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, fromRect.origin.y + fromRect.size.height);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(oldImage, 1.f)];
    [imageData writeToFile:[NSString stringWithFormat:@"%@topImage.jpg", [paths objectAtIndex:0]] atomically:YES];
    
    //获取下半部分的图片
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    bottomImgView.image = oldImage;
    bottomImgView.clipsToBounds = YES;
    bottomImgView.contentMode = UIViewContentModeBottom;
    bottomImgView.alpha = 1.0;
    bottomImgView.frame = CGRectMake(0, topImgView.height, oldImage.size.width, oldImage.size.height - topImgView.height);
    
    
    //month->week
    [app.overViewController.view insertSubview:app.overViewController.overViewWeekView aboveSubview:app.overViewController.scrollView];
    UIView *superView = app.overViewController.overViewWeekView;
    
    
    //新页面
    UIImage *newImage = [PlannerClass getImageFromView:superView size:superView.frame.size];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, topImgView.top + topImgView.height,
                                   newImage.size.width,
                                   [UIScreen mainScreen].bounds.size.height - 64 - BottomHeight);
    
    UIImageView *_bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _bottomImgView.image = newImage;
    _bottomImgView.clipsToBounds = YES;
    _bottomImgView.contentMode = UIViewContentModeBottom;
    _bottomImgView.alpha = 1.0;
    _bottomImgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - BottomHeight,
                                      newImage.size.width, BottomHeight);
    
    //    for (UIView *subView in superView.subviews) {
    //        subView.hidden = YES;
    //    }
    [superView addSubview:_topImgView];
    [superView addSubview:topImgView];
    [superView addSubview:bottomImgView];
    [superView addSubview:_bottomImgView];
    [app.overViewController.view bringSubviewToFront:app.overViewController.headerView];
    
    
    
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         bottomImgView.alpha = 0.0;
                         _topImgView.top = 0;
                         topImgView.top = -topImgView.height;
                         bottomImgView.top = oldImage.size.height;
                         //                         app.overViewController.monthLabel.text =
                     }
                     completion:^(BOOL finished){
                         [_topImgView removeFromSuperview];
                         [topImgView removeFromSuperview];
                         [bottomImgView removeFromSuperview];
                         [_bottomImgView removeFromSuperview];
                         app.window.userInteractionEnabled = YES;
                         //add
                         _calViewController.view.hidden = YES;
                         //                         for (UIView *subView in superView.subviews) {
                         //                             subView.hidden = NO;
                         //                         }
                     }];
    
    
    
}

-(void)changeWeekCalendartoMonthCalendar:(CGRect)toRect
{
    //回到月份日历
    AppDelegate_iPhone *app = (AppDelegate_iPhone *)[UIApplication sharedApplication].delegate;
    app.window.userInteractionEnabled = NO;
    //add
    _calViewController.view.hidden = NO;
    //获取daily calendar截图
    UIImage *oldImage = [PlannerClass getImageFromView:_kalContailView size:_kalContailView.frame.size];
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, oldImage.size.height);
    
    [self.view bringSubviewToFront:_scrollView];
    UIView *superView = _calViewController.view;//month calendar viewController
    
    //month calendar 截图
    UIImage *newImage = [PlannerClass getImageFromView:superView size:superView.frame.size];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, -(toRect.origin.y + toRect.size.height),
                                   newImage.size.width,
                                   toRect.origin.y + toRect.size.height);
    
    UIImageView *_middleImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _middleImgView.image = newImage;
    _middleImgView.clipsToBounds = YES;
    _middleImgView.contentMode = UIViewContentModeBottom;
    _middleImgView.alpha = 1.0;
    _middleImgView.frame = CGRectMake(0, newImage.size.height,
                                      newImage.size.width, newImage.size.height - _topImgView.height);
    
    [superView addSubview:topImgView];
    [superView addSubview:_topImgView];
    [superView addSubview:_middleImgView];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _topImgView.top = 0;
                         _middleImgView.top = _topImgView.height;
                     }
                     completion:^(BOOL finished){
                         [_topImgView removeFromSuperview];
                         [topImgView removeFromSuperview];
                         [_middleImgView removeFromSuperview];
                         
                         app.window.userInteractionEnabled = YES;
                     }];
    [self.view bringSubviewToFront:_headerView];
    [UIView animateWithDuration:0.1 animations:^{
        _headerView.frame=CGRectMake(0, 0,SCREEN_WIDTH, 64);
    }];
}
-(void)billBtnPressed:(id)sender
{
    _billsViewController = [[BillsViewController alloc]initWithNibName:@"BillsViewController" bundle:nil];
    //隐藏tabbar
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    _billsViewController.hidesBottomBarWhenPushed = TRUE;
    appDelegate.customerTabbarView.hidden = YES;
    [self.navigationController pushViewController:_billsViewController animated:YES];
}

-(void)settingBtnPressed:(UIButton *)sender{
    self.settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self.settingViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)movetoSelectedDate:(NSDate *)tmpDate{
    self.kalViewController.logic.baseDate = tmpDate;
    [self.kalViewController didSelectDate:[KalDate_week dateFromNSDate:tmpDate]];
    //新加的一句
//    [self.kalViewController.kalView.gridView changeMonthViewToWeekView];
}



- (void)addSubviewsToHeaderView:(UIView *)headerView withDate:(NSDate *)date
{
    for (UIView *view in _headerView.subviews)
    {
        [view removeFromSuperview];
    }
    topDataArray=[NSMutableArray array];
    [self getTopViewDatawithDate:date];
    for (id oneObject in headerView.subviews)
    {
        [oneObject removeFromSuperview];
    }
    
    NSMutableArray *weekdayNames = [[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S",nil];
    
    //设置星期
    int firstWeekday = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekday = 2;
    }
    //设置标题
    NSUInteger i = firstWeekday-1;
    
    double  tmpLabelWith = SCREEN_WIDTH/7.0;
    for (CGFloat xOffset = 0.f; xOffset < SCREEN_WIDTH; xOffset += tmpLabelWith, i = (i+1)%7)
    {
        CGRect weekdayFrame = CGRectMake(xOffset-4, 49, tmpLabelWith-10, 12);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        weekdayLabel.textColor = [UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1];
        
        [weekdayLabel setTextAlignment:NSTextAlignmentRight];
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [headerView addSubview:weekdayLabel];
    }
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
    line.backgroundColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
    [headerView addSubview:line];
    
    //构建topView数据显示
    NSArray *labelArray=@[NSLocalizedString(@"VC_INCOME", nil),NSLocalizedString(@"VC_EXPENSE", nil),NSLocalizedString(@"VC_BALANCE", nil)];
    for (int i=0; i<3; i++)
    {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 7, SCREEN_WIDTH/3, 14)];
        label.text=[labelArray objectAtIndex:i];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
        label.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        [headerView addSubview:label];
    }
    
    UIColor *green=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
    UIColor *red=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    UIColor *gray=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    NSMutableArray *colorArray=[NSMutableArray arrayWithObjects:green,red,gray, nil];

    for (int i=0; i<3; i++)
    {
        UILabel *amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 24, SCREEN_WIDTH/3, 17)];
        [amountLabel setTextAlignment:NSTextAlignmentCenter];
        amountLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
        double value=[[topDataArray objectAtIndex:i]doubleValue];
        if (value>999999999 || value<-999999999)
        {
            amountLabel.text=[NSString stringWithFormat:@"%@m",[appDelegate.epnc formatterString:value/1000000]];
        }
        else if(value>999999 || value <-999999)
        {
            amountLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:value/1000]];
        }
        else
        {
            amountLabel.text=[appDelegate.epnc formatterString:value];
        }
        amountLabel.textColor=[colorArray objectAtIndex:i];
        [headerView addSubview:amountLabel];
    }
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 6, SCREEN_SCALE, 37)];
    line1.backgroundColor=[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    [headerView addSubview:line1];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 6, SCREEN_SCALE, 37)];
    line2.backgroundColor=[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1];
    [headerView addSubview:line2];
    
}
//得到topView当前显示月份数据
-(void)getTopViewDatawithDate:(NSDate *)date
{
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//
//
//    
//    [topDataArray removeAllObjects];
//    NSError *error = nil;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
//    [fetchRequest setPredicate:predicate];
//    
//    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *tmpTransactionsArray = [[NSMutableArray alloc] initWithArray:objects];
//    
//    float monthIncomeAmount=0;
//    float monthExpenseAmount=0;
//    
//    for (Transaction *transaction in tmpTransactionsArray)
//    {
//        NSDate *tranDate=transaction.dateTime;
//        //获取当月trans,分析
//        if ([tranDate compare:date] == 1 && [tranDate compare:endDate] == -1)
//        {
//            if ([transaction.category.categoryType isEqualToString:@"EXPENSE"])
//            {
//                monthExpenseAmount += [transaction.amount doubleValue];
//            }
//            else if ([transaction.category.categoryType isEqualToString:@"INCOME"])
//            {
//                monthIncomeAmount += [transaction.amount doubleValue];
//            }
//            else if(transaction.category == nil && transaction.expenseAccount!= nil )
//            {
//                monthExpenseAmount += [transaction.amount doubleValue];
//            }
//            else if (transaction.category ==nil && transaction.incomeAccount!= nil)
//            {
//                monthIncomeAmount += [transaction.amount doubleValue];
//            }
//        }
//    }
//    float monthBalanceAmount=monthIncomeAmount - monthExpenseAmount;
    
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *endDate = [appDelegete.epnc getEndDateDateType:2 withStartDate:date];

    NSError *error =nil;
    
    
   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:date,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    
    double totalSpend = 0;
    double totalIncome =0;
    double netWorth = 0;
    for (int i=0; i<[objects1 count]; i++)
    {
        Transaction *oneTransaction =[objects1 objectAtIndex:i];
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

    
    
    [topDataArray addObject:[NSNumber numberWithFloat:totalIncome]];
    [topDataArray addObject:[NSNumber numberWithFloat:totalSpend]];
    netWorth = [appDelegete.epdc getSelectedMonthNetWorth:endDate isMonthViewControllerBalance:YES];

    [topDataArray addObject:[NSNumber numberWithFloat:netWorth]];
}
#pragma mark budget Methed




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

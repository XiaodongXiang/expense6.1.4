//
//  BillsViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-2.
//
//

#import "BillsViewController.h"

#import "BillEditViewController.h"
#import "AppDelegate_iPhone.h"
#import "HMJButton.h"

#import "PokcetExpenseAppDelegate.h"
#import "EPNormalClass.h"
#import "EPDataBaseModifyClass.h"
#import "CalenderListView.h"
#import "PaymentViewController.h"
#import "KalDate_bill_iPhone.h"

#import "AccountEditViewController.h"
#import "BillMonthMark.h"
#import "EventKitDataSource_bill_iPhone.h"
#import "UIViewAdditions.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"
#import "CustomBillCell.h"

#import "UIViewController+MMDrawerController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface BillsViewController ()
{
    UILabel *monthLabel;
    UILabel *amountLabel;
}
@property (weak, nonatomic) IBOutlet UIImageView *emptyStateView;
@end

@implementation BillsViewController


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

    [self initPoint];
    [self initNavStyle];
    [self initKalView];
    [self resetData];

    self.bvc_tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.bvc_tableView.separatorColor = RGBColor(226, 226, 226);
    
    self.emptyStateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.bvc_tableView.height - 50);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    appDelegate.customerTabbarView.hidden = YES;
//    appDelegate.adsView.hidden = YES;
//
//
//    __weak UIViewController *slf = self;
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
//    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
//        BOOL shouldRecongize=NO;
//        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
//        {
//            CGPoint location = [touch locationInView:slf.view];
//            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 150, SCREEN_HEIGHT), location);
//            [appDelegate.menuVC reloadView];
//        }
//
//        return shouldRecongize;
//    }];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}
-(void)refleshUI{
    if (self.billEditViewController != nil)
    {
        [self.billEditViewController refleshUI];
    }
    else if (self.paymentViewController !=nil){
        [self.paymentViewController refleshUI];
    }
    else
    {
        [self resetData];
    }
}

#pragma mark View Didload Method
-(void)initPoint{
    _noRecordLabel.text = NSLocalizedString(@"VC_NoBills", nil);

    //最开始的时候是在 tableView中l[
    _bvc_calenderBtn.selected = NO;
    [_bvc_calenderBtn addTarget:self action:@selector(bvc_calenderBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bvc_addBtn addTarget:self action:@selector(bvc_addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _c = [[NSDateComponents alloc] init];

    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.bvc_MonthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate  date]];
    self.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.bvc_MonthStartDate];
    
    _bvc_Bill1Array = [[NSMutableArray alloc]init];
    _bvc_bill2Array = [[NSMutableArray alloc]init];
    _bvc_BillAllArray = [[NSMutableArray alloc]init];
    _bvc_unpaidArray = [[NSMutableArray alloc]init];
    _bvc_paidArray = [[NSMutableArray alloc]init];
    _bvc_monthTableViewExpiredDataArray = [[NSMutableArray alloc]init];
    
    _outputFormatterCell = [[NSDateFormatter alloc] init];
	_outputFormatterCell.dateStyle = NSDateFormatterMediumStyle;
    _outputFormatterCell.timeStyle = NSDateFormatterNoStyle;
    [_outputFormatterCell setLocale:[NSLocale currentLocale]];
    
    totalExpenseAmount = 0;
    totalExpensePaidAmount = 0;
    
    _swipIndex = nil;
    _swipIntergerCalendar =-1;
    _bvc_deleteIndex = nil;
    
    ////////payment view
    _bvc_dateFormatter = [[NSDateFormatter alloc]init];
    [_bvc_dateFormatter setDateFormat:@"MMM/dd"];
    _bvc_indexOfBill = -1;
    [_bvc_cancleBtn addTarget:self action:@selector(paymentCancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bvc_payBtn addTarget:self action:@selector(paymentPayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _bvc_selectedPaymentBillArray = [[NSMutableArray alloc]init];
    
    _bl_bill1Array= [[NSMutableArray alloc]init];
    _bl_bill2Array= [[NSMutableArray alloc]init];
    _bl_totalBillsArray= [[NSMutableArray alloc]init];
    _bl_pastMutableArray= [[NSMutableArray alloc]init];
    _bl_7MutableArray= [[NSMutableArray alloc]init];
    _bl_30MutableArray= [[NSMutableArray alloc]init];
    
    //获取日历
    NSCalendar *cal = [NSCalendar currentCalendar];
    //当天
    NSDate *tempToday = [NSDate date];
    //日历组成单元标识
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //日历组成单元
    NSDateComponents *components = [cal components:flags fromDate:tempToday];
    //设置组成单元
    [components setMonth:components.month];
    [components setDay:components.day + 30];
    self.thirtyDaysLater =[[NSCalendar  currentCalendar]dateFromComponents:components];
    
    NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [parts1 setHour:0];
    [parts1 setMinute:0];
    [parts1 setSecond:0];
    self.yestary= [[NSCalendar currentCalendar] dateFromComponents:parts1];
    
    NSDateComponents *parts2 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [parts2 setHour:0];
    [parts2 setMinute:0];
    [parts2 setSecond:0];
    [parts2 setDay:parts2.day+7];
    self.sevendaysLater= [[NSCalendar currentCalendar] dateFromComponents:parts2];

}

-(void)initKalView
{
    AppDelegate_iPhone *appdelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //day
    double monthKalViewHigh = 48;
    _bvc_kalLogic = [[KalLogic_bill_iPhone alloc] init];
    
    double kalViewHigh = self.view.frame.size.height-monthKalViewHigh;
//    if (self.view.bounds.size.height <[UIScreen mainScreen].bounds.size.height)
//        kalViewHigh = self.view.frame.size.height-monthKalViewHigh -20;
    
    _bvc_kalView = [[KalView_bill_iPhone alloc] initWithFrame:CGRectMake(0,monthKalViewHigh, SCREEN_WIDTH, kalViewHigh) delegate:self logic:_bvc_kalLogic withShowModule:FALSE];
    _bvc_kalView.delegate = self;
    self.dataSource = [[EventKitDataSource_bill_iPhone alloc] init];
    _bvc_kalView.tableView.delegate = self.dataSource;
    _bvc_kalView.tableView.dataSource = self.dataSource;
//    [_bvc_kalViewAndMonthViewContainView addSubview:_bvc_kalView];
    
    //month
    _kalLogic = [[HMJMonthLogic alloc] init];
	_kalView = [[HMJMonthView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, monthKalViewHigh) delegate:self logic:_kalLogic withShowModule:FALSE];
    _kalView.delegate = self;
    _kalView.clipsToBounds = YES;
    _kalView.backgroundColor = [UIColor whiteColor];
//    [_bvc_kalViewAndMonthViewContainView addSubview:_kalView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    UIView *back=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    back.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
//    [_bvc_kalViewAndMonthViewContainView addSubview:back];
    
    monthLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 11, 150, 20)];
    NSString *stringDate=[dateFormatter stringFromDate:_bvc_MonthStartDate];
    monthLabel.text=stringDate;
    monthLabel.textColor=[UIColor whiteColor];
    monthLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    monthLabel.textAlignment=NSTextAlignmentCenter;
    [back addSubview:monthLabel];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 4, 40, 40)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"buttion_arrow_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(monthChangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=101;
    [back addSubview:leftBtn];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90-10, 4, 40, 40)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"buttion_arrow_right"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(monthChangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=102;
    [back addSubview:rightBtn];
    

    
    [self getCurrentMonthBillArrayandReloadDayKalView];
    
    float monthAmount=0;
    for (BillFather *father in _bvc_BillAllArray)
    {
        monthAmount+=father.bf_billAmount;
    }
    NSString *str=[appdelegate.epnc formatterString:monthAmount];
    
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10],NSFontAttributeName, nil];
    CGRect titleSize = [str boundingRectWithSize:CGSizeMake(150, 12) options:NSStringDrawingTruncatesLastVisibleLine attributes:tmpAttr context:nil];
    
    amountLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-titleSize.size.width-12)/2, 32, titleSize.size.width+12, 12)];
    
    amountLabel.backgroundColor=[UIColor colorWithRed:88/255.0 green:162/255.0 blue:207/255.0 alpha:1];
    amountLabel.textColor=[UIColor whiteColor];
    amountLabel.textAlignment=NSTextAlignmentCenter;
    amountLabel.text=str;
    amountLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:10];
    CALayer *layer=amountLabel.layer;
    layer.cornerRadius=6.0f;
    [back addSubview:amountLabel];
    
    amountLabel.layer.masksToBounds=YES;
    
}
-(void)monthChangeBtnClick:(id)sender
{
    AppDelegate_iPhone *appdelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    UIButton *btn=sender;
    NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp=[[NSDateComponents alloc]init];
    [comp setYear:0];
    [comp setDay:0];
    if (btn.tag==101)
    {
        [comp setMonth:-1];
        _bvc_MonthStartDate=[cal dateByAddingComponents:comp toDate:_bvc_MonthStartDate options:nil];
        _bvc_MonthEndDate=[cal dateByAddingComponents:comp toDate:_bvc_MonthEndDate options:nil];
    }
    else if(btn.tag==102)
    {
        [comp setMonth:1];
        _bvc_MonthStartDate=[cal dateByAddingComponents:comp toDate:_bvc_MonthStartDate options:nil];
        _bvc_MonthEndDate=[cal dateByAddingComponents:comp toDate:_bvc_MonthEndDate options:nil];
    }
    [self getCurrentMonthBillArrayandReloadDayKalView];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *stringDate=[dateFormatter stringFromDate:_bvc_MonthStartDate];
    monthLabel.text=stringDate;
    
    float monthAmount=0;
    for (BillFather *father in _bvc_BillAllArray)
    {
        monthAmount+=father.bf_billAmount;
    }
    NSString *str=[appdelegate.epnc formatterString:monthAmount];;
    
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10],NSFontAttributeName, nil];
    CGRect titleSize = [str boundingRectWithSize:CGSizeMake(150, 12) options:NSStringDrawingTruncatesLastVisibleLine attributes:tmpAttr context:nil];
    amountLabel.frame=CGRectMake((SCREEN_WIDTH-titleSize.size.width-12)/2, 32, titleSize.size.width+12, 12);
    amountLabel.text=str;
    
}
-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Bills", nil);

    
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -6.f;

    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc] initWithCustomView:_bvc_rightNavBarContainView];
	self.navigationItem.rightBarButtonItems = @[flexible,rightBar];
    _bvc_calenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bvc_calenderBtn.frame = CGRectMake(20, 0, 30,44);
    [_bvc_calenderBtn setImage:[UIImage imageNamed:@"button_calander"] forState:UIControlStateNormal];
    [_bvc_calenderBtn setImage:[UIImage imageNamed:@"button_calander_list"] forState:UIControlStateSelected];
    [_bvc_calenderBtn addTarget:self action:@selector(bvc_calenderBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bvc_rightNavBarContainView addSubview:_bvc_calenderBtn];
}
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)resetCalendarStyle
{
    
    [_bvc_kalView addSubviewsToHeaderView:_bvc_kalView.headerView];
    
    [_bvc_kalView jumpToSelectedMonth];
}

#pragma mark View Will Appear Method
//获取30天之内的bill以及五个月份的bill
-(void)resetData{
    self.paymentViewController = nil;
    self.billEditViewController = nil;
    [self getBillListArray];
    [self get5MonthBillArray];
}

//重新获取选中的五个月的bill数据
-(void)get5MonthBillArray
{
    [_bvc_monthTableViewExpiredDataArray removeAllObjects];
    for (int i=0; i<5; i++) {
        BillMonthMark *oneBillMonth = [[BillMonthMark alloc]init];
        oneBillMonth.unClearedNum = 0;
        [_bvc_monthTableViewExpiredDataArray addObject:oneBillMonth];
    }
    
    [self getFirstTileMonthData];
    [self getSecondTileMonthData];
    [self getThirdTileMonthData];
    [self getForthTileMonthData];
    [self getFirthTileMonthData];
    
    for (int i=0; i<[_bvc_monthTableViewExpiredDataArray count]; i++)
    {
//        BillMonthMark *oneBillMonth = [_bvc_monthTableViewExpiredDataArray objectAtIndex:i];
    }
//    [self getSecondTileMonthData];
    
//    //刷新month calendar
//    [self showSelected5Month];
    [_kalView setNeedsDisplay];
    //刷新这个月份的日历
//    [self  showSelectedMonth];

    
    [self getCurrentMonthBillArrayandReloadDayKalView];
    
    //加载选中日期的数据
    [self reloadData];
}

//获取当前选中month的data
-(void)getSelectedMonthData
{
    
    [_bvc_Bill1Array removeAllObjects];
    [_bvc_bill2Array removeAllObjects];
    [_bvc_BillAllArray removeAllObjects];
    [_bvc_unpaidArray removeAllObjects];
    [_bvc_paidArray removeAllObjects];
    
    
    totalExpenseAmount = 0;
    totalExpensePaidAmount = 0;
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //获取bill1中的数据
    [self getBillRuleArray:_bvc_MonthStartDate endDate:_bvc_MonthEndDate array:_bvc_Bill1Array];
    [self useBill1CreateAllBill:_bvc_Bill1Array totalArray:_bvc_BillAllArray startDate:self.bvc_MonthStartDate endDate:self.bvc_MonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:self.bvc_MonthStartDate endDate:self.bvc_MonthEndDate array:_bvc_bill2Array];
    [self useBill2CreateAllBill:_bvc_bill2Array allArray:_bvc_BillAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num = 0;
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [_bvc_BillAllArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [_bvc_BillAllArray setArray:ar];
    
    for (int i=0; i<[_bvc_BillAllArray count]; i++) {
        BillFather *oneBillFather = [_bvc_BillAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        totalExpenseAmount += oneBillFather.bf_billAmount;//totalExpenseAmount
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
                totalExpensePaidAmount += [oneTransaction.amount doubleValue];//totalExpensePaidAmount

            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++ ;
            }
            [_bvc_unpaidArray addObject:oneBillFather];
        }
        else
            [_bvc_paidArray addObject:oneBillFather];
    }
}
//获取month日历选中那个月份的数据，isReplace表示是否替换bvc_monthTableViewExpiredDataArray数组中的数据
-(void)getFirstTileMonthData{
    
    NSMutableArray *firstMonth_bill1Array = [[NSMutableArray alloc]init];
    NSMutableArray *firstMonth_bill2Array = [[NSMutableArray alloc]init];
    NSMutableArray *firstMonth_billAllArray = [[NSMutableArray alloc]init];
    [firstMonth_bill1Array removeAllObjects];
    [firstMonth_bill2Array removeAllObjects];
    [firstMonth_billAllArray removeAllObjects];
    
    totalExpenseAmount = 0;
    totalExpensePaidAmount = 0;
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //获取bill1中的数据
    NSDate *thisMonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.kalLogic.fromDate];
    
    [self getBillRuleArray:self.kalLogic.fromDate endDate:thisMonthEndDate array:firstMonth_bill1Array];
    [self useBill1CreateAllBill:firstMonth_bill1Array totalArray:firstMonth_billAllArray startDate:self.kalLogic.fromDate endDate:thisMonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:self.kalLogic.fromDate endDate:thisMonthEndDate array:firstMonth_bill2Array];
    [self useBill2CreateAllBill:firstMonth_bill2Array allArray:firstMonth_billAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num = 0;
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [firstMonth_billAllArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [firstMonth_billAllArray setArray:ar];
    
    for (int i=0; i<[firstMonth_billAllArray count]; i++) {
        BillFather *oneBillFather = [firstMonth_billAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        totalExpenseAmount += oneBillFather.bf_billAmount;//totalExpenseAmount
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
                
                totalExpensePaidAmount += [oneTransaction.amount doubleValue];//totalExpensePaidAmount
            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++ ;
            }
        }
  
    }
    
    BillMonthMark *mark1 =  [[BillMonthMark alloc]init];
    if (hasExpiredBill) {
        mark1.unClearedNum = num;
        mark1.date = self.kalLogic.fromDate;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:0 withObject:mark1];
    }
    else
    {
        mark1.unClearedNum = 0;
        mark1.date = self.kalLogic.fromDate;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:0 withObject:mark1];
    }

}

//获取从左边数第二个tile的日期
-(void)getSecondTileMonthData{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents *startcomponent = [[NSDateComponents alloc] init];
    
    [startcomponent setMonth:1];
    
    NSDate *lastMonthStartDate = [cal dateByAddingComponents:startcomponent toDate:self.kalLogic.fromDate options:0];
    NSDate *lastMonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:lastMonthStartDate];
    
    NSMutableArray *lastMonth_bill1Array = [[NSMutableArray alloc]init];
    NSMutableArray *lastMonth_bill2Array = [[NSMutableArray alloc]init];
    NSMutableArray *lastMonth_billAllArray = [[NSMutableArray alloc]init];
    
    [self getBillRuleArray:self.bvc_MonthStartDate endDate:lastMonthEndDate array:lastMonth_bill1Array];
    [self useBill1CreateAllBill:lastMonth_bill1Array totalArray:lastMonth_billAllArray startDate:lastMonthStartDate endDate:lastMonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:lastMonthStartDate endDate:lastMonthEndDate array:lastMonth_bill2Array];
    [self useBill2CreateAllBill:lastMonth_bill2Array allArray:lastMonth_billAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num=0;
    for (int i=0; i<[lastMonth_billAllArray count]; i++) {
        BillFather *oneBillFather = [lastMonth_billAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++;
            }
        }
    }
    
    BillMonthMark *mark1 =  [[BillMonthMark alloc]init];
    if (hasExpiredBill) {
        mark1.unClearedNum = num;
        mark1.date =lastMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:1 withObject:mark1];
    }
    else
    {
        mark1.unClearedNum = 0;
        mark1.date =lastMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:1 withObject:mark1];
    }

    
}

//获取左边数第三个tile的date
-(void)getThirdTileMonthData{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents *startcomponent = [[NSDateComponents alloc] init];
    
    [startcomponent setMonth:2];
    
    
    NSDate *lastSecondMonthStartDate = [cal dateByAddingComponents:startcomponent toDate:self.kalLogic.fromDate options:0];
    NSDate *lastSecondMonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:lastSecondMonthStartDate];
    
    NSMutableArray *lastSecondMonth_bill1Array = [[NSMutableArray alloc]init];
    NSMutableArray *lastSecondMonth_bill2Array = [[NSMutableArray alloc]init];
    NSMutableArray *lastSecondMonth_billAllArray = [[NSMutableArray alloc]init];
    
    [self getBillRuleArray:self.bvc_MonthStartDate endDate:lastSecondMonthEndDate array:lastSecondMonth_bill1Array];
    [self useBill1CreateAllBill:lastSecondMonth_bill1Array totalArray:lastSecondMonth_billAllArray startDate:lastSecondMonthStartDate endDate:lastSecondMonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:lastSecondMonthStartDate endDate:lastSecondMonthEndDate array:lastSecondMonth_bill2Array];
    [self useBill2CreateAllBill:lastSecondMonth_bill2Array allArray:lastSecondMonth_billAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num=0;
    for (int i=0; i<[lastSecondMonth_billAllArray count]; i++) {
        BillFather *oneBillFather = [lastSecondMonth_billAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        totalExpenseAmount += oneBillFather.bf_billAmount;//totalExpenseAmount
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
                
                totalExpensePaidAmount += [oneTransaction.amount doubleValue];//totalExpensePaidAmount
            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++;
            }
        }
    }
    
    BillMonthMark *mark1 =  [[BillMonthMark alloc]init];
    if (hasExpiredBill) {
        mark1.unClearedNum = num;
        mark1.date = lastSecondMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:2 withObject:mark1];
    }
    else
    {
        mark1.unClearedNum = 0;
        mark1.date = lastSecondMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:2 withObject:mark1];
    }

    
}

-(void)getForthTileMonthData{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents *startcomponent = [[NSDateComponents alloc] init] ;
    
    [startcomponent setMonth:3];
    
    NSDate *nextMonthStartDate = [cal dateByAddingComponents:startcomponent toDate:self.kalLogic.fromDate options:0];
    NSDate *nextMonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:nextMonthStartDate];
    
    NSMutableArray *nextMonth_bill1Array = [[NSMutableArray alloc]init];
    NSMutableArray *nextMonth_bill2Array = [[NSMutableArray alloc]init];
    NSMutableArray *nextMonth_billAllArray = [[NSMutableArray alloc]init];
    
    [self getBillRuleArray:self.bvc_MonthStartDate endDate:nextMonthEndDate array:nextMonth_bill1Array];
    [self useBill1CreateAllBill:nextMonth_bill1Array totalArray:nextMonth_billAllArray startDate:nextMonthStartDate endDate:nextMonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:nextMonthStartDate endDate:nextMonthEndDate array:nextMonth_bill2Array];
    [self useBill2CreateAllBill:nextMonth_bill2Array allArray:nextMonth_billAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num=0;
    for (int i=0; i<[nextMonth_billAllArray count]; i++) {
        BillFather *oneBillFather = [nextMonth_billAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];

            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++;
            }
        }
    }
    
    BillMonthMark *mark1 =  [[BillMonthMark alloc]init];
    if (hasExpiredBill) {
        mark1.unClearedNum = num;
        mark1.date = nextMonthEndDate;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:3 withObject:mark1];
    }
    else
    {
        mark1.unClearedNum = 0;
        mark1.date = nextMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:3 withObject:mark1];
    }

    
}

-(void)getFirthTileMonthData{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents *startcomponent = [[NSDateComponents alloc] init] ;
    
    [startcomponent setMonth:4];
    
    NSDate *nextSecondMonthStartDate = [cal dateByAddingComponents:startcomponent toDate:self.kalLogic.fromDate options:0];
    NSDate *nextSecondMonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:nextSecondMonthStartDate];
    
    NSMutableArray *nextSecondMonth_bill1Array = [[NSMutableArray alloc]init];
    NSMutableArray *nextSecondMonth_bill2Array = [[NSMutableArray alloc]init];
    NSMutableArray *nextSecondMonth_billAllArray = [[NSMutableArray alloc]init];
    
    [self getBillRuleArray:self.bvc_MonthStartDate endDate:nextSecondMonthEndDate array:nextSecondMonth_bill1Array];
    [self useBill1CreateAllBill:nextSecondMonth_bill1Array totalArray:nextSecondMonth_billAllArray startDate:nextSecondMonthStartDate endDate:nextSecondMonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:nextSecondMonthStartDate endDate:nextSecondMonthEndDate array:nextSecondMonth_bill2Array];
    [self useBill2CreateAllBill:nextSecondMonth_bill2Array allArray:nextSecondMonth_billAllArray];
    
    BOOL  hasExpiredBill = NO;
    int num=0;
    for (int i=0; i<[nextSecondMonth_billAllArray count]; i++) {
        BillFather *oneBillFather = [nextSecondMonth_billAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
            }
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
                hasExpiredBill = YES;
                num ++;

            }
        }
    }
    
    BillMonthMark *mark1 =  [[BillMonthMark alloc]init];
    
    if (hasExpiredBill) {
        mark1.unClearedNum = num;
        mark1.date = nextSecondMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:4 withObject:mark1];
    }
    else
    {
        mark1.unClearedNum = 0;
        mark1.date = nextSecondMonthEndDate ;
        [_bvc_monthTableViewExpiredDataArray  replaceObjectAtIndex:4 withObject:mark1];
    }

}

//获取bill1中的数据
-(void)getBillRuleArray:(NSDate *)startDate endDate:(NSDate *)endDate array:(NSMutableArray *)array{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:endDate,@"startDate",nil];
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBillRulebyDate" substitutionVariables:sub];
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    [array setArray:objects];

    NSMutableArray *tmpBill1Array = [[NSMutableArray alloc]init];
    for (int i=0; i<[array count]; i++) {
        EP_BillRule *oneBill = [array objectAtIndex:i];
        if ([appDelegate.epnc dateCompare:oneBill.ep_billEndDate withDate:startDate]>=0) {
            [tmpBill1Array insertObject:oneBill atIndex:[tmpBill1Array count]];
//            [_bvc_Bill1Array removeObjectAtIndex:i];
        }
    }
    
    [array setArray:tmpBill1Array];
}

-(void)getBillItemArray:(NSDate *)startDate endDate:(NSDate *)endDate array:(NSMutableArray *)array{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBill2byDate" substitutionVariables:sub];
    
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    [array setArray:objects];

}

//通过bill1创建billfather
-(void)useBill1CreateAllBill:(NSMutableArray *)bill1Array totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    for (int i=0; i<[bill1Array count]; i++) {
        EP_BillRule *oneBill = [bill1Array objectAtIndex:i];
        [self setBillFathferbyBillRule:oneBill totalArray:totalArray  startDate:startDate endDate:endDate];
    }
}

-(void)setBillFathferbyBillRule:(EP_BillRule *)bill totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"]){
        
        if (([appDelegate.epnc  dateCompare:bill.ep_billDueDate withDate:startDate]>=0 && [appDelegate.epnc dateCompare:bill.ep_billDueDate withDate:endDate]<=0)) {
            BillFather *billFateher = [[BillFather alloc]init];
            
            [appDelegate.epdc editBillFather:billFateher withBillRule:bill withDate:nil];
            
            [totalArray addObject:billFateher];
            return;
        }
        
    }
    //如果是循环账单
    else{
        NSDate *lastDate = [appDelegate.epnc getCycleStartDateByMinDate:startDate withCycleStartDate:bill.ep_billDueDate withCycleType:bill.ep_recurringType isRule:YES] ;
        
        NSDate *endDateorBillEndDate = [appDelegate.epnc dateCompare:endDate withDate:bill.ep_billEndDate]<0?endDate : bill.ep_billEndDate;
        if ([appDelegate.epnc dateCompare:startDate withDate:endDateorBillEndDate]>0) {
            return;
        }
        else{
            //循环创建账单
            while ([appDelegate.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                if ([appDelegate.epnc dateCompare:lastDate withDate:startDate]>=0)
                {
                    BillFather *oneBillfather = [[BillFather alloc]init];
                    
                    [appDelegate.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                    [totalArray  addObject:oneBillfather];
                }
                
                //获取下一次循环的时间
                lastDate= [appDelegate.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}


-(void)useBill2CreateAllBill:(NSMutableArray *)tmpBill2Array allArray:(NSMutableArray *)tmpAllArray{
    for (int i=0; i<[tmpBill2Array count]; i++) {
        EP_BillItem *billObject = [tmpBill2Array objectAtIndex:i];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        //如果被删除了，就从all中删除这个数据
        if ([billObject.ep_billisDelete boolValue]){
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather   *checkedBill = [tmpAllArray objectAtIndex:j];
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                    [tmpAllArray removeObject:checkedBill];
                }
            }
        }
        else{
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather *oneBillfather = [tmpAllArray objectAtIndex:j];
                //相等的话说明是同一件事情，此时需要修改
                if (oneBillfather.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:oneBillfather.bf_billDueDate withDate:billObject.ep_billItemDueDate]==0)
                {
                    [appDelegate.epdc editBillFather:oneBillfather withBillItem:billObject];
                }
            }
        }
        
    }
    
}

//在月份日历上面选中某个月份的时候，调用这个方法
-(void)getCurrentMonthBillArrayandReloadDayKalView
{
    //获取选中这个月的数组
    [self getSelectedMonthData];
    //刷新这个月份的日历
    [self  showSelectedMonth];
    //加载选中日期的数据
    [self reloadData];
}


#pragma mark Btn Action
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

//切换tableView和kalView
-(void)bvc_calenderBtnPressed:(NSIndexPath *)indexPath
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
    _bvc_calenderBtn.selected = !_bvc_calenderBtn.selected;


    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if(_bvc_calenderBtn.selected)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"12_BIL_CALD"];
    }
    else
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"12_BIL_LIST"];

}

-(void)bvc_addBtnPressed:(UIButton *)sender{
    
    self.billEditViewController = [[BillEditViewController alloc]initWithNibName:@"BillEditViewController" bundle:nil];
    self.billEditViewController.typeOftodo = @"ADD";
    if (_bvc_calenderBtn.selected) {
        self.billEditViewController.starttime = [self.bvc_kalView.selectedDate NSDate];
    }
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self.billEditViewController];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

-(void)celleditBtnPressed:(NSIndexPath *)indexPath
{
    self.swipIndex = nil;
    
//    self.billEditViewController = [[BillEditViewController alloc]initWithNibName:@"BillEditViewController" bundle:nil];
    
    BillFather *oneBillFather;
    if (indexPath.section==0) {
        oneBillFather = [_bl_pastMutableArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==1)
        oneBillFather = [_bl_7MutableArray objectAtIndex:indexPath.row];
    else{
        oneBillFather = [_bl_30MutableArray objectAtIndex:indexPath.row];
    }
//    self.billEditViewController .typeOftodo = @"EDIT";
//    self.billEditViewController .billFather = oneBillFather;
    
    if ([self.delegate respondsToSelector:@selector(returnSelectedEditBill:)]) {
        [self.delegate returnSelectedEditBill:oneBillFather];
    }
//    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:self.billEditViewController];
//    [self presentViewController:navigationViewController animated:YES completion:nil];
    
}
-(void)celldeleteBtnPressed:(NSIndexPath *)indexPath isCalenderTableViewBill:(BillFather *)calendarBillFather
{
    BillFather *billFather;
    if (!_bvc_calenderBtn.selected) {
        self.swipIndex = nil;
        
        if (indexPath.section==0) {
            billFather = [_bl_pastMutableArray objectAtIndex:indexPath.row];
        }
        else if(indexPath.section==1)
            billFather = [_bl_7MutableArray objectAtIndex:indexPath.row];
        else
            billFather = [_bl_30MutableArray objectAtIndex:indexPath.row];
    }
    else
    {
        billFather = calendarBillFather;
        _bvc_billFatherCalendar =  calendarBillFather;
    }
    
    
    if (![billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        self.bvc_deleteIndex = indexPath;
//        NSString *meg = [NSString stringWithFormat:@"This is a repeating bill. Do you want to delete this bill, or all future bills for name'%@'?",billFather.bf_billName];
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:billFather.bf_billName];
        NSString *meg = string1;
        
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionsheet;
        return;
    }
    //非循环 删除BK_Bill BK_Payment
    else{
        if (billFather.bf_billRule != nil)
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            NSError *error = nil;
            
            billFather.bf_billRule.state = @"0";
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        
        self.swipIndex = nil;
        self.swipIntergerCalendar = -1;
        _bvc_billFatherCalendar = nil;
    }
    [self resetData];
    
}


#pragma mark KalView Method
- (void)drawSelectedMonthUnpaidPaidMark
{
    [_bvc_kalView paidmarkTilesForDates:_bvc_unpaidArray withDates1:_bvc_paidArray  isTran:FALSE];
	[_bvc_kalView unpaidmarkTilesForDates];
}



//点击日历上面的日期弹出payment View
-(void)didSelectDate:(KalDate_bill_iPhone *)date{
    _bvc_kalView.selectedDate = date ;
    [_dataSource loadItemsforselectedDay];
    [self.bvc_kalView.tableView reloadData];
    [self.bvc_kalView.tableView flashScrollIndicators];
}

-(void)didSelectMonth:(KalDate_bill_iPhone *)date
{
    
}

- (void) setLabelByBill:(BillFather *)tmpbillFather;
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _bvc_dateLabel.text = [_bvc_dateFormatter stringFromDate:tmpbillFather.bf_billDueDate];
    _bvc_categoryImage.image = [UIImage imageNamed:tmpbillFather.bf_category.iconName];
    _bvc_billName.text = tmpbillFather.bf_billName;
    _bvc_amountLabel.text = [appDelegate.epnc formatterString:tmpbillFather.bf_billAmount];
    //expired image
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if (tmpbillFather.bf_billItem != nil) {
        [paymentArray setArray:[tmpbillFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    else if(tmpbillFather.bf_billRule != nil)
        [paymentArray setArray:[tmpbillFather.bf_billRule.billRuleHasTransaction allObjects]];
    
    if ([paymentArray count]==0) {
        if ([appDelegate.epnc dateCompare:tmpbillFather.bf_billDueDate withDate:[NSDate date]]<0) {
            _bvc_expiredImage.image = [UIImage imageNamed:@"mark_red.png"];
        }
        else
            _bvc_expiredImage.image = [UIImage imageNamed:@"mark_gray.png"];
    }
    else{
        if ([appDelegate.epnc dateCompare:tmpbillFather.bf_billDueDate withDate:[NSDate date]]<0) {
            _bvc_expiredImage.image = [UIImage imageNamed:@"mark_red.png"];
        }
        else
            _bvc_expiredImage.image = [UIImage imageNamed:@"mark_green2.png"];
    }
    
    if (![tmpbillFather.bf_billRecurringType isEqualToString:@"Never"]) {
        _bvc_recurringLabel.text = tmpbillFather.bf_billRecurringType;
    }
    else{
        _bvc_recurringImage.hidden = YES;
        _bvc_recurringLabel.hidden = YES;
        _bvc_recurringLabel.text = @"";
    }
    if (![tmpbillFather.bf_billReminderDate isEqualToString:@"None"] &&![tmpbillFather.bf_billReminderDate isEqualToString:@"No Reminder"]) {

        _bvc_reminderLabel.text = tmpbillFather.bf_billReminderDate;
    }
    else{
        _bvc_reminderImage.hidden = YES;
        _bvc_reminderLabel.hidden = YES;
        _bvc_reminderLabel.text = @"";
    }
    
    if (_bvc_reminderImage.hidden && _bvc_recurringImage.hidden) {
        _bvc_categoryImage.frame = CGRectMake(30, 42, 30, 30);
        _bvc_billName.frame = CGRectMake(78, 36, 118, 22);
        _bvc_expiredImage.frame = CGRectMake(80, 63, 8, 8);
        _bvc_amountLabel.frame = CGRectMake(96, 58, 120, 14);
    }
    else{
        _bvc_categoryImage.frame = CGRectMake(30, 42, 30, 30);
        _bvc_billName.frame = CGRectMake(78, 36, 118, 22);
        _bvc_expiredImage.frame = CGRectMake(80, 63, 8, 8);
        _bvc_amountLabel.frame = CGRectMake(96, 58, 120, 14);
    }
}

-(void)showSelectedMonth
{
    //计算选中这个月份所有的日期
    [_bvc_kalLogic retreatToSelectedMonth:self.bvc_MonthStartDate];
    //设置日历的日期
    [_bvc_kalView slideNone];
    [self drawSelectedMonthUnpaidPaidMark];
}

- (void)showPreviousMonth
{
 	[_bvc_kalLogic retreatToPreviousMonth];
	[_bvc_kalView slideDown];
}
- (void)showFollowingMonth
{
 	[_bvc_kalLogic advanceToFollowingMonth];
	[_bvc_kalView slideUp];
}

-(void)reloadData
{
    [_dataSource presentingDatesFrom:self.bvc_MonthStartDate   to:self.bvc_MonthEndDate   delegate:self];
}

- (void)loadedDataSource:(id<KalDataSource_bill_iPhone>)theDataSource;
{
    //  NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    //  NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
    //  for (int i=0; i<[dates count]; i++)
    //    [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    //
    //  [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.bvc_kalView.selectedDate];
}


//这里不对
- (void)showPrevious5Month
{
 	[_kalLogic retreatToPrevious5Monthes];
    [self get5MonthBillArray];
	[_kalView slideDown];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.bvc_MonthStartDate = [_kalView.gridView.selectedTile.date NSDate];
    self.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.bvc_MonthStartDate];
    [self  resetData];
}

//这里不对
- (void)showFollowing5Month
{
 	[_kalLogic advanceToFollowing5Monthes];
	[_kalView slideUp];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.bvc_MonthStartDate = [_kalView.gridView.selectedTile.date NSDate];
    self.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.bvc_MonthStartDate];
    [self  resetData];
}

- (void)showSelected5Month
{
	[_kalView slideNone];
    [_kalView setNeedsDisplay];
}

#pragma mark Payment View Method
-(void)toRight:(id)sender{
    if([_bvc_selectedPaymentBillArray count] == 0) return;
    if(_bvc_indexOfBill == [_bvc_selectedPaymentBillArray count]-1) _bvc_indexOfBill =0;
    else _bvc_indexOfBill ++;
    
    _bvc_pageControl.currentPage = _bvc_indexOfBill;
    BillFather *tmpBillFather = [_bvc_selectedPaymentBillArray objectAtIndex:_bvc_indexOfBill];
    [self setLabelByBill:tmpBillFather ];
}

-(void)toLeft:(id)sender{
    if([_bvc_selectedPaymentBillArray count] == 0) return;
    if(_bvc_indexOfBill == [_bvc_selectedPaymentBillArray count]-1)
    {
        _bvc_indexOfBill =0;
    }
    else{
        _bvc_indexOfBill ++;
    }
    
    _bvc_pageControl.currentPage = _bvc_indexOfBill;
    BillFather *tmpBillFather = [_bvc_selectedPaymentBillArray objectAtIndex:_bvc_indexOfBill];
    [self setLabelByBill:tmpBillFather];
}

-(void)paymentCancelBtnPressed:(id)sender{
    _bvc_paymentView.hidden = YES;
    
    _bvc_calenderBtn.userInteractionEnabled = YES;
    _bvc_addBtn.userInteractionEnabled = YES;
}

-(void)paymentPayBtnPressed:(id)sender{
    _bvc_paymentView.hidden = YES;
    
    self.paymentViewController = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
    BillFather *oneBillFather = [_bvc_selectedPaymentBillArray objectAtIndex:_bvc_indexOfBill];
    self.paymentViewController.billFather = oneBillFather;
    
    [self.navigationController pushViewController:self.paymentViewController animated:YES];
}


#pragma mark UITableView Method
-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_bl_pastMutableArray count]==0 && [_bl_7MutableArray count]==0 && [_bl_30MutableArray count]==0)
    {
        _bvc_tableView.hidden = YES;
//        _noRecordView.hidden = NO;
        self.emptyStateView.hidden = NO;
    }
    else
    {
//        _noRecordView.hidden = YES;
        _bvc_tableView.hidden = NO;
        self.emptyStateView.hidden = YES;
    }
    
    if (section==0)
        return [_bl_pastMutableArray count];
    else if (section==1)
        return [_bl_7MutableArray count];
    return [_bl_30MutableArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 && [_bl_pastMutableArray count]>0) {
        return 36;
    }
    else if (section==1 && [_bl_7MutableArray count]>0)
        return 36;
    else if(section==2 && [_bl_30MutableArray count]>0)
        return 36;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 320, 22)];
    headerView.userInteractionEnabled = NO;
    headerView.backgroundColor = RGBColor(246, 246, 246);

    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 140, 22)];
    if (section==0) {
        typeLabel.text = NSLocalizedString(@"VC_Overdue", nil);
    }
    else if (section==1)
        typeLabel.text = NSLocalizedString(@"VC_DueWithin7Days", nil);
    else
        typeLabel.text = NSLocalizedString(@"VC_DueWithin30Days", nil);
    typeLabel.textColor = [appDelegate_iPhone.epnc getAmountGrayColor];
    [typeLabel setFont:[UIFont fontWithName:FontSFUITextRegular size:12]];
    typeLabel.adjustsFontSizeToFitWidth = YES;
    [typeLabel setMinimumScaleFactor:0];
    typeLabel.textAlignment =NSTextAlignmentLeft;
    typeLabel.textColor = RGBColor(154, 154, 154);
    typeLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:typeLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-165, 14, 150, 22)];
    if (section==0) {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalPastAmount];
        
    }
    else if (section==1)
    {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalSevenDayAmount];
    }
    else
    {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalThirthDayAmount];
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    numLabel.textColor = [appDelegate_iPhone.epnc getAmountGrayColor];;
    [numLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    numLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:numLabel];
    
//    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 22-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
//    line1.backgroundColor = [UIColor colorWithRed:219.f/255.f green:219.f/255.f blue:219.f/255.f alpha:1];
//    [headerView addSubview:line1];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)configureBillsCell:(CustomBillCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    BillFather *billFather;
    cell.leftLabel.textColor = RGBColor(200, 200, 200);

    if(indexPath.section == 0)
    {
        billFather= [_bl_pastMutableArray objectAtIndex:indexPath.row];
        cell.leftLabel.textColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
        
    }
    else if(indexPath.section==1)
    {
        billFather= [_bl_7MutableArray objectAtIndex:indexPath.row];
        [cell.amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];
    }
    else
    {
        billFather = [_bl_30MutableArray objectAtIndex:indexPath.row];
        [cell.amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1.f]];

    }
    //category
    if (billFather.bf_category != nil)
	{
 		cell.categoryIconImage.image = [UIImage imageNamed:billFather.bf_category.iconName];
	}
    
	//name
	cell.nameLabel.text = billFather.bf_billName;
    cell.date = billFather.bf_billDueDate;
    //date
    NSString* time = [_outputFormatterCell stringFromDate:billFather.bf_billDueDate];
	cell.dateLabel.text = time;
    
    CGSize size = [time sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:14]}];
    
    //amount
    //amount
    double lestAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([billFather.bf_billRecurringType isEqualToString:@"Never"])
    {
        [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else
    {
        [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    for (int i=0; i<[paymentArray count]; i++)
    {
        Transaction *onePayment = [paymentArray objectAtIndex:i];
        if ([onePayment.state isEqualToString:@"1"])
        {
            lestAmount += [onePayment.amount doubleValue];
        }
    }
	cell.amountLabel.text = [appDelegate.epnc formatterString:(billFather.bf_billAmount-lestAmount)];
    
    //cycle
    if ([billFather.bf_billNote length]>0) {
        cell.memoImage.hidden = NO;
        cell.memoImage.x = size.width + 10 + 65;
    }
    else
        cell.memoImage.hidden = YES;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BillCell";
	CustomBillCell *cell = (CustomBillCell *)[_bvc_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell = [[CustomBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    [self configureBillsCell:cell atIndexPath:indexPath];
    cell.delegate=self;
    float width;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        width = 53;
    }
    else
    {
        width = 63;
    }
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
  	return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:RGBColor(113, 163, 245) normalIcon:[UIImage imageNamed:@"bianji"] selectedIcon:[UIImage imageNamed:@"bianji"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(254, 59, 47) normalIcon:[UIImage imageNamed:@"del"] selectedIcon:[UIImage imageNamed:@"del"]];
    return btns;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.swipIndex != nil) {
        self.swipIndex = nil;
        [_bvc_tableView reloadData];
        return;
    }
    BillFather *oneBillFather;
    if (indexPath.section==0) {
        oneBillFather = [_bl_pastMutableArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section==1)
        oneBillFather = [_bl_7MutableArray objectAtIndex:indexPath.row];
    else
        oneBillFather = [_bl_30MutableArray objectAtIndex:indexPath.row];
    
//    self.paymentViewController = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
//    self.paymentViewController.billFather = oneBillFather;
    
    if ([self.delegate respondsToSelector:@selector(returnSelectedBill:)]) {
        [self.delegate returnSelectedBill:oneBillFather];
    }
    
    //隐藏tabbar
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    self.paymentViewController.hidesBottomBarWhenPushed = TRUE;
    appDelegate.customerTabbarView.hidden = YES;
//    [self.navigationController pushViewController:self.paymentViewController animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipIndex!=nil) {
        self.swipIndex=nil;
        _bvc_tableView.scrollEnabled = NO;
        [_bvc_tableView reloadData];
        _bvc_tableView.scrollEnabled = YES;
        [_bvc_tableView setContentOffset:CGPointMake(0, 0)];
    }
}








///////////
#pragma mark /////Get BillListArray
-(void)getBillListArray
{
    [_bl_bill1Array removeAllObjects];
    [_bl_bill2Array removeAllObjects];
    [_bl_totalBillsArray removeAllObjects];
    [_bl_30MutableArray removeAllObjects];
    [_bl_7MutableArray removeAllObjects];
    [_bl_pastMutableArray removeAllObjects];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    //1.查询bill1中所有的bill
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch setPredicate:predicate];
    NSArray *bill1tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    [_bl_bill1Array setArray:bill1tempArray];
    
    //2.查询bill2中所有数据
    NSFetchRequest *fetch2 = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch2 setEntity:entity2];
    NSPredicate * predicate2 =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch2 setPredicate:predicate2];
    NSArray *bill2tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch2 error:&error]];
    [_bl_bill2Array setArray:bill2tempArray];
    
    //3.分析，产生新的数据
    [self useTemlateCreateBill];
    [self useBill2createRealAllArray];
    
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [_bl_totalBillsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [_bl_totalBillsArray setArray:ar];
    
    [self setArraybyPast_7day_30daysType];
    
    [_bvc_tableView reloadData];
    
}

-(void)useTemlateCreateBill{
    for (int i=0; i<[_bl_bill1Array count]; i++)
    {
        EP_BillRule *oneBill = [_bl_bill1Array objectAtIndex:i];
        [self setBillFathferbyBill:oneBill];
    }
}

-(void)setBillFathferbyBill:(EP_BillRule *)bill
{
    
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"] )
    {
        double paymentAmount = 0.00;
        
        
        if ([appDelegate_iphone.epnc dateCompare:bill.ep_billDueDate withDate:_thirtyDaysLater]<=0)
        {
            NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[bill.billRuleHasTransaction allObjects]];
            for (int n=0; n<[paymentarray count]; n++)
            {
                Transaction *onepayment = [paymentarray objectAtIndex:n];
                if ([onepayment.state isEqualToString:@"1"])
                {
                    paymentAmount = paymentAmount +[onepayment.amount doubleValue];
                }
            }
            if (paymentAmount<[bill.ep_billAmount doubleValue])
            {
                BillFather *billFateher = [[BillFather alloc]init];
                [appDelegate_iphone.epdc editBillFather:billFateher withBillRule:bill withDate:nil];
                [_bl_totalBillsArray addObject:billFateher];
            }
        }
        
        return;
    }
    //如果是循环账单
    else
    {
        //如果账单开始的时间在30天之后，过掉
        if ([appDelegate_iphone.epnc  dateCompare:bill.ep_billDueDate withDate:_thirtyDaysLater] == 1)
        {
            return;
        }
        
        NSDate *lastDate = bill.ep_billDueDate ;

        NSDate *endDateorBillEndDate = [appDelegate_iphone.epnc dateCompare:_thirtyDaysLater withDate:bill.ep_billEndDate]<0?_thirtyDaysLater : bill.ep_billEndDate;
        if ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]>0)
        {
            return;
        }
        else
        {
            //循环创建账单
            while ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                BillFather *oneBillfather = [[BillFather alloc]init];
                
                [appDelegate_iphone.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                
                [_bl_totalBillsArray  addObject:oneBillfather];
                //获取下一次循环的时间
                lastDate= [appDelegate_iphone.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}
-(void)useBill2createRealAllArray
{
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    for (int i=0; i<[_bl_bill2Array count]; i++)
    {
        EP_BillItem *billObject = [_bl_bill2Array objectAtIndex:i];
        
        //在30天之后的去掉
        if ([appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:_thirtyDaysLater]==1)
            continue;
        else{
            
            //如果被删除了，就从all中删除这个数据
            if ([billObject.ep_billisDelete boolValue])
            {
                for (int j=0; j<[_bl_totalBillsArray count]; j++)
                {
                    BillFather   *checkedBill = [_bl_totalBillsArray objectAtIndex:j];
                    if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0)
                    {
                        [_bl_totalBillsArray removeObject:checkedBill];
                    }
                }
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

                    }
                }
                
                if (paymentAmount < [billObject.ep_billItemAmount doubleValue])
                {
                    for (int j=0; j<[_bl_totalBillsArray count]; j++)
                    {
                        BillFather *oneBillfather = [_bl_totalBillsArray objectAtIndex:j];
                        //相等的话说明是同一件事情，此时需要修改
                        if (oneBillfather.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:oneBillfather.bf_billDueDate withDate:billObject.ep_billItemDueDate]==0)
                        {
                            [appDelegate_iPhone.epdc editBillFather:oneBillfather withBillItem:billObject];
                        }
                    }
                }
                else
                {
                    for (int j=0; j<[_bl_totalBillsArray count]; j++) {
                        BillFather   *checkedBill = [_bl_totalBillsArray objectAtIndex:j];
                        if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0)
                        {
                            [_bl_totalBillsArray removeObject:checkedBill];
                        }
                    }
                }
            }
            
        }
        
    }
    
}

-(void)setArraybyPast_7day_30daysType
{
    totalPastAmount = 0;
    totalSevenDayAmount = 0;
    totalThirthDayAmount = 0;

    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    for (int i=0; i<[_bl_totalBillsArray count]; i++)
    {
        BillFather *selecBillFather = [_bl_totalBillsArray objectAtIndex:i];
        
        if ([appDelegate_iPhone.epnc dateCompare:selecBillFather.bf_billDueDate withDate:self.yestary]==-1)
        {
            [_bl_pastMutableArray addObject:selecBillFather];

            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"])
            {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else
            {
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++)
            {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"])
                {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalPastAmount += selecBillFather.bf_billAmount-paidAmount;
        }
        else if([appDelegate_iPhone.epnc dateCompare:selecBillFather.bf_billDueDate withDate:self.sevendaysLater]==-1)
        {
            [_bl_7MutableArray addObject:selecBillFather];
            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else{
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"]) {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalSevenDayAmount += selecBillFather.bf_billAmount-paidAmount;

        }
        
        else
        {
            [_bl_30MutableArray addObject:selecBillFather];
            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else{
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"]) {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalThirthDayAmount += selecBillFather.bf_billAmount-paidAmount;
        }
    }
}


#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==2)
        return;
        
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    BillFather *billFather;
    
    if (_bvc_billFatherCalendar == nil)
    {
        if (_bvc_deleteIndex.section==0) {
            if (_bl_pastMutableArray.count > 0) {
                billFather = [_bl_pastMutableArray objectAtIndex:self.bvc_deleteIndex.row];
            }
        }else if (_bvc_deleteIndex.section==1)
        {
            if (_bl_7MutableArray.count > 0) {
                billFather = [_bl_7MutableArray objectAtIndex:self.bvc_deleteIndex.row];
            }
        } else{
            if (_bl_30MutableArray.count > 0) {
                billFather = [_bl_30MutableArray objectAtIndex:self.bvc_deleteIndex.row];
            }
        }

    }
    else
        billFather = _bvc_billFatherCalendar;
    
    if (buttonIndex==2) {
        self.bvc_deleteIndex = nil;
        self.swipIndex = nil;
        self.swipIntergerCalendar = -1;
        _bvc_billFatherCalendar = nil;
        [self resetData];
        return;
    }
    //删除后面所有的bill,billItem，修改transaction
    else if (buttonIndex==1)
    {
        //如果是循环的第一条bill，需要删除这个循环,bill2中相关连的数据
        if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
        {
            
            //删除bill2数组
            NSMutableArray *bill2Array =[[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
            for (int i=0; i<[bill2Array count]; i++) {
                EP_BillItem *billo = [bill2Array objectAtIndex:i];
                
                billo.dateTime = [NSDate date];
                billo.state = @"0";
                if (![appDelegate.managedObjectContext save:&error]) {
                    
                }
//                if (appDelegate.dropbox.drop_account.linked) {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
////                    [appDelegate.managedObjectContext deleteObject:billo];
//
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                }
            }
            
            //删除bill
            billFather.bf_billRule.dateTime = [NSDate date];
            billFather.bf_billRule.state = @"0";
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        else
        {
            //---给老bill设置截止日期,删除这日期以后的bill2
            NSMutableArray *bill2array = [[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
            NSMutableArray *deleteBill2array = [[NSMutableArray alloc]init];
            //获取要删除的bill2
            for (int i=0; i<[bill2array count]; i++)
            {
                EP_BillItem *billo = [bill2array objectAtIndex:i];
                if ([appDelegate.epnc dateCompare:billo.ep_billItemDueDateNew withDate:billFather.bf_billDueDate]>=0) {
                    [deleteBill2array addObject:billo];
                }
            }
            //删除bill2
            for (int i=0; i<[deleteBill2array count]; i++)
            {
                EP_BillItem *billo = [deleteBill2array objectAtIndex:i];
                billo.state = @"0";
                billo.dateTime = [NSDate date];
                [appDelegate.managedObjectContext save:&error];
//                if (appDelegate.dropbox.drop_account.linked) {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                }
            }
            //修改由 billBrose中的billfather
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [cal components:flags fromDate:billFather.bf_billDueDate];
            [components setMonth:components.month];
            [components setDay:components.day -1 ];
            NSDate *billFatherendDate =[[NSCalendar  currentCalendar]dateFromComponents:components];
            //-----当删除后面所有的账单的时候，要把永久循环设置为NO
            billFather.bf_billRule.ep_billEndDate = billFatherendDate;
            billFather.bf_billRule.dateTime = [NSDate date];
            
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        
        
    }
    //只是本次的bill
    else
    {
        //循环BK_Bill的第一个BK_BillObject,修改BK_Bill duedate
        if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
        {
            if (billFather.bf_billItem!=nil)
            {
                billFather.bf_billItem.state = @"0";
                billFather.bf_billItem.dateTime = [NSDate date];
                if (![appDelegate.managedObjectContext save:&error])
                {
                }
//                if (appDelegate.dropbox.drop_account.linked)
//                {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billFather.bf_billItem];
////                    [appDelegate.managedObjectContext deleteObject:billFather.bf_billItem];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billFather.bf_billItem];
                }
            }
            
            billFather.bf_billRule.ep_billDueDate = [appDelegate.epnc getDate:billFather.bf_billDueDate byCycleType:billFather.bf_billRecurringType];
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
//            if (appDelegate.dropbox.drop_account.linked)
//            {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        else
        {
            //----------在bill2中记下一条记录，并且删除这个bill2对应的payment
            EP_BillItem *deleteBillobject;
            if (billFather.bf_billItem == nil)
            {
                
                deleteBillobject = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
                deleteBillobject.uuid = [EPNormalClass GetUUID];
            }
            else{
                deleteBillobject =billFather.bf_billItem;
            }
            //配置被删除的bill2对象
            deleteBillobject.ep_billisDelete = [NSNumber numberWithBool:YES];
            deleteBillobject.ep_billItemName = billFather.bf_billName;
            deleteBillobject.ep_billItemAmount = [NSNumber numberWithDouble:billFather.bf_billAmount];
            deleteBillobject.ep_billItemDueDate = billFather.bf_billDueDate;
            if (deleteBillobject.ep_billItemDueDateNew == nil) {
                deleteBillobject.ep_billItemDueDateNew = billFather.bf_billDueDate;
            }
            deleteBillobject.ep_billItemRecurringType = billFather.bf_billRecurringType;
            deleteBillobject.ep_billItemEndDate = billFather.bf_billEndDate;
            deleteBillobject.ep_billItemNote = billFather.bf_billNote;
            deleteBillobject.ep_billItemReminderDate = billFather.bf_billReminderDate;
            deleteBillobject.ep_billItemReminderTime = billFather.bf_billReminderTime;
            
            deleteBillobject.billItemHasBillRule = billFather.bf_billRule;
            deleteBillobject.billItemHasCategory = billFather.bf_category;
            deleteBillobject.billItemHasPayee = billFather.bf_payee;
            deleteBillobject.billItemHasTransaction = nil;
            
            deleteBillobject.dateTime = [NSDate date];
            deleteBillobject.state = @"1";
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteBillobject];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteBillobject];
            }
        }
    }
    self.bvc_deleteIndex = nil;
    self.swipIndex = nil;
    self.swipIntergerCalendar = -1;
    _bvc_billFatherCalendar = nil;
    [self resetData];
    
}
#pragma mark - SWTableView Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[_bvc_tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self celleditBtnPressed:indexPath];
            break;

        default:
            [self celldeleteBtnPressed:indexPath isCalenderTableViewBill:nil];
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBillCal" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

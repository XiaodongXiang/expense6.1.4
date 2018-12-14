/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "EventKitDataSource.h"
#import "AppDelegate_iPad.h"
#import "ipad_MainViewController.h"
#import "ipad_BillsViewController.h"
#import "iPad_OverViewViewController.h"

#import "ipad_DateSelBillsViewController.h"


#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()
@property (nonatomic, retain) NSDate *initialDate;
- (KalView*)calendarView;
@end

@implementation KalViewController
@synthesize logic,kalView,tableView;
@synthesize dataSource, delegate, initialDate, selectedDate;
@synthesize isHidenHeaderView;

- (id)initWithSelectedDate:(NSDate *)date
{
  if ((self = [super init])) {
      logic = [[KalLogic alloc] init];
    self.initialDate = date;
    self.selectedDate = date;
      //当时间改变时通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
  }
  return self;
}

- (id)init
{
  return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
  if (dataSource != aDataSource) {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate) {
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void)reloadData
{
    AppDelegate_iPad  *appDelegate = (AppDelegate_iPad  *)[[UIApplication sharedApplication]delegate];
    
    NSDate *startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:self.kalView.logic.baseDate];
    NSDate *endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.kalView.logic.baseDate];
    //在这里获取交易，并且绘制title
    [dataSource presentingDatesFrom:startDate to:endDate delegate:self];

    
    if (appDelegate.mainViewController.currentViewSelect==4) {
        //设置iBillViewController中的data
        appDelegate.mainViewController.iBillsViewController.bvc_MonthStartDate = startDate;
        appDelegate.mainViewController.iBillsViewController.bvc_MonthEndDate = endDate;
        [appDelegate.mainViewController.iBillsViewController getSelectedMonthData];
        
        [kalView paidmarkTilesForDates:appDelegate.mainViewController.iBillsViewController.selectedMonthBillAllArray withDates1:appDelegate.mainViewController.iBillsViewController.selectedMonthpaidArray  isTran:FALSE];
    }
}

- (void)significantTimeChangeOccurred
{
    [self showSelectedMonth];
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    self.selectedDate = [date NSDate];

    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
    {
        NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
        NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
        [self clearTable];
        
        //overview页面
        [dataSource loadItemsFromDate:from toDate:to];
        [tableView reloadData];
    }
    else
    {
        [dataSource loadBillItemsFromDate:[date NSDate]];
        [tableView reloadData];
    }
}

-(void)didSelectDate:(KalDate *)date withFram:(CGRect)r
{
    self.selectedDate = [date NSDate];
    [self clearTable];
    [dataSource loadBillItemsFromDate:[date NSDate]];
    [tableView reloadData];
    
    
    
    
//    //当人为点击才允许弹出pop
//    if (!appDelegate_iPad.mainViewController.iBillsViewController.needShowSelectedDateBillViewController)
//    {
//        return;
//    }
//    
//    BOOL isPop = FALSE;
//    
//    NSMutableArray *tmpselectedMonthArray = [[NSMutableArray alloc]initWithArray:appDelegate_iPad.mainViewController.iBillsViewController.selectedMonthBillAllArray];
//    for (int i = 0;i< [tmpselectedMonthArray count]; i++) {
//        BillFather *b = [tmpselectedMonthArray objectAtIndex:i];
//        if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:[date NSDate]] == 0)
//        {
//            isPop = TRUE;
//            break;
//            
//        }
//        else     if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:[date NSDate]] == 1)
//        {
//            break;
//        }
//    }
//    
//    if(!isPop)
//    {
//        return;
//    }
//    else
//    {
//        //如果是从其他的页面跳转到bill页面的话，那么额不管当前选中的有没有pop也不弹
//        if (!appDelegate_iPad.mainViewController.lasViewSelectisBillView) {
//            return;
//        }
//        
//        appDelegate_iPad.pvt = budgetTransactionListPopup;
//        
//        ipad_DateSelBillsViewController *iDateSelBillsViewController = [[ipad_DateSelBillsViewController alloc] initWithStyle:UITableViewStylePlain];
//        iDateSelBillsViewController.iBillsViewController = appDelegate_iPad.mainViewController.iBillsViewController;
//        
//        iDateSelBillsViewController.selDate = [date NSDate] ;
//        //获取选中某一天的数组
//        iDateSelBillsViewController.selDateBillsArray = [[NSMutableArray alloc] init];
//        
//        for (int i = 0;i< [appDelegate_iPad.mainViewController.iBillsViewController.selectedMonthBillAllArray count]; i++) {
//            BillFather *b = [appDelegate_iPad.mainViewController.iBillsViewController.selectedMonthBillAllArray objectAtIndex:i];
//            if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:[date NSDate]] == 0)
//            {
//                [iDateSelBillsViewController.selDateBillsArray addObject:b];
//                
//            }
//            else     if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:[date NSDate]] == 1)
//            {
//                break;
//            }
//        }
//        
//        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:iDateSelBillsViewController];
//        
//        //新加
//        appDelegate_iPad.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
//        appDelegate_iPad.AddPopoverController.popoverContentSize = CGSizeMake(330.0,300);
//        appDelegate_iPad.AddPopoverController.delegate = appDelegate_iPad.mainViewController.iBillsViewController;
//        [appDelegate_iPad.AddPopoverController presentPopoverFromRect:CGRectMake(r.origin.x +20 ,  r.origin.y+80, r.size.width, r.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//
//    }
    
}

- (void)showPreviousMonth
{

    
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
    
    //设置overview页面的起始时间
    AppDelegate_iPad  *appDelegate = (AppDelegate_iPad  *)[[UIApplication sharedApplication]delegate];
    
    NSDate *startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:self.kalView.logic.baseDate];
    NSDate *endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.kalView.logic.baseDate];
    if (appDelegate.mainViewController.currentViewSelect==0) {
        appDelegate.mainViewController.overViewController.monthStartDate = startDate;
        appDelegate.mainViewController.overViewController.monthEndDate = endDate;
        [appDelegate.mainViewController.overViewController refleshData];
    }
    else
        [self reloadData];
}

-(void)showSelectedMonth
{
    [self clearTable];
    [logic retreatToSelectedMonth:logic.baseDate];
    [[self calendarView] slideNone];
}

- (void)showFollowingMonth
{
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
    
    //上下翻页的时候，刷新overview页面的数据
    AppDelegate_iPad  *appDelegate = (AppDelegate_iPad  *)[[UIApplication sharedApplication]delegate];
    
    NSDate *startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:self.kalView.logic.baseDate];
    NSDate *endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.kalView.logic.baseDate];
    if (appDelegate.mainViewController.currentViewSelect==0) {
        appDelegate.mainViewController.overViewController.monthStartDate = startDate;
        appDelegate.mainViewController.overViewController.monthEndDate = endDate;
        [appDelegate.mainViewController.overViewController refleshData];
    }
    else
        [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    
    [self didSelectDate:self.calendarView.selectedDate];
    
    [tableView reloadData];
    [tableView flashScrollIndicators];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToMonthForDate:date];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
  [self reloadData];
}

- (NSDate *)selectedDate
{
  return [self.calendarView.selectedDate NSDate];
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
  self.initialDate = self.selectedDate; // must be done before calling super
  [super didReceiveMemoryWarning];
}

- (void)loadView
{
  if (!self.title)
    self.title = @"Calendar";
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.currentViewSelect == 0) {
        kalView=[[KalView alloc]initWithFrame:CGRectMake(0, 0, 378, 674) delegate:self logic:logic];
        
    }
    else
    {
        kalView = [[KalView alloc]initWithFrame:CGRectMake(0, 0, 378, 704) delegate:self logic:logic];
        
    }
   
  self.view = kalView;
  tableView = kalView.tableView;
  tableView.dataSource = dataSource;
  tableView.delegate = delegate;
  tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
  [self reloadData];
    
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];

}

@end

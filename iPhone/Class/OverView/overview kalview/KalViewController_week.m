/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController_week.h"
#import "KalLogic_week.h"
#import "KalDataSource_week.h"
#import "KalDate_week.h"
#import "KalPrivate_week.h"

#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "OverViewMonthViewController.h"


#define PROFILER 0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

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

NSString *const KalDataSourceChangedNotification_week = @"KalDataSourceChangedNotification";

@interface KalViewController_week ()
@property (nonatomic, strong, readwrite) NSDate *initialDate;
//@property (nonatomic, strong) NSDate *selectedDate;



- (KalView_week*)calendarView;
@end

@implementation KalViewController_week

@synthesize dataSource, delegate, initialDate, selectedDate,logic,kalView,tableView;
@synthesize startDate,endDate;

- (id)initWithSelectedDate:(NSDate *)date
{
  if ((self = [super init])) {
      
      AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
      if (appDelegate_iPhone.overViewController.overViewMonthViewController != nil && appDelegate_iPhone.overViewController.overViewMonthViewController.selectedDate != nil)
      {
          logic = [[KalLogic_week alloc] initForDate:[NSDate dateWithTimeInterval:0 sinceDate:appDelegate_iPhone.overViewController.overViewMonthViewController.selectedDate]];

          self.selectedDate = [NSDate dateWithTimeInterval:0 sinceDate:appDelegate_iPhone.overViewController.overViewMonthViewController.selectedDate];
          self.initialDate = [NSDate dateWithTimeInterval:0 sinceDate:appDelegate_iPhone.overViewController.overViewMonthViewController.selectedDate];
      }
      else
      {
          logic = [[KalLogic_week alloc] initForDate:date];
          self.initialDate = date;
          self.selectedDate = date;
      }
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification_week object:nil];
  }
  return self;
}

- (id)init
{
    
  return [self initWithSelectedDate:[NSDate date]];
}




- (KalView_week*)calendarView
{
    return (KalView_week*)self.view;
}

- (void)setDataSource:(id<KalDataSource_week>)aDataSource
{
  if (dataSource != aDataSource)
  {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate)
  {
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
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (logic.calenderDisplayMode == 0)
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:self.logic.baseDate];
        self.endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.logic.baseDate];
    }
    else if (logic.calenderDisplayMode==1)
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:1 fromDate:self.logic.baseDate];
        self.endDate = [appDelegate.epnc getEndDateDateType:1 withStartDate:self.logic.baseDate];
    }
    //在这里获取交易，并且绘制title
    [dataSource presentingDatesFrom:self.startDate to:self.endDate delegate:self];
    
}

- (void)significantTimeChangeOccurred
{
    
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate_week *)date
{

    //设置overview页面的时间
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MMMM yyyy"];
    
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [weekFormatter setDateFormat:@"EEEE"];
    [dayFormatter setDateFormat:@"dd"];
//    NSString *tmpWeekString = [[weekFormatter stringFromDate:[date NSDate]] uppercaseString];
//    NSString *dayString = [dayFormatter stringFromDate:[date NSDate]];
//    NSString *finalString =[ NSString stringWithFormat:@"%@ %@",tmpWeekString,dayString];
//    appDelegate_iPhone.overViewController.yearLabel.text = finalString;

    


    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPhone.overViewController.navigationItem.title = [monthFormatter stringFromDate:[date NSDate]];
    
    
    
  self.selectedDate = [date NSDate];
    

  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate_iPhone.overViewController.overViewMonthViewController != nil)
        [appDelegate_iPhone.overViewController.overViewMonthViewController resetData];
    else
    {
        //发送一个通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"swipIndex" object:nil];
        [appDelegate_iPhone.overViewController resetAllDate];
    }
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    //设置 date
    [[self calendarView] slideUp];
//    [self reloadData];

    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    if (appDelegate_iPhone.overViewController.overViewMonthViewController != nil)
        [appDelegate_iPhone.overViewController.overViewMonthViewController resetData];
    
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"swipIndex" object:nil];
        [appDelegate_iPhone.overViewController resetAllDate];

    }

}

-(void)showCurrentDay_Month{
    NSDate *lastDate = [NSDate dateWithTimeInterval:0 sinceDate:logic.baseDate];
    [self clearTable];
    [logic retreatToCurrentDay_Month];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //需要往前翻转
    if ([appDelegate.epnc monthCompare:lastDate withDate:[NSDate date]]>0)
    {
        [[self calendarView] slideDown];
        [self reloadData];
    }
    else if ([appDelegate.epnc monthCompare:lastDate withDate:[NSDate date]]<0)
    {
        [[self calendarView] slideUp];
        [self reloadData];
    }
    else if ([appDelegate.epnc monthCompare:lastDate withDate:[NSDate date]]==0)
    {
    }
}

-(void)showCurrentMonth{
    [self clearTable];
    [logic getCurrentMonth];
    [[self calendarView]slideinThisMonth];
    [self reloadData];
}

-(void)reflashDateStly
{
    logic = [logic  initForDate:self.selectedDate];
    [self showCurrentMonth];
}


// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource_week>)theDataSource;
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
  
  [[self calendarView] selectDate:[KalDate_week dateFromNSDate:date]];
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
  kalView = [[KalView_week alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic] ;
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    //个人热点打开链接
    if(appDelegate_iPhone.overViewController.view.frame.size.height < [UIScreen mainScreen].bounds.size.height)
        kalView.frame = CGRectIntegral(CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64));
    else
        kalView.frame = CGRectIntegral(CGRectMake(0, 0, SCREEN_WIDTH,appDelegate_iPhone.overViewController.kalContailView.frame.size.height));

  self.view = kalView;
  tableView = kalView.tableView;
  tableView.dataSource = dataSource;
  tableView.delegate = delegate;
  [kalView selectDate:[KalDate_week dateFromNSDate:self.initialDate]];
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

#pragma mark Custom Method




@end

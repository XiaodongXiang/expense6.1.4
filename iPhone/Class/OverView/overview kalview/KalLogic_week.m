/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic_week.h"
#import "KalDate_week.h"
#import "KalPrivate_week.h"

#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "OverViewMonthViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface KalLogic_week ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSArray *daysInSelectedMonth;
@property (nonatomic, strong) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, strong) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation KalLogic_week

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;
@synthesize calenderDisplayMode;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
  if ((self = [super init])) {
      if (appDelegate_iphone.overViewController.overViewMonthViewController !=nil)
      {
          calenderDisplayMode = 0;
      }
      else
          calenderDisplayMode = 1;
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM yyyy"];
    [self moveToMonthForDate:date];
  }
  return self;
}

- (id)init
{
  return [self initForDate:[NSDate date]];
}

//将默认的日期选到这个星期的第一天，将overView上的起始日期改变，重新计算这个月的值
- (void)moveToMonthForDate:(NSDate *)date
{
    if (calenderDisplayMode==0)
    {
        self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
    }
    else{
        self.baseDate = [date cc_dateByMovingToFirstDayOfTheWeek];
        
    }
    
    //设置overView上面的monthStartDate,monthEndDate
//    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

//    appDelegete.overViewController.monthStartDate = [appDelegete.epnc getStartDateWithDateType:2  fromDate:self.baseDate];
//    appDelegete.overViewController.monthEndDate = [appDelegete.epnc getEndDateDateType:2 withStartDate:appDelegete.overViewController.monthStartDate];
  [self recalculateVisibleDays];
}
-(void)moveToWeekForDate:(NSDate *)date{
//    self.baseDate = [date cc_dateByMovingToFirstDayOfTheCurrentWeek];
    [self recalculateVisibleDays];
}

////
- (void)retreatToPreviousMonth
{
    if (calenderDisplayMode==0) {
        [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];

    }
    else
        [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousWeek]];
}

- (void)advanceToFollowingMonth
{
    if (calenderDisplayMode==0) {
        [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];

    }
    else
        [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingWeek]];

}

-(void)retreatToCurrentDay_Month{
    [self moveToMonthForDate:[NSDate date]];
}

-(void)getCurrentMonth{
    if (calenderDisplayMode==0) {
        //[self.baseDate cc_dateByMovingToFirstDayOfTheCurrentMonth]返回的是这一周的第一天
        [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheCurrentMonth]];
        
    }
    else
        [self moveToWeekForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheCurrentWeek]];

}



- (NSString *)selectedMonthNameAndYear;
{
  return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
    return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
    c.day = [self.baseDate cc_numberOfDaysInMonth];


    int firstWeekday = 1;
    if([appDelegate.settings.others16 isEqualToString:@"2"]){
        firstWeekday = 2;
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setFirstWeekday:firstWeekday];
    NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
   return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
    if (calenderDisplayMode==0) {
        //获取上个月开始的第一天
        NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
        //获取上个月的天数
        NSUInteger n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
        NSUInteger numPartialDays = [self numberOfDaysInPreviousPartialWeek];
        NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
        for (NSUInteger i = n - (numPartialDays - 1); i < n + 1; i++)
            [days addObject:[KalDate_week dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    }
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
    NSMutableArray *days = [NSMutableArray array];
    if (calenderDisplayMode==0) {
        
        NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
        NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
        for (int i = 1; i < numDays + 1; i++)
            [days addObject:[KalDate_week dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    }
    else{
        //计算这一周所有的日期
        NSDate *tempFirstDayofThisWeek = [self.baseDate cc_dateByMovingToFirstDayOfTheWeek];
        for (int i=0; i<7; i++) {
            [days addObject:[KalDate_week dateForDay:i dependOnDate:tempFirstDayofThisWeek]];
        }
    }
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
    if (calenderDisplayMode==0) {
        NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
        NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
        
        for (int i = 1; i < numPartialDays + 1; i++)
            [days addObject:[KalDate_week dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
    }
  
  return days;
}

- (void)recalculateVisibleDays
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
    self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
    self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *weekFormatter =[[NSDateFormatter alloc]init];
    NSDateFormatter *dayFormatter =[[NSDateFormatter alloc]init];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
    
    if (calenderDisplayMode==1)
    {
        
        [monthFormatter setDateFormat:@"MMMM yyyy"];
        [weekFormatter setDateFormat:@"EEEE"];
        [dayFormatter setDateFormat:@"dd"];
        
        KalDate_week *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
        KalDate_week *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
        self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
        self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
        
//        NSString *tmpWeekString = [[weekFormatter stringFromDate:self.baseDate] uppercaseString];
//        NSString *dayString = [dayFormatter stringFromDate:self.baseDate];
//        NSString *finalString =[ NSString stringWithFormat:@"%@ %@",tmpWeekString,dayString];

        //month label是正确的，yearlabel是错误的
//        NSLog(@"时间：%@",appDelegate_iPhone.overViewController.monthLabel.text);
//        appDelegate_iPhone.overViewController.yearLabel.text = finalString;
       
    }
    else
    {
        [yearFormatter setDateFormat:@"MMM yyyy"];
        self.fromDate = [self.daysInSelectedMonth firstObject];
        self.toDate = [self.daysInSelectedMonth lastObject];
        appDelegate_iPhone.overViewController.overViewMonthViewController.headTitle.text = [yearFormatter stringFromDate:self.baseDate];
    }

    
    
}

#pragma mark -



@end

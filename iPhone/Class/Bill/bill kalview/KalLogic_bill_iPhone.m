/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic_bill_iPhone.h"
#import "KalDate_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"
#import "PokcetExpenseAppDelegate.h"

@interface KalLogic_bill_iPhone ()
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

@implementation KalLogic_bill_iPhone

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth,isIpadShow;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init]))
    {
        [self moveToMonthForDate:date];
    }
    return self;
}

- (id)init
{
  if ((self = [super init])) {
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM yyyy"];
    [self moveToMonthForDate:[[NSDate date] cc_dateByMovingToFirstDayOfTheMonth]];
  }
  return self;
}

- (void)moveToMonthForDate:(NSDate *)date
{
  self.baseDate = date;
  [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

-(void)retreatToSelectedMonth:(NSDate *)date{
    self.baseDate = date;
    [self recalculateVisibleDays];
}

- (void)moveToTodaysMonth
{
  [self moveToMonthForDate:[[NSDate date] cc_dateByMovingToFirstDayOfTheMonth]];
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
    NSDate *lastDayOfTheMonth = [cal dateFromComponents:c];
    return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
  long n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
  long numPartialDays = [self numberOfDaysInPreviousPartialWeek];
  NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
  for (long i = n - (numPartialDays - 1); i < n + 1; i++)
    [days addObject:[KalDate_bill_iPhone dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate_bill_iPhone dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate_bill_iPhone dateForDay:(unsigned int)i month:(unsigned int)c.month year:(unsigned int)c.year]];
  
  return days;
}

- (void)recalculateVisibleDays
{
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
	self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
	self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
	KalDate_bill_iPhone *from,*to;
    from	=  [self.daysInSelectedMonth objectAtIndex:0];
    to	= [self.daysInSelectedMonth lastObject];
    self.fromDate =  [from NSDate]  ;
    self.toDate =  [to NSDate]  ;
    
    return;
//	if(isIpadShow)
//	{
//		from	=  [self.daysInSelectedMonth objectAtIndex:0];
//		to	= [self.daysInSelectedMonth lastObject];
//		self.fromDate =  [from NSDate]  ;
//		self.toDate =  [to NSDate]  ;
//
// 	}
//	else {
//		from	=[self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
//		to	= [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
//		self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
//		self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
//
//	}
	
}



@end

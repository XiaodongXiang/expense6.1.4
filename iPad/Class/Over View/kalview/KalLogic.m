/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "PokcetExpenseAppDelegate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;
@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation KalLogic

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
  if ((self = [super init])) {
    monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"LLLL"];
      
  yearFormatter = [[NSDateFormatter alloc]init];
  [yearFormatter setDateFormat:@"yyyy"];
    [self moveToMonthForDate:date];
  }
  return self;
}

- (id)init
{
  return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
  self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
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
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSDate *thisMonthFirstDay = [appDelegate.epnc getMonthFirstDate:date];
    self.baseDate = thisMonthFirstDay;
    [self recalculateVisibleDays];
}

- (void)moveToTodaysMonth
{
    [self moveToMonthForDate:[[NSDate date] cc_dateByMovingToFirstDayOfTheMonth]];
}


- (NSMutableAttributedString *)selectedMonthNameAndYear;
{
    NSString *monthString = [monthFormatter stringFromDate:self.baseDate];
    NSString *yearString = [yearFormatter stringFromDate:self.baseDate];
    
    //设置字体的颜色
    NSUInteger spStrLength=[monthString length];
    NSUInteger tbStrLength=[yearString length];
    
    NSRange spStrRange=NSMakeRange(0, spStrLength);
    NSRange tbRange=NSMakeRange(spStrLength, tbStrLength+2);
    
    NSString *allCompentsStr=[NSString stringWithFormat:@"%@  %@",monthString,yearString];
    //month
    NSMutableAttributedString *acAttributeStr=[[NSMutableAttributedString alloc]initWithString:allCompentsStr];
    [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1] range:spStrRange];
    
    [acAttributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0] range:spStrRange];
    
    //设置后半截文字的颜色
    [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1] range:tbRange ];
    [acAttributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:tbRange];
    
  return acAttributeStr;
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
    [days addObject:[KalDate dateForDay:(int)i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate dateForDay:(int)i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate dateForDay:(int)i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (void)recalculateVisibleDays
{
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
  self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
  self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
  KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
  KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
  self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
  self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
}

#pragma mark -



@end

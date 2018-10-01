/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NSDateAdditions.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"

static NSCalendar* curCalendar;


@implementation NSDate (KalAdditions)

- (NSDate *)cc_dateByMovingToBeginningOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
  NSDate *d = nil;
  BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
  NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
  return d;
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
  NSDateComponents *c = [[NSDateComponents alloc] init] ;
  c.month = -1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];  
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
  NSDateComponents *c = [[NSDateComponents alloc] init] ;
  c.month = 1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
  return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

//- (NSUInteger)cc_weekday
//{
//    int order = 1;
//    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
//    if ([defaults2 integerForKey:@"CalendarDateStly"])
//    {
//        order = [defaults2 integerForKey:@"CalendarDateStly"];
//    }
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setFirstWeekday:order];
//    
//    NSLog(@"ddsssdd:%d",[calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self]);
//    
//    return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
//}

//设置星期
- (NSUInteger)cc_weekday
{
    //星期天为1
    int firstWeekDay = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekDay = 2;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:firstWeekDay];
  return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
  return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

//////
- (NSDate *)cc_dateByMovingToFirstDayOfTheWeek
{
    //设置overView上面的月份金额
    //    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    //    [monthFormatter setDateFormat:@"MMMM yyyy"];
    //    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //    appDelegate_iPhone.overViewController.monthLabel.text = [monthFormatter stringFromDate:self];
    //    [monthFormatter release];
    
//    int order = 1;
//    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
//    if ([defaults2 integerForKey:@"CalendarDateStly"])
//    {
//        order = [defaults2 integerForKey:@"CalendarDateStly"];
//    }
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setFirstWeekday:order];
//    
//    
//    BOOL ok= [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
    
    
    //星期天为1
    int firstWeekDay = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekDay = 2;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:firstWeekDay];
    
    __weak NSDate *slf = self;//这样写为了避免增加指针
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&slf interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
    //为什么返回self就是错误的，返回slf就是正确的呢，因为是在slf的基础上更改的
    return slf;
}

-(NSDate *)cc_dateByMovingToFirstDayOfThePreviousWeek
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
//    c.week = -1;
    
    c.weekOfMonth = -1;
    
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek];
}

-(NSDate *)cc_dateByMovingToFirstDayOfTheFollowingWeek{
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
//    c.week = 1;
    c.weekOfMonth = 1;
    
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek];
}

-(NSDate *)cc_dateByMovingToFirstDayOfTheCurrentWeek{
    NSDateComponents *selectedComponents  = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
    
    NSDateComponents *c = [[NSDateComponents alloc]init];
    c.day = 0-(selectedComponents.weekday-1);
    NSLog(@"DATE:%@",[[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek]);
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek];
}

-(NSDate *)cc_dateByMovingToFirstDayOfTheCurrentMonth{
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
    c.month = 0;
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];}

//HMJMonthView
-(NSDate *)hmj_dateByMovingToFirstDayofthePrevious5Monthes
{
    if (curCalendar == nil) {
		curCalendar = [[NSCalendar currentCalendar] copy];
	}
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
    c.year=0;
    c.month = -5;
    NSLog(@"SS:%@",[[curCalendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth]);
    
    return [[curCalendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}
-(NSDate *)hmj_dateByMovingToFirstDayoftheFollowing5Monthes
{
    if (curCalendar == nil) {
		curCalendar = [[NSCalendar currentCalendar] copy];
	}
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
    c.month = 5;
    return [[curCalendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}



@end
/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDate_week.h"
#import "KalPrivate_week.h"

static KalDate_week *today;


@interface KalDate_week ()
+ (void)cacheTodaysDate;
@end


@implementation KalDate_week

+ (void)initialize
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheTodaysDate) name:UIApplicationSignificantTimeChangeNotification object:nil];
  [self cacheTodaysDate];
}

+ (void)cacheTodaysDate
{
  today = [KalDate_week dateFromNSDate:[NSDate date]] ;
}

////
+ (KalDate_week *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  return [[KalDate_week alloc] initForDay:day month:month year:year] ;
}
+(KalDate_week *)dateForDay:(unsigned int)day dependOnDate:(NSDate *)tempDate {
    NSCalendar *cal= [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];

    NSDate *tempNewDate = [cal dateByAddingComponents:dateComponents toDate:tempDate options:0];
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:tempNewDate];
    return [[KalDate_week alloc]initForDay:(unsigned int)parts.day month:(unsigned int)parts.month year:(unsigned int)parts.year];
}

+ (KalDate_week *)dateFromNSDate:(NSDate *)date
{
  NSDateComponents *parts = [date cc_componentsForMonthDayAndYear];
  return [KalDate_week dateForDay:(unsigned int)[parts day] month:(unsigned int)[parts month] year:(unsigned int)[parts year]];
}

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  if ((self = [super init])) {
    a.day = day;
    a.month = month;
    a.year = year;
  }
  return self;
}

- (unsigned int)day { return a.day; }
- (unsigned int)month { return a.month; }
- (unsigned int)year { return a.year; }

- (NSDate *)NSDate
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.day = a.day;
  c.month = a.month;
  c.year = a.year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (BOOL)isToday { return [self isEqual:today]; }

- (NSComparisonResult)compare:(KalDate_week *)otherDate
{
  NSInteger selfComposite = a.year*10000 + a.month*100 + a.day;
  NSInteger otherComposite = [otherDate year]*10000 + [otherDate month]*100 + [otherDate day];
  
  if (selfComposite < otherComposite)
    return NSOrderedAscending;
  else if (selfComposite == otherComposite)
    return NSOrderedSame;
  else
    return NSOrderedDescending;
}

#pragma mark -
#pragma mark NSObject interface

- (BOOL)isEqual:(id)anObject
{
  if (![anObject isKindOfClass:[KalDate_week class]])
    return NO;
    KalDate_week *d = (KalDate_week*)anObject;
    
    BOOL result = a.day == [d day] && a.month == [d month] && a.year == [d year];
    return result;
}

- (NSUInteger)hash
{
  return a.day;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%u/%u/%u", a.month, a.day, a.year];
}

@end

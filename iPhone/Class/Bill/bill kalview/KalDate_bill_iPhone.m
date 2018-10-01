/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDate_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"

static KalDate_bill_iPhone *today;

@implementation KalDate_bill_iPhone

+ (void)initialize
{
  today = [KalDate_bill_iPhone dateFromNSDate:[NSDate date]];
  // TODO set a timer for midnight to recache this value
}

+ (KalDate_bill_iPhone *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  return [[KalDate_bill_iPhone alloc] initForDay:day month:month year:year] ;
}

+ (KalDate_bill_iPhone *)dateFromNSDate:(NSDate *)date
{
  NSDateComponents *parts = [date cc_componentsForMonthDayAndYear];
  return [KalDate_bill_iPhone dateForDay:(unsigned int)[parts day] month:(unsigned int)[parts month] year:(unsigned int)[parts year]];
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

- (unsigned int)day { return a.day;}
- (unsigned int)month { return a.month;}
- (unsigned int)year { return a.year;}

- (NSDate *)NSDate
{
  NSDateComponents *c = [[NSDateComponents alloc] init] ;
  c.day = a.day;
  c.month = a.month;
  c.year = a.year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (BOOL)isToday { return [self isEqual:today]; }

- (NSComparisonResult)compare:(KalDate_bill_iPhone *)otherDate
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
  if (![anObject isKindOfClass:[KalDate_bill_iPhone class]])
    return NO;
  
  KalDate_bill_iPhone *d = (KalDate_bill_iPhone*)anObject;
  return a.day == [d day] && a.month == [d month] && a.year == [d year];
}

- (NSUInteger)hash
{
  return a.day;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%u/%u/%u", a.month, a.day, a.year];
}

//HMJMonthView
-(BOOL)isCurrentMonth
{
	NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[self NSDate]];
	NSDateComponents *cmpday2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[today NSDate]];
	if([cmpday1 month] == [cmpday2 month] &&
	   [cmpday1 year] == [cmpday2 year]) {
		return YES;
	}
    return NO;
    
}


@end

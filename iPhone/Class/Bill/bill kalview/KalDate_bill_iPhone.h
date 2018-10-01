/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

//与HMJMonthView公用

@interface KalDate_bill_iPhone : NSObject
{
  struct {
    unsigned int month : 4;
    unsigned int day : 5;
    unsigned int year : 15;
  } a;
}

+ (KalDate_bill_iPhone *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
+ (KalDate_bill_iPhone *)dateFromNSDate:(NSDate *)date;

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
- (unsigned int)day;
- (unsigned int)month;
- (unsigned int)year;
- (NSDate *)NSDate;
- (NSComparisonResult)compare:(KalDate_bill_iPhone *)otherDate;
- (BOOL)isToday;

//HMJMonthView
-(BOOL)isCurrentMonth;


@end

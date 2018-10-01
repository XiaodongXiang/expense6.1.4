//
//  XDCalendarClass.h
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline NSCalendar * GMTCalendar(){
    static NSCalendar *_gmtCalendar;
    if (!_gmtCalendar) {
        _gmtCalendar = [NSCalendar currentCalendar];
        
        if ([NSCalendar currentCalendar].calendarIdentifier != NSCalendarIdentifierGregorian) {
            _gmtCalendar  = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        }
//        [_gmtCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    return _gmtCalendar;
}

@interface XDCalendarClass : NSObject

+(XDCalendarClass*)shareCalendarClass;

//month view
-(NSArray*)getMonthDataWithCurrentDateTo1970Years;
-(NSArray*)getDaysDataWithCurrentDateTo1970Years;
-(NSInteger)getCurrentMonthInterger;
-(NSDate*)getCurrentDayInitDay;
//day view
-(NSInteger)getSelectedMonthInterger:(NSDate*)date;
-(NSInteger)sevenCountWithCurrentDate;
-(NSInteger)getDayViewCurrentMonthWithSelectedDate:(NSDate*)date;

-(NSArray*)dateArray;
@end

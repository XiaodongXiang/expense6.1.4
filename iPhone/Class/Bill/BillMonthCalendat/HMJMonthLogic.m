//
//  HMJMonthLogic.m
//  KalMonth
//
//  Created by humingjing on 14-4-4.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import "HMJMonthLogic.h"
#import "NSDateAdditions.h"
//#import "AppDelegate.h"
#import "KalDate_bill_iPhone.h"

@implementation HMJMonthLogic
@synthesize baseDate,fromDate,toDate;
@synthesize monthesInSelectedMonthGroup;

- (id)init
{
    return [self initForDate:[NSDate date]];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init])) {
        NSDate *tmpBaseDate =[[NSDate date] cc_dateByMovingToFirstDayOfTheMonth];
        //获取五个月开始的第一天
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
        
        NSDateComponents *componentsFromyear = [cal components:unitFlags fromDate:tmpBaseDate];
        componentsFromyear.year = componentsFromyear.year;
        componentsFromyear.month = componentsFromyear.month-2;
        componentsFromyear.day = 1;
        [componentsFromyear setHour:0];
        [componentsFromyear setMinute:0];
        [componentsFromyear setSecond:0];
        self.fromDate = [cal dateFromComponents:componentsFromyear];
        self.baseDate = self.fromDate;
        
        
//        NSDateComponents *componentsFromyear2 = [cal components:unitFlags fromDate:self.baseDate];
//        componentsFromyear2.year = componentsFromyear2.year;
//        componentsFromyear2.month = componentsFromyear2.month+3;
//        componentsFromyear2.day = -1;
//        [componentsFromyear2 setHour:23];
//        [componentsFromyear2 setMinute:59];
//        [componentsFromyear2 setSecond:59];
//        self.toDate = [cal dateFromComponents:componentsFromyear2];
        
        [self moveToMonthForDate:self.baseDate];
    }
    return self;
}

//利用这五个月的第一天获取五个月的所有时间
- (void)moveToMonthForDate:(NSDate *)date
{
    self.baseDate = date;
    self.fromDate = self.baseDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *componentsFromyear2 = [cal components:unitFlags fromDate:self.baseDate];
    componentsFromyear2.year = componentsFromyear2.year;
    componentsFromyear2.month = componentsFromyear2.month+5;
    componentsFromyear2.day = -1;
    [componentsFromyear2 setHour:23];
    [componentsFromyear2 setMinute:59];
    [componentsFromyear2 setSecond:59];
    self.toDate = [cal dateFromComponents:componentsFromyear2];
    [self recalculateVisibleDays];
}

- (void)recalculateVisibleDays
{
    
    self.monthesInSelectedMonthGroup = [self calculateMonthesInSelectedMonthesGroup];
    return;
}


- (void)retreatToPreviousMonth
{
    [self moveToMonthForDate:[self.baseDate hmj_dateByMovingToFirstDayofthePrevious5Monthes]];
}

- (void)advanceToFollowingMonth
{
    [self moveToMonthForDate:[self.baseDate hmj_dateByMovingToFirstDayoftheFollowing5Monthes]];
}




- (NSArray *)calculateMonthesInSelectedMonthesGroup
{
    NSMutableArray *days = [NSMutableArray array];

    for (int i = 0; i < 5; i++)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
        //NSDateComponents需要先根据时间来初始化
        NSDateComponents *componentsFromyear = [cal components:unitFlags fromDate:self.fromDate];
        componentsFromyear.year = componentsFromyear.year;
        componentsFromyear.month = componentsFromyear.month + i;
        componentsFromyear.day = 1;
        [componentsFromyear setHour:0];
        [componentsFromyear setMinute:0];
        [componentsFromyear setSecond:0];
        NSDate *tmpDate = [cal dateFromComponents:componentsFromyear];
        KalDate_bill_iPhone *tmpKalDate =  [KalDate_bill_iPhone dateFromNSDate:tmpDate];
        [days addObject:tmpKalDate];
    }
    
    return days;
}

- (void)retreatToPrevious5Monthes
{
    [self moveToMonthForDate:[self.baseDate hmj_dateByMovingToFirstDayofthePrevious5Monthes]];
}

- (void)advanceToFollowing5Monthes
{
    [self moveToMonthForDate:[self.baseDate hmj_dateByMovingToFirstDayoftheFollowing5Monthes]];
}

//-(void)dealloc
//{
//    [monthesInSelectedMonthGroup release];
//    
//    [super dealloc];
//}

@end

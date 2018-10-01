//
//  XDCalendarClass.m
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDCalendarClass.h"
#import "XDCalendarModel.h"
#import "XDCalendarModel.h"

#import "Setting+CoreDataClass.h"

#define maxMonth ((2100 - 1970) * 12)
#define maxDay (((2100 - 1970) * 365) + 4)

@interface XDCalendarClass()
@property(nonatomic, strong)NSMutableArray* array;
@end

@implementation XDCalendarClass

+(XDCalendarClass *)shareCalendarClass{
    static XDCalendarClass* g_shareCalendarClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shareCalendarClass = [[XDCalendarClass alloc]init];
    });
    return g_shareCalendarClass;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getMonthDataWithCurrentDateTo1970Years];
    }
    return self;
}
#pragma mark - Month Data

//计算1970到2100有多少月份

-(NSArray*)getMonthDataWithCurrentDateTo1970Years{
    
    NSMutableArray* allMonthMuArr = [NSMutableArray array];

//    NSLog(@"%ld",[self getFirstDayWeekForMonth:[self getCurrentMonth]]);
//
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:[NSDate date]];
    
    [components setYear:1970];
    [components setMonth:0];
    [components setDay:1];
    [components setHour:0];

    NSDate* startDay = [GMTCalendar() dateFromComponents:components];
    
    NSDateComponents* startComp = [GMTCalendar() components:dayInfoUnits fromDate:startDay];
    
    for (int i = 0;  i < maxMonth ; i++) {
        startComp.month +=1;
        NSDate* month = [GMTCalendar() dateFromComponents:startComp];
        
        [allMonthMuArr addObject:month];
    }
    
    self.array = [NSMutableArray array];
    
    for (NSDate* date in allMonthMuArr) {
        
        XDCalendarModel * model = [self getAllDaysForMonth:date];

        [self.array addObject:model];
    }
    
    return self.array;
}

-(NSArray*)dateArray{
    
    return self.array;
}


-(NSInteger )getCurrentMonthInterger{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:[NSDate date]];
    NSInteger interger = (components.year - 1970) * 12 + components.month - 1;
    
    return interger;
}

-(NSInteger)getSelectedMonthInterger:(NSDate*)date{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:date];
    NSInteger interger = (components.year - 1970) * 12 + components.month - 1;
    
    return interger;
}


-(NSDate *)getCurrentDayInitDay{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:[NSDate date]];
    NSDate* date = [GMTCalendar() dateFromComponents:components];
    
    return date;
    
}

-(NSDate*)getCurrentMonth{
    
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:[NSDate date]];

    [components setDay:1];
    
    NSDate* date = [GMTCalendar() dateFromComponents:components];
    
    return date;
    
}

-(NSInteger)getDaysInMonth:(NSDate *)date{
    
    NSInteger monthNum = [GMTCalendar() rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    return monthNum;
}

-(XDCalendarModel* )getAllDaysForMonth:(NSDate*)date{
    
  
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:date];
    
    NSDateComponents* lastMonthComp = [GMTCalendar() components:dayInfoUnits fromDate:date];
    lastMonthComp.month -= 1;
    NSDate* lastMonth = [GMTCalendar() dateFromComponents:lastMonthComp];
    NSInteger lastMonthDaysCount = [self getDaysInMonth:lastMonth];
    
    NSDateComponents* nextMonthComp = [GMTCalendar() components:dayInfoUnits fromDate:date];
    nextMonthComp.month += 1;
    
    NSInteger currentDaysCount = [self getDaysInMonth:date];
    NSInteger lastDaysCount = [self getFirstDayWeekForMonth:date];
    NSInteger nextCount = 42 - lastDaysCount - currentDaysCount;
    
    
    NSMutableArray* lastMuArr = [NSMutableArray array];
    NSMutableArray* currentMuArr = [NSMutableArray array];
    NSMutableArray* nextMuArr = [NSMutableArray array];
    
    for (int i = 1; i <= nextCount; i++) {
        nextMonthComp.day = i;
        NSDate* date = [GMTCalendar() dateFromComponents:nextMonthComp];
        [nextMuArr addObject:date];
    }
    
    for (NSInteger i = lastMonthDaysCount - lastDaysCount + 1; i<=lastMonthDaysCount; i++) {
        lastMonthComp.day = i;
        NSDate* date = [GMTCalendar() dateFromComponents:lastMonthComp];
        [lastMuArr addObject:date];
    }
    
    for (int i = 1; i <= currentDaysCount; i++) {
        components.day = i;
        NSDate* day = [GMTCalendar() dateFromComponents:components];
        
        [currentMuArr addObject:day];
    }
    NSMutableArray* allDaysMuArr = [NSMutableArray array];
    [allDaysMuArr addObjectsFromArray:lastMuArr];
    [allDaysMuArr addObjectsFromArray:currentMuArr];
    [allDaysMuArr addObjectsFromArray:nextMuArr];
    
    
    XDCalendarModel* model = [[XDCalendarModel alloc]init];
    model.currentMonthArr = currentMuArr;
    model.lastMonthArr = lastMuArr;
    model.nextMonthArr = nextMuArr;
    model.allDaysInMonthArr = allDaysMuArr;
    model.calendarMonth = date;
    
    return model;
}

//获取1号是星期几

-(NSInteger)getFirstDayWeekForMonth:(NSDate*)date
{
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    NSDateComponents* com = [GMTCalendar() components:NSCalendarUnitWeekday fromDate:date];

    //[setting.others16 integerValue] == 1 sunday开始, 2 Monday开始
    if ([setting.others16 integerValue] == 1) {
        NSInteger begin = [com weekday]-1;
        if (begin<0) {
            begin+=7;
        }
        return begin;
    }else{
        NSInteger begin = [com weekday]-2;
        if (begin<0) {
            begin+=7;
        }
        return begin;
    }
    
    return 0;
}


#pragma mark - Day Data

//从1969/12/28开始计算时间

-(NSArray*)getDaysDataWithCurrentDateTo1970Years{
    
    NSMutableArray* allDayMuArr = [NSMutableArray array];
    //    NSLog(@"%ld",[self getFirstDayWeekForMonth:[self getCurrentMonth]]);
    //
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:[NSDate date]];
    
    [components setYear:1969];
    [components setMonth:12];
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    
    //[setting.others16 integerValue] == 1 sunday开始, 2 Monday开始
    if ([setting.others16 integerValue] == 1) {
        [components setDay:27];

    }else{
        [components setDay:28];

    }
    
    NSDate* startDay = [GMTCalendar() dateFromComponents:components];
    
    NSDateComponents* startComp = [GMTCalendar() components:dayInfoUnits fromDate:startDay];
    
    for (int i = 0; i < maxDay; i += 7) {
        
        NSMutableArray* sevenMuArr = [NSMutableArray array];
        for (int j = i ; j < i + 7; j++) {
                startComp.day +=1;
                NSDate* month = [GMTCalendar() dateFromComponents:startComp];
                [sevenMuArr addObject:month];
        }
        [allDayMuArr addObject:sevenMuArr];
    }
    
    return allDayMuArr;
}

-(NSInteger)sevenCountWithCurrentDate{
    
    NSInteger integer = [[self getCurrentDayInitDay] timeIntervalSince1970] + 4 * 3600 * 24;
    NSInteger sevenCount = integer/3600/24/7;
    
    return sevenCount;
}

-(NSInteger)getDayViewCurrentMonthWithSelectedDate:(NSDate*)date{
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    
    //[setting.others16 integerValue] == 1 sunday开始, 2 Monday开始
    if ([setting.others16 integerValue] == 1) {
        NSInteger integer = [date timeIntervalSince1970] + 5 * 3600 * 24;
        NSInteger sevenCount = integer/3600/24/7;
        
        return sevenCount;
    }else{
        NSInteger integer = [date timeIntervalSince1970] + 4 * 3600 * 24;
        NSInteger sevenCount = integer/3600/24/7;
        
        return sevenCount;
    }
    return 0;
}

@end

//
//  XDCalendarModel.h
//  calendar
//
//  Created by 晓东 on 2018/1/3.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDCalendarModel : NSObject

@property(nonatomic, strong)NSDate* calendarMonth;

@property(nonatomic, strong)NSArray * currentMonthArr;
@property(nonatomic, strong)NSArray * lastMonthArr;
@property(nonatomic, strong)NSArray * nextMonthArr;

@property(nonatomic, strong)NSArray * allDaysInMonthArr;

@end

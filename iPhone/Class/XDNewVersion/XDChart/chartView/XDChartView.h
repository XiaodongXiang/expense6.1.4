//
//  XDChartView.h
//  chart
//
//  Created by 晓东 on 2018/1/22.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDTimeSelectView.h"

@class XDChartModel;
typedef enum : NSUInteger {
    ExpenseChart = 0,
    IncomeChart,
    BalanceChart,
} ChartType;

@interface XDChartView : UIView

@property(nonatomic, strong)XDChartModel* model;

@property(nonatomic, assign)ChartType chartType;

@property(nonatomic, strong)NSDate * date;

@property(nonatomic, strong)NSArray * dateArray;

@property(nonatomic, copy)NSString * dateStr;

@end

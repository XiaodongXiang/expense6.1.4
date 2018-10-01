//
//  XDChartDataClass.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/1.
//

#import <Foundation/Foundation.h>
#import "XDDateSelectedModel.h"
#import "XDChartView.h"
#import "XDChartModel.h"
#import "Category.h"
#import "Accounts.h"
@interface XDChartDataClass : NSObject

+(XDChartModel*)modelWithDate:(NSDate*)date dateType:(DateSelectedType)type chartType:(ChartType)type account:(Accounts*)account;

+(XDChartModel*)modelWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate chartType:(ChartType)chartType  account:(Accounts*)account type:(void(^)(NSString*))dateType;


+(NSArray *)pieCategoryWithDate:(NSDate *)date endDate:(NSDate*)endDate dateType:(DateSelectedType)type tranType:(NSString*)tranType account:(Accounts*)account;

+(NSArray *)pieCategoryWithDate:(NSDate *)date endDate:(NSDate*)endDate dateType:(DateSelectedType)type category:(Category*)category account:(Accounts*)account;

@end

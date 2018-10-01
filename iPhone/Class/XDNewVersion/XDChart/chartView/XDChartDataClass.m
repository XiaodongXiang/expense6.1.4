//
//  XDChartDataClass.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/1.
//

#import "XDChartDataClass.h"
#import "Transaction.h"
#import "Setting+CoreDataClass.h"
#import "Category.h"
#import "XDPieChartModel.h"
@implementation XDChartDataClass

+(XDChartModel*)modelWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate chartType:(ChartType)chartType  account:(Accounts*)account type:(void(^)(NSString*))dateType{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth;
    
    NSDate* startD = [calendar dateFromComponents:[calendar components:unit fromDate:startDate]];
    NSDate* endD = [calendar dateFromComponents:[calendar components:unit fromDate:endDate]];

    
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:startD toDate:endD options:0];
    NSInteger days = dayComponents.day;
    
    
    NSMutableArray* xMuArr = [NSMutableArray array];
    NSMutableArray* yMuArr = [NSMutableArray array];
    NSMutableArray* dataMuArr = [NSMutableArray array];
    
    if (days <= 31) {
        dateType(@"Day");
        
        NSMutableArray* dateMuArr = [NSMutableArray array];
        for (int i = 0; i <= days; i++) {
            NSDateComponents* comp = [calendar components:unit fromDate:startD];
            comp.day += i;
            
            NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
            [dateMuArr addObject:newDate];
            NSDateComponents* scomp = [[NSCalendar currentCalendar] components:unit fromDate:newDate];
            [xMuArr addObject:@(scomp.day)];
        }
        
        for (int i = 0; i<dateMuArr.count; i++) {
            NSDate* sdate = dateMuArr[i];
            double amount = [self getAmount:sdate chartType:chartType account:account];
            [dataMuArr addObject:@(amount)];
        }
        
        if (chartType == BalanceChart) {
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }else if (days>31 && days <= 210){
        dateType(@"Week");
        NSInteger weeks = days/7;
        if (days%7>0) {
            weeks +=1;
        }
        NSMutableArray* dateMuArr = [NSMutableArray array];

        for (int i = 0; i <= weeks; i++) {
            NSDateComponents* comp = [[NSCalendar currentCalendar] components:unit fromDate:startD];
            comp.day += i * 7;
            NSDate* weekDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
            
            NSDateComponents* weekcomp = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:weekDate];
            [xMuArr addObject:@([weekcomp weekOfYear])];
            
            NSDate* startWeekDate ;
            BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekOfYearCalendarUnit startDate:&startWeekDate interval:nil forDate:weekDate];
            
            [dateMuArr addObject:weekDate];
            
        }
        
        for (int i = 0; i<dateMuArr.count; i++) {
            NSDate* sdate = dateMuArr[i];
            NSDate* beginningOfWeek = nil;
            BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekOfYearCalendarUnit startDate:&beginningOfWeek interval:nil forDate:sdate];
            
            NSArray* array = [self getMonthWithStartData:beginningOfWeek endDate:[self getWeekEndDate:beginningOfWeek] account:account];
            
            [dataMuArr addObject:@([self getAmountWithTransactionArr:array chartType:chartType account:account monthEndDate:[self getWeekEndDate:beginningOfWeek]])];
        }
        
        if (chartType == BalanceChart) {
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }else if (days>210 && days <= 900){
        dateType(@"Month");
        NSInteger months = days/30;
        if (days % 30 > 0) {
            months += 1;
        }
        NSMutableArray* dateMuArr = [NSMutableArray array];
        for (int i = 0; i <= months; i++) {
            NSDateComponents* dateComp = [[NSCalendar currentCalendar] components:unit fromDate:startD];
            dateComp.month += i;
            NSDate * sDate = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
            NSDateComponents* monthComp = [[NSCalendar currentCalendar] components:unit fromDate:sDate];
            [xMuArr addObject:@(monthComp.month)];
            [dateMuArr addObject:sDate];
        }
        for (int i = 0; i < dateMuArr.count; i++) {
            NSDate* date = dateMuArr[i];
            NSDateComponents* startComp = [[NSCalendar currentCalendar] components:unit fromDate:date];
            startComp.day = 1;
            NSDate* startDate = [[NSCalendar currentCalendar] dateFromComponents:startComp];
            NSDate* endDate = [self getMonthEndDate:startDate];
            
            NSArray* array = [self getMonthWithStartData:startDate endDate:endDate account:account];
            [dataMuArr addObject:@([self getAmountWithTransactionArr:array chartType:chartType account:account monthEndDate:endDate])];
        }
        
        if (chartType == BalanceChart) {
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
//            double num = [self getChartAmountMax:account];
            //           //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
        
    }else if (days > 900){
        dateType(@"Year");
        NSDateComponents* startComp = [[NSCalendar currentCalendar] components:unit fromDate:startD];
        NSDateComponents* endComp = [[NSCalendar currentCalendar] components:unit fromDate:endD];
        
        NSMutableArray* dateMuArr = [NSMutableArray array];
        for (NSInteger i = startComp.year; i <= endComp.year; i++) {
            startComp.year = i;
            NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:startComp];
            [xMuArr addObject:@(startComp.year)];
            [dateMuArr addObject:date];
        }
        
        for (int i = 0 ; i < dateMuArr.count ; i++) {
            NSDate* date = dateMuArr[i];
            NSDateComponents* dateComp = [[NSCalendar currentCalendar]components:unit fromDate:date];
            dateComp.day = 2;
            dateComp.month = 1;
            NSDate* startDate = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
            
            NSArray* array = [self getMonthWithStartData:startDate endDate:[self getYearEndDate:startDate]account:account];
            [dataMuArr addObject:@([self getAmountWithTransactionArr:array chartType:chartType account:account monthEndDate:[self getYearEndDate:startDate]])];
        }
        
        if (chartType == BalanceChart) {
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
            //            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }
    XDChartModel* chartModel = [[XDChartModel alloc]init];
    chartModel.xMuArr = xMuArr;
    chartModel.yMuArr = yMuArr;
    chartModel.dataMuArr = dataMuArr;
    
    return chartModel;
}

+(XDChartModel *)modelWithDate:(NSDate *)date dateType:(DateSelectedType)DateType chartType:(ChartType)chartType account:(Accounts*)account{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSMutableArray* xMuArr = [NSMutableArray array];
    NSMutableArray* yMuArr = [NSMutableArray array];
    NSMutableArray* dataMuArr = [NSMutableArray array];

   __block BOOL hasData = NO;
    if (DateType == DateSelectedMonth) {
        NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
        NSMutableArray* dateMuArr = [NSMutableArray array];
        NSDateComponents* comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        for (int i = 1; i <= monthNum; i++) {
            comp.day = i;
            NSDate* newDate = [calendar dateFromComponents:comp];
            [dateMuArr addObject:newDate];
            [xMuArr addObject:@(i)];
        }
        
        
        if (chartType == BalanceChart) {
            double startBalance = [self backgroundGetAmountWithStartDate:date account:account];
            
            for (int i = 0; i<dateMuArr.count; i++) {
                NSDate* sdate = dateMuArr[i];
                double amount = [self backgroundGetMonthNetworthWithDate:sdate account:account completion:^(BOOL shasData) {
                    if (shasData) {
                        hasData = shasData;
                    }
                }];
             
                startBalance += amount;
                [dataMuArr addObject:@(startBalance)];
            }
        }else{
            for (int i = 0; i<dateMuArr.count; i++) {
                NSDate* sdate = dateMuArr[i];
                double amount = [self backgroundGetMonthNotNetworthWithDate:sdate chartType:chartType account:account];

                [dataMuArr addObject:@(amount)];
            }
        }
        
        if (chartType == BalanceChart) {
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
//            double num = [self getChartAmountMax:account];
            double num   = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }else if (DateType == DateSelectedYear){
        
        NSMutableArray* dateMuArr = [NSMutableArray array];
        NSDateComponents* comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        for (int i = 1; i <= 12; i++) {
            comp.month = i;
            NSDate* newDate = [calendar dateFromComponents:comp];
            [dateMuArr addObject:newDate];
            [xMuArr addObject:@(i)];
        }
        
        if (chartType == BalanceChart) {
            double startBalance = [self backgroundGetAmountWithStartDate:date account:account];
            for (int i = 0; i < dateMuArr.count; i++) {
                NSDate* sDate = dateMuArr[i];
                NSArray* array = [self backgroundGetMonthWithStartData:sDate endDate:[self getMonthEndDate:sDate] account:account];
                double amount = [self getYearNetworthWithArray:array account:account];
                if (array.count > 0) {
                    hasData = YES;
                }
                startBalance += amount;
                [dataMuArr addObject:@(startBalance)];
            }
            
        }else{
            for (int i = 0; i < dateMuArr.count; i++) {
                NSDate* sDate = dateMuArr[i];
                
                NSArray* array = [self backgroundGetMonthWithStartData:sDate endDate:[self getMonthEndDate:sDate] account:account];
                
                [dataMuArr addObject:@([self getYearNotNetworthWithArray:array chartType:chartType account:account])];
            }
            
        }
        
      
        if (chartType == BalanceChart) {
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }else if (DateType == DateSelectedWeek){
        NSMutableArray* dateMuArr = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            NSDateComponents* comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            comp.day += i;
            NSDate* newDate = [calendar dateFromComponents:comp];
            [dateMuArr addObject:newDate];
            
            NSDateComponents* scomp = [calendar components:NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth fromDate:newDate];

            [xMuArr addObject:@(scomp.day)];
        }
        
        if (chartType == BalanceChart) {
            double startBalance = [self backgroundGetAmountWithStartDate:date account:account];
            for (int i = 0; i < dateMuArr.count; i++) {
                NSDate* sDate = dateMuArr[i];
                double amount = [self backgroundGetWeekNetworthWithDate:sDate account:account completion:^(BOOL shasData) {
                    if (shasData) {
                        hasData = YES;
                    }
                }];
                
                startBalance += amount;
                [dataMuArr addObject:@(startBalance)];
            }
        }else{
            for (int i = 0; i<dateMuArr.count; i++) {
                NSDate* sdate = dateMuArr[i];
                double amount = [self backgroundGetWeekNotNetworthWithDate:sdate chartType:chartType account:account];
                [dataMuArr addObject:@(amount)];
            }
        }
       
        if (chartType == BalanceChart) {
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 2;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            
            [yMuArr addObjectsFromArray:@[@(number* 2),@(number),@(0),@(-number)]];
            
        }else{
//            double num = [self getChartAmountMax:account];
            double num = 0;
            for (int i = 0; i < dataMuArr.count; i++) {
                double snum =fabs([dataMuArr[i] doubleValue]);
                if (snum > num) {
                    num = snum;
                }
            }
            if (num == 0) {
                num = 100;
            }
            float number = num / 4;
            
            if (number <= 1) {
                number = 1;
            }else if (number > 1 && number <= 5){
                number = 5;
            }else if (number > 5 && number <= 10){
                number = 10;
            }else{
                number = ceil(number / 10.0) * 10;
            }
            for (int i = 4; i > 0; i--) {
                [yMuArr addObject:@(number * i)];
            }
        }
    }
    
    XDChartModel* chartModel = [[XDChartModel alloc]init];
    chartModel.xMuArr = xMuArr;
    chartModel.yMuArr = yMuArr;
    chartModel.dataMuArr = dataMuArr;
    chartModel.hasData = hasData;
    
    return chartModel;
}

+(NSArray *)pieCategoryWithDate:(NSDate *)date endDate:(NSDate*)endDate dateType:(DateSelectedType)type tranType:(NSString*)tranType account:(Accounts *)account{
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    if (date == nil) {
        return nil ;
    }
    NSDate* startD = nil;
    NSDate* endD = nil;
    if (type == DateSelectedMonth) {
        startD = [self getMonthStartDate:date];
        endD = [self getMonthEndDate:date];
        
    }else if (type == DateSelectedWeek){
        startD = [self getDayInitDate:date];
        endD = [self getWeekEndDate:startD];
        
    }else if (type == DateSelectedYear){
        startD = [self getYearStartDate:date];
        endD = [self getYearEndDate:date];
        
    }else if (type == DateSelectedCustom){
        startD = [self getDayInitDate:date];
        endD = [self getDayEndDate:endDate];
    }
    NSArray* transArr = [self getTransactionByStartDate:startD endDate:endD type:tranType account:account];
    
    NSMutableArray* modelMuArr = [NSMutableArray array];

    if (transArr.count == 0) {
        XDPieChartModel* model = [[XDPieChartModel alloc]init];
        model.category = nil;
        model.amount = 0;
        model.type = tranType;
        
        [modelMuArr addObject:model];
        return modelMuArr;
    }
    
    NSMutableArray* categoryArr = [NSMutableArray array];

    for (Transaction* trans in transArr) {
        Category* cate = trans.category;
        if ([cate.categoryName containsString:@":"]) {
            Category* category = [[[XDDataManager shareManager] getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName = %@",[[cate.categoryName componentsSeparatedByString:@":"]firstObject]] sortDescriptors:nil]lastObject];
            if (![categoryArr containsObject:category]) {
                if (category) {
                    [categoryArr addObject:category];
                }
            }
        }else{
            if (![categoryArr containsObject:cate]) {
                if (cate) {
                    [categoryArr addObject:cate];
                }
            }
        }
        
    }
    
    for (int i = 0; i < categoryArr.count; i++) {
        Category* category = categoryArr[i];
        if (category.categoryName.length > 0) {
            NSArray* array = [transArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category.categoryName = %@ || category.categoryName contains[c] %@",category.categoryName,[NSString stringWithFormat:@"%@:",category.categoryName]]];
            double cateAllAmount = 0;
            for (int i = 0; i < array.count; i++) {
                Transaction* tran = array[i];
                
//                NSLog(@"tran == %@ -- %@ -- %@ -- %@ -- %f",tran.incomeAccount.accName,tran.category.categoryName,tran.expenseAccount.accName,tran.transactionType,[tran.amount doubleValue]);
//                if (tran.incomeAccount && tran.expenseAccount) {
//
//                }
                cateAllAmount += [tran.amount doubleValue];
            }
            
            XDPieChartModel* model = [[XDPieChartModel alloc]init];
            model.category = category;
            model.amount = cateAllAmount;
            model.type = tranType;
            
            [modelMuArr addObject:model];
        }
    }
    
    return modelMuArr;
    
}


+(NSArray *)pieCategoryWithDate:(NSDate *)date endDate:(NSDate*)endDate dateType:(DateSelectedType)type category:(Category*)category account:(Accounts *)account{
    //    NSCalendar* calendar = [NSCalendar currentCalendar];
    //    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    if (date == nil) {
        return nil ;
    }
    NSDate* startD = nil;
    NSDate* endD = nil;
    if (type == DateSelectedMonth) {
        startD = [self getMonthStartDate:date];
        endD = [self getMonthEndDate:date];
        
    }else if (type == DateSelectedWeek){
        startD = [self getDayInitDate:date];
        endD = [self getWeekEndDate:startD];
        
    }else if (type == DateSelectedYear){
        startD = [self getYearStartDate:date];
        endD = [self getYearEndDate:date];
        
    }else if (type == DateSelectedCustom){
        startD = [self getDayInitDate:date];
        endD = [self getDayEndDate:endDate];
    }
    
    NSArray* array = [self getTransactionByStartDate:startD endDate:endD category:category account:account];
    
    return array;
}

+(NSDate*)getMonthEndDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.day = monthNum;
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    NSDate* endDate = [calendar dateFromComponents:comp];
    
    return  endDate;
    
}
+(NSDate*)getDayInitDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.hour = 0;
    comp.minute = 0;
    comp.second = 0;
    
    NSDate* endDate = [calendar dateFromComponents:comp];
    
    return  endDate;
}

+(NSDate*)getDayEndDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    NSDate* endDate = [calendar dateFromComponents:comp];
    
    return  endDate;
}

+(NSDate*)getMonthStartDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.day = 1;
    comp.hour = 0;
    comp.minute = 0;
    comp.second = 0;
    
    NSDate* endDate = [calendar dateFromComponents:comp];
    
    return  endDate;
}

+(NSDate*)getWeekEndDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.day += 6;
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    NSDate* endDate = [calendar dateFromComponents:comp];
    
    return  endDate;
    
}

+(NSDate*)getYearStartDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.month = 1;
    comp.day = 1;
    comp.hour = 0;
    comp.minute = 0;
    comp.second = 0;
    
    return [calendar dateFromComponents:comp];
}

+(NSDate*)getYearEndDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    comp.month = 12;
    comp.day = 31;
    comp.hour = 23;
    comp.minute = 59;
    comp.second = 59;
    
    return [calendar dateFromComponents:comp];
    
}


+(NSArray*)getMonthWithStartData:(NSDate*)startDate endDate:(NSDate*)endDate account:(Accounts*)account{
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];

    NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [objects filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return objects;
}

+(NSArray*)backgroundGetMonthWithStartData:(NSDate*)startDate endDate:(NSDate*)endDate account:(Accounts*)account{
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[[XDDataManager shareManager].backgroundContext executeFetchRequest:fetchRequest error:&error]];
    
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [objects filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return objects;
}

+(NSArray*)getTransactionByStartDate:(NSDate*)startDate endDate:(NSDate*)endDate type:(NSString*)type account:(Accounts*)account{
    NSDictionary *subs;
    if (startDate == nil || endDate == nil) {
        return nil;
    }
    if ([type isEqualToString:@"EXPENSE"]) {
        subs = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",@"EXPENSE",@"TYPE", nil];
    }else if ([type isEqualToString:@"INCOME"]){
        subs = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",@"INCOME",@"TYPE", nil];
    }
    
    NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDateandCategoryType" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [objects filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return objects;
}

+(NSArray*)getTransactionByStartDate:(NSDate*)startDate endDate:(NSDate*)endDate category:(Category*)category account:(Accounts*)account{
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",category.categoryName,@"CATEGORYNAME",category.categoryType,@"TYPE", nil];
    
    NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDateAndParCategory" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"category.categoryName = %@ || category.categoryName contains[c] %@",category.categoryName,[NSString stringWithFormat:@"%@:",category.categoryName]];
    
    NSArray* filterArr = [objects filteredArrayUsingPredicate:pre];
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [filterArr filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return filterArr;
}



+(double)getAmountWithTransactionArr:(NSArray*)dataArr chartType:(ChartType)chartType account:(Accounts*)account monthEndDate:(NSDate*)date{
    double incomeAmount = 0;
    double expenseAmount = 0;
    double balanceAmount = 0;
    double startNetworth = 0;
    if (account) {
        startNetworth = [account.amount doubleValue];
    }else{
        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"] sortDescriptors:nil];
        for (Accounts* acc in array) {
            startNetworth += [acc.amount doubleValue];
        }
    }
    
    if (dataArr.count > 0) {
        
        for (int i = 0; i<dataArr.count; i++) {
            Transaction* transaction = dataArr[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            //                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];

                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    balanceAmount = [self getBeforeAmountWithDate:date startNetworth:startNetworth account:account];
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }else{
        return balanceAmount;
    }
    
    return 0;
}


+(double)getAmount:(NSDate*)date chartType:(ChartType)chartType account:(Accounts*)account{
    NSArray* transactionArray = [[XDDataManager shareManager] getTransactionDate:date withAccount:account];
    double incomeAmount = 0;
    double expenseAmount = 0;
    double balanceAmount = 0;
    double startNetworth = 0;
    if (account) {
        startNetworth = [account.amount doubleValue];
    }else{
        NSArray* accountArray = [[XDDataManager shareManager] getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        for (Accounts* acc in accountArray) {
            startNetworth += [acc.amount doubleValue];
        }
    }
    
    if (transactionArray.count > 0) {
      
        for (int i = 0; i<transactionArray.count; i++) {
            Transaction* transaction = transactionArray[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
//                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
//                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
//                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];

                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    balanceAmount = [self getBeforeAmountWithDate:date startNetworth:startNetworth account:account];
    
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }else{
        return balanceAmount;
    }

    return 0;
}

+(double)getBeforeAmountWithDate:(NSDate*)date startNetworth:(double)startBalance account:(Accounts*)account{
    
    if (account) {
        NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime <= %@ and (expenseAccount.uuid = %@ or incomeAccount.uuid = %@)",@"1",date,account.uuid,account.uuid] sortDescriptors:nil];
        
        if (array.count > 0) {
            double amount = startBalance;
            for (Transaction* transaction in array) {
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                        amount += [transaction.amount doubleValue];
                        if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                            if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                                amount -= [transaction.amount doubleValue];
                            }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                                amount += [transaction.amount doubleValue];
                            }
                        }else{
                            if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                                amount -= [transaction.amount doubleValue];
                            }else{
                                amount += [transaction.amount doubleValue];
                            }
                        }
                        
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                        amount -= [transaction.amount doubleValue];
                        
                        if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                            if (transaction.incomeAccount == account) {
                                amount += [transaction.amount doubleValue];
                            }else if (transaction.expenseAccount == account){
                                amount -= [transaction.amount doubleValue];
                            }
                        }else{
                            amount -= [transaction.amount doubleValue];
                        }
                    }
                }
            }
            return amount;
        }
    }else{
        
        
        NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime <= %@",@"1",date] sortDescriptors:nil];
        
        if (array.count>0) {
            double amount = startBalance;
            for (Transaction* transaction in array) {
                
//                NSLog(@"transaction == %@",transaction.category.categoryType);
                
                if (transaction.parTransaction == nil) {
                    if (transaction) {
                        if (([transaction.transactionType isEqualToString:@"income"] && transaction.transactionType) || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                            amount += [transaction.amount doubleValue];
                            if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                                if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                                    amount -= [transaction.amount doubleValue];
                                }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                                    amount += [transaction.amount doubleValue];
                                }
                            }else{
                                if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                                    amount -= [transaction.amount doubleValue];
                                }else{
                                    amount += [transaction.amount doubleValue];
                                }
                            }
                        }else if(([transaction.transactionType isEqualToString:@"expense"] && transaction.transactionType) || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                            amount -= [transaction.amount doubleValue];
                            if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                                if (transaction.incomeAccount == account) {
                                    amount += [transaction.amount doubleValue];
                                }else if (transaction.expenseAccount == account){
                                    amount -= [transaction.amount doubleValue];
                                }
                            }else{
                                amount -= [transaction.amount doubleValue];
                            }
                        }
                    }
                }
            }
            return amount;
        }
    }
    return 0;
}


+(double)getChartAmountMax:(Accounts*)account{
    double startNetworth = 0;
    if (account) {
        startNetworth = [account.amount doubleValue];
        
        NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and (expenseAccount.uuid = %@ or incomeAccount.uuid = %@)",@"1",account.uuid,account.uuid] sortDescriptors:nil];

        double amount = startNetworth;
        for (Transaction* transaction in tranArr) {
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                    amount += [transaction.amount doubleValue];
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                    amount -= [transaction.amount doubleValue];
                }
            }
        }
        
        if (fabs(amount)>fabs(startNetworth)) {
            return fabs(amount);
        }else{
            return fabs(startNetworth);
        }
    }else{
        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        for (Accounts* acc in array) {
            startNetworth += [acc.amount doubleValue];
        }
        
        NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];

        double amount = startNetworth;
        for (Transaction* transaction in tranArr) {
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                    amount += [transaction.amount doubleValue];
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                    amount -= [transaction.amount doubleValue];
                }
            }
        }
        if (fabs(amount)>fabs(startNetworth)) {
            return fabs(amount);
        }else{
            return fabs(startNetworth);
        }
    }
    
    
    return 100;
}

+(double)getAmountWithStartDate:(NSDate*)date account:(Accounts*)account{
    
    double startNetworth = 0;
    if (account) {
        startNetworth = [account.amount doubleValue];
        
        NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime <= %@ and (expenseAccount.uuid = %@ or incomeAccount.uuid = %@)",@"1",date,account.uuid,account.uuid] sortDescriptors:nil];

        double amount = startNetworth;
        if (tranArr.count > 0) {
            for (Transaction* transaction in tranArr) {
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                        amount += [transaction.amount doubleValue];
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                        amount -= [transaction.amount doubleValue];
                    }
                }
            }
        }
        return amount;

    }else{
        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        for (Accounts* acc in array) {
            startNetworth += [acc.amount doubleValue];
        }
        
        NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime < %@",@"1",date] sortDescriptors:nil];

        double amount = startNetworth;
        if (tranArr.count > 0) {
            for (Transaction* transaction in tranArr) {
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                        amount += [transaction.amount doubleValue];
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                        amount -= [transaction.amount doubleValue];
                    }
                }
            }
        }
        return amount;
    }
    
    return 0;
}

+(double)backgroundGetAmountWithStartDate:(NSDate*)date account:(Accounts*)account{
    
    double startNetworth = 0;
    if (account) {
        startNetworth = [account.amount doubleValue];
        
        NSArray* tranArr = [[XDDataManager shareManager]backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime < %@ and (expenseAccount.uuid = %@ or incomeAccount.uuid = %@)",@"1",date,account.uuid,account.uuid] sortDescriptors:nil];
        
        
        double amount = startNetworth;
        if (tranArr.count > 0) {
            for (Transaction* transaction in tranArr) {
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                        //                    incomeAmount += [transaction.amount doubleValue];
                        if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                            if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                                //                            amount -= [transaction.amount doubleValue];
                                amount -= [transaction.amount doubleValue];
                                
                            }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                                amount += [transaction.amount doubleValue];
                            }
                        }else{
                            if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                                //                            amount -= [transaction.amount doubleValue];
                                amount -= [transaction.amount doubleValue];

                            }else{
                                amount += [transaction.amount doubleValue];
                            }
                        }
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                        //                    expenseAmount += [transaction.amount doubleValue];
                        if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                            if (transaction.incomeAccount == account) {
                                //                            expenseAmount += [transaction.amount doubleValue];
                                amount += [transaction.amount doubleValue];

                            }else if (transaction.expenseAccount == account){
                                amount -= [transaction.amount doubleValue];
                            }
                        }else{
                            amount -= [transaction.amount doubleValue];
                        }
                    }else{
                        if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                            amount += [transaction.amount doubleValue];
                        }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                            amount -= [transaction.amount doubleValue];
                        }
                    }
                }
            }
        }
        return amount;
        
    }else{
        NSArray* array = [[XDDataManager shareManager] backgroundGetObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        for (Accounts* acc in array) {
            startNetworth += [acc.amount doubleValue];
        }
        
        NSArray* tranArr = [[XDDataManager shareManager]backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and dateTime < %@",@"1",date] sortDescriptors:nil];
        
        double amount = startNetworth;
        if (tranArr.count > 0) {
            for (Transaction* transaction in tranArr) {
                if (transaction.parTransaction == nil) {
                    if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                        //                    incomeAmount += [transaction.amount doubleValue];
                        if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                            if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                                //                            amount -= [transaction.amount doubleValue];
                                amount -= [transaction.amount doubleValue];
                                
                            }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                                amount += [transaction.amount doubleValue];
                            }
                        }else{
                            if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                                //                            amount -= [transaction.amount doubleValue];
                                amount -= [transaction.amount doubleValue];
                                
                            }else{
                                amount += [transaction.amount doubleValue];
                            }
                        }
                    }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                        //                    expenseAmount += [transaction.amount doubleValue];
                        if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                            if (transaction.incomeAccount == account) {
                                //                            expenseAmount += [transaction.amount doubleValue];
                                amount += [transaction.amount doubleValue];
                                
                            }else if (transaction.expenseAccount == account){
                                amount -= [transaction.amount doubleValue];
                            }
                        }else{
                            amount -= [transaction.amount doubleValue];
                        }
                    }else{
                        if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                            amount += [transaction.amount doubleValue];
                        }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                            amount -= [transaction.amount doubleValue];
                        }
                    }
                }
            }
        }
        return amount;
    }
    
    return 0;
}

+(double)getMonthNotNetworthWithDate:(NSDate*)date chartType:(ChartType)chartType account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] getTransactionDate:date withAccount:account];
    double incomeAmount = 0;
    double expenseAmount = 0;
   
    if (array.count > 0) {
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                    incomeAmount += [transaction.amount doubleValue];
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                    expenseAmount += [transaction.amount doubleValue];
                }
            }
        }
    }
    
    
//    NSLog(@"income -- %f, expense -- %f",incomeAmount,expenseAmount);

    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }
    
    
    return 0;
}

+(double)backgroundGetMonthNotNetworthWithDate:(NSDate*)date chartType:(ChartType)chartType account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] backgroundGetTransactionDate:date withAccount:account];
    double incomeAmount = 0;
    double expenseAmount = 0;
    
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            //                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];

                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    
    //    NSLog(@"income -- %f, expense -- %f",incomeAmount,expenseAmount);
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }
    
    
    return 0;
}
+(double)getMonthNetworthWithDate:(NSDate*)date account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] getTransactionDate:date withAccount:account];
    double balance = 0;
    
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                    balance += [transaction.amount doubleValue];
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                    balance -= [transaction.amount doubleValue];
                }
            }
        }
    }
    
    return balance;
}

+(double)backgroundGetMonthNetworthWithDate:(NSDate*)date account:(Accounts*)account completion:(void(^)(BOOL shasData))completion{
    NSArray* array = [[XDDataManager shareManager] backgroundGetTransactionDate:date withAccount:account];
    
    double balance = 0;
    
    if (array.count > 0) {
        
        if (completion) {
            completion(YES);
        }
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
                    
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            balance -= [transaction.amount doubleValue];
                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            balance += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            balance -= [transaction.amount doubleValue];
                        }else{
                            balance += [transaction.amount doubleValue];
                        }
                    }
                    
//                    balance += [transaction.amount doubleValue];
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            balance += [transaction.amount doubleValue];
                        }else if (transaction.expenseAccount == account){
                            balance -= [transaction.amount doubleValue];
                        }
                    }else{
                        balance -= [transaction.amount doubleValue];
                    }
//                    balance -= [transaction.amount doubleValue];
                }else{
                    if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                        balance += [transaction.amount doubleValue];
                    }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                        balance -= [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    return balance;
}

+(double)getYearNotNetworthWithArray:(NSArray*)array chartType:(ChartType)chartType account:(Accounts*)account{
    double incomeAmount = 0;
    double expenseAmount = 0;
   
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            //                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];

                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }
    
    return 0;
}
+(double)getYearNetworthWithArray:(NSArray*)array account:(Accounts*)account{
    double balance = 0;
    
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    balance += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            balance -= [transaction.amount doubleValue];
                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            balance += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            balance -= [transaction.amount doubleValue];
                        }else{
                            balance += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    balance -= [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            balance += [transaction.amount doubleValue];
                        }else if (transaction.expenseAccount == account){
                            balance -= [transaction.amount doubleValue];
                        }
                    }else{
                        balance -= [transaction.amount doubleValue];
                    }
                }else{
                    if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                        balance += [transaction.amount doubleValue];
                    }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                        balance -= [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    return balance;
    
}



+(double)getWeekNotNetworthWithDate:(NSDate*)date chartType:(ChartType)chartType account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] getTransactionDate:date withAccount:account];
    double incomeAmount = 0;
    double expenseAmount = 0;
    
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];
                            
                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];
                            
                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            //                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];
                            
                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }
    
    return 0;
}

+(double)backgroundGetWeekNotNetworthWithDate:(NSDate*)date chartType:(ChartType)chartType account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] backgroundGetTransactionDate:date withAccount:account];
    double incomeAmount = 0;
    double expenseAmount = 0;
    
    if (array.count > 0) {
        
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    incomeAmount += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            //                            amount -= [transaction.amount doubleValue];
                            expenseAmount += [transaction.amount doubleValue];

                        }else{
                            incomeAmount += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    expenseAmount += [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            //                            expenseAmount += [transaction.amount doubleValue];
                            incomeAmount += [transaction.amount doubleValue];

                        }else if (transaction.expenseAccount == account){
                            expenseAmount += [transaction.amount doubleValue];
                        }
                    }else{
                        expenseAmount += [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    
    if (chartType == IncomeChart) {
        return incomeAmount;
    }else if(chartType == ExpenseChart){
        return expenseAmount;
    }
    
    return 0;
}
+(double)getWeekNetworthWithDate:(NSDate*)date account:(Accounts*)account{
    NSArray* array = [[XDDataManager shareManager] getTransactionDate:date withAccount:account];
    double balance = 0;
    
    if (array.count > 0) {
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    balance += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            balance -= [transaction.amount doubleValue];
                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            balance += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            balance -= [transaction.amount doubleValue];
                        }else{
                            balance += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    balance -= [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            balance += [transaction.amount doubleValue];
                        }else if (transaction.expenseAccount == account){
                            balance -= [transaction.amount doubleValue];
                        }
                    }else{
                        balance -= [transaction.amount doubleValue];
                    }
                }else{
                    if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                        balance += [transaction.amount doubleValue];
                    }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                        balance -= [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    return balance;
}

+(double)backgroundGetWeekNetworthWithDate:(NSDate*)date account:(Accounts*)account completion:(void(^)(BOOL shasData))completion{
    NSArray* array = [[XDDataManager shareManager] backgroundGetTransactionDate:date withAccount:account];
    double balance = 0;
    
    if (array.count > 0) {
        if (completion) {
            completion(YES);
        }
        for (int i = 0; i<array.count; i++) {
            Transaction* transaction = array[i];
            
            if (transaction.parTransaction == nil) {
                if ([transaction.transactionType isEqualToString:@"income"] || ((transaction.expenseAccount == nil && transaction.incomeAccount != nil)&&[transaction.category.categoryType isEqualToString:@"INCOME"])) {
//                    balance += [transaction.amount doubleValue];
                    if (transaction.incomeAccount && transaction.expenseAccount && transaction.category) {
                        if ([transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                            balance -= [transaction.amount doubleValue];
                        }else if([transaction.category.categoryType isEqualToString:@"INCOME"]){
                            balance += [transaction.amount doubleValue];
                        }
                    }else{
                        if (transaction.incomeAccount == nil && transaction.expenseAccount) {
                            balance -= [transaction.amount doubleValue];
                        }else{
                            balance += [transaction.amount doubleValue];
                        }
                    }
                }else if([transaction.transactionType isEqualToString:@"expense"] || ((transaction.expenseAccount != nil && transaction.incomeAccount == nil)&&[transaction.category.categoryType isEqualToString:@"EXPENSE"])){
//                    balance -= [transaction.amount doubleValue];
                    if (transaction.category == nil && transaction.incomeAccount && transaction.expenseAccount) {
                        if (transaction.incomeAccount == account) {
                            balance += [transaction.amount doubleValue];
                        }else if (transaction.expenseAccount == account){
                            balance -= [transaction.amount doubleValue];
                        }
                    }else{
                        balance -= [transaction.amount doubleValue];
                    }
                }else{
                    if ([transaction.incomeAccount.uuid isEqualToString: account.uuid]) {
                        balance += [transaction.amount doubleValue];
                    }else if ([transaction.expenseAccount.uuid isEqualToString: account.uuid]){
                        balance -= [transaction.amount doubleValue];
                    }
                }
            }
        }
    }
    
    return balance;
}
@end

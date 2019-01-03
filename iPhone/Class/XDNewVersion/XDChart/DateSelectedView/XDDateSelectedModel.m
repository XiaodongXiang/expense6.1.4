//
//  XDDateSelectedModel.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/27.
//

#import "XDDateSelectedModel.h"
#import "Transaction.h"
#import "Setting+CoreDataClass.h"
@implementation XDDateSelectedModel

+(NSArray *)returnDateSelectedWithType:(DateSelectedType)type completion:(void (^)(NSInteger))completion{
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    NSArray* tranArr = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and parTransaction = null",@"1"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES]]];
    
    
    
    
    Transaction* startTransaction = [tranArr firstObject];
    Transaction* endTransaction = [tranArr lastObject];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [calendar setFirstWeekday:[setting.others16 integerValue]];
    
    NSDate* tranStartDay;
    NSDate* tranEndDay;
    NSDate* currentDay = [calendar dateFromComponents:[calendar components:unit fromDate:[NSDate date]]];
//    if ([currentDay compare:endTransaction.dateTime] == NSOrderedDescending) {
//        currentDay = endTransaction.dateTime ;
//    }
    
    if (tranArr.count == 0) {
        tranStartDay = [calendar dateFromComponents:[calendar components:unit fromDate:[[NSDate date]initYearDate]]];
        tranEndDay = [calendar dateFromComponents:[calendar components:unit fromDate:[[NSDate date]initYearEndDate]]];

    }else{
        tranStartDay = [calendar dateFromComponents:[calendar components:unit fromDate:startTransaction.dateTime]];
        tranEndDay = [calendar dateFromComponents:[calendar components:unit fromDate:endTransaction.dateTime]];
        if ([tranEndDay compare:[NSDate date]] == NSOrderedAscending) {
            tranEndDay = [NSDate date];
        }
    }
    
    
    if (type == DateSelectedWeek) {
        NSInteger startIndex = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:tranStartDay];
        NSInteger endIndex = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:tranEndDay];
        
        NSDateComponents* startComponents = [calendar components:unit fromDate:tranStartDay];
        startComponents.day -= startIndex - 1;
        NSDate* startDay = [calendar dateFromComponents:startComponents];
        
        NSDateComponents* endComponents = [calendar components:unit fromDate:tranEndDay];
        endComponents.day += 7 - endIndex;
        NSDate* endDay = [calendar dateFromComponents:endComponents];

        NSDateComponents *dateCom = [calendar components:NSCalendarUnitDay fromDate:startDay toDate:endDay options:0];

        NSInteger count = dateCom.day + 1;
        
        NSMutableArray* allMuArr = [NSMutableArray array];
        for (int i = 0; i < count/7; i++) {
            NSMutableArray* muArr = [NSMutableArray array];
            for (int j = i*7; j < 7*(i+1); j++) {

                NSDateComponents* comp = [calendar components:unit fromDate:startDay];
                comp.day += j;
                NSDate* date = [calendar dateFromComponents:comp];
                
                if ([date compare:[currentDay initDate]] == NSOrderedSame) {
                    if (completion) {
                        completion(i);
                    }
                }

                [muArr addObject:date];
            }
            [allMuArr addObject:muArr];
        }
        
        return allMuArr;
    }else if (type == DateSelectedMonth){
        NSDateComponents* startComponents = [calendar components:NSCalendarUnitYear fromDate:tranStartDay];
        startComponents.month = 1;
        startComponents.day = 1;
        
        NSDateComponents* endComponents = [calendar components:NSCalendarUnitYear fromDate:tranEndDay];

//        NSDateComponents    * comp = [calendar components:NSCalendarUnitMonth fromDate:tranStartDay toDate:tranEndDay options:NSCalendarWrapComponents];
        
        NSDateComponents* currentComponents = [calendar components:unit fromDate:currentDay];
        currentComponents.day = 1;
        NSDate* currentDay = [calendar dateFromComponents:currentComponents];
        
        NSInteger index = endComponents.year - startComponents.year;
        
        NSDateComponents* monthComponents = [calendar components:unit fromDate:[calendar dateFromComponents:startComponents]];
        NSInteger month = monthComponents.month;
        
        NSMutableArray* muarr = [NSMutableArray array];
        
        for (int i = 0; i < (index + 1)*12; i++) {
            monthComponents.month = month + i;
            NSDate* date = [calendar dateFromComponents:monthComponents];
            [muarr addObject:date];
            
            if ([date compare: [currentDay initDate]] == NSOrderedSame) {
                if (completion) {
                    completion(i);
                }
            }
            
        }
        return muarr;
    }else if (type == DateSelectedYear){
        NSDateComponents* startComponents = [calendar components:NSCalendarUnitYear fromDate:tranStartDay];
        startComponents.month = 1;
        startComponents.day = 1;
        NSDateComponents* endComponents = [calendar components:NSCalendarUnitYear fromDate:tranEndDay];
        
        NSDateComponents* currentComponents = [calendar components:unit fromDate:currentDay];
        currentComponents.month = 1;
        currentComponents.day = 1;
        NSDate* currentDay = [calendar dateFromComponents:currentComponents];
        
        NSInteger index = endComponents.year - startComponents.year;
        
        NSDateComponents* yearComponents = [calendar components:unit fromDate:[calendar dateFromComponents:startComponents]];
        NSInteger year = yearComponents.year;
        
        NSMutableArray* muarr = [NSMutableArray array];
        for (int i = 0; i <= index; i++) {
            yearComponents.year = year + i;
            NSDate* date = [calendar dateFromComponents:yearComponents];
            [muarr addObject:date];
            
            if ([date compare: currentDay] == NSOrderedSame) {
                if (completion) {
                    completion(i);
                }
            }
        }
        return muarr;
    }
    
    return nil;
}


@end

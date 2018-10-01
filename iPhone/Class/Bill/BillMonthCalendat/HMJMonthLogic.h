//
//  HMJMonthLogic.h
//  KalMonth
//
//  Created by humingjing on 14-4-4.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMJMonthLogic : NSObject
{
    NSDate *baseDate;
    NSDate *fromDate;
    NSDate *toDate;
    NSArray *monthesInSelectedMonthGroup;
}

@property(nonatomic,strong) NSDate *baseDate;
@property(nonatomic,strong)NSDate *fromDate;
@property(nonatomic,strong)NSDate *toDate;
@property(nonatomic,strong)NSArray *monthesInSelectedMonthGroup;

- (void)retreatToPrevious5Monthes;
- (void)advanceToFollowing5Monthes;
@end

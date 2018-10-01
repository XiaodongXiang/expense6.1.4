//
//  HMJMonthMonthView.h
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMJMonthTileView;
@interface HMJMonthMonthView : UIView

- (void)showDates:(NSArray *)mainDates;
- (HMJMonthTileView *)mediumTileOf5Month;

@end

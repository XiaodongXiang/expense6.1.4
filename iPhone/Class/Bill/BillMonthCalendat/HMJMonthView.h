//
//  HMJMonthView.h
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HMJMonthGridView,HMJMonthLogic;
@protocol HMJMonthViewDelegate;
@interface HMJMonthView : UIView
{
    HMJMonthGridView    *gridView;
    HMJMonthLogic       *logic;
    id<HMJMonthViewDelegate> delegate;
}
@property(nonatomic,strong)HMJMonthGridView    *gridView;
@property(nonatomic,strong)HMJMonthLogic       *logic;
@property(nonatomic,strong)id<HMJMonthViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id<HMJMonthViewDelegate>)theDelegate logic:(HMJMonthLogic *)theLogic withShowModule:(BOOL)m;
- (void)showPrevious5Month;
- (void)showFollowing5Month;

- (void)slideDown;
- (void)slideUp;
-(void)slideNone;

@end


#pragma mark -

@class KalDate_bill_iPhone;

@protocol HMJMonthViewDelegate
- (void)showPrevious5Month;
- (void)showFollowing5Month;
- (void)didSelectMonth:(KalDate_bill_iPhone *)date;

@end

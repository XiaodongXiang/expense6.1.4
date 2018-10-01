//
//  HMJMonthGridView.h
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMJMonthLogic,HMJMonthMonthView,HMJMonthTileView;
@protocol HMJMonthViewDelegate;


@interface HMJMonthGridView : UIView
{
    id<HMJMonthViewDelegate> delegate;  // Assigned.

    HMJMonthLogic       *logic;
    HMJMonthMonthView   *frontMonthView;
    HMJMonthMonthView   *backMonthView;
    HMJMonthTileView    *selectedTile;
    BOOL transitioning;
    BOOL isTouch;
}
@property(nonatomic,strong)id<HMJMonthViewDelegate> delegate;

@property(nonatomic,strong)HMJMonthLogic       *logic;
@property(nonatomic,strong)HMJMonthMonthView   *frontMonthView;
@property(nonatomic,strong)HMJMonthMonthView   *backMonthView;
@property(nonatomic,strong)HMJMonthTileView    *selectedTile;
@property(nonatomic,assign)BOOL transitioning;
@property(nonatomic,assign)BOOL isTouch;

- (void)slideUp;
- (void)slideDown;
-(void)slideNone;

- (id)initWithFrame:(CGRect)frame logic:(HMJMonthLogic *)theLogic delegate:(id<HMJMonthViewDelegate>)theDelegate;

@end

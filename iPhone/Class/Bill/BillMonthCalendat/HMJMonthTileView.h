//
//  HMJMonthTileView.h
//  KalMonth
//
//  Created by humingjing on 14-4-4.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KalDate_bill_iPhone.h"
@interface HMJMonthTileView : UIView
{
    struct {
		unsigned int selected : 1;
	} flags;
    
    KalDate_bill_iPhone *date;
    UIView              *headBlueView;
    UIView              *rightLine;
    UIView              *bottomLine;
    CGPoint origin;
    
    BOOL overDue;
    NSDateFormatter *monthDateFormatter;
    NSDateFormatter *yearDateFormatter;
}

@property(nonatomic,strong)KalDate_bill_iPhone *date;
@property(nonatomic,assign)CGPoint origin;
@property (nonatomic, getter=isSelected) BOOL selected;


@property(nonatomic,assign)BOOL overDue;
@property(nonatomic,strong)NSDateFormatter *monthDateFormatter;
@property(nonatomic,strong)NSDateFormatter *yearDateFormatter;

- (id)initWithFrame:(CGRect)frame;
- (void)resetState;
@end

//
//  TrackerCell.m
//  Expense 5
//
//  Created by BHI_James on 4/24/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "TrackerCell.h"
#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"

@interface TrackerCell (SubviewFrames)
@end

@implementation TrackerCell

-(void)awakeFromNib
{
    [_categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [_categoryLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
    [_categoryLabel setTextAlignment:NSTextAlignmentLeft];
    [_categoryLabel setBackgroundColor:[UIColor clearColor]];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [_amountLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_exceptInCalendar_WithSize:15]];
    [_amountLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
    [_amountLabel setTextAlignment:NSTextAlignmentRight];
    [_amountLabel setBackgroundColor:[UIColor clearColor]];
    
    [_percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [_percentLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
    [_percentLabel setTextAlignment:NSTextAlignmentCenter];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    
    CALayer *layer=_colorLabel.layer;
    layer.masksToBounds=YES;
    [layer setCornerRadius:7];
    

    _lineH.constant = EXPENSE_SCALE;
    
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        _categoryToLeft.constant=40;
        _percentToRight.constant=124;
    }
    else if (IS_IPHONE_6)
    {
        _categoryToLeft.constant=40;
        _percentToRight.constant=147;
    }
    else if (IS_IPHONE_6PLUS)
    {
        _categoryToLeft.constant=40;
        _percentToRight.constant=162;
    }
    
}


@end

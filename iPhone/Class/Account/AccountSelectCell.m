//
//  CategorySelectCell.m
//  PokcetExpense
//
//  Created by ZQ on 12/6/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "AccountSelectCell.h"
@implementation AccountSelectCell

-(void)awakeFromNib
{
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [_nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    _lineH.constant = EXPENSE_SCALE;
    
}


@end
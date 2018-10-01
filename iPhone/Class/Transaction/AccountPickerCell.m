//
//  AccountPickerCell.m
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import "AccountPickerCell.h"

@implementation AccountPickerCell


- (void)awakeFromNib
{
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [_nameLabel setTextColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    _lineH.constant = EXPENSE_SCALE;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

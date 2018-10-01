//
//  CategoryCell.m
//  Expense 5
//
//  Created by BHI_James on 4/19/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "CategoryCell.h"
 
@implementation CategoryCell

-(void)awakeFromNib
{
    [_headImageView setBackgroundColor:[UIColor clearColor]];
    
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    _lineH.constant = EXPENSE_SCALE;
    
    self.thisCellisEdit = NO;

}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
        return;
    
    [super setEditing:selected animated:YES];
    if (selected)
    {
        _lineX.constant = 15;
    }
    else
        _lineX.constant = 46;
    
}

@end

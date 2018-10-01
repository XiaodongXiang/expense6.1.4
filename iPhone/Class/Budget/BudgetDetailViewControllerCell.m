//
//  BudgetDetailViewControllerCell.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-10-29.
//
//

#import "BudgetDetailViewControllerCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation BudgetDetailViewControllerCell


-(void)awakeFromNib
{
    //payee
    [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [_nameLabel setTextColor:[UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    //category
    [_categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [_categoryLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1]];
    [_categoryLabel setTextAlignment:NSTextAlignmentLeft];
    [_categoryLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [_spentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [_spentLabel setTextAlignment:NSTextAlignmentRight];
    [_spentLabel setBackgroundColor:[UIColor clearColor]];
    [_spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
    
    
    [_timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [_timeLabel setTextColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1.0]];
    
    _lineH.constant = EXPENSE_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

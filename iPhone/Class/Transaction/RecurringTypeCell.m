//
//  RecurringTypeCell.m
//  PocketExpense
//
//  Created by humingjing on 14/11/17.
//
//

#import "RecurringTypeCell.h"
#import "PokcetExpenseAppDelegate.h"

@implementation RecurringTypeCell

- (void)awakeFromNib
{
    
    _lineH.constant = EXPENSE_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

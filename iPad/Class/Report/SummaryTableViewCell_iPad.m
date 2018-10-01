//
//  SummaryTableViewCell_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import "SummaryTableViewCell_iPad.h"
#import "PokcetExpenseAppDelegate.h"

@implementation SummaryTableViewCell_iPad

- (void)awakeFromNib {
    PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _amountLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

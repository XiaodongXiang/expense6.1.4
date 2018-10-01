//
//  NetWorthTableViewCell_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/25.
//
//

#import "NetWorthTableViewCell_iPad.h"
#import "PokcetExpenseAppDelegate.h"


@implementation NetWorthTableViewCell_iPad

- (void)awakeFromNib {
    // Initialization code
    PokcetExpenseAppDelegate *appdelegate=(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _firstLineW.constant=EXPENSE_SCALE;
    _secondLineW.constant=EXPENSE_SCALE;
    _amountLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    _differenceLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

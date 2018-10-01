//
//  CashflowTableViewCell_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/25.
//
//

#import "CashflowTableViewCell_iPad.h"
#import "AppDelegate_iPad.h"
@implementation CashflowTableViewCell_iPad

- (void)awakeFromNib {
    AppDelegate_iPad *appdelegate=(AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    _firstLineW.constant=EXPENSE_SCALE;
    _secondLineW.constant=EXPENSE_SCALE;
    
    _flowInLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    _flowOutLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

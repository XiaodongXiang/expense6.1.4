//
//  CategoryTableViewCell_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import "CategoryTableViewCell_iPad.h"
#import "AppDelegate_iPad.h"
@implementation CategoryTableViewCell_iPad

- (void)awakeFromNib {
    AppDelegate_iPad *appdelegate=(AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    _firstLineW.constant=EXPENSE_SCALE;
    _secondLineW.constant=EXPENSE_SCALE;
    
    _percentLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    _amountLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    _bottomLineH.constant=EXPENSE_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NetWorthTableViewCell.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/18.
//
//

#import "NetWorthTableViewCell.h"

@implementation NetWorthTableViewCell

- (void)awakeFromNib {
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        _networthLabelToRight.constant=125;
    }
    else if (IS_IPHONE_6)
    {
        _networthLabelToRight.constant=151;
    }
    else if (IS_IPHONE_6PLUS)
    {
        _networthLabelToRight.constant=172;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

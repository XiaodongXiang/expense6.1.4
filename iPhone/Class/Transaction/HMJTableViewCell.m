//
//  HMJTableViewCell.m
//  PocketExpense
//
//  Created by humingjing on 15/2/2.
//
//

#import "HMJTableViewCell.h"

@implementation HMJTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

@end

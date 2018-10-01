//
//  menuTableViewCell.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/16.
//
//

#import "menuTableViewCell.h"

@implementation menuTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedBackgroundView=[[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:22/255.0 green:35/255.0 blue:42/255.0 alpha:1];
    
    if (IS_IPHONE_5)
    {
        _topLineWidth.constant=256;
        _bottomLineWidth.constant=256;
    }
    else if (IS_IPHONE_6)
    {
        _topLineWidth.constant=293;
        _bottomLineWidth.constant=293;
    }
    else if (IS_IPHONE_6PLUS)
    {
        _topLineWidth.constant=332;
        _bottomLineWidth.constant=332;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

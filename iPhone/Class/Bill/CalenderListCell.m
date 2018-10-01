//
//  CalenderListCell.m
//  BillKeeper
//
//  Created by APPXY_DEV on 13-9-5.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import "CalenderListCell.h"

@implementation CalenderListCell
@synthesize containtView,monthLabel,backImagenomal,cellDate,pastBillImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 64, 58);
        
        containtView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 58)];
        containtView.backgroundColor = [UIColor clearColor];
        
        backImagenomal = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 58)];
        backImagenomal.image = [UIImage imageNamed:@"month_64_58.png"];
        [containtView addSubview: backImagenomal];
        
        monthLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0,64, 30)];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        monthLabel.textColor = [UIColor colorWithRed:90.f/255.f green:121.f/255.f blue:165.f/255.f alpha:1];
        [containtView addSubview:monthLabel];
        
        
        //旋转内部的文字
        containtView.center = CGPointMake(self.bounds.size.height/2.0, self.bounds.size.width/2.0);
        containtView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:containtView];
        
        pastBillImage = [[UIImageView alloc]initWithFrame:CGRectMake(28, 40, 8, 8)];
        pastBillImage.image = [UIImage imageNamed:@"mark_red.png"];
        [containtView addSubview:pastBillImage];
        pastBillImage.hidden = YES;
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

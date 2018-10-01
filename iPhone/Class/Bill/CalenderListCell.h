//
//  CalenderListCell.h
//  BillKeeper
//
//  Created by APPXY_DEV on 13-9-5.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderListCell : UITableViewCell{
    UIView *containtView;
    UILabel *monthLabel;
    UIImageView *backImagenomal;
    UIImageView *pastBillImage;
    NSDate *cellDate;
}

@property (nonatomic,strong)UIView *containtView;
@property (nonatomic,strong)UILabel *monthLabel;
@property (nonatomic,strong)UIImageView *backImagenomal;
@property(nonatomic,strong)UIImageView *pastBillImage;
@property (nonatomic,strong)NSDate *cellDate;
@end

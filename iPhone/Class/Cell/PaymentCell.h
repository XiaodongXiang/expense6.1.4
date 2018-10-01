//
//  PaymentCell.h
//  Expense 5
//
//  Created by BHI_James on 5/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PaymentCell : UITableViewCell 

@property (nonatomic, strong) UILabel			*dateLabel;
@property (nonatomic, strong) UILabel			*accountLabel;
@property (nonatomic, strong) UILabel			*amountLabel;
@property(nonatomic,strong)UIImageView                                 *categoryImage;

@end

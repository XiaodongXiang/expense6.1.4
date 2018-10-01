//
//  ipad_PaymentCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-18.
//
//

#import <UIKit/UIKit.h>

@interface ipad_PaymentCell : UITableViewCell
{
	UIImageView									*bgImageView;
	UILabel										*dateLabel;
	UILabel										*accountLabel;
	UILabel										*amountLabel;
    UIImageView                                 *categoryImage;
}

@property (nonatomic, strong) UIImageView		*bgImageView;
@property (nonatomic, strong) UILabel			*dateLabel;
@property (nonatomic, strong) UILabel			*accountLabel;
@property (nonatomic, strong) UILabel			*amountLabel;
@property(nonatomic,strong)UIImageView                                 *categoryImage;

@end

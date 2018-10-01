//
//  ipad_BudgetTransactionCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@interface ipad_BudgetTransactionCell : UITableViewCell
{
    UIImageView							    *bgImageView;
	UILabel									*nameLabel;
    
	UILabel                                 *categoryLabel;
	UILabel									*spentLabel;
	UILabel									*timeLabel;
    
}

@property (nonatomic,strong) UIImageView    *bgImageView;
@property (nonatomic,strong) UILabel		*nameLabel;
@property (nonatomic,strong) UILabel        *categoryLabel;
@property (nonatomic,strong) UILabel        *spentLabel;
@property (nonatomic,strong) UILabel        *timeLabel;


@end

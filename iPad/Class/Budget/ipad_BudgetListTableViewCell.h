//
//  ipad_BudgetListTableViewCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@interface ipad_BudgetListTableViewCell : UITableViewCell
{
    UIImageView     *categoryIcon;
    UILabel         *categoryLabel;
    UITextField     *textAmountText;
    UIImageView     *bgImageView;
}
@property(nonatomic,strong) UIImageView     *categoryIcon;
@property(nonatomic,strong) UILabel         *categoryLabel;
@property(nonatomic,strong) UITextField     *textAmountText;

@property(nonatomic,strong) UIImageView     *bgImageView;

@end

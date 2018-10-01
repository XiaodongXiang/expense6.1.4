//
//  BudgetListTableViewCell.h
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import <UIKit/UIKit.h>

@interface BudgetListTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView     *categoryIcon;
@property(nonatomic,strong)IBOutlet UILabel         *categoryLabel;
@property(nonatomic,strong)IBOutlet UITextField     *textAmountText;
@property(nonatomic,strong)IBOutlet UIView          *line1;
@property(nonatomic,strong)IBOutlet UIView          *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2X;

@end

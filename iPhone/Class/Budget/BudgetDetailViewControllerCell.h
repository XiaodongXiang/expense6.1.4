//
//  BudgetDetailViewControllerCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-10-29.
//
//

#import <UIKit/UIKit.h>

@interface BudgetDetailViewControllerCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel		*nameLabel;
@property (nonatomic,strong)IBOutlet  UILabel        *categoryLabel;
@property (nonatomic,strong)IBOutlet  UILabel        *spentLabel;
@property (nonatomic,strong)IBOutlet  UILabel        *timeLabel;
@property(nonatomic,strong)IBOutlet UIView           *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameToTop;

@end

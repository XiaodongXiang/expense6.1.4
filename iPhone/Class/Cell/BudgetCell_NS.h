//
//  BudgetCell.h
//  Expense 5
//
//  Created by BHI_James on 4/22/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "budgetBar.h"
@class BudgetViewController;
@interface BudgetCell_NS : UITableViewCell 


@property (nonatomic, strong)IBOutlet UILabel       *nameLabel;

@property (strong, nonatomic)  budgetBar *budgetBar;
@property (strong, nonatomic) IBOutlet UILabel *spentLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spentLabelToRight;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *budgetLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *budgetLabelToRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;

@end

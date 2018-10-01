//
//  BudgetTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import <UIKit/UIKit.h>

@class BudgetCountClass;
@interface BudgetTableViewCell : UITableViewCell

@property(nonatomic, strong)BudgetCountClass * budgetCountClass;

@property(nonatomic, assign)double allBudgetAmount;
@property(nonatomic, assign)double expenseAmount;

@end

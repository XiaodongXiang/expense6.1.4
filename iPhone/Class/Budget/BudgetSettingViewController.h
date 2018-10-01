//
//  BudgetSettingViewController.h
//  PocketExpense
//
//  Created by humingjing on 15/1/19.
//
//

#import <UIKit/UIKit.h>

@class BudgetListViewController;
@class BudgetViewController;

@interface BudgetSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *budgetArray;
    double               totalBudgetAmount;
}

@property(nonatomic,weak)IBOutlet UITableView           *budgetTabel;
@property(nonatomic,weak)IBOutlet UITableViewCell       *categoryCell;
@property(nonatomic,weak)IBOutlet UITableViewCell       *repeatCell;
@property(nonatomic,weak)IBOutlet UILabel               *categoryLabelText;
@property(nonatomic,weak)IBOutlet UILabel               *repeatLabelText;

@property(nonatomic,weak)IBOutlet UILabel               *categoryLabel;
@property(nonatomic,weak)IBOutlet UIButton              *weeklyBtn;
@property(nonatomic,weak)IBOutlet UIButton              *monthlyBtn;

@property(nonatomic,strong)BudgetListViewController    *budgetListViewController;
@property(nonatomic,strong)BudgetViewController *budgetViewController;
@end

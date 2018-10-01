//
//  ipad_BudgetSettingViewController.h
//  PocketExpense
//
//  Created by humingjing on 15/1/20.
//
//

#import <UIKit/UIKit.h>

@class ipad_BudgetListViewController,ipad_BudgetViewController;

@interface ipad_BudgetSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *budgetArray;
    double               totalBudgetAmount;
}

@property(nonatomic,weak)IBOutlet UITableView           *budgetTabel;
@property(nonatomic,strong)IBOutlet UITableViewCell       *categoryCell;
@property(nonatomic,strong)IBOutlet UITableViewCell       *repeatCell;
@property(nonatomic,weak)IBOutlet UILabel               *categoryLabelText;
@property(nonatomic,weak)IBOutlet UILabel               *repeatLabelText;

@property(nonatomic,weak)IBOutlet UILabel               *categoryLabel;
@property(nonatomic,weak)IBOutlet UIButton              *weeklyBtn;
@property(nonatomic,weak)IBOutlet UIButton              *monthlyBtn;

@property(nonatomic,strong)ipad_BudgetListViewController    *budgetListViewController;
@property(nonatomic,strong)ipad_BudgetViewController        *budgetViewController;

@end

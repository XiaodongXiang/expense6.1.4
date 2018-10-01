//
//  BudgetListViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import <UIKit/UIKit.h>

@class TransactionCategorySplitViewController,BudgetSettingViewController;
@interface BudgetListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    
    UIButton        *addBudgetBtn;
    UITextField     *tcsvc_TextField;
    UILabel         *budgetAmountLabel;
}
@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)NSMutableArray  *budgetExistArray;//数据库中已经保存的budget
@property(nonatomic,strong)NSMutableArray  *budgetEditArray;//即将要编辑的budget

@property(nonatomic,strong)BudgetSettingViewController *budgetSettingViewController;
@property(nonatomic,strong)TransactionCategorySplitViewController *transactionCategorySplitViewController;
@property(nonatomic,assign)BOOL transactionSpliteViewToBudgetListView;

@end

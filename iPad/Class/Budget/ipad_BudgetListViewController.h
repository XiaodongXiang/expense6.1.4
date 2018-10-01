//
//  ipad_BudgetListViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@class ipad_BudgetSettingViewController,ipad_TransacationSplitViewController;
@interface ipad_BudgetListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UITableView     *myTableView;
    NSMutableArray  *budgetExistArray;//数据库中已经保存的budget
    NSMutableArray  *budgetEditArray;//即将要编辑的budget
    UIButton        *addBudgetBtn;
    UITextField     *tcsvc_TextField;
    UILabel         *budgetAmountLabel;
    
    ipad_TransacationSplitViewController *iTransactionCategorySplitViewController;
    BOOL                    transactionSpliteViewToBudgetListView;
}
@property(nonatomic,strong)IBOutlet UITableView     *myTableView;

@property(nonatomic,strong)UIButton        *addBudgetBtn;
@property(nonatomic,strong)UITextField     *tcsvc_TextField;
@property(nonatomic,strong)UILabel         *budgetAmountLabel;

@property(nonatomic,strong)NSMutableArray           *budgetExistArray;
@property(nonatomic,strong)NSMutableArray           *budgetEditArray;

@property(nonatomic,strong)ipad_BudgetSettingViewController *budgetSettingViewController;
@property(nonatomic,strong)ipad_TransacationSplitViewController *iTransactionCategorySplitViewController;
@property(nonatomic,assign)BOOL transactionSpliteViewToBudgetListView;

@end

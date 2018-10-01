//
//  TransactionCategorySplitViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import <UIKit/UIKit.h>

@class TransactionEditViewController,CategorySelect,BudgetViewController,BudgetIntroduceViewController,BudgetListViewController;
@interface TransactionCategorySplitViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>{
    
    UIButton    *nextBtn;
    UITableView *tcsvc_tableView;
    UITextField *tcsvc_TextField;
    
    NSMutableArray  *categoryArray;
    NSMutableArray  *selectedCategoryArray;
    NSMutableArray  *selected_editCategory_fromBudgetListViewArray;
    
    TransactionEditViewController *tcsvc_transactionEditViewController;
    
    BudgetIntroduceViewController   *budgetIntroduceViewController;
    BudgetListViewController        *budgetListViewController;
    UIBarButtonItem *nextBar;
}

@property(nonatomic,strong)UIButton    *nextBtn;
@property(nonatomic,strong)IBOutlet UITableView *tcsvc_tableView;
@property(nonatomic,strong)NSMutableArray  *categoryArray;
@property(nonatomic,strong)UITextField *tcsvc_TextField;
@property(nonatomic,strong)NSMutableArray  *selectedCategoryArray;
@property(nonatomic,strong)NSMutableArray  *selected_editCategory_fromBudgetListViewArray;
@property(nonatomic,strong)UIBarButtonItem *nextBar;

@property(nonatomic,strong)TransactionEditViewController *tcsvc_transactionEditViewController;
@property(nonatomic,strong)BudgetIntroduceViewController   *budgetIntroduceViewController;
@property(nonatomic,strong)BudgetListViewController        *budgetListViewController;

-(void)refleshUI;
@end

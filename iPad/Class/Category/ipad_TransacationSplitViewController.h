//
//  TransactionCategorySplitViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import <UIKit/UIKit.h>

@class CategorySelect;
@class  ipad_TranscactionQuickEditViewController,ipad_BudgetViewController,ipad_BudgetIntroduceViewController,ipad_BudgetListViewController;
@interface ipad_TransacationSplitViewController: UIViewController<UITextFieldDelegate>{
    
    UIButton            *nextBtn;
    UIBarButtonItem    *nextBar;
    UITableView *tcsvc_tableView;
    UITextField *tcsvc_TextField;
    
    NSMutableArray  *categoryArray;
    NSMutableArray  *selectedCategoryArray;
    NSMutableArray  *selected_editCategory_fromBudgetListViewArray;
    
    ipad_TranscactionQuickEditViewController *iTransactionEditViewController;
    ipad_BudgetIntroduceViewController  *iBudgetIntroduceViewController;
    ipad_BudgetListViewController        *iBudgetListViewController;

}
@property(nonatomic,strong)UIButton            *nextBtn;
@property(nonatomic,strong)UIBarButtonItem    *nextBar;
@property(nonatomic,strong)IBOutlet UITableView *tcsvc_tableView;
@property(nonatomic,strong)NSMutableArray  *categoryArray;
@property(nonatomic,strong)UITextField *tcsvc_TextField;
@property(nonatomic,strong)NSMutableArray  *selectedCategoryArray;
@property(nonatomic,strong)NSMutableArray  *selected_editCategory_fromBudgetListViewArray;

@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *iTransactionEditViewController;
@property(nonatomic,strong)ipad_BudgetIntroduceViewController  *iBudgetIntroduceViewController;
@property(nonatomic,strong)ipad_BudgetListViewController        *iBudgetListViewController;

-(void)refleshUI;
@end

//
//  TransactionCategoryViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import <UIKit/UIKit.h>
#import "ipad_TranscactionQuickEditViewController.h"

@class ipad_SettingViewController;

@class ipad_CategoryEditViewController,ipad_TransacationSplitViewController,ipad_SettingPayeeEditViewController;
@class ipad_BillEditViewController;
@class iPad_GeneralViewController;

@interface ipad_TranscationCategorySelectViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger           deleteIndex;
    NSMutableArray      *tcvc_allCategoryArray;
    NSMutableArray      *tcvc_justCategoryArray;
}
@property(nonatomic,strong)IBOutlet UIView      *tcvc_expenseIncomeView;
@property(nonatomic,strong)IBOutlet UIButton    *tcvc_expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton    *tcvc_incomeBtn;
@property(nonatomic,strong)         UIButton    *tcvc_searchBtn;
@property(nonatomic,strong)         UILabel     *tcvc_headLabel;

@property(nonatomic,strong)IBOutlet UITableView *tcvc_categoryTableView;
@property(nonatomic,strong)IBOutlet UIButton    *tcvc_splitBtn;
@property(nonatomic,strong)IBOutlet UIView      *tvc_tabBarView;

@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *transactionEditViewController;
@property(nonatomic,strong)ipad_SettingPayeeEditViewController *payeeEditViewController;
@property(nonatomic,strong)ipad_SettingViewController *settingViewController;
@property(nonatomic,strong)ipad_CategoryEditViewController *categoryEditViewController;
@property(nonatomic,strong)ipad_TransacationSplitViewController *transactionCategorySplitViewController;
@property(nonatomic,strong)ipad_BillEditViewController *billEditViewController;
@property(nonatomic,strong)iPad_GeneralViewController *genetalViewController;

-(void)refleshUI;
@end

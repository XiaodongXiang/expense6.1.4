//
//  TransactionCategoryViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import <UIKit/UIKit.h>
#import "TransactionEditViewController.h"
#import "SettingPayeeEditViewController.h"
#import "SettingViewController.h"

@class GeneralViewController;
@class CategoryEditViewController,TransactionCategorySplitViewController,
SettingPayeeEditViewController;

@protocol SettingTransactionCategoryViewDelegate <NSObject>
-(void)returnTransactionCategoryChange;
@end

@interface TransactionCategoryViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger deleteIndex;
}
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@property(nonatomic, weak)id<SettingTransactionCategoryViewDelegate> xxdDelegate;

@property(nonatomic, assign)TransactionType type;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewB;
@property(nonatomic,strong)IBOutlet UIView      *tcvc_expenseIncomeView;
@property(nonatomic,strong)IBOutlet UIButton    *tcvc_expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton    *tcvc_incomeBtn;
@property(nonatomic,strong) UIButton            *tcvc_searchBtn;
@property(nonatomic,strong) UILabel             *tcvc_headLabel;

@property(nonatomic,strong)IBOutlet UITableView *tcvc_categoryTableView;
//@property(nonatomic,strong)IBOutlet UIButton    *tcvc_splitBtn;
//@property(nonatomic,strong)IBOutlet UIView      *tvc_tabBarView;

@property(nonatomic,strong)NSMutableArray       *tcvc_allCategoryArray;
@property(nonatomic,strong)NSMutableArray       *tcvc_justCategoryArray;

@property(nonatomic,strong)TransactionEditViewController *tcvc_transactionEditViewController;
@property(nonatomic,strong)SettingPayeeEditViewController *tvc_payeeEditViewController;
@property(nonatomic,strong)SettingViewController *settingViewController;
@property(nonatomic,strong)CategoryEditViewController *categoryEditViewController;
@property(nonatomic,strong)TransactionCategorySplitViewController *transactionCategorySplitViewController;
@property(nonatomic,strong)GeneralViewController       *generalViewController;

-(void)refleshUI;
@end

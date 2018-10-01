//
//  AccountPickerViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import <UIKit/UIKit.h>

@class TransactionEditViewController,Accounts;
@class AccountEditViewController;
@class GeneralViewController;
@interface AccountPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)TransactionEditViewController *transactionEditViewController;
@property(nonatomic,strong)IBOutlet UITableView *mytableView;
@property(nonatomic,strong)NSMutableArray *accountArray;
@property(nonatomic,strong)Accounts *selectedAccount;
@property(nonatomic,assign)int accountType;
@property(nonatomic,strong)AccountEditViewController *accountEditViewController;
@property(nonatomic,strong)GeneralViewController *generalViewController;
-(void)refleshUI;
@end

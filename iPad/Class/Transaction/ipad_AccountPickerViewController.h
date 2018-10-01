//
//  AccountPickerViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import <UIKit/UIKit.h>

@class ipad_TranscactionQuickEditViewController,Accounts,ipad_AccountEditViewController;
@class iPad_GeneralViewController;
@interface ipad_AccountPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *accountArray;
}

@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *transactionEditViewController;
@property(nonatomic,strong)IBOutlet UITableView *mytableView;
@property(nonatomic,strong)Accounts *selectedAccount;
@property(nonatomic,assign)int accountType;//0:account 1:from account 2:to account
@property(nonatomic,strong)ipad_AccountEditViewController *iAccountEditViewController;
@property(nonatomic,strong)iPad_GeneralViewController *generalViewController;
-(void)refleshUI;
@end

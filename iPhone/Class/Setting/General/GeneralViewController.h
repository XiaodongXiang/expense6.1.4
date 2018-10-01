//
//  GeneralViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-10-13.
//
//

#import <UIKit/UIKit.h>

#import "Accounts.h"
#import "Category.h"

@interface GeneralViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel         *accountLabelText;
    UILabel         *categoryLabelText;
    UILabel         *amountLabelText;
    UILabel         *weeksLabelText;
    UILabel         *notificationLabelText;
    
    UILabel         *accountLabel;
    UILabel         *categoryLabel;
    UIButton        *leftBtn;
    UIButton        *spentBtn;
    UIButton        *sunBtn;
    UIButton        *monBtn;
    UISwitch        *notificationSwitch;
    
    UITableView     *myTableView;
    UITableViewCell *accountCell;
    UITableViewCell *categoryCell;
    UITableViewCell *amountCell;
    UITableViewCell *weeksCell;
    UITableViewCell *notificationCell;
    
    Accounts        *defaultAccount;
    Category        *defaultExpenseCategory;
    Category        *defaultIncomeCategory;
    
}

@property(nonatomic,strong)IBOutlet UILabel     *accountLabelText;
@property(nonatomic,strong)IBOutlet UILabel     *categoryLabelText;
@property(nonatomic,strong)IBOutlet UILabel     *amountLabelText;
@property(nonatomic,strong)IBOutlet UILabel     *weeksLabelText;
@property(nonatomic,strong)IBOutlet UILabel     *notificationLabelText;

@property(nonatomic,strong)IBOutlet UILabel     *accountLabel;
@property(nonatomic,strong)IBOutlet UILabel     *categoryLabel;
@property(nonatomic,strong)IBOutlet UIButton    *leftBtn;
@property(nonatomic,strong)IBOutlet UIButton    *spentBtn;
@property(nonatomic,strong)IBOutlet UIButton    *sunBtn;
@property(nonatomic,strong)IBOutlet UIButton    *monBtn;
@property(nonatomic,strong)IBOutlet UISwitch    *notificationSwitch;

@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)IBOutlet UITableViewCell *accountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *categoryCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *amountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *weeksCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *notificationCell;

@property(nonatomic,strong) Accounts        *defaultAccount;
@property(nonatomic,strong) Category        *defaultExpenseCategory;
@property(nonatomic,strong) Category        *defaultIncomeCategory;
@end

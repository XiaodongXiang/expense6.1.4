//
//  TransactionRecurringViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import <UIKit/UIKit.h>

@class TransactionEditViewController;
@interface TransactionRecurringViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSString *recurringType;
    NSMutableArray   *recurringTypeArray;
    TransactionEditViewController *transactionEditViewController;
}
@property(nonatomic,strong)IBOutlet UITableView             *myTableView;
@property(nonatomic,strong)             NSString            *recurringType;
@property(nonatomic,strong)     NSMutableArray              *recurringTypeArray;
@property(nonatomic,strong)TransactionEditViewController    *transactionEditViewController;

@end

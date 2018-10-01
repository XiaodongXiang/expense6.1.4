//
//  ipad_TransactionRecurringViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import <UIKit/UIKit.h>

@class ipad_TranscactionQuickEditViewController;
@interface ipad_TransactionRecurringViewController : UIViewController
@property(nonatomic,strong)IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSString *recurringType;
@property(nonatomic,strong)NSMutableArray   *recurringTypeArray;
@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *itransactionEditViewController;
@end

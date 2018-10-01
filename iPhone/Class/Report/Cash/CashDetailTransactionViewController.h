//
//  CashDetailTransactionViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-31.
//
//

#import <UIKit/UIKit.h>

@class TransactionEditViewController,SearchRelatedViewController,ExpenseViewController;
@interface CashDetailTransactionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)IBOutlet UITableView *ctvc_tableView;

@property(nonatomic,strong)NSDate               *ctvc_startDate;
@property(nonatomic,strong)NSDate               *ctvc_endDate;

@property(nonatomic,assign)NSInteger            swipCellIndex;
@property(nonatomic,assign)NSInteger           cdvc_dayType;
@property(nonatomic,strong)NSDateFormatter      *ctvc_dateFoamatter;
@property(nonatomic,strong)NSDateFormatter      *ctvc_naviTitleDataFormatter;
@property(nonatomic,strong)NSMutableArray       *transactionArray;
@property(nonatomic,strong)TransactionEditViewController *transactionEditViewController;
@property(nonatomic,strong)SearchRelatedViewController *searchRelatedViewController;
@property(nonatomic,strong)ExpenseViewController    *expenseViewController;
-(void)refleshUI;
@end

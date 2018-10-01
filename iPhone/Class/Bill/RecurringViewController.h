//
//  RecurringViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import <UIKit/UIKit.h>
#import "UIHMJDatePicker.h"

@class BillEditViewController;
@interface RecurringViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView     *myTableView;
    NSString        *recurringType;
    
    NSMutableArray  *recurringArray;
    BillEditViewController *billEditViewController;
}

@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)NSString        *recurringType;
@property(nonatomic,strong)NSMutableArray  *recurringArray;
@property(nonatomic,strong)BillEditViewController *billEditViewController;
@end

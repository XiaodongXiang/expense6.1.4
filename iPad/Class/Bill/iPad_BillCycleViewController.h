//
//  iPad_BillCycleViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import <UIKit/UIKit.h>
#import "UIHMJDatePicker.h"

@class ipad_BillEditViewController;

@interface iPad_BillCycleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView     *myTableView;
    NSString        *recurringType;
    NSMutableArray  *recurringArray;
    ipad_BillEditViewController *iBillEditViewController;
}

@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)NSString        *recurringType;
@property(nonatomic,strong)NSMutableArray  *recurringArray;
@property(nonatomic,strong)ipad_BillEditViewController *iBillEditViewController;


@end

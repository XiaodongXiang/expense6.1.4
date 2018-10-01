//
//  ipad_DateSelBillsViewController.h
//  PocketExpense
//
//  Created by MV on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*======================点击bill中日历的某一格，显示当天bill的信息*/
#import <UIKit/UIKit.h>
@class ipad_BillsViewController;
@interface ipad_DateSelBillsViewController : UITableViewController<UIActionSheetDelegate>
{
    ipad_BillsViewController *iBillsViewController;
    NSDate *selDate;
    NSMutableArray *selDateBillsArray;
    NSDateFormatter *outputFormatterCell;
    NSIndexPath             *swipIndex;

}
@property (nonatomic, strong) ipad_BillsViewController *iBillsViewController;
@property (nonatomic, strong)  NSDate *selDate;
@property (nonatomic, strong)  NSMutableArray *selDateBillsArray;
@property (nonatomic, strong)  NSDateFormatter *outputFormatterCell;

@property(nonatomic,strong)NSIndexPath             *swipIndex;
@end

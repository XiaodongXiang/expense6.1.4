//
//  SetDateRangeViewController_iPhone.h
//  PocketExpense
//
//  Created by MV on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "RepTransactionFilterViewController.h"
#import "RepCashflowFilterViewController.h"
//#import "RepBillFilterViewController.h"

@interface SetDateRangeViewController_iPhone : UITableViewController {
     RepTransactionFilterViewController *repTransactionFilterViewController;
    RepCashflowFilterViewController *repCashflowFilterViewController;
//    RepBillFilterViewController     *repBillFilterViewController;
	NSString *moduleString;
	NSString *dateRangeString;
    
	NSInteger currentSelect;
	BOOL isSubPopView;
}

@property (nonatomic, strong) RepTransactionFilterViewController *repTransactionFilterViewController;
@property (nonatomic, strong) RepCashflowFilterViewController *repCashflowFilterViewController;
//@property (nonatomic, strong) RepBillFilterViewController     *repBillFilterViewController;

@property (nonatomic, copy ) NSString *moduleString;
@property (nonatomic, copy ) NSString *dateRangeString;

@property (nonatomic, assign ) NSInteger currentSelect;
@property (nonatomic, assign ) BOOL isSubPopView;

@end

//
//  RepSelectCategoryViewController_iPhone.h
//  PocketExpense
//
//  Created by MV on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepTransactionFilterViewController.h"
//#import "RepBillFilterViewController.h"

@interface RepSelectCategoryViewController_iPhone :  UITableViewController {
    
	RepTransactionFilterViewController   *iTranReportViewController;
//    RepBillFilterViewController          *iBillReportViewController;
    NSString *selectType;
    BOOL isSelectAll;

}

@property (nonatomic, strong) RepTransactionFilterViewController *iTranReportViewController;
//@property (nonatomic, strong)  RepBillFilterViewController          *iBillReportViewController;

@property (nonatomic, strong) NSString *selectType;
@property (nonatomic, assign) BOOL isSelectAll;

@end
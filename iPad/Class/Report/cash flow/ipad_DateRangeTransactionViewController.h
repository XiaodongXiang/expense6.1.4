//
//  ipad_DateRangeTransactionViewController.h
//  PocketExpense
//
//  Created by MV on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrokenLineObject;
@class ipad_ReportCashFlowViewController;

@interface ipad_DateRangeTransactionViewController :UITableViewController
{
  	NSDateFormatter				*outputFormatter;
    NSDateFormatter				*monthFormatter;
}
@property (nonatomic, strong)  BrokenLineObject             *bcd;
@property (nonatomic, strong)  IBOutlet UISegmentedControl  *typeSeg;
@property (nonatomic, strong)  IBOutlet UITableView         *myTablewView;
@property (nonatomic, copy)     NSString                    *dateRangeStr;
@property (nonatomic, strong)  ipad_ReportCashFlowViewController *iReportCashFlowViewController;

@end

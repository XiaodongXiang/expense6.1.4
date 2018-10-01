//
//  XDEditTransCategorySplitTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/11.
//

#import <UIKit/UIKit.h>
@class XDAddTransactionViewController;

@interface XDEditTransCategorySplitTableViewController : UITableViewController

@property(nonatomic, assign)NSMutableArray * editSplitCategoryMuArr;

@property(nonatomic, strong)XDAddTransactionViewController * addVc;

@end

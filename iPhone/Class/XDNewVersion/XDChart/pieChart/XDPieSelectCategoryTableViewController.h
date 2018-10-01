//
//  XDPieSelectCategoryTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/27.
//

#import <UIKit/UIKit.h>
#import "XDDateSelectedModel.h"

@class XDPieChartModel,Accounts;

@interface XDPieSelectCategoryTableViewController : UITableViewController

@property(nonatomic, strong)XDPieChartModel * model;
@property(nonatomic, strong)NSDate * startDate;
@property(nonatomic, strong)NSDate * endDate;

@property(nonatomic, assign)DateSelectedType type;
@property(nonatomic, strong)Accounts * account;


@end

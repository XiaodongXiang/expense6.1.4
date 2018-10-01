//
//  XDPieSelectCategoryViewController.h
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/16.
//

#import <UIKit/UIKit.h>
#import "XDDateSelectedModel.h"
@class XDPieChartModel,Accounts;

@interface XDPieSelectCategoryViewController : UIViewController

@property(nonatomic, strong)XDPieChartModel * model;
@property(nonatomic, strong)NSDate * startDate;
@property(nonatomic, strong)NSDate * endDate;

@property(nonatomic, assign)DateSelectedType type;
@property(nonatomic, strong)Accounts * account;

@end

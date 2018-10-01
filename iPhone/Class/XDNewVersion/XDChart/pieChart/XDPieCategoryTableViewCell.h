//
//  XDPieCategoryTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/26.
//

#import <UIKit/UIKit.h>

@class XDPieChartModel;
@interface XDPieCategoryTableViewCell : UITableViewCell

@property(nonatomic, strong)XDPieChartModel * model;
@property(nonatomic, assign)double amount;

@end

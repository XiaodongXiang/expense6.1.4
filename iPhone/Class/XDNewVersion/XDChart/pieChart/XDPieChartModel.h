//
//  XDPieChartModel.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/22.
//

#import <Foundation/Foundation.h>
@class Category;

@interface XDPieChartModel : NSObject
@property(nonatomic, strong)Category * category;
@property(nonatomic, assign)double amount;
@property(nonatomic, copy)NSString * type;


@end

//
//  XDChartModel.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/1.
//

#import <Foundation/Foundation.h>

@interface XDChartModel : NSObject

@property(nonatomic, strong)NSMutableArray * yMuArr;
@property(nonatomic, strong)NSMutableArray * xMuArr;
@property(nonatomic, strong)NSMutableArray * dataMuArr;
@property(nonatomic, assign)BOOL hasData;

@end

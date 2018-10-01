//
//  XDPiePageView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/23.
//

#import <UIKit/UIKit.h>

@class XDPieChartModel;
@protocol XDPiePageViewDelegate <NSObject>
-(void)returnSelectedPieModel:(XDPieChartModel*)model;
@end
@interface XDPiePageView : UIView

@property(nonatomic, strong)NSArray * dataArray;

@property(nonatomic, weak)id<XDPiePageViewDelegate> delegate;

@end

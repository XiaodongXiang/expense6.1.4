//
//  XDChartPageView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/26.
//

#import <UIKit/UIKit.h>
#import "XDTimeSelectView.h"
@class XDChartModel,Accounts;

@protocol XDChartPageViewDelegate <NSObject>
-(void)returnPieViewDataArray:(NSArray*)array pieType:(NSString* )string;
@end
@interface XDChartPageView : UIView

@property(nonatomic, strong)NSDate * date;
@property(nonatomic, assign)DateSelectedType type;
@property(nonatomic, strong)Accounts * account;

@property(nonatomic, strong)NSArray * dateArr;
@property(nonatomic, weak)id<XDChartPageViewDelegate> delegate;

-(void)scrollToNetworth;

@end

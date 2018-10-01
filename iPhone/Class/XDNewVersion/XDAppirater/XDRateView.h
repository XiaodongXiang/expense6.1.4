//
//  XDRateView.h
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/23.
//

#import <UIKit/UIKit.h>

@protocol XDRateDelegate <NSObject>

-(void)likeApp;
-(void)hateApp;
-(void)cancelApp;
@end

@interface XDRateView : UIView

@property(nonatomic, weak)id<XDRateDelegate> xxDelegate;

@end

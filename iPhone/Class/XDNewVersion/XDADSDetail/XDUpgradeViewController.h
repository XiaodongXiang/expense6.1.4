//
//  XDUpgradeViewController.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/8/28.
//

#import <UIKit/UIKit.h>

@protocol XDUpgradeViewDelegate <NSObject>

@optional
-(void)XDUpgradeViewDismiss;

@end
@interface XDUpgradeViewController : UIViewController
@property(weak  ,nonatomic)id<XDUpgradeViewDelegate> xxdDelegate;
@property (assign, nonatomic) BOOL isChristmasEnter;

@end

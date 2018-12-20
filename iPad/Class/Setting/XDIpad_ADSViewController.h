//
//  XDIpad_ADSViewController.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/8/29.
//

#import <UIKit/UIKit.h>

@protocol XDIpad_ADSViewDelegate <NSObject>


@optional
-(void)ipadUpgradeViewDismiss;

@end
@interface XDIpad_ADSViewController : UIViewController

@property( nonatomic, weak)id<XDIpad_ADSViewDelegate> xxdDelegate;

@end

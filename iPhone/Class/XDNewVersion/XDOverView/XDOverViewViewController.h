//
//  XDOverViewViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/1.
//

#import <UIKit/UIKit.h>

@class XDTabbarViewController;
typedef void(^returnSelectedDate)(NSDate* selectedDate);

@interface XDOverViewViewController : UIViewController

@property(nonatomic, copy)returnSelectedDate dateBlock;
@property(nonatomic, strong)XDTabbarViewController * tabbarVc;

-(void)reloadTableView;

-(void)scrollToToday;

@end

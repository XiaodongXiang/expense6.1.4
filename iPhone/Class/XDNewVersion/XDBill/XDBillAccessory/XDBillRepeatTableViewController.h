//
//  XDBillRepeatTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import <UIKit/UIKit.h>

@protocol XDBillRepeatTableViewDelegate <NSObject>
-(void)returnBillRepeatSelect:(NSString*)string;
@end
@interface XDBillRepeatTableViewController : UITableViewController

@property(nonatomic, copy)NSString * repeatString;
@property(nonatomic, weak)id<XDBillRepeatTableViewDelegate> xxdDelegate;

@end

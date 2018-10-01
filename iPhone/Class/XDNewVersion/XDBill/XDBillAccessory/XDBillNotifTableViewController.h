//
//  XDBillNotifTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import <UIKit/UIKit.h>

@protocol  XDBillNotifTableViewDelegate<NSObject>
-(void)returnBillNotifRemindMe:(NSString*)remindMe remindAt:(NSDate*)remindAt;
@end
@interface XDBillNotifTableViewController : UITableViewController
@property(nonatomic, weak)id<XDBillNotifTableViewDelegate> xxdDelegate;

@property(nonatomic, strong)NSDate * remindDate;
@property(nonatomic, copy)NSString * remindStr;

@end

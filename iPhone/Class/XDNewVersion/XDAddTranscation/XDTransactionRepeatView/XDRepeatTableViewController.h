//
//  XDRepeatTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/25.
//

#import <UIKit/UIKit.h>

@protocol  XDRepeatTableViewDelegate <NSObject>
-(void)returnSelectedRepeat:(NSString*)string;
@end

@interface XDRepeatTableViewController : UITableViewController
@property(nonatomic, weak)id<XDRepeatTableViewDelegate> repeatDelegate;

@property(nonatomic, copy)NSString * repeatStr;

@end

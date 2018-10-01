//
//  XDBillEndDateTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import <UIKit/UIKit.h>

@protocol XDBillEndDateTableViewDelegate <NSObject>

-(void)returnEndDate:(NSDate*)endDate;

@end

@interface XDBillEndDateTableViewController : UITableViewController

@property(nonatomic, strong)NSDate * endDate;
@property(nonatomic, weak)id<XDBillEndDateTableViewDelegate> xxdDelegate;

@end

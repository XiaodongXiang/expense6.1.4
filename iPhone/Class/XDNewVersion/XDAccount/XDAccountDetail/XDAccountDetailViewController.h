//
//  XDAccountDetailViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/8.
//

#import <UIKit/UIKit.h>

@class AccountCount;
@interface XDAccountDetailViewController : UIViewController

@property(nonatomic, strong)AccountCount * account;
@property(nonatomic, strong)NSMutableArray * dataArray;

@end

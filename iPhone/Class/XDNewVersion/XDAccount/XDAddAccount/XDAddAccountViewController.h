//
//  XDAddAccountViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/6.
//

#import <UIKit/UIKit.h>

@class Accounts;

@protocol  XDAddAccountViewDelegate <NSObject>

@optional
-(void)returnAccount:(Accounts*)account;
-(void)returnEditAccount:(Accounts*)account;
@end

@interface XDAddAccountViewController : UIViewController

@property(nonatomic, strong)Accounts * editAccount;;
@property(nonatomic, weak)id<XDAddAccountViewDelegate> delegate;

@end

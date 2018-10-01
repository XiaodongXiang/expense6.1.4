//
//  XDNewTypeTableViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/14.
//

#import <UIKit/UIKit.h>
@class AccountType;

@protocol XDNewTypeTableViewDelegate <NSObject>

-(void)updateAccountType;
-(void)addNewAccountType:(AccountType*)newType;

@end

@interface XDNewTypeTableViewController : UITableViewController

@property(nonatomic, strong)AccountType * accountType;
@property(nonatomic, weak)id<XDNewTypeTableViewDelegate> addDelegate;


@end

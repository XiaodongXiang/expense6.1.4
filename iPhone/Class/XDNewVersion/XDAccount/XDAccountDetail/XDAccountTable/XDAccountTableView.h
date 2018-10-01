//
//  XDAccountTableView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/9.
//

#import <UIKit/UIKit.h>

@class AccountCount;
@class Transaction;
@protocol XDAccountTableViewDelegate <NSObject>
-(void)returnSelectedAccountTransaction:(Transaction*)transaction;

-(void)returnSwipeBtn:(NSInteger)index withTran:(Transaction*)transaction;
@end

@interface XDAccountTableView : UITableView

@property(nonatomic, strong)AccountCount * accounts;
@property(nonatomic, assign)BOOL recondile;
@property(nonatomic, assign)BOOL hide;
@property(nonatomic, weak)id<XDAccountTableViewDelegate> xxdDelegate;

-(void)refreshUI;
@end

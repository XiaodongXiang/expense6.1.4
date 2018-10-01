//
//  XDAddTransactionViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/12.
//

#import <UIKit/UIKit.h>

@class Transaction;
@class Accounts;

@protocol XDAddTransactionViewDelegate  <NSObject>

-(void)addTransactionCompletion;
@end

@interface XDAddTransactionViewController : UIViewController

@property(nonatomic, strong)NSDate * calSelectedDate;
@property(nonatomic, weak)id<XDAddTransactionViewDelegate> delegate;
@property(nonatomic, strong)Transaction * editTransaction;
@property(nonatomic, strong)Accounts * account;

@end

//
//  XDAccountDetailTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/9.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class Transaction;
@class Accounts;
@interface XDAccountDetailTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tranBalance;

@property(nonatomic, strong)Transaction * transaction;
@property(nonatomic, strong)Accounts * account;

@property(nonatomic, assign)BOOL cleared;

@end

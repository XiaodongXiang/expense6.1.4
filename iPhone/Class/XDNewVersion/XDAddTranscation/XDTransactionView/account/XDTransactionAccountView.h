//
//  XDTransactionAccountView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
@protocol XDTransactionAccountViewDelegate <NSObject>
-(void)returnSelectedAccount:(Accounts*)account;
@end
@interface XDTransactionAccountView : UITableView

@property(nonatomic, weak)id<XDTransactionAccountViewDelegate> accountDelegate;
@property(nonatomic, strong)Accounts * transAccount;

-(void)refreshData;

@end

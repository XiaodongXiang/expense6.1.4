//
//  XDTransferAccountView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/14.
//

#import <UIKit/UIKit.h>

@class Accounts;
@interface XDTransferAccountView : UIView

@property(nonatomic, strong)Accounts * account;
@property(nonatomic, assign)BOOL isFrom;


@end

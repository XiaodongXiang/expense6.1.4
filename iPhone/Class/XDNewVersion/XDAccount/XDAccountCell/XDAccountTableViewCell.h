//
//  XDAccountTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import <UIKit/UIKit.h>
@class AccountCount;

@protocol  XDAccountTableViewCellDelegate<NSObject>
-(void)selectedAccountEdit:(AccountCount*)account;
@end

@interface XDAccountTableViewCell : UITableViewCell

@property(nonatomic, strong)AccountCount * account;
@property(nonatomic, weak)id<XDAccountTableViewCellDelegate> xxdDelegate;


@end

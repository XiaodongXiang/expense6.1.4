//
//  XDTransactionAccountTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/25.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
@interface XDTransactionAccountTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UILabel *accountName;

@property(nonatomic, strong)Accounts * account;
@property(nonatomic, assign)BOOL accountSelected;

@end

//
//  XDBillItemTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/10.
//

#import <UIKit/UIKit.h>

#import "Transaction.h"
@interface XDBillItemTableViewCell : UITableViewCell

@property(nonatomic, strong)Transaction * transaction;

@end

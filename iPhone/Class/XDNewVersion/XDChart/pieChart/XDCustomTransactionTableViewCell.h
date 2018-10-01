//
//  XDCustomTransactionTableViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/27.
//

#import <UIKit/UIKit.h>

@interface XDCustomTransactionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *amountL;

@end

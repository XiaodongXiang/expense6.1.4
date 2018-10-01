//
//  CashFlowCell.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-31.
//
//

#import <UIKit/UIKit.h>

@interface CashFlowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *inAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *outamountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@end

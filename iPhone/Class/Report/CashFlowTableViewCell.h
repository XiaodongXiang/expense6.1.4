//
//  CashFlowTableViewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/12.
//
//

#import <UIKit/UIKit.h>

@interface CashFlowTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowInLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowInPercentage;
@property (strong, nonatomic) IBOutlet UILabel *flowOutPercentage;
@property (strong, nonatomic) IBOutlet UIImageView *flowInImage;
@property (strong, nonatomic) IBOutlet UIImageView *flowOutImage;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Right;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *flowinpercentToRight;

@end

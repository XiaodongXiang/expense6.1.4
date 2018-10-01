//
//  CashflowTableViewCell_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/25.
//
//

#import <UIKit/UIKit.h>

@interface CashflowTableViewCell_iPad : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowInLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowInPercentage;
@property (strong, nonatomic) IBOutlet UILabel *flowOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *flowOutPercentage;
@property (strong, nonatomic) IBOutlet UIImageView *flowInImage;
@property (strong, nonatomic) IBOutlet UIImageView *flowOutImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *flowinpercentWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *flowoutPercentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLineW;

@end

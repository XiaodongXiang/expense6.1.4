//
//  NetWorthTableViewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/18.
//
//

#import <UIKit/UIKit.h>

@interface NetWorthTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *netWorthLabel;

@property (strong, nonatomic) IBOutlet UILabel *differenceLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *networthLabelToRight;

@end

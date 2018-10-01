//
//  NetWorthTableViewCell_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/25.
//
//

#import <UIKit/UIKit.h>

@interface NetWorthTableViewCell_iPad : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *differenceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLineW;

@end

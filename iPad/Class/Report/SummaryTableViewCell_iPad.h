//
//  SummaryTableViewCell_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import <UIKit/UIKit.h>

@interface SummaryTableViewCell_iPad : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *amountW;

@end

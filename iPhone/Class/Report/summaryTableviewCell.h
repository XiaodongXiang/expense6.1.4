//
//  summaryTableviewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/9.
//
//

#import <UIKit/UIKit.h>

@interface summaryTableviewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *amountLabelW;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

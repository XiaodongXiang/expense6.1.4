//
//  RecurringTypeCell.h
//  PocketExpense
//
//  Created by humingjing on 14/11/17.
//
//

#import <UIKit/UIKit.h>

@interface RecurringTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;

@end

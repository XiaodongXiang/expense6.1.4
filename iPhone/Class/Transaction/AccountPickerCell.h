//
//  AccountPickerCell.h
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import <UIKit/UIKit.h>

@interface AccountPickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;


@end

//
//  CategoryTableViewCell_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell_iPad : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLineW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLineW;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineH;

@end

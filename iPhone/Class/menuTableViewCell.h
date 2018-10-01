//
//  menuTableViewCell.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/16.
//
//

#import <UIKit/UIKit.h>

@interface menuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToLeft;

@property (weak, nonatomic) IBOutlet UIView *cellBottomLine;
@property (weak, nonatomic) IBOutlet UIView *cellTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineWidth;


@end

//
//  newAcountCell.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/28.
//
//

#import <UIKit/UIKit.h>

@interface newAcountCell : UITableViewCell


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *accountIconWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelW;


@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic)  UIButton *deleteBtn;
@property(strong,nonatomic)   UIButton *detailButton;
@property(strong,nonatomic)   UIImageView *sortImage;
@end

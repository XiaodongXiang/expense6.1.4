//
//  AccountCell.h
//
//  Created by BHI_James on 4/13/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountsViewController;
@interface AccountCell : UITableViewCell
{
    double detailBtn_Origin1;
    double detailBtn_Origin2;
}

@property (strong, nonatomic) UIButton          *deleteBtn;
@property (strong, nonatomic) UIButton          *detailBtn;

@property (strong, nonatomic) UIImageView       *accountIcon;
@property (strong, nonatomic) UILabel           *nameLabel;
@property (strong, nonatomic) UILabel           *blanceLabel;
@property (strong, nonatomic) UIImageView       *arrowImageView;
@property (strong, nonatomic) UIImageView       *bgViewImage;
@property (strong, nonatomic) UILabel           *typeLabel;

@property (strong, nonatomic) UIView             *line;

@property(strong,nonatomic) AccountsViewController      *accountViewController;

@end

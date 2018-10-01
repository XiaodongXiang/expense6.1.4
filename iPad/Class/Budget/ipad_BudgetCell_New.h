//
//  ipad_BudgetCell.h
//  PocketExpense
//
//  Created by Tommy on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "budgetBar_iPad.h"

@interface ipad_BudgetCell_New : UITableViewCell 
{
//    UIImageView			*headImageView;
    UIImageView         *bgImage;
 	UILabel             *nameLabel;
	UILabel				*spentLabel;
 
	UIImageView			*spentImageView;
	UIImageView			*spentImageLeftArc;
    UIImageView         *spentImageRightArc;
    UIImageView         *totalImageView;
    UIImageView         *totalImageLeftArc;
    UIImageView         *totalImageRightArc;
    UIView         *todayView;
    
 }

//@property (nonatomic, strong) UIImageView			*headImageView;
@property (nonatomic,strong) UIImageView         *cateImageView;
@property (nonatomic, strong) UIImageView         *bgImage;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel				*spentLabel;
@property (nonatomic,strong)  budgetBar_iPad *budgetBar;
@property (nonatomic, strong) UIImageView			*spentImageView;
@property (nonatomic, strong) UIImageView			*spentImageLeftArc;
@property (nonatomic, strong) UIImageView         *spentImageRightArc;
@property (nonatomic, strong) UIImageView         *totalImageView;
@property (nonatomic, strong) UIImageView         *totalImageLeftArc;
@property (nonatomic, strong) UIImageView         *totalImageRightArc;
@property (nonatomic, strong) UIView         *todayView;
@property (nonatomic, strong) UILabel *budgetLabel;
@end

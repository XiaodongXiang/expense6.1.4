//
//  CategoryCell.h
//  Expense 5
//
//  Created by BHI_James on 4/19/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ipad_CategoryCell : UITableViewCell
{
	UILabel									*nameLabel;
 	
	UIImageView								*headImageView;
	UIImageView								*bgImageView;
	
	UIImageView								*subShadowImageView;
	
	BOOL    thisCellisEdit;
 }

@property (nonatomic, strong) UILabel		*nameLabel;
 
@property (nonatomic, strong) UIImageView	*bgImageView;
@property (nonatomic, strong) UIImageView	*headImageView;
@property (nonatomic, strong) UIImageView	*subShadowImageView;

@property(nonatomic,assign)BOOL    thisCellisEdit;
@end

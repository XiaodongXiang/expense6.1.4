//
//  CategorySelectCell.h
//  PokcetExpense
//
//  Created by ZQ on 12/6/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategorySelectCell : UITableViewCell 
{
	UILabel									*nameLabel;
	UIImageView								*headImageView;
	UIImageView								*bgImageView1;
    UIImageView								*bgImageView2;
}

@property (nonatomic, strong) UILabel		*nameLabel;
@property (nonatomic, strong) UIImageView	*bgImageView1;
@property (nonatomic, strong) UIImageView	*bgImageView2;

@property (nonatomic, strong) UIImageView	*headImageView;

@end

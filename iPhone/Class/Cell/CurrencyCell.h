//
//  CurrencyCell.h
//  PokcetExpense
//
//  Created by ZQ on 11/22/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrencyCell : UITableViewCell {

	UILabel*           symbolLabel;
	UILabel*           nameLabel;
	UIImageView*       bgImageView;
	
}

@property(nonatomic,strong) UILabel*      symbolLabel;
@property(nonatomic,strong) UILabel*      nameLabel;
@property (nonatomic, strong) UIImageView*  bgImageView;
@end

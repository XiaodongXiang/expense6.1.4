//
//  ipad_CategoryCmpCell.h
//  PocketExpense
//
//  Created by MV on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipad_CategoryCmpCell : UITableViewCell 
{
	UILabel									*nameLabel;
	UILabel									*amount1Label;
    UILabel									*amount2Label;
    UILabel									*diffAmountLabel;

     
}

@property (nonatomic, strong) UILabel		*nameLabel;
@property (nonatomic, strong) UILabel		*amount1Label;
@property (nonatomic, strong) UILabel	    *amount2Label;
@property (nonatomic, strong) UILabel		*diffAmountLabel;

@end

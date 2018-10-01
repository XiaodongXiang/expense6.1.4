//
//  ipad_AccountTypeCell.h
//  PocketExpense
//
//  Created by MV on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipad_AccountTypeCell : UITableViewCell 
{
	UILabel									*nameLabel;
	UIImageView								*headImageView;
}

@property (nonatomic, strong) UILabel		*nameLabel;
 @property (nonatomic, strong) UIImageView	*headImageView;

@end

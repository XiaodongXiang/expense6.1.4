//
//  ipad_CategoryCell.h
//  PocketExpense
//
//  Created by Tommy on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@interface ipad_CategoryCellDetail : UITableViewCell 
{
    UIImageView                             *bgImageView;
	UILabel									*nameLabel;
	UILabel									*spentLabel;
	UILabel									*percentLabel;
	
     UILabel                                 *colorLabel;
 }
@property (nonatomic, strong) UIImageView                             *bgImageView;
@property (nonatomic, strong) UILabel		*nameLabel;
@property (nonatomic, strong) UILabel		*spentLabel;
@property (nonatomic, strong) UILabel		*percentLabel;
@property (nonatomic, strong) UILabel       *colorLabel;


 
@end

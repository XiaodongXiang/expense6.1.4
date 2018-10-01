//
//  ipad_PayeeSettingCell.h
//  PocketExpense
//
//  Created by MV on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipad_PayeeSettingCell :UITableViewCell {
	
    UILabel								*categoryLabel;
    
	UILabel                               *memoLabel;
    UILabel                               *payeeLabel;
    UIImageView         *bgImage;
    
}

@property (nonatomic,strong) UILabel		 *categoryLabel;

@property (nonatomic,strong) UILabel       *memoLabel;
@property (nonatomic,strong) UILabel       *payeeLabel;
@property(nonatomic,strong)UIImageView         *bgImage;

@end

//
//  ipad_ExpenseCell.h
//  PocketExpense
//
//  Created by Tommy on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipad_PayeeSearchCell : UITableViewCell {
	UILabel                               *payeeLabel;
    UILabel								*categoryLabel;
}
@property (nonatomic,strong) UILabel       *payeeLabel;
@property (nonatomic,strong) UILabel		 *categoryLabel;

@end

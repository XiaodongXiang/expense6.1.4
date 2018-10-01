//
//  NewGroupViewController.h
//  Expense 5
//
//  Created by ZQ on 9/9/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import "AccountType.h"
#import "ipad_AccountTypeViewController.h"
 
@interface ipad_AccountTypeEditViewController : UIViewController 
<UITextFieldDelegate>
{
	NSMutableArray				*iconNameArray;
 	
 	NSInteger                   selectIndex;
}

@property (nonatomic, strong) IBOutlet UITableView		*mytableView;
@property (nonatomic, strong) IBOutlet UITableViewCell	*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell  *iconCell;
 
@property (nonatomic, strong) IBOutlet UITextField		*nameText;
@property (nonatomic, strong) IBOutlet UIImageView		*iconView;

@property (nonatomic, strong) IBOutlet UILabel         *nameLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *iconLabelText;
 
 @property (nonatomic, strong) NSString					*editModule;
 @property (nonatomic, strong)AccountType                 *accountType;
@property (nonatomic, strong) ipad_AccountTypeViewController *iAccountTypeViewController;

@end


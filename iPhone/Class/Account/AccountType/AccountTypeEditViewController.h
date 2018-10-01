//
//  NewGroupViewController.h
//
//  Created by ZQ on 9/9/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import "AccountType.h"
#import "AccountTypeViewController.h"

@class AccountTypeViewController;
@interface AccountTypeEditViewController : UIViewController 
<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLineHigh;

@property (nonatomic, strong) IBOutlet UITableView		*mytableView;
@property (nonatomic, strong) IBOutlet UITableViewCell	*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell  *iconCell;

@property (nonatomic, strong) IBOutlet UILabel          *nameLabelText;
@property (nonatomic, strong) IBOutlet UILabel          *iconLabelText;
@property (nonatomic, strong) IBOutlet UITextField		*nameText;
@property (nonatomic, strong) IBOutlet UIImageView		*iconView;
@property (nonatomic, strong) AccountType               *accountType;
@property (nonatomic, strong) NSMutableArray			*iconNameArray;
@property (nonatomic, strong) NSString					*editModule;
@property (nonatomic, assign) NSInteger                 selectIndex;

@property (nonatomic, strong) AccountTypeViewController *iAccountTypeViewController;
@end


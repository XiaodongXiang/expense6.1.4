//
//  PasscodeViewController.h
//  GlucoseMate
//
//  Created by Joe Jia on 1/19/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

/*---密码的主界面，当点击Option中的密码项的时候，就弹出来这个界面*/
#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"

@interface PasscodeViewController_iPhone : UIViewController 
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
UITextFieldDelegate,
UIPopoverControllerDelegate
>
{
	UITableView*											tableView;
	
	UITableViewCell*										cellPasscodeSwitch;
	UITableViewCell*										cellPasscodeChange;

	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;	
	UITextField*											txtHiddenPasscode;	
	UILabel*												lblNotification;
	UIView*													viewPassHolder;
	
	NSInteger												selectedSection;
	
	Setting*												setting;
	
	UIAlertView*											alertView;
    
    UILabel         *turnOffLabelText;
    UILabel         *changeLabelText;
}

@property (nonatomic, strong) IBOutlet UITableView*			tableView;
@property (nonatomic, strong) IBOutlet UITableViewCell*		cellPasscodeSwitch;
@property (nonatomic, strong) IBOutlet UITableViewCell*		cellPasscodeChange;


@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtHiddenPasscode;
@property (nonatomic, strong) IBOutlet UILabel*				lblNotification;
@property (nonatomic, strong) IBOutlet UIView*				viewPassHolder;
@property (nonatomic) NSInteger								selectedSection;

@property (nonatomic, strong) Setting*						setting;

@property (nonatomic, strong) UIAlertView*					alertView;

@property (nonatomic, strong) IBOutlet UILabel         *turnOffLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *changeLabelText;
 
-(IBAction)charEntered;
@end

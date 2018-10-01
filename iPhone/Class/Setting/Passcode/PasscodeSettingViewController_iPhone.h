//
//  PasscodeSettingViewController.h
//  GlucoseMate
//
//  Created by Joe Jia on 1/19/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasscodeReenterViewController_iPhone.h"
#import "Setting+CoreDataClass.h"
#import "SettingViewController.h"
 
@interface PasscodeSettingViewController_iPhone : UIViewController 
<UITextFieldDelegate,PasscodeReenterDelegate_iPhone,
UIPopoverControllerDelegate
>
{
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	
	UITextField*											txtPasscode;
	
	UILabel*												lblNotification;
	
	Setting*												setting;
	
	NSString												*typeOftodo;
	SettingViewController                              *settingSVC;
    UILabel         *faildLabelText;
    UILabel         *enterLabelText;


    
}

@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) IBOutlet UILabel*				lblNotification;
@property (nonatomic, strong) Setting*						setting;

@property (nonatomic, strong) NSString						*typeOftodo;
@property (nonatomic, strong) SettingViewController *settingSVC;
@property (nonatomic, strong) IBOutlet UILabel         *faildLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *enterLabelText;




-(void)cancelPressed:(id)sender;
-(IBAction)charEntered;

@end

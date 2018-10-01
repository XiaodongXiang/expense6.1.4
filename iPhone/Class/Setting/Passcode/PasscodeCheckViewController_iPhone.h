//
//  ipad_PasscodeEnterViewController.h
 //
//  Created by Tommy on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

 #import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
 
@interface PasscodeCheckViewController_iPhone : UIViewController<UIPopoverControllerDelegate> {
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	
	UITextField*											txtPasscode;
	
	UILabel*												lblNotification;
	
	Setting*												setting;
    UILabel         *enterLabelText;
    UILabel         *faildLabelText;
    
    
 }

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoH;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passcodeT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindeLabelT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wrongLabelT;


@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) IBOutlet UILabel*				lblNotification;
@property (nonatomic, strong) IBOutlet UIView *passcodeBGView;
 
@property (nonatomic, strong) Setting*						setting;
@property (nonatomic, strong) IBOutlet UILabel         *enterLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *faildLabelText;
 
-(IBAction)charEntered;
@end

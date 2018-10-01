//
//  PasscodeReenterViewController.h
//  GlucoseMate
//
//  Created by Joe Jia on 1/19/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasscodeReenterDelegate_iPhone;

@interface PasscodeReenterViewController_iPhone : UIViewController 
<
UITextFieldDelegate,UIPopoverControllerDelegate
>
{
	id <PasscodeReenterDelegate_iPhone>							delegate;
	
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	
	UITextField*											txtPasscode;
	
	NSString*												passcode;
	
	NSString *typetodo;
    UILabel         *faildLabelText;
    UILabel         *enterLabelText;

}

@property (nonatomic, strong) id <PasscodeReenterDelegate_iPhone>	delegate;

@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) NSString*						passcode;
@property (nonatomic, strong) NSString*						typetodo;
@property (nonatomic, strong) IBOutlet UILabel         *faildLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *enterLabelText;


-(IBAction)charEntered;

@end

@protocol PasscodeReenterDelegate_iPhone

-(void)passcodeDidReentered:(NSString*)passcode;

@end


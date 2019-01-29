//
//  PasscodeSettingViewController.m
//  GlucoseMate
//
//  Created by Joe Jia on 1/19/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "PasscodeSettingViewController_iPhone.h"
#import "PasscodeReenterViewController_iPhone.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "XDPwKeyboard.h"
#import "XDPasswordKeyboard.h"



#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface PasscodeSettingViewController_iPhone()<XDPasswordKeyBboardDelegate>

//@property(nonatomic, strong)XDPwKeyboard* keyboard;
@property(nonatomic, strong)XDPasswordKeyboard* keyboard;

@end
@implementation PasscodeSettingViewController_iPhone

@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize typeOftodo;
@synthesize settingSVC;
@synthesize faildLabelText;
@synthesize enterLabelText;

#pragma mark Custom Events

-(XDPasswordKeyboard *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle] loadNibNamed:@"XDPasswordKeyboard" owner:self options:nil]lastObject];
        _keyboard.xxdDelegate = self;
    }
    return _keyboard;
}

-(void)returnPassword:(NSString *)string{
    
    NSString* text = string;
    self.lblNotification.hidden = YES;
    self.txtPasscode.text = string;
    //    self.txtP1.text = @"";
    //    self.txtP2.text = @"";
    //    self.txtP3.text = @"";
    //    self.txtP4.text = @"";
    self.txtP1.background = [UIImage imageNamed:@"password1.png"];
    self.txtP2.background = [UIImage imageNamed:@"password1.png"];
    self.txtP3.background = [UIImage imageNamed:@"password1.png"];
    self.txtP4.background = [UIImage imageNamed:@"password1.png"];
    
    if (text.length > 0)
    {
        self.txtP1.background = [UIImage imageNamed:@"password2.png"];
        
    }
    if (text.length > 1)
    {
        self.txtP2.background = [UIImage imageNamed:@"password2.png"];
        
    }
    if (text.length > 2)
    {
        self.txtP3.background = [UIImage imageNamed:@"password2.png"];
        
    }
    if (text.length > 3)
    {
        self.txtP4.background = [UIImage imageNamed:@"password2.png"];
        
    }
    
    if (text.length == 4)
    {
        PasscodeReenterViewController_iPhone* reenterViewController = [[PasscodeReenterViewController_iPhone alloc] initWithNibName:@"PasscodeReenterViewController_iPhone" bundle:nil];
        reenterViewController.delegate = self;
        [self.navigationController pushViewController:reenterViewController animated:YES];
        
    }
}

-(void)cancelPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(IBAction)charEntered
{
	NSString* text = self.txtPasscode.text;
	self.lblNotification.hidden = YES;
	
//	self.txtP1.text = @"";
//	self.txtP2.text = @"";
//	self.txtP3.text = @"";
//	self.txtP4.text = @"";
    self.txtP1.background = [UIImage imageNamed:@"password1.png"];
    self.txtP2.background = [UIImage imageNamed:@"password1.png"];
    self.txtP3.background = [UIImage imageNamed:@"password1.png"];
    self.txtP4.background = [UIImage imageNamed:@"password1.png"];

	if (text.length > 0)
	{		
        self.txtP1.background = [UIImage imageNamed:@"password2.png"];

	}
	if (text.length > 1)
	{
        self.txtP2.background = [UIImage imageNamed:@"password2.png"];

	}
	if (text.length > 2)
	{
        self.txtP3.background = [UIImage imageNamed:@"password2.png"];

	}
	if (text.length > 3)
	{
        self.txtP4.background = [UIImage imageNamed:@"password2.png"];

	}
	
	if (text.length == 4)
	{		
		PasscodeReenterViewController_iPhone* reenterViewController = [[PasscodeReenterViewController_iPhone alloc] initWithNibName:@"PasscodeReenterViewController_iPhone" bundle:nil];
		reenterViewController.delegate = self;
		[self.navigationController pushViewController:reenterViewController animated:YES];
		
	}
}

-(void) passcodeDidReentered:(NSString *)passcodeEntered
{
	if([passcodeEntered compare:@"Cancel"]==NSOrderedSame)
	{
 
        [self.navigationController popToRootViewControllerAnimated:YES];
 	}
	else
	{
		if ([self.txtPasscode.text isEqualToString:passcodeEntered])
		{
			// Passcode match
			self.setting.passcode = passcodeEntered;
			
			PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext* context = [appDelegate managedObjectContext];
			NSError* error = nil;
            self.setting.passcodeStyle=@"number";
			[context save:&error];
			
//			succeed = YES;
//            [settingSVC reSetViewData];
            [self.navigationController popToRootViewControllerAnimated:YES];
 		}
		else 
		{
			// Passcode not match
			[self.navigationController popViewControllerAnimated:YES];
            self.txtP1.background = [UIImage imageNamed:@"password1.png"];
            self.txtP2.background = [UIImage imageNamed:@"password1.png"];
            self.txtP3.background = [UIImage imageNamed:@"password1.png"];
            self.txtP4.background = [UIImage imageNamed:@"password1.png"];

			self.txtPasscode.text = @"";
			self.lblNotification.hidden = NO;
		}
	}
}

#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	BOOL ret = YES;
	if ([textField.text length] >= 4)
	{
		if ([string isEqualToString:@""])
		{
			ret =  YES;
		}
		else 
		{
			ret = NO;
		}
	}
	return ret;
}
//---点击手势，弹出键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![txtPasscode isFirstResponder]) {
        [self.txtPasscode becomeFirstResponder];
    }
}
#pragma mark System Events
-(void) viewDidLoad
{
    [super viewDidLoad];
    self.txtPasscode.inputView  = self.keyboard;
    [self.txtPasscode becomeFirstResponder];
    
    enterLabelText.text = NSLocalizedString(@"VC_Enteryourpasscode", nil);
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
	self.navigationItem.title = NSLocalizedString(@"VC_PasscodeSetting", nil);
    
//   self.txtPasscode.inputView = self.txtP1.inputView = self.txtP2.inputView = self.txtP3.inputView = self.txtP4.inputView = self.keyboard;
    
//    self.txtPasscode.inputView = self.keyboard;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    [self performSelector:@selector(keyboardShow) withObject:nil afterDelay:0];
//}
-(void)keyboardShow
{
    [self.txtPasscode becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}




@end

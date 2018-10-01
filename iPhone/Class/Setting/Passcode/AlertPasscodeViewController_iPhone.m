//
//  AlertPasscodeViewController.m
//  CarbMaster
//
//  Created by BHI_H04 on 4/1/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "AlertPasscodeViewController_iPhone.h"
#import "PasscodeSettingViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation AlertPasscodeViewController_iPhone
@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize openType;
@synthesize faildLabelText,enterLabelText;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(void)cancelPressed:(id)sener
{
    [self.txtPasscode resignFirstResponder];
//	[self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![txtPasscode isFirstResponder]) {
        [self.txtPasscode becomeFirstResponder];
    }
}
-(IBAction)charEntered 
{

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

	NSString* text = self.txtPasscode.text;
	self.lblNotification.hidden = YES;
	
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
		if ([text isEqualToString:self.setting.passcode])
		{
			if([self.openType compare:@"OFF"]==NSOrderedSame)
			{
 				NSManagedObjectContext* context = [self.setting managedObjectContext];
				self.setting.passcode = nil;
				NSError* error = nil;
                
                self.setting.passcodeStyle=@"none";
                
				[context save:&error];
                [self.navigationController popToRootViewControllerAnimated:YES];
		 	}
			else if([self.openType isEqualToString:@"CHANGE"])
			{
				PasscodeSettingViewController_iPhone* passcodeSettingController = [[PasscodeSettingViewController_iPhone alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
				passcodeSettingController.setting = self.setting;
				[self.navigationController pushViewController:passcodeSettingController animated:YES];
			}
            else if ([self.openType isEqualToString:@"TOUCHID"])
            {
                [self popoverPresentationController];
                LAContext *context=[LAContext new];
                context.localizedFallbackTitle=@"";
                
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"VC_OpenTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                    if (success)
                    {
                        NSLog(@"成功");
                        appDelegate.settings.passcodeStyle=@"touchid";
                        NSError *touchidError;
                        [appDelegate.managedObjectContext save:&touchidError];
                    }
                    else
                    {
                        NSLog(@"失败");
                    }
                }];
            }
		}
		else
		{
			self.txtP1.text = @"";
			self.txtP2.text = @"";
			self.txtP3.text = @"";
			self.txtP4.text = @"";
			self.txtPasscode.text = @"";
            self.txtP1.background = [UIImage imageNamed:@"password1.png"];
            self.txtP2.background = [UIImage imageNamed:@"password1.png"];
            self.txtP3.background = [UIImage imageNamed:@"password1.png"];
            self.txtP4.background = [UIImage imageNamed:@"password1.png"];

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar doSetNavigationBar];

    isPasscode = NO;
    oldString = [[NSString alloc]init];
	[self.txtPasscode becomeFirstResponder];
    
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    enterLabelText.text = NSLocalizedString(@"VC_Enter your old passcode", nil);

    
    
    if([self.openType compare:@"OFF"]==NSOrderedSame)
	{
        self.navigationItem.title = NSLocalizedString(@"VC_TurnPasscodeOff", nil);
		
	}
	else
	{
		self.navigationItem.title = NSLocalizedString(@"VC_Enter your old passcode", nil);
	}

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self cancelPressed:nil];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//- (void)viewDidUnload {
//	
//}




@end

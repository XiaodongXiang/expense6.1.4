//
//  PasscodeReenterViewController.m
//  GlucoseMate
//
//  Created by Joe Jia on 1/19/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "PasscodeReenterViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "XDPasswordKeyboard.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface PasscodeReenterViewController_iPhone ()<XDPasswordKeyBboardDelegate>
@property(nonatomic, strong)XDPasswordKeyboard* keyboard;

@end
@implementation PasscodeReenterViewController_iPhone

@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize passcode;
@synthesize delegate;
@synthesize typetodo;
@synthesize faildLabelText;
@synthesize enterLabelText;

-(XDPasswordKeyboard *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle] loadNibNamed:@"XDPasswordKeyboard" owner:self options:nil]lastObject];
        _keyboard.xxdDelegate = self;
    }
    return _keyboard;
}

-(void)returnPassword:(NSString *)string{
    
    NSString* text = string;
    
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
        [self.delegate passcodeDidReentered:text];
    }
}
#pragma mark Custom Events
-(IBAction)charEntered
{
	NSString* text = self.txtPasscode.text;
	
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
		[self.delegate passcodeDidReentered:self.txtPasscode.text];
	}
}

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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![txtPasscode isFirstResponder]) {
        [self.txtPasscode becomeFirstResponder];
    }
}
#pragma mark System Events
-(void) viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController.navigationBar doSetNavigationBar];

    self.txtPasscode.inputView = self.keyboard;
	[self.txtPasscode becomeFirstResponder];

    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    enterLabelText.text = NSLocalizedString(@"VC_Re_enteryourpasscode", nil);


	self.navigationItem.title = NSLocalizedString(@"VC_Re_enteryourpasscode", nil);
 }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self cancel:nil];
}

-(void)cancel:(id)sender
{
	[self.delegate passcodeDidReentered:@"Cancel"];
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

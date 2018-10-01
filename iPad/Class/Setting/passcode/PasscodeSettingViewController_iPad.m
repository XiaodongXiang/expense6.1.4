//
//  PasscodeSettingViewController_iPad.m
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import "PasscodeSettingViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"

@interface PasscodeSettingViewController_iPad ()

@end

@implementation PasscodeSettingViewController_iPad
@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize typeOftodo;
@synthesize settingSVC;
@synthesize faildLabelText;

#pragma mark Custom Events
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
	
//	NSRange range;
	if (text.length > 0)
	{
//		range = NSMakeRange(0, 1);
        //		self.txtP1.text = [text substringWithRange:range];
        self.txtP1.background = [UIImage imageNamed:@"password2.png"];
        
	}
	if (text.length > 1)
	{
//		range = NSMakeRange(1, 1);
        //		self.txtP2.text = [text substringWithRange:range];
        self.txtP2.background = [UIImage imageNamed:@"password2.png"];
        
	}
	if (text.length > 2)
	{
//		range = NSMakeRange(2, 1);
        //		self.txtP3.text = [text substringWithRange:range];
        self.txtP3.background = [UIImage imageNamed:@"password2.png"];
        
	}
	if (text.length > 3)
	{
//		range = NSMakeRange(3, 1);
        //		self.txtP4.text = [text substringWithRange:range];
        self.txtP4.background = [UIImage imageNamed:@"password2.png"];
        
	}
	
	if (text.length == 4)
	{
		PasscodeReenterViewController_iPad* reenterViewController = [[PasscodeReenterViewController_iPad alloc] initWithNibName:@"PasscodeReenterViewController_iPad" bundle:nil];
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
//			BOOL succeed = [context save:&error];
			
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
	[self.txtPasscode becomeFirstResponder];
    
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = NSLocalizedString(@"VC_PasscodeSetting", nil);
	self.navigationItem.titleView = 	titleLabel;
    
    
	UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
	back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];

    
    
	
    
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

//
//  AlertPasscodeViewController_iPad.m
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import "AlertPasscodeViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#import "PasscodeSettingViewController_iPad.h"

@interface AlertPasscodeViewController_iPad ()

@end

@implementation AlertPasscodeViewController_iPad
@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize openType;
@synthesize faildLabelText;
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
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![txtPasscode isFirstResponder]) {
        [self.txtPasscode becomeFirstResponder];
    }
}
-(IBAction)charEntered
{
    
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
		if ([text isEqualToString:self.setting.passcode])
		{
			if([self.openType compare:@"OFF"]==NSOrderedSame)
			{
 				NSManagedObjectContext* context = [self.setting managedObjectContext];
				self.setting.passcode = nil;
				NSError* error = nil;
				[context save:&error];
 				[self.navigationController popToRootViewControllerAnimated:YES];
		 	}
			else
			{
				PasscodeSettingViewController_iPad* passcodeSettingController = [[PasscodeSettingViewController_iPad alloc] initWithNibName:@"PasscodeSettingViewController_iPad" bundle:nil];
				passcodeSettingController.setting = self.setting;
				[self.navigationController pushViewController:passcodeSettingController animated:YES];
                
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
- (void)viewDidLoad {
    [super viewDidLoad];
    isPasscode = NO;
    oldString = [[NSString alloc]init];
	self.navigationItem.hidesBackButton = YES;
	[self.txtPasscode becomeFirstResponder];
    
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if([self.openType compare:@"OFF"]==NSOrderedSame)
	{
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];       [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];		titleLabel.text = NSLocalizedString(@"VC_TurnPasscodeOff", nil);
		self.navigationItem.titleView = titleLabel;
		
	}
	else
	{
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
       [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
		titleLabel.text = NSLocalizedString(@"VC_Enter your old passcode", nil);
		self.navigationItem.titleView = 	titleLabel;
		
	}
    
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

//
//  PasscodeViewController_iPad.m
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import "PasscodeViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#import "PasscodeSettingViewController_iPad.h"
#import "AlertPasscodeViewController_iPad.h"

@interface PasscodeViewController_iPad ()

@end

@implementation PasscodeViewController_iPad
@synthesize tableView;
@synthesize cellPasscodeSwitch;
@synthesize cellPasscodeChange;
@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtHiddenPasscode;
@synthesize lblNotification;
@synthesize viewPassHolder;
@synthesize selectedSection;
@synthesize setting;
@synthesize alertView;
@synthesize turnOffLabelText,changeLabelText;

#pragma mark Custom Events


-(IBAction)charEntered
{
	NSString* text = self.txtHiddenPasscode.text;
	
	self.lblNotification.hidden = YES;
	self.txtP1.text = @"";
	self.txtP2.text = @"";
	self.txtP3.text = @"";
	self.txtP4.text = @"";
	
	NSRange range;
	if (text.length > 0)
	{
		range = NSMakeRange(0, 1);
		self.txtP1.text = [text substringWithRange:range];
	}
	if (text.length > 1)
	{
		range = NSMakeRange(1, 1);
		self.txtP2.text = [text substringWithRange:range];
	}
	if (text.length > 2)
	{
		range = NSMakeRange(2, 1);
		self.txtP3.text = [text substringWithRange:range];
	}
	if (text.length > 3)
	{
		range = NSMakeRange(3, 1);
		self.txtP4.text = [text substringWithRange:range];
	}
	
	if (text.length == 4)
	{
		if ([text isEqualToString:self.setting.passcode])
		{
            
            
			if (self.selectedSection == 0) // Turn passcode off
			{
				PokcetExpenseAppDelegate* appDelegate =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
				NSManagedObjectContext* context = [appDelegate managedObjectContext];
				self.setting.passcode = nil;
				
				NSError* error = nil;
				[context save:&error];
				[self.alertView dismissWithClickedButtonIndex:0 animated:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
			}
			else if (self.selectedSection == 1)
			{
				[self.alertView dismissWithClickedButtonIndex:0 animated:NO];
				PasscodeSettingViewController_iPad* passcodeSettingController = [[PasscodeSettingViewController_iPad alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
				passcodeSettingController.setting = self.setting;
				UINavigationController* naviController = [[UINavigationController alloc] initWithRootViewController:passcodeSettingController];
				[self presentViewController:naviController animated:YES completion:nil];
			}
		}
		else
		{
			self.txtP1.text = @"";
			self.txtP2.text = @"";
			self.txtP3.text = @"";
			self.txtP4.text = @"";
			self.txtHiddenPasscode.text = @"";
			self.lblNotification.hidden = NO;
		}
        
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if (textField.tag == 1)
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
	else {
		return YES;
	}
}

-(void) willPresentAlertView:(UIAlertView *)alertView
{
	[self.txtHiddenPasscode becomeFirstResponder];
	
	self.txtP1.text = @"";
	self.txtP2.text = @"";
	self.txtP3.text = @"";
	self.txtP4.text = @"";
	self.txtHiddenPasscode.text = @"";
	self.lblNotification.hidden = YES;
	
	CGRect rect = self.alertView.frame;
	self.alertView.frame = CGRectMake(rect.origin.x, rect.origin.y - 80, rect.size.width, rect.size.height);
    
}

#pragma mark TableView Delegate and Datasource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
        return self.cellPasscodeSwitch;

	}
	
	else
	{
        return self.cellPasscodeChange;

	}
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	AlertPasscodeViewController_iPad * alertPasscodeViewController = [[AlertPasscodeViewController_iPad alloc] initWithNibName:@"AlertPasscodeViewController_iPad" bundle:nil];
    alertPasscodeViewController.setting = self.setting;
    
    if (indexPath.section == 0)
    {
        alertPasscodeViewController.openType = @"OFF";
    }
    else if (indexPath.section == 1)
    {
        alertPasscodeViewController.openType = @"CHANGE";
    }
    [self.navigationController pushViewController:alertPasscodeViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Systeme Events
-(void) viewDidLoad
{
    [super viewDidLoad];
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

    
    [back addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    turnOffLabelText.text = NSLocalizedString(@"VC_TurnPasscodeOff", nil);
    changeLabelText.text = NSLocalizedString(@"VC_ChangePasscode", nil);}



#pragma mark navigationItem event
- (void) cancel:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];//往下
}

-(BOOL)hidesBottomBarWhenPushed
{
	return YES;
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

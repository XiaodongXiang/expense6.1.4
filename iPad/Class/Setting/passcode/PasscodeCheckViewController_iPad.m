//
//  PasscodeCheckViewController_iPad.m
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import "PasscodeCheckViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#define degreesToRadians(x) (M_PI  * (x) / 180.0)

@interface PasscodeCheckViewController_iPad ()

@end

@implementation PasscodeCheckViewController_iPad
@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize passcodeBGView;
@synthesize enterLabelText,faildLabelText;

- (void)rotateViewAccordingToStatusBarOrientation:(NSNotification *)notification
{
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
        return;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0.0;
    CGRect newFrame = self.view.window.bounds;
    CGSize statusBarSize = CGSizeZero;// [[UIApplication sharedApplication] statusBarFrame].size;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            newFrame.size.height -= statusBarSize.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI / 2.0f;

            newFrame.origin.x += statusBarSize.width;
            newFrame.size.width -= statusBarSize.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI / 2.0f;

            newFrame.size.width -= statusBarSize.width;
            break;
        default: // as UIInterfaceOrientationPortrait
            angle = 0.0;
            newFrame.origin.y += statusBarSize.height;
            newFrame.size.height -= statusBarSize.height;
            break;
    }
    self.view.transform = CGAffineTransformMakeRotation(angle);
    self.view.frame = newFrame;
    //    if(!ISPAD)
    //    {
    //        self.view.transform = CGAffineTransformMakeRotation(angle);
    //        self.view.frame = newFrame;
    //    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    enterLabelText.text = NSLocalizedString(@"VC_Enteryourpasscode", nil);
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    
    PokcetExpenseAppDelegate *appDelegete =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.setting = appDelegete.settings;
    [txtPasscode becomeFirstResponder];
    
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateViewAccordingToStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
}


-(IBAction)charEntered
{
	NSString* text = self.txtPasscode.text;
	self.lblNotification.hidden = YES;
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
		if ([self.txtPasscode.text isEqualToString:setting.passcode])
		{
			self.lblNotification.hidden = YES;
 			
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
            
			[self.txtPasscode resignFirstResponder];
            
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            if (!appDelegate.isPurchased)
            {
                appDelegate.applicationLaunchDate = [NSDate dateWithTimeIntervalSinceNow:0];
//                [appDelegate insertAdsMob];
            }
            [self.view removeFromSuperview];
            
		}
		else
		{
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

//---重新设定 锁界面的 方向
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.f)
        return;

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);

        
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload
//{
//}



@end

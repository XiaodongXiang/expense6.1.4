//
//  ipad_PasscodeEnterViewController.m
 //
//  Created by Tommy on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasscodeCheckViewController_iPhone.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XDPasswordKeyboard.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)

@interface PasscodeCheckViewController_iPhone()<XDPasswordKeyBboardDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg1;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg2;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg3;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg4;
@property(nonatomic, strong)XDPasswordKeyboard* keyboard;


@end
@implementation PasscodeCheckViewController_iPhone

@synthesize txtP1, txtP2, txtP3, txtP4;
@synthesize txtPasscode;
@synthesize lblNotification;
@synthesize setting;
@synthesize passcodeBGView;
@synthesize enterLabelText,faildLabelText;

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
    //    self.txtP1.text = @"";
    //    self.txtP2.text = @"";
    //    self.txtP3.text = @"";
    //    self.txtP4.text = @"";
    self.txtP1.background = [UIImage imageNamed:@"password1.png"];
    self.txtP2.background = [UIImage imageNamed:@"password1.png"];
    self.txtP3.background = [UIImage imageNamed:@"password1.png"];
    self.txtP4.background = [UIImage imageNamed:@"password1.png"];
    
    self.passwordImg1.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg2.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg3.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg4.image = [UIImage imageNamed:@"password_normal.png"];
    
    if (text.length > 0)
    {
        //        range = NSMakeRange(0, 1);
        //        self.txtP1.text = [text substringWithRange:range];
        self.txtP1.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg1.image = [UIImage imageNamed:@"password_press.png"];
    }
    if (text.length > 1)
    {
        //        range = NSMakeRange(1, 1);
        //        self.txtP2.text = [text substringWithRange:range];
        self.txtP2.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg2.image = [UIImage imageNamed:@"password_press.png"];
        
    }
    if (text.length > 2)
    {
        //        range = NSMakeRange(2, 1);
        //        self.txtP3.text = [text substringWithRange:range];
        self.txtP3.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg3.image = [UIImage imageNamed:@"password_press.png"];
        
    }
    if (text.length > 3)
    {
        //        range = NSMakeRange(3, 1);
        //        self.txtP4.text = [text substringWithRange:range];
        self.txtP4.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg4.image = [UIImage imageNamed:@"password_press.png"];
        
    }
    
    if (text.length == 4)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([text isEqualToString:setting.passcode])
                {
                    self.lblNotification.hidden = YES;
                    
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                    
                    [self.txtPasscode resignFirstResponder];
                    
                    PokcetExpenseAppDelegate *appDelegate2 = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                    if (!appDelegate2.isPurchased)
                    {
                        appDelegate2.applicationLaunchDate = [NSDate dateWithTimeIntervalSinceNow:0];
                    }
                    [self.view removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
                    
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.txtP1.background = [UIImage imageNamed:@"password1.png"];
                    self.txtP2.background = [UIImage imageNamed:@"password1.png"];
                    self.txtP3.background = [UIImage imageNamed:@"password1.png"];
                    self.txtP4.background = [UIImage imageNamed:@"password1.png"];
                    
                    self.passwordImg1.image = [UIImage imageNamed:@"password_normal.png"];
                    self.passwordImg2.image = [UIImage imageNamed:@"password_normal.png"];
                    self.passwordImg3.image = [UIImage imageNamed:@"password_normal.png"];
                    self.passwordImg4.image = [UIImage imageNamed:@"password_normal.png"];
                    
                    
                    self.txtPasscode.text = @"";
                    self.lblNotification.hidden = NO;
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self start];
                }
            });
        });
    }
}


#pragma mark - View lifecycle
- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.txtPasscode.inputView = self.keyboard;
    
    enterLabelText.text = NSLocalizedString(@"VC_Enteryourpasscode", nil);
    faildLabelText.text = NSLocalizedString(@"VC_Passcodedidnotmatch_Tryagain", nil);
    self.faildLabelText.hidden = YES;
    
    PokcetExpenseAppDelegate *appDelegete =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.setting = appDelegete.settings;
    [txtPasscode becomeFirstResponder];
    
//    _logoImage.image = [UIImage imageNamed:[NSString customImageName:@"password"]];
    if (IS_IPHONE_6PLUS)
    {
        _logoW.constant = 118;
        _logoH.constant = 118;
        _logoT.constant = 80;
        _passcodeT.constant = 258;
        _remindeLabelT.constant = 225;
        _wrongLabelT.constant = 280;

    }
    else if (IS_IPHONE_6)
    {
        _logoW.constant = 118;
        _logoH.constant = 118;
        _logoT.constant = 80;
        _passcodeT.constant = 258;
        _remindeLabelT.constant = 225;
        _wrongLabelT.constant = 270;

    }else if(IS_IPHONE_X){
        _logoT.constant = 150;

    }else
    {
        _logoW.constant = 101;
        _logoH.constant = 101;

    }
}
 
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [[UIScreen mainScreen]bounds].size.height);

    
    self.passwordImg1.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg2.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg3.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg4.image = [UIImage imageNamed:@"password_normal.png"];
    
    [self.keyboard reset];
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

    self.passwordImg1.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg2.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg3.image = [UIImage imageNamed:@"password_normal.png"];
    self.passwordImg4.image = [UIImage imageNamed:@"password_normal.png"];

	if (text.length > 0)
	{		
//		range = NSMakeRange(0, 1);
//		self.txtP1.text = [text substringWithRange:range];
        self.txtP1.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg1.image = [UIImage imageNamed:@"password_press.png"];
	}
	if (text.length > 1) 
	{
//		range = NSMakeRange(1, 1);
//		self.txtP2.text = [text substringWithRange:range];
        self.txtP2.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg2.image = [UIImage imageNamed:@"password_press.png"];

	}
	if (text.length > 2)
	{
//		range = NSMakeRange(2, 1);
//		self.txtP3.text = [text substringWithRange:range];
        self.txtP3.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg3.image = [UIImage imageNamed:@"password_press.png"];

	}
	if (text.length > 3)
	{
//		range = NSMakeRange(3, 1);
//		self.txtP4.text = [text substringWithRange:range];
        self.txtP4.background = [UIImage imageNamed:@"password2.png"];
        self.passwordImg4.image = [UIImage imageNamed:@"password_press.png"];

	}
	
	if (text.length == 4)
	{		
		if ([self.txtPasscode.text isEqualToString:setting.passcode])
		{
			self.lblNotification.hidden = YES;
 			
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

			[self.txtPasscode resignFirstResponder];
            
            PokcetExpenseAppDelegate *appDelegate2 = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            if (!appDelegate2.isPurchased)
            {
                appDelegate2.applicationLaunchDate = [NSDate dateWithTimeIntervalSinceNow:0];
            }
            [self.view removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];

		}
		else 
		{
			[self.navigationController popViewControllerAnimated:YES];
			self.txtP1.background = [UIImage imageNamed:@"password1.png"];
            self.txtP2.background = [UIImage imageNamed:@"password1.png"];
            self.txtP3.background = [UIImage imageNamed:@"password1.png"];
            self.txtP4.background = [UIImage imageNamed:@"password1.png"];
            
            self.passwordImg1.image = [UIImage imageNamed:@"password_normal.png"];
            self.passwordImg2.image = [UIImage imageNamed:@"password_normal.png"];
            self.passwordImg3.image = [UIImage imageNamed:@"password_normal.png"];
            self.passwordImg4.image = [UIImage imageNamed:@"password_normal.png"];
            

			self.txtPasscode.text = @"";
			self.lblNotification.hidden = NO;
            
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self start];
		}		
	}
}

//开点按钮功能呢
- (void)start {
    //实例化
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //拿到动画 key
    anim.keyPath =@"transform.rotation";
    // 动画时间
    anim.duration =.25;
    
    // 重复的次数
    anim.repeatCount = 2;
    //无限次重复
//    anim.repeatCount =MAXFLOAT;
    
    //设置抖动数值
    anim.values =@[@(ANGLE_TO_RADIAN(-15)),@(ANGLE_TO_RADIAN(15)),@(ANGLE_TO_RADIAN(-15))];
    
    // 保持最后的状态
    anim.removedOnCompletion =YES;
    //动画的填充模式
    anim.fillMode =kCAFillModeForwards;
    //layer层实现动画
    [self.passwordImg1.layer addAnimation:anim forKey:@"shake"];
    [self.passwordImg2.layer addAnimation:anim forKey:@"shake"];
    [self.passwordImg3.layer addAnimation:anim forKey:@"shake"];
    [self.passwordImg4.layer addAnimation:anim forKey:@"shake"];

    [self.keyboard reset];
}

//点击结束按钮
- (void)end {
    //图标
    [self.passwordImg1.layer removeAnimationForKey:@"shake"];
    [self.passwordImg2.layer removeAnimationForKey:@"shake"];
    [self.passwordImg3.layer removeAnimationForKey:@"shake"];
    [self.passwordImg4.layer removeAnimationForKey:@"shake"];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload 
//{
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    NSLog(@"touchesBegan");
//    [self.keyboard reset];

    [self.txtPasscode becomeFirstResponder];
}


@end

//
//  thirdView_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/18.
//
//

#import "thirdView_iPad.h"
#import <Parse/Parse.h>
#import "AppDelegate_iPad.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ParseDBManager.h"
@interface thirdView_iPad ()<UITextFieldDelegate>
{
    int direction;
    int shakes;
    UILabel *logo;
    UIView *frontView;
    
    UITextField *topTextfield;
    UITextField *bottomTextField;
    
    UIButton *bottomClearBtn;
    UIButton *topClearBtn;
    
    UIView *textView;
    UILabel *emlLabel;
    UILabel *pswLabel;
    UIView *topLine;
    UIView *bottomLine;
    
    UILabel *warningLabel;
    
    UIButton *signinBtn;
    UIImageView *load;
    UIButton *fbBtn;
    UIButton *startBtn;
    
    UIButton *signupBtn;
    UIButton *forgetBtn;
    
    UIButton *backToBtn;
    
    BOOL isSignIn;
    
    float toTop;
}
@end

@implementation thirdView_iPad



-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [self createBackImage];
    [self createFrontView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)createBackImage
{
    
    UIImageView *backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 242)];
    backImage.image=[UIImage imageNamed:@"ipad_sign_top_bg"];
    [self addSubview:backImage];
}
-(void)createFrontView
{
    isSignIn=YES;
    
    frontView=[[UIView alloc]initWithFrame:CGRectMake(0, 187, SCREEN_WIDTH, SCREEN_HEIGHT-187)];
    frontView.backgroundColor=[UIColor clearColor];
    [self addSubview:frontView];
    
    //白色背景
    UIView *whiteBack=[[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT-110-187)];
    whiteBack.backgroundColor=[UIColor whiteColor];
    [frontView addSubview:whiteBack];
    
    
    backToBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 45, 100, 24)];
    [backToBtn setTitle:@"Back" forState:UIControlStateNormal];
    backToBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [backToBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backToBtn];
    backToBtn.alpha=0;
    
    //logo
    
    UIImageView *frontLogo=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    frontLogo.image=[UIImage imageNamed:@"ipad_sign_top_icon"];
    [frontView addSubview:frontLogo];
    
    logo=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 129, 250, 22)];
    logo.text=@"POCKET EXPENSE";
    logo.textColor=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
    logo.textAlignment=NSTextAlignmentCenter;
    logo.font=[UIFont fontWithName:@"HelveticaNeue" size:19];
    [frontView addSubview:logo];
    
    

    //用于显示textField及相关组件的view
    toTop=210;
    textView=[[UIView alloc]initWithFrame:CGRectMake(347, toTop, SCREEN_WIDTH-2*347, 88)];
    [frontView addSubview:textView];
    
    topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 42, 330, 2)];
    topLine.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [textView addSubview:topLine];
    
    bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 86, 330, 2)];
    bottomLine.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [textView addSubview:bottomLine];
    
    warningLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-37-200, 86+2+3, 200, 13)];
    warningLabel.text=NSLocalizedString(@"VC_No network connection is established.", nil);
    warningLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:10];
    warningLabel.textAlignment=NSTextAlignmentRight;
    warningLabel.textColor=[UIColor colorWithRed:255/255.0 green:60/255.0 blue:48/255.0 alpha:1];
    [textView addSubview:warningLabel];
    warningLabel.alpha=0;
    
    topTextfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 20, 330, 17)];
    topTextfield.placeholder=@"Email Adress";
    topTextfield.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    topTextfield.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    topTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    topTextfield.autocorrectionType=UITextAutocorrectionTypeNo;
    topTextfield.returnKeyType=UIReturnKeyNext;
    topTextfield.delegate=self;
    topTextfield.tag=1;
    topTextfield.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [topTextfield addTarget:self action:@selector(signInBtnCanBePressed) forControlEvents:UIControlEventEditingChanged];
    [textView addSubview:topTextfield];
    
    bottomTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, 64, 330, 17)];
    bottomTextField.placeholder=@"Password";
    bottomTextField.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    bottomTextField.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    bottomTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    bottomTextField.returnKeyType=UIReturnKeyGo;
    bottomTextField.secureTextEntry=YES;
    bottomTextField.delegate=self;
    bottomTextField.tag=2;
    bottomTextField.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [bottomTextField addTarget:self action:@selector(signInBtnCanBePressed) forControlEvents:UIControlEventEditingChanged];
    [textView addSubview:bottomTextField];
    
    //clear 按钮，找回密码
    topClearBtn=[[UIButton alloc]initWithFrame:CGRectMake(330-30, 0, 30, 44)];
    [topClearBtn setImage:[UIImage imageNamed:@"icon_delete_textfield"] forState:UIControlStateNormal];
    [textView addSubview:topClearBtn];
    [topClearBtn addTarget:self action:@selector(clearBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    topClearBtn.tag=1;
    topClearBtn.alpha=0;
    
    bottomClearBtn=[[UIButton alloc]initWithFrame:CGRectMake(330-35-30, 44, 30, 44)];
    [bottomClearBtn setImage:[UIImage imageNamed:@"icon_delete_textfield"] forState:UIControlStateNormal];
    [textView addSubview:bottomClearBtn];
    [bottomClearBtn addTarget:self action:@selector(clearBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    bottomClearBtn.tag=2;
    bottomClearBtn.alpha=0;
    
    forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(330-30, 44, 30, 44)];
    [forgetBtn setImage:[UIImage imageNamed:@"icon_forgetpassword"] forState:UIControlStateNormal];
    [textView addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(forgetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    emlLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 4, 100, 13)];
    emlLabel.text=@"Email Address";
    emlLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    emlLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:10];
    [textView addSubview:emlLabel];
    emlLabel.alpha=0;
    
    pswLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 48, 100, 13)];
    pswLabel.text=@"Password";
    pswLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    pswLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:10];
    [textView addSubview:pswLabel];
    pswLabel.alpha=0;
    
    //buttons
    signinBtn=[[UIButton alloc]initWithFrame:CGRectMake(347, toTop+88+40, 330, 44)];
    signinBtn.backgroundColor=[UIColor colorWithRed:146/255.0 green:234/255.0 blue:168/255.0 alpha:1];
    signinBtn.enabled=NO;
    [signinBtn setTitleColor:[UIColor colorWithRed:202/255.0 green:244/255.0 blue:211/255.0 alpha:1] forState:UIControlStateDisabled];
    signinBtn.layer.cornerRadius=6;
    signinBtn.layer.masksToBounds=YES;
    [signinBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    signinBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [signinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signinBtn addTarget:self action:@selector(signinBntPressed:) forControlEvents:UIControlEventTouchUpInside];
    [frontView addSubview:signinBtn];
    
    startBtn=[[UIButton alloc]initWithFrame:CGRectMake(347, toTop+88+40, 330, 44)];
    startBtn.backgroundColor=[UIColor colorWithRed:146/255.0 green:234/255.0 blue:168/255.0 alpha:1];
    startBtn.enabled=NO;
    startBtn.layer.cornerRadius=6;
    startBtn.layer.masksToBounds=YES;
    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    startBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [frontView addSubview:startBtn];
    startBtn.alpha=0;
    
    UIImage *loadImage=[UIImage imageNamed:@"sign_icon_load"];
    load=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, loadImage.size.width, loadImage.size.height)];
    load.image=loadImage;
    load.center=signinBtn.center;
    load.alpha=0;
    [frontView addSubview:load];
    
    //给load添加动画
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration=1;
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.repeatCount=NSIntegerMax;
    [load.layer addAnimation:animation forKey:@"rotate-layer"];
    
    fbBtn=[[UIButton alloc]initWithFrame:CGRectMake(347, toTop+88+40+44+20, 330, 44)];
    [fbBtn setImage:[UIImage imageNamed:@"ipad_sign_button"] forState:UIControlStateNormal];
    fbBtn.layer.cornerRadius=6;
    fbBtn.layer.masksToBounds=YES;
    [fbBtn addTarget:self action:@selector(signinWithFB) forControlEvents:UIControlEventTouchUpInside];
    [frontView addSubview:fbBtn];
    
    signupBtn=[[UIButton alloc]initWithFrame:CGRectMake(330+347-60, toTop+88+40+44+20+44+18, 60, 20)];
    [signupBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    signupBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
    signupBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [signupBtn setTitleColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1] forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [frontView addSubview:signupBtn];
    
}
#pragma mark - 响应事件
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (isSignIn==YES)
    {
        [topTextfield resignFirstResponder];
        [bottomTextField resignFirstResponder];
    }
}
#pragma mark - textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1)
    {
        [bottomTextField becomeFirstResponder];
    }
    else
    {
        [self performSelector:@selector(signinBntPressed:) withObject:nil];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1)
    {
        topLine.backgroundColor=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
        topClearBtn.alpha=1;
        bottomClearBtn.alpha=0;
    }
    else
    {
        bottomLine.backgroundColor=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
        topClearBtn.alpha=0;
        bottomClearBtn.alpha=1;
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1)
    {
        topLine.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        topClearBtn.alpha=0;
    }
    else
    {
        bottomLine.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        bottomClearBtn.alpha=0;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //监测是否有text
    if ([string isEqualToString:@""] && textField.text.length == range.length)
    {
        if (textField.tag==1)
        {
            emlLabel.alpha=0;
        }
        if (textField.tag==2)
        {
            pswLabel.alpha=0;
        }
    }
    else
    {
        if (textField.tag==1)
        {
            emlLabel.alpha=1;
        }
        if (textField.tag==2)
        {
            pswLabel.alpha=1;
        }
    }
    
    
    return YES;
}
#pragma  mark - Btn
-(void)signinBntPressed:(id)sender
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    //判断有无网络连接
    if (!appDelegate.networkConnected)
    {
        signinBtn.backgroundColor=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
        [signinBtn setImage:[UIImage imageNamed:@"sign_icon_remind"] forState:UIControlStateNormal];
        [signinBtn setTitle:@"" forState:UIControlStateNormal];
        warningLabel.alpha=1;
        [self performSelector:@selector(recoveryAfterNetWarning) withObject:nil afterDelay:2];
        signinBtn.enabled=NO;
        return;
    }
    [self btnAnimationStart];
    signinBtn.enabled=NO;
    
    
    
    if (isSignIn)
    {
        [PFUser logInWithUsernameInBackground:topTextfield.text password:bottomTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            
            [self btnAnimationStop];
            
            if (error)
            {
                signinBtn.enabled=YES;
                [self shakeIt];
            }
            else
            {
                [[XDPurchasedManager shareManager] getPFSetting];
                [appDelegate succededInLogIn];
            }
        }];
        
    }
    else
    {
        
        PFUser *user=[PFUser user];
        user.username=topTextfield.text;
        user.password=bottomTextField.text;
        user.email=topTextfield.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self btnAnimationStop];
            if (error)
            {
                signinBtn.enabled=YES;
                [self shakeIt];
            }
            else
            {
                [appDelegate succededInSignUp];
                [[XDPurchasedManager shareManager] saveDefaultParseSetting];
                [[XDPurchasedManager shareManager] tryOutPremium30DaysWithNewUser];

            }
        }];
    }
    
    
}
-(void)signUpBtnClick
{
    isSignIn=NO;
    backToBtn.alpha=1;
    [topTextfield becomeFirstResponder];
    [signinBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    signupBtn.alpha=0;
    fbBtn.alpha=0;
}
-(void)backBtnClick
{
    backToBtn.alpha=0;
    fbBtn.alpha=1;
    [signinBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    isSignIn=YES;
    [topTextfield resignFirstResponder];
    [bottomClearBtn resignFirstResponder];
    signupBtn.alpha=1;
}
-(void)signinWithFB
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"user_about_me"] block:^(PFUser *user, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@",error);
         }
         if (!user)
         {
             NSLog(@"Uh oh. The user cancelled the Facebook login.");
         }
         else if (user.isNew)
         {
             NSLog(@"User signed up and logged in through Facebook!");
             [appDelegate succededInSignUp];
             if ([FBSDKAccessToken currentAccessToken])
             {
                 FBSDKGraphRequest *graph=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters: nil];
                 [graph startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]]];
                     
                     NSData  *avaData = [NSData dataWithContentsOfURL:url];
                     
                     
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
                     NSString *documentsPath = [paths objectAtIndex:0];
                     [avaData writeToFile:[NSString stringWithFormat:@"%@/avatarImage.jpg", documentsPath] atomically:YES];
                     
                     user.username=result[@"name"];
                     
                     PFFile *photo=[PFFile fileWithName:[NSString stringWithFormat:@"avatar.jpg"] data:avaData];
                     user[@"avatar"]=photo;
                     [user saveInBackground];
                 }];
             }
         }
         else
         {
             NSLog(@"User logged in through Facebook!");
             [appDelegate succededInLogIn];
             [[XDPurchasedManager shareManager] getPFSetting];

             
         }
         
     }];
    
}


#pragma mark - 响应方法
-(void)shakeIt
{
    direction=1;
    shakes=0;
    [self shake:textView];
}
-(void)recoveryAfterNetWarning
{
    //无网络连接两秒后恢复
    signinBtn.backgroundColor=[UIColor colorWithRed:37/255.0 green:212/255.0 blue:80/255.0 alpha:1];
    [signinBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    [signinBtn setImage:nil forState:UIControlStateNormal];
    signinBtn.enabled=YES;
    warningLabel.text=NSLocalizedString(@"VC_No network connection is established.", nil);
    warningLabel.alpha=0;
}
-(void)recoveryAfterForgetPw
{
    topLine.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    warningLabel.alpha=0;
    warningLabel.text=NSLocalizedString(@"VC_No network connection is established.", nil);
}


#warning 修改过
-(void)signInBtnCanBePressed
{
//    判断textfield是否满足登录条件
    if ([self validateEmail:topTextfield.text] && ![bottomTextField.text isEqualToString:@""])
    {
        signinBtn.enabled=YES;
        signinBtn.backgroundColor=[UIColor colorWithRed:37/255.0 green:212/255.0 blue:80/255.0 alpha:1];
    }
    else
    {
        signinBtn.enabled=NO;
        signinBtn.backgroundColor=[UIColor colorWithRed:146/255.0 green:234/255.0 blue:168/255.0 alpha:1];
    }
}


- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
-(void)clearBtnPressed:(id)sender
{
    UIButton *btn=sender;
    if (btn.tag==1)
    {
        topTextfield.text=@"";
        emlLabel.alpha=0;
    }
    else
    {
        bottomTextField.text=@"";
        pswLabel.alpha=0;
    }
}
-(void)forgetBtnPressed
{
    
    [PFUser requestPasswordResetForEmailInBackground:topTextfield.text block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error)
        {
            topLine.backgroundColor=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:110/255.0 alpha:1];
            warningLabel.text=[NSString stringWithFormat:@"No user found with email %@.",topTextfield.text];
            warningLabel.alpha=1;
            [self performSelector:@selector(recoveryAfterForgetPw) withObject:nil afterDelay:2];
        }
        else
        {
           NSString *alertStr = [NSString stringWithFormat:NSLocalizedString(@"VC_We have sent an email to <email address>. Please follow the directions in the email to reset password", nil),topTextfield.text];            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

#pragma mark - 键盘响应
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    [UIView animateWithDuration:duration animations:^
     {
         frontView.frame=CGRectMake(0, 47, SCREEN_WIDTH, SCREEN_HEIGHT-187);
         
         textView.frame=CGRectMake(347, 181, 330, 88);
         
         signinBtn.frame=CGRectMake(347, 181+88+40,330, 44);
         fbBtn.frame=CGRectMake(347, 181+88+40+44+40, 330, 44);
         signupBtn.frame=CGRectMake(330+347-60, 138+88+40+44+40+44+18, 60, 20);
         load.center=signinBtn.center;
     }];
    
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    double duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        frontView.frame=CGRectMake(0, 187, SCREEN_WIDTH, SCREEN_HEIGHT-187);
        
        textView.frame=CGRectMake(347, toTop, SCREEN_WIDTH-2*347, 88);
        
        signinBtn.frame=CGRectMake(347, toTop+88+40, 330, 44);
        fbBtn.frame=CGRectMake(347, toTop+88+40+44+20, 330, 44);
        signupBtn.frame=CGRectMake(330+347-60, toTop+88+40+44+20+44+18, 60, 20);
        load.center=signinBtn.center;
    }];
    
    
}
#pragma  mark - Animation
-(void)btnAnimationStart
{
    [signinBtn setTitle:@"" forState:UIControlStateNormal];
    
    load.alpha=1;
    
}
-(void)btnAnimationStop
{
    [signinBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    load.alpha=0;
}
#pragma mark - 振动 方法
-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.05 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 4)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}

@end

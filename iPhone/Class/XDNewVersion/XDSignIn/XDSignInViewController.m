//
//  XDSignInViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/17.
//

#import "XDSignInViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate_iPhone.h"
#import "ParseDBManager.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@import Firebase;
@interface XDSignInViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbBtnTopH;

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlBottomY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTopH;
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading2;
@property (weak, nonatomic) IBOutlet UILabel *warmLabel;

@end

@implementation XDSignInViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FIRAnalytics setScreenName:@"sign_in_view_iphone" screenClass:@"XDSignInViewController"];

    NSArray* titleArr = @[@"See where your money goes",@"Get intuitive analysis",@"Budgets under control",@"Never forget a bill"];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    for (int i = 1; i < 5; i++) {
        UIImageView* imageView = [[UIImageView alloc]init];
        if (IS_IPHONE_5) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"start page%d-i5",i]];
            imageView.frame = CGRectMake(SCREEN_WIDTH*(i-1), 50, SCREEN_WIDTH, 220);
            imageView.contentMode = UIViewContentModeCenter;

        }else if(IS_IPHONE_X){
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"start page%d",i]];
            imageView.frame = CGRectMake(SCREEN_WIDTH*(i-1), 40, SCREEN_WIDTH, 353);
            imageView.contentMode = UIViewContentModeCenter;

        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"start page%d",i]];
            imageView.frame = CGRectMake(SCREEN_WIDTH*(i-1), 0, SCREEN_WIDTH, 353);
            imageView.contentMode = UIViewContentModeCenter;


        }
        [self.scrollView addSubview:imageView];
        
        UILabel* lbl = [[UILabel alloc]init];
        if (IS_IPHONE_5) {
            lbl.frame =CGRectMake(0, 190, SCREEN_WIDTH, 24);
            lbl.font = [UIFont fontWithName:FontSFUITextMedium size:14];
        }else if(IS_IPHONE_X){
            
            lbl.frame =CGRectMake(0, 300, SCREEN_WIDTH, 24);
            lbl.font = [UIFont fontWithName:FontSFUITextMedium size:22];
            
        }else{
            lbl.frame =CGRectMake(0, 280, SCREEN_WIDTH, 24);
            lbl.font = [UIFont fontWithName:FontSFUITextMedium size:18];
        }
        lbl.textColor = RGBColor(176, 204, 255);
        lbl.text = titleArr[i-1];
        lbl.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:lbl];
    }
    
    self.signInBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    
    self.signUpBtn.layer.cornerRadius = 15;
    self.signUpBtn.layer.masksToBounds = YES;
    
//    self.signInBtn.backgroundColor = [UIColor colorWithRed:113/255. green:163/255. blue:245/255. alpha:0.6];
    
    self.indicator.hidden = YES;
    
    if (IS_IPHONE_5) {
        self.fbBtnTopH.constant = 0;
        self.bjImageView.image = [UIImage imageNamed:@"di_se"];
        self.topViewH.constant = 284;
        self.emailTopH.constant = 10;
        self.leading1.constant = -20;
        self.leading2.constant = -20;
    }else if(IS_IPHONE_X){
        self.topViewH.constant = 386;
        self.bjImageView.image = [UIImage imageNamed:@"bj_x"];
        self.pageControlBottomY.constant = -25;
        self.emailTopH.constant = 50;
        self.fbBtnTopH.constant = 30;
    }else if(IS_IPHONE_6){
        self.emailTopH.constant = 30;
        self.topViewH.constant = 353;
        self.fbBtnTopH.constant = 10;
    }else{
        self.emailTopH.constant = 40;
        self.topViewH.constant = 353;
        self.fbBtnTopH.constant = 30;
    }
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.bottomView addGestureRecognizer:pan];
    
    [self.signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
}

-(void)pan:(UIPanGestureRecognizer*)gest{
    
    if (gest.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[gest translationInView:self.view]];
    }
}



- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    
    
    if (absX > absY ) {
        
        if (translation.x<0) {
            
            //向左滑动
        }else{
            
            //向右滑动
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            
            //向上滑动
        }else{
            
            [self.view endEditing:YES];
            [UIView animateWithDuration:0.2 animations:^{
                self.topView.transform = CGAffineTransformIdentity;
                self.bottomView.transform = CGAffineTransformIdentity;
                
            }];

        }
    }
}




- (IBAction)fbBtnClick:(id)sender {
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (![appDelegate networkConnected]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No Network Connection!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Log In";
    hud.mode = MBProgressHUDModeIndeterminate;
    [PFFacebookUtils facebookLoginManager].loginBehavior = FBSDKLoginBehaviorWeb;
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"user_about_me"] block:^(PFUser *user, NSError *error)
     {
         [hud hideAnimated:YES];
         [hud removeFromSuperview];
         
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

-(void)keyboardWillChangeFrame:(NSNotification*)noti{
    NSValue *value = [[noti userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];

    [UIView animateWithDuration:0.2 animations:^{
        if (value.CGRectValue.origin.y != SCREEN_HEIGHT){
            self.topView.transform = CGAffineTransformMakeTranslation(0, -400);
            if (IS_IPHONE_5) {
                self.bottomView.transform = CGAffineTransformMakeTranslation(0, -230);
            }else{
                self.bottomView.transform = CGAffineTransformMakeTranslation(0, -300);
            }
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

        }else{
            self.topView.transform = CGAffineTransformIdentity;
            self.bottomView.transform = CGAffineTransformIdentity;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

        }
    }];
};


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    self.pageControl.currentPage = index;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

- (IBAction)signInBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    //判断有无网络连接
    if (!appDelegate.networkConnected){
        self.warmLabel.hidden = NO;
        self.warmLabel.text=NSLocalizedString(@"VC_No network connection is established.", nil);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.warmLabel.hidden = YES;
            });

        });
        return;
    }
    
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    if (![self isValidateEmail:self.emailTF.text] || self.emailTF.text.length == 0 || self.passwordTF.text.length == 0) {
        
        self.indicator.hidden = YES;
        [self.indicator stopAnimating];

        [self shakeAnimationForView:self.emailTF];
        [self shakeAnimationForView:self.passwordTF];
        [self shakeAnimationForView:self.imageView1];
        [self shakeAnimationForView:self.imageView2];
        
        return;
    }
    

    if ([self.signInBtn.titleLabel.text isEqualToString:@"Sign In"]){
        [PFUser logInWithUsernameInBackground:self.emailTF.text password:self.passwordTF.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            
            if (error)
            {
                
                [self shakeAnimationForView:self.emailTF];
                [self shakeAnimationForView:self.passwordTF];
                [self shakeAnimationForView:self.imageView1];
                [self shakeAnimationForView:self.imageView2];

//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
                self.warmLabel.hidden = NO;
                self.warmLabel.text=[NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.warmLabel.hidden = YES;
                    });
                    
                });
            }
            else
            {
                [appDelegate succededInLogIn];
                [[XDPurchasedManager shareManager] getPFSetting];

            }
        }];
        
    }else{
        PFUser *user=[PFUser user];
        user.username=self.emailTF.text;
        user.password=self.passwordTF.text;
        user.email=self.emailTF.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            if (error)
            {
                [self shakeAnimationForView:self.emailTF];
                [self shakeAnimationForView:self.passwordTF];
                [self shakeAnimationForView:self.imageView1];
                [self shakeAnimationForView:self.imageView2];
                
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.userInfo[@"error"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
                
                self.warmLabel.hidden = NO;
                self.warmLabel.text=[NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.warmLabel.hidden = YES;
                    });
                });
            }
            else
            {
                [appDelegate succededInSignUp];
                [[XDPurchasedManager shareManager] saveDefaultParseSetting];
      
            }
        }];
        
    }
    
    
}

- (IBAction)signUpBtnClick:(id)sender {
    [self.emailTF becomeFirstResponder];
    
    if ([self.signInBtn.titleLabel.text isEqualToString:@"Sign In"]) {
        
        [self.signInBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.signUpBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    }else{
        
        [self.signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
        [self.signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
    
}
- (IBAction)forgetBtnClick:(id)sender {
    if (self.emailTF.text.length > 0) {
        if (![self isValidateEmail:self.emailTF.text]) {
            self.topLine.backgroundColor = [UIColor redColor];
            self.warmLabel.hidden = NO;
            self.warmLabel.text = @"Email format is incorrent";
            [self shakeAnimationForView:self.emailTF];
            [self shakeAnimationForView:self.imageView1];
        }else{
            self.topLine.backgroundColor = RGBColor(230, 230, 230);
            
            [PFUser requestPasswordResetForEmailInBackground:self.emailTF.text block:^(BOOL succeeded, NSError * _Nullable error) {
                if (error)
                {
                    self.warmLabel.hidden = NO;
                    self.warmLabel.text=[NSString stringWithFormat:@"No user found with email %@.",self.emailTF.text];
                    [self shakeAnimationForView:self.emailTF];
                    [self shakeAnimationForView:self.imageView1];
                }
                else
                {
                    self.warmLabel.hidden = YES;
                    NSString *alertStr = [NSString stringWithFormat:NSLocalizedString(@"VC_We have sent an email to <email address>. Please follow the directions in the email to reset password", nil),self.emailTF.text];
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }];
        }
    }else{
        self.warmLabel.hidden = NO;
        self.warmLabel.text = @"Please enter Email";
        [self shakeAnimationForView:self.emailTF];
        [self shakeAnimationForView:self.imageView1];
    }
}

- (IBAction)textValueChanged:(id)sender {
    UITextField* text = sender;
    
    if (text == self.emailTF) {
        if (![self isValidateEmail:self.emailTF.text]) {
            self.topLine.backgroundColor = [UIColor redColor];
        }else{
            self.topLine.backgroundColor = RGBColor(230, 230, 230);
        }
    }
    
//    if ([self isValidateEmail:self.emailTF.text] && self.passwordTF.text.length > 0) {
//        self.signInBtn.enabled = YES;
//        [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"save_nurmal1"] forState:UIControlStateNormal];
//    }else{
//        self.signInBtn.enabled = NO;
////        [self.signInBtn setImage:[UIImage imageNamed:@"save_disabled1"] forState:UIControlStateNormal];
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([self isValidateEmail:self.emailTF.text] && self.passwordTF.text.length > 0) {
//        self.signInBtn.enabled = YES;
//        [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"save_nurmal1"] forState:UIControlStateNormal];
//    }else{
//        self.signInBtn.enabled = NO;
////        [self.signInBtn setImage:[UIImage imageNamed:@"save_disabled1"] forState:UIControlStateNormal];
//    }
    
    if (self.emailTF.text.length == 0) {
        self.topLine.backgroundColor = RGBColor(230, 230, 230);
    }
}


- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 5, position.y);
    CGPoint y = CGPointMake(position.x - 5, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)isValidateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end

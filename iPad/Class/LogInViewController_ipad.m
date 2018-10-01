//
//  LogInViewController_ipad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/6/30.
//
//

#import "LogInViewController_ipad.h"
#import "NSStringAdditions.h"
#import "UIViewAdditions.h"
#import <Parse/Parse.h>
#import "AppDelegate_iPad.h"
#import "HMJCustomAnimationButton.h"

#define LOGS_ENABLED NO
#define ANIMATION_DURATION   0.25
#define SLIDESHOW_WIDTH 400

@interface LogInViewController_ipad ()<UIAlertViewDelegate>
{
    BOOL isSignIn;
    float angle;
    HMJCustomAnimationButton *aniBtn;
    HMJCustomAnimationButton *startBtn;
    NSString *_alertString;
}
@end

@implementation LogInViewController_ipad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isKeyboardUp=NO;
    isNextTextFieldTouch=NO;
    isSignIn=YES;
    
    
    self.slideShow=[[DRDynamicSlideShow_ipad alloc]init];
    self.viewsForPages=[[NSArray alloc]init];
    self.slideShow.logInViewController_ipad=self;
    
    //创建动画
    [self.slideShow setFrame:CGRectMake((1024-SLIDESHOW_WIDTH)/2, 0, SLIDESHOW_WIDTH, 400)];
    [self.slideShow setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.slideShow setAlpha:1];
    [self.slideShow setDidReachPageBlock:^(NSInteger reachedPage) {
        if (LOGS_ENABLED) {
            NSLog(@"Current Page:%li",(long)reachedPage);
        }
    }];
    self.slideShow.bounces=NO;
    [self.view insertSubview:self.slideShow belowSubview:_bgBtn];
    
    self.viewsForPages=[[NSBundle mainBundle]loadNibNamed:@"DRDynamicSlideShowSubviews" owner:self options:nil];
    [self setupSlideShowSubviewsAndAnimations];
    
    
    //返回按钮
    [_arrowBtn setBackgroundImage:[UIImage imageNamed:[NSString customImageName:@"ipad_arrow"]] forState:UIControlStateNormal];
    _arrowBtn.alpha=0;
    [_arrowBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //响应事件添加
    [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_forgetpasswordBtn addTarget:self action:@selector(forgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    _forgetpasswordBtn.backgroundColor=[UIColor blackColor];
    
    [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    _emailAddressTextfield.delegate=self;
    _passwordTextfield.delegate=self;
    UIFont *font_Light = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    UIColor *black1 = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:font_Light,NSFontAttributeName,black1,NSForegroundColorAttributeName, nil];
    _emailAddressTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:dic];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:dic];

    [_signUpBtn setTitle:NSLocalizedString(@"VC_Sign Up", nil) forState:UIControlStateNormal];

    
    [self createAnimationButton];
    [self createStartBtn];
    
    startBtn.alpha=0;
    [self viewLayout];
    
}
-(void)createAnimationButton
{
    //SIGN IN button
    CGFloat y;
    y=567;
    UIImage *signin = [UIImage imageNamed:[NSString customImageName:@"ipad_sign_in"]];
    CGFloat width=signin.size.width;
    CGFloat height=signin.size.height;
    CGFloat x=(1024-width)/2;
    
//    NSLog(@"%f ddd %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    CGRect size=CGRectMake(x, y, width, height);
    
    aniBtn=[[HMJCustomAnimationButton alloc]initWithFrame:size title:NSLocalizedString(@"VC_SIGN IN", nil) backgroundColor:[UIColor colorWithRed:76.f/255.f green:143.f/255.f blue:202.f/255.f alpha:1]];
    
    [self.view addSubview:aniBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signInBtnPressed:)];
    
    [aniBtn addGestureRecognizer:tap];
    
}
-(void)createStartBtn
{
    CGFloat y;
    y=330;
    UIImage *signin = [UIImage imageNamed:[NSString customImageName:@"ipad_next"]];
    CGFloat width=signin.size.width;
    CGFloat height=signin.size.height;
    CGFloat x=aniBtn.left+aniBtn.width-width;
    
    CGRect size=CGRectMake(x, y, width, height);
    
    startBtn=[[HMJCustomAnimationButton alloc]initWithFrame:size title:NSLocalizedString(@"VC_Start", nil) backgroundColor:[UIColor colorWithRed:76.f/255.f green:143.f/255.f blue:202.f/255.f alpha:1]];
    
    [self.view addSubview:startBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(start)];
    
    [startBtn addGestureRecognizer:tap];
}

-(void)viewLayout
{
    _bgBtn.hidden=YES;
    
    _topBgLine.height=SCREEN_SCALE;
    _bottomBgLine.top = 100-SCREEN_SCALE;
    _bottomBgLine.height = SCREEN_SCALE;
    _leftBgLine.width = SCREEN_SCALE;
    _rightBgLine.left = _contentView.width-SCREEN_SCALE;
    _rightBgLine.width = SCREEN_SCALE;
    _middleBgLine.height = SCREEN_SCALE;
    
    float textLeft=15;
    [_emailAddressTextfield setFrame:CGRectMake(textLeft, SCREEN_SCALE, _contentView.width-23, 50-SCREEN_SCALE)];
    [_passwordTextfield setFrame:CGRectMake(textLeft, 50, _contentView.width-textLeft-_forgetpasswordBtn.width, 50)];
    
    
    _warningLabel.left=_contentView.left;
    _warningLabel.width=SCREEN_WIDTH-2*_warningLabel.left;
    
    startBtn.top=334;
    _arrowBtn.top=340;
    _arrowBtn.left=_contentView.left;
//    UIImage *arrow=[UIImage imageNamed:[NSString customImageName:@"ipad_arrow"]];
//    _arrowBtn.width=arrow.size.width;
//    _arrowBtn.height=arrow.size.height;
    
    
    
    startBtn.right=_contentView.right;
    
    _pageController.top=380;
    _contentView.top=440;
    _signUpView.top=623;
    _warningLabel.top=542;
    _signUpView.left=1024/2-_signUpView.width/2;
}



-(void)setupSlideShowSubviewsAndAnimations
{
    for (UIView *pageView in self.viewsForPages)
    {
        for (UIView *subview in pageView.subviews)
        {
            switch (subview.tag) {
                case 1:
                {
                    UIImage *image=[UIImage imageNamed:[NSString customImageName:@"ipad_logo_a1"]];
                    ((UIImageView *)subview).image=image;
                    subview.width=image.size.width;
                    subview.height = image.size.height;
                    subview.left=(SLIDESHOW_WIDTH-image.size.width)/2;
                    subview.top=120;
                }
                    break;
                case 2:
                {
                    UIImage *image=[UIImage imageNamed:[NSString customImageName:@"ipad_pocket_expense_a1"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH- image.size.width)/2;
                    subview.top = 274;
                }
                    break;
                case 3:
                {
                    UIImage *image=[UIImage imageNamed:[NSString customImageName:@"ipad_phone"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=58;
                    subview.top=162;
                }
                    break;
                case 4:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_sync"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=131;
                    subview.top=202;
                }
                    break;
                case 5:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_pad"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=188;
                    subview.top=162;
                }
                    break;
                case 6:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_document"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=74;
                    subview.top=146;
                }
                    break;
                case 7:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_pie_chart"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=178;
                    subview.top=212;
                }
                    break;
                case 8:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_histogram"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=256;
                    subview.top=178;
                }
                    break;
                case 9:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_text1"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top=324;
                }
                    break;
                case 10:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_text2"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top=324;
                }
                    break;
                case 11:
                {
                    UIImage *image=[UIImage imageNamed:[NSString customImageName:@"ipad_Welcome_to"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top=250;
                }
                    break;
                default:
                    break;
            }
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height)];
            [self.slideShow addSubview:subview onPage:pageView.tag];
        }
    }
    //page0 animation
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:iconImage page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(20+SLIDESHOW_WIDTH, 86, 34, 34)] delay:0]];
    
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:descriptionImageView page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(62+SLIDESHOW_WIDTH, 95, 128, 12)] delay:0]];
    
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    [phoneImageView setCenter:CGPointMake(phoneImageView.center.x+SLIDESHOW_WIDTH/2, phoneImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:phoneImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(phoneImageView.center.x-SLIDESHOW_WIDTH/2, phoneImageView.center.y)] delay:0]];
    
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    [syncImageView setCenter:CGPointMake(syncImageView.center.x+SLIDESHOW_WIDTH*2, syncImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:syncImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(syncImageView.center.x-SLIDESHOW_WIDTH*2, syncImageView.center.y)] delay:0]];
    
    
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    [padImageView setCenter:CGPointMake(padImageView.center.x+SLIDESHOW_WIDTH*3, padImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:padImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(padImageView.center.x-SLIDESHOW_WIDTH*3, padImageView.center.y)] delay:0]];
    
    
    UIImageView *page2Label = (UIImageView *)[self.view viewWithTag:9];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:page2Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    
    //page1 animation
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:iconImage page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(20+SLIDESHOW_WIDTH, 86, 34, 34)] toValue:[NSValue valueWithCGRect:CGRectMake(20+SLIDESHOW_WIDTH*2, 86, 34, 34)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:descriptionImageView page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(62+SLIDESHOW_WIDTH, 95, 128, 12)] toValue:[NSValue valueWithCGRect:CGRectMake(62+SLIDESHOW_WIDTH*2, 95, 128, 12)] delay:0]];
    
    
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    [documentImageView setCenter:CGPointMake(documentImageView.center.x+SLIDESHOW_WIDTH/2, documentImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:documentImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(documentImageView.center.x-SLIDESHOW_WIDTH/2, documentImageView.center.y)] delay:0]];
    
    
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    [reportImageView setCenter:CGPointMake(reportImageView.center.x+SLIDESHOW_WIDTH*2, reportImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:reportImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(reportImageView.center.x-SLIDESHOW_WIDTH*2, reportImageView.center.y)] delay:0]];
    
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    [historyImageView setCenter:CGPointMake(historyImageView.center.x+SLIDESHOW_WIDTH*3, historyImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:historyImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(historyImageView.center.x-SLIDESHOW_WIDTH*3, historyImageView.center.y)] delay:0]];
    
    
    UIImageView *page3Label = (UIImageView *)[self.view viewWithTag:10];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:page3Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
}

-(void)signInBtnPressed:(id)sender
{
    
    if([_emailAddressTextfield.text length]==0 || [_passwordTextfield.text length]==0)
    {
        _warningLabel.text=NSLocalizedString(@"VC_Email address or password is missing", nil);
        return;
    }
    //开始动画
    [aniBtn begainAnimation];
    
    self.view.userInteractionEnabled=NO;
    
    //获取当前时间--获取动画时间差
    NSDate *startDate=[NSDate date];
    
    [PFUser logInWithUsernameInBackground:_emailAddressTextfield.text password:_passwordTextfield.text block:^(PFUser *user, NSError *error)
     {
         NSTimeInterval late=[startDate timeIntervalSince1970];
         NSDate *endDate=[NSDate date];
         NSTimeInterval now=[endDate timeIntervalSince1970];
         float timeInterval=now -late;
         NSLog(@"tiemInterval:%f",timeInterval);
         if (user)
         {
             if (timeInterval<1.5)
             {
                 [self performSelector:@selector(succededAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
             }
             else
             {
                 [self succededAfterParseLogin];
             }
         }
         else
         {
             _alertString  =  [error userInfo][@"error"];
             if([_alertString isEqualToString:@"invalid login parameters"])
             {
                 _alertString = NSLocalizedString(@"VC_Email or passcode error", nil);
             }
             else if([_alertString isEqualToString:@"The Internet connection appears to be offline."])
             {
                 _alertString=NSLocalizedString(@"VC_No network connection is established.", nil);
             }
             
             if (timeInterval<1.5)
             {
                 [self performSelector:@selector(failedAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
                 
             }
             else
             {
                 [self failedAfterParseLogin];
             }
         }
     }];
}
#pragma mark UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>=SCREEN_WIDTH*2)
    {
        _pageController.currentPage=2;
    }
    else if (scrollView.contentOffset.x >= SCREEN_WITH)
        _pageController.currentPage = 1;
    else
        _pageController.currentPage = 0;
}
#pragma mark UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _warningLabel.text=@"";
    if (!isKeyboardUp)
    {
        [self keyboardUpAnimation];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailAddressTextfield)
    {
        [_passwordTextfield becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self bgTouch];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)bgTouch
{
    if (!isSignIn)
    {
        return;
    }
    if ([_emailAddressTextfield isFirstResponder])
    {
        [_emailAddressTextfield resignFirstResponder];
    }
    else if ([_passwordTextfield isFirstResponder])
    {
        [_passwordTextfield resignFirstResponder];
    }
    
    if (isKeyboardUp)
        [self keyboardDownAnimation];
}
-(void)keyboardUpAnimation
{
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    UIImageView  *documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    
    UIImageView *text1ImageView=(UIImageView *)[self.slideShow viewWithTag:9];
    UIImageView *text2ImageView=(UIImageView *)[self.slideShow viewWithTag:10];
    UIImageView *welcomeImageView=(UIImageView *)[self.slideShow viewWithTag:11];
    
    if (_pageController.currentPage==0)
    {
        _pageController.alpha = 0;
        welcomeImageView.alpha=0;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            [self keyboardUpUIObjectFrame:0];
        } completion:^(BOOL finished) {
            if (!isSignIn)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    startBtn.alpha=1;
                    _arrowBtn.alpha=1;
                }];
            }
        }];
    }
    else if (_pageController.currentPage == 1)
    {
        _pageController.alpha = 0;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            [self keyboardUpUIObjectFrame:1];
            phoneImageView.alpha = 0;
            syncImageView.alpha = 0;
            padImageView.alpha = 0;
            text1ImageView.alpha=0;
        } completion:^(BOOL finished) {
            if (!isSignIn)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    startBtn.alpha=1;
                    _arrowBtn.alpha=1;
                }];
            }
        }];
    }
    else
    {
        _pageController.alpha = 0;
        
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            [self keyboardUpUIObjectFrame:2];
            documentImageView.alpha = 0;
            reportImageView.alpha = 0;
            historyImageView.alpha = 0;
            text2ImageView.alpha=0;
        } completion:^(BOOL finished) {
            if (!isSignIn)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    startBtn.alpha=1;
                    _arrowBtn.alpha=1;
                }];
            }
        }];
    }
    
    _slideShow.scrollEnabled = NO;
    _bgBtn.hidden = NO;
    isKeyboardUp = YES;
}
-(void)keyboardUpUIObjectFrame:(int)page
{
    UIImageView *iconImageView = (UIImageView *)[self.slideShow viewWithTag:1];
    UIImageView * descriptionImageView = (UIImageView *)[self.slideShow viewWithTag:2];
    UIImage *iconImage = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a3"]];
    iconImageView.image = iconImage;
    iconImageView.width = iconImage.size.width;
    iconImageView.height = iconImage.size.height;
    iconImageView.left = (SLIDESHOW_WIDTH-iconImage.size.width)/2 + SLIDESHOW_WIDTH*page;
    
    UIImage *desImage = [UIImage imageNamed:[NSString customImageName:@"ipad_pocket_expense_a2"]];
    descriptionImageView.image=desImage;
    descriptionImageView.width = desImage.size.width;
    descriptionImageView.height = desImage.size.height;
    descriptionImageView.left = (SLIDESHOW_WIDTH-desImage.size.width)/2 + SLIDESHOW_WIDTH*page;
    _pageController.alpha = 0;

    iconImageView.top = 56;
    descriptionImageView.top = 162;
    _contentView.top = 204;
    _warningLabel.top=306;
    aniBtn.top = 334;
    _signUpView.top = 334+aniBtn.height+5;

}
-(void)keyboardDownAnimation
{
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    UIImageView * descriptionImageView = (UIImageView *)[self.slideShow viewWithTag:2];
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    UIImageView *text1ImageView=(UIImageView *)[self.slideShow viewWithTag:9];
    UIImageView *text2ImageView=(UIImageView *)[self.slideShow viewWithTag:10];
    UIImageView *welcomeImage=(UIImageView *)[self.slideShow viewWithTag:11];
    
    if (_pageController.currentPage==0)
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
        
            welcomeImage.alpha=1;
            welcomeImage.top=250;
            _pageController.top=380;
            _contentView.top=440;
            _warningLabel.top=545;
            aniBtn.top=568;
            _signUpView.top=635;

            UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a1"]];
            iconImage.image=image;
            iconImage.width = image.size.width;
            iconImage.height = image.size.height;
            iconImage.left = (SLIDESHOW_WIDTH - image.size.width)/2;
            iconImage.top = 120;
            
            UIImage *image2 = [UIImage imageNamed:[NSString customImageName:@"ipad_pocket_expense_a1"]];
            descriptionImageView.image=image2;
            descriptionImageView.width = image2.size.width;
            descriptionImageView.height = image2.size.height;
            descriptionImageView.left = (SLIDESHOW_WIDTH - image2.size.width)/2;
            descriptionImageView.top =274;

            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _pageController.alpha = 1;
            }];
        }];
    }
    else if (_pageController.currentPage==1)
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            iconImage.frame = CGRectMake(20+SLIDESHOW_WIDTH, 86, 34, 34);
            descriptionImageView.frame = CGRectMake(62+SLIDESHOW_WIDTH, 95, 128, 12);
            _pageController.alpha = 1;
            phoneImageView.alpha = 1;
            syncImageView.alpha = 1;
            padImageView.alpha = 1;
            text1ImageView.alpha=1;
            _pageController.top=380;
            _contentView.top=440;
            _warningLabel.top=545;
            aniBtn.top=568;
            _signUpView.top=635;
        } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    _pageController.alpha = 1;
                }];
        }];
    }
    else
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            iconImage.frame = CGRectMake(20+SLIDESHOW_WIDTH*2, 86, 34, 34);
            descriptionImageView.frame = CGRectMake(62+SLIDESHOW_WIDTH*2, 95, 128, 12);
            _pageController.alpha = 1;
            documentImageView.alpha = 1;
            reportImageView.alpha = 1;
            historyImageView.alpha = 1;
            text2ImageView.alpha=1;
            _pageController.top=380;
            _contentView.top=440;
            _warningLabel.top=545;
            aniBtn.top=568;
            _signUpView.top=635;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _pageController.alpha = 1;
            }];
        }];
    }
    isKeyboardUp = NO;
    _slideShow.scrollEnabled = YES;
    _bgBtn.hidden = YES;
}
-(void)start
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.networkConnected)
    {
        _warningLabel.text=NSLocalizedString(@"VC_No network connection is established.", nil);
        return;
    }
    NSString *email=_emailAddressTextfield.text;
    NSString *password=_passwordTextfield.text;
    if([_emailAddressTextfield.text length]==0 || [_passwordTextfield.text length]==0)
    {
        _warningLabel.text=NSLocalizedString(@"VC_Email address or password is missing", nil);
        return;
    }
    if (![self validateEmail:email])
    {
        _warningLabel.text=NSLocalizedString(@"VC_Please use email address as your account.", nil);
        return;
    }
    
    self.view.userInteractionEnabled=NO;
    
    [startBtn begainAnimation];
    NSDate *start=[NSDate date];
    
    
    PFUser *user=[PFUser user];
    user.username=email;
    user.password=password;
    user.email=email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        NSTimeInterval late=[start timeIntervalSince1970];
        NSDate *endDate=[NSDate date];
        NSTimeInterval now=[endDate timeIntervalSince1970];
        float timeInterval=now -late;
        NSLog(@"tiemInterval:%f",timeInterval);
        
        
        if (!error)
        {
            
            //注册成功
            if (timeInterval<1.5)
            {
                [self performSelector:@selector(succededAfterParseStart) withObject:nil afterDelay:(1.5-timeInterval)];
            }
            else
            {
                [self succededAfterParseStart];
            }
            
        }
        else
        {
            if([_alertString isEqualToString:@"The Internet connection appears to be offline."])
            {
                _alertString=NSLocalizedString(@"VC_No network connection is established.", nil);
            }
            else
            {
                _alertString=NSLocalizedString(@"VC_The email address has been used by someone else.", nil);
            }
            
            if (timeInterval<1.5)
            {
                [self performSelector:@selector(failedAfterParseStart) withObject:nil afterDelay:(1.5-timeInterval)];
            }
            else
            {
                [self failedAfterParseStart];
            }
            
        }
    }];
}

-(void)forgetBtnPressed:(UIButton *)sender
{
    if ([_emailAddressTextfield.text length]==0)
    {
        _warningLabel.text=NSLocalizedString(@"VC_Email address or password is missing", nil);
        return;
    }
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_An email for password reset will be sent to your address.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) otherButtonTitles:NSLocalizedString(@"VC_OK", nil), nil];
    [alertView show];
}
-(void)signUpBtnPressed:(UIButton *)sender
{
    aniBtn.alpha=0;
    _warningLabel.text=@"";
    isSignIn=NO;
    NSLog(@"%d",isSignIn);
    [self keyboardUpAnimation];
    _signUpView.alpha=0;
    _forgetpasswordBtn.alpha=0;
    [_emailAddressTextfield becomeFirstResponder];
    float textLeft=15;

    [_passwordTextfield setFrame:CGRectMake(textLeft, 50, _contentView.width-textLeft, 50)];
}

-(void)back
{
    _warningLabel.text=@"";
    isSignIn=YES;
    [self keyboardDownAnimation];
    aniBtn.alpha=1;
    _signUpView.alpha=1;
    _arrowBtn.alpha=0;
    startBtn.alpha=0;
    _forgetpasswordBtn.alpha=1;
    [_emailAddressTextfield resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
    float textLeft=15;
    [_passwordTextfield setFrame:CGRectMake(textLeft, 50, _contentView.width-textLeft-_forgetpasswordBtn.width, 50)];
}
- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


#pragma alertView delegate 方法

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        
        NSError *error;
        [PFUser requestPasswordResetForEmail:_emailAddressTextfield.text error:&error];
        
        if (error)
        {
            NSString *alert=[NSString stringWithFormat:@"No user found with email %@.",_emailAddressTextfield.text];
            _warningLabel.text=alert;
            return;
        }
        
        [PFUser requestPasswordResetForEmailInBackground:_emailAddressTextfield.text];
        NSString *str=NSLocalizedString(@"VC_We have sent an email to <email address>. Please follow the directions in the email to reset password", nil);
        NSString *alertStr=[NSString stringWithFormat:str,_emailAddressTextfield.text];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma mark - After SIGN IN or START
-(void)failedAfterParseLogin
{
    [aniBtn endAnimation];
    self.view.userInteractionEnabled=YES;
    _warningLabel.text=_alertString;
}
-(void)succededAfterParseLogin
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [appDelegate succededInLogIn];
}
-(void)succededAfterParseStart
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [self.emailAddressTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    [appDelegate succededInSignUp];
}
-(void)failedAfterParseStart
{
    self.view.userInteractionEnabled=YES;
    _warningLabel.text=_alertString;
    [startBtn endAnimation];
}

@end

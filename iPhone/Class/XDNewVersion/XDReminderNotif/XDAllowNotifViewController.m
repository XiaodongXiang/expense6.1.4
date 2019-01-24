//
//  XDAllowNotifViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/22.
//

#import "XDAllowNotifViewController.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDAllowNotifViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading;
@property (weak, nonatomic) IBOutlet UIButton *allowBtn;

@end

@implementation XDAllowNotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allowBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);

}
- (IBAction)laterClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)allowClick:(id)sender {
    
    UIApplication* application = [UIApplication sharedApplication];
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)application.delegate;

    [UNUserNotificationCenter currentNotificationCenter].delegate = appDelegate;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
    UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:authOptions
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
         // ...
         [self dismissViewControllerAnimated:NO completion:nil];
         
     }];
    [application registerForRemoteNotifications];


    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    visualEffectView.alpha = 1.0;
    [self.view addSubview:visualEffectView];
    
    UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shou"]];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.frame = CGRectMake(SCREEN_WIDTH/2+40, SCREEN_HEIGHT/2+110, 50, 50);
    [self.view addSubview:imgView];
    
    [self popJumpAnimationView:imgView];
    
}


- (void)popJumpAnimationView:(UIView *)sender
{
    
    CGFloat duration = 1.f;
    CGFloat height = 7.f;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTy = sender.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentTy), @(currentTy - height/4), @(currentTy-height/4*2), @(currentTy-height/4*3), @(currentTy - height), @(currentTy-height/4*3), @(currentTy -height/4*2), @(currentTy - height/4), @(currentTy)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [sender.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
    
}




@end

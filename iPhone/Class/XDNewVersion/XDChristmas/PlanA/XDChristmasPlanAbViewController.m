//
//  XDChristmasPlanAbViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import "XDChristmasPlanAbViewController.h"
#import "XDPlanControlClass.h"
#import "XDUpgradeViewController.h"
#import "XDChristmasShareSuccessdPlanAPopViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>

typedef void(^SucceessBlock)(BOOL success, NSString* text);

@import Firebase;
@interface XDChristmasPlanAbViewController ()<XDUpgradeViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *tryPremiumBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTopL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryPremiumH;
@property(nonatomic, strong)XDChristmasShareSuccessdPlanAPopViewController* popVc;

@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;

@end

@implementation XDChristmasPlanAbViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.enterDate = [NSDate date];
    if (IS_IPHONE_X) {
        self.bg.image = [UIImage imageNamed:@"christmas_di_b_x"];
        self.contentImgCenterY.constant = -250;
        self.titleTopL.constant = 180;
        self.titleH.constant = 30;
        self.cancelTopL.constant = 30;
    }else if (IS_IPHONE_5){
        self.bg.image = [UIImage imageNamed:@"christmas_di_b_se"];
    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"christmas_di_b_plus"];
        self.cancelTopL.constant = 20;

    }else{
        self.bg.image = [UIImage imageNamed:@"christmas_di_b_8"];
    }
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        self.titleLbl.text = @"Share to get 68% off a month to Premium.";
        self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_7day"];
        self.titleLbl.text = @"Gifts for Christmas!\nStart Your 7-Day Free Trial.";
         self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        self.titleLbl.text = @"Give a gift they’ll love.\nShare 68% off a month to friends.";
        self.tryPremiumH.constant = 0.01;
         self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        self.tryPremiumBtn.hidden = YES;
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
        self.titleLbl.text = @"Gifts for LIFETIME ACHIEVEMENT!\nShare to get the 50% off Hours keeper.";
         self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.99/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    }
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }
}

- (IBAction)tryPremiumBtnClick:(id)sender {
    
    XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
    adsVc.xxdDelegate = self;
    [self presentViewController:adsVc animated:YES completion:nil];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_main_tryPremium" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_main_tryPremium" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_main_tryPremium" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_main_tryPremium" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }
}

- (IBAction)shareBtnClick:(id)sender {
    NSString *textToShare = @"Gifts for Christmas! Enjoy your FREE trail for 7 days. Let the wisdom began！";
    UIImage *imageToShare = [UIImage imageNamed:@"christmas_di_plus"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pocket-expense-6/id424575621?mt=8"];
    NSArray *items = @[urlToShare,textToShare,imageToShare];
    
    [self mq_share:items target:self success:^(BOOL success, NSString *text) {
        if (success) {
            self.popVc = [[XDChristmasShareSuccessdPlanAPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessdPlanAPopViewController" bundle:nil];
            [self.view addSubview:self.popVc.view];
            self.popVc.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.popVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc show];
            
            
            if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
                [FIRAnalytics logEventWithName:@"christmas_A_b_1_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
                
                [FIRAnalytics logEventWithName:@"christmas_A_b_2_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
                
                [FIRAnalytics logEventWithName:@"christmas_A_b_3_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
                
                [FIRAnalytics logEventWithName:@"christmas_A_b_4_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }
        }
    }];
}

-(void)vcCancelClick{
    [self.popVc dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }
}

-(void)vcUseItClick{
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        
        XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
        adsVc.xxdDelegate = self;
        [self presentViewController:adsVc animated:YES completion:nil];
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_1_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        [self puchasedInfoInSetting:[NSDate date] productID:@"7_day_free_trial" originalProID:@"7_day_free_trial"];
        [self vcCancelClick];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.isPurchased = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_2_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_b_3_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        NSString *urlStr = @"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
    
        [FIRAnalytics logEventWithName:@"christmas_A_b_4_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        NSString *urlStr = @"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }
}


-(void)puchasedInfoInSetting:(NSDate*)startDate productID:(NSString*)productID originalProID:(NSString *)originalProID{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    
    // 修改订阅测试时间
#ifdef DEBUG
    comp.minute += 3;
#else
    comp.day += 7;
#endif
    NSDate* endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
    
    Setting* setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"] lastObject];
    setting.purchasedProductID = productID;
    setting.purchasedStartDate = startDate;
    setting.purchasedEndDate = endDate;
    setting.purchasedUpdateTime = [NSDate date];
    setting.otherBool17 = @NO;
    setting.purchasedIsSubscription = @YES;
    setting.uuid = [PFUser currentUser].objectId;
    setting.purchaseOriginalProductID = originalProID;
    
    [[XDDataManager shareManager] saveContext];
    
    [[ParseDBManager sharedManager] savingSetting];
}


#pragma mark - XDUpgradeViewDelegate
-(void)XDUpgradeViewDismiss{
//    [self vcCancelClick];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/** 分享 */
- (void)mq_share:(NSArray *)items target:(id)target success:(SucceessBlock)successBlock {
    if (items.count == 0 || target == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks];
    }else {
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
//        NSLog(@"activityType == %@\ncompleted == %d\nreturnedItems==%@",activityType,completed,returnedItems);
        if (completed) {
//            NSLog(@">>>>>success");
            if (successBlock) {
                successBlock(YES, [NSString stringWithFormat:@"%@",activityType]);
            }
        }else {
//            NSLog(@">>>>>faild -- %@",activityError);
            if (successBlock) {
                successBlock(NO, @"");
            }
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = target;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

@end

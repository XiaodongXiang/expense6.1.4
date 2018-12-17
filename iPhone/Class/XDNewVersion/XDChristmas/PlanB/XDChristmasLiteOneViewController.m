//
//  XDChristmasLiteOneViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDChristmasLiteOneViewController.h"
#import "XDPlanControlClass.h"
#import "XDChristmasShareSuccessPlanBPopViewController.h"
#import "XDUpgradeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "XDIpad_ADSViewController.h"
typedef void(^SucceessBlock)(BOOL success, NSString* text);
@import  Firebase;
@interface XDChristmasLiteOneViewController ()<XDUpgradeViewDelegate,XDIpad_ADSViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;
@property(nonatomic, strong)XDChristmasShareSuccessPlanBPopViewController* popVc;

@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;
@end

@implementation XDChristmasLiteOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.bg.image = [UIImage imageNamed:@"Bchristmas_x_pic_a"];
        self.contentCenterY.constant = -70;
        self.topL.constant = 30;
    }else if (IS_IPHONE_5){
        self.bg.image = [UIImage imageNamed:@"Bchristmas_se_pic_a"];
        self.contentCenterY.constant = -35;

    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8p_pic_a"];
        self.contentCenterY.constant = -55;
        self.textCenterY.constant = 170;
        self.topL.constant = 20;
    }else{
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8_pic_a"];
    }
    self.enterDate = [NSDate date];

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%-1"];
        }else if (IS_IPHONE_5){
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_se_68%"];
        }
        
        self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];

        [FIRAnalytics logEventWithName:@"christmas_a_B_1_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_7day"];
//
//        [FIRAnalytics logEventWithName:@"christmas_a_B_2_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_3_68%"];
//        if (IS_IPHONE_6PLUS) {
//            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%"];
//        }
//
//        [FIRAnalytics logEventWithName:@"christmas_a_B_3_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"Bchristmas_50%off"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_50%"];
        }else if (IS_IPHONE_5){
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_se_50%off"];
        }
        
        
        
        [FIRAnalytics logEventWithName:@"christmas_a_B_4_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        self.textLbl.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.99/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];

    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_a_B_1_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [FIRAnalytics logEventWithName:@"christmas_a_B_2_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        [FIRAnalytics logEventWithName:@"christmas_a_B_3_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_a_B_4_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
    }
}


- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtnClick:(id)sender {
    UIImage *imageToShare = [UIImage imageNamed:@"mail_gifts_68"];
    NSString *textToShare = @"Gifts for Christmas! Enjoy your 68% off on Pocket Expense. Let the wisdom began.";

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        imageToShare = [UIImage imageNamed:@"mail_gifts_68"];
        textToShare = @"Gifts for Christmas! Enjoy your 68% off on Pocket Expense. Let the wisdom began.";
    }else{
        imageToShare = [UIImage imageNamed:@"mail_gifts_68"];
        textToShare = @"Gifts for Christmas! Enjoy your 68% off on Pocket Expense. Let the wisdom began！";

    }
    
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pocket-expense-6/id424575621?mt=8"];
    NSArray *items = @[urlToShare,textToShare,imageToShare];
    
    [self mq_share:items target:self success:^(BOOL success, NSString *text) {
        if (success) {
            self.popVc = [[XDChristmasShareSuccessPlanBPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessPlanBPopViewController" bundle:nil];
            [self.view addSubview:self.popVc.view];
            self.popVc.view.frame  = CGRectMake(0, 0, ISPAD?375:SCREEN_WIDTH, ISPAD?667:SCREEN_HEIGHT);
            [self.popVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc show];
            
            if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
                
                [FIRAnalytics logEventWithName:@"christmas_a_B_1_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
//            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//
//                [FIRAnalytics logEventWithName:@"christmas_a_B_2_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
//
//            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//
//                [FIRAnalytics logEventWithName:@"christmas_a_B_3_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
//
            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
                
                [FIRAnalytics logEventWithName:@"christmas_a_B_4_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }
        }
    }];
    
}

-(void)vcCancelClick{
    [self.popVc dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_a_B_1_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [FIRAnalytics logEventWithName:@"christmas_a_B_2_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        [FIRAnalytics logEventWithName:@"christmas_a_B_3_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_a_B_4_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }
}

-(void)vcUseItClick{
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        if (ISPAD) {
            XDIpad_ADSViewController* adsDetailViewController = [[XDIpad_ADSViewController alloc]initWithNibName:@"XDIpad_ADSViewController" bundle:nil];
            //        adsDetailViewController.isComeFromSetting = NO;
            //        adsDetailViewController.pageNum = i;
            //        adsDetailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            adsDetailViewController.xxdDelegate = self;
            adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            adsDetailViewController.preferredContentSize = CGSizeMake(375, 667);
            adsDetailViewController.isChristmasEnter = YES;

            adsDetailViewController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;
            [self presentViewController:adsDetailViewController animated:YES completion:nil];
            
            
        }else
        {
            XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
            adsVc.xxdDelegate = self;
            adsVc.isChristmasEnter = YES;

            [self presentViewController:adsVc animated:YES completion:nil];
        }
        [FIRAnalytics logEventWithName:@"christmas_a_B_1_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        
//        [self puchasedInfoInSetting:[NSDate date] productID:@"7_day_free_trial" originalProID:@"7_day_free_trial"];
//        [self vcCancelClick];
//        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
//        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        appDelegate.isPurchased = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//        [FIRAnalytics logEventWithName:@"christmas_a_B_2_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        
//        [FIRAnalytics logEventWithName:@"christmas_a_B_3_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        NSString *urlStr = @"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8";
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_a_B_4_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id563155321?pt=12390800&ct=ChristmasActivity-PKEP-HRKP&mt=8";
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


/** 分享 */
- (void)mq_share:(NSArray *)items target:(id)target success:(SucceessBlock)successBlock {
    if (items.count == 0 || target == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        NSLog(@"activityType == %@\ncompleted == %d\nreturnedItems==%@",activityType,completed,returnedItems);
        if (completed) {
            NSLog(@">>>>>success");
            if (successBlock) {
                successBlock(YES, [NSString stringWithFormat:@"%@",activityType]);
            }
        }else {
            NSLog(@">>>>>faild -- %@",activityError);
            if (successBlock) {
                successBlock(NO, @"");
            }
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = target;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = self.shareBtn.frame;
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark - XDUpgradeViewDelegate
-(void)XDUpgradeViewDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ipadUpgradeViewDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  XDChristmasLitePlanAViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDChristmasLitePlanAViewController.h"
#import "XDPlanControlClass.h"
#import "XDChristmasShareSuccessdPlanAPopViewController.h"
#import "XDUpgradeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "XDIpad_ADSViewController.h"

@import  Firebase;
@interface XDChristmasLitePlanAViewController ()<XDUpgradeViewDelegate,XDIpad_ADSViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;
@property(nonatomic, strong)XDChristmasShareSuccessdPlanAPopViewController* popVc;

@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;

@end

@implementation XDChristmasLitePlanAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.bg.image = [UIImage imageNamed:@"christmas_di_x"];
        self.contentCenterY.constant = -250;
        self.textCenterY.constant = 30;
        self.topL.constant = 30;
    }else if (IS_IPHONE_5){
        self.bg.image = [UIImage imageNamed:@"christmas_di_se"];
        self.contentCenterY.constant = -165;

    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"christmas_di_plus"];
    }else{
        self.bg.image = [UIImage imageNamed:@"christmas_di_8"];
    }
    self.enterDate = [NSDate date];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        self.text1.text = @"Share to get 68% off a month to Premium.";
        self.text2.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        
        [FIRAnalytics logEventWithName:@"christmas_A_B_1_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        self.contentImgView.image = [UIImage imageNamed:@"christmas_7day"];
//        self.text1.text = @"Gifts for Christmas!\nStart Your 7-Day Free Trial.";
//        self.text2.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
//
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
//        self.text1.text = @"Give a gift they’ll love.\nShare 68% off a month to friends.";
//        self.text2.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.49/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
        self.text1.text = @"Share to get the 50% off Hours keeper.";
        self.text2.text = [NSString stringWithFormat:@"Limited time offer.\nStarts at $1.99/month after.\nEnds in %ld days.",(long)[[XDPlanControlClass shareControlClass] distanceEndTime]];
        [FIRAnalytics logEventWithName:@"christmas_A_B_4_main_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_B_1_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_B_4_main_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
    }
}


- (IBAction)shareBtnClick:(id)sender {
    
    UIImage *imageToShare = [UIImage imageNamed:@"share_expense_68"];
    NSString *textToShare = @"Gifts for Christmas! Enjoy your 68% off on Pocket Expense. Let the wisdom began.";

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        imageToShare = [UIImage imageNamed:@"share_expense_68"];
        textToShare = @"Gifts for Christmas! Enjoy your 68% off on Pocket Expense. Let the wisdom began.";

    }else{
        imageToShare = [UIImage imageNamed:@"share_expense_68"];
        textToShare = @"Gifts for Christmas! Enjoy your 50% Off on Hours Keeper. More than just a Hours Keeper you need.";
    }
    
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pocket-expense-6/id424575621?mt=8"];
    NSArray *items = @[urlToShare,textToShare,imageToShare];
    
    [self mq_share:items target:self success:^(BOOL success, NSString *text) {
        if (success) {
            self.popVc = [[XDChristmasShareSuccessdPlanAPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessdPlanAPopViewController" bundle:nil];
            [self.view addSubview:self.popVc.view];
            self.popVc.view.frame  = CGRectMake(0, 0, ISPAD?375:SCREEN_WIDTH, ISPAD?667:SCREEN_HEIGHT);
            [self.popVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc show];
            
            
            if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
                [FIRAnalytics logEventWithName:@"christmas_A_B_1_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
//            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//
//                [FIRAnalytics logEventWithName:@"christmas_A_B_2_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
//
//            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//
//
//                [FIRAnalytics logEventWithName:@"christmas_A_B_3_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
//
            }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
                
                [FIRAnalytics logEventWithName:@"christmas_A_B_4_main_share" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"UIActivityType":text}];
                
            }
        }
    }];
    
    
}


-(void)vcCancelClick{
    [self.popVc dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_B_1_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"christmas_A_B_4_shareSuccess_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
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
            
            adsDetailViewController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;
            [self presentViewController:adsDetailViewController animated:YES completion:nil];


        }else{

            XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
            adsVc.xxdDelegate = self;
            adsVc.isChristmasEnter = YES;
            [self presentViewController:adsVc animated:YES completion:nil];
            
        }
        
        [FIRAnalytics logEventWithName:@"christmas_A_B_1_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [self puchasedInfoInSetting:[NSDate date] productID:@"7_day_free_trial" originalProID:@"7_day_free_trial"];
//        [self vcCancelClick];
//        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
//        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        appDelegate.isPurchased = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
//
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        NSString *urlStr = @"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8";
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_B_4_shareSuccess_useIt" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
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

#pragma mark - XDUpgradeViewDelegate
-(void)XDUpgradeViewDismiss{
    [self vcCancelClick];
}

#pragma mark - XDIpad_ADSViewDelegate
-(void)ipadUpgradeViewDismiss{
    [self vcCancelClick];
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
//    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
//        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
//    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
//        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks];
//    }else {
//        activityVC.excludedActivityTypes = @[UIActivityTypeMessage];
//    }
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

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"christmas_A_B_1_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        
//        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//        
//        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        [FIRAnalytics logEventWithName:@"christmas_A_B_4_main_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

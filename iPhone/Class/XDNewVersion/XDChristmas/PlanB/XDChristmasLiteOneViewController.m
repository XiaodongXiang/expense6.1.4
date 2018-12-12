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

typedef void(^SucceessBlock)(BOOL success, NSString* text);

@interface XDChristmasLiteOneViewController ()<XDUpgradeViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;
@property(nonatomic, strong)XDChristmasShareSuccessPlanBPopViewController* popVc;

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
    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8p_pic_a"];
        self.contentCenterY.constant = -55;
        self.textCenterY.constant = 170;
        self.topL.constant = 20;
    }else{
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8_pic_a"];
    }
    

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%-1"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_7day"];
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_3_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"Bchristmas_50%off"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_50%"];
        }
    }
    
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtnClick:(id)sender {
    NSString *textToShare = @"Gifts for Christmas! Enjoy your FREE trail for 7 days. Let the wisdom began！";
    UIImage *imageToShare = [UIImage imageNamed:@"christmas_di_plus"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pocket-expense-6/id424575621?mt=8"];
    NSArray *items = @[urlToShare,textToShare,imageToShare];
    
    [self mq_share:items target:self success:^(BOOL success, NSString *text) {
        if (success) {
            self.popVc = [[XDChristmasShareSuccessPlanBPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessPlanBPopViewController" bundle:nil];
            [self.view addSubview:self.popVc.view];
            self.popVc.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.popVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popVc show];
        }
    }];
    
}

-(void)vcCancelClick{
    [self.popVc dismiss];
}

-(void)vcUseItClick{
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        
        XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
        adsVc.xxdDelegate = self;
        [self presentViewController:adsVc animated:YES completion:nil];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        
        [self puchasedInfoInSetting:[NSDate date] productID:@"7_day_free_trial" originalProID:@"7_day_free_trial"];
        [self vcCancelClick];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.isPurchased = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
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
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks];
    }else {
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        NSLog(@"activityType == %@\ncompleted == %d\nreturnedItems==%@",activityType,completed,returnedItems);
        if (completed) {
            NSLog(@">>>>>success");
            if (successBlock) {
                successBlock(YES, @"");
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
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark - XDUpgradeViewDelegate
-(void)XDUpgradeViewDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

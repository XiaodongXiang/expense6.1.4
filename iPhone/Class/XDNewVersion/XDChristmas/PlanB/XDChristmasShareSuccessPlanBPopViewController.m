//
//  XDChristmasShareSuccessPlanBPopViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/10.
//

#import "XDChristmasShareSuccessPlanBPopViewController.h"
#import "XDPlanControlClass.h"
#import <Parse/Parse.h>
@import Firebase;

@interface XDChristmasShareSuccessPlanBPopViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancenLT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useItTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;


@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;

@end

@implementation XDChristmasShareSuccessPlanBPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enterDate = [NSDate date];

    
    if (IS_IPHONE_X) {
        self.bgImgView.image = [UIImage imageNamed:@"pic_x"];
        self.cancenLT.constant = 30;
        self.contentCenterY.constant = -95;
        self.useItTopH.constant = 187;
    }else if (IS_IPHONE_5){
        self.bgImgView.image = [UIImage imageNamed:@"pic_se"];
    }else if (IS_IPHONE_6PLUS){
        self.contentCenterY.constant = -105;
        self.bgImgView.image = [UIImage imageNamed:@"pic_plus"];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"pic_8"];
    }
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        }
        
        if ([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana) {
            [FIRAnalytics logEventWithName:@"christmas_a_B_1_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }else{
            [FIRAnalytics logEventWithName:@"christmas_a_b_1_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_7day"];
//        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_normat_7day"] forState:UIControlStateNormal];
//        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_Selected_7day"] forState:UIControlStateHighlighted];
//
//        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
//            [FIRAnalytics logEventWithName:@"christmas_a_B_2_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//        }else{
//            [FIRAnalytics logEventWithName:@"christmas_a_b_2_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//        }
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
//
//        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
//            [FIRAnalytics logEventWithName:@"christmas_a_B_3_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//        }else{
//            [FIRAnalytics logEventWithName:@"christmas_a_b_3_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//
//        }

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];
        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_a_B_4_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }else{
            [FIRAnalytics logEventWithName:@"christmas_a_b_4_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        }
        
        if ([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana) {
            [FIRAnalytics logEventWithName:@"christmas_a_B_1_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
            
        }else{
            [FIRAnalytics logEventWithName:@"christmas_a_b_1_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
            
        }
        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_7day"];
//        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_normat_7day"] forState:UIControlStateNormal];
//        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_Selected_7day"] forState:UIControlStateHighlighted];
//        
//        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
//            [FIRAnalytics logEventWithName:@"christmas_a_B_2_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//        }else{
//            [FIRAnalytics logEventWithName:@"christmas_a_b_2_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//        }
//        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
//        
//        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
//            [FIRAnalytics logEventWithName:@"christmas_a_B_3_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//            
//        }else{
//            [FIRAnalytics logEventWithName:@"christmas_a_b_3_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//            
//        }
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];
        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_a_B_4_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
            
        }else{
            [FIRAnalytics logEventWithName:@"christmas_a_b_4_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

        }
    }
}

-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgImgView.alpha = 1;
        self.contentImgView.alpha = 1;
        self.useItBtn.alpha = 1;
    }];
}


-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgImgView.alpha = 0;
        self.contentImgView.alpha = 0;
        self.useItBtn.alpha = 0;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];

    }];
    
}


@end

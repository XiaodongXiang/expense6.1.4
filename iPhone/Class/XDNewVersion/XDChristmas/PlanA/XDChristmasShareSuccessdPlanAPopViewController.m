//
//  XDChristmasShareSuccessdPlanAPopViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/7.
//

#import "XDChristmasShareSuccessdPlanAPopViewController.h"
#import "XDPlanControlClass.h"
#import <Parse/Parse.h>
@import Firebase;
@interface XDChristmasShareSuccessdPlanAPopViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;

@end

@implementation XDChristmasShareSuccessdPlanAPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.useItBtn.alpha = 0;
    self.contentImgView.alpha = 0;
    self.backView.alpha = 0;
    self.enterDate = [NSDate date];
    if (IS_IPHONE_X) {
        self.cancelBtn.frame = CGRectMake(10, 30, 44, 44);
    }else if (IS_IPHONE_5){
        self.contentImgView.frame = CGRectMake(0, 130, 320, 150);
        self.useItBtn.centerX = 160;
        self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 370);
        self.useItBtn.y = 428;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        
        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_A_B_1_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }else{
            [FIRAnalytics logEventWithName:@"christmas_A_b_1_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }

//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        self.contentImgView.image = [UIImage imageNamed:@"christmas_7day"];
//
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
//        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download"] forState:UIControlStateNormal];
//        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download_press"] forState:UIControlStateHighlighted];
//
//
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download"] forState:UIControlStateNormal];
        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download_press"] forState:UIControlStateHighlighted];

        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_A_B_4_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }else{
            [FIRAnalytics logEventWithName:@"christmas_A_b_4_shareSuccess_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        }
    }
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        
        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_A_B_1_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

            
        }else{
            [FIRAnalytics logEventWithName:@"christmas_A_b_1_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

            
        }
        
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_2_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
//
//
//    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
//        [FIRAnalytics logEventWithName:@"christmas_A_B_3_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        
        if([XDPlanControlClass shareControlClass].planSubType == ChristmasSubPlana){
            [FIRAnalytics logEventWithName:@"christmas_A_B_4_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

            
        }else{
            [FIRAnalytics logEventWithName:@"christmas_A_b_4_shareSuccess_pageTime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

        }
        
    }
}

-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85f];
        self.bgView.y = 0;
        self.useItBtn.alpha = 1;
        self.contentImgView.alpha = 1;
        self.backView.alpha = 1;
    }];
}


-(void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        self.bgView.y = SCREEN_HEIGHT;
        self.useItBtn.alpha = 0;
        self.contentImgView.alpha = 0;
        self.backView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
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

//
//  XDOurAppsViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/6.
//
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "XDPlanControlClass.h"

#import "XDOurAppsViewController.h"
@import  Firebase;
@interface XDOurAppsViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *forthCell;
@property (weak, nonatomic) IBOutlet UIView *secondBackView;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdBackView;
@property (weak, nonatomic) IBOutlet UIView *fourthBackView;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *firstBackView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;


@property(nonatomic, strong)NSDate* enterDate;
@property(nonatomic, strong)NSDate* leaveDate;

@end

@implementation XDOurAppsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.enterDate = [NSDate date];

   
    [self.topView.layer addSublayer:[UIColor setGradualChangingColor:self.topView fromColor:RGBColor(129, 177, 255) toColor:RGBColor(82, 147, 252)]];

    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(5, 20, 44, 44);
    if (IS_IPHONE_X) {
        cancelBtn.y = 40;
        self.topViewH.constant = 180;
    }

    
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cancelBtn.frame), 200, 30)];
    lable.font = [UIFont boldSystemFontOfSize:24];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"OUR APPS";
    [self.topView addSubview:lable];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    if (ISPAD) {
        cancelBtn.hidden = YES;
    }
    
    self.firstBackView.layer.cornerRadius = self.thirdBackView.layer.cornerRadius = self.fourthBackView.layer.cornerRadius = self.secondBackView.layer.cornerRadius = 10;
    self.firstBackView.layer.shadowOffset = self.thirdBackView.layer.shadowOffset = self.fourthBackView.layer.shadowOffset = self.secondBackView.layer.shadowOffset = CGSizeMake(0, 4);
    self.firstBackView.layer.shadowColor = self.thirdBackView.layer.shadowColor = self.fourthBackView.layer.shadowColor = self.secondBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.firstBackView.layer.shadowOpacity = self.thirdBackView.layer.shadowOpacity = self.fourthBackView.layer.shadowOpacity = self.secondBackView.layer.shadowOpacity = 0.06;//阴影透明度，默认0
    self.firstBackView.layer.shadowRadius = self.thirdBackView.layer.shadowRadius = self.fourthBackView.layer.shadowRadius = self.secondBackView.layer.shadowRadius = 18;//阴影半径，默认3
    self.firstBackView.layer.masksToBounds = self.thirdBackView.layer.masksToBounds = self.fourthBackView.layer.masksToBounds = self.secondBackView.layer.masksToBounds = NO;
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"db-b43ep996igwezzh://"]]){
        [self.firstBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.firstBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
//
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"PCheckBook://"]]){
        [self.secondBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.secondBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
//
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"scannnernow://"]]){
        [self.thirdBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.thirdBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };
//
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"faxnow://"]]){
        [self.fourthBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }else{
        [self.fourthBtn setImage:[UIImage imageNamed:@"get"] forState:UIControlStateNormal];
    };

    [FIRAnalytics logEventWithName:@"ours_app_enter" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.leaveDate = [NSDate date];
    
    [FIRAnalytics logEventWithName:@"ours_app_pagetime" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser,@"pageTime":[[XDPlanControlClass shareControlClass] pageTimeWithStartDate:self.enterDate endDate:self.leaveDate]}];

    [FIRAnalytics logEventWithName:@"ours_app_leave" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

    
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.firstCell;
    }else if(indexPath.row == 1){
        return self.secondCell;
    }else if (indexPath.row == 2){
        return self.thirdCell;
    }else{
        return self.forthCell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 120;
    }
    return 100;
}

- (IBAction)getOrOopenClick:(id)sender {
    UIButton * btn = sender;

    if (btn.tag == 1) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"db-b43ep996igwezzh://"]]){

//            NSString *urlStr = @"HoursKeeper://";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            NSString *urlStr = @"db-b43ep996igwezzh://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

            [FIRAnalytics logEventWithName:@"ours_app_open_hoursKeeper" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }else{
            NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id563155321?pt=12390800&ct=OurApps-PKEP-HRKP&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_download_hoursKeeper" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        };

    }else if (btn.tag == 2){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"PCheckBook://"]]){
            
            NSString *urlStr = @"PCheckBook://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_open_checkBook" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
        }else{
            NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id484000695?pt=118715235&ct=OurApps-PKEP-CKBK&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_download_checkBook" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }
    }else if (btn.tag == 3){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"scannnernow://"]]){
            
            NSString *urlStr = @"scannnernow://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_open_sannernow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
            
        }else{
            NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id1193953564?pt=291138&ct=OurApps-PKEP-SCNN&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_download_sannernow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }
    }else if (btn.tag == 4){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"faxnow://"]]){

            NSString *urlStr = @"faxnow://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_open_faxnow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }else{
            NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id1197930396?pt=291138&ct=OurApps-PKEP-FXNW&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            [FIRAnalytics logEventWithName:@"ours_app_download_faxnow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        }
    }
}

@end

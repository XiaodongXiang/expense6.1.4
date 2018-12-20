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


@end

@implementation XDChristmasShareSuccessPlanBPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];
      
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
    

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];

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

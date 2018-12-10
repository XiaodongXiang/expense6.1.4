//
//  XDChristmasPlanAbViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import "XDChristmasPlanAbViewController.h"
#import "XDPlanControlClass.h"

@interface XDChristmasPlanAbViewController ()
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

@end

@implementation XDChristmasPlanAbViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
        self.titleLbl.text = @"Congratulations to get the 7-day free trial.\nShare to get 68% off a month to Premium.";
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_7day"];
        self.titleLbl.text = @"Gifts for Christmas!\nStart Your 7-Day Free Trial.";
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        self.titleLbl.text = @"Give a gift they’ll love.\nShare 68% off a month to friends.";
        self.tryPremiumH.constant = 0.01;
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
        self.titleLbl.text = @"Gifts for LIFETIME ACHIEVEMENT!\nShare to get the 50% off Hours keeper.";
    }
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

//
//  XDChristmasShareSuccessPlanBPopViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/10.
//

#import "XDChristmasShareSuccessPlanBPopViewController.h"
#import "XDPlanControlClass.h"

@interface XDChristmasShareSuccessPlanBPopViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UIButton *useItBtn;
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
        self.cancenLT.constant = 25;
    }else if (IS_IPHONE_5){
        self.bgImgView.image = [UIImage imageNamed:@"pic_se"];
    }else if (IS_IPHONE_6PLUS){
        self.bgImgView.image = [UIImage imageNamed:@"pic_plus"];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"pic_8"];
    }
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_7day"];
        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_normat_7day"] forState:UIControlStateNormal];
        [self.useItBtn setImage:[UIImage imageNamed:@"bChristmas_share_btn_Selected_7day"] forState:UIControlStateHighlighted];

    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_68%off"];
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];
        
    }
}
- (IBAction)useItClick:(id)sender {
    
}



@end

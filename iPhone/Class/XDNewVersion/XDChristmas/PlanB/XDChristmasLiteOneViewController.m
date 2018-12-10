//
//  XDChristmasLiteOneViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDChristmasLiteOneViewController.h"
#import "XDPlanControlClass.h"

@interface XDChristmasLiteOneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;

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
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_1_68%_7"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_1_68%"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_7day"];
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_3_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"Bchristmas_50%off"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_50%"];
        }
    }
    
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

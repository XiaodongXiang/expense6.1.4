//
//  XDChristmasPlanBbViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import "XDChristmasPlanBbViewController.h"
#import "XDPlanControlClass.h"

@interface XDChristmasPlanBbViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTopL;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopL;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@end

@implementation XDChristmasPlanBbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        self.bg.image = [UIImage imageNamed:@"Bchristmas_x_pic_b"];
        self.contentCenterY.constant = 235;
        self.cancelTopL.constant = 30;
    }else if (IS_IPHONE_5){
        self.bg.image = [UIImage imageNamed:@"Bchristmas_se_pic_b"];
    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8p_pic_b"];
        self.contentCenterY.constant = 210;
        self.cancelTopL.constant = 20;
        self.textTopL.constant = 100;
    }else{
        self.bg.image = [UIImage imageNamed:@"Bchristmas_8_pic_b"];
    }
        
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_68%"];
        if (IS_IPHONE_6PLUS) {
            self.contentImgView.image = [UIImage imageNamed:@"bChristmas_plus_68%-1"];
        }
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotHasReceive7Days){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_7day"];
      
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"bChristmas_3_68%"];
       
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryNotLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"Bchristmas_50%off"];
        
    }
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:  nil];
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

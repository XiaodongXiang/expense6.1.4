//
//  XDChristmasLitePlanAViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDChristmasLitePlanAViewController.h"

@interface XDChristmasLitePlanAViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCenterY;

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
    }else if (IS_IPHONE_6PLUS){
        self.bg.image = [UIImage imageNamed:@"christmas_di_plus"];
    }else{
        self.bg.image = [UIImage imageNamed:@"christmas_di_8"];
    }
    
}
- (IBAction)shareBtnClick:(id)sender {
    
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

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
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation XDChristmasShareSuccessdPlanAPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.useItBtn.alpha = 0;
    self.contentImgView.alpha = 0;
    self.backView.alpha = 0;

    if (IS_IPHONE_X) {
        self.cancelBtn.frame = CGRectMake(10, 30, 44, 44);
    }else if (IS_IPHONE_5){
        self.contentImgView.frame = CGRectMake(0, 130, 320, 150);
        self.useItBtn.centerX = 160;
        self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 370);
        self.useItBtn.y = 428;
    }else if (IS_IPHONE_6PLUS){
        self.contentImgView.centerX = SCREEN_WIDTH/2;
        self.useItBtn.centerX = SCREEN_WIDTH/2;
        self.backView.centerX = SCREEN_WIDTH/2;
        
    }
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];

    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        self.contentImgView.image = [UIImage imageNamed:@"christmas_68%off"];
        
        
    }else if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        self.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download"] forState:UIControlStateNormal];
        [self.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download_press"] forState:UIControlStateHighlighted];

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

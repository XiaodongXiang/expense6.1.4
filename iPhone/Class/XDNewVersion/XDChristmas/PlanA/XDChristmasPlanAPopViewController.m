//
//  XDChristmasPlanAPopViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import "XDChristmasPlanAPopViewController.h"
#import <Parse/Parse.h>
#import "XDPlanControlClass.h"


@import Firebase;

@interface XDChristmasPlanAPopViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation XDChristmasPlanAPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backView.y = SCREEN_HEIGHT;
    self.backView.centerX = SCREEN_WIDTH/2;
    
}


-(void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        self.backView.y = 0;
    }];
}


-(void)dismiss{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

        self.backView.y = SCREEN_HEIGHT;

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

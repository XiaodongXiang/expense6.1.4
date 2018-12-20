//
//  XDChristmasPlanBViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/5.
//

#import "XDChristmasPlanBPopViewController.h"

#import <Parse/Parse.h>
#import "XDPlanControlClass.h"

@import Firebase;

@interface XDChristmasPlanBPopViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation XDChristmasPlanBPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
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


@end

//
//  XDNavigationViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/18.
//

#import "XDNavigationViewController.h"
#import "XDPresentTransition.h"
@interface XDNavigationViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation XDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [XDPresentTransition transitionWithTransitionType:XDPresentOTransitionTypePresent];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [XDPresentTransition transitionWithTransitionType:XDPresentOTransitionTypeDismiss];
}

@end

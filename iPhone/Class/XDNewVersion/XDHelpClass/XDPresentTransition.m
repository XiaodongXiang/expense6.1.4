//
//  XDPresentTransition.m
//  aaaa
//
//  Created by 晓东 on 2018/4/18.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDPresentTransition.h"

@implementation XDPresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

+(instancetype)transitionWithTransitionType:(XDPresentOTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

-(instancetype)initWithTransitionType:(XDPresentOTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case XDPresentOTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case XDPresentOTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}
//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];

    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    toVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
 
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
            //首先我们让vc2向上移动
//            toVC.view.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            //然后让截图视图缩小一点即可
            toVC.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            //转场失败后的处理
            if ([transitionContext transitionWasCancelled]) {
                //失败后，我们要把vc1显示出来
                fromVC.view.hidden = NO;
                //然后移除截图视图，因为下次触发present会重新截图
                [fromVC.view removeFromSuperview];
            }
            
            //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

        }];
}
//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意这个关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //参照present动画的逻辑，present成功后，containerView的最后一个子视图就是截图视图，我们将其取出准备动画

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了标记失败
            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            [fromVC.view removeFromSuperview];
        }
    }];
    
   
}



@end

//
//  UIViewController+Animation.m
//  MSCal
//
//  Created by wangdong on 10/24/13.
//  Copyright (c) 2013 dongdong.wang. All rights reserved.
//

#import "UIViewController+Animation.h"
//#import "AppDelegate.h"

extern CGFloat headerHeight_WD;

#define BottomHeight 44
@implementation UIViewController (Animation)

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void) zoomoutViewController:(UIViewController *)viewController fromRect:(CGRect) fromRect
{
    /*
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.userInteractionEnabled = NO;
    UIView *superView = app.window;
    UIImage *oldImage = [self imageWithView:self.navigationController.view];
    
    //老页面
    CGFloat offHeight = 64;
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, offHeight);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    bottomImgView.image = oldImage;
    bottomImgView.clipsToBounds = YES;
    bottomImgView.contentMode = UIViewContentModeBottom;
    bottomImgView.alpha = 1.0;
    bottomImgView.frame = CGRectMake(0, offHeight, oldImage.size.width, oldImage.size.height - offHeight);
    
    [self.navigationController pushViewController:viewController animated:NO];
    
    //新页面
    UIImage *newImage = [self imageWithView:viewController.navigationController.view];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, 0, newImage.size.width, offHeight);
    
    UIImageView *_bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _bottomImgView.image = newImage;
    _bottomImgView.clipsToBounds = YES;
    _bottomImgView.contentMode = UIViewContentModeBottom;
    _bottomImgView.alpha = 1.0;
    _bottomImgView.frame = CGRectMake(0, offHeight, newImage.size.width, newImage.size.height - offHeight);
    
    _bottomImgView.transform = CGAffineTransformMakeScale(fromRect.size.width/_bottomImgView.width*1.0f, fromRect.size.height/_bottomImgView.height*1.0f);
    _bottomImgView.frame = CGRectMake(fromRect.origin.x, fromRect.origin.y, _bottomImgView.width, _bottomImgView.height);
    
    [superView addSubview:_topImgView];
    [superView addSubview:topImgView];
    [superView addSubview:bottomImgView];
    [superView addSubview:_bottomImgView];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         topImgView.alpha = 0.0;
                         
                         _bottomImgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         _bottomImgView.frame = CGRectMake(0, offHeight, newImage.size.width, newImage.size.height - offHeight);
                     }
                     completion:^(BOOL finished){
                         [topImgView removeFromSuperview];
                         [bottomImgView removeFromSuperview];
                         [_topImgView removeFromSuperview];
                         [_bottomImgView removeFromSuperview];
                         app.window.userInteractionEnabled = YES;
                     }];
     */
}


-(void) zoominViewController:(UIViewController *)viewController toRect:(CGRect) toRect
{
    /*
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.userInteractionEnabled = NO;
    UIView *superView = app.window;
    UIImage *oldImage = [self imageWithView:self.navigationController.view];
    
    //老页面
    CGFloat offHeight = 64;
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, offHeight);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    bottomImgView.image = oldImage;
    bottomImgView.clipsToBounds = YES;
    bottomImgView.contentMode = UIViewContentModeBottomLeft;
    bottomImgView.alpha = 1.0;
    bottomImgView.frame = CGRectMake(0, offHeight, oldImage.size.width, oldImage.size.height - offHeight);
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [superView addSubview:topImgView];
    [superView addSubview:bottomImgView];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         topImgView.alpha = 0.0;
                         bottomImgView.alpha = 0.0;
                         bottomImgView.transform = CGAffineTransformMakeScale(toRect.size.width/bottomImgView.width*1.0f, toRect.size.height/bottomImgView.height*1.0f);
                         bottomImgView.frame = CGRectMake(toRect.origin.x, toRect.origin.y, bottomImgView.width, bottomImgView.height);
                     }
                     completion:^(BOOL finished){
                         [topImgView removeFromSuperview];
                         [bottomImgView removeFromSuperview];;
                         app.window.userInteractionEnabled = YES;
                     }];
     */
}


-(void) presentViewController:(UIViewController *)viewController fromRect:(CGRect) fromRect
{
    /*
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.userInteractionEnabled = NO;
    UIImage *oldImage = [PlannerClass getImageFromView:self.view size:self.view.frame.size];
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, fromRect.origin.y + fromRect.size.height);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    bottomImgView.image = oldImage;
    bottomImgView.clipsToBounds = YES;
    bottomImgView.contentMode = UIViewContentModeBottom;
    bottomImgView.alpha = 1.0;
    bottomImgView.frame = CGRectMake(0, topImgView.height, oldImage.size.width, oldImage.size.height - topImgView.height);
    
    [self.navigationController pushViewController:viewController animated:NO];
    UIView *superView = viewController.view;
    
    //新页面
    UIImage *newImage = [PlannerClass getImageFromView:viewController.view size:viewController.view.frame.size];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, topImgView.top + topImgView.height,
                                   newImage.size.width,
                                   self.navigationController.view.height - 64 - BottomHeight);
    
    UIImageView *_bottomImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _bottomImgView.image = newImage;
    _bottomImgView.clipsToBounds = YES;
    _bottomImgView.contentMode = UIViewContentModeBottom;
    _bottomImgView.alpha = 1.0;
    _bottomImgView.frame = CGRectMake(0, self.navigationController.view.height - 64 - BottomHeight,
                                      newImage.size.width, BottomHeight);
    
    for (UIView *subView in viewController.view.subviews) {
        subView.hidden = YES;
    }
    [superView addSubview:_topImgView];
    [superView addSubview:topImgView];
    [superView addSubview:bottomImgView];
    [superView addSubview:_bottomImgView];
    
    [UIView animateWithDuration:.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         bottomImgView.alpha = 0.0;
                         _topImgView.top = 0;
                         topImgView.top = -topImgView.height;
                         bottomImgView.top = oldImage.size.height;
                     }
                     completion:^(BOOL finished){
                         [_topImgView removeFromSuperview];
                         [topImgView removeFromSuperview];
                         [bottomImgView removeFromSuperview];
                         [_bottomImgView removeFromSuperview];
                         app.window.userInteractionEnabled = YES;
                         for (UIView *subView in viewController.view.subviews) {
                             subView.hidden = NO;
                         }
                     }];
     */
}
-(void) dismissViewController:(UIViewController *)viewController toRect:(CGRect) toRect
{
    /*
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.userInteractionEnabled = NO;
    UIImage *oldImage = [PlannerClass getImageFromView:self.view size:self.view.frame.size];
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    topImgView.image = oldImage;
    topImgView.clipsToBounds = YES;
    topImgView.alpha = 1.0;
    topImgView.contentMode = UIViewContentModeTop;
    topImgView.frame = CGRectMake(0, 0, oldImage.size.width, oldImage.size.height);
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIView *superView = viewController.view;
    
    //新页面
    UIImage *newImage = [PlannerClass getImageFromView:viewController.view size:viewController.view.frame.size];
    UIImageView *_topImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _topImgView.image = newImage;
    _topImgView.clipsToBounds = YES;
    _topImgView.contentMode = UIViewContentModeTop;
    _topImgView.alpha = 1.0;
    _topImgView.frame = CGRectMake(0, -(toRect.origin.y + toRect.size.height),
                                   newImage.size.width,
                                   toRect.origin.y + toRect.size.height);
    
    UIImageView *_middleImgView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _middleImgView.image = newImage;
    _middleImgView.clipsToBounds = YES;
    _middleImgView.contentMode = UIViewContentModeBottom;
    _middleImgView.alpha = 1.0;
    _middleImgView.frame = CGRectMake(0, newImage.size.height,
                                      newImage.size.width, newImage.size.height - _topImgView.height);
    
    [superView addSubview:topImgView];
    [superView addSubview:_topImgView];
    [superView addSubview:_middleImgView];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _topImgView.top = 0;
                         _middleImgView.top = _topImgView.height;
                     }
                     completion:^(BOOL finished){
                         [_topImgView removeFromSuperview];
                         [topImgView removeFromSuperview];
                         [_middleImgView removeFromSuperview];
                         app.window.userInteractionEnabled = YES;
                     }];
     */
}
@end

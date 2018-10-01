//
//  UIViewController+Animation.h
//  MSCal
//
//  Created by wangdong on 10/24/13.
//  Copyright (c) 2013 dongdong.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Animation)


-(void) zoomoutViewController:(UIViewController *)viewController fromRect:(CGRect) fromRect;
-(void) zoominViewController:(UIViewController *)viewController toRect:(CGRect) toRect;

-(void) presentViewController:(UIViewController *)viewController fromRect:(CGRect) fromRect;
-(void) dismissViewController:(UIViewController *)viewController toRect:(CGRect) toRect;
@end

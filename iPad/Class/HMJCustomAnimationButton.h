//
//  HMJCustomAnimationButton.h
//  ButtonAnimationSample
//
//  Created by humingjing on 15/7/13.
//  Copyright (c) 2015年 humingjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMJCustomAnimationButton : UIView

@property (strong, nonatomic) UIImageView *signInRotateLastImage;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)bgColor;
-(void)setSelfFrame:(CGRect)frame;

-(void)begainAnimation;
-(void)endAnimation;

@end

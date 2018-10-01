//
//  XDPresentTransition.h
//  aaaa
//
//  Created by 晓东 on 2018/4/18.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XDPresentOTransitionType) {
    XDPresentOTransitionTypePresent = 0,//管理present动画
    XDPresentOTransitionTypeDismiss//管理dismiss动画
};


@interface XDPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XDPresentOTransitionType)type;

- (instancetype)initWithTransitionType:(XDPresentOTransitionType)type;

@property(nonatomic, assign)XDPresentOTransitionType type;


@end

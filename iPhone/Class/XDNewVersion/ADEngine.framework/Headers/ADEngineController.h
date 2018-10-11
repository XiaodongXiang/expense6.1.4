//
//  ADEngineController.h
//  ADEngine
//
//  Created by DaMo on 2018/8/23.
//  Copyright © 2018年 DaMo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ADEngineController;

@protocol ADEngineControllerBannerDelegate <NSObject>

@optional
/**
 * banner是否加载成功 方法可用来显示广告时改变界面UI
 * result yes成功 no失败
 * ad 广告自身
 */
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad;

@end

typedef enum {
	
	ADEngineControllerADTypeBanner = 0,
	ADEngineControllerADTypeInterstitial
}ADEngineControllerADType;

@interface ADEngineController : NSObject

- (ADEngineController *)initLoadADWithAdPint:(NSString *)adPoint;
- (ADEngineController *)initLoadADWithAdPint:(NSString *)adPoint delegate:(id<ADEngineControllerBannerDelegate>)delegate;

/**
 * 进应用立刻弹广告用这个方法 只能初始化结束使用
 *
 * 只适用于插页广告
 * target UIViewController
 */
- (void)nowShowInterstitialAdWithTarget:(id)target;

/**
 * 一般的预加载 用这个方法显示广告
 *
 * target
 * 插页广告 UIViewController
 */
- (void)showInterstitialAdWithTarget:(UIViewController *)target;

/**
 *
 * target
 * 横幅广告 UIView
 */
- (void)showBannerAdWithTarget:(UIView *)target rootViewcontroller:(UIViewController *)controller;

@end

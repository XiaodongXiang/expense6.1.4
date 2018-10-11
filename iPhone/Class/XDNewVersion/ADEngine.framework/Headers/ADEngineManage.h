//
//  ADEngineManage
//  ADEngine
//
//  Created by DaMo on 2018/8/20.
//  Copyright © 2018年 DaMo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^queryADConfigureCallBackBlock)(NSMutableArray *resultArray);

@interface ADEngineManage : NSObject

+ (ADEngineManage *)adEngineManage;
- (void)downloadConfigByAppName:(NSString *)appName;

/**
 * unlockAllFunctionsHideAd 此方法可以屏蔽所有广告 比如内购后
 * lockFunctionsShowAd 此方法可以恢复广告被网络控制器控制 比如订阅到期 
 */
- (void)unlockAllFunctionsHideAd;
- (void)lockFunctionsShowAd;

@end

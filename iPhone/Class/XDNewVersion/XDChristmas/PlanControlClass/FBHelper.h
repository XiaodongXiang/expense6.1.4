//
//  FBHelper.h
//  SingleView
//
//  Created by Joe Jia on 2018/12/4.
//  Copyright © 2018 Joe Jia. All rights reserved.
//
//  本类完成Firebase各服务的配置。只需在application:didFinishLaunchingWithOptions:方法中调用[FBHelper instance]即可。
//
//  目前功能：陆续添加中
//  In App Messaging
//      无需额外代码
//  Cloud Messaging
//      自行处理接受消息时间
//  Remote Config
//      通过valueByConfigureName:获取响应变量的值
//  A/B Testing
//      借助Remote Config实现，同样以valueByConfigureName:获取变量值

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 在Pod文件中添加
// pod 'Firebase'
// pod 'Firebase/InAppMessagingDisplay'
// pod 'Firebase/Core'
// pod 'Firebase/RemoteConfig'
// pod 'Firebase/Messaging'
// pod 'FIrebase/DynamicLinks'

NS_ASSUME_NONNULL_BEGIN
@import Firebase;
@import UserNotifications;

@interface FBHelper : NSObject

@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;

+(FBHelper*)instance;
+(NSString*)valueByConfigureName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END

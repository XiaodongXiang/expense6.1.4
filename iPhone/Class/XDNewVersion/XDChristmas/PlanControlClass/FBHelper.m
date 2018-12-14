//
//  FBHelper.m
//  SingleView
//
//  Created by Joe Jia on 2018/12/4.
//  Copyright © 2018 Joe Jia. All rights reserved.
//

#import "FBHelper.h"
#import "PokcetExpenseAppDelegate.h"

@interface FBHelper (private)

FOUNDATION_EXPORT void FBHelperLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@end

@interface PokcetExpenseAppDelegate (FBHelperExtension) <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end

#pragma mark -
@implementation FBHelper

+(FBHelper *)instance
{
    static FBHelper* helper;
    if (helper == nil)
    {
        helper = [[FBHelper alloc] init];
    }
    
    return helper;
}

-(id)init
{
    self = [super init];
    
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    NSTimeInterval interval = 1800; // 半个小时有效期
    
#ifdef DEBUG
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
    self.remoteConfig.configSettings = remoteConfigSettings;
    interval = 0; // 开发模式实时有效
#endif
    
    [self.remoteConfig fetchWithExpirationDuration:interval completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            FBHelperLog(@"Config fetched!");
            [self.remoteConfig activateFetched];
        } else {
            FBHelperLog(@"Config not fetched");
            FBHelperLog(@"Error %@", error.localizedDescription);
        }
    }];
    
    UIApplication* application = [UIApplication sharedApplication];
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)application.delegate;
    
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = appDelegate;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    [FIRMessaging messaging].delegate = appDelegate;
    
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
        if (error != nil) {
            FBHelperLog(@"Error fetching remote instance ID: %@", error);
        } else {
            FBHelperLog(@"Remote instance ID token: %@", result.token);
        }
    }];
    
    return self;
}

#pragma mark - FIRMessaging Delegate
//- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
//    NSLog(@"FCM registration token: %@", fcmToken);
//    // Notify about received token.
//    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//     @"FCMToken" object:nil userInfo:dataDict];
//}

#pragma mark - Custom Method
+(NSString *)valueByConfigureName:(NSString *)parameterName
{
    FBHelper* helper = [FBHelper instance];
    NSString* configString = helper.remoteConfig[parameterName].stringValue;
    FBHelperLog(@"Config value for %@ is: %@", parameterName, configString);
    return configString;
}

#pragma mark -  Misc
void FBHelperLog(NSString *pFormat, ...)
{
#ifdef DEBUG
    if (pFormat == nil) {
        printf("Format nil\n");
        return;
    }
    
    va_list argList;
    va_start(argList, pFormat);
    
    NSString* s = [[NSString alloc] initWithFormat:pFormat arguments:argList];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/d/yyyy HH:mm:ss.SSS"];
    NSString* strTime = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    printf("\n%s FBHelper \t\t%s\n", [strTime UTF8String], [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//    [s release];
    va_end(argList);
#endif
    
}

@end

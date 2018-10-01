//
//  PlannerClass.h
//  MSCal
//
//  Created by wangdong on 3/25/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpClass.h"
@class Tasks;
@class Settings;


@interface PlannerClass : NSObject

+(BOOL) freeVersion;

//AppDelegate
//设置所有NavigationBar style
//+ (void) initAppearance;
//获得应用的setting
//+(Settings *) setMainAppSettings;
//读取数据库 判断task的Priority 是否为老用户
//+(BOOL) isOldUserFetchFromDataBase;
//刷新要显示的calendar数组
//+(void) refreshShowCalsArray;
//当用户授权应用访问 calendar时  刷新页面
//+(void) refreshMainViewWhenCalendarGranted;

//判断是否为全新用户  用于识别task中的优先级别
//+(BOOL) isNewUserAndUseNewPriority;

//显示和隐藏同步状态
//+(void) showAlertView;
+(void) dismissAlertView;

//刷新Badge 当应用程序返回到主界面
//+(void) refreshBadgeNumberWhenApplicationDidEnterBackground;

//切图
+(UIImage *)getImageFromView:(UIView *)view size:(CGSize)size;
//获取月份 全英文
+(NSString *)getMonthStrAtIndex:(NSInteger) index;

//获取task的优先级 以及对应优先级的颜色
//+(NSString *) getPriorityFromTask:(Tasks *)task;
//+(UIColor * ) getPriorityColorFromTask:(Tasks *)task;

//freeVersion
//+ (NSInteger)getVersionFreeCountByType:(VersionFreeCountType)type;
//+ (void)versionFreeCountAddByType:(VersionFreeCountType)type;
//+ (void)showLimitAlertViewWhenTaskOrNoteMax;

//画圆
+ (UIImage *)imageWithColor:(HSBColor *)color size:(CGSize )size;

//appdelegate
//+(void)applicationWillEnterForeground;
//+(void)applicationDidBecomeActive;

//+(void) refreshFrames:(UILabel *)titleLab valueLab:(UILabel *)valueLab inCell:(UIView *)cell hasAccessory:(BOOL)hasAccessory;
//+(void) logFlurryEventWhenAppFirstEnter;
@end


@interface NSDate (WangAdded)
/*获得某日期的年月日*/
-(NSDateComponents *)dateComponentsYMDcalType:(NSCalendarType)calendarType;
-(BOOL) isToday;
@end


#pragma mark - ---------------------------UIDevice---------------------------
@interface UIDevice (wangdong)
+ (BOOL)isLandscape;
@end

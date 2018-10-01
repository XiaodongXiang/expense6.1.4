//
//  PlannerClass.m
//  MSCal
//
//  Created by wangdong on 3/25/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import "PlannerClass.h"
#import <CoreText/CoreText.h>
//#import "WDEventHelp.h"
//#import "WDAppirater.h"
//#import "Flurry.h"

@implementation PlannerClass
+(BOOL) freeVersion
{
#ifdef Version_Free
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:FullFunctionKey];
    if (object && [object boolValue]) {
        return NO;
    }
    return YES;
#else
    return NO;
#endif
}

#pragma mark - AppDelegate
//1.设置所有NavigationBar style
//+ (void) initAppearance
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    app.dataInit_iPhone.shadowImage_Col = [UIImage imageWithColor:[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0] size:CGSizeMake(ScreenWidth, 0.5)];
//    app.dataInit_iPhone.shadowImage_nil = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 0.5)];
//    
//    UIImage *barimg = [[UIImage imageNamed:@"nav_bar_320_64.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    UIImage *backImage = [UIImage imageWithColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0] size:CGSizeMake(ScreenWidth, 64)];
//    [[UINavigationBar appearanceWhenContainedIn: [MSNavigationController class], nil] setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearanceWhenContainedIn: [HLNavigationController class], nil] setBackgroundImage:barimg forBarMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setShadowImage:app.dataInit_iPhone.shadowImage_Col];
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    shadow.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
//    [[UINavigationBar appearanceWhenContainedIn: [HLNavigationController class], nil] setTitleTextAttributes: @{
//                                                                                                                NSForegroundColorAttributeName:[UIColor whiteColor] ,
//                                                                                                                NSShadowAttributeName: shadow,
//                                                                                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
//                                                                                                                }];
//    
//    [[UINavigationBar appearanceWhenContainedIn: [MSNavigationController class], nil] setTitleTextAttributes: @{
//                                                                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0],
//                                                                                                                NSShadowAttributeName: shadow,
//                                                                                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
//                                                                                                                }];
//    
//    
//    [[UINavigationBar appearanceWhenContainedIn: [HLNavigationController class], nil] setTintColor:[UIColor whiteColor]];
//    NSDictionary *attributes_nor = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    titleColor, NSForegroundColorAttributeName,
//                                    [UIFont fontWithName:@"HelveticaNeue" size:17], NSFontAttributeName ,nil];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [HLNavigationController class], nil] setTitleTextAttributes: attributes_nor
//                                                                                                                            forState: UIControlStateNormal];
//    
//    NSDictionary *attributes_dis = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    titleHighlightedColor, NSForegroundColorAttributeName,
//                                    [UIFont fontWithName:@"HelveticaNeue" size:17], NSFontAttributeName,nil];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [HLNavigationController class], nil] setTitleTextAttributes: attributes_dis
//                                                                                                                            forState: UIControlStateDisabled];
//    
//    
//    [[UINavigationBar appearanceWhenContainedIn: [MSNavigationController class], nil] setTintColor:[UIColor colorWithRed:12.0/255.0 green:95.0/255.0 blue:254.0/255.0 alpha:1.0]];
//    NSDictionary *attributes_nor1 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor colorWithRed:12.0/255.0 green:95.0/255.0 blue:254.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                     [UIFont fontWithName:@"HelveticaNeue" size:17], NSFontAttributeName ,nil];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [MSNavigationController class], nil] setTitleTextAttributes: attributes_nor1
//                                                                                                                            forState: UIControlStateNormal];
//    
//    NSDictionary *attributes_dis1 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     titleHighlightedColor, NSForegroundColorAttributeName,
//                                     [UIFont fontWithName:@"HelveticaNeue" size:17], NSFontAttributeName,nil];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [MSNavigationController class], nil] setTitleTextAttributes: attributes_dis1
//                                                                                                                            forState: UIControlStateDisabled];
//    
//    
//    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]}
//                                                   forState:UIControlStateNormal];
//    
//}


#pragma mark - 获得应用的setting
//+(Settings *) setMainAppSettings
//{
//    
//    
//    //新增属性
//    id object = [[NSUserDefaults standardUserDefaults] objectForKey:ShowTasksInCalendar];
//    if (!object) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ShowTasksInCalendar];
//    }
//
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    if(!app.dataInit_iPhone.setting)
//	{
//		NSArray *settingArr = [[DataManager shareInstance] getObjectsByName:DBNameSettings];
//		EKEventStore *eventStore = [CustomEventStore eventStore];
//		
//		if([settingArr count] > 0)
//		{
//			app.dataInit_iPhone.setting = [settingArr objectAtIndex:0];
//			
//			if(![eventStore calendarWithIdentifier:app.dataInit_iPhone.setting.eDefaultCalendarID])
//			{
//				app.dataInit_iPhone.setting.eDefaultCalendarID = [eventStore defaultCalendarForNewEvents].calendarIdentifier;
//			}
//			if([app.dataInit_iPhone.setting.gTimeZone length] == 0)
//			{
//				app.dataInit_iPhone.setting.gTimeZone = [NSTimeZone defaultTimeZone].name;
//			}
//			if(!app.dataInit_iPhone.setting.tOrderBy)
//			{
//				app.dataInit_iPhone.setting.tOrderBy = [NSNumber numberWithInt:SettingTaskOrderByPriority];
//			}
//            if (!app.dataInit_iPhone.setting.tNewPriority)
//            {
//                app.dataInit_iPhone.setting.tNewPriority = [NSNumber numberWithInteger:WDTaskPriorityNone];
//            }
//		}
//		else
//		{
//			app.dataInit_iPhone.setting = (Settings *)[[DataManager shareInstance] insertObjectByName:DBNameSettings];
//            
//			app.dataInit_iPhone.setting.gTimeZone = [[NSTimeZone defaultTimeZone] name];
//			app.dataInit_iPhone.setting.gFirstDay = [NSNumber numberWithInt:FirstDayOfWeekSunday];
//			app.dataInit_iPhone.setting.gTimePickerMinuteInterval = [NSNumber numberWithInt:TimePickerMinuteInterval5Minutes];
//			
//			app.dataInit_iPhone.setting.tShowCompleted = [NSNumber numberWithBool:YES];
//			app.dataInit_iPhone.setting.tAppBadge = [NSNumber numberWithInt:SettingTaskBadgeBoth];
//			app.dataInit_iPhone.setting.tTabBadge = [NSNumber numberWithInt:SettingTaskBadgeBoth];
//			app.dataInit_iPhone.setting.tStatus = [NSNumber numberWithInt:SettingTaskStatusNormal];
//			app.dataInit_iPhone.setting.tPriority = @"B1";
//            app.dataInit_iPhone.setting.tNewPriority = [NSNumber numberWithInteger:WDTaskPriorityNone];
//            if (!app.dataInit_iPhone.isOldUser) {
//                app.dataInit_iPhone.setting.tUsePriorityType = [NSNumber numberWithBool:YES];
//            }
//			app.dataInit_iPhone.setting.tOrderBy = [NSNumber numberWithInt:SettingTaskOrderByPriority];
//			app.dataInit_iPhone.setting.tNextDay = [NSNumber numberWithInt:TaskNextDayTwo];
//			
//			app.dataInit_iPhone.setting.eDuration = [NSNumber numberWithInt:EventDuration1Hour];
//            if (EventStoreStatusAuthorized(EKEntityTypeEvent)) {
//                app.dataInit_iPhone.setting.eDefaultCalendarID = [eventStore defaultCalendarForNewEvents].calendarIdentifier;
//            }
//			app.dataInit_iPhone.setting.eHourStart = [NSNumber numberWithInt:0];
//			app.dataInit_iPhone.setting.eHourEnd = [NSNumber numberWithInt:24];
//			
//			app.dataInit_iPhone.setting.nTaskOn = [NSNumber numberWithBool:YES];
//			app.dataInit_iPhone.setting.nTaskTime = [[NSDate date] getDateByYear:-1 month:-1 day:-1 hour:17 minute:0 second:0 getDatetype:GetDateTypeModification calendarType:NSCalendarTypeGMT];
//			app.dataInit_iPhone.setting.nEventOn = [NSNumber numberWithBool:YES];
//			app.dataInit_iPhone.setting.nEventTime = [NSNumber numberWithInt:EventNotificationAtTimeOfEvent];
//			
//			app.dataInit_iPhone.setting.isDateConversion = [NSNumber numberWithBool:YES];
//		}
//        
//        
//		for(EKCalendar *ca in [eventStore calendarsForEntityType:EKEntityTypeEvent])
//		{
//			NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ca.calendarIdentifier, @"calendarID", nil];
//			NSArray *array = [[DataManager shareInstance] getObjectByTemplateName:@"FetchShowCalendarByID" parameter:dic];
//			
//			if([array count] == 0)
//			{
//				ShowCalendar *sc = (ShowCalendar *)[[DataManager shareInstance] insertObjectByName:DBNameShowCalendar];
//				sc.calendarID = ca.calendarIdentifier;
//				sc.isShow = [NSNumber numberWithBool:YES];
//			}
//		}
//		[[DataManager shareInstance] save];
//	}
//    return app.dataInit_iPhone.setting;
//}

#pragma mark - 判断是否为老用户
//+(BOOL) isOldUserFetchFromDataBase
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL oldUser = [userDefaults boolForKey:PLANNER_OLDUSER];
//    if (!oldUser) {
//        NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys: [NSNull null], @"PriorityNil",  nil];
//        NSArray *tempArray = [[DataManager shareInstance] getObjectByTemplateName:@"FetchTaskByUseNewPriority" parameter:paraDic];
//        oldUser = tempArray.count > 0;
//        if (oldUser) {
//            [userDefaults setBool:YES forKey:PLANNER_OLDUSER];
//            [userDefaults synchronize];
//        }
//    }
//    return oldUser;
//}

#pragma mark - 根据新老用户 分配task的Priority使用哪种形式 老用户可选择 B1 B2 或者 ！ ！！ ！！！ 新用户只能使用 ！

//+(BOOL) isNewUserAndUseNewPriority
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    BOOL useNewPriority = NO;
//    if (app.dataInit_iPhone.isOldUser) {
//        BOOL _useNewPriority = [app.dataInit_iPhone.setting.tUsePriorityType integerValue] == SettingTaskPriorityTypeGTH;
//        if (_useNewPriority) {
//            useNewPriority = YES;
//        }
//    }
//    else
//    {
//        useNewPriority = YES;
//    }
//    return useNewPriority;
//}

#pragma mark - 刷新要显示的calendar数组
//+(void) refreshShowCalsArray
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    if (app.dataInit_iPhone.showCalArray) {
//        app.dataInit_iPhone.showCalArray = nil;
//    }
//    NSArray *calArray = [[DataManager shareInstance] getObjectsByName:DBNameShowCalendar];
//    NSArray *allCalArray = [[WDEventHelp shareInstance] getLocalCalendars];
//    EKEventStore *eventStore = [CustomEventStore eventStore];
//    
//    NSMutableArray *showArray = [NSMutableArray array];
//    for(ShowCalendar* selCal in calArray)
//    {
//        EKCalendar *locaCal = [eventStore calendarWithIdentifier:selCal.calendarID];
//        if([allCalArray containsObject:locaCal] && locaCal && [selCal.isShow boolValue])
//        {
//            [showArray addObject:locaCal];
//        }
//    }
//    app.dataInit_iPhone.showCalArray = showArray;
//}


#pragma mark - 当用户授权应用访问 calendar时  刷新页面
//+(void) refreshMainViewWhenCalendarGranted
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    app.dataInit_iPhone.setting = nil;
//    [PlannerClass setMainAppSettings];
//    [PlannerClass refreshShowCalsArray];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddOrEditEvent object:nil];
//}
#pragma mark - 显示和隐藏同步状态
//+(void) showAlertView
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIView *alertView = [app.window viewWithTag:9527];
//    if (!alertView)
//    {
//        alertView = [[UIView alloc] initWithFrame:[app.window bounds]];
//        alertView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
//        alertView.tag = 9527;
//        
//        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
//        tempView.layer.cornerRadius = 8.f;
//        tempView.backgroundColor = [UIColor blackColor];
//        tempView.center = app.window.center;
//        [alertView addSubview:tempView];
//        tempView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        
//        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [actView startAnimating];
//        [tempView addSubview:actView];
//        actView.frame  = CGRectMake(0, 10, tempView.width, tempView.height);
//        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, tempView.width, 24)];
//        lbl.backgroundColor = [UIColor clearColor];
//        lbl.textColor = [UIColor whiteColor];
//        lbl.text = @"Syncing";
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
//        [tempView addSubview:lbl];
//    }
//    alertView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [app.window addSubview:alertView];
//}


+(void) dismissAlertView
{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIView *alertView = [app.window viewWithTag:9527];
//    if (alertView) {
//        [alertView removeFromSuperview];
//    }
}


#pragma mark - 刷新Badge 当应用程序返回到主界面
//+(void) refreshBadgeNumberWhenApplicationDidEnterBackground
//{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    switch ([app.dataInit_iPhone.setting.tAppBadge intValue])
//	{
//		case SettingTaskBadgeNone:
//			[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//			break;
//		case SettingTaskBadgeOverdueCount:
//		{
//			NSDate *endDate = [[[NSDate date] conversionDate:NSCalendarTypeLocal typeNew:NSCalendarTypeGMT] getStartTimeInDay:NSCalendarTypeGMT];
//			endDate = [endDate getDateByYear:0 month:0 day:0 hour:0 minute:0 second:-1 getDatetype:GetDateTypeAddSubtract calendarType:NSCalendarTypeGMT];
//			NSDictionary *paraDicDate = [NSDictionary dictionaryWithObjectsAndKeys:endDate, @"endDate", [NSNull null], @"isDeleteNil", nil];
//			[UIApplication sharedApplication].applicationIconBadgeNumber = [[[DataManager shareInstance] getObjectByTemplateName:@"FetchTaskByDateRange3" parameter:paraDicDate] count];
//		}
//			break;
//		case SettingTaskBadgeDueSoonCount:
//		{
//			NSDate *startDate = [[[NSDate date] conversionDate:NSCalendarTypeLocal typeNew:NSCalendarTypeGMT] getStartTimeInDay:NSCalendarTypeGMT];
//			NSDate *endDate = [startDate getEndTimeInDay:NSCalendarTypeGMT];
//			endDate = [endDate getDateByYear:0 month:0 day:[app.dataInit_iPhone.setting.tNextDay intValue]+1 hour:0 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:NSCalendarTypeGMT];
//			NSDictionary *paraDicDate = [NSDictionary dictionaryWithObjectsAndKeys:startDate, @"startDate", endDate, @"endDate", [NSNull null], @"isDeleteNil", nil];
//			[UIApplication sharedApplication].applicationIconBadgeNumber = [[[DataManager shareInstance] getObjectByTemplateName:@"FetchTaskByDateRange2" parameter:paraDicDate] count];
//		}
//			break;
//		case SettingTaskBadgeBoth:
//		{
//			NSDate *startDate = [[[NSDate date] conversionDate:NSCalendarTypeLocal typeNew:NSCalendarTypeGMT] getStartTimeInDay:NSCalendarTypeGMT];
//			NSDate *endDate = [startDate getEndTimeInDay:NSCalendarTypeGMT];
//			endDate = [endDate getDateByYear:0 month:0 day:[app.dataInit_iPhone.setting.tNextDay intValue]+1 hour:0 minute:0 second:0 getDatetype:GetDateTypeAddSubtract calendarType:NSCalendarTypeGMT];
//			NSDictionary *paraDicDate = [NSDictionary dictionaryWithObjectsAndKeys:endDate, @"endDate", [NSNull null], @"isDeleteNil", nil];
//			[UIApplication sharedApplication].applicationIconBadgeNumber = [[[DataManager shareInstance] getObjectByTemplateName:@"FetchTaskByDateRange3" parameter:paraDicDate] count];
//		}
//			break;
//		default:
//			break;
//	}
//    
//    {
//		[[UIApplication sharedApplication] cancelAllLocalNotifications];
//		
//		if([app.dataInit_iPhone.setting.nTaskOn boolValue])
//		{
//			NSDate *nowDate = [NSDate date];
//			
//			NSDate *startDate = [[[NSDate date] conversionDate:NSCalendarTypeLocal typeNew:NSCalendarTypeGMT] getStartTimeInDay:NSCalendarTypeGMT];
//			NSDictionary *paraDicDate = [NSDictionary dictionaryWithObjectsAndKeys:startDate, @"startDate", [NSNull null], @"isDeleteNil", nil];
//			NSMutableArray *taskArr = [[NSMutableArray alloc] initWithArray:[[DataManager shareInstance] getObjectByTemplateName:@"FetchTaskByDateRange4" parameter:paraDicDate]];
//			[HelpClass sortObjects:taskArr soryNames:[NSArray arrayWithObject:@"tpDueDate"] ascendings:[NSArray arrayWithObject:[NSNumber numberWithInt:YES]]];
//			
//			for(int i = 0; i < 64; i++)
//			{
//				if(i >= [taskArr count])
//					break;
//				
//				Tasks *task = [taskArr objectAtIndex:i];
//				
//				NSInteger year = [task.tpDueDate getDateInfoType:DateInfoTypeYear calendarType:NSCalendarTypeGMT];
//				NSInteger month = [task.tpDueDate getDateInfoType:DateInfoTypeMonth calendarType:NSCalendarTypeGMT];
//				NSInteger day = [task.tpDueDate getDateInfoType:DateInfoTypeDay calendarType:NSCalendarTypeGMT];
//				NSInteger hour = [task.tpAlertTime getDateInfoType:DateInfoTypeHour calendarType:NSCalendarTypeGMT];
//				NSInteger minute = [task.tpAlertTime getDateInfoType:DateInfoTypeMinute calendarType:NSCalendarTypeGMT];
//				
//				NSDate *alertDate = [[NSDate date] getDateByYear:year month:month day:day hour:hour minute:minute second:0 getDatetype:GetDateTypeModification calendarType:NSCalendarTypeLocal];
//				if([alertDate timeIntervalSince1970] < [nowDate timeIntervalSince1970])
//				{
//					[taskArr removeObject:task];
//					i--;
//					continue;
//				}
//				UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//				localNotification.timeZone = [NSTimeZone defaultTimeZone];
//				localNotification.repeatInterval = NSDayCalendarUnit;
//				localNotification.fireDate = alertDate;
//				localNotification.alertBody = task.tpTitle;
//				localNotification.alertAction = NSLocalizedString(@"View", nil);
//				localNotification.soundName = UILocalNotificationDefaultSoundName;
//				[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//			}
//		}
//	}
//}

#pragma mark - 切图
+(UIImage *)getImageFromView:(UIView *)view size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0.0, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark - 获取月份 全英文
+(NSString *)getMonthStrAtIndex:(NSInteger) index
{
    NSArray *array = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    return [array objectAtIndex:index];
}

#pragma mark - taskCell  Priority

//+(NSString *) getPriorityFromTask:(Tasks *)task
//{
//    BOOL useNewPriority = [PlannerClass isNewUserAndUseNewPriority];
//    
//    NSString *priorityStr = nil;
//    if (useNewPriority) {
//        NSInteger priority = [task.tpNewPriority integerValue];
//        switch (priority) {
//            case WDTaskPriorityNone:
//            {
//                priorityStr = @"";
//            }
//                break;
//            case WDTaskPriorityOne:
//            {
//                priorityStr = @"!";
//            }
//                break;
//            case WDTaskPriorityTwo:
//            {
//                priorityStr = @"!!";
//            }
//                break;
//            case WDTaskPriorityThree:
//            {
//                priorityStr = @"!!!";
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    else
//    {
//        priorityStr = task.tpPriority;
//    }
//    return priorityStr;
//}

//+(UIColor * ) getPriorityColorFromTask:(Tasks *)task
//{
//    BOOL useNewPriority = [PlannerClass isNewUserAndUseNewPriority];
//    UIColor  *pColor = [UIColor darkGrayColor];
//    if (useNewPriority) {
//        NSInteger priority = [task.tpNewPriority integerValue];
//        switch (priority) {
//            case WDTaskPriorityNone:
//            {
//                pColor = [UIColor clearColor];
//            }
//                break;
//            case WDTaskPriorityOne:
//            {
//                pColor = [UIColor darkGrayColor];
//            }
//                break;
//            case WDTaskPriorityTwo:
//            {
//                pColor = [UIColor colorWithRed:203/225.0 green:133/255.0 blue:0/255.0 alpha:1];
//            }
//                break;
//            case WDTaskPriorityThree:
//            {
//                pColor = [UIColor colorWithRed:198/225.0 green:73/255.0 blue:69/255.0 alpha:1];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    return pColor;
//}

#pragma mark -
+ (UIImage *)imageWithColor:(HSBColor *)color size:(CGSize )size
{
    CGColorRef fillColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.8].CGColor;
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextFillEllipseInRect(context, CGRectMake(1, 1, size.width-2, size.height-2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - freeVersion 免费版 显示note task 添加

//+ (NSInteger)getVersionFreeCountByType:(VersionFreeCountType)type
//{
//	NSString *key = [[NSDate date] formatterStyle:@"yyyyMMdd" styleType:DateFormatterTypeCustom calendarType:NSCalendarTypeLocal];
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	
//	NSString *versionFreeFlag = @"";
//	switch (type)
//	{
//		case VersionFreeCountTypeTask:
//			versionFreeFlag = VersionFreeTaskCountFlag;
//			break;
//		case VersionFreeCountTypeNote:
//			versionFreeFlag = VersionFreeNoteCountFlag;
//			break;
//		default:
//			break;
//	}
//	NSMutableDictionary *dic = [[userDefaults valueForKey:versionFreeFlag] mutableCopy];
//	if(!dic)
//	{
//		dic = [NSMutableDictionary dictionary];
//	}
//	NSNumber *count = [dic objectForKey:key];
//	if(!count)
//	{
//		count = [NSNumber numberWithInt:0];
//		[dic setObject:count forKey:key];
//	}
//	[userDefaults setValue:dic forKey:versionFreeFlag];
//	[userDefaults synchronize];
//	
//	return [count integerValue];
//}


//+ (void)versionFreeCountAddByType:(VersionFreeCountType)type
//{
//	NSString *key = [[NSDate date] formatterStyle:@"yyyyMMdd" styleType:DateFormatterTypeCustom calendarType:NSCalendarTypeLocal];
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	
//	NSString *versionFreeFlag = @"";
//	switch (type)
//	{
//		case VersionFreeCountTypeTask:
//			versionFreeFlag = VersionFreeTaskCountFlag;
//			break;
//		case VersionFreeCountTypeNote:
//			versionFreeFlag = VersionFreeNoteCountFlag;
//			break;
//		default:
//			break;
//	}
//	NSMutableDictionary *dic = [[userDefaults valueForKey:versionFreeFlag] mutableCopy];
//	
//	NSNumber *count = [dic objectForKey:key];
//	count = [NSNumber numberWithInt:[count intValue] + 1];
//	[dic setObject:count forKey:key];
//	
//	[userDefaults setValue:dic forKey:versionFreeFlag];
//	[userDefaults synchronize];
//}

+ (void)showLimitAlertViewWhenTaskOrNoteMax
{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert_note_free_title", nil)
//                                                        message:NSLocalizedString(@"Alert_note_free_message", nil)
//                                                       delegate:app
//                                              cancelButtonTitle:NSLocalizedString(@"Alert_cancel_button", nil)
//                                              otherButtonTitles:NSLocalizedString(@"Alert_note_free_button2", nil), nil];
//    alertView.tag = 999;
//    [alertView show];
}

#pragma mark - appdelegate
//+(void)applicationWillEnterForeground
//{
//    [WDAppirater appLaunched];
//	
//    for(EKCalendar *ca in [[CustomEventStore eventStore] calendarsForEntityType:EKEntityTypeEvent])
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ca.calendarIdentifier, @"calendarID", nil];
//        NSArray *array = [[DataManager shareInstance] getObjectByTemplateName:@"FetchShowCalendarByID" parameter:dic];
//        
//        if([array count] == 0)
//        {
//            ShowCalendar *sc = (ShowCalendar *)[[DataManager shareInstance] insertObjectByName:DBNameShowCalendar];
//            sc.calendarID = ca.calendarIdentifier;
//            sc.isShow = [NSNumber numberWithBool:YES];
//        }
//    }
//    [[DataManager shareInstance] save];
//    [PlannerClass refreshShowCalsArray];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddOrEditEvent object:nil];
//}

//+(void)applicationDidBecomeActive
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"planner.zip"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
//    }
//    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app.dataInit_iPhone.monthCal2ViewController reloadTableView];
//    [app.mainViewController requestStart];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReloadTasksView object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReloadNotesView object:nil];
//}


#pragma mark - tableView

//+(void) refreshFrames:(UILabel *)titleLab valueLab:(UILabel *)valueLab inCell:(UIView *)cell hasAccessory:(BOOL)hasAccessory
//{
//    [titleLab sizeToFit];
//    [valueLab sizeToFit];
////    titleLab.backgroundColor = [UIColor redColor];
////    valueLab.backgroundColor = [UIColor yellowColor];
//    CGFloat width = 0;
//    if (hasAccessory) {
//        width = ScreenWidth - titleLab.left - 30;
//    }
//    else
//    {
//        width = ScreenWidth - titleLab.left - 15;
//    }
//    if (titleLab.width + valueLab.width > width) {
//        if (titleLab.width > width/2.0f && valueLab.width > width/2.0f) {
//            titleLab.width = width/2.f;
//            valueLab.width = width/2.f;
//            valueLab.left = titleLab.left + titleLab.width;
//        }
//        else if (titleLab.width > width/2.f)
//        {
//            valueLab.left = ScreenWidth - 15 - (hasAccessory?15:0) - valueLab.width;
//            titleLab.width = valueLab.left - titleLab.left;
//        }
//        else if (valueLab.width > width/2.f)
//        {
//            valueLab.left = titleLab.left + titleLab.width;
//            valueLab.width = ScreenWidth - 15 - (hasAccessory?15:0) - valueLab.left;
//        }
//    }
//    else
//    {
//        valueLab.left = ScreenWidth - 15 - (hasAccessory?15:0) - valueLab.width;
//    }
//}

//+(void) logFlurryEventWhenAppFirstEnter
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSNumber *flurry_1 = [userDefaults objectForKey:Flurry_1];
//    if (!flurry_1) {
//        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:Flurry_1];
//        [userDefaults synchronize];
//        
//        BOOL showTask = [userDefaults boolForKey:ShowTasksInCalendar];
//        if (!showTask) {
//            [Flurry logEvent:FlurryCalendarHideTask_P];
//        }
//        BOOL showWeekNum = [userDefaults boolForKey:ShowWeekNumber];
//        if (!showWeekNum) {
//            [Flurry logEvent:FlurryCalendarHideWeekNum_P];
//        }
//        
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        switch ([app.dataInit_iPhone.setting.tOrderBy integerValue]) {
//            case SettingTaskOrderByDueDate:
//            {
//                [Flurry logEvent:FlurryTaskSortDate_P];
//            }
//                break;
//            case SettingTaskOrderByPriority:
//            {
//                [Flurry logEvent:FlurryTaskSortPriority_P];
//            }
//                break;
//            case SettingTaskOrderByName:
//            {
//                [Flurry logEvent:FlurryTaskSortAlphabet_P];
//            }
//                break;
//            default:
//                break;
//        }
//        
//        id object = [userDefaults objectForKey:UserDefaultsNoteShowType];
//        NoteShowType type = NoteShowTypeList;
//        if (object) {
//            type = [object integerValue] == 0?NoteShowTypeList:NoteShowTypeCard;
//        }
//        if (type == NoteShowTypeList) {
//            [Flurry logEvent:FlurryNoteList_P];
//        }
//        else
//        {
//            [Flurry logEvent:FlurryNoteCard_P];
//        }
//    }
//    
//}
@end



@implementation UINavigationItem (barButton)

//-(void)setLeftBarButtonItem:(UIBarButtonItem *)item
//{
//    if (item) {
//        CGFloat offButton = [item.customView isKindOfClass:[UIButton class]]?-8:0;
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        flexible.width = offButton;
//        self.leftBarButtonItems = @[flexible, item];
//    }
//    else{
//        self.leftBarButtonItems = @[];
//    }
//}
//
//-(void)setRightBarButtonItem:(UIBarButtonItem *)item
//{
//    
//    if (item) {
//        CGFloat offButton = [item.customView isKindOfClass:[UIButton class]]?-8:0;
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        flexible.width = offButton;
//        self.rightBarButtonItems = @[flexible, item];
//    }
//    else
//        self.rightBarButtonItems = @[];
//}

@end


@implementation UIView (notduodian)

-(BOOL)isExclusiveTouch
{
	return YES;
}

@end

@implementation NSDate (WangAdded)
-(NSDateComponents *)dateComponentsYMDcalType:(NSCalendarType)calendarType
{
    NSCalendar *calendar = nil;
	switch (calendarType)
	{
		case NSCalendarTypeLocal:
			calendar = [NSCalendar localCalendar];
			break;
		case NSCalendarTypeTimezone:
			calendar = [NSCalendar timezoneCalendar];
			break;
		case NSCalendarTypeGMT:
			calendar = [NSCalendar GMTCalendar];
			break;
		default:
			calendar = [NSCalendar currentCalendar];
			break;
	}
    return [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

-(BOOL) isToday
{
    NSDateComponents* parts0 = [self dateComponentsYMDcalType:NSCalendarTypeTimezone];
    NSDateComponents* parts1 = [[[NSDate date] getStartTimeInDay:NSCalendarTypeTimezone] dateComponentsYMDcalType:NSCalendarTypeTimezone];
    return parts0.year == parts1.year && parts0.month == parts1.month &&parts0.day == parts1.day;
}

@end

@implementation UIDevice (wangdong)
+(BOOL)isLandscape
{
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
@end


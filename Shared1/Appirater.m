/*
 This file is part of Appirater.
 Copyright (c) 2010, Arash Payan
 All rights reserved.
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
/*
 * Appirater.m
 * appirater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2010 Arash Payan. All rights reserved.
 */

#import "Appirater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


NSString *const kAppiraterLaunchDate = @"kAppiraterLaunchDate";
NSString *const kAppiraterLaunchCount = @"kAppiraterLaunchCount";
NSString *const kAppiraterCurrentVersion = @"kAppiraterCurrentVersion";
NSString *const kAppiraterRatedCurrentVersion = @"kAppiraterRatedCurrentVersion";
NSString *const kAppiraterDeclinedToRate = @"kAppiraterDeclinedToRate";

//NSString *templateReviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";

NSString* templateReviewURL = @"https://itunes.apple.com/cn/app/pocket-expense-personal-finance/id424575621?action=write-review";


@interface Appirater (hidden)
- (BOOL)connectedToNetwork;
@end

@implementation Appirater (hidden)

- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

@end


@implementation Appirater


+ (void)appLaunched {
	Appirater *appirater = [[Appirater alloc] init];
	[NSThread detachNewThreadSelector:@selector(_appLaunched) toTarget:appirater withObject:nil];
}


- (void)_appLaunched{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    //如果是 debug版本，立马就弹出来
	if (APPIRATER_DEBUG)
	{
		[self performSelectorOnMainThread:@selector(showPrompt) withObject:nil waitUntilDone:NO];
		
		return;
	}
	
	BOOL willShowPrompt = NO;
	
	// get the app's version 获得当前编译的app的info.plist文件中的版本号
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //获取当前设备上保存的版本号
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
    
    //如果设备上没有版本号，就说明，这个版本是最新的
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
    //如果两个版本号相同
	if ([trackingVersion isEqualToString:version])
	{
		// 获取从第一次登陆，到现在的时间
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kAppiraterLaunchDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kAppiraterLaunchDate];
		}
		
        //获取初次下载登陆与 现在的时间
		NSTimeInterval secondsSinceLaunch = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
		//double secondsUntilPrompt = 60 * 60 * 24 * DAYS_UNTIL_PROMPT;
		
		//获取laucn的次数
		long launchCount = [userDefaults integerForKey:kAppiraterLaunchCount];
        
        //如果不是第一次登陆的日期不是今日，就将 launch time +1
		if(timeInterval !=secondsSinceLaunch)
            launchCount++;
        
        //保存登陆的次数
		[userDefaults setInteger:launchCount forKey:kAppiraterLaunchCount];
        
        
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Launch count: %ld", launchCount);
		
		// have they previously declined to rate this version of the app?
		BOOL declinedToRate = [userDefaults boolForKey:kAppiraterDeclinedToRate];
		
		// have they already rated the app?是否曾经评论过
		BOOL ratedApp = [userDefaults boolForKey:kAppiraterRatedCurrentVersion];
        
        //如果登陆超过五次，就弹出评论框
        if (
			launchCount > LAUNCHES_UNTIL_PROMPT &&
			!declinedToRate &&
			!ratedApp)
            
		{
			if ([self connectedToNetwork]) // check if they can reach the app store
			{
				willShowPrompt = YES;
				[self performSelectorOnMainThread:@selector(showPrompt) withObject:nil waitUntilDone:NO];
			}
		}
	}
	else
	{
        
        if (ISPAD) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"What's New in %@",version] message:[NSString stringWithFormat:@"Pocket Expense %@ redesign user interface. Support more powerful charts, custom account styles, and touch ID.\n\nIf you like Pocket Expense, we will be very happy if you rate or review Pocket Expense on the app store.",version] delegate:self cancelButtonTitle:nil otherButtonTitles:@"No, Thanks", @"Rate", nil];
            alertView.tag = 101;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alertView show];
            });
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alertView;
            
            
            [userDefaults setObject:version forKey:kAppiraterCurrentVersion];
            [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterLaunchDate];
            [userDefaults setInteger:1 forKey:kAppiraterLaunchCount];
            [userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];//设置已经评论过了这个app
            [userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"What's New in %@",version] message:[NSString stringWithFormat:@"Pocket Expense %@ has been completely redesigned, with more clarity, better structure, improved workflow and delightful interaction.\n\nWe hope you enjoy the all-new apps – If you have a moment to leave a review in the App Store we would really appreciate it.",version] delegate:self cancelButtonTitle:nil otherButtonTitles:@"No, Thanks", @"Rate", nil];
            alertView.tag = 101;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alertView show];
            });
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alertView;
            
            
            [userDefaults setObject:version forKey:kAppiraterCurrentVersion];
            [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterLaunchDate];
            [userDefaults setInteger:1 forKey:kAppiraterLaunchCount];
            [userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];//设置已经评论过了这个app
            [userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
        }
	}
	
	
//	[userDefaults synchronize];
	if (!willShowPrompt)
        //		[self autorelease];
        
        [pool release];

    
}


-(void)incrementAndRate:(NSNumber*)_canPromptForRating
{
    
}
- (void)showPrompt {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPIRATER_MESSAGE_TITLE
														message:APPIRATER_MESSAGE
													   delegate:self
											  cancelButtonTitle:APPIRATER_CANCEL_BUTTON
											  otherButtonTitles:APPIRATER_RATE_BUTTON, APPIRATER_RATE_LATER, nil];
    alertView.tag = 100;
	[alertView show];
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPhone.appAlertView = alertView;
    return;
}


//- (void)showPrompt {
//	PokcetExpenseAppDelegate * appDelegate =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//	{
//		AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
//		if([appDelegate.settings.passcode length] > 0 &&appDelegate.iPasscodeEnterViewController !=nil)
//		{
//			[appDelegate1.mainViewController.view  insertSubview:appDelegate1.iPad_appRaterView.view belowSubview:appDelegate.iPasscodeEnterViewController.view];
//
//		}
//		else 
//        {
//			[appDelegate1.mainViewController.view addSubview:appDelegate1.iPad_appRaterView.view ]; 
//		}
//
// 		appDelegate1.isAppRateViewShow = TRUE;
// 	}
//	else 
//	{
//		AppRaterView * raterView = [[AppRaterView alloc] initWithNibName:@"AppRaterView" bundle:nil];
//        raterView.view.frame = CGRectMake(0, 20, 320, 480);
//
//		if([appDelegate.settings.passcode length] > 0)
//		{
//			[appDelegate.window insertSubview:raterView.view  atIndex:[[appDelegate.window subviews] count]-1];
//		}
//		else {
//			[appDelegate.window addSubview:raterView.view];
//
//		}
//
// 
//	}
//}

+(void)BtnPressed:(int)btnIndex
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if(btnIndex == 0)
	{
		NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", APPIRATER_APP_ID]];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
		
		[userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];
	}
	else if(btnIndex == 2)
	{
		[userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
	}
	[userDefaults synchronize];
	[self release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	switch (buttonIndex) {
		case 0:
		{
			// they don't want to rate it
			[userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
			break;
		}
		case 1:
		{
            NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", APPIRATER_APP_ID]];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
			
			[userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];
			break;
			
		}
		case 2:
			// remind them later
			break;
		default:
			break;
	}
	
	[userDefaults synchronize];
	
	[alertView release];
	[self release];
}

@end

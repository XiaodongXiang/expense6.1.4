//
//  XDAppriater.m
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/20.
//



#import "XDAppriater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "XDRateView.h"
#import "HelpClass.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PokcetExpenseAppDelegate.h"
@interface XDAppriater (hidden)

@end

@implementation XDAppriater(hidden)
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

@interface XDAppriater ()<XDRateDelegate,MFMailComposeViewControllerDelegate>

@end

//#ifdef LITE
//NSString* templateReviewURL = @"https://itunes.apple.com/cn/app/pocket-expense-personal-finance/id424575621?action=write-review";
//#else
//NSString* templateReviewURL = @"http://itunes.apple.com/us/app/pocket-expense-lite/id830063876?action=write-review";
//#endif


@implementation XDAppriater

+(XDAppriater *)shareAppirater{
    static XDAppriater* g_appirater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_appirater = [[XDAppriater alloc]init];
    });
    return g_appirater;
}

-(void)judgeShowRateView{
    BOOL show = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERDONTSHOWAGAIN] boolValue];
    if (!show) {
        NSInteger integer = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERIMPORTANTEVENT] integerValue];
        if (integer >= XDAPPIRATERNUMBERWITHIMPORTANTEVENT && [self connectedToNetwork]) {
            [self showAppirater];
        }
    }    
}

-(void)showAppirater{
    XDRateView* appView = [[[NSBundle mainBundle]loadNibNamed:@"XDRateView" owner:self options:nil]lastObject];
    appView.xxDelegate = self;
    appView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:appView];
    appView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        appView.alpha = 1;
    }];
}

-(void)setEmptyAppirater{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XDAPPIRATERIMPORTANTEVENT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XDAPPIRATERDONTSHOWAGAIN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XDAPPIRATERCLOSERATEVIEW];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - XDRateDelegate
-(void)likeApp{
    NSString* templateReviewURL = @"https://itunes.apple.com/cn/app/pocket-expense-personal-finance/id424575621?action=write-review";

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURL]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:XDAPPIRATERDONTSHOWAGAIN];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)cancelApp{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERCLOSERATEVIEW];
    if ([number integerValue] >= 2) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:XDAPPIRATERDONTSHOWAGAIN];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@([number integerValue] + 1) forKey:XDAPPIRATERCLOSERATEVIEW];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:XDAPPIRATERIMPORTANTEVENT];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)hateApp{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_No Mail Accounts", nil) message:NSLocalizedString(@"VC_Please set up a mail account in order to send mail.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
    }
}

-(void)displayComposerSheet
{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Pocket Expense Feedback"];
    [picker setToRecipients:[NSArray arrayWithObject:@"expense5@appxy.com"]];
    [picker setCcRecipients:nil];
    [picker setCcRecipients:nil];
    
    NSString * versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * deviceType = [[UIDevice currentDevice] systemName];
    NSString * deviceVersion = [[UIDevice currentDevice] systemVersion];
    NSString * deviceStr = [self returnDeviceName];
    
    NSString *liteorpro;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(appDelegate.isPurchased)
    {
        liteorpro = @"Pur";
    }
    else
    {
        liteorpro = @"Lite";
    }

    NSString *mailBody = [NSString stringWithFormat:@"<html><body>App:v%@ %@<br/>%@：v%@<br/>Device: %@<br/>Feedback here: </body></html>", versionStr,liteorpro, deviceType, deviceVersion, deviceStr];
    
    
    
    
    [picker setMessageBody:mailBody isHTML:YES];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:XDAPPIRATERDONTSHOWAGAIN];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }];
}


-(NSString* )returnDeviceName{
    
    NSString *platform = [UIDevice platform];
    
    NSDictionary* deviceNamesByCode = @{@"i386"      : @"Simulator",
                                        @"x86_64"    : @"Simulator",
                                        @"iPod1,1"   : @"iPod Touch",        // (Original)
                                        @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                                        @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                                        @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                                        @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                                        @"iPhone1,1" : @"iPhone",            // (Original)
                                        @"iPhone1,2" : @"iPhone",            // (3G)
                                        @"iPhone2,1" : @"iPhone",            // (3GS)
                                        @"iPad1,1"   : @"iPad",              // (Original)
                                        @"iPad2,1"   : @"iPad 2",            //
                                        @"iPad3,1"   : @"iPad",              // (3rd Generation)
                                        @"iPhone3,1" : @"iPhone 4",          // (GSM)
                                        @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                                        @"iPhone4,1" : @"iPhone 4S",         //
                                        @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                                        @"iPad3,4"   : @"iPad",              // (4th Generation)
                                        @"iPad2,5"   : @"iPad Mini",         // (Original)
                                        @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPhone7,1" : @"iPhone 6 Plus",     //
                                        @"iPhone7,2" : @"iPhone 6",          //
                                        @"iPhone8,1" : @"iPhone 6S",         //
                                        @"iPhone8,2" : @"iPhone 6S Plus",    //
                                        @"iPhone8,4" : @"iPhone SE",         //
                                        @"iPhone9,1" : @"iPhone 7",          //
                                        @"iPhone9,3" : @"iPhone 7",          //
                                        @"iPhone9,2" : @"iPhone 7 Plus",     //
                                        @"iPhone9,4" : @"iPhone 7 Plus",     //
                                        @"iPhone10,1": @"iPhone 8",          // CDMA
                                        @"iPhone10,4": @"iPhone 8",          // GSM
                                        @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                                        @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                                        @"iPhone10,3": @"iPhone X",          // CDMA
                                        @"iPhone10,6": @"iPhone X",          // GSM
                                        @"iPhone11,4": @"iPhone Xs Max",
                                        @"iPhone11,6": @"iPhone Xs Max",
                                        @"iPhone11,8": @"iphone XR",
                                        @"iPhone11,2": @"iphone XS",
                                        @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                                        @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                                        @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                                        @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                                        @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                                        @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                                        };
    
    return deviceNamesByCode[platform]?:platform;
    
}

#pragma mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

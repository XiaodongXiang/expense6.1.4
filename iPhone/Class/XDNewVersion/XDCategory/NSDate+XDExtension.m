//
//  NSDate+XDExtension.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/30.
//

#import "NSDate+XDExtension.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

#define URLArray    @[@"http://www.yahoo.com",@"http://www.microsoft.com/",@"https://parse.com/",@"https://www.amazon.com",@"http://www.apple.com/",@"https://www.baidu.com/",@"http://www.alibaba.com",@"http://www.msn.com"]


@implementation NSDate (XDExtension)


+(NSDate *)initCurrentDate{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:[NSDate date]];
    
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return date;
}

-(NSDate*)dateAndTime{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents* currentCom = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:[NSDate date]];
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:self];
    components.hour = currentCom.hour;
    components.minute = currentCom.minute;
    components.second = currentCom.second;
    
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return date;
}
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
-(NSDate*)initDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [calendar components:dayInfoUnits fromDate:self];
    
    NSDate* date = [calendar dateFromComponents:components];
    
    return date;
}

-(NSDate*)endDate{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return date;
    
}

-(NSDate *)initYearDate{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:self];
    components.month = 1;
    components.day = 2;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return date;
}

-(NSDate *)initYearEndDate{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:self];
    components.month = 12;
    components.day = 31;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return date;
}


+ (BOOL)connectedToNetwork {
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

+(void) internetServerDate:(void (^) (NSDate *))block{
    if ([NSDate connectedToNetwork]){
        __block BOOL getDate = NO;
        __block NSInteger   requestCount = 0;
        NSOperationQueue *urlQueue = [NSOperationQueue new];
        urlQueue.name = @"OperationDate";
        
        for (NSString *urlString in URLArray) {
            NSMutableURLRequest *URLRequest        = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
            URLRequest.HTTPMethod                  = @"HEAD";
            
            [NSURLConnection sendAsynchronousRequest:URLRequest queue:urlQueue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                requestCount++;
                if (connectionError) {
                    //                    NSLog(@"Error ---- %@",connectionError);
                }else{
                    if (!getDate) {
                        getDate = YES;
                        NSHTTPURLResponse *resp         = (NSHTTPURLResponse *) response;
                        NSString *httpDate              = [resp allHeaderFields][@"Date"];
                        
                        NSDateFormatter *df             = [NSDateFormatter new];
                        df.dateFormat                   = @"EEE, dd MMM yyyy HH:mm:ss z";
                        df.locale                       = [NSLocale localeWithLocaleIdentifier:@"en_US"];
                        
                        NSDate *serverDate             = [df dateFromString: httpDate];
                        if (block) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                block(serverDate);
                            });
                        }
                    }
                }
                
                if (requestCount >= URLArray.count && !getDate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(nil);
                    });
                }
            }];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil);
        });
    }
}


+(NSDate *)internetDate{
    
    NSTimeInterval interval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"] doubleValue];
    return [[NSDate date] dateByAddingTimeInterval:-interval];
}

+(NSDate *)GMTTime{
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT"]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:[NSDate date]];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate* newDate = [[NSDate date] dateByAddingTimeInterval:time];
    
    return newDate;
}


@end

//
//  XDPlanControlClass.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDPlanControlClass.h"
#import "PokcetExpenseAppDelegate.h"
#import <Parse/Parse.h>
#import "FBHelper.h"
@import Firebase;

@implementation XDPlanControlClass

+(instancetype)shareControlClass{
    static XDPlanControlClass* g_class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_class = [[XDPlanControlClass alloc]init];
    });
    return g_class;
}

-(void)setChristmasView:(XDOverviewChristmasViewA *)christmasView{
    
    if (self.planType == ChristmasPlanA) {
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_plus"] forState:UIControlStateNormal];
        }
        [FIRAnalytics logEventWithName:@"christmas_A_banner_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

        
    }else{
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone 8plus"] forState:UIControlStateNormal];
        }
        [FIRAnalytics logEventWithName:@"christmas_a_banner_show" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];

    }
}

-(BOOL)needShow{
//    return YES;

    BOOL dismiss = [[NSUserDefaults standardUserDefaults] boolForKey:@"dismissChristmasBanner"];
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue < 11.2 || dismiss) {
        return NO;
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.isPurchased == YES) {
        
        NSString* avalue = [FBHelper valueByConfigureName:@"cm_pa_layout_type"];
        NSString* avalue2 = [FBHelper valueByConfigureName:@"cm_pa_button_type"];
        
        if (!avalue || avalue.length == 0 || [avalue isEqualToString:@"None"]) {
            return NO;
        }
        if (!avalue2 || avalue2.length == 0 || [avalue2 isEqualToString:@"None"]) {
            return NO;
        }
        
    }else{
        
        
        NSString* Avalue = [FBHelper valueByConfigureName:@"cm_ip_layout_type"];
        NSString* Avalue2 = [FBHelper valueByConfigureName:@"cm_ip_button_type"];
        
        if (!Avalue || Avalue.length == 0 || [Avalue isEqualToString:@"None"]) {
            return NO;
        }
        if (!Avalue2 || Avalue2.length == 0 || [Avalue2 isEqualToString:@"None"]) {
            return NO;
        }
    }
    
    
    return YES;
}

-(BOOL)everyDayShowOnce{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (!self.needShow || appDelegate.isPurchased == YES) {
        return NO;
    }
    
    
    NSDate* today = [NSDate date];
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:today];
    comp.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate* initDate = [[NSCalendar currentCalendar]dateFromComponents:comp];
    
    NSDate* date = [[NSUserDefaults standardUserDefaults] valueForKey:@"everyDayShowOnceDate"];
    if (!date) {
        [[NSUserDefaults standardUserDefaults] setObject:initDate forKey:@"everyDayShowOnceDate"];
        return YES;
    }
    if ([date compare:initDate] == NSOrderedSame) {
        return NO;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:initDate forKey:@"everyDayShowOnceDate"];
        return YES;
    }
    
    return NO;
}

-(ChristmasPlanType)planType{
//    return random()%2;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        NSString* value = [FBHelper valueByConfigureName:@"cm_pa_layout_type"];
        if ([value isEqualToString:@"LEILEI"]) {
            return ChristmasPlanB;
        }else{
            return ChristmasPlanA;
        }
    }else{
        NSString* value = [FBHelper valueByConfigureName:@"cm_ip_layout_type"];
        if ([value isEqualToString:@"LEILEI"]) {
            return ChristmasPlanB;
        }else{
            return ChristmasPlanA;
        }
    }
    
    return ChristmasPlanA;
}
//
-(ChristmasSubPlan)planSubType{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        NSString* value2 = [FBHelper valueByConfigureName:@"cm_pa_button_type"];
        if ([value2 isEqualToString:@"Get And Share"]) {
            return ChristmasSubPlanb;
        }else{
            return ChristmasSubPlana;
        }

    }else{
        NSString* value2 = [FBHelper valueByConfigureName:@"cm_ip_button_type"];
        if ([value2 isEqualToString:@"Get And Share"]) {
            return ChristmasSubPlanb;
        }else{
            return ChristmasSubPlana;
        }
    }
        
    
     return ChristmasSubPlanb;
    
}

-(ChristmasPlanCategory)planCategory{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        return ChristmasPlanCategoryHasReceive7Days;
    }else{
        return ChristmasPlanCategoryLifetime;
    }

    return ChristmasPlanCategoryHasReceive7Days;
}

-(NSNumber*)isChristmasNewUser{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    comp.year = 2018;
    comp.month = 12;
    comp.day = 22;
    comp.hour = 0;
    comp.minute = 0;
    comp.second = 0;
    NSDate* startDate = [[NSCalendar currentCalendar] dateFromComponents:comp];

    if ([[PFUser currentUser].createdAt compare:startDate] == NSOrderedDescending) {
        return [NSNumber numberWithBool:YES];
    }else{
        return [NSNumber numberWithBool:NO];
    }
}

-(NSNumber*)pageTimeWithStartDate:(NSDate *)enterDate endDate:(NSDate *)leaveDate{
    
    NSTimeInterval interval = [enterDate timeIntervalSinceDate:leaveDate];
    
    return [NSNumber numberWithDouble:interval];
}

-(void)validateReceipt
{
    
    NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString* urlStr = RECEIPTURL;
    
    NSString * encodeStr = [receiptData base64EncodedStringWithOptions:0];
    NSURL* sandBoxUrl = [[NSURL alloc]initWithString:urlStr];
    
    NSDictionary* dic = @{@"receipt":encodeStr};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    
    NSMutableURLRequest* connectionRequest = [NSMutableURLRequest requestWithURL:sandBoxUrl];
    connectionRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    connectionRequest.HTTPBody = jsonData;
    connectionRequest.HTTPMethod = @"POST";
    [connectionRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [connectionRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    // create a background session for connecting to the Receipt Verification service.
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest: connectionRequest
                                                completionHandler: ^(NSData *apiData
                                                                     , NSURLResponse *apiResponse
                                                                     , NSError *conxErr)
                                      {
                                          // background datatask completion block
                                          if (apiData) {
                                              
                                              NSError *parseErr;
                                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData: apiData
                                                                                                   options: 0
                                                                                                     error: &parseErr];
                                              // TODO: add error handling for conxErr, json parsing, and invalid http response statuscode
                                              NSDictionary* recerptDic = json[@"receipt"];
                                              
                                              NSArray* lastReceiptArr = recerptDic[@"latest_receipt_info"];
//                                              NSDictionary* pendingRenewal = [recerptDic[@"pending_renewal_info"] lastObject];
                                              NSDictionary* lastReceiptInfo = lastReceiptArr.lastObject;
                                              NSLog(@"receipt=== %@",lastReceiptInfo);
                                              
                                                
                                          }else{
                                              
                                              
                                          }
                                          
                                          
                                          /* TODO: Unlock the In App purchases ...
                                           At this point the json dictionary will contain the verified receipt from Apple
                                           and each purchased item will be in the array of lineitems.
                                           */
                                      }];
    
    [datatask resume];
}


-(NSInteger)distanceEndTime{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    comp.year = 2019;
    comp.month = 1;
    comp.day = 3;
    NSDate* endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];

     NSDateComponents *delta = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date] toDate:endDate options:0];
    
    
    
    return delta.day;
}
@end

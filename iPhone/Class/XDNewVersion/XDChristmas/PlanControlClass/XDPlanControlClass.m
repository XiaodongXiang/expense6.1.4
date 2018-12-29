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

#define CM_IP_BUTTON   @"cm_ip_button_type"
#define CM_IP_LAYOUT   @"cm_ip_layout_type"
#define CM_PA_BUTTON   @"cm_pa_button_type"
#define CM_PA_LAYOUT   @"cm_pa_layout_type"


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
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];

    
    if (self.planType == ChristmasPlanA) {
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_plus"] forState:UIControlStateNormal];
        }
        if (appDelegate.isPurchased) {
            [FIRAnalytics logEventWithName:@"CA_PU_ShowBanner" parameters:nil];
        }else{
             [FIRAnalytics logEventWithName:@"CA_FU_ShowBanner" parameters:nil];
        }
        
    }else{
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone 8plus"] forState:UIControlStateNormal];
        }
        if (appDelegate.isPurchased) {
            [FIRAnalytics logEventWithName:@"CA_PU_ShowBanner" parameters:nil];
        }else{
            [FIRAnalytics logEventWithName:@"CA_FU_ShowBanner" parameters:nil];
        }
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
        
        NSString* avalue = [FBHelper valueByConfigureName:CM_PA_LAYOUT];
        NSString* avalue2 = [FBHelper valueByConfigureName:CM_PA_BUTTON];
        
        if (!avalue || avalue.length == 0 || [avalue isEqualToString:@"None"]) {
            return NO;
        }
        if (!avalue2 || avalue2.length == 0 || [avalue2 isEqualToString:@"None"]) {
            return NO;
        }
        
    }else{
        
        
        NSString* Avalue = [FBHelper valueByConfigureName:CM_IP_LAYOUT];
        NSString* Avalue2 = [FBHelper valueByConfigureName:CM_IP_BUTTON];
        
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
        NSString* value = [FBHelper valueByConfigureName:CM_PA_LAYOUT];
        if ([value isEqualToString:@"LEILEI"]) {
            return ChristmasPlanB;
        }else{
            return ChristmasPlanA;
        }
    }else{
        NSString* value = [FBHelper valueByConfigureName:CM_IP_LAYOUT];
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
        NSString* value2 = [FBHelper valueByConfigureName:CM_PA_BUTTON];
        if ([value2 isEqualToString:@"Get And Share"]) {
            return ChristmasSubPlanb;
        }else{
            return ChristmasSubPlana;
        }

    }else{
        NSString* value2 = [FBHelper valueByConfigureName:CM_IP_BUTTON];
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

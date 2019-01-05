//
//  XDPurchasedManager.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/29.
//

#import "XDPurchasedManager.h"

#import "PokcetExpenseAppDelegate.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>

@implementation XDPurchasedManager

+(XDPurchasedManager*)shareManager{
    static XDPurchasedManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XDPurchasedManager alloc]init];
    });
    
    return manager;
}


-(void)savePFSetting{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![PFUser currentUser]) {
            return;
        }
        Setting* setting = [[[XDDataManager shareManager]getObjectsFromTable:@"Setting"]lastObject];
        PFQuery *query = [PFQuery queryWithClassName:@"Setting"];
        [query whereKey:@"settingID" equalTo:[PFUser currentUser].objectId];
        [query whereKey:@"parse_User" equalTo:[PFUser currentUser]];

        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                if (objects.count > 0) {
                    PFObject* objectServer = objects.lastObject;
                    
                    if (setting.purchasedProductID != nil) {
                        objectServer[@"purchasedProductID"] = setting.purchasedProductID;
                    }else{
                        [objectServer  removeObjectForKey:@"purchasedProductID"];
                    }
                    
                    if (setting.purchasedStartDate != nil) {
                        objectServer[@"purchasedStartDate"] = setting.purchasedStartDate;
                    }else{
                        [objectServer removeObjectForKey:@"purchasedStartDate"];
                    }
                    
                    if (setting.purchasedEndDate != nil) {
                        objectServer[@"purchasedEndDate"] = setting.purchasedEndDate;
                    }else{
                        [objectServer removeObjectForKey:@"purchasedEndDate"];
                    }
                    
                    if (setting.purchasedUpdateTime != nil) {
                        objectServer[@"purchasedUpdateTime"] = setting.purchasedUpdateTime;
                    }else{
                        [objectServer removeObjectForKey:@"purchasedUpdateTime"];
                    }
                    
                    if (setting.uuid != nil) {
                        objectServer[@"settingID"]  = setting.uuid;
                    }else{
                        [objectServer removeObjectForKey:@"settingID"];
                    }
                    
                    if (setting.purchasedIsSubscription != nil) {
                        objectServer[@"purchasedIsSubscription"]  = setting.purchasedIsSubscription;
                    }else{
                        [objectServer removeObjectForKey:@"purchasedIsSubscription"];
                    }
                    
                    if (setting.purchaseOriginalProductID != nil) {
                        objectServer[@"purchaseOriginalProductID"]  = setting.purchaseOriginalProductID;
                    }else{
                        [objectServer removeObjectForKey:@"purchaseOriginalProductID"];
                    }
                    
                    [objectServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            setting.otherBool17 = @YES;
                        }else{
                            setting.otherBool17 = @NO;
                        }
                        [[XDDataManager shareManager] saveContext];
                        
                    }];
                    
                }else{
                    if (![setting.purchasedIsSubscription boolValue]) {
                        return ;
                    }
                    PFObject* objectServer = [PFObject objectWithClassName:@"Setting"];
                    if (setting.purchasedProductID) {
                        objectServer[@"purchasedProductID"] = setting.purchasedProductID;
                    }
                    if (setting.purchasedStartDate) {
                        objectServer[@"purchasedStartDate"] = setting.purchasedStartDate;
                    }
                    if (setting.purchasedEndDate) {
                        objectServer[@"purchasedEndDate"] = setting.purchasedEndDate;
                    }
                    if (setting.purchasedUpdateTime) {
                        objectServer[@"purchasedUpdateTime"] = setting.purchasedUpdateTime;
                    }
                    if ([PFUser currentUser].objectId) {
                        objectServer[@"settingID"] = [PFUser currentUser].objectId;
                    }
                    if (setting.purchasedIsSubscription) {
                        objectServer[@"purchasedIsSubscription"] = setting.purchasedIsSubscription;
                    }
                    if (setting.purchaseOriginalProductID) {
                        objectServer[@"purchaseOriginalProductID"] = setting.purchaseOriginalProductID;
                    }
                    [objectServer setObject:[PFUser currentUser] forKey:@"parse_User"];

                    [objectServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            setting.otherBool17 = @YES;
                        }else{
                            setting.otherBool17 = @NO;
                        }
                        [[XDDataManager shareManager] saveContext];
                        
                    }];
                }
            }
        }];
    });
    
    
    
}

-(void)getPFSetting{
    
    if (![PFUser currentUser]) {
        return;
    }
    Setting* setting = [[[XDDataManager shareManager]getObjectsFromTable:@"Setting"]lastObject];
    PFQuery *query = [PFQuery queryWithClassName:@"Setting"];
    [query whereKey:@"settingID" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"parse_User" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            for (PFObject* object in objects) {
                NSDate* updateDate = object[@"purchasedUpdateTime"];
                if ([PFUser currentUser]) {
                    if ([[PFUser currentUser].objectId isEqualToString:object[@"settingID"]]) {
                        if ([updateDate compare:setting.purchasedUpdateTime] == NSOrderedDescending || !setting.purchasedUpdateTime) {
                            
                            setting.purchasedUpdateTime = object[@"purchasedUpdateTime"];
                            setting.purchasedProductID = object[@"purchasedProductID"];
                            setting.purchasedStartDate = object[@"purchasedStartDate"];
                            setting.purchasedEndDate = object[@"purchasedEndDate"];
                            setting.purchasedIsSubscription = object[@"purchasedIsSubscription"];
                            setting.uuid = object[@"settingID"];
                            setting.purchaseOriginalProductID = object[@"purchaseOriginalProductID"];
                            
                            setting.otherBool16 = [NSNumber numberWithInt:[object[@"isTryingPremium"]boolValue]];
                            setting.otherBool18 = [NSNumber numberWithInt:[object[@"alreadyInvited"]boolValue]];
                            setting.otherBool19 = [NSNumber numberWithInt:[object[@"haveOneMonthTrial"]boolValue]];
                            setting.otherBool20 = [NSNumber numberWithInt:[object[@"invitedSuccessNotif"]boolValue]];
                            
                            object[@"invitedSuccessNotif"] = @"0";
                            [object saveEventually];
                        }
                    }
                }
            }
            
            if ([setting.otherBool20 boolValue]) {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Your invitation will be successful and you will receive one month of premium member usage time." message:nil preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:action];
//                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                
                setting.otherBool20 = [NSNumber numberWithBool:NO];
                
                
            }
            
            
            [[XDDataManager shareManager]saveContext];
            
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
            if ([setting.purchasedIsSubscription boolValue]) {
                appDelegate.isPurchased = YES;
                [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];
            }else{
                appDelegate.isPurchased = NO;
                [[XDDataManager shareManager]openWidgetInSettingWithBool14:NO];
            }
            
        }
    }];
}


-(void)saveDefaultParseSetting{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            BOOL isFirstUploadSetting = [[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST_UPLOAD_SETTING];
            if (!isFirstUploadSetting) {
                
                if (![PFUser currentUser]) {
                    return;
                }
                
                Setting* setting = [[[XDDataManager shareManager]getObjectsFromTable:@"Setting"]lastObject];
                PFQuery *query = [PFQuery queryWithClassName:@"Setting"];
                [query whereKey:@"settingID" equalTo:[PFUser currentUser].objectId];
                [query whereKey:@"parse_User" equalTo:[PFUser currentUser]];
                
                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    if (!object) {
                        PFObject* objectServer = [PFObject objectWithClassName:@"Setting"];
                        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
                        
                        if (appDelegete.isPurchased == YES) {
                            
                            BOOL lifetime = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;
                            if (lifetime) {
                                objectServer[@"purchasedProductID"] = kInAppPurchaseProductIdLifetime;
                            }else{
                                if (setting.purchasedProductID) {
                                    objectServer[@"purchasedProductID"] = setting.purchasedProductID;
                                }else{
                                    objectServer[@"purchasedProductID"] = KInAppPurchaseProductIdMonth;
                                }
                            }
                        }else{
                            objectServer[@"purchasedProductID"] = KInAppPurchaseProductIdMonth;
                        }
                        if (setting.purchasedStartDate) {
                            objectServer[@"purchasedStartDate"] = setting.purchasedStartDate;
                        }else{
                            objectServer[@"purchasedStartDate"] = [NSDate dateWithTimeIntervalSince1970:0];
                        }
                        if (setting.purchasedEndDate) {
                            objectServer[@"purchasedEndDate"] = setting.purchasedEndDate;
                        }else{
                            objectServer[@"purchasedEndDate"] = [NSDate dateWithTimeIntervalSince1970:0];
                        }
                        if (setting.purchasedUpdateTime) {
                            objectServer[@"purchasedUpdateTime"] = setting.purchasedUpdateTime;
                        }else{
                            objectServer[@"purchasedUpdateTime"] = [NSDate date];
                        }
                        if ([PFUser currentUser].objectId) {
                            objectServer[@"settingID"] = [PFUser currentUser].objectId;
                        }
                        if (setting.purchasedIsSubscription) {
                            objectServer[@"purchasedIsSubscription"] = setting.purchasedIsSubscription;
                        }else{
                            objectServer[@"purchasedIsSubscription"] = [NSNumber numberWithInt:0];
                        }
                        if (setting.purchaseOriginalProductID) {
                            objectServer[@"purchaseOriginalProductID"] = setting.purchaseOriginalProductID;
                        }else{
                            objectServer[@"purchaseOriginalProductID"] = @"1234567890";
                        }
                        
                        
                        objectServer[@"alreadyInvited"] = @"0";
                        objectServer[@"haveOneMonthTrial"] = @"0";
                        objectServer[@"invitedSuccessNotif"] = @"0";
                        objectServer[@"isTryingPremium"] = @"0";
                        
                        [objectServer setObject:[PFUser currentUser] forKey:@"parse_User"];
                        
                        [objectServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                setting.otherBool17 = @YES;
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FIRST_UPLOAD_SETTING];
                                
                            }else{
                                setting.otherBool17 = @NO;
                            }
                            [[XDDataManager shareManager] saveContext];
                            
                        }];
                    }
                }];
            }
        });
}

-(void)puchasedMonthInfoInSetting:(NSDate*)startDate productID:(NSString*)productID originalProID:(NSString *)originalProID{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    
    // 修改订阅测试时间
#ifdef DEBUG
    comp.minute += 5;
#else
    comp.month += 1;
#endif
    NSDate* endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
      
    Setting* setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"] lastObject];
    setting.purchasedProductID = productID;
    setting.purchasedStartDate = startDate;
    setting.purchasedEndDate = endDate;
    setting.purchasedUpdateTime = [NSDate date];
    setting.otherBool17 = @NO;
    setting.purchasedIsSubscription = @YES;
    setting.uuid = [PFUser currentUser].objectId;
    setting.purchaseOriginalProductID = originalProID;
    
    [[XDDataManager shareManager] saveContext];
    
    [[XDPurchasedManager shareManager] savePFSetting];

}

-(void)tryOutPremium30DaysWithNewUser{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString* string = [[NSUserDefaults standardUserDefaults] valueForKey:@"invitedby"];
        if (string.length > 0) {
            PFQuery *query = [PFQuery queryWithClassName:@"Setting"];
            [query whereKey:@"settingID" equalTo:string];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (objects.count > 0) {
                    
                    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
                    
                    // 修改订阅测试时间
#ifdef DEBUG
                    comp.minute += 5;
#else
                    comp.month += 1;
#endif
                    NSDate* endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
                    
                    BOOL isSubcription = NO;
                    BOOL alreadInvited = NO;
                    for (PFObject* object in objects) {
                        isSubcription = [object[@"purchasedIsSubscription"] boolValue];
                        alreadInvited = [object[@"alreadyInvited"] boolValue];
                    }
                    
                    if (!alreadInvited) {
                        if (!isSubcription) {
                            for (PFObject* objectServer in objects) {
                                objectServer[@"purchasedStartDate"] = [NSDate date];
                                objectServer[@"purchasedEndDate"] = endDate;
                                objectServer[@"purchasedUpdateTime"] = [NSDate date];
                                objectServer[@"purchasedIsSubscription"] = [NSNumber numberWithInt:1];
                                objectServer[@"alreadyInvited"] = @"1";
                                objectServer[@"haveOneMonthTrial"] = @"0";
                                objectServer[@"invitedSuccessNotif"] = @"1";
                                objectServer[@"isTryingPremium"] = @"1";
                                
                                [objectServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    
                                }];
                            }
                        }else{
                            for (PFObject* objectServer in objects) {
                                objectServer[@"purchasedUpdateTime"] = [NSDate date];
                                objectServer[@"alreadyInvited"] = @"1";
                                objectServer[@"haveOneMonthTrial"] = @"1";
                                objectServer[@"invitedSuccessNotif"] = @"1";
                                objectServer[@"isTryingPremium"] = @"0";
                                
                                [objectServer saveInBackground];
                            }
                        }
                    }
                }
            }];
        }
    });
}

@end
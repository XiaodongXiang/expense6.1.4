//
//  ipad_MainViewController.m
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_MainViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "ipad_SearchViewController.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "PersonalnfoViewController.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>

@import Firebase;

@interface ipad_MainViewController ()


@end
@implementation ipad_MainViewController

#pragma mark Life Method
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initPointandBtnAction];
    [self initFrameView];
    
//    [Appsee setUserID:[PFUser currentUser].email];

    [self checkDateWithPurchase];

    [FIRAnalytics setScreenName:@"main_view_ipad" screenClass:@"ipad_MainViewController"];
    [self getCurrentVersion];
    

}

-(void)getCurrentVersion
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (![currentVersion isEqualToString:lastVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self uploadUserProperty];
        
    }
}

-(void)uploadUserProperty{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        BOOL defaults = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;
        if (defaults) {
            [FIRAnalytics setUserPropertyString:@"lifetime" forName:@"subscription_type"];
        }else{
            Setting* setting = [[XDDataManager shareManager] getSetting];
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    [FIRAnalytics setUserPropertyString:@"monthly" forName:@"subscription_type"];
                    [FIRAnalytics setUserPropertyString:@"in subscribing" forName:@"subscription_status"];
                    
                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    [FIRAnalytics setUserPropertyString:@"yearly" forName:@"subscription_type"];
                    [FIRAnalytics setUserPropertyString:@"in subscribing" forName:@"subscription_status"];
                    
                }else{
                    [FIRAnalytics setUserPropertyString:@"lifetime" forName:@"subscription_type"];
                }
            }
        }
    }else{
        
        [FIRAnalytics setUserPropertyString:@"free" forName:@"subscription_type"];
    }
    
    [self validateReceiptWithUserProperty];
    
}

-(void)validateReceiptWithUserProperty
{
    
    NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    if (receiptData == nil) {
        return;
    }
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
                                              NSDictionary* pendingRenewal = [recerptDic[@"pending_renewal_info"] lastObject];
                                              NSDictionary* lastReceiptInfo = lastReceiptArr.lastObject;
                                              NSDictionary* firstReceiptInfo = lastReceiptArr.firstObject;
                                              if (lastReceiptArr.count <= 0) {
                                                  [FIRAnalytics setUserPropertyString:@"never" forName:@"subscription_status"];
                                              }else{
                                                  [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",lastReceiptArr.count] forName:@"subscription_continuity"];
                                              }
                                              
                                              if (lastReceiptInfo) {
                                                  [self returnUserPropertyReceipt:lastReceiptInfo pendingRenewal:pendingRenewal];
                                              }
                                              if (firstReceiptInfo) {
                                                  NSString* purchasedStr = [firstReceiptInfo valueForKey:@"purchase_date"];
                                                  NSString* purchaseSubStr = [purchasedStr substringToIndex:purchasedStr.length - 7];
                                                  
                                                  NSDateFormatter *dateFormant = [[NSDateFormatter alloc] init];
                                                  [dateFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                                                  NSDate* purchaseDate = [dateFormant dateFromString:purchaseSubStr];
                                                  
                                                  NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:purchaseDate];
                                                  
                                                  [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",comp.year] forName:@"subscription_year"];
                                                  [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",comp.month] forName:@"subscription_month"];
                                                  [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",comp.day] forName:@"subscription_day"];
                                                  
                                              }
                                              
                                          }else{
                                              [FIRAnalytics setUserPropertyString:@"never" forName:@"subscription_status"];
                                          }
                                      }];
    
    [datatask resume];
}

-(void)returnUserPropertyReceipt:(NSDictionary*)lastReceipt  pendingRenewal:(NSDictionary*)pendingRenewal{
    
    NSString* expiresStr =[lastReceipt valueForKey:@"expires_date"];
    NSString* productID = [lastReceipt valueForKey:@"product_id"];
    
    if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]) {
        return;
    }
    
    NSString* expireSubStr = [expiresStr substringToIndex:expiresStr.length - 7];
    
    NSDateFormatter *dateFormant = [[NSDateFormatter alloc] init];
    [dateFormant setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* expireDate = [dateFormant dateFromString:expireSubStr];
    
    //续订了
    if ([[NSDate GMTTime] compare:expireDate] == NSOrderedAscending) {
        
    }else{  //没续订
        NSString* auto_renew_status = pendingRenewal[@"auto_renew_status"];
        NSString* expiration_intent = pendingRenewal[@"expiration_intent"];
        
        if ([auto_renew_status isEqualToString:@"0"]) {
            if ([expiration_intent isEqualToString:@"1"] || [expiration_intent isEqualToString:@"3"]) {
                [FIRAnalytics setUserPropertyString:@"cancelled" forName:@"subscription_status"];
            }
        }
    }
}



-(void)returnReceipt:(NSDictionary*)lastReceipt{
    
    
    NSString* purchasedStr = [lastReceipt valueForKey:@"purchase_date"];
    NSString* expiresStr =[lastReceipt valueForKey:@"expires_date"];
    NSString* productID = [lastReceipt valueForKey:@"product_id"];
    NSString* originalID = [lastReceipt valueForKey:@"original_transaction_id"];
    //    NSString* originalTransacionID = [lastReceipt valueForKey:@"original_transaction_id"];
    
    if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
//        [[ADEngineManage adEngineManage] unlockAllFunctionsHideAd];

        return;
    }
    
    NSString* purchaseSubStr = [purchasedStr substringToIndex:purchasedStr.length - 7];
    NSString* expireSubStr = [expiresStr substringToIndex:expiresStr.length - 7];
    
    NSDateFormatter *dateFormant = [[NSDateFormatter alloc] init];
    [dateFormant setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* purchaseDate = [dateFormant dateFromString:purchaseSubStr];
    NSDate* expireDate = [dateFormant dateFromString:expireSubStr];
    
    //    NSString* loclOriginalTransactionID = [[NSUserDefaults standardUserDefaults] stringForKey:@"originalTransactionID"];
    
    //续订了
    if ([[NSDate GMTTime] compare:expireDate] == NSOrderedAscending) {
        
        
        [[XDDataManager shareManager] puchasedInfoInSetting:purchaseDate productID:productID originalProID:originalID];
//        [[ADEngineManage adEngineManage] unlockAllFunctionsHideAd];
        
    }else{  //没续订
        
        [self noSubscription];
        
    }
}

-(void)noSubscription{
//    [[ADEngineManage adEngineManage] lockFunctionsShowAd];
    [[XDDataManager shareManager] removeSettingPurchase];
    [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isPurchased = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
}



//检测是否订阅，并检测订阅时间是否到期
-(void)checkDateWithPurchase{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];
    
    Setting* setting = [[XDDataManager shareManager] getSetting];
    
    NSString* productID = setting.purchasedProductID;
    BOOL isPurchase = [setting.purchasedIsSubscription boolValue];
    //判断免费版是否被购买了
    if (appDelegate.isPurchased || (productID.length > 0 && isPurchase)) {
        Setting* setting = [[XDDataManager shareManager] getSetting];
        
        NSDate* date = setting.purchasedStartDate;
        NSString* purchasedID = setting.purchasedProductID;
        BOOL lifeTime = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG];
        
        if (lifeTime || [purchasedID isEqualToString:kInAppPurchaseProductIdLifetime]) {
            return;
        }else{
            if (!date || !purchasedID) {
                {
                    [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
                    appDelegate.isPurchased = NO;
//                    [[ADEngineManage adEngineManage] lockFunctionsShowAd];

                    [[XDDataManager shareManager] removeSettingPurchase];
                }
            }else if (purchasedID && date) {
                
                NSDate* expiredTime = setting.purchasedEndDate;
                NSTimeInterval timeInterval = [expiredTime timeIntervalSinceDate:[NSDate date]];
                
                if (timeInterval <= 0) {
                    NSData* receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                    if (receipt) {
                        //要提示重新订阅
                        [self validateReceipt];
                    }else{
                        
//                        [[ADEngineManage adEngineManage] lockFunctionsShowAd];
                        Setting* setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"] lastObject];
                        setting.purchasedProductID = nil;
                        setting.purchasedStartDate = nil;
                        setting.purchasedEndDate = nil;
                        setting.purchaseOriginalProductID = nil;
                        setting.dateTime = [NSDate GMTTime];
                        setting.otherBool17 = @NO;
                        setting.purchasedIsSubscription = @NO;
                        
                        [[XDDataManager shareManager] saveContext];
                        
                        [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
                        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
                        appDelegate.isPurchased = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
//                        [[ADEngineManage adEngineManage] lockFunctionsShowAd];

                    }
                }
            }
        }
    }
}
-(void)validateReceipt
{
    
    NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    if (receiptData == nil) {
        [self noSubscription];

        return;
    }
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
                                              NSDictionary* lastReceiptInfo = lastReceiptArr.lastObject;
                                              
                                              [self returnReceipt:lastReceiptInfo];
                                              
                                              if (lastReceiptArr.count <= 0) {
                                                  [FIRAnalytics setUserPropertyString:@"never" forName:@"subscription_status"];
                                              }else{
                                                  [FIRAnalytics setUserPropertyString:[NSString stringWithFormat:@"%ld",lastReceiptArr.count] forName:@"subscription_continuity"];
                                              }
                                              
                                          }else{
                                              [self noSubscription];
                                          }
                                          
                                          
                                          /* TODO: Unlock the In App purchases ...
                                           At this point the json dictionary will contain the verified receipt from Apple
                                           and each purchased item will be in the array of lineitems.
                                           */
                                      }];
    
    [datatask resume];
}

-(void)refleshData
{
    if (self.currentViewSelect==0) {
        [_overViewController refleshData];
    }
    else if (self.currentViewSelect==1)
    {
        [_iAccountViewController reFlashTableViewData];
    }
    else if (self.currentViewSelect==2)
        [_iBudgetViewController reFlashTableViewData];
    else if (self.currentViewSelect==3)
        [_iReportRootViewController reFlashTableViewData];

    else
        [_iBillsViewController reFlashBillModuleViewData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)initPointandBtnAction
{
    _lasViewSelectisBillView = NO;
    
    
    [_overViewModuleBtn addTarget:self action:@selector(overViewModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_accountModuleBtn addTarget:self action:@selector(accountModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_budgetModuleBtn addTarget:self action:@selector(budgetModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_reportModuleBtn addTarget:self action:@selector(reportModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_billsModuleBtn addTarget:self action:@selector(billModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_settingModuleBtn addTarget:self action:@selector(settingModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchModudleBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_networthModuleBtn addTarget:self action:@selector(networthBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cashflowModuleBtn addTarget:self action:@selector(cashflowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_summaryModuleBtn addTarget:self action:@selector(summaryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_categoryModuleBtn addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sideView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"side_bg_color"]];
    _topLineHeight.constant=EXPENSE_SCALE;
    
    
    [_avatarBtn addTarget:self action:@selector(avatarBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image=[UIImage imageNamed:@"ipad_personal_icon"];
    [_avatarBtn setImage:image forState:UIControlStateNormal];

}
-(void)initFrameView
{
    self.appTitleLabel.text = NSLocalizedString(@"VC_Overview", nil);
    [self setAllModuleBtnStateNomal];
    self.overViewModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
 	_currentViewSelect = overView;
    
    //首先在这里创建了一次viewController，所以当加载overview的时候会先加载kalview一次，这时候kalview的tag还是0
    _overViewController = [[iPad_OverViewViewController alloc]initWithNibName:@"iPad_OverViewViewController" bundle:nil];
    _overViewController.view.frame = CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
    [_contentView addSubview:_overViewController.view];
}

-(void)setAllModuleBtnStateNomal
{
    self.overViewModuleBtn.selected = NO;
    self.accountModuleBtn.selected = NO;
    self.budgetModuleBtn.selected = NO;
    self.reportModuleBtn.selected = NO;
    self.billsModuleBtn.selected = NO;
    self.summaryModuleBtn.selected=NO;
    self.categoryModuleBtn.selected=NO;
    self.cashflowModuleBtn.selected=NO;
    self.networthModuleBtn.selected=NO;
}
//设置side图片
-(void)setAllBtnNormalImg
{
    [self.settingModuleBtn setImage:[UIImage imageNamed:@"ipad_siderbar_setting"] forState:UIControlStateSelected];
	[self.settingModuleBtn setImage:[UIImage imageNamed:@"ipad_siderbar_setting"] forState:UIControlStateNormal];
    [self.settingModuleBtn setImage:[UIImage imageNamed:@"ipad_siderbar_setting"] forState:UIControlStateSelected|UIControlStateHighlighted];

    [self.overViewModuleBtn setImage:[UIImage imageNamed:@"side_overview"] forState:UIControlStateNormal];
    [self.overViewModuleBtn setImage:[UIImage imageNamed:@"side_overview_click"] forState:UIControlStateSelected];
    [self.overViewModuleBtn setImage:[UIImage imageNamed:@"side_overview_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
	[self.accountModuleBtn setImage:[UIImage imageNamed:@"side_account"] forState:UIControlStateNormal];
	[self.accountModuleBtn setImage:[UIImage imageNamed:@"side_account_click"] forState:UIControlStateSelected];
    [self.accountModuleBtn setImage:[UIImage imageNamed:@"side_account_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
    [self.budgetModuleBtn setImage:[UIImage imageNamed:@"side_budget"] forState:UIControlStateNormal];
    [self.budgetModuleBtn setImage:[UIImage imageNamed:@"side_budget_click"] forState:UIControlStateSelected];
    [self.budgetModuleBtn setImage:[UIImage imageNamed:@"side_budget_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
	[self.billsModuleBtn setImage:[UIImage imageNamed:@"side_bill"] forState:UIControlStateNormal];
	[self.billsModuleBtn setImage:[UIImage imageNamed:@"side_bill_click"] forState:UIControlStateSelected];
    [self.billsModuleBtn setImage:[UIImage imageNamed:@"side_bill_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
    [self.summaryModuleBtn setImage:[UIImage imageNamed:@"side_summary"] forState:UIControlStateNormal];
    [self.summaryModuleBtn setImage:[UIImage imageNamed:@"side_summary_click"] forState:UIControlStateSelected];
    [self.summaryModuleBtn setImage:[UIImage imageNamed:@"side_summary_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    [self.categoryModuleBtn setImage:[UIImage imageNamed:@"side_category"] forState:UIControlStateNormal];
    [self.categoryModuleBtn setImage:[UIImage imageNamed:@"side_category_click"] forState:UIControlStateSelected];
    [self.categoryModuleBtn setImage:[UIImage imageNamed:@"side_category_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
    [self.cashflowModuleBtn setImage:[UIImage imageNamed:@"side_cashflow"] forState:UIControlStateNormal];
    [self.cashflowModuleBtn setImage:[UIImage imageNamed:@"side_cashflow_click"] forState:UIControlStateSelected];
    [self.cashflowModuleBtn setImage:[UIImage imageNamed:@"side_cashflow_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

    
    [self.networthModuleBtn setImage:[UIImage imageNamed:@"side_networth"] forState:UIControlStateNormal];
    [self.networthModuleBtn setImage:[UIImage imageNamed:@"side_networth_click"] forState:UIControlStateSelected];
    [self.networthModuleBtn setImage:[UIImage imageNamed:@"side_networth_click"] forState:UIControlStateSelected|UIControlStateHighlighted];

}

#pragma mark Btn Action
-(void)refleshUI
{
    if (self.iSettingViewController != nil ) {
        [self.iSettingViewController refleshUI];
    }
    else if (self.currentViewSelect == 0) {
        [self.overViewController refleshUI];
    }
    else if (self.currentViewSelect==1)
    {
        [self.iAccountViewController refleshUI];
    }
    else if (self.currentViewSelect==2)
    {
        [self.iBudgetViewController refleshUI];
    }
    else if (self.currentViewSelect == 3)
    {
        [_iReportRootViewController reFlashTableViewData];

//        [_reportViewController reFlashTableViewData];
    }
    else if (self.currentViewSelect==4)
    {
        [self.iBillsViewController refleshUI];
    }
}
-(void)avatarBtnPressed:(id)sender
{
    PersonalnfoViewController *personalVC=[[PersonalnfoViewController alloc]initWithNibName:@"PersonalnfoViewController" bundle:nil];
    _avatatInfoVC=[[UIPopoverController alloc]initWithContentViewController:personalVC];
    _avatatInfoVC.popoverContentSize = CGSizeMake(217, 113);
    [_avatatInfoVC presentPopoverFromRect:CGRectMake(74, 84, 10, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}
-(void)overViewModuleBtnAction:(id)sender
{

    _lasViewSelectisBillView = NO;
    if (_currentViewSelect == overView) {
        return;
    }
    [self setAllModuleBtnStateNomal];
    self.overViewModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
    [self handleDateOverView];
    self.appTitleLabel.text = NSLocalizedString(@"VC_Overview", nil);

}
-(void)accountModuleBtnAction:(id)sender
{
    _lasViewSelectisBillView = NO;

	if(_currentViewSelect == accountView )
        return ;
    [self setAllModuleBtnStateNomal];
    self.accountModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
    [self handleDateAccountView];
    self.appTitleLabel.text = NSLocalizedString(@"VC_Account", nil);

}

-(void)budgetModuleBtnAction:(id)sender
{
    _lasViewSelectisBillView = NO;

//    [self getBudgetData];
    if(_currentViewSelect == budgetView)
        return ;
    [self setAllModuleBtnStateNomal];
    self.budgetModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
    [self handleDateBudgetView];
    self.appTitleLabel.text = NSLocalizedString(@"VC_Budget", nil);

}
-(void)reportModuleBtnAction:(id)sender
{
    _lasViewSelectisBillView = NO;

    if(_currentViewSelect == reportView ) return ;
    [self setAllModuleBtnStateNomal];
    self.reportModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
    [self handleDateReportView];
    self.appTitleLabel.text = NSLocalizedString(@"VC_Report", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_RPT"];
}
-(void)billModuleBtnAction:(id)sender
{

    if(_currentViewSelect == billsView ) return ;
    [self setAllModuleBtnStateNomal];
    self.billsModuleBtn.selected = YES;
    [self setAllBtnNormalImg];
    [self handleDateBillView];
    self.appTitleLabel.text = NSLocalizedString(@"VC_Bills", nil);
    _lasViewSelectisBillView = YES;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_BIL"];
}
-(void)networthBtnPressed:(UIButton *)sender
{
    if (_currentViewSelect == networthView)
    {
        return;
    }
    [self setAllModuleBtnStateNomal];
    self.networthModuleBtn.selected=YES;
    [self setAllBtnNormalImg];
     _lasViewSelectisBillView = NO;
    [self handleNetWorthView];
    self.appTitleLabel.text=NSLocalizedString(@"VC_NetWorth", nil);
}
-(void)cashflowBtnPressed:(UIButton *)sender
{
    if (_currentViewSelect == cashflowView)
    {
        return;
    }
    [self setAllModuleBtnStateNomal];
    self.cashflowModuleBtn.selected=YES;
    [self setAllBtnNormalImg];
    _lasViewSelectisBillView = NO;
    [self handleCashFlowView];
    self.appTitleLabel.text=NSLocalizedString(@"VC_CashFlow", nil);
}
-(void)summaryBtnPressed:(UIButton *)sender
{
    if (_currentViewSelect==summaryView)
    {
        return;
    }
    [self setAllModuleBtnStateNomal];
    self.summaryModuleBtn.selected=YES;
    [self setAllBtnNormalImg];
    _lasViewSelectisBillView = NO;
    [self handleSummaryView];
    self.appTitleLabel.text=NSLocalizedString(@"VC_Summary", nil);
}
-(void)categoryBtnPressed:(UIButton *)sender
{
    if (_currentViewSelect==categoryView)
    {
        return;
    }
    [self setAllModuleBtnStateNomal];
    self.categoryModuleBtn.selected=YES;
    [self setAllBtnNormalImg];
    _lasViewSelectisBillView = NO;
    [self handleCategoryView];
    self.appTitleLabel.text=NSLocalizedString(@"VC_Category", nil);

}
-(void)settingModuleBtnAction:(id)sender
{
    _iSettingViewController = [[ipad_SettingViewController alloc]initWithNibName:@"ipad_SettingViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iSettingViewController];
	AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
 	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
 	appDelegate1.mainViewController.popViewController = navigationController;
    appDelegate1.mainViewController.popViewController.view.tag = 100;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           0,
//                                                           480,
//                                                           490
//                                                           );
    
 	navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;

}

-(void)searchBtnPressed:(id)sender
{
    if (_searchViewController == nil)
    {
        _searchViewController = [[ipad_SearchViewController alloc]initWithNibName:@"ipad_SearchViewController" bundle:nil];
    }
    _searchViewController.firstToBeHere = NO;
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:_searchViewController];

    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate.AddPopoverController = [[UIPopoverController alloc]initWithContentViewController:navi];
    appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320, 306);
    [appDelegate.AddPopoverController presentPopoverFromRect:CGRectMake(SCREEN_WIDTH-15, 30, 58, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

-(void)presentaTransactionViewController:(Transaction *)trans
{
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate1.AddPopoverController dismissPopoverAnimated:YES];
    
    ipad_TranscactionQuickEditViewController * iTransactionQuickEditViewController=[[ipad_TranscactionQuickEditViewController alloc]initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    iTransactionQuickEditViewController.transaction = trans ;
    iTransactionQuickEditViewController.typeoftodo = @"IPAD_EDIT";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:iTransactionQuickEditViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate1.mainViewController.popViewController = navigationController ;
    [self presentViewController:navigationController animated:YES completion:nil];
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
}

-(void)handleDateOverView
{
    [self removeCurrentMoudleView];
    _currentViewSelect  = overView;

    if(_overViewController == nil)
	{
		_overViewController= [[iPad_OverViewViewController alloc] initWithNibName:@"iPad_OverViewViewController" bundle:nil];
		_overViewController.view.frame =CGRectMake(80, 64, IPAD_WIDTH, IPAD_HEIGHT);
 	}
    [_contentView addSubview:_overViewController.view];


    [_overViewController refleshData];
    
}

-(void)handleDateAccountView
{
    [self removeCurrentMoudleView];
    if(_iAccountViewController == nil)
	{
		_iAccountViewController= [[ipad_AccountViewController alloc] initWithNibName:@"ipad_AccountViewController" bundle:nil];
		_iAccountViewController.view.frame =CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
 	}
    _currentViewSelect  = accountView;
    [_contentView addSubview:_iAccountViewController.view];

    
    [_iAccountViewController reFlashTableViewData];
    
}

-(void)handleDateBudgetView
{
    [self removeCurrentMoudleView];
    
    if(_iBudgetViewController == nil)
	{
		_iBudgetViewController= [[ipad_BudgetViewController alloc] initWithNibName:@"ipad_BudgetViewController" bundle:nil];
		_iBudgetViewController.view.frame =CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
 	}
    _currentViewSelect  = budgetView;

    [_contentView addSubview:_iBudgetViewController.view];

    
    [_iBudgetViewController reFlashTableViewData];
    
}
-(void)handleNetWorthView
{
    [self removeCurrentMoudleView];

    _iNetworthViewController=[[NetWorthViewController_iPad alloc]initWithNibName:@"NetWorthViewController_iPad" bundle:nil];
    _iNetworthViewController.view.frame=CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
    
    _currentViewSelect=networthView;
    [_contentView addSubview:_iNetworthViewController.view];
}
-(void)handleCashFlowView
{
    [self removeCurrentMoudleView];

    _iCashflowViewController=[[CashFlowViewController_iPad alloc]initWithNibName:@"CashFlowViewController_iPad" bundle:nil];
    _iCashflowViewController.view.frame=CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
    _currentViewSelect=cashflowView;
    [_contentView addSubview:_iCashflowViewController.view];

}
-(void)handleSummaryView
{
    [self removeCurrentMoudleView];

    _iSummaryViewController=[[summaryVC_iPad alloc]init];
    _iSummaryViewController.view.frame=CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);

    _currentViewSelect=summaryView;
    [_contentView addSubview:_iSummaryViewController.view];
}
-(void)handleCategoryView
{
    [self removeCurrentMoudleView];

    _iCategoryViewController=[[CategoryViewController_iPad alloc]init];
    _iCategoryViewController.view.frame=CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);

    _currentViewSelect=categoryView;
    [_contentView addSubview:_iCategoryViewController.view];
}
-(void)handleDateReportView
{
    [self removeCurrentMoudleView];
    
    
    if(_iReportRootViewController == nil)
    {
        _iReportRootViewController= [[ipad_ReportRootViewController alloc] initWithNibName:@"ipad_ReportRootViewController" bundle:nil];
        _iReportRootViewController.view.frame =CGRectMake(80, 64, IPAD_WIDTH, IPAD_HEIGHT);
    }
    _currentViewSelect  = reportView;
    
    [_contentView addSubview:_iReportRootViewController.view];
    
    
    [self.iReportRootViewController reFlashTableViewData];
}

-(void)handleDateBillView
{
    [self removeCurrentMoudleView];
    _currentViewSelect  = billsView;

    if(_iBillsViewController == nil)
	{
        //第一次初始化的时候，会初始化logic
		_iBillsViewController= [[ipad_BillsViewController alloc] initWithNibName:@"ipad_BillsViewController" bundle:nil];
		_iBillsViewController.view.frame =CGRectMake(80, 44, IPAD_WIDTH, IPAD_HEIGHT);
 	}

    [_contentView addSubview:_iBillsViewController.view];

    
    [_iBillsViewController reFlashBillModuleViewData];
    
    
}

-(void)removeCurrentMoudleView
{
    if(_currentViewSelect== overView)
    {
        [self.overViewController.view removeFromSuperview];
    }
	if(_currentViewSelect == accountView )
	{
		[self.iAccountViewController.view removeFromSuperview];
	}
    else if (_currentViewSelect == budgetView)
    {
        [self.iBudgetViewController.view removeFromSuperview];
    }
	else if(_currentViewSelect == billsView )
	{
		[self.iBillsViewController.view removeFromSuperview];
	}
    
	else if(_currentViewSelect == reportView )
	{
        [_iReportRootViewController.view removeFromSuperview];
	}
    else if (_currentViewSelect == networthView)
    {
        [_iNetworthViewController.view removeFromSuperview];
    }
    else if (_currentViewSelect==cashflowView)
    {
        [_iCashflowViewController.view removeFromSuperview];
    }
    else if (_currentViewSelect==summaryView)
    {
        [_iSummaryViewController.view removeFromSuperview];
    }
    else if (_currentViewSelect==categoryView)
    {
        [_iCategoryViewController.view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)syncBtnPressed:(id)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ParseDBManager sharedManager]dataSyncWithServer];
    });
}
-(void)syncAnimationStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = NO;
        rotationAnimation.repeatCount = NSIntegerMax;
        
        [_syncBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
-(void)syncAnimationStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_syncBtn.layer removeAllAnimations];
        
        NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        [center removeObserver:self];
    });
}
@end

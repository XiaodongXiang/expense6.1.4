//
//  InAppPurchaseManager.m
//  VectorScanner
//
//  Created by Tommy Zhuang on 8/27/12.
//  Copyright (c) 2012 Tommy Zhuang. All rights reserved.
//

#import "InAppPurchaseManager.h"
//#import "InAppPurchaseViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"
#import "OverViewWeekCalenderViewController.h"
#import "ExpenseViewController.h"
#import "SettingViewController.h"

#import "iPad_OverViewViewController.h"
#import "ipad_SettingViewController.h"

#import "ADSDeatailViewController.h"
#import "ipad_ADSDeatailViewController.h"
#import "BudgetViewController.h"

#import <Parse/Parse.h>

@interface InAppPurchaseManager()
@property(nonatomic, strong)NSMutableDictionary* muDic;

@end
@implementation InAppPurchaseManager
@synthesize delegate,proUpgradeProduct;
//@synthesize alertView;
//@synthesize indicator;


#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnRestoreReceipt:) name:@"returnRestoreReceipt" object:nil];
    }
    return self;
}

-(void)dealloc
{
    // NSLog(@"----> remove transcation <----");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)returnRestoreReceipt:(NSNotification *)notif{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate hideIndicator];

    NSDictionary* dic = [notif object];
    NSArray* newarray = [dic objectForKey:@"latest_receipt_info"];
    
    NSArray* array = [newarray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"expires_date" ascending:YES]]];
    
//    NSLog(@"array == %@",array);
    NSDictionary* lastReceipt = [array lastObject];
    
    if (!lastReceipt) {
        [[XDDataManager shareManager] removeSettingPurchase];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
        
        appDelegate.isPurchased = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
        
        return;
    }
    //    NSLog(@"lastReceipt = %@",[notif object]);

    NSString* purchasedStr = [lastReceipt valueForKey:@"purchase_date"];
    NSString* expiresStr =[lastReceipt valueForKey:@"expires_date"];
    NSString* productID = [lastReceipt valueForKey:@"product_id"];
//    NSString* originalTransacionID = [lastReceipt valueForKey:@"original_transaction_id"];
    
    if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
        [[XDDataManager shareManager] puchasedInfoInSetting:[NSDate date] productID:kInAppPurchaseProductIdLifetime originalProID:nil];
        appDelegate.isPurchased = YES;
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProImage" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"settingReloadData" object:nil];

        
        [self finishSomeUnfinishTransaction];
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
        
        if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
        }
        
        [[XDDataManager shareManager] puchasedInfoInSetting:purchaseDate productID:productID originalProID:nil];
        appDelegate.isPurchased = YES;
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProImage" object:nil];

    }else{  //没续订
        [[XDDataManager shareManager] removeSettingPurchase];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
        
        appDelegate.isPurchased = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Error", nil) message:NSLocalizedString(@"VC_A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            [restoreAlert show];
        });
    }
    
    [self finishSomeUnfinishTransaction];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"settingReloadData" object:nil];

}


-(void)finishSomeUnfinishTransaction{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0)
    {
        //检测是否有未完成的交易
        for (SKPaymentTransaction *transaction in transactions)
        {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased)
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }

        }
    }
}

//－－－－－－－－－－－－－－－－－－请求获取商品信息－－－－－－－－－－－－－－－－－－
#pragma Public methods
//1.请求商品信息
- (void)requestProUpgradeProductData
{
    self.muDic = [NSMutableDictionary dictionary];
    
    NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchaseProductIdLifetime,KInAppPurchaseProductIdMonth,KInAppPurchaseProductIdYear,nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    // we will release the request object in the delegate callback
}

//2.请求商品信息，获得反馈
#pragma mark SKProductsRequestDelegate methods
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"SKProductsRequestDelegate error - %@",error);
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Purchase Stopped", nil) message:NSLocalizedString(@"VC_Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [failedAlert show];
    });
    
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{

    NSArray *myProduct = response.products;
    
    double monthPrice = 0;
    double yearPrice = 0;
    // populate UI
    for(SKProduct *product in myProduct){
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
        
        [self.muDic setObject:product forKey:product.productIdentifier];

        [delegate updateTheBarTitleWithPrice: [product.price doubleValue] withLocal:product.priceLocale productID:product.productIdentifier];

        if ([product.productIdentifier isEqualToString:KInAppPurchaseProductIdMonth]) {
            monthPrice = [product.price doubleValue];
        }else if ([product.productIdentifier isEqualToString:KInAppPurchaseProductIdYear]){
            yearPrice = [product.price doubleValue];
        }
        
    }
    double sale = (monthPrice * 12 - yearPrice)/(monthPrice * 12) * 100;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:sale] forKey:@"salePrice"];
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
//    [productsRequest release];
    
//    请求商品信息成功，发送通知做什么？
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}




//－－－－－－－－－－－－－－－－－－请求获取商品信息结束－－－－－－－－－－－－－－－－－－


//－－－－－－－－－－－－－－－－－－外部调用方法－－－－－－－－－－－－－－－－－－－
//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
//   [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
    
}
//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{

    if(proUpgradeProduct == nil){
      return;
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
    
    SKPayment *payment = [SKPayment paymentWithProduct: proUpgradeProduct];
    //每次增加一个payment的时候都需要重新设置transactionObserver
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)addTransactionObserver{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


-(void)removeTransactionObserver{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)purchaseUpgrade:(NSString*)productID
{
    [self finishSomeUnfinishTransaction];
    
    SKProduct* product = self.muDic[productID];
    if (!product) {
        [self requestProUpgradeProductData];
        return;
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
   
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    //每次增加一个payment的时候都需要重新设置transactionObserver
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"信息反馈结束");
}

- (void)restorePurchase
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
//－－－－－－－－－－－－－－－－－－外部调用方法结束－－－－－－－－－－－－－－－－－－－


- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
//    NSLog(@"transaction == %@ -- %@",transaction.transactionIdentifier,transaction.payment.productIdentifier);

    
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionIdentifier forKey:@"originalTransactionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//在本地标记允许pro功能
- (void)provideContent:(NSString *)productId purchaseDate:(NSDate*)date originaProID:(NSString*)originaProID
{
    NSDate* newDate = date?:[NSDate date];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

//    Setting* setting =[[ XDDataManager shareManager]getSetting];

    if ([productId isEqualToString:kInAppPurchaseProductIdLifetime])
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];

        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
//        [[XDDataManager shareManager] puchasedInfoInSetting:newDate productID:kInAppPurchaseProductIdLifetime];
        
        appDelegate.isPurchased = YES;

        // enable the pro features
    }else if ([productId isEqualToString:KInAppPurchaseProductIdMonth]){
        
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:LITE_UNLOCK_FLAG]) {
            appDelegate.isPurchased = YES;
            return;
        }
        
        [[XDDataManager shareManager] puchasedInfoInSetting:newDate productID:KInAppPurchaseProductIdMonth originalProID:originaProID];
        appDelegate.isPurchased = YES;
        
    }else if ([productId isEqualToString:KInAppPurchaseProductIdYear]){
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];

        if ([[NSUserDefaults standardUserDefaults] objectForKey:LITE_UNLOCK_FLAG]) {
            appDelegate.isPurchased = YES;
            return;
        }
        [[XDDataManager shareManager] puchasedInfoInSetting:newDate productID:KInAppPurchaseProductIdYear originalProID:originaProID];

        appDelegate.isPurchased = YES;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"settingReloadData" object:nil];

}

//购买成功之后移除观察者
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful isRestore:(BOOL)isRestore
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];

    
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        if (isRestore)
        {
            UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"VC_Restore purchase successfully!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [restoreAlert show];
            });
            appDelegate.appAlertView = restoreAlert;
            if (!isPad) {
//                AppDelegate_iPhone *appdelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProImage" object:nil];
            }
        }
        else
        {
            //购买成功的提示
        }
        
        //购买成功，刷新一些界面的功能
        if (isPad)
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            if (appDelegate.mainViewController.popViewController != nil)
            {
                //setting里restore，直接刷新
                if (appDelegate.mainViewController.popViewController.view.tag == 100 )
                {
                    [appDelegate.mainViewController.iSettingViewController hideOrShowAds];
                }
                else
                {
                    [appDelegate.mainViewController.overViewController hideorShowAds];
                    [appDelegate.mainViewController.popViewController dismissViewControllerAnimated:YES completion:nil];
                }
                
            }
        }
        else
        {
            AppDelegate_iPhone *appdelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//            [appdelegate_iPhone  hideAds:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissADSView" object:nil];
            //remove adsDetailView
            if (appdelegate_iPhone.overViewController.settingViewController.adsDetailViewController != nil)
            {
                [appdelegate_iPhone.overViewController.settingViewController.adsDetailViewController contentViewDisAppear];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"settingReloadData" object:nil];
            }
            [appdelegate_iPhone.adsView removeFromSuperview];
        }
    }
    //购买失败，应该提醒用户什么信息？
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        
//        Setting* setting = [[XDDataManager shareManager] getSetting];
//        NSDate* date = setting.purchasedStartDate;
//        NSString* purchasedID = setting.purchasedProductID;
//
//        if (purchasedID && date) {
//            if ([purchasedID isEqualToString:kInAppPurchaseProductIdLifetime]) {
//                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:LITE_UNLOCK_FLAG];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                appDelegate.isPurchased = YES;
//            }else{
//                NSDate* expiredTime = setting.purchasedEndDate;
//
//                NSTimeInterval timeInterval = [expiredTime timeIntervalSinceDate:[NSDate date]];
//                if (timeInterval <= 0) {
//                    //要提示重新订阅
//                    [[XDDataManager shareManager]openWidgetInSettingWithBool14:NO];
//
//                    appDelegate.isPurchased = NO;
//                    [appDelegate insertAdsMob];
//
//                    [[XDDataManager shareManager] removeSettingPurchase];
//                }
//            }
//            if ([purchasedID isEqualToString:KInAppPurchaseProductIdMonth]) {
//                NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
//                // 修改订阅测试时间
//                //            comp.month += 1;
//                //            comp.day += 1;
//                comp.minute += 5;
//                NSDate* expiredTime = [[NSCalendar currentCalendar] dateFromComponents:comp];
//
//                NSTimeInterval timeInterval = [expiredTime timeIntervalSinceDate:[NSDate date]];
//                if (timeInterval <= 0) {
//                    //要提示重新订阅
//                    [[XDDataManager shareManager]openWidgetInSettingWithBool14:NO];
//
//                    appDelegate.isPurchased = NO;
//                    [appDelegate insertAdsMob];
//
//                    [[XDDataManager shareManager] removeSettingPurchase];
//                }
//            }else if ([purchasedID isEqualToString:KInAppPurchaseProductIdYear]){
//                NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
//                // 修改订阅测试时间
//                //            comp.year += 1;
//                //            comp.day += 1;
//                comp.hour += 1;
//                NSDate* expiredTime = [[NSCalendar currentCalendar] dateFromComponents:comp];
//
//                NSTimeInterval timeInterval = [expiredTime timeIntervalSinceDate:[NSDate date]];
//                if (timeInterval <= 0) {
//                    //要提示重新订阅
//                    [[XDDataManager shareManager]openWidgetInSettingWithBool14:NO];
//
//                    appDelegate.isPurchased = NO;
//                    [appDelegate insertAdsMob];
//
//                    [[XDDataManager shareManager] removeSettingPurchase];
//
//                }
//            }else{
//                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:LITE_UNLOCK_FLAG];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                appDelegate.isPurchased = YES;
//            }
//        }
        
        
        //send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
        
        if (isRestore)
        {
            UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Error", nil) message:NSLocalizedString(@"VC_A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [restoreAlert show];
            });
            appDelegate.appAlertView = restoreAlert;
        }
        else
        {
            UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Purchase Stopped", nil) message:NSLocalizedString(@"VC_Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [failedAlert show];
            });
            appDelegate.appAlertView = failedAlert;
        }
        
    }
}


//-----------------购买成功
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (![PFUser currentUser]) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        return;
    }
    
    //不需要记录产品信息吧
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier purchaseDate:transaction.transactionDate originaProID:transaction.originalTransaction.transactionIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES isRestore:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

}

//------------------恢复购买成功
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier purchaseDate:transaction.transactionDate originaProID:transaction.originalTransaction.transactionIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES isRestore:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

}



//------------------购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
//    NSLog(@"transaction.error.code == %ld",transaction.error.code);
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO isRestore:NO];        
    }
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

        UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Purchase Stopped", nil) message:NSLocalizedString(@"VC_Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
        [failedAlert show];
        appDelegate.appAlertView = failedAlert;
        // this is fine, the user just cancelled, so don’t notify
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];

}



//------------------------------购买商品代理------------------------------------
#pragma mark -
#pragma mark SKPaymentTransactionObserver methods
//当transaction的状态发生改变时，购买状态发生改变时会调用这个
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    
    if (transactions.count > 1) {
        SKPaymentTransaction* transaction = transactions.firstObject;

        NSArray* lifetimeArr = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"payment.productIdentifier = %@",kInAppPurchaseProductIdLifetime]];
        if (lifetimeArr.count > 0) {
            NSArray* sortArr = [lifetimeArr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate" ascending:NO]]];
            transaction = sortArr.firstObject;
        }else{
            NSArray* sortArr = [transactions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate" ascending:NO]]];
            transaction = sortArr.firstObject;
//            NSArray* yearArr = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"payment.productIdentifier = %@",KInAppPurchaseProductIdYear]];
//            if (yearArr.count > 0) {
//                NSArray* sortArr = [yearArr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate" ascending:NO]]];
//                transaction = sortArr.firstObject;
//            }else{
//                NSArray* monthArr = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"payment.productIdentifier = %@",KInAppPurchaseProductIdMonth]];
//                if (monthArr.count > 0) {
//                    NSArray* sortArr = [monthArr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate" ascending:NO]]];
//                    transaction = sortArr.firstObject;
//                }
//            }
        }
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
        if (transaction) {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchased:
                    
                    [self completeTransaction:transaction];
                    [appDelegate  hideIndicator];
                   
                    
                    break;
                case SKPaymentTransactionStateRestored:{
//                    NSLog(@"date == %@, id == %@",transaction.transactionDate,transaction.transactionIdentifier);
                    if (![transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProductIdLifetime]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
//                            expensePurchase* expense = [[expensePurchase alloc]init];
//                            [expense requestRestore];
                        });
                    }else{
                        
                        [self completeTransaction:transaction];
                        [appDelegate  hideIndicator];

                        [[NSNotificationCenter defaultCenter]postNotificationName:@"settingReloadData" object:nil];
                    }
                   
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

//                    [self restoreTransaction:transaction];
//                    [appDelegate  showIndicator];
                }
                    break;
                    //购买成功与恢复购买成功都跑这里。
                case SKPaymentTransactionStateFailed:
                    
                    [self failedTransaction:transaction];
                    [appDelegate  hideIndicator];
                    
                    
                    break;
                case SKPaymentTransactionStatePurchasing:
                {
                    
                }
                    
                    break;
                default:
                    break;
            }
        }
        
    }else if(transactions.count == 1){
        SKPaymentTransaction* transaction = transactions.firstObject;
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchased:
                    
                    [self completeTransaction:transaction];
                    [appDelegate  hideIndicator];

                    break;
                case SKPaymentTransactionStateRestored:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        expensePurchase* expense = [[expensePurchase alloc]init];
//                        [expense requestRestore];
                    });
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                }
                    break;
                    //购买成功与恢复购买成功都跑这里。
                case SKPaymentTransactionStateFailed:
                    [self failedTransaction:transaction];
                    [appDelegate  hideIndicator];
                    
                    break;
                case SKPaymentTransactionStatePurchasing:
                {
                }
                    
                    break;
                default:
                    break;
            }
        
    }
}
//
//- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
//{
//    return YES;
//}

//恢复购买检测结果出来
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
    //回复失败的提醒
    if ([queue.transactions count] == 0)
    {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        [self incompleteRestore];
    }
    
//    NSArray* array = queue.transactions;
//    for  (SKPaymentTransaction* transaction in array) {
//        NSLog(@"transaction == %ld   -  %@ --- %@",(long)transaction.transactionState,transaction.payment.productIdentifier,transaction.transactionDate);
//    }
//
//
//    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
//    if (transactions.count > 0)
//    {
//        //检测是否有未完成的交易
//        for (SKPaymentTransaction *transaction in transactions)
//        {
//            if (transaction.transactionState == SKPaymentTransactionStatePurchased)
//            {
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//            }
//        }
//    }

    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

}

//恢复完成购买出现问题
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restoreCompletedTransactionsFailedWithError");
    [self incompleteRestore_restorewithError];
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

// Called when one or more transactions have been removed from the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"EBPurchase removedTransactions");
    
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
//    for (SKPaymentTransaction *transaction in transactions)
//    {
//        if (transaction.transactionState == SKPaymentTransactionStatePurchased)
//        {
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//        }
//
//    }
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];

    
}


//-----------------恢复购买失败
-(void) incompleteRestore
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];

    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Error", nil) message:NSLocalizedString(@"VC_A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
    [restoreAlert show];
    appDelegate.appAlertView = restoreAlert;

}

-(void)incompleteRestore_restorewithError
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate  hideIndicator];

    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Stopped", nil) message:NSLocalizedString(@"VC_Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
    [failedAlert show];
    appDelegate.appAlertView = failedAlert;


}









@end

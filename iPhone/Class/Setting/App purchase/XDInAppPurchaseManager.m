//
//  XDInAppPurchaseManager.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/29.
//

#import "XDInAppPurchaseManager.h"
#import <StoreKit/StoreKit.h>
#import "PokcetExpenseAppDelegate.h"

#import "Pocket_Expense-Swift.h"

#define LITE_UNLOCK_FLAG    @"isProUpgradePurchased"

@interface XDInAppPurchaseManager ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic, strong)NSMutableDictionary* productDic;

@end
@implementation XDInAppPurchaseManager

+(XDInAppPurchaseManager*)shareManager{
    
    static XDInAppPurchaseManager* g_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_manager = [[XDInAppPurchaseManager alloc]init];
    });
    return g_manager;
}

-(void)dealloc{
    [self removeTransactionObserver];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnRestoreReceipt:) name:@"returnRestoreReceipt" object:nil];
    }
    return self;
}


-(void)getProductInfo{
    self.productDic = [NSMutableDictionary dictionary];

    NSLog(@"---------请求对应的产品信息------------");
    NSSet *nsset = [NSSet setWithObjects:kInAppPurchaseProductIdLifetime,KInAppPurchaseProductIdMonth,KInAppPurchaseProductIdYear,nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}



#pragma mark - SKRequestDelegate
- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray* productArr = response.products;
    if (productArr.count==0)
    {
        NSLog(@"无法获取产品信息，购买失败");
        return;
    }
    double monthPrice = 0;
    double yearPrice = 0;
    for(SKProduct *product in productArr){

        [self.productDic setObject:product forKey:product.productIdentifier];
        
        if ([product.productIdentifier isEqualToString:KInAppPurchaseProductIdMonth]) {
            monthPrice = [product.price doubleValue];
        }else if ([product.productIdentifier isEqualToString:KInAppPurchaseProductIdYear]){
            yearPrice = [product.price doubleValue];
        }
        [self updateTheBarTitleWithPrice: [product.price doubleValue] withLocal:product.priceLocale productID:product.productIdentifier];

    }
    double sale = (monthPrice * 12 - yearPrice)/(monthPrice * 12) * 100;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:sale] forKey:@"salePrice"];
    
//    [[NSUserDefaults standardUserDefaults] setObject:productDic forKey:salePriceData];

}
//内购流程2:获取商品信息成功之后，把商品信息存储起来，发送通知让相关页面把价格显示出来
-(void)updateTheBarTitleWithPrice:(double)p withLocal:(NSLocale*)l productID:(NSString*)productID
{
    //保存商品的价格信息到本地，方便没网的时候获取
    NSNumberFormatter *numberFmt =[[NSNumberFormatter alloc] init];
    [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFmt setLocale:l];
    [numberFmt setMaximumFractionDigits:2];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([productID isEqualToString:KInAppPurchaseProductIdMonth]) {
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_MONTH];
    }else if ([productID isEqualToString:KInAppPurchaseProductIdYear]){
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_YEAR];
    }else if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]){
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_LIFETIME];
    }
    [userDefaults synchronize];
    
    //发送通知，让ads detail页面金额改变.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:GET_PRO_VERSION_PRICE_ACTION object:nil];
}

-(void)purchaseUpgrade:(NSString*)productID{
    if ([SKPaymentQueue canMakePayments]) {
        if (self.productDic) {
            SKProduct* product = self.productDic[productID];
            if (product) {
                PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
                [appDelegate showIndicator];
                
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
                
                SKPayment* payment = [SKPayment paymentWithProduct:product];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }else{
                [self getProductInfo];
            }
        }else{
            [self getProductInfo];
        }
        
    }else{
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}

-(void)restoreUpgrade{
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -
#pragma mark - 购买产品

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    
    SKPaymentTransaction *transaction = transactions.lastObject;
    
    NSArray* lifetimeArr = [transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"payment.productIdentifier = %@",kInAppPurchaseProductIdLifetime]];
     if (lifetimeArr.count > 0) {
         transaction = lifetimeArr.lastObject;
     }
    switch (transaction.transactionState)
    {
        case SKPaymentTransactionStatePurchasing:      //点击购买按钮添加支付队列，商品添加进列表
            //Update your UI to reflect the in-progress status, and wait to be called again.
            NSLog(@"-----商品添加进列表 --------");
            break;
        case SKPaymentTransactionStateDeferred:
            //Update your UI to reflect the deferred status, and wait to be called again.
            NSLog(@"-----交易延期—－－－－");
            break;
        case SKPaymentTransactionStatePurchased://交易完成
            
            if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProductIdLifetime]) {
                PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
                [appDelegate hideIndicator];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
                [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
                appDelegate.isPurchased = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
                
            }else{
                [self completeTransaction:transaction];
            }
            NSLog(@"-----交易完成 --------");
            break;
        case SKPaymentTransactionStateFailed://交易失败
            [self failedTransaction:transaction];
            NSLog(@"-----交易失败 --------");
            break;
        case SKPaymentTransactionStateRestored://已经购买过该商品
            [self restoreTransaction:transaction];
            NSLog(@"-----已经购买过该商品 --------");
            break;
    }
}


-(void)completeTransaction:(SKPaymentTransaction*)transaction{
//    expensePurchase* expense = [[expensePurchase alloc]init];
//    [expense completeTransactionReceipt];
    
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate hideIndicator];
    
    NSString* proID = transaction.payment.productIdentifier;
    NSDate* purchaseDate = transaction.transactionDate;
    NSString* originalProID = transaction.originalTransaction.transactionIdentifier;
    
    if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
        [[XDDataManager shareManager]puchasedInfoInSetting:purchaseDate productID:KInAppPurchaseProductIdMonth originalProID:originalProID];
    }else if([proID isEqualToString:KInAppPurchaseProductIdYear]){
         [[XDDataManager shareManager]puchasedInfoInSetting:purchaseDate productID:KInAppPurchaseProductIdYear originalProID:originalProID];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
    }
    
    [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
    appDelegate.isPurchased = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self finishSomeUnfinishTransaction];

    
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction{
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate hideIndicator];
    
//    NSLog(@"交易失败2 %@",transaction.error);
//    if (transaction.error.code == SKErrorPaymentCancelled)
//    {
//        [self showAlertControllerTitle:@"Hint" Message:@"You have cancelled your purchase."];
//    }
//    else if(transaction.error.code==SKErrorPaymentInvalid)
//    {
//        [self showAlertControllerTitle:@"Hint" Message:@"Pay is invalid"];
//    }
//    else if(transaction.error.code==SKErrorPaymentNotAllowed)
//    {
//        [self showAlertControllerTitle:@"Hint" Message:@"No payment"];
//    }
//    else if(transaction.error.code==SKErrorStoreProductNotAvailable)
//    {
//        [self showAlertControllerTitle:@"Hint" Message:@"The product is invalid"];
//    }
//    else if(transaction.error.code==SKErrorClientInvalid)
//    {
//        [self showAlertControllerTitle:@"Hint" Message:@"Invalid client"];
//    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    [self finishSomeUnfinishTransaction];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
}

//- (void)showAlertControllerTitle:(NSString *)title Message:(NSString *)message
//{
//    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
//    [failedAlert show];
//}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction{
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];

    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProductIdLifetime]) {
        appDelegate.isPurchased = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LITE_UNLOCK_FLAG];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

        [appDelegate hideIndicator];
    }else{
        expensePurchase* expense = [[expensePurchase alloc]init];
        [expense requestRestore];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self finishSomeUnfinishTransaction];
}


-(void)addTransactionObserver{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

 
-(void)removeTransactionObserver{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog(@"%@",purchasedItemIDs);
    }
    
    [self finishSomeUnfinishTransaction];

    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate hideIndicator];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate hideIndicator];
}

#pragma mark - function
//-(void)completeTransactionReceipt:(NSNotification*)notif{
//    NSDictionary* dic = [notif object];
//    NSArray* newArray = [dic objectForKey:@"latest_recript_info"];
//    NSDictionary* lastReceipt = [newArray lastObject];
//
//    if (lastReceipt) {
//        NSString* purchasedStr = [lastReceipt valueForKey:@"purchase_date"];
//        NSString* productID = [lastReceipt valueForKey:@"product_id"];
//        NSString* originalID = [lastReceipt valueForKey:@"original_transacation_id"];
//
//        if (![productID isEqualToString:kInAppPurchaseProductIdLifetime]) {
//            NSString* purchaseSubStr = [purchasedStr substringToIndex:purchasedStr.length - 7];
//            NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
//            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate* purchaseDate = [dateFormat dateFromString:purchaseSubStr];
//
//            [[XDDataManager shareManager] puchasedInfoInSetting:purchaseDate productID:productID originalProID:originalID];
//        }
//    }
//}

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

        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];
        [appDelegate insertAdsMob];
        
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
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProImage" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

        
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

    }else{  //没续订
        [[XDDataManager shareManager] removeSettingPurchase];
        [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
        
        appDelegate.isPurchased = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

        [appDelegate insertAdsMob];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Error", nil) message:NSLocalizedString(@"VC_A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            [restoreAlert show];
        });
    }
    
    [self finishSomeUnfinishTransaction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingReloadData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSettingUI" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseSuccessful" object:nil];

}


-(void)finishSomeUnfinishTransaction{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0)
    {
        //检测是否有未完成的交易
        for (SKPaymentTransaction *transaction in transactions)
        {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored)
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
            
        }
    }
}

#pragma mark - other

-(NSString*)stringWithLocalPrice:(NSLocale*)local price:(double)price{
    //保存商品的价格信息到本地，方便没网的时候获取
    NSNumberFormatter *numberFmt =[[NSNumberFormatter alloc] init];
    [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFmt setLocale:local];
    [numberFmt setMaximumFractionDigits:2];
    return [numberFmt stringFromNumber:[NSNumber numberWithDouble:price]];
}


@end

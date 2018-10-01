//
//  XDInAppPurchaseManager.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/29.
//

#import "XDInAppPurchaseManager.h"
#import <StoreKit/StoreKit.h>

#define salePriceData @"salePriceData"

@interface XDInAppPurchaseManager ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

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




-(void)getProductInfo{
    
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
    NSDictionary* productDic = [NSDictionary dictionary];
    for(SKProduct *product in productArr){
//        NSString * priceStr = [self stringWithLocalPrice:product.priceLocale price:[product.price doubleValue]];
        [productDic setValue:product forKey:product.productIdentifier];
    }
    [[NSUserDefaults standardUserDefaults] setObject:productDic forKey:salePriceData];

}

-(void)purchaseUpgrade:(NSString*)productID{
    if ([SKPaymentQueue canMakePayments]) {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:salePriceData];
        if (dic) {
            SKProduct* product = dic[productID];
            if (product) {
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

#pragma mark -
#pragma mark - 购买产品

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    SKPaymentTransaction *transaction = transactions.lastObject;

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
            [self completeTransaction:transaction];
            NSLog(@"-----交易完成 --------");
            break;
        case SKPaymentTransactionStateFailed://交易失败
            [self failedTransaction:transaction];
            NSLog(@"-----交易失败 --------");
            break;
        case SKPaymentTransactionStateRestored://已经购买过该商品
            //            [self restore];
            [self restoreTransaction:transaction];
            NSLog(@"-----已经购买过该商品 --------");
            break;
    }
}


-(void)completeTransaction:(SKPaymentTransaction*)transaction{
    
    
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction{
    
}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction{
    
}


-(void)addTransactionObserver{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


-(void)removeTransactionObserver{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
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

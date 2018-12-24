//
//  XDInAppPurchaseManager.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDInAppPurchaseManager : NSObject

+(XDInAppPurchaseManager*)shareManager;

-(void)getProductInfo;

-(void)purchaseUpgrade:(NSString*)productID;

-(void)restoreUpgrade;

-(void)addTransactionObserver;

-(void)removeTransactionObserver;

@end

NS_ASSUME_NONNULL_END

//
//  XDPurchasedManager.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPurchasedManager : NSObject

+(XDPurchasedManager*)shareManager;


-(void)getPFSetting;
-(void)savePFSetting;
-(void)saveDefaultParseSetting;
-(void)tryOutPremium30DaysWithNewUser;
@end

NS_ASSUME_NONNULL_END
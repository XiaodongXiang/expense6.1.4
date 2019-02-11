//
//  XDReceiptManager.h
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XDReceiptModel : NSObject
@property(nonatomic, strong)NSDate* purchaseDate;
@property(nonatomic, strong)NSDate* expiredDate;
@property(nonatomic, strong)NSString* productID;
@property(nonatomic, strong)NSString* originalProID;

@end


@interface XDReceiptManager : NSObject

+(instancetype)shareManager;

+(void)returnReceiptData:(void (^)(XDReceiptModel * model))completion;

@end



NS_ASSUME_NONNULL_END

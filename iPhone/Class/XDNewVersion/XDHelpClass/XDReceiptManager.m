//
//  XDReceiptManager.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/1/30.
//

//
//"auto_renew_product_id" 订阅的productID
//"auto_renew_status"
    //“1” - Subscription will renew at the end of the current subscription period.
    //“0” - Customer has turned off automatic renewal for their subscription.

//"expiration_intent" 此密钥仅适用于包含已过期的自动续订订阅的收据。可以使用此值来决定是否在应用中显示适当的消息，以便客户重新订阅。
    //“1” - Customer canceled their subscription.
    //“2” - Billing error; for example customer’s payment information was no longer valid.
    //“3” - Customer did not agree to a recent price increase.
    //“4” - Product was not available for purchase at the time of renewal.
    //“5” - Unknown error

//"is_in_billing_retry_period  此密钥仅适用于自动续订订阅收据。如果客户的订阅由于App Store无法完成交易而无法续订，则此值将反映App Store是否仍在尝试续订订阅。
    //“1” - App Store is still attempting to renew the subscription.
    //“0” - App Store has stopped attempting to renew the subscription


#define latest_receipt_info                     @"latest_receipt_info"
#define purchase_date                           @"purchase_date"
#define expires_date                            @"expires_date"
#define product_id                              @"product_id"
#define original_transaction_id                 @"original_transaction_id"


#import "XDReceiptManager.h"

@interface XDReceiptModel ()

@end

@implementation XDReceiptModel

+(instancetype)model{
    return [[XDReceiptModel alloc]init];
}

@end

@implementation XDReceiptManager

+ (instancetype)shareManager{
    static XDReceiptManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XDReceiptManager alloc]init];
    });
    return manager;
}


//先检查是否有终身receipt，有则返回，然后返回最新的回执
+(void)returnReceiptData:(void (^)(XDReceiptModel * model))completion
{
    
    NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    if (!receiptData) {
        if (completion) {
            completion(nil);
        }
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
                                              
                                              //终身用户需要检查 in_app
                                              NSDictionary* receiptArr = recerptDic[@"receipt"];
                                              NSArray* inAppArr = receiptArr[@"in_app"];
                                              if (inAppArr.count > 0) {
                                                  NSArray* lifetimeArr = [inAppArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"product_id = %@",kInAppPurchaseProductIdLifetime]];
                                                  if (lifetimeArr.count > 0) {
                                                      NSDictionary* lifetimeInfo = lifetimeArr.lastObject;
                                                      XDReceiptModel* model = [XDReceiptModel model];
                                                      model.purchaseDate = [self returnDateFormat:lifetimeInfo[purchase_date]] ;
                                                      model.productID = lifetimeInfo[product_id];
                                                      model.originalProID = lifetimeInfo[original_transaction_id];
                                                      if (completion) {
                                                          completion(model);
                                                          
                                                          return ;
                                                      }
                                                  }
                                              }
                                              NSArray* lastReceiptArr = recerptDic[@"latest_receipt_info"];
                                              NSArray* lifetimeArr = [lastReceiptArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"product_id = %@",kInAppPurchaseProductIdLifetime]];
                                              if (lifetimeArr.count > 0) {
                                                  NSDictionary* lifetimeInfo = lifetimeArr.lastObject;
                                                  XDReceiptModel* model = [XDReceiptModel model];
                                                  model.purchaseDate = [self returnDateFormat:lifetimeInfo[purchase_date]];
                                                  model.productID = lifetimeInfo[product_id];
                                                  model.originalProID = lifetimeInfo[original_transaction_id];

                                                  if (completion) {
                                                      completion(model);
                                                      
                                                      return ;
                                                  }
                                              }
                                              if (lastReceiptArr.count > 0) {
                                                  NSDictionary* lastReceiptInfo = lastReceiptArr.lastObject;
                                                  XDReceiptModel* model = [XDReceiptModel model];
                                                  model.purchaseDate = [self returnDateFormat:lastReceiptInfo[purchase_date]];
                                                  model.expiredDate = [self returnDateFormat:lastReceiptInfo[expires_date]];
                                                  model.productID = lastReceiptInfo[product_id];
                                                  model.originalProID = lastReceiptInfo[original_transaction_id];

                                                  if (completion) {
                                                      completion(model);
                                                  }
                                              }
                                          }else{
                                              if (completion) {
                                                  completion(nil);
                                              }
                                          }
                                          
                                          /* TODO: Unlock the In App purchases ...
                                           At this point the json dictionary will contain the verified receipt from Apple
                                           and each purchased item will be in the array of lineitems.
                                           */
                                      }];
    
    [datatask resume];
    
}

+(NSDate* )returnDateFormat:(NSString* )dateStr{
    NSString* purchaseSubStr = [dateStr substringToIndex:dateStr.length - 7];
    
    NSDateFormatter *dateFormant = [[NSDateFormatter alloc] init];
    [dateFormant setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* newDate = [dateFormant dateFromString:purchaseSubStr];
    return newDate;
}


@end



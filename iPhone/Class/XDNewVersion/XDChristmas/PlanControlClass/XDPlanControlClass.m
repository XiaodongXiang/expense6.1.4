//
//  XDPlanControlClass.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDPlanControlClass.h"
#import "PokcetExpenseAppDelegate.h"

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
    
    if (self.planType == ChristmasPlanA) {
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_plus"] forState:UIControlStateNormal];
        }
        
    }else{
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone 8plus"] forState:UIControlStateNormal];
        }
    }
}

-(BOOL)needShow{
    return YES;
}


-(ChristmasPlanType)planType{
//    return random()%2;
    return 0;
}

-(ChristmasSubPlan)planSubType{
//    return random()%2;
    return 0;
}

-(ChristmasPlanCategory)planCategory{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        
    }
    
    //    return random()%4;
    return 1;
}

-(void)validateReceipt
{
    
    NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData* receiptData = [NSData dataWithContentsOfURL:receiptUrl];
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
//                                              NSDictionary* pendingRenewal = [recerptDic[@"pending_renewal_info"] lastObject];
                                              NSDictionary* lastReceiptInfo = lastReceiptArr.lastObject;
                                              NSLog(@"receipt=== %@",lastReceiptInfo);
                                              
                                                
                                          }else{
                                              
                                              
                                          }
                                          
                                          
                                          /* TODO: Unlock the In App purchases ...
                                           At this point the json dictionary will contain the verified receipt from Apple
                                           and each purchased item will be in the array of lineitems.
                                           */
                                      }];
    
    [datatask resume];
}
@end

//
//  XDTransactionHelpClass.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import <Foundation/Foundation.h>

@interface XDTransactionHelpClass : NSObject

+(NSArray*)getCategroysWithTranscationType:(TransactionType)type;

+(NSArray*)getTransactionAccounts;

+(NSArray*)getPayeeWithTransactionType:(TransactionType)type;
@end

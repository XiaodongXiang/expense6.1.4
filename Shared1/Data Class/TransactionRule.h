//
//  TransactionRule.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface TransactionRule : NSManagedObject

@property (nonatomic, retain) NSString * cycleType;
@property (nonatomic, retain) NSDate * recordDate;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface TransactionRule (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end

//
//  Transaction.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Accounts, BillRule, Category, EP_BillItem, EP_BillRule, Payee, Transaction, TransactionRule;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * transactionBool;
@property (nonatomic, retain) NSNumber * isClear;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * others;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) id photoData;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * dateTime_sync;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) NSString * groupByDate;
@property (nonatomic, retain) NSString * transactionstring;
@property (nonatomic, retain) NSString * recurringType;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString *isUpload;
@property (nonatomic, retain) EP_BillItem *transactionHasBillItem;
@property (nonatomic, retain) EP_BillRule *transactionHasBillRule;
@property (nonatomic, retain) BillRule *billItem;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *childTransactions;
@property (nonatomic, retain) Accounts *expenseAccount;
@property (nonatomic, retain) TransactionRule *transactionRule;
@property (nonatomic, retain) Accounts *incomeAccount;
@property (nonatomic, retain) Transaction *parTransaction;
@property (nonatomic, retain) Payee *payee;

@end

@interface Transaction (CoreDataGeneratedAccessors)

- (void)addChildTransactionsObject:(Transaction *)value;
- (void)removeChildTransactionsObject:(Transaction *)value;
- (void)addChildTransactions:(NSSet *)values;
- (void)removeChildTransactions:(NSSet *)values;

@end

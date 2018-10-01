//
//  Accounts+CoreDataProperties.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/12/7.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Accounts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Accounts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *checkNumber;
@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *updatedTime;
@property (nullable, nonatomic, retain) NSString *others;
@property (nullable, nonatomic, retain) NSString *accName;
@property (nullable, nonatomic, retain) NSDate *dueDate;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSDate *dateTime;
@property (nullable, nonatomic, retain) NSNumber *autoClear;
@property (nullable, nonatomic, retain) NSDate *dateTime_sync;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSNumber *reconcile;
@property (nullable, nonatomic, retain) NSNumber *creditLimit;
@property (nullable, nonatomic, retain) NSString *objectId;
@property (nullable, nonatomic, retain) NSString *iconName;
@property (nullable, nonatomic, retain) NSNumber *runningBalance;
@property (nullable, nonatomic, retain) NSNumber *orderIndex;
@property (nullable, nonatomic, retain) NSNumber *accountColor;
@property (nullable, nonatomic, retain) NSSet<Transaction *> *expenseTransactions;
@property (nullable, nonatomic, retain) NSSet<BillRule *> *toBill;
@property (nullable, nonatomic, retain) NSSet<BillRule *> *fromBill;
@property (nullable, nonatomic, retain) TransactionReports *transactionRep;
@property (nullable, nonatomic, retain) NSSet<Transaction *> *incomeTransactions;
@property (nullable, nonatomic, retain) AccountType *accountType;

@end

@interface Accounts (CoreDataGeneratedAccessors)

- (void)addExpenseTransactionsObject:(Transaction *)value;
- (void)removeExpenseTransactionsObject:(Transaction *)value;
- (void)addExpenseTransactions:(NSSet<Transaction *> *)values;
- (void)removeExpenseTransactions:(NSSet<Transaction *> *)values;

- (void)addToBillObject:(BillRule *)value;
- (void)removeToBillObject:(BillRule *)value;
- (void)addToBill:(NSSet<BillRule *> *)values;
- (void)removeToBill:(NSSet<BillRule *> *)values;

- (void)addFromBillObject:(BillRule *)value;
- (void)removeFromBillObject:(BillRule *)value;
- (void)addFromBill:(NSSet<BillRule *> *)values;
- (void)removeFromBill:(NSSet<BillRule *> *)values;

- (void)addIncomeTransactionsObject:(Transaction *)value;
- (void)removeIncomeTransactionsObject:(Transaction *)value;
- (void)addIncomeTransactions:(NSSet<Transaction *> *)values;
- (void)removeIncomeTransactions:(NSSet<Transaction *> *)values;

@end

NS_ASSUME_NONNULL_END

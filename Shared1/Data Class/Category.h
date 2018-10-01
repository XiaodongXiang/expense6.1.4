//
//  Category.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillReports, BillRule, BudgetTemplate, EP_BillItem, EP_BillRule, Payee, Transaction, TransactionReports;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * others;
@property (nonatomic, retain) NSString * categoryString;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * categoryisIncome;
@property (nonatomic, retain) NSNumber * hasBudget;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * categoryisExpense;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSNumber * isSystemRecord;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSNumber * colorName;
@property (nonatomic, retain) NSNumber * recordIndex;
@property (nonatomic, retain) NSString * categoryType;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSSet *billItem;
@property (nonatomic, retain) BudgetTemplate *budgetTemplate;
@property (nonatomic, retain) TransactionReports *transactionRep;
@property (nonatomic, retain) NSSet *categoryHasBillRule;
@property (nonatomic, retain) BillReports *billRep;
@property (nonatomic, retain) NSSet *transactions;
@property (nonatomic, retain) NSSet *categoryHasBillItem;
@property (nonatomic, retain) NSSet *payee;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addBillItemObject:(BillRule *)value;
- (void)removeBillItemObject:(BillRule *)value;
- (void)addBillItem:(NSSet *)values;
- (void)removeBillItem:(NSSet *)values;

- (void)addCategoryHasBillRuleObject:(EP_BillRule *)value;
- (void)removeCategoryHasBillRuleObject:(EP_BillRule *)value;
- (void)addCategoryHasBillRule:(NSSet *)values;
- (void)removeCategoryHasBillRule:(NSSet *)values;

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

- (void)addCategoryHasBillItemObject:(EP_BillItem *)value;
- (void)removeCategoryHasBillItemObject:(EP_BillItem *)value;
- (void)addCategoryHasBillItem:(NSSet *)values;
- (void)removeCategoryHasBillItem:(NSSet *)values;

- (void)addPayeeObject:(Payee *)value;
- (void)removePayeeObject:(Payee *)value;
- (void)addPayee:(NSSet *)values;
- (void)removePayee:(NSSet *)values;

@end

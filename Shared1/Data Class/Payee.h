//
//  Payee.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRule, Category, EP_BillItem, EP_BillRule, Transaction;

@interface Payee : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * others;
@property (nonatomic, retain) NSNumber * tranAmount;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * tranCleared;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * tranMemo;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * tranType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *payeeHasBillRule;
@property (nonatomic, retain) NSSet *transaction;
@property (nonatomic, retain) NSSet *billItem;
@property (nonatomic, retain) NSSet *payeeHasBillItem;
@end

@interface Payee (CoreDataGeneratedAccessors)

- (void)addPayeeHasBillRuleObject:(EP_BillRule *)value;
- (void)removePayeeHasBillRuleObject:(EP_BillRule *)value;
- (void)addPayeeHasBillRule:(NSSet *)values;
- (void)removePayeeHasBillRule:(NSSet *)values;

- (void)addTransactionObject:(Transaction *)value;
- (void)removeTransactionObject:(Transaction *)value;
- (void)addTransaction:(NSSet *)values;
- (void)removeTransaction:(NSSet *)values;

- (void)addBillItemObject:(BillRule *)value;
- (void)removeBillItemObject:(BillRule *)value;
- (void)addBillItem:(NSSet *)values;
- (void)removeBillItem:(NSSet *)values;

- (void)addPayeeHasBillItemObject:(EP_BillItem *)value;
- (void)removePayeeHasBillItemObject:(EP_BillItem *)value;
- (void)addPayeeHasBillItem:(NSSet *)values;
- (void)removePayeeHasBillItem:(NSSet *)values;

@end

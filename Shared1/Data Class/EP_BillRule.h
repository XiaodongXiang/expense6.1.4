//
//  EP_BillRule.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, EP_BillItem, Payee, Transaction;

@interface EP_BillRule : NSManagedObject

@property (nonatomic, retain) NSNumber * ep_bool1;
@property (nonatomic, retain) NSString * ep_note;
@property (nonatomic, retain) NSString * ep_reminderDate;
@property (nonatomic, retain) NSString * ep_recurringType;
@property (nonatomic, retain) NSNumber * ep_bool2;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * ep_string2;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * ep_string1;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * ep_billAmount;
@property (nonatomic, retain) NSDate * ep_billEndDate;
@property (nonatomic, retain) NSDate * ep_billDueDate;
@property (nonatomic, retain) NSDate * ep_date1;
@property (nonatomic, retain) NSDate * ep_reminderTime;
@property (nonatomic, retain) NSDate * ep_date2;
@property (nonatomic, retain) NSString * ep_billName;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) Category *billRuleHasCategory;
@property (nonatomic, retain) NSSet *billRuleHasBillItem;
@property (nonatomic, retain) NSSet *billRuleHasTransaction;
@property (nonatomic, retain) Payee *billRuleHasPayee;
@end

@interface EP_BillRule (CoreDataGeneratedAccessors)

- (void)addBillRuleHasBillItemObject:(EP_BillItem *)value;
- (void)removeBillRuleHasBillItemObject:(EP_BillItem *)value;
- (void)addBillRuleHasBillItem:(NSSet *)values;
- (void)removeBillRuleHasBillItem:(NSSet *)values;

- (void)addBillRuleHasTransactionObject:(Transaction *)value;
- (void)removeBillRuleHasTransactionObject:(Transaction *)value;
- (void)addBillRuleHasTransaction:(NSSet *)values;
- (void)removeBillRuleHasTransaction:(NSSet *)values;

@end

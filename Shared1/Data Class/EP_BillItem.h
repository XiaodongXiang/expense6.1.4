//
//  EP_BillItem.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, EP_BillRule, Payee, Transaction;

@interface EP_BillItem : NSManagedObject

@property (nonatomic, retain) NSNumber * ep_billItemAmount;
@property (nonatomic, retain) NSDate * ep_billItemDueDateNew;
@property (nonatomic, retain) NSNumber * ep_billItemBool2;
@property (nonatomic, retain) NSString * ep_billItemName;
@property (nonatomic, retain) NSString * ep_billItemNote;
@property (nonatomic, retain) NSString * ep_billItemString1;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * ep_billItemDueDate;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * ep_billItemEndDate;
@property (nonatomic, retain) NSDate * ep_billItemDate1;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * ep_billItemRecurringType;
@property (nonatomic, retain) NSString * ep_billItemReminderDate;
@property (nonatomic, retain) NSNumber * ep_billItemBool1;
@property (nonatomic, retain) NSString * ep_billItemString2;
@property (nonatomic, retain) NSDate * ep_billItemDate2;
@property (nonatomic, retain) NSDate * ep_billItemReminderTime;
@property (nonatomic, retain) NSNumber * ep_billisDelete;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Payee *billItemHasPayee;
@property (nonatomic, retain) NSSet *billItemHasTransaction;
@property (nonatomic, retain) Category *billItemHasCategory;
@property (nonatomic, retain) EP_BillRule *billItemHasBillRule;
@end

@interface EP_BillItem (CoreDataGeneratedAccessors)

- (void)addBillItemHasTransactionObject:(Transaction *)value;
- (void)removeBillItemHasTransactionObject:(Transaction *)value;
- (void)addBillItemHasTransaction:(NSSet *)values;
- (void)removeBillItemHasTransaction:(NSSet *)values;

@end

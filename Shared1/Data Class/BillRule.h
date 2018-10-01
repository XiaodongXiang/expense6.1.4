//
//  BillRule.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Accounts, BillRule, Category, Payee, Transaction;

@interface BillRule : NSManagedObject

@property (nonatomic, retain) NSNumber * isRule;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * dayInWeek;
@property (nonatomic, retain) NSNumber * amountDue;
@property (nonatomic, retain) NSDate * paidDate;
@property (nonatomic, retain) NSNumber * weekInMonth;
@property (nonatomic, retain) NSString * cycle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * monthInYear;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * hasPaid;
@property (nonatomic, retain) NSString * remind;
@property (nonatomic, retain) NSDate * recordDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * amountPaid;
@property (nonatomic, retain) NSString * billType;
@property (nonatomic, retain) NSNumber * dayInMonth;
@property (nonatomic, retain) Accounts *toAccount;
@property (nonatomic, retain) BillRule *parentBillRule;
@property (nonatomic, retain) NSSet *transaction;
@property (nonatomic, retain) Accounts *fromAccount;
@property (nonatomic, retain) BillRule *childBillRule;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Payee *payees;
@end

@interface BillRule (CoreDataGeneratedAccessors)

- (void)addTransactionObject:(Transaction *)value;
- (void)removeTransactionObject:(Transaction *)value;
- (void)addTransaction:(NSSet *)values;
- (void)removeTransaction:(NSSet *)values;

@end

//
//  BudgetItem.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BudgetTemplate, BudgetTransfer;

@interface BudgetItem : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * rolloverAmount;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isRollover;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSSet *toTransfer;
@property (nonatomic, retain) BudgetTemplate *budgetTemplate;
@property (nonatomic, retain) NSSet *fromTransfer;
@end

@interface BudgetItem (CoreDataGeneratedAccessors)

- (void)addToTransferObject:(BudgetTransfer *)value;
- (void)removeToTransferObject:(BudgetTransfer *)value;
- (void)addToTransfer:(NSSet *)values;
- (void)removeToTransfer:(NSSet *)values;

- (void)addFromTransferObject:(BudgetTransfer *)value;
- (void)removeFromTransferObject:(BudgetTransfer *)value;
- (void)addFromTransfer:(NSSet *)values;
- (void)removeFromTransfer:(NSSet *)values;

@end

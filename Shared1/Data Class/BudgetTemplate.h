//
//  BudgetTemplate.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BudgetItem, BudgetReports, Category;

@interface BudgetTemplate : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * startDateHasChange;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isRollover;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSString * cycleType;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) BudgetReports *budgetRep;
@property (nonatomic, retain) NSSet *budgetItems;
@end

@interface BudgetTemplate (CoreDataGeneratedAccessors)

- (void)addBudgetItemsObject:(BudgetItem *)value;
- (void)removeBudgetItemsObject:(BudgetItem *)value;
- (void)addBudgetItems:(NSSet *)values;
- (void)removeBudgetItems:(NSSet *)values;

@end

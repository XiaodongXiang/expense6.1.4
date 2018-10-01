//
//  BudgetReports.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BudgetTemplate;

@interface BudgetReports : NSManagedObject

@property (nonatomic, retain) NSNumber * incHistory;
@property (nonatomic, retain) NSDate * genDateTime;
@property (nonatomic, retain) NSString * reportName;
@property (nonatomic, retain) NSNumber * budgetsIncOrExc;
@property (nonatomic, retain) NSNumber * incTransaction;
@property (nonatomic, retain) NSSet *selBudgets;
@end

@interface BudgetReports (CoreDataGeneratedAccessors)

- (void)addSelBudgetsObject:(BudgetTemplate *)value;
- (void)removeSelBudgetsObject:(BudgetTemplate *)value;
- (void)addSelBudgets:(NSSet *)values;
- (void)removeSelBudgets:(NSSet *)values;

@end

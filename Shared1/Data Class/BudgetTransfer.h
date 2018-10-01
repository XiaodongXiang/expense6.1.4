//
//  BudgetTransfer.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BudgetItem;

@interface BudgetTransfer : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * dateTime_sync;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) BudgetItem *toBudget;
@property (nonatomic, retain) BudgetItem *fromBudget;

@end

//
//  TransactionReports.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Accounts, Category;

@interface TransactionReports : NSManagedObject

@property (nonatomic, retain) NSString * transactionRepType;
@property (nonatomic, retain) NSNumber * sortByAsc;
@property (nonatomic, retain) NSString * reportName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * sortByAccOrCate;
@property (nonatomic, retain) NSNumber * accsIncOrExc;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * catesIncOrExc;
@property (nonatomic, retain) NSDate * genDateTime;
@property (nonatomic, retain) NSSet *selCategories;
@property (nonatomic, retain) NSSet *selAccounts;
@end

@interface TransactionReports (CoreDataGeneratedAccessors)

- (void)addSelCategoriesObject:(Category *)value;
- (void)removeSelCategoriesObject:(Category *)value;
- (void)addSelCategories:(NSSet *)values;
- (void)removeSelCategories:(NSSet *)values;

- (void)addSelAccountsObject:(Accounts *)value;
- (void)removeSelAccountsObject:(Accounts *)value;
- (void)addSelAccounts:(NSSet *)values;
- (void)removeSelAccounts:(NSSet *)values;

@end

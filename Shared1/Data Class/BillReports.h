//
//  BillReports.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface BillReports : NSManagedObject

@property (nonatomic, retain) NSString * reportName;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * sortByType;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * billRepType;
@property (nonatomic, retain) NSNumber * catesIncOrExc;
@property (nonatomic, retain) NSNumber * sortByAsc;
@property (nonatomic, retain) NSDate * genDateTime;
@property (nonatomic, retain) NSSet *selCategories;
@end

@interface BillReports (CoreDataGeneratedAccessors)

- (void)addSelCategoriesObject:(Category *)value;
- (void)removeSelCategoriesObject:(Category *)value;
- (void)addSelCategories:(NSSet *)values;
- (void)removeSelCategories:(NSSet *)values;

@end

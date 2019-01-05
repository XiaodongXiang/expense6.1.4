//
//  XDDataManager.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/11.
//

#import <Foundation/Foundation.h>
#import "Accounts.h"
#import "Setting+CoreDataClass.h"
@interface XDDataManager : NSObject

@property(nonatomic, strong,readonly)NSManagedObjectContext * backgroundContext;


+(XDDataManager*)shareManager;
-(NSManagedObjectModel*)managedObjectModel;
-(NSManagedObjectContext*)managedObjectContext;


-(id)insertObjectToTable:(NSString*)tableName;
-(NSArray *)getObjectsFromTable:(NSString *)tableName;
-(NSArray *)getObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray;

-(NSArray *)backgroundGetObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray;
-(NSArray*)backgroundGetTransactionDate:(NSDate* )date withAccount:(Accounts*)account;


-(NSArray*)getTransactionDate:(NSDate* )date withAccount:(Accounts*)account;
-(NSArray*)fetchParentExpenseCategory;

-(void)openWidgetInSettingWithBool14:(BOOL)open;
    
-(void)deleteTableObject:(id)object;

-(void)saveContext;

-(Setting*)getSetting;

+(NSString* )moneyFormatter:(double)doubleContext;
-(void)puchasedInfoInSetting:(NSDate*)startDate productID:(NSString*)productID originalProID:(NSString*)originalProID;
-(void)removeSettingPurchase;


-(void)fixStateIsZeroBug;
-(void)uploadLocalTransaction;
@end

@interface NSDate (customer)

-(NSDate*)startDate;
-(NSDate*)endDate;

@end

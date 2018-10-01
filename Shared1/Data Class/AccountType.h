//
//  AccountType.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Accounts;

@interface AccountType : NSManagedObject

@property (nonatomic, retain) NSString * others;
@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSNumber * ordexIndex;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * updatedTime;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface AccountType (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Accounts *)value;
- (void)removeAccountsObject:(Accounts *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end

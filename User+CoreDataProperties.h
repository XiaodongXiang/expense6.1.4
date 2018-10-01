//
//  User+CoreDataProperties.h
//  PocketExpense
//
//  Created by 刘晨 on 16/5/18.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *restoreTime;
@property (nullable, nonatomic, retain) NSString *lastUser;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSDate *syncTime;
@property (nullable, nonatomic, retain) NSString *userObjectId;
@property (nullable, nonatomic, retain) NSNumber *purchaseType;

@end

NS_ASSUME_NONNULL_END

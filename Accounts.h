//
//  Accounts.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/12/7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountType, BillRule, Transaction, TransactionReports;

NS_ASSUME_NONNULL_BEGIN

@interface Accounts : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Accounts+CoreDataProperties.h"

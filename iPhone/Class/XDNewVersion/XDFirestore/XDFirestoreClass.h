//
//  XDFirestoreClass.h
//  PocketExpense
//
//  Created by 晓东项 on 2019/2/20.
//

#import <Foundation/Foundation.h>

#import "Transaction.h"
#import "Payee.h"
#import "Accounts.h"
#import "Category.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "BudgetTemplate.h"
#import "BudgetItem.h"
#import "BudgetTransfer.h"
#import "accountType.h"



NS_ASSUME_NONNULL_BEGIN

@interface XDFirestoreClass : NSObject

+(XDFirestoreClass*)shareClass;

-(void)addTransactionToFirestore:(Transaction*)transaction;


-(void)addPayeeToFirestore:(Payee*)payee;


-(void)addAccountToFirestore:(Accounts*)account;
-(void)addAccountTypeToFirestore:(AccountType*)accountType;
-(void)addCategoryToFirestore:(Category*)category;
-(void)addBillRuleToFirestore:(EP_BillRule*)billRule;
-(void)addBillItemToFirestore:(EP_BillItem*)billItem;
-(void)addBudgetTemplateToFirestore:(BudgetTemplate*)budgetTemplate;
-(void)addBudgetItemToFirestore:(BudgetItem*)budgetItem;
-(void)addBudgetTransferToFirestore:(BudgetTransfer*)budgerTransfer;


-(void)batchAllDataToFirestore;

-(void)listenAllTable;

@end

NS_ASSUME_NONNULL_END

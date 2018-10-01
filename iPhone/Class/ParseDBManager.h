//
//  ParseDBManager.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/4/29.
//
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
#import "XDFirstPromptViewController.h"

@interface ParseDBManager : NSObject
+(ParseDBManager *)sharedManager;

//以下update方法用于对数据的增加,修改

-(void)updateTransactionFromLocal:(Transaction *)t;

-(void)updatePayeeFromLocal:(Payee *)p;

-(void)updateAccountFromLocal:(Accounts *)a;

-(void)updateAccountTypeFromLocal:(AccountType *)at;

-(void)updateCategoryFromLocal:(Category *)c;

-(void)updateBillRuleFromLocal:(EP_BillRule *)br;

-(void)updateBillItemFormLocal:(EP_BillItem *)bi;

-(void)updateBudgetFromLocal:(BudgetTemplate *)bt;

-(void)updateBudgetItemLocal:(BudgetItem *)bi;

-(void)updateBudgetTransfer:(BudgetTransfer *)bt;

-(void)dataSyncWithServer;

-(void)dataSyncWithSyncBtn:(void(^)(BOOL complete))completion;

-(void)dataSyncWithLogInServer;

-(void)localDataToServer;

-(void)restoreDataRemove;


-(void)getPFSetting;
-(void)savingSetting;

@end

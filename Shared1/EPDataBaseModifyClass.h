//
//  EPDataBaseModifyClass.h
//  PocketExpense
//
//  Created by MV on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BudgetTemplate.h"
#import "Transaction.h"
#import "Accounts.h"
#import "BudgetTransfer.h"

@class BillFather;
//-----------数据库修改 类
@interface EPDataBaseModifyClass : NSObject
{
   
}


//1.初始化Accunt的类型 2.初始化Category 3.初始化Category iPad类型
-(void)initializeAccountType;
-(void)initializeCategory;

//1.检测 是否由Category Icon类型的错误 2.检测是否由Account Type类型的错误 3.天健Category
-(void)CheckCategoryErrorIcon;
-(void)CheckAccountTypeErrorName;
-(void)AddCategory_V100ToV101;
-(void)autoReCountBudgetRollover_V101ToV102;
-(void)autoGenCategoryDataRelationShip;
-(void)CheckErrorCategoryBudgetRelation;//检测是否有category 预算关系的错误
-(void)CheckErrorBudget;

//1.重新统计budget 2.清除budget
-(void)ReCountBudgetRollover:(BudgetTemplate *)b;
-(void)ClearBudget:(BudgetTemplate *)b;
-(void)autoGenCycleBudgetItem:(BudgetTemplate *)b withEndDate:(NSDate *)cycleEndDate isIpad:(BOOL)isIpad;
-(void)insertBudgetItem:(BudgetTemplate *)b withStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
- (void)autoInsertTransaction:(Transaction *)repeatTransactionRule ;

-(void)AutoFillBudgetData:(BOOL)isIpad;
-(void)AutoFillTransactionData;
-(BOOL)canBeAddTranscation;

-(void)deleteTransactionRel:(Transaction *)t;
-(void)deleteChildTransactionRel:(Transaction *)t;

-(void)deleteTransferRel:(BudgetTransfer *)t;

-(void)deleteAccountRel:(Accounts * )a;
-(void)deleteCategoryAndDeleteRel:(Category * )c;

-(void)deleteBudgetRel:(BudgetTemplate * )b;

-(void)saveTransaction:(Transaction *)trans;
-(void)saveBillItem:(EP_BillItem *)billItems;
-(void)deleteAllTableDataBase_exceptSeetingTable:(BOOL)deleteSetting;

-(void)deleteAccountTypeRel:(AccountType *)accountType;
-(void)deletePayee_sync:(Payee *)onePayee;

-(void)deleteBillRuleRel:(EP_BillRule *)billRule;
-(void)saveBudgetTemplateandtheBudgetItem:(BudgetTemplate *)budgetTemplate withAmount:(double)budgetAmount;

//create BillFather
-(void)editBillFather:(BillFather *)tmpBillFather withBillRule:(EP_BillRule *)tmpBillRule withDate:(NSDate *)tmpDate;
-(void)editBillFather:(BillFather *)tmpBillFather withBillItem:(EP_BillItem *)tmpBillItem;

-(NSArray *)getDataArray_TableName:(NSString *)m_tableName searchSubPre:(NSDictionary *)m_diction;

#pragma mark delete data without sync
-(void)deleteAccountTypeRel_withoutSync:(AccountType *)accountType;
-(void)deleteAccountRel_withoutSync:(Accounts * )a;
-(void)deleteTransactionRel_withOutSync:(Transaction *)t;
-(void)deleteChildTransactionRel_withoutSync:(Transaction *)t;
-(void)deleteCategoryAndDeleteRel_withoutSync:(Category * )c;
-(void)deletePayee_withoutSync:(Payee *)onePayee;
-(void)deleteBudgetRel_withoutSync:(BudgetTemplate * )b;
-(void)deleteBudgetItemRel_withoutSync:(BudgetItem *)budgetItem;
-(void)deleteTransferRel_withoutSync:(BudgetTransfer *)t;
-(void)deleteBillRuleRel_withoutSync:(EP_BillRule *)billRule;
-(void)deleteBillItemRel_withoutSync:(EP_BillItem *)billItem;


-(void)checkCategorytoChangeNotsureCategory;
-(void)setAccountOrderIndex;
-(void)setTransactionType;
-(void)setCategoryTransactionType;
-(void)changeTransactionRecurringType;
-(void)setAllLocalTables_state_uuid_DateTime;
-(void)setAccountTypeTable_state_uuid_dateTime;
-(void)setCategoryTransactionType;
-(void)createDefaultAccount;

-(void)setTransactionTable_UUID_5_2VersionOnly;
//免费版升级时候，需要先把所有的数据读取出来
-(void)getOldDataBaseInsertToNewDataBase_isBackup:(BOOL)isBackup;
-(void)getBillDataFormOldEntitytoNewEntity;
-(void)setFreeVersionBelongtoWhichVersionIdentification;

-(double)getSelectedMonthNetWorth:(NSDate *)date isMonthViewControllerBalance:(BOOL)isMonthViewControllerBalance;
-(void)setLocalDataBaseSyncTimeToday_whenRestore;

-(void)deleteCategoryAndRelation:(Category*) category;
-(void)duplicateTransaction:(Transaction *)selectedTrans withDate:(NSDate *)duplicateDate;
@end

//
//  Category.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import "Category.h"
#import "BillReports.h"
#import "BillRule.h"
#import "BudgetTemplate.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "Payee.h"
#import "Transaction.h"
#import "TransactionReports.h"


@implementation Category

@dynamic others;
@dynamic categoryString;
@dynamic categoryName;
@dynamic categoryisIncome;
@dynamic hasBudget;
@dynamic uuid;
@dynamic categoryisExpense;
@dynamic isDefault;
@dynamic isSystemRecord;
@dynamic dateTime;
@dynamic state;
@dynamic iconName;
@dynamic colorName;
@dynamic recordIndex;
@dynamic categoryType;
@dynamic objectId;
@dynamic updatedTime;
@dynamic billItem;
@dynamic budgetTemplate;
@dynamic transactionRep;
@dynamic categoryHasBillRule;
@dynamic billRep;
@dynamic transactions;
@dynamic categoryHasBillItem;
@dynamic payee;

@end

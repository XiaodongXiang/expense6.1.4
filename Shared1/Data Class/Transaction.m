//
//  Transaction.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import "Transaction.h"
#import "Accounts.h"
#import "BillRule.h"
#import "Category.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "Payee.h"
#import "Transaction.h"
#import "TransactionRule.h"


@implementation Transaction

@dynamic transactionBool;
@dynamic isClear;
@dynamic amount;
@dynamic others;
@dynamic photoName;
@dynamic photoData;
@dynamic uuid;
@dynamic dateTime;
@dynamic dateTime_sync;
@dynamic type;
@dynamic state;
@dynamic transactionType;
@dynamic groupByDate;
@dynamic transactionstring;
@dynamic recurringType;
@dynamic notes;
@dynamic orderIndex;
@dynamic objectId;
@dynamic updatedTime;
@dynamic transactionHasBillItem;
@dynamic transactionHasBillRule;
@dynamic billItem;
@dynamic category;
@dynamic childTransactions;
@dynamic expenseAccount;
@dynamic transactionRule;
@dynamic incomeAccount;
@dynamic parTransaction;
@dynamic payee;
@dynamic isUpload;

-(NSString *)groupByDateString
{
    [self willAccessValueForKey:@"groupByDateString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *stringToReturn =[NSString stringWithString:[dateFormatter stringFromDate:self.dateTime]];
    [self didAccessValueForKey:@"groupByDateString"];
    return stringToReturn;
}

-(NSString *)groupByDetailDateString{
    [self willAccessValueForKey:@"groupByDetailDateString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    NSString *stringToReturn =[NSString stringWithString:[dateFormatter stringFromDate:self.dateTime]];
    [self didAccessValueForKey:@"groupByDetailDateString"];
    return stringToReturn;
}
-(NSString *)groupByMonthString{
    [self willAccessValueForKey:@"groupByMonthString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *stringToReturn =[NSString stringWithString:[dateFormatter stringFromDate:self.dateTime]];
    [self didAccessValueForKey:@"groupByMonthString"];
    return stringToReturn;
}
@end

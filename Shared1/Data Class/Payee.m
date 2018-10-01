//
//  Payee.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/14.
//
//

#import "Payee.h"
#import "BillRule.h"
#import "Category.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "Transaction.h"


@implementation Payee

@dynamic uuid;
@dynamic state;
@dynamic phone;
@dynamic others;
@dynamic tranAmount;
@dynamic memo;
@dynamic tranCleared;
@dynamic orderIndex;
@dynamic dateTime;
@dynamic tranMemo;
@dynamic website;
@dynamic tranType;
@dynamic name;
@dynamic updatedTime;
@dynamic objectId;
@dynamic category;
@dynamic payeeHasBillRule;
@dynamic transaction;
@dynamic billItem;
@dynamic payeeHasBillItem;
-(NSString *)groupByName
{
    [self willAccessValueForKey:@"groupByName"];
    
    NSString *stringToReturn = self.name;
    [self didAccessValueForKey:@"groupByName"];
    
    return stringToReturn;
}

-(NSString *)groupByDateString
{
    [self willAccessValueForKey:@"groupByDateString"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *stringToReturn =[NSString stringWithString:[dateFormatter stringFromDate:self.dateTime]];
    [self didAccessValueForKey:@"groupByDateString"];
    return stringToReturn;
}
@end

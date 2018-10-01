//
//  BillFather.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-2.
//
//

#import "BillFather.h"

@implementation BillFather
@synthesize bf_billName,bf_billAmount,bf_billDueDate,bf_billEndDate,bf_billRecurringType,bf_billReminderDate,bf_billReminderTime,bf_billNote,bf_billRule,bf_billItem,bf_category,bf_payee;

//默认的hidden是yes的
-(id)init{
    self = [super init];
    if (self) {
        bf_billName = nil;
        bf_billAmount = 0;
        bf_billDueDate = [[NSDate alloc]init];
        bf_billEndDate = [[NSDate alloc]init];
        bf_billRecurringType = nil;
        bf_billReminderDate = nil;
        bf_billReminderTime = [[NSDate alloc]init];
        bf_billNote = nil;
        
        
        bf_billRule = nil;
        bf_billItem = nil;
        bf_category = nil;
        bf_payee = nil;
    }
    return self;
}


@end

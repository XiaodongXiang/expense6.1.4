//
//  BrokenLineObject.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-27.
//
//

#import "BrokenLineObject.h"

@implementation BrokenLineObject
@synthesize dateTime,expenseAmount,incomeAmount,thisDaytTransactionArray;

-(id)initWithDay:(NSDate *)date{
    self.dateTime = date;
    self.expenseAmount = 0.0;
    self.incomeAmount = 0.0;

    self.thisDaytTransactionArray = [[NSMutableArray alloc]init];
    return self;
}


@end

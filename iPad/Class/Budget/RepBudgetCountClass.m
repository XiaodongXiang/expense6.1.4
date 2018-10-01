//
//  RepBudgetCountClass.m
//  PocketExpense
//
//  Created by MV on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepBudgetCountClass.h"
@implementation RepBudgetHisClass
@synthesize bi,biAmount;
 //@synthesize hisTransArray;
- (id)init{
    if (self = [super init]) 
	{
       // hisTransArray =[[NSMutableArray alloc] init];
    }
    return self;
}

@end
@implementation RepBudgetCountClass
@synthesize bt;
@synthesize btTotalIncome;
@synthesize btTotalExpense;
@synthesize btTotalRollover;
@synthesize allHisArray,allTransArray;
- (id)init{
    if (self = [super init]) 
	{
        allTransArray =[[NSMutableArray alloc] init];
        allHisArray =[[NSMutableArray alloc] init];

    }
    return self;
}

@end


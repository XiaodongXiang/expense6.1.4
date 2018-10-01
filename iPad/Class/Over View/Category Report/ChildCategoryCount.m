//
//  ChildCategoryCount.m
//  PocketExpense
//
//  Created by humingjing on 14-5-12.
//
//

#import "ChildCategoryCount.h"

@implementation ChildCategoryCount
@synthesize categoryName,fullName,amount,isNeedShowData ;
-(id)init{
    if ((self = [super init])) {
        amount=0.0;
        isNeedShowData = TRUE;
    }
    return self;
}

@end

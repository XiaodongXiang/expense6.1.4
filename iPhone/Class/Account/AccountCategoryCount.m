//
//  AccountCategoryCount.m
//  PocketExpense
//
//  Created by humingjing on 14-9-9.
//
//

#import "AccountCategoryCount.h"


@implementation AccountCategoryCount
@synthesize categoryItem,transNumber;

-(AccountCategoryCount *)initWithCategory:(Category *)category num:(long)num
{
   
    if ([super init]) {
        
        
        categoryItem = category;
        transNumber = num;
        
    }
    return self;
}
@end

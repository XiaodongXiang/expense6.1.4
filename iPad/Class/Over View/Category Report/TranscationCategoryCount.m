//
//  TranscationCategoryCount.m
//  PocketExpense
//
//  Created by humingjing on 14-5-12.
//
//

#import "TranscationCategoryCount.h"

@implementation TranscationCategoryCount
@synthesize categoryName,transcationArray,childCateArray ;
@synthesize c;
-(id)init{
    if ((self = [super init])) {
        transcationArray=[[NSMutableArray alloc] init];
        childCateArray=[[NSMutableArray alloc] init];
    }
    return self;
}


@end

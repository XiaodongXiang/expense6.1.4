//
//  TranscationCategoryCount.h
//  PocketExpense
//
//  Created by humingjing on 14-5-12.
//
//

#import <Foundation/Foundation.h>
#import "Category.h"

@interface TranscationCategoryCount : NSObject
{
	NSString *categoryName;
    //存放所有的 tranaction
    NSMutableArray *transcationArray;
    //存放所有二级category底下的 tranaction
    NSMutableArray *childCateArray;
    Category *c;
}

@property (nonatomic, strong)  NSString         *categoryName;
@property (nonatomic, strong)  NSMutableArray   *transcationArray;
@property (nonatomic, strong)  NSMutableArray   *childCateArray;
@property (nonatomic, strong)  Category         *c;


@end

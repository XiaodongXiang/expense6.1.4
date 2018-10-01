//
//  CategoryCount.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-11.
//
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "CategorySelect.h"


@interface CategoryCount : NSObject {
	Category *categoryItem;
 	double cellHeight;
    CategoryPCType pcType;
    NSString *cateName;
}
@property (nonatomic, copy)  NSString *cateName;

@property (nonatomic, strong)  Category *categoryItem;
@property (nonatomic, assign) double cellHeight;
@property (nonatomic, assign)  CategoryPCType pcType;

@end

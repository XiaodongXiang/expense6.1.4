//
//  ChildCategoryCount.h
//  PocketExpense
//
//  Created by humingjing on 14-5-12.
//
//

#import <Foundation/Foundation.h>

@interface ChildCategoryCount : NSObject
{
	NSString *categoryName;
    NSString *fullName;
    
    double amount;
    BOOL   isNeedShowData;
}

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *fullName;

@property (nonatomic, assign)  double amount;
@property (nonatomic, assign)   BOOL   isNeedShowData;

@end

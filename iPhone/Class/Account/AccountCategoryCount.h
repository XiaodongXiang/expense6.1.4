//
//  AccountCategoryCount.h
//  PocketExpense
//
//  Created by humingjing on 14-9-9.
//
//

#import <Foundation/Foundation.h>
#import "Category.h"

@interface AccountCategoryCount : NSObject
{
    Category *categoryItem;
    long     transNumber;
}
@property(nonatomic,strong) Category *categoryItem;
@property(nonatomic,assign) long     transNumber;

-(AccountCategoryCount *)initWithCategory:(Category *)category num:(long)num;
@end

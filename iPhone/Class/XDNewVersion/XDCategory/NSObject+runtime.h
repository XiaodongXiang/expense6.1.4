//
//  NSObject+runtime.h
//  PocketExpense
//
//  Created by 晓东项 on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (runtime)

-(NSMutableDictionary*)dicWithItem;

-(id)isNull;

@end

NS_ASSUME_NONNULL_END

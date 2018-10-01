//
//  XDDateSelectedModel.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/27.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DateSelectedWeek,
    DateSelectedMonth,
    DateSelectedYear,
    DateSelectedCustom
} DateSelectedType;

@interface XDDateSelectedModel : NSObject

+(NSArray*)returnDateSelectedWithType:(DateSelectedType)type completion:(void(^)(NSInteger index))completion;

@end

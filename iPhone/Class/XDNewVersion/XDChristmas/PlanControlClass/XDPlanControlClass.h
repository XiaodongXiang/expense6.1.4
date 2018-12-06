//
//  XDPlanControlClass.h
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import <Foundation/Foundation.h>
#import "XDOverviewChristmasViewA.h"

typedef enum : NSUInteger {
    ChristmasPlanA,
    ChristmasPlanB,
} ChristmasPlanType;

typedef enum : NSUInteger {
    ChristmasSubPlana,
    ChristmasSubPlanb,
}  ChristmasSubPlan;


typedef enum : NSUInteger {
    ChristmasPlanCategoryHasReceive7Days,
    ChristmasPlanCategoryNotHasReceive7Days,
    ChristmasPlanCategoryNotLifetime,
    ChristmasPlanCategoryLifetime,
} ChristmasPlanCategory;
NS_ASSUME_NONNULL_BEGIN

@interface XDPlanControlClass : NSObject

@property(nonatomic, assign)ChristmasPlanType planType;
@property(nonatomic, assign)ChristmasPlanCategory planCategory;
@property(nonatomic, assign)ChristmasSubPlan planSubType;

@property(nonatomic, assign)BOOL needShow;
@property(nonatomic, strong)XDOverviewChristmasViewA* christmasView;


+(instancetype)shareControlClass;


@end

NS_ASSUME_NONNULL_END

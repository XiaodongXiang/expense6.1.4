//
//  DailyAmountObject.h
//  PocketExpense
//
//  Created by humingjing on 14/12/1.
//
//

#import <Foundation/Foundation.h>

@interface DailyAmountObject : NSObject

@property(nonatomic,strong)NSDate *date;
@property(nonatomic,assign)double expenseAmount;
@property(nonatomic,assign)double incomeAmount;

//-(id)init;
@end

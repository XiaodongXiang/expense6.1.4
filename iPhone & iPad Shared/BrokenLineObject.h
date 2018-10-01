//
//  BrokenLineObject.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-27.
//
//

#import <Foundation/Foundation.h>

@interface BrokenLineObject : NSObject{
    NSDate  *dateTime;
    
    double  expenseAmount;
    double  incomeAmount;
    
    NSMutableArray  *thisDaytTransactionArray;
}

@property(nonatomic,strong)NSDate           *dateTime;

@property(nonatomic,assign)double            expenseAmount;
@property(nonatomic,assign)double            incomeAmount;
@property(nonatomic,assign)double            maxAmount;
@property(nonatomic,strong)NSMutableArray   *thisDaytTransactionArray;


-(id)initWithDay:(NSDate *)date;
@end

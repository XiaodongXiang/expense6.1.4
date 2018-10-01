//
//  RepBudgetCountClass.h
//  PocketExpense
//
//  Created by MV on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetTemplate.h"
#import "BudgetItem.h"
@interface RepBudgetHisClass : NSObject {
	
 	BudgetItem *bi;
    // NSMutableArray *hisTransArray;
    double biAmount;
}

@property (nonatomic, strong) BudgetItem *bi;
//@property (nonatomic, strong)  NSMutableArray *hisTransArray;
@property (nonatomic, assign) double biAmount;

@end

@interface RepBudgetCountClass : NSObject {
	
 	BudgetTemplate *bt;
	double btTotalIncome;
	double btTotalExpense;
    double btTotalRollover;
    NSMutableArray *allTransArray;
    NSMutableArray *allHisArray;

}

@property (nonatomic, strong) BudgetTemplate *bt;;
@property (nonatomic, assign) double btTotalIncome;
@property (nonatomic, assign) double  btTotalExpense;
@property (nonatomic, assign)  double btTotalRollover;
@property (nonatomic, strong)  NSMutableArray *allTransArray;
@property (nonatomic, strong)  NSMutableArray *allHisArray;

@end

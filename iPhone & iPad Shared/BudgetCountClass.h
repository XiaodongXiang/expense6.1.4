//
//  BudgetCountClass.h
//  PokcetExpense
//
//  Created by Tommy on 1/15/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

#import "BudgetTemplate.h"

@interface BudgetCountClass : NSObject
{
	
 	BudgetTemplate *bt;
	double btTotalIncome;
	double btTotalExpense;
    double btTotalRellover;

}

@property (nonatomic, strong) BudgetTemplate *bt;;
@property (nonatomic, assign) double btTotalIncome;
@property (nonatomic, assign) double  btTotalExpense;
@property (nonatomic, assign)  double btTotalRellover;

 @end

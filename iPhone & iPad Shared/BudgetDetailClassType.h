//
//  BudgetDetailClassType.h
//  PokcetExpense
//
//  Created by Tommy on 1/12/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//
#import "BudgetTransfer.h"
#import "Transaction.h"

typedef enum {
	DetailClassTypeTranction = 0,
	DetailClassTypeFromTransfer =1,
	DetailClassTypeToTransfer =2,

} DetailClassType;


@interface BudgetDetailClassType : NSObject {

	NSDate *date;
	DetailClassType dct;
	BudgetTransfer *budgetTransfer;
	Transaction *transaction;
}

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) DetailClassType dct;
@property (nonatomic, strong) BudgetTransfer *budgetTransfer;
@property (nonatomic, strong) Transaction *transaction;
@end

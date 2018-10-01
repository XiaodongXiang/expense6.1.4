//
//  ClearCusBtn.h
//  PocketExpense
//
//  Created by MV on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Transaction.h" 
@interface ClearCusBtn : UIButton {
    Transaction *t;   
}

@property (nonatomic, strong) Transaction *t; 
 
@end
//
//  AccountCount.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-16.
//
//

#import <Foundation/Foundation.h>
#import "Accounts.h"



@interface AccountCount : NSObject{
	Accounts *accountsItem;
 	double totalIncome;
    double totalExpense;
    double totalBalance;
    
    double defaultAmount;
}
@property (nonatomic, strong) Accounts *accountsItem;
@property (nonatomic, assign) double totalIncome;
@property (nonatomic, assign)  double totalExpense;
@property (nonatomic, assign)  double totalBalance;
@property (nonatomic, assign) double defaultAmount;


@end

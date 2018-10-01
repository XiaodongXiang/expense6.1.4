//
//  XDBudgetTransferViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/28.
//

#import <UIKit/UIKit.h>
#import "BudgetTemplate.h"
#import "BudgetDetailClassType.h"
@protocol XDBudgetTransferViewDelegate <NSObject>
-(void)returnBudgetTransfer:(BudgetDetailClassType*)budgetClassType;

@end
@interface XDBudgetTransferViewController : UIViewController
@property(nonatomic, strong)BudgetTemplate * budgetTemple;
@property(nonatomic, assign)double residurAmount;
@property(nonatomic, weak)id<XDBudgetTransferViewDelegate> delegate;

@property(nonatomic, strong)BudgetDetailClassType * classType;

@end

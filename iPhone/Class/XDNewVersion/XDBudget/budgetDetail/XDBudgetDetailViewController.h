//
//  XDBudgetDetailViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/22.
//

#import <UIKit/UIKit.h>
#import "XDEditBudgetViewController.h"
@class BudgetTemplate;
@interface XDBudgetDetailViewController : UIViewController

@property(nonatomic, strong)BudgetTemplate * budgetTemple;
@property(nonatomic, strong)NSDate * date;
@property(nonatomic, assign)BudgetType type;


@end

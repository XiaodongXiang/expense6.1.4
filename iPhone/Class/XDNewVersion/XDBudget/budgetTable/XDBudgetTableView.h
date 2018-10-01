//
//  XDBudgetTableView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import <UIKit/UIKit.h>
@class BudgetTemplate;
@protocol XDBudgetTableViewDelegate <NSObject>

-(void)returnSelectedBudget:(BudgetTemplate*)budgetTemple transactionArray:(NSArray*)array;
-(void)createBudgetBtnClick;
@end

@interface XDBudgetTableView : UITableView

@property(nonatomic, strong)NSArray * budgetArray;
@property(nonatomic, weak)id<XDBudgetTableViewDelegate> budgetDelegate;

@end

//
//  XDEditBudgetViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Weekly = 1,
    Monthly,
} BudgetType;

@protocol XDEditBudgetViewDelegate <NSObject>

-(void)returnEditBudget:(NSArray* )budgetArray DateType:(BudgetType)type;

@end
@interface XDEditBudgetViewController : UIViewController

@property(nonatomic, weak)id<XDEditBudgetViewDelegate> delegate;
@property(nonatomic, assign)BudgetType type;



@end

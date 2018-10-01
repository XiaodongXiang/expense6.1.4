//
//  BudgetIntroduceViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import <UIKit/UIKit.h>

@interface BudgetIntroduceViewController : UIViewController
{
    UILabel *reminderLabel;
    UIButton *selectedCategoryBtn;
    BOOL    dismisswithnoAnimation;
}

@property(nonatomic,strong)IBOutlet UILabel *reminderLabel;
@property(nonatomic,strong)IBOutlet UIButton *selectedCategoryBtn;
@property(nonatomic,assign)BOOL    dismisswithnoAnimation;

-(void)back:(UIButton *)sender;
@end

//
//  ipad_BudgetIntroduceViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@interface ipad_BudgetIntroduceViewController : UIViewController
{
    UIButton *selectedCategoryBtn;
    UILabel *reminderLabel;
    
    BOOL    dismisswithnoAnimation;
}

@property(nonatomic,strong)IBOutlet UILabel *reminderLabel;
@property(nonatomic,strong)IBOutlet UIButton *selectedCategoryBtn;
@property(nonatomic,assign)BOOL    dismisswithnoAnimation;

-(void)back:(UIButton *)sender;

@end

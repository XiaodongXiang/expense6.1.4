//
//  ipad_ExportSelectedCategoryViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import <UIKit/UIKit.h>

@class ipad_EmailViewController,ipad_RepTransactionFilterViewController;


@interface ipad_ExportSelectedCategoryViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *categoryTableView;
    UILabel         *selecedCategoryAmountLabel;
    UIButton        *selectedAllBtn;
    
    UIView          *expenseorIncomeView;
    UIButton        *expenseBtn;
    UIButton        *incomeBtn;
    NSInteger       selectedItemCount;
    
        UILabel         *selectAllLabelText;
    
    NSMutableArray  *expenseCategoryArray;
    NSMutableArray  *incomeCategoryArray;
    ipad_EmailViewController *iEmailViewController;
    
}

@property(nonatomic,strong)IBOutlet UITableView     *categoryTableView;
@property(nonatomic,strong)IBOutlet UILabel         *selecedCategoryAmountLabel;
@property(nonatomic,strong)IBOutlet UIButton        *selectedAllBtn;

@property(nonatomic,strong)IBOutlet UIView          *expenseorIncomeView;
@property(nonatomic,strong)IBOutlet UIButton        *expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *incomeBtn;
@property(nonatomic,assign)NSInteger       selectedItemCount;

@property(nonatomic,strong)IBOutlet UILabel         *selectAllLabelText;


@property(nonatomic,strong)NSMutableArray  *expenseCategoryArray;
@property(nonatomic,strong)NSMutableArray  *incomeCategoryArray;
@property(nonatomic,strong)ipad_EmailViewController *iEmailViewController;
@property(nonatomic,strong)ipad_RepTransactionFilterViewController  *iTransactionPDFViewController;

@end

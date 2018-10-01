//
//  ExportSelectedCategoryViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-17.
//
//

#import <UIKit/UIKit.h>

@class EmailViewController,RepTransactionFilterViewController;

@interface ExportSelectedCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@property(nonatomic,strong)IBOutlet UITableView     *categoryTableView;
@property(nonatomic,strong)IBOutlet UILabel         *selecedCategoryAmountLabel;
@property(nonatomic,strong)IBOutlet UIButton        *selectedAllBtn;

@property(nonatomic,strong)IBOutlet UIView          *expenseorIncomeView;
@property(nonatomic,strong)IBOutlet UIButton        *expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *incomeBtn;
@property(nonatomic,assign)NSInteger                selectedItemCount;

@property(nonatomic,strong)IBOutlet UILabel         *selectAllLabelText;

@property(nonatomic,strong)NSMutableArray           *expenseCategoryArray;
@property(nonatomic,strong)NSMutableArray           *incomeCategoryArray;
@property(nonatomic,strong)EmailViewController      *emailViewController;

@property(nonatomic,strong)RepTransactionFilterViewController  *transactionPDFViewController;

@end

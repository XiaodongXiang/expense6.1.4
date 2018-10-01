//
//  DateRangeViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import <UIKit/UIKit.h>

@class  ExpenseViewController,ExpenseCategoryViewController,ExpenseSecondCategoryViewController,CashDetailViewController;
@interface DateRangeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView             *dateTableView;
    UITableViewCell         *thisMonthCell;
    UITableViewCell         *lastMonthCell;
    UITableViewCell         *thisQuarterCell;
    UITableViewCell         *lastQuarterCell;
    UITableViewCell         *thisYearCell;
    UITableViewCell         *lastYearCell;
    UITableViewCell         *customCell;
    
    UILabel                 *thisMonthLabelText;
    UILabel                 *lastMonthLabelText;
    UILabel                 *thisQuarterLabelText;
    UILabel                 *lastQuarterLabelText;
    UILabel                 *thisYearLabelText;
    UILabel                 *lastYearLabelText;
    UILabel                 *customRangeLabelText;
    
    ExpenseViewController   *expenseViewController;
    ExpenseCategoryViewController *expenseCategoryViewController;
    ExpenseSecondCategoryViewController *expenseSecondCategoryViewController;
    CashDetailViewController             *cashDetailViewController;
}

@property(nonatomic,strong)IBOutlet UITableView       *dateTableView;

@property(nonatomic,strong)IBOutlet UITableViewCell   *thisMonthCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *lastMonthCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *thisQuarterCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *lastQuarterCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *thisYearCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *lastYearCell;
@property(nonatomic,strong)IBOutlet UITableViewCell   *customCell;
@property(nonatomic,strong)IBOutlet UILabel                 *thisMonthLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *lastMonthLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *thisQuarterLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *lastQuarterLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *thisYearLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *lastYearLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *customRangeLabelText;

@property(nonatomic,strong)ExpenseViewController   *expenseViewController;
@property(nonatomic,strong)ExpenseCategoryViewController *expenseCategoryViewController;
@property(nonatomic,strong)ExpenseSecondCategoryViewController *expenseSecondCategoryViewController;
@property(nonatomic,strong)CashDetailViewController             *cashDetailViewController;


@end

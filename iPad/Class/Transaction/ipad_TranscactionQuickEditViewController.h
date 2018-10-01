//
//  TransactionEditViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-5.
//
//

#import <UIKit/UIKit.h>
#import "HMJPickerView.h"

#import "Transaction.h"
#import "Accounts.h"
#import "Category.h"
#import "Payee.h"

#import "iPad_OverViewViewController.h"
#import "HMJTableViewCell.h"

#define hmjclearBtn	11	// C
#define divBtn      12	// ÷
#define mulBtn      13	// x
#define subBtn      14	// -
#define plusBtn     15	// +
#define equalBtn    16	// =
#define backBtn		17	// ←
#define dotBtn      18	// .

//枚举出交易的类型 结构体
typedef enum
{
	expense = 0,
	income =1,
 	transfer =2
} TranscationClassType;

@class ipad_TranscationCategorySelectViewController,ipad_TransacationSplitViewController,ipad_AccountPickerViewController;
@class ipad_AccountViewController;
@class ipad_BudgetViewController;
@class ipad_SearchRelatedViewController;

@interface ipad_TranscactionQuickEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HMJPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UIPopoverControllerDelegate>
{
	UITableView *showCellTable;
    UITableViewCell *accountCell;
    UITableViewCell *fromAccountCell;
    UITableViewCell *toAccountCell;
	UITableViewCell *amountCell;
	UITableViewCell *categoryCell;
	UITableViewCell *dateCell;
	UITableViewCell *recurringCell;
	UITableViewCell *noteCell;
	UITableViewCell *imageCell;
	UITableViewCell *payeeCell;
	UITableViewCell *clearCell;
    UITableViewCell *showMoreDetailsCell;
    UITableViewCell *datePickerCell;
    BOOL            isSpliteTrans;//判断是不是splite类型的category，以及是不是需要计算计算器中的金额
    
    NSIndexPath *selectedRowIndexPath;
    
    UILabel         *sectionHeaderLabel;
    UITextField     *payeText;
    UIView          *payeeSearchView;
    UITableView     *payeeSearchTable;
    UILabel         *display;//amount label
    UIButton        *expenseBtn;
    UIButton        *incomeBtn;
    UIButton        *transferBtn;
    UILabel         *categoryLabel;
    
    UITextField     *accountLabel;
    UITextField         *fromAccountLabel;
    UITextField         *toAccountLabel;
    UILabel         *dateLabel;
    UISwitch        *clearedSwitch;
    UILabel         *recurringLabel;
    UIImageView     *phontoImageView;
    UILabel         *memoLabel;
    UITextView      *memoTextView;
    NSDateFormatter* outputFormatter;
    NSDateFormatter *headerDateormatter;
    
    UILabel         *cagetoryLabelText;
    UILabel         *accountLabelText;
    UILabel         *fromAccountLabelText;
    UILabel         *toAccountLabelText;
    UILabel         *dateLabelText;
    UILabel         *repeatLabelText;
    UILabel         *ClearedLabelText;
    UILabel         *photoLabelText;
    UILabel         *showMoreLabelText;

    
    UIDatePicker    *datePicker;
    NSInteger		picktype;
	NSString        *photosName;

    
    NSString        *documentsPath;
    Transaction     *transaction;
    Accounts        *accounts;
	Accounts        *fromAccounts;
	Accounts        *toAccounts;
    Category        *categories;
    Category        *otherCategory_expense;
    Category        *otherCategory_income;
	Payee           *payees;
    NSString        *typeoftodo;
    //这里列举了recurring,memo,缺少reminder photo
    NSString        *recurringType;
    NSString        *payeeString;
    NSDate          *transactionDate;
    BOOL             showMoreDetails;
    
    //用来存储amount的
	double          currentNumber;
    
    NSMutableArray   *payeeArray;
    NSMutableArray  *accountArray;
    NSMutableArray   *cycleTypeArray;
    NSMutableArray   *categoryArray;
    NSMutableArray  *pickItemArray;
    NSMutableArray  *picureArray;
    NSMutableArray  *tranExpCategorySelectArray;
    NSMutableArray  *tranCategorySelectedArray;

    
    //计算器部分需要用到的东西
    UIView          *calculateView;
	UILabel         *showFoperator;
    BOOL            bBegin;
	BOOL            backOpen;
    
    BOOL            isEnterNumber;
    BOOL            isDotDown;
    double          fstOperand;
    double          thirdOperand;
    NSString        *lastFlag;
    NSString        *arithmeticFlag;
    
    int             firsttoBeHere;
    BOOL            thisTransisBeenDelete;
    
    ipad_TranscationCategorySelectViewController *transactionCategoryViewController;
    ipad_TransacationSplitViewController *transactionCategorySplitViewController;
    
    iPad_OverViewViewController *iOverViewViewController;
    ipad_AccountViewController  *iAccountViewController;
    ipad_BudgetViewController   *iBudgetViewController;
}



@property(nonatomic,strong)IBOutlet UITableView     *showCellTable;
@property(nonatomic,strong)IBOutlet UITableViewCell *accountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *fromAccountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *toAccountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *amountCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *categoryCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *dateCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *recurringCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *noteCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *imageCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *payeeCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *clearCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *showMoreDetailsCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *datePickerCell;
@property(strong, nonatomic) NSIndexPath *selectedRowIndexPath;

@property(nonatomic,assign)BOOL            isSpliteTrans;
@property(nonatomic,strong)IBOutlet UILabel         *sectionHeaderLabel;
@property(nonatomic,strong)IBOutlet UITextField     *payeText;
@property(nonatomic,strong)IBOutlet UIView          *payeeSearchView;
@property(nonatomic,strong)IBOutlet UITableView     *payeeSearchTable;
@property(nonatomic,strong)IBOutlet UIButton        *expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *incomeBtn;
@property(nonatomic,strong)IBOutlet UIButton        *transferBtn;
@property(nonatomic,strong)IBOutlet UILabel         *categoryLabel;
@property(nonatomic,strong)IBOutlet UITextField     *accountLabel;
@property(nonatomic,strong)IBOutlet UITextField         *fromAccountLabel;
@property(nonatomic,strong)IBOutlet UITextField         *toAccountLabel;
@property(nonatomic,strong)IBOutlet UILabel         *dateLabel;
@property(nonatomic,strong)IBOutlet UISwitch        *clearedSwitch;
@property(nonatomic,strong)IBOutlet UILabel         *recurringLabel;
@property(nonatomic,strong)IBOutlet UIImageView     *phontoImageView;
@property(nonatomic,strong)IBOutlet UILabel         *memoLabel;
@property(nonatomic,strong)IBOutlet UITextView      *memoTextView;
@property(nonatomic,strong)NSString                 *documentsPath;
@property(nonatomic,strong)NSDateFormatter* outputFormatter;
@property(nonatomic,strong)NSDateFormatter *headerDateormatter;
@property(nonatomic,assign)BOOL             showMoreDetails;

@property(nonatomic,strong)IBOutlet UIDatePicker    *datePicker;
@property(nonatomic,assign) NSInteger		picktype;
@property(nonatomic,strong) 	NSString*                    photosName;


@property(nonatomic,strong)IBOutlet UILabel         *cagetoryLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *accountLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *fromAccountLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *toAccountLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *dateLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *repeatLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *ClearedLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *photoLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *showMoreLabelText;



@property(nonatomic,strong)Transaction              *transaction;
@property(nonatomic,strong)Accounts                 *accounts;
@property(nonatomic,strong)Accounts                 *fromAccounts;
@property(nonatomic,strong)Accounts                 *toAccounts;
@property(nonatomic,strong)Category                 *categories;
@property(nonatomic,strong)Category        *otherCategory_expense;
@property(nonatomic,strong)Category        *otherCategory_income;
@property(nonatomic,strong)Payee                    *payees;
@property(nonatomic,strong)NSString                 *typeoftodo;
@property(nonatomic,strong)NSString                 *recurringType;
@property(nonatomic,strong)NSString                 *payeeString;
@property(nonatomic,strong)NSDate                   *transactionDate;

//用来存储amount的
@property(nonatomic,assign)double                   currentNumber;

@property(nonatomic,strong)NSMutableArray           *payeeArray;
@property(nonatomic,strong)NSMutableArray*              accountArray;
@property(nonatomic,strong)NSMutableArray           *cycleTypeArray;
@property(nonatomic,strong)NSMutableArray           *categoryArray;
@property(nonatomic,strong)NSMutableArray           *pickItemArray;
@property(nonatomic,strong)NSMutableArray           *picureArray;
@property(nonatomic,strong)NSMutableArray           *tranExpCategorySelectArray;
@property(nonatomic,strong)NSMutableArray           *tranCategorySelectedArray;

//计算器部分需要用到的东西
@property(nonatomic,strong)IBOutlet UILabel         *display;

@property(nonatomic,strong)IBOutlet UILabel         *showFoperator;

@property(nonatomic,strong)IBOutlet UIView          *calculateView;

@property(nonatomic,assign)BOOL                     thisTransisBeenDelete;
@property(nonatomic,strong)ipad_TranscationCategorySelectViewController *transactionCategoryViewController;
@property(nonatomic,strong)ipad_TransacationSplitViewController *transactionCategorySplitViewController;

@property(nonatomic,strong)iPad_OverViewViewController *iOverViewViewController;
@property(nonatomic,strong)ipad_AccountViewController  *iAccountViewController;
@property(nonatomic,strong)ipad_BudgetViewController   *iBudgetViewController;
@property(nonatomic,strong)ipad_AccountPickerViewController *iAccountPickerViewController;
@property(nonatomic,strong)ipad_SearchRelatedViewController *searchReleatedViewController;

-(IBAction)calculateBtnPressed:(UIButton *)sender;
//-(void)addAccountBtnPressed;

-(IBAction)TextDidEnd:(UITextField *)textField;
-(IBAction)TextFieldDidBeginEditing:(UITextField *)textField;
-(void)initAllSplitCategoryMemory;
-(void)refleshUI;
@end

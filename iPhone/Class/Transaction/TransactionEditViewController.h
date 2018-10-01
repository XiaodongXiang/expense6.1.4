//
//  TransactionEditViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-5.
//
//

#import <UIKit/UIKit.h>
#import "HMJPickerView.h"
#import "HMJTableViewCell.h"

#import "Transaction.h"
#import "Accounts.h"
#import "Category.h"
#import "Payee.h"

#define hmjclearBtn	11	// C
#define divBtn      12	// ÷
#define mulBtn      13	// x
#define subBtn      14	// -
#define plusBtn     15	// +
#define equalBtn    16	// =
#define backBtn		17	// ←
#define dotBtn      18	// .

@class TransactionCategoryViewController,TransactionCategorySplitViewController,AccountPickerViewController;
@interface TransactionEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HMJPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calculateB;

//transaction cell
@property(nonatomic,strong)IBOutlet UITableView     *showCellTable;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *accountCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *fromAccountCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *toAccountCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *amountCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *categoryCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *dateCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *recurringCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *noteCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *imageCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *payeeCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *clearCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *showMoreDetailsCell;
@property(nonatomic,strong)IBOutlet HMJTableViewCell *datePickerCell;

//transaction little control grid
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payeeSearchViewT;
@property(nonatomic,strong)IBOutlet UIView          *payeeSearchView;
@property(nonatomic,strong)IBOutlet UITableView     *payeeSearchTable;
@property(nonatomic,strong)IBOutlet UIImageView     *payeeListBg;
@property(nonatomic,strong)IBOutlet UILabel         *sectionHeaderLabel;
@property(nonatomic,strong)IBOutlet UITextField     *payeText;
@property(nonatomic,strong)IBOutlet UIButton        *expenseBtn;
@property(nonatomic,strong)IBOutlet UIButton        *incomeBtn;
@property(nonatomic,strong)IBOutlet UIButton        *transferBtn;
@property(nonatomic,strong)IBOutlet UILabel         *categoryLabel;
@property(nonatomic,strong)IBOutlet UITextField     *accountLabel;
@property(nonatomic,strong)IBOutlet UITextField     *fromAccountLabel;
@property(nonatomic,strong)IBOutlet UITextField     *toAccountLabel;
@property(nonatomic,strong)IBOutlet UILabel         *dateLabel;
@property(nonatomic,strong)IBOutlet UISwitch        *clearedSwitch;
@property(nonatomic,strong)IBOutlet UILabel         *recurringLabel;
@property(nonatomic,strong)IBOutlet UIImageView     *phontoImageView;
@property(nonatomic,strong)IBOutlet UILabel         *memoLabel;
@property(nonatomic,strong)IBOutlet UITextView      *memoTextView;
@property(nonatomic,strong)IBOutlet UIDatePicker    *datePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datepickerWidth;



//local langue
@property(nonatomic,strong)IBOutlet UILabel         *accountLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *fromAccountLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *cagetoryLabelText;
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
@property(nonatomic,strong)Category                 *otherCategory_expense;
@property(nonatomic,strong)Category                 *otherCategory_income;
@property(nonatomic,strong)Payee                    *payees;
@property(nonatomic,strong)NSString                 *typeoftodo;
@property(nonatomic,strong)NSString                 *recurringType;
@property(nonatomic,assign)NSInteger                picktype;
@property(nonatomic,strong)NSString*                photosName;
//用来存储amount的
@property(nonatomic,assign)double                   currentNumber;
@property(strong,nonatomic)NSIndexPath              *selectedRowIndexPath;
@property(nonatomic,assign)BOOL                     showMoreDetails;
@property(nonatomic,assign)BOOL                     isSpliteTrans;
@property(nonatomic,strong)NSDate                   *transactionDate;
@property(nonatomic,strong)NSDateFormatter          *headerDateormatter;
@property(nonatomic,strong)NSDateFormatter          *outputFormatter;
@property(nonatomic,strong)NSString                 *documentsPath;

//array
@property(nonatomic,strong)NSMutableArray           *payeeArray;
@property(nonatomic,strong)NSMutableArray*          accountArray;
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
@property(nonatomic,assign)BOOL                     bBegin;
@property(nonatomic,assign)BOOL                     backOpen;
@property(nonatomic,assign)BOOL                     isDotDown;
@property(nonatomic,assign)double                   fstOperand;
@property(nonatomic,strong)NSString                 *arithmeticFlag;
@property(nonatomic,assign)int                      firsttoBeHere;


@property (weak, nonatomic) IBOutlet UIButton *calculator_c;
@property (weak, nonatomic) IBOutlet UIButton *calculator_d;
@property (weak, nonatomic) IBOutlet UIButton *calculator_m;
@property (weak, nonatomic) IBOutlet UIButton *calculator_mi;
@property (weak, nonatomic) IBOutlet UIButton *calculator_2;
@property (weak, nonatomic) IBOutlet UIButton *calculator_3;
@property (weak, nonatomic) IBOutlet UIButton *calculator_add;
@property (weak, nonatomic) IBOutlet UIButton *calculator_4;
@property (weak, nonatomic) IBOutlet UIButton *calculator_5;
@property (weak, nonatomic) IBOutlet UIButton *calculator_6;
@property (weak, nonatomic) IBOutlet UIButton *calculator_7;
@property (weak, nonatomic) IBOutlet UIButton *calculator_8;
@property (weak, nonatomic) IBOutlet UIButton *calculator_9;
@property (weak, nonatomic) IBOutlet UIButton *calculator_equal;
@property (weak, nonatomic) IBOutlet UIButton *calculator_point;
@property (weak, nonatomic) IBOutlet UIButton *calculator_0;
@property (weak, nonatomic) IBOutlet UIButton *calculator_re;
@property (weak, nonatomic) IBOutlet UIButton *calculator_1;







@property(nonatomic,strong)UILabel                  *tileLabel;

@property(nonatomic,assign)BOOL                     thisTransisBeenDelete;
@property(nonatomic,assign)BOOL                     isFromHomePage;
@property(nonatomic,strong)TransactionCategoryViewController *transactionCategoryViewController;
@property(nonatomic,strong)TransactionCategorySplitViewController *transactionCategorySplitViewController;
@property(nonatomic,strong)AccountPickerViewController *accountPickerViewController;


-(IBAction)calculateBtnPressed:(UIButton *)sender;
-(IBAction)TextDidEnd:(UITextField *)textField;
-(IBAction)TextFieldDidBeginEditing:(UITextField *)textField;
-(void)initAllSplitCategoryMemory;

//sync
-(void)refleshUI;
@end

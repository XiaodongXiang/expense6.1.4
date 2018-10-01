//
//  NewBillViewController.h
//  Expense 5
//
//  Created by BHI_James on 5/4/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ipad_BillsViewController.h"

#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "Category.h"
#import "Payee.h"
#import "Accounts.h"
#import "Transaction.h"
#import "BillFather.h"

#import "BillCategoryViewController.h"
#import "HMJTableViewCell.h"

@class PaymentViewController;
@interface BillEditViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    NSInteger   selectedCellIntenger;
    float       keyBoardHigh;
    BOOL        keyBoardChangeHeight;
}

//tableview
@property (nonatomic, strong) IBOutlet UITableView		*mytableView;
@property (nonatomic, strong) IBOutlet UIView           *payeeView;
@property (nonatomic, strong) IBOutlet UITableView      *payeeTableView;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*nameCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*amountCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell  *payeeCell;

@property (nonatomic, strong) IBOutlet HMJTableViewCell	*categoryCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*startDateCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*cycleCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*remindCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*notesCell;

@property (nonatomic, strong) IBOutlet HMJTableViewCell	*datePickerCell;
@property (nonatomic, strong) IBOutlet HMJTableViewCell	*endDateCell;

//grid
@property (nonatomic, strong) IBOutlet UITextField		*nameText;
@property (nonatomic, strong) IBOutlet UITextField		*amountText;
@property (nonatomic, strong) IBOutlet UITextField      *payeeText;
@property (nonatomic, strong) IBOutlet UILabel			*categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel			*startDateLabel;
@property (nonatomic, strong) IBOutlet UILabel			*cycleLabel;
@property (nonatomic, strong) IBOutlet UILabel			*remindLabel;
@property (nonatomic, strong) NSString                  *reminderDateString;
@property (nonatomic, strong) NSDate                    *reminderTime;
@property (nonatomic, strong) IBOutlet UILabel          *memoLabel;
@property (nonatomic, strong) IBOutlet UITextView       *memoTextView;
@property (nonatomic, strong) IBOutlet UIDatePicker     *startDatePicker;
@property (nonatomic, assign) double                    amount;
@property (nonatomic, strong) IBOutlet UILabel          *endDateLabel;
@property (nonatomic, strong) BillFather                *billFather;
@property (nonatomic, strong) Category					*categories;
@property (nonatomic, strong) Payee                     *payee;
@property (nonatomic, strong) NSString					*typeOftodo;
@property (nonatomic, strong) NSString                  *recurringType;

@property (nonatomic, strong) NSIndexPath               *selectedRowIndexPath;
@property (nonatomic, strong) NSDate					*starttime;
@property (nonatomic, strong) NSDate					*endtime;
@property (nonatomic, strong) NSDateFormatter			*outputFormatter;
@property (nonatomic, strong) NSDateFormatter			*daysFormatter;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSDate                    *realBillDueDate;
@property (nonatomic, strong) NSDateFormatter           *headerDateormatter;

//local langue
@property (nonatomic,strong)IBOutlet UILabel            *nameLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *amountLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *payeeLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *categoryLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *dateLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *repeatLabelText;
@property (nonatomic,strong)IBOutlet UILabel            *alertLabelText;
@property (nonatomic, strong) IBOutlet UILabel          *endDateLabelText;
@property (nonatomic, strong) NSMutableArray			*categoryArray;
@property(nonatomic,strong)NSMutableArray               *payeeArray;

@property (nonatomic, assign) BOOL isDelete;
@property(nonatomic,assign)BOOL thisBillisBeenDelete;

@property(nonatomic,strong)BillCategoryViewController *billCategoryViewController;
@property(nonatomic,strong)PaymentViewController *paymentViewController;


-(IBAction)textFieldDidBeginEditing:(UITextField *)textField;
-(IBAction) didEndEdit;
-(IBAction) amountTextDid:(id)sender;
-(IBAction)EditChanged:(id)sender;
-(IBAction)TextDidEnd:(id)sender;

-(void)refleshUI;
 @end
 


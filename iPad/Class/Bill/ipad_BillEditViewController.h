//
//  NewBillViewController.h
//  Expense 5
//
//  Created by BHI_James on 5/4/10.
//  Copyright 2010 BHI. All rights reserved.
//

/*---------------这个viewController既是bill 也是 reminder viewcontroller--------------------*/
#import <UIKit/UIKit.h>
#import "BillRule.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "Category.h"
#import "Payee.h"
#import "Accounts.h"
#import "Transaction.h"
#import "BillFather.h"
@class ipad_BillsViewController,ipad_PaymentViewController,iPad_BillCategoryViewController;

@interface ipad_BillEditViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
	UITableView											*mytableView;
    UIView                                              *payeeView;
    UITableView                                         *payeeTableView;
 	UITableViewCell										*nameCell;
	UITableViewCell										*amountCell;
	UITableViewCell                                     *payeeCell;
    
	UITableViewCell										*categoryCell;
	UITableViewCell										*startDateCell;
	UITableViewCell										*cycleCell;
    
	UITableViewCell										*remindCell;
	UITableViewCell										*notesCell;
    
	UITextField											*nameText;
	UITextField											*amountText;
    
	UILabel												*categoryLabel;
    UITextField                                        *payeeText;
	UILabel												*startDateLabel;
	UILabel												*cycleLabel;
	UILabel												*remindLabel;
    UILabel         *memoLabel;
    UITextView      *memoTextView;
    UIDatePicker                                        *startDatePicker;
    
    UILabel         *nameLabelText;
    UILabel         *amountLabelText;
    UILabel         *payeeLabelText;
    UILabel         *categoryLabelText;
    UILabel         *dateLabelText;
    UILabel         *repeatLabelText;
    UILabel         *alertLabelText;
    
    
	NSDateFormatter										*outputFormatter;
	NSDateFormatter										*daysFormatter;
	NSString											*typeOftodo;
    NSString                                            *reminderDateString;
    NSDate                                              *reminderTime;
	
    
    BillFather                                          *billFather;
	NSDate												*realBillDueDate;
	Category											*categories;
	Payee                                               *payee;
    NSString        *recurringType;
    
	NSDate												*starttime;
	NSDate												*endtime;
 	UIActivityIndicatorView								*activityView;
	double                                              amount;
	NSMutableArray										*categoryArray;
    NSMutableArray                                      *payeeArray;
    
	BOOL isDelete;
    
    BOOL thisBillisBeenDelete;
    NSInteger   selectedCellIntenger;
    float keyBoardHigh;
    BOOL        keyBoardChangeHeight;
    
    NSDateFormatter *headerDateormatter;

    ipad_BillsViewController *iBillsViewController;
    ipad_PaymentViewController *iPaymentViewController;
    
    UITableViewCell                                     *datePickerCell;
    UITableViewCell                                     *endDateCell;
    NSIndexPath                                         *selectedRowIndexPath;
    UILabel                                             *endDateLabel;
    UILabel                                             *endDateLabelText;

}

@property (nonatomic, strong) NSMutableArray			*categoryArray;
@property(nonatomic,strong)NSMutableArray               *payeeArray;
@property (nonatomic, assign) double                    amount;

@property (nonatomic, strong) IBOutlet UITableView		*mytableView;
@property (nonatomic, strong) IBOutlet UIView           *payeeView;
@property (nonatomic, strong) IBOutlet UITableView      *payeeTableView;
@property (nonatomic, strong) IBOutlet UITableViewCell	*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*amountCell;
@property (nonatomic, strong) IBOutlet UITableViewCell  *payeeCell;

@property (nonatomic, strong) IBOutlet UITableViewCell	*categoryCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*startDateCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*cycleCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*remindCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*notesCell;


@property (nonatomic, strong) IBOutlet UITextField		*nameText;
@property (nonatomic, strong) IBOutlet UITextField		*amountText;
@property (nonatomic, strong) IBOutlet UITextField      *payeeText;

@property (nonatomic, strong) IBOutlet UILabel			*categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel			*startDateLabel;
@property (nonatomic, strong) IBOutlet UILabel			*cycleLabel;
@property (nonatomic, strong) IBOutlet UILabel			*remindLabel;
@property (nonatomic, strong) NSString                  *reminderDateString;
@property (nonatomic, strong) NSDate                    *reminderTime;
@property (nonatomic, strong) IBOutlet UILabel         *memoLabel;
@property (nonatomic, strong) IBOutlet UITextView      *memoTextView;
@property (nonatomic,strong)IBOutlet UIDatePicker       *startDatePicker;

@property (nonatomic,strong)IBOutlet UILabel         *nameLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *amountLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *payeeLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *categoryLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *dateLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *repeatLabelText;
@property (nonatomic,strong)IBOutlet UILabel         *alertLabelText;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSDate	*realBillDueDate;


@property (nonatomic, strong) NSDateFormatter			*outputFormatter;
@property (nonatomic, strong) NSDateFormatter			*daysFormatter;

@property (nonatomic, strong) NSString					*typeOftodo;

@property (nonatomic, strong) BillFather                *billFather;
@property (nonatomic, strong) Category					*categories;
@property (nonatomic, strong) Payee                     *payee;
@property (nonatomic, strong) NSString        *recurringType;

@property (nonatomic, strong) NSDate					*starttime;
@property (nonatomic, strong) NSDate					*endtime;

@property (nonatomic, assign) BOOL isDelete;

@property(nonatomic,assign)BOOL thisBillisBeenDelete;

@property (nonatomic, strong) NSDateFormatter *headerDateormatter;
@property (nonatomic, strong)ipad_BillsViewController *iBillsViewController;
@property (nonatomic, strong)ipad_PaymentViewController *iPaymentViewController;
@property(nonatomic,strong)iPad_BillCategoryViewController *iBillCategoryViewController;

@property (nonatomic, strong) IBOutlet UITableViewCell	*datePickerCell;
@property (nonatomic, strong) IBOutlet UITableViewCell	*endDateCell;
@property (nonatomic, strong) NSIndexPath  *selectedRowIndexPath;
@property (nonatomic, strong) IBOutlet UILabel       *endDateLabel;
@property (nonatomic, strong) IBOutlet UILabel          *endDateLabelText;



-(IBAction)EditChanged:(id)sender;
-(IBAction)TextDidEnd:(id)sender;
-(void)refleshUI;
 @end
 


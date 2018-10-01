//
//  NewAccountViewController.h
//  Expense 5
//
//  Created by BHI_James on 4/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
#import "AccountType.h"

@class ipad_AccountViewController,ipad_AccountTypeViewController,ipad_AccountPickerViewController;
@interface ipad_AccountEditViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL                    fistToBeHere;
    double                  accAmount;
    
    NSDateFormatter         *outputFormatter;
    NSMutableArray          *aevc_accountArray;
    NSMutableArray          *aevc_accountTypeArray;
}

@property(nonatomic,strong)NSMutableArray *colorBtnArray;
@property(nonatomic,strong)UIButton *formerSelectedBtn;

@property (nonatomic, strong) IBOutlet UITableView			*mytableView;
@property (nonatomic, strong) IBOutlet UITableViewCell		*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell		*amountCell;
@property (nonatomic, strong) IBOutlet UITableViewCell		*typeCell;
@property (nonatomic, strong) IBOutlet UITableViewCell      *TimeCell;
@property (nonatomic, strong) IBOutlet UITableViewCell      *autoClearCell;
@property (nonatomic, strong) IBOutlet UITableViewCell   *datePickerCell;
@property (nonatomic, assign)           NSInteger           selectedRow;
@property (strong, nonatomic) IBOutlet UITableViewCell *colorSelectCell;

@property (nonatomic, strong) IBOutlet UITextField			*nameText;
@property (nonatomic, strong) IBOutlet UITextField			*amountText;
@property (nonatomic, strong) IBOutlet UILabel				*typeLabel;
@property (nonatomic, strong) IBOutlet UILabel              *timeLabel;
@property (nonatomic, strong) IBOutlet UISwitch             *autoClearSwitch;
@property (nonatomic,strong) IBOutlet UIDatePicker*      datePicker;
@property (nonatomic, strong) NSString						*typeOftodo;

@property (nonatomic, strong) IBOutlet UILabel             *nameLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *balanceLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *dateLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *typeLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *clearedLabelText;

@property (nonatomic, strong) Accounts						*accounts;
@property (nonatomic, strong)  AccountType                  *accountType;


@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *expenseBtn;


@property (nonatomic,strong) ipad_AccountViewController                  *iAccountViewController;
@property (nonatomic,strong)ipad_AccountTypeViewController              *iAccountTypeViewController;
@property(nonatomic,strong)ipad_AccountPickerViewController  *accountPickerViewController;


 -(IBAction) TextDidEnd:(id)sender;
 -(IBAction) EditChanged:(id)sender;

-(IBAction) positiveBtnPressed:(id)sender;

-(IBAction) negativeBtnPressed:(id)sender;

- (IBAction)incomeBtnPressed:(id)sender;
- (IBAction)expenseBtnPressed:(id)sender;

-(IBAction)dateSelected;
-(void)refleshUI;
@end
 


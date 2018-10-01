//
//  NewAccountViewController.h
//
//  Created by BHI_James on 4/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
#import "AccountType.h"
#import "AccountTypeViewController.h"
#import "AccountPickerViewController.h"

@class AccountsViewController;
@interface AccountEditViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,strong)NSMutableArray *colorBtnArray;
@property(nonatomic,strong)UIButton *formerSelectedBtn;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerLineHigh;


@property (nonatomic, strong) IBOutlet UITableView			*mytableView;
@property (nonatomic, strong) IBOutlet UITableViewCell		*nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell		*amountCell;
@property (nonatomic, strong) IBOutlet UITableViewCell		*typeCell;
@property (nonatomic, strong) IBOutlet UITableViewCell      *autoClearCell;
@property (nonatomic, strong) IBOutlet UITableViewCell   *timeCell;
@property (nonatomic, strong) IBOutlet UITableViewCell   *datePickerCell;
@property (nonatomic, strong) NSIndexPath             *selectedIndex;


@property (nonatomic, strong) IBOutlet UILabel                  *timeLabel;
@property (nonatomic, strong) IBOutlet UISwitch             *autoClearSwitch;

@property (nonatomic, strong) IBOutlet UILabel             *nameLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *balanceLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *dateLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *typeLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *clearedLabelText;


@property (nonatomic, strong) IBOutlet UITextField			*nameText;
@property (nonatomic, strong) IBOutlet UITextField			*amountText;
@property (nonatomic, strong) IBOutlet UILabel				*typeLabel;
@property (nonatomic, strong) IBOutlet UIView				*amountView;
@property (nonatomic, strong) NSString						*typeOftodo;

@property (nonatomic, strong) NSMutableArray				*pickerArray;
 
@property (nonatomic, strong) Accounts						*accounts;
@property (nonatomic, strong)  AccountType                  *accountType;

@property(nonatomic,strong) IBOutlet UIDatePicker*      datePicker;

@property (nonatomic, strong) NSDateFormatter *outputFormatter;
@property (nonatomic, assign) double       accAmount;
@property (nonatomic, strong) UINavigationController *navController;

@property(nonatomic,strong)NSMutableArray       *aevc_accountTypeArray;
@property(nonatomic,strong)NSMutableArray                                          *aevc_accountArray;
@property(nonatomic,strong)AccountTypeViewController *accountTypeViewController;
@property(nonatomic,strong)AccountPickerViewController  *accountPickerViewController;

@property (strong, nonatomic)  UIView *signView;

@property (strong, nonatomic)  UIButton *signBtn;
@property (strong, nonatomic) IBOutlet UITableViewCell *backgroundCell;




-(IBAction)TextDidEnd:(id)sender;
-(IBAction) amountTextDid:(id)sender;
-(IBAction)EditChanged:(id)sender;

-(IBAction) positiveBtnPressed:(id)sender;

-(IBAction) negativeBtnPressed:(id)sender;
-(void)reflashUI;
 @end
 


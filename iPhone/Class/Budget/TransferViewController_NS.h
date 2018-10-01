//
//  TransferViewController.h
//  Expense 5
//
//  Created by BHI_James on 4/23/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetTemplate.h"
#import "BudgetTransfer.h"

@interface TransferViewController_NS : UIViewController 
<UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;

@property (weak, nonatomic) IBOutlet UIImageView *fromBgImage;
@property (nonatomic, strong) IBOutlet UILabel      *fromBudgetLabelText;
@property (nonatomic, strong) IBOutlet UILabel		*fromLabel;
@property (nonatomic, strong) IBOutlet UILabel		*fromTotalLabel;

@property (weak, nonatomic) IBOutlet UIImageView *toBgImage;
@property (nonatomic, strong) IBOutlet UILabel       *toBudgetTextLabel;
@property (nonatomic, strong) IBOutlet UILabel		*toLabel;
@property (nonatomic, strong) IBOutlet UILabel		*toTotalLabel;
@property (nonatomic, strong) IBOutlet UIButton     *btnToBudget;

@property (nonatomic, strong) IBOutlet UILabel      *amountLabelText;
@property (nonatomic, strong) IBOutlet UITextField	*amountText;

@property (nonatomic, strong) NSDate                *startDate;
@property (nonatomic, strong) NSDate                *endDate;
@property (nonatomic, assign) double                amountNum;
@property (nonatomic, strong) NSString				*typeOftodo;
@property (nonatomic, strong) BudgetTemplate		*fromBudget;
@property (nonatomic, strong) BudgetTemplate		*toBudget;
@property (nonatomic, strong) BudgetTransfer		*budgetTransfer;

@property (nonatomic, strong) NSMutableArray        *selectBudgetArray;
 
@property (nonatomic, strong) IBOutlet  UIPickerView*customerPick;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;


-(IBAction)TextDidEnd:(id)sender;
-(IBAction) amountTextDid:(id)sender;
-(IBAction)EditChanged:(id)sender;
@end

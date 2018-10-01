//
//  ipad_TransferViewController_NS.h
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import <UIKit/UIKit.h>
#import "BudgetTemplate.h"
#import "BudgetItem.h"
#import "BudgetTransfer.h"

@interface ipad_TransferViewController_NS : UIViewController
<UIPickerViewDelegate,UITextFieldDelegate>
{
	UILabel             *fromLabel;
	UILabel             *toLabel;
	UILabel             *fromTotalLabel;
	UILabel             *toTotalLabel;
    
	UIButton            *btnToBudget;
	UITextField			*amountText;
    UILabel             *toBudgetTextLabel;
    
    UILabel             *fromBudgetLabelText;
    UILabel             *amountLabelText;


    
	NSString			*typeOftodo;
	
	BudgetTemplate		*fromBudget;
	BudgetTemplate		*toBudget;
	
	BudgetTransfer		*budgetTransfer;
	double				amountNum;
    
	NSMutableArray      *selectBudgetArray;
    
	UIPickerView        *customerPick;
    NSDate              *startDate;
    NSDate              *endDate;
    
    
}
@property (nonatomic, strong) NSDate  *startDate;
@property (nonatomic, strong) NSDate  *endDate;

@property (nonatomic, assign) double				  amountNum;


@property (nonatomic, strong) IBOutlet UILabel			*fromLabel;
@property (nonatomic, strong) IBOutlet UILabel			*toLabel;
@property (nonatomic, strong) IBOutlet UILabel			 *fromTotalLabel;
@property (nonatomic, strong) IBOutlet UILabel			 *toTotalLabel;
@property (nonatomic, strong) IBOutlet UILabel          *toBudgetTextLabel;


@property (nonatomic, strong) IBOutlet UITextField		*amountText;

@property (nonatomic, strong) NSString					*typeOftodo;

@property (nonatomic, strong) BudgetTemplate			*fromBudget;
@property (nonatomic, strong) BudgetTemplate			*toBudget;

@property (nonatomic, strong) BudgetTransfer			*budgetTransfer;

@property (nonatomic, strong) IBOutlet UILabel             *fromBudgetLabelText;
@property (nonatomic, strong) IBOutlet UILabel             *amountLabelText;



@property (nonatomic, strong) NSMutableArray*              selectBudgetArray;

@property (nonatomic, strong) IBOutlet  UIPickerView*                customerPick;

@property (nonatomic, strong) IBOutlet UIButton *btnToBudget;

-(IBAction)TextDidEnd:(id)sender;
-(IBAction) amountTextDid:(id)sender;
-(IBAction)EditChanged:(id)sender;


@end

//
//  ipad_BillPaymentViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-18.
//
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
#import "BillFather.h"
#import "Transaction.h"

@protocol ipad_BillPaymentViewDelegate <NSObject>

-(void)billPaySuccess;

@end
@interface ipad_BillPaymentViewController : UIViewController
<UITextFieldDelegate,NSFetchedResultsControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
	UITableView         *paymtnTableVeiw;
    UITableViewCell     *amountTableViewCell;
    UITableViewCell     *accountTableViewCell;
    UITableViewCell     *dateTableViewCell;
    
    UITextField         *amountText;
    UILabel             *accountLabel;
    UILabel             *dateLabel;
    
    double              amount;
    Accounts            *account;
    NSDate              *date;
    
    BillFather          *billFather;
    Transaction         *transaction;
    
    NSMutableArray      *accountArray;
    NSMutableArray      *categoyrArray;
    UIPickerView        *accountPickerView;
    UIDatePicker        *datePicker;
    
    NSString            *typeoftodo;
    NSDateFormatter     *dateFormatter;
    
    UILabel             *amountLabelText;
    UILabel             *accountLabelText;
    UILabel             *paymentDateLabelText;
}

@property(nonatomic,strong)IBOutlet UITableView         *paymtnTableVeiw;
@property(nonatomic,strong)IBOutlet UITableViewCell     *amountTableViewCell;
@property(nonatomic,strong)IBOutlet UITableViewCell     *accountTableViewCell;
@property(nonatomic,strong)IBOutlet UITableViewCell     *dateTableViewCell;

@property(nonatomic,strong)IBOutlet UITextField         *amountText;
@property(nonatomic,strong)IBOutlet UILabel             *accountLabel;
@property(nonatomic,strong)IBOutlet UILabel             *dateLabel;

@property(nonatomic,strong)NSDate              *date;
@property(nonatomic,assign)double              amount;
@property(nonatomic,strong)Accounts            *account;
@property(nonatomic,strong)BillFather                   *billFather;
@property(nonatomic,strong)Transaction                  *transaction;

@property(nonatomic,strong)NSMutableArray               *accountArray;
@property(nonatomic,strong)NSMutableArray               *categoyrArray;
@property(nonatomic,strong)IBOutlet UIPickerView        *accountPickerView;
@property(nonatomic,strong)IBOutlet UIDatePicker        *datePicker;

@property(nonatomic,strong)NSString            *typeoftodo;
@property(nonatomic,strong)NSDateFormatter     *dateFormatter;

@property(nonatomic,strong)IBOutlet UILabel             *amountLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *accountLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *paymentDateLabelText;

@property(nonatomic,weak)id<ipad_BillPaymentViewDelegate> xxdDelegate;

@end

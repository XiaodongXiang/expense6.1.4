 

#import <UIKit/UIKit.h>
#import "RepTransactionFilterViewController.h" 
#import "RepCashflowFilterViewController.h" 
//#import "RepBillFilterViewController.h" 

@interface CustomDateRangeViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate> {

	IBOutlet UITableView *addTableView;
 	IBOutlet UITableViewCell *startDateCell;
	IBOutlet UITableViewCell *endDatecell;
	
 	IBOutlet UILabel *startDateLabel;
	IBOutlet UILabel *endDateLabel;
    
    UILabel     *startDateLabelText;
    UILabel     *endDateLabelText;
    
	NSDate *fromDate;
	NSDate *toDate;

	IBOutlet UIDatePicker *dateSelectPick;
 	NSInteger selectNum;
	
    RepTransactionFilterViewController *repTransactionFilterViewController;
    RepCashflowFilterViewController *repCashflowFilterViewController;
	NSString *moduleString;
 	
    UITableViewCell *datepickerCell;
    NSIndexPath     *selectedIndex;
    UITableViewCell *endPickerCell;
    UIDatePicker    *endPicker;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *date1LineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *date2LineHigh;

@property (nonatomic, strong) UITableView *addTableView;
@property (nonatomic, strong) UITableViewCell *titleCell;
@property (nonatomic, strong) UITableViewCell *startDateCell;
@property (nonatomic, strong) UITableViewCell *endDatecell;

@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;

@property (nonatomic, strong)IBOutlet UILabel     *startDateLabelText;
@property (nonatomic, strong)IBOutlet UILabel     *endDateLabelText;


@property (nonatomic, strong) UIDatePicker *dateSelectPick;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, assign) NSInteger selectNum;

@property (nonatomic, strong) RepTransactionFilterViewController *repTransactionFilterViewController;
@property (nonatomic, strong) RepCashflowFilterViewController *repCashflowFilterViewController;


@property (nonatomic, copy ) NSString *moduleString;

@property (nonatomic, strong)IBOutlet UITableViewCell *datepickerCell;
@property (nonatomic, strong)NSIndexPath     *selectedIndex;
@property (nonatomic, strong)IBOutlet UITableViewCell *endPickerCell;
@property (nonatomic, strong)IBOutlet UIDatePicker    *endPicker;

-(IBAction)PvalueChange;

@end

//
//  CustomDateRangeViewController_iPad.h
//  PocketExpense
//
//  Created by humingjing on 14-6-5.
//
//

#import <UIKit/UIKit.h>

@class ipad_RepTransactionFilterViewController,ipad_RepCashflowFilterViewController;

@interface CustomDateRangeViewController_iPad : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
	IBOutlet UITableView *addTableView;
 	IBOutlet UITableViewCell *startDateCell;
	IBOutlet UITableViewCell *endDatecell;
	
 	IBOutlet UILabel *startDateLabel;
	IBOutlet UILabel *endDateLabel;
	NSDate *fromDate;
	NSDate *toDate;
    
    UILabel     *startDateLabelText;
    UILabel     *endDateLabelText;
    
	IBOutlet UIDatePicker *dateSelectPick;
 	NSInteger selectNum;
	
    ipad_RepTransactionFilterViewController *repTransactionFilterViewController;
    ipad_RepCashflowFilterViewController *repCashflowFilterViewController;
    //    RepBillFilterViewController     *repBillFilterViewController;
	NSString *moduleString;
 	
    UITableViewCell *datepickerCell;
    NSIndexPath     *selectedIndex;
    UITableViewCell *endPickerCell;
    UIDatePicker    *endPicker;
    
}

@property (nonatomic, strong) UITableView *addTableView;
@property (nonatomic, strong) UITableViewCell *startDateCell;
@property (nonatomic, strong) UITableViewCell *endDatecell;

@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UIDatePicker *dateSelectPick;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, assign) NSInteger selectNum;

@property (nonatomic, strong)IBOutlet UILabel     *startDateLabelText;
@property (nonatomic, strong)IBOutlet UILabel     *endDateLabelText;

@property (nonatomic, strong) ipad_RepTransactionFilterViewController *repTransactionFilterViewController;
@property (nonatomic, strong) ipad_RepCashflowFilterViewController *repCashflowFilterViewController;
//@property (nonatomic, strong) RepBillFilterViewController     *repBillFilterViewController;


@property (nonatomic, copy ) NSString *moduleString;

@property (nonatomic, strong)IBOutlet UITableViewCell *datepickerCell;
@property (nonatomic, strong)NSIndexPath     *selectedIndex;
@property (nonatomic, strong)IBOutlet UITableViewCell *endPickerCell;
@property (nonatomic, strong)IBOutlet UIDatePicker    *endPicker;


-(IBAction)PvalueChange;


@end

//
//  CustomDateViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import <UIKit/UIKit.h>

@class ExpenseViewController;
@interface CustomDateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger               *cdvc_dateType;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startPickerLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endPickerLineH;

@property(nonatomic,strong)IBOutlet UITableView    *cdvc_tableView;
@property(nonatomic,strong)IBOutlet UITableViewCell*cdvc_startCell;
@property(nonatomic,strong)IBOutlet UITableViewCell*cdvc_endCell;
@property(nonatomic,strong)IBOutlet UILabel        *cdvc_staetDateLabel;
@property(nonatomic,strong)IBOutlet UILabel        *cdvc_endDateLabel;

@property(nonatomic,strong)IBOutlet UILabel                 *startDateLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *endDateLabelText;

@property(nonatomic,strong)NSDate                  *cdvc_startDate;
@property(nonatomic,strong)NSDate                  *cdvc_endDate;

@property(nonatomic,strong)IBOutlet UIDatePicker            *cdvc_datePicker;
@property(nonatomic,strong)NSDateFormatter         *cdvc_Formatter;

@property(nonatomic,strong)ExpenseViewController   *cdvc_expenseViewController;

@property(nonatomic,strong)IBOutlet UITableViewCell         *startDateCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *endDateCell;
@property(nonatomic,strong)IBOutlet UIDatePicker            *endDatePicker;
@property(nonatomic,strong) NSIndexPath             *selectedIndex;

@end

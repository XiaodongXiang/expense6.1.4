//
//  ReminderViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import <UIKit/UIKit.h>

@class BillEditViewController;
@interface ReminderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderDateCellL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderDateCellLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderAtLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerLineH;


@property(nonatomic,strong)IBOutlet UITableView             *myTableView;
@property(nonatomic,strong)IBOutlet UITableViewCell         *reminederDateCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *reminderTimeCell;

@property(nonatomic,strong)IBOutlet UILabel                 *reminederDateLabel;
@property(nonatomic,strong)IBOutlet UILabel                 *reminderTimeLabel;

@property(nonatomic,strong)IBOutlet UILabel                 *reminderLabelText;
@property(nonatomic,strong)IBOutlet UILabel                 *reminderTimeLabelText;

@property(nonatomic,strong)NSString                         *reminderType;
@property(nonatomic,strong)NSDate                           *reminderTime;

@property(nonatomic,strong)IBOutlet UIPickerView            *picker;
@property(nonatomic,strong)IBOutlet UIDatePicker            *datePicker;

@property(nonatomic,strong)NSDateFormatter                  *dateFormatter;

@property(nonatomic,strong)NSMutableArray                   *reminderTypeArray;
@property(nonatomic,strong)BillEditViewController           *billEditViewController;

@property(nonatomic,strong)IBOutlet UITableViewCell         *pickerCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *datePickerCell;
@property(nonatomic,strong)NSIndexPath                      *selectedRowIndexPath;

@end

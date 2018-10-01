//
//  iPad_ReminderViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import <UIKit/UIKit.h>

@class ipad_BillEditViewController;

@interface iPad_ReminderViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>{
    UITableView             *myTableView;
    UITableViewCell         *reminederDateCell;
    UITableViewCell         *reminderTimeCell;
    
    UILabel                 *reminederDateLabel;
    UILabel                 *reminderTimeLabel;
    
    UILabel                 *reminderLabelText;
    UILabel                 *reminderTimeLabelText;
    
    NSString                *reminderType;
    NSDate                  *reminderTime;
    
    UIPickerView            *picker;
    UIDatePicker            *datePicker;
    
    NSDateFormatter         *dateFormatter;
    
    NSMutableArray          *reminderTypeArray;
    ipad_BillEditViewController  *iBillEditViewController;
    
    UITableViewCell         *pickerCell;
    UITableViewCell         *datePickerCell;
    NSIndexPath             *selectedRowIndexPath;
}

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
@property(nonatomic,strong)ipad_BillEditViewController  *iBillEditViewController;

@property(nonatomic,strong)IBOutlet UITableViewCell         *pickerCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *datePickerCell;
@property(nonatomic,strong) NSIndexPath             *selectedRowIndexPath;

@end

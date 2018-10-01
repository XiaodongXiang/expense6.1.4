//
//  iPad_EndDateViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-8-24.
//
//

#import <UIKit/UIKit.h>

@class ipad_BillEditViewController;

@interface iPad_EndDateViewController : UIViewController
{
    UITableView *mytableView;
    
    UITableViewCell         *forverCell;
    UITableViewCell         *endDateCell;
    UITableViewCell         *datePickerCell;
    UIDatePicker            *endDatePicker;
    NSIndexPath             *selectedRowIndexPath;
    
    
    NSDate                  *endDate;
    ipad_BillEditViewController  *billEditViewController;
}

@property(nonatomic,strong)IBOutlet UITableView *mytableView;

@property(nonatomic,strong)IBOutlet UITableViewCell         *forverCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *endDateCell;
@property(nonatomic,strong)IBOutlet UITableViewCell         *datePickerCell;
@property(nonatomic,strong)IBOutlet UIDatePicker            *endDatePicker;
@property(nonatomic,strong)NSIndexPath             *selectedRowIndexPath;

@property(nonatomic,strong) NSDate                          *endDate;
@property(nonatomic,strong) ipad_BillEditViewController          *billEditViewController;
@end

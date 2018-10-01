//
//  EndDateViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-8-21.
//
//

#import <UIKit/UIKit.h>

@class BillEditViewController;
@interface EndDateViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forverLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLineL;

@property(nonatomic,strong)IBOutlet UITableView      *mytableView;

@property(nonatomic,strong)IBOutlet UITableViewCell  *forverCell;
@property(nonatomic,strong)IBOutlet UITableViewCell  *endDateCell;
@property(nonatomic,strong)IBOutlet UITableViewCell  *datePickerCell;
@property(nonatomic,strong)IBOutlet UIDatePicker     *endDatePicker;
@property(nonatomic,strong)NSIndexPath               *selectedRowIndexPath;

@property(nonatomic,strong) NSDate                   *endDate;
@property(nonatomic,strong) BillEditViewController   *billEditViewController;
@end

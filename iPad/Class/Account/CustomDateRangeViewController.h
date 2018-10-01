 

#import <UIKit/UIKit.h>
#import "ipad_AccountViewController.h"
#import "ipad_ReportCategotyViewController.h"
#import "CategoryViewController_iPad.h"

//#import "ipad_CategoryViewController.h"
//#import "ipad_ReportViewController.h"
//#import "ipad_ReportControlPanelViewController.h"

@interface CustomDateRangeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	
}
@property (nonatomic, strong)NSDate *fromDate;
@property (nonatomic, strong)NSDate *toDate;

@property (nonatomic, assign)NSInteger selectNum;
@property (nonatomic, strong)NSString *moduleString;
@property (nonatomic, strong)NSIndexPath     *selectedIndex;

@property (nonatomic, strong) UITableView *addTableView;
@property (nonatomic, strong) UITableViewCell *titleCell;
@property (nonatomic, strong) UITableViewCell *startDateCell;
@property (nonatomic, strong) UITableViewCell *endDatecell;

@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UIDatePicker *dateSelectPick;

@property (nonatomic, strong)IBOutlet UILabel         *startDateLabelText;
@property (nonatomic, strong)IBOutlet UILabel         *endDateLabelText;

@property (nonatomic, strong) ipad_AccountViewController *iAccountViewController;
@property (nonatomic, strong)CategoryViewController_iPad  *categoryViewController;



@property (nonatomic, strong)IBOutlet UITableViewCell *datepickerCell;
@property (nonatomic, strong)IBOutlet UITableViewCell *endDatePickerCell;
@property (nonatomic, strong)IBOutlet UIDatePicker    *endDatePicker;
-(IBAction)PvalueChange;

@end

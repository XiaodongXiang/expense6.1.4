//
//  ipad_EmailViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Category.h"
#import "Accounts.h"

@interface ipad_EmailViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate,
NSFetchedResultsControllerDelegate
>

{
	UITableView             *myTableView;
    
    UITableViewCell         *cellGroupBy;
    UITableViewCell         *cellCategory;
    UITableViewCell         *cellAccount;
	UITableViewCell         *cellStartDate;
	UITableViewCell         *cellEndDate;
    UITableViewCell         *cellSequence;
    
    
	NSDate                  *startDate;
	NSDate                  *endDate;
	UIDatePicker            *datePicker;
	Category                *category;
    Accounts                *accounts;
    
    UILabel                 *lblStartDate;
	UILabel                 *lblEndDate;
	UILabel                 *lblCategory;
    UILabel                 *lblAccount;
    
	NSMutableArray          *categoryArray;//获取所有的category
    NSMutableArray          *accountArray;
    
    UIButton                *groupCategoryBtn;
    UIButton                *groupAccountBtn;
    UIButton                *sequenceAscBtn;
    UIButton                *sequenceDesBtn;
    
    
    UILabel             *groupByLabelText;
    UILabel             *categoryLabelText;
    UILabel             *accountsLabelText;
    UILabel             *startFromLabelText;
    UILabel             *endToLabelText;
    UILabel             *sequenceLabelText;
    
    UITableViewCell *datepickerCell;
    NSIndexPath     *selectedIndex;
    UITableViewCell *endDatePickerCell;
    UIDatePicker    *endDatePicker;
}


@property (nonatomic, strong) NSFetchedResultsController    *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UITableView          *myTableView;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellGroupBy;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellCategory;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellAccount;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellStartDate;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellEndDate;
@property (nonatomic, strong) IBOutlet UITableViewCell      *cellSequence;


@property (nonatomic, strong) NSDate                        *startDate;
@property (nonatomic, strong) NSDate                        *endDate;
@property (nonatomic, strong) IBOutlet UIDatePicker         *datePicker;
@property (nonatomic, strong) IBOutlet UILabel              *lblStartDate;
@property (nonatomic, strong) IBOutlet UILabel              *lblEndDate;
@property (nonatomic, strong) IBOutlet UILabel              *lblCategory;
@property (nonatomic, strong) IBOutlet UILabel              *lblAccount;
@property (nonatomic, strong) NSMutableArray                *categoryArray;
@property (nonatomic, strong) NSMutableArray                *accountArray;

@property (nonatomic, strong) Category                      *category;
@property (nonatomic, strong) Accounts                      *accounts;

@property (nonatomic) int segIndex;

@property (nonatomic, strong)IBOutlet UIButton               *groupCategoryBtn;
@property (nonatomic, strong)IBOutlet UIButton               *groupAccountBtn;
@property (nonatomic, strong)IBOutlet UIButton               *sequenceAscBtn;
@property (nonatomic, strong)IBOutlet UIButton               *sequenceDesBtn;

@property (nonatomic, strong)IBOutlet UILabel             *groupByLabelText;
@property (nonatomic, strong)IBOutlet UILabel             *categoryLabelText;
@property (nonatomic, strong)IBOutlet UILabel             *accountsLabelText;
@property (nonatomic, strong)IBOutlet UILabel             *startFromLabelText;
@property (nonatomic, strong)IBOutlet UILabel             *endToLabelText;
@property (nonatomic, strong)IBOutlet UILabel             *sequenceLabelText;

@property (nonatomic, strong)IBOutlet UITableViewCell *datepickerCell;
@property (nonatomic, strong)NSIndexPath     *selectedIndex;
@property(nonatomic,strong)IBOutlet UITableViewCell *endDatePickerCell;
@property(nonatomic,strong)IBOutlet UIDatePicker    *endDatePicker;
-(void)dateSelected;

@end

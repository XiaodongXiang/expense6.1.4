//
//  iPad_EndDateViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-8-24.
//
//

#import "iPad_EndDateViewController.h"
#import "ipad_BillEditViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface iPad_EndDateViewController ()

@end

@implementation iPad_EndDateViewController
@synthesize mytableView,forverCell,endDateCell,datePickerCell,endDatePicker,endDate,billEditViewController,selectedRowIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPoint];
    [self initNavBarStyle];
    [self initContex];
}

-(void)initContex
{
    if (self.endDate != nil)
    {
        self.endDatePicker.date = self.endDate;
    }
    
}
-(void)initPoint
{
    selectedRowIndexPath = nil;
    [endDatePicker addTarget:self action:@selector(datePickerValueChange) forControlEvents:UIControlEventValueChanged];
    
    [forverCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]]];
    
    [endDateCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]]];
    
    self.endDatePicker.minimumDate = self.billEditViewController.starttime;
    self.endDatePicker.maximumDate = nil;
    
    endDatePicker.datePickerMode = UIDatePickerModeDate;
}

-(void)initNavBarStyle
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"End Repeat";
    self.navigationItem.titleView = 	titleLabel;
    
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 30, 30);
    [customerButton setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
 	[customerButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2)
    {
        return 216;
    }
    else
        return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedRowIndexPath != nil)
    {
        return 3;
    }
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    
    
    if (self.endDate==nil)
    {
        forverCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        endDateCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    
    
    if (indexPath.row==0)
    {
        return forverCell;
    }
    else if (indexPath.row==1)
        return endDateCell;
    else
        return datePickerCell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedRowIndexPath==nil && indexPath.row==1)
    {
        selectedRowIndexPath = indexPath;
    }
    else
        selectedRowIndexPath = nil;
    
    NSIndexPath *selectionIndexPath = nil;
    if (self.endDate==nil)
    {
        selectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else
        selectionIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row==0)
    {
        self.endDate = nil;
    }
    else
        self.endDate = endDatePicker.date;
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [self insertorDelegateDatePickerCell];
}

-(void)datePickerValueChange
{
    self.endDate = endDatePicker.date;
}

-(void)deleteDatePickerCell
{
    selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (selectedRowIndexPath!=nil)
    {
        if ([mytableView numberOfRowsInSection:0]==2)
        {
            [mytableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else
    {
        if ([mytableView numberOfRowsInSection:0]==3) {
            [mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}

#pragma mark Btn Action
-(void)back:(id)sender
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];
    
    self.billEditViewController.endtime = self.endDate;
    if (self.endDate == nil)
    {
        self.billEditViewController.endDateLabel.text = NSLocalizedString(@"VC_Forever", nil);
    }
    else
        self.billEditViewController.endDateLabel.text = [outputFormatter stringFromDate:self.endDate];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

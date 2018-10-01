//
//  CustomDateViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import "CustomDateViewController.h"
#import "ExpenseViewController.h"
#import "ExpenseSecondCategoryViewController.h"

#import "AppDelegate_iPhone.h"

@interface CustomDateViewController ()

@end

@implementation CustomDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavBarStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;

}

#pragma mark View Did Load Method
-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_CustomRange", nil);

    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(0, 0, 90, 30);
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [doneBtn.titleLabel setMinimumScaleFactor:0];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
	[doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBar =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];
}

-(void)initPoint
{
    _startLineH.constant = EXPENSE_SCALE;
    _endLineH.constant = EXPENSE_SCALE;
    _startPickerLineH.constant = EXPENSE_SCALE;
    _endPickerLineH.constant = EXPENSE_SCALE;
    
    _startDateLabelText.text = NSLocalizedString(@"VC_StartDate", nil);
    _endDateLabelText.text = NSLocalizedString(@"VC_EndDate", nil);
    
    cdvc_dateType = 0;
    
    _cdvc_Formatter = [[NSDateFormatter alloc]init];
    [_cdvc_Formatter setDateFormat:@"MMM dd, yyyy"];
    
    if (self.cdvc_expenseViewController != nil)
    {
        self.cdvc_startDate = self.cdvc_expenseViewController.categoryStartDate;
        self.cdvc_endDate = self.cdvc_expenseViewController.categoryEndDate;
    }

    self.cdvc_staetDateLabel.text = [_cdvc_Formatter stringFromDate:self.cdvc_startDate];
    self.cdvc_endDateLabel.text = [_cdvc_Formatter stringFromDate:self.cdvc_endDate];
    _cdvc_datePicker.backgroundColor = [UIColor whiteColor];
    [_cdvc_datePicker addTarget:self action:@selector(datePickerSelected:) forControlEvents:UIControlEventValueChanged];
    [_endDatePicker addTarget:self action:@selector(datePickerSelected:) forControlEvents:UIControlEventValueChanged];

}

#pragma mark Btn Action
-(void)back:(UIButton *)sender
{
    [self.navigationController popToViewController:(UIViewController *)self.cdvc_expenseViewController  animated:YES];
}

-(void)save:(UIButton *)sender{
    //不跑
    if ([self.cdvc_startDate compare:self.cdvc_endDate]==NSOrderedDescending ) {
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Start date should be earlier than End Date.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        appDelegate_iPhone.appAlertView = alertView;
        return;
    }
    
//    unsigned int flags = NSDayCalendarUnit;
//	//4.dateTime
// 	NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.cdvc_startDate toDate:self.cdvc_endDate options:nil];

    if (self.cdvc_expenseViewController!=nil) {
        self.cdvc_expenseViewController.dateType = 6;
        self.cdvc_expenseViewController.categoryStartDate = self.cdvc_startDate;
        self.cdvc_expenseViewController.categoryEndDate = self.cdvc_endDate;
        [self.navigationController popToViewController:self.cdvc_expenseViewController animated:YES];
    }
}

-(void)datePickerSelected:(id)sender{
    if (cdvc_dateType == 0) {
        self.cdvc_startDate = _cdvc_datePicker.date;
        _cdvc_staetDateLabel.text =  [_cdvc_Formatter stringFromDate:self.cdvc_startDate];
    }
    else{
        self.cdvc_endDate = _endDatePicker.date;
        _cdvc_endDateLabel.text = [_cdvc_Formatter stringFromDate:self.cdvc_endDate];
    }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex)
    {
        return 3;
    }
    else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex && indexPath.row == self.selectedIndex.row+1)
    {
        return 216;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return _cdvc_startCell;
    }
    else if (indexPath.row==1)
    {
        if (self.selectedIndex && self.selectedIndex.row==0)
        {
            return _startDateCell;
        }
        else
            return _cdvc_endCell;
    }
    else
    {
         if (self.selectedIndex && self.selectedIndex.row==0)
         {
             return _cdvc_endCell;
         }
        else
            return _endDateCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [_cdvc_tableView beginUpdates];
    if (self.selectedIndex)
    {
        if (indexPath.row != self.selectedIndex.row)
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
            if (indexPath.row > self.selectedIndex.row) {
                indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedIndex = indexPath;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
            
            self.selectedIndex = nil;
        }
        
        
    }
    else
    {
        self.selectedIndex = indexPath;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
        
    }

    if (indexPath.row == 0) {
        cdvc_dateType = 0;
        if (self.cdvc_startDate != nil ) {
            [_cdvc_datePicker setDate:self.cdvc_startDate animated:NO];
            _cdvc_datePicker.maximumDate = self.cdvc_endDate ;
            _cdvc_datePicker.minimumDate = nil;
        }
    }
    else
    {
        cdvc_dateType = 1;
        if (self.cdvc_endDate != nil ) {
            [_endDatePicker setDate:self.cdvc_endDate animated:NO];
        }
       _endDatePicker.minimumDate = self.cdvc_startDate;
        _endDatePicker.maximumDate = nil;
    }

    
    [_cdvc_tableView endUpdates];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

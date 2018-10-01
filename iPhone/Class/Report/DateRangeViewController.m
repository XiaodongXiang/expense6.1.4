//
//  DateRangeViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import "DateRangeViewController.h"
#import "ExpenseViewController.h"
#import "ExpenseSecondCategoryViewController.h"

#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"

#import "CustomDateViewController.h"

@interface DateRangeViewController ()

@end

@implementation DateRangeViewController
@synthesize dateTableView,thisMonthCell,lastMonthCell,thisQuarterCell,lastQuarterCell,thisYearCell,lastYearCell,customCell;
@synthesize expenseViewController,expenseCategoryViewController,expenseSecondCategoryViewController,cashDetailViewController;
@synthesize thisMonthLabelText,lastMonthLabelText,thisQuarterLabelText,lastQuarterLabelText,thisYearLabelText,lastYearLabelText,customRangeLabelText;


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
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavBarStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_DateRange", nil);
    
    thisMonthLabelText.text = NSLocalizedString(@"VC_ThisMonth", nil);
    lastMonthLabelText.text = NSLocalizedString(@"VC_LastMonth", nil);
    thisQuarterLabelText.text = NSLocalizedString(@"VC_ThisQuarter", nil);
    lastQuarterLabelText.text = NSLocalizedString(@"VC_LastQuarter", nil);
    thisYearLabelText.text = NSLocalizedString(@"VC_ThisYear", nil);
    lastYearLabelText.text = NSLocalizedString(@"VC_LastYear", nil);
    customRangeLabelText.text = NSLocalizedString(@"VC_CustomRange", nil);
}

-(void)initPoint
{
    [thisMonthCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [lastMonthCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [thisQuarterCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [lastQuarterCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [thisYearCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [lastYearCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    [customCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j2_320_44.png"]]];

}
#pragma mark Btn Action
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expenseViewController.dateType==0 && self.expenseViewController!=nil) {
        thisMonthCell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.expenseViewController.dateType==1 && self.expenseViewController!=nil)
        
    {
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryCheckmark;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.expenseViewController.dateType==2 && self.expenseViewController!=nil)
    {
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryCheckmark;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.expenseViewController.dateType==3 && self.expenseViewController!=nil)
    {
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryCheckmark;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.expenseViewController.dateType==4 && self.expenseViewController!=nil)
    {
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.expenseViewController.dateType==5 && self.expenseViewController!=nil)
    {
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryCheckmark;
        customCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        thisMonthCell.accessoryType = UITableViewCellAccessoryNone;
        lastMonthCell.accessoryType = UITableViewCellAccessoryNone;
        thisQuarterCell.accessoryType=UITableViewCellAccessoryNone;
        lastQuarterCell.accessoryType = UITableViewCellAccessoryNone;
        thisYearCell.accessoryType = UITableViewCellAccessoryNone;
        lastYearCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
   
    if (indexPath.row==0) {
        return thisMonthCell;
    }
    else if (indexPath.row==1)
        return lastMonthCell;
    else if (indexPath.row==2)
        return thisQuarterCell;
    else if (indexPath.row==3)
        return lastQuarterCell;
    else if (indexPath.row==4)
        return thisYearCell;
    else if (indexPath.row==5)
        return lastYearCell;
    else
        return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents *startcomponent = [[NSDateComponents alloc] init] ;
	NSDateComponents *endcomponent = [[NSDateComponents alloc] init] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    if (indexPath.row==0) {
        if (self.expenseViewController!=nil)
        {
            self.expenseViewController.categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
            self.expenseViewController.categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.expenseViewController.categoryStartDate];
            self.expenseViewController.dateType=0;
        }
        
        [dateTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (indexPath.row==1)
    {
        
        [startcomponent setMonth:-1];
		[endcomponent setMonth:1];
		[endcomponent setDay:-1];
        NSDate *tmpStartDate = [cal dateByAddingComponents:startcomponent toDate:[NSDate date] options:0];
        if (self.expenseViewController!=nil) {
            self.expenseViewController.categoryStartDate= [appDelegate.epnc getStartDateWithDateType:2 fromDate:tmpStartDate];
            self.expenseViewController.categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.expenseViewController.categoryStartDate];
            self.expenseViewController.dateType=1;
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (indexPath.row==2){
        if (component.month==1 || component.month==2 || component.month==3) {
            [component setMonth:1];
        }
        else if (component.month==4 || component.month==5 || component.month==6){
            [component setMonth:4];

        }
        else if (component.month==7 || component.month==8 || component.month==9){
            [component setMonth:7];

        }
        else{
            [component setMonth:10];

        }
        [component setDay:1];
        [component setHour:0];
        [component setMinute:0];
        [component setSecond:1];
        
        if (self.expenseViewController != nil) {
            self.expenseViewController.categoryStartDate = [cal dateFromComponents:component];
            NSDateComponents *comp = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self.expenseViewController.categoryStartDate];
            comp.year = comp.year;
            comp.month = comp.month + 3;
            comp.day = 0;
            comp.hour = 23;
            comp.minute = 59;
            comp.second = 59;
            self.expenseViewController.categoryEndDate = [cal dateFromComponents:comp];
            self.expenseViewController.dateType=2;
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (indexPath.row==3){
        //获得前一个季度的起始时间
        if (component.month==1 || component.month==2 || component.month==3) {
            component.month = component.month -3;
        }
        else if (component.month==4 || component.month==5 || component.month==6){
            [component setMonth:1];
        }
        else if (component.month==7 || component.month==8 || component.month==9){
            [component setMonth:4];
        }
        else{
            [component setMonth:7];
        }
        [component setDay:1];
        [component setHour:0];
        [component setMinute:0];
        [component setSecond:0];
        
        if (self.expenseViewController!=nil) {
            self.expenseViewController.categoryStartDate = [cal dateFromComponents:component];
            NSDateComponents *comp = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self.expenseViewController.categoryStartDate];
            component.year = component.year;
            comp.month = comp.month + 3;
            comp.day = 0;
            comp.hour = 23;
            comp.minute = 59;
            comp.second = 59;

            self.expenseViewController.categoryEndDate = [cal dateFromComponents:comp];
            self.expenseViewController.dateType=3;

        }
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (indexPath.row==4){
        if (self.expenseViewController != nil) {
            self.expenseViewController.categoryStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
            self.expenseViewController.categoryEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:self.expenseViewController.categoryStartDate];
            self.expenseViewController.dateType=4;
        }

        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (indexPath.row==5){
        component.year = component.year-1;
        component.month = 1;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        if (self.expenseViewController != nil) {
            self.expenseViewController.categoryStartDate = [cal dateFromComponents:component];
            self.expenseViewController.categoryEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:self.expenseViewController.categoryStartDate];
            self.expenseViewController.dateType=5;
        }
        [self.navigationController popViewControllerAnimated:YES];

    }
    else{
        CustomDateViewController *customDateViewController = [[CustomDateViewController alloc]initWithNibName:@"CustomDateViewController" bundle:nil];
        customDateViewController.cdvc_expenseViewController = self.expenseViewController;
        
        [self.navigationController pushViewController:customDateViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

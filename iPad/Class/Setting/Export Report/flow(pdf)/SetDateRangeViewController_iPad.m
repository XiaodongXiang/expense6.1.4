//
//  SetDateRangeViewController_iPad.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "SetDateRangeViewController_iPad.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_RepTransactionFilterViewController.h"
#import "ipad_RepCashflowFilterViewController.h"
#import "CustomDateRangeViewController_iPad.h"
#import "RecurringTypeCell.h"

@interface SetDateRangeViewController_iPad ()

@end

@implementation SetDateRangeViewController_iPad
@synthesize iRepTransactionFilterViewController,iRepCashflowFilterViewController;
@synthesize moduleString,dateRangeString;
@synthesize currentSelect;
@synthesize isSubPopView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */
#pragma mark - Customer API
-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[flexible,leftBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel  setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"VC_Select Date", nil);
    self.navigationItem.titleView = titleLabel;
}

-(NSString *)getDateRangeByIndex
{
	if(currentSelect ==0) return @"This Month";
	if(currentSelect ==1) return @"Last Month";
	if(currentSelect ==2) return @"This Quarter";
	if(currentSelect ==3) return @"Last Quarter";
	if(currentSelect ==4) return @"This Year";
	if(currentSelect ==5) return @"Last 30 days";
	if(currentSelect ==6) return @"Last 60 days";
	if(currentSelect ==7) return @"Last 90 days";
	if(currentSelect ==8) return @"Last 12 Months";
 	if(currentSelect ==-1) return @"Custom";
	return @"";
}

#pragma mark navigationItem event
- (void) back:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) save:(id)sender
{
    if(iRepTransactionFilterViewController != nil)
	{
		if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
		{
			iRepTransactionFilterViewController.tranDateTypeString = [self getDateRangeByIndex];
            
		}
 		[self.navigationController popViewControllerAnimated:YES];
	}
    else if(iRepCashflowFilterViewController !=nil)
    {
        if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
		{
			iRepCashflowFilterViewController.cashDateTypeString = [self getDateRangeByIndex] ;
 		}
 		[self.navigationController popViewControllerAnimated:YES];
        
    }
    //    else if(repBillFilterViewController !=nil)
    //    {
    //        if([moduleString isEqualToString:@"REPORT_BILL"])
    //		{
    //			repBillFilterViewController.billDateTypeString = [[self getDateRangeByIndex] copy];
    //
    //		}
    // 		[self.navigationController popViewControllerAnimated:YES];
    //
    //    }
    
    
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tCellIdentifier = @"transcationCell";
    RecurringTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:tCellIdentifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecurringTypeCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

	
    [cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [cell.nameLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];
    
    if(indexPath.row ==0)
    {
        
        cell.nameLabel.text = NSLocalizedString(@"VC_ThisMonth", nil);
        
        if([dateRangeString isEqualToString:@"This Month"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 0;
            
        }
    }
    else if(indexPath.row ==1){
        cell.nameLabel.text = NSLocalizedString(@"VC_LastMonth", nil);
        if([dateRangeString isEqualToString:@"Last Month"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 1;
            
        }
        
    }
    else if(indexPath.row ==2){
        cell.nameLabel.text = NSLocalizedString(@"VC_ThisQuarter", nil);
        if([dateRangeString isEqualToString:@"This Quarter"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 2;
            
        }
        
    }
    else if(indexPath.row ==3){
        cell.nameLabel.text = NSLocalizedString(@"VC_LastQuarter", nil);
        if([dateRangeString isEqualToString:@"Last Quarter"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 3;
            
        }
        
    }
    else if(indexPath.row ==4){
        cell.nameLabel.text = NSLocalizedString(@"VC_ThisYear", nil);
        if([dateRangeString isEqualToString:@"This Year"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect =4;
            
        }
        
    }
    else if(indexPath.row ==5){
        cell.nameLabel.text = NSLocalizedString(@"VC_Last 30 days", nil);
        if([dateRangeString isEqualToString:@"Last 30 days"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 5;
            
        }
        
    }
    else if(indexPath.row ==6){
        cell.nameLabel.text = NSLocalizedString(@"VC_Last 60 days", nil);
        if([dateRangeString isEqualToString:@"Last 60 days"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 6;
            
            
        }
    }
    else if(indexPath.row ==7){
        cell.nameLabel.text = NSLocalizedString(@"VC_Last 90 days", nil);
        if([dateRangeString isEqualToString:@"Last 90 days"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 7;
            
        }
        
    }
    else if(indexPath.row ==8){
        cell.nameLabel.text = NSLocalizedString(@"VC_Last 12 Months", nil);
        if([dateRangeString isEqualToString:@"Last 12 Months"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            currentSelect = 8;
            
        }
        
    }
    else if(indexPath.row ==9){
        cell.nameLabel.text = NSLocalizedString(@"VC_Custom Filter", nil);
        
        if([dateRangeString isEqualToString:@"Custom"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            currentSelect = -1;
        }
    }
    
    if (indexPath.row== 9)
    {
        cell.lineX.constant = 0;
    }
    else
    {
        cell.lineX.constant = 15;
    }
    return cell;
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row ==9)
	{
		CustomDateRangeViewController_iPad *editController =[[CustomDateRangeViewController_iPad alloc] initWithNibName:@"CustomDateRangeViewController_iPad" bundle:nil];
	 	editController.moduleString = self.moduleString;
        editController.repTransactionFilterViewController = iRepTransactionFilterViewController;
        editController.repCashflowFilterViewController = iRepCashflowFilterViewController;
        
        
        
		[self.navigationController pushViewController:editController animated:YES];
		dateRangeString = @"Custom";
        if(iRepTransactionFilterViewController != nil)
        {
            if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
            {
                iRepTransactionFilterViewController.tranDateTypeString = dateRangeString;
                
            }
        }
        else if(iRepCashflowFilterViewController !=nil)
        {
            if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
            {
                iRepCashflowFilterViewController.cashDateTypeString = dateRangeString;
                
            }
            
        }
		currentSelect = -1;
		return ;
	}
 	
	
	UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelect inSection:0]];
	if(currentSelect == -1) lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
	lastCell.accessoryType = UITableViewCellAccessoryNone;
    
	currentSelect = indexPath.row;
	dateRangeString = [self getDateRangeByIndex];
	UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
	currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if(iRepTransactionFilterViewController != nil)
	{
		if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
		{
			iRepTransactionFilterViewController.tranDateTypeString = dateRangeString;
            
		}
 	}
    else if(iRepCashflowFilterViewController !=nil)
    {
        if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
		{
			iRepCashflowFilterViewController.cashDateTypeString = dateRangeString;
            
		}
        
    }
    //    else if(repBillFilterViewController !=nil)
    //    {
    //        if([moduleString isEqualToString:@"REPORT_BILL"])
    //		{
    //			repBillFilterViewController.billDateTypeString = [dateRangeString copy];
    //
    //		}
    //
    //    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.scrollEnabled = FALSE;
 	currentSelect =-1;
    [self initNavBarStyle];
    self.tableView.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
	
	
	
	[self.tableView reloadData];

}


-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(170, 360);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end

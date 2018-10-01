//
//  SetDateRangeViewController_iPhone.m
//  PocketExpense
//
//  Created by MV on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetDateRangeViewController_iPhone.h"
#import "PokcetExpenseAppDelegate.h"
//#import "CustomDateRangeViewController_iPhone.h"
#import "CustomDateRangeViewController_iPhone.h"

#import "AppDelegate_iPhone.h"
#import "RecurringTypeCell.h"


@implementation SetDateRangeViewController_iPhone
@synthesize repTransactionFilterViewController,repCashflowFilterViewController;
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
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Select Date", nil);
    
    //返回有事件
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
//    flexible.width = -11.f;
//    
//    UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    customerButton.frame = CGRectMake(0, 0,30, 30);
//    [customerButton setImage: [UIImage imageNamed:@"icon_back_30_30.png"] forState:UIControlStateNormal];
//    [customerButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
//    self.navigationItem.leftBarButtonItems = @[flexible,leftButton];

    
    
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
   if(repTransactionFilterViewController != nil)
	{
		if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
		{
			repTransactionFilterViewController.tranDateTypeString = [self getDateRangeByIndex];
            
		}
 		[self.navigationController popViewControllerAnimated:YES];
	}
    else if(repCashflowFilterViewController !=nil)
    {
        if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
		{
			repCashflowFilterViewController.cashDateTypeString = [self getDateRangeByIndex];
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
//--------在IOS7中 cell的背景颜色会被默认成白色，用这个代理来去掉白色背景
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

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
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.row ==9)
	{
		CustomDateRangeViewController_iPhone *editController =[[CustomDateRangeViewController_iPhone alloc] initWithNibName:@"CustomDateRangeViewController_iPhone" bundle:nil];
	 	editController.moduleString = self.moduleString;
        editController.repTransactionFilterViewController = repTransactionFilterViewController;
        editController.repCashflowFilterViewController = repCashflowFilterViewController;
        
//        editController.repBillFilterViewController = self.repBillFilterViewController;
        

		[self.navigationController pushViewController:editController animated:YES];
		dateRangeString = @"Custom";
        if(repTransactionFilterViewController != nil)
        {
            if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
            {
                repTransactionFilterViewController.tranDateTypeString = dateRangeString;
                
            }
        }
        else if(repCashflowFilterViewController !=nil)
        {
            if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
            {
                repCashflowFilterViewController.cashDateTypeString = dateRangeString;
                
            }
            
        }
//        else if(repBillFilterViewController !=nil)
//        {
//            if([moduleString isEqualToString:@"REPORT_BILL"])
//            {
//                repBillFilterViewController.billDateTypeString = [dateRangeString copy];
//                
//            }
//            
//        }

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
    if(repTransactionFilterViewController != nil)
	{
		if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
		{
			repTransactionFilterViewController.tranDateTypeString = dateRangeString;
            
		}
 	}
    else if(repCashflowFilterViewController !=nil)
    {
        if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
		{
			repCashflowFilterViewController.cashDateTypeString = dateRangeString;
            
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
    [self.tableView setScrollEnabled:YES];
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

//
//  SemesterAddViewController.m
//  Schedule
//
//  Created by Tommy on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomDateRangeViewController_iPhone.h"
#import "PokcetExpenseAppDelegate.h" 
#import "AppDelegate_iPhone.h"

@implementation CustomDateRangeViewController_iPhone

@synthesize addTableView;
@synthesize startDateCell,endDatecell;
@synthesize startDateLabel,endDateLabel;
@synthesize dateSelectPick;
@synthesize fromDate,toDate;
@synthesize selectNum;
@synthesize repTransactionFilterViewController,repCashflowFilterViewController;
@synthesize moduleString;
@synthesize startDateLabelText,endDateLabelText;
@synthesize selectedIndex,datepickerCell,endPicker,endPickerCell;

// implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_Custom Date", nil);
	
   	NSDate *now=[NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
	[dc1 setMonth:3];
	self.toDate = [gregorian dateByAddingComponents:dc1 toDate:now options:0];
	self.fromDate = now;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateStyle:NSDateFormatterMediumStyle];
	self.startDateLabel.text = [format stringFromDate:self.fromDate];
  	self.endDateLabel.text = [format stringFromDate:self.toDate];
	dateSelectPick.date = self.fromDate;
    
    startDateLabelText.text = NSLocalizedString(@"VC_StartDate", nil);
    endDateLabelText.text = NSLocalizedString(@"VC_EndDate", nil);
    
    
    [self initPoint];
    
 }

-(void)initPoint
{
    self.startLineHigh.constant = EXPENSE_SCALE;
    self.endLineHigh.constant = EXPENSE_SCALE;
    self.date1LineHigh.constant = EXPENSE_SCALE;
    self.date2LineHigh.constant = EXPENSE_SCALE;
//    [startDateCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [endDatecell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j2_320_44.png"]]];
}
-(void)viewWillAppear:(BOOL)animated
{

//	[addTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
	[super viewWillAppear:animated];
    
    [addTableView reloadData];
 }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self back:nil];
}


-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}
#pragma mark -
#pragma mark Table view methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex && indexPath.row == self.selectedIndex.row+1)
    {
        return 216;
    }
    return 44.0;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedIndex)
    {
        return 3;
    }
	return  2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	
    if (indexPath.row==0)
    {
        return startDateCell;
    }
    else if (indexPath.row==1)
    {
        if (self.selectedIndex && self.selectedIndex.row==0)
        {
            return datepickerCell;
        }
        else
            return endDatecell;
    }
    else
        return  endPickerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[addTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];
    if (self.selectedIndex)
    {
        if (indexPath.row==self.selectedIndex.row)
        {
            [addTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedIndex = nil;
        }
        else
        {
            [addTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
            if (indexPath.row > self.selectedIndex.row) {
                indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedIndex = indexPath;
            [addTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
    else
    {
        self.selectedIndex = indexPath;
        [addTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(selectedIndex.row+1) inSection:selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if(indexPath.row == 1)
    {
        selectNum = 1;
	}
	else
	{
		selectNum = 0;
	}
    [self setPickerDateRange];
    
    
    [addTableView endUpdates];

	
}
-(void)setPickerDateRange
{
    dateSelectPick.maximumDate = self.toDate;
    dateSelectPick.minimumDate = nil;
    self.dateSelectPick.date = self.fromDate;
    
    endPicker.maximumDate = nil;
    endPicker.minimumDate = self.fromDate;
    self.endPicker.date = self.toDate;
}

#pragma mark -
#pragma mark Customer Action
- (void) back:(id)sender
{
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  		if([moduleString isEqualToString:@"REPORT_TRANSCATION"])
		{
			NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.fromDate];
			[parts1 setHour:0];
			[parts1 setMinute:0];
			[parts1 setSecond:0];
			repTransactionFilterViewController.startDate= [[NSCalendar currentCalendar] dateFromComponents:parts1];
			
			NSDateComponents* parts2 = [[NSCalendar currentCalendar] components:flags fromDate: self.toDate];
			[parts2 setHour:23];
			[parts2 setMinute:59];
			[parts2 setSecond:59];
			repTransactionFilterViewController.endDate = [[NSCalendar currentCalendar] dateFromComponents:parts2];
			
		}
		else 		if([moduleString isEqualToString:@"REPORT_CASHFLOW"])
		{
			NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.fromDate];
			[parts1 setHour:0];
			[parts1 setMinute:0];
			[parts1 setSecond:0];
			repCashflowFilterViewController.startDate= [[NSCalendar currentCalendar] dateFromComponents:parts1];
			
			NSDateComponents* parts2 = [[NSCalendar currentCalendar] components:flags fromDate: self.toDate];
			[parts2 setHour:23];
			[parts2 setMinute:59];
			[parts2 setSecond:59];
			repCashflowFilterViewController.endDate = [[NSCalendar currentCalendar] dateFromComponents:parts2];
			
		}
		else 		if([moduleString isEqualToString:@"REPORT_BILL"])
		{
//			NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.fromDate];
//			[parts1 setHour:0];
//			[parts1 setMinute:0];
//			[parts1 setSecond:0];
//			repBillFilterViewController.startDate= [[NSCalendar currentCalendar] dateFromComponents:parts1];
//			
//			NSDateComponents* parts2 = [[NSCalendar currentCalendar] components:flags fromDate: self.toDate];
//			[parts2 setHour:23];
//			[parts2 setMinute:59];
//			[parts2 setSecond:59];
//			repBillFilterViewController.endDate = [[NSCalendar currentCalendar] dateFromComponents:parts2];
			
		}
//    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)PvalueChange
{
	if(selectNum == 0)
	{
		self.fromDate = dateSelectPick.date;
		NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
		[formatDate setDateStyle:NSDateFormatterMediumStyle];
		[formatDate setTimeStyle:NSDateFormatterNoStyle];
		NSString *dateString = [formatDate stringFromDate:self.fromDate];
		self.startDateLabel.text = dateString;
	}
	else
	{
		self.toDate = endPicker.date;
		NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
		[formatDate setDateStyle:NSDateFormatterMediumStyle];
		[formatDate setTimeStyle:NSDateFormatterNoStyle];
		NSString *dateString = [formatDate stringFromDate:self.toDate];
		self.endDateLabel.text = dateString;
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end

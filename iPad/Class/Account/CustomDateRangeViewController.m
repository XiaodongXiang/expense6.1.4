//
//  SemesterAddViewController.m
//  Schedule
//
//  Created by Tommy on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomDateRangeViewController.h"
#import "PokcetExpenseAppDelegate.h" 
@implementation CustomDateRangeViewController

@synthesize addTableView;

- (void)viewDidLoad {
	[super viewDidLoad];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Custom", nil);
    self.navigationItem.titleView = 	titleLabel;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    
    UIButton *nilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nilBtn.frame = CGRectMake(0, 0, 90, 44);
    nilBtn.titleLabel.text = @"";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:nilBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [doneBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];

	
	
   	NSDate *now=[NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
	NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
	[dc1 setMonth:3];
	_toDate = [gregorian dateByAddingComponents:dc1 toDate:now options:0];
	_fromDate = now;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateStyle:NSDateFormatterMediumStyle];
	_startDateLabel.text = [format stringFromDate:_fromDate];
  	_endDateLabel.text = [format stringFromDate:_toDate];
	_dateSelectPick.date = _fromDate;
    
    self.startDateLabelText.text = NSLocalizedString(@"VC_StartDate", nil);
    self.endDateLabelText.text = NSLocalizedString(@"VC_EndDate", nil);
    
    //新添加
    _endDatePicker.date = _toDate;
    
    _dateSelectPick.datePickerMode = UIDatePickerModeDate;
    _endDatePicker.datePickerMode = UIDatePickerModeDate;
 }


-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}
#pragma mark -
#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndex && _selectedIndex.row+1 == indexPath.row)
    {
        return 216;
    }
    else
        return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if (self.selectedIndex != nil)
    {
        return 3;
    }
	return  2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	
    if (indexPath.row==0)
    {
        return _startDateCell;
    }
    else if (indexPath.row==1)
    {
        if (self.selectedIndex &&  self.selectedIndex.row==0 )
        {
            return _datepickerCell;
        }
        else
            return _endDatecell;

    }
    else
    {
        if (self.selectedIndex && self.selectedIndex.row==1)
        {
            return _endDatePickerCell;

        }
        else
            return _endDatecell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    [addTableView beginUpdates];
    if (self.selectedIndex)
    {
        if (indexPath.row != self.selectedIndex.row)
        {
            [addTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
            
            if (indexPath.row>self.selectedIndex.row)
            {
                indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedIndex = indexPath;
            
            [addTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [addTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedIndex = nil;
        }
        
        
    }
    else
    {
        self.selectedIndex = indexPath;
        [addTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    if (self.selectedIndex && self.selectedIndex.row==0)
    {
        _dateSelectPick.maximumDate = self.toDate;
        _dateSelectPick.minimumDate = nil;
        self.dateSelectPick.date = self.fromDate;
        _selectNum = 0;
    }
    else
    {
        _endDatePicker.maximumDate = nil;
        _endDatePicker.minimumDate = self.fromDate;
        self.endDatePicker.date = self.toDate;
        _selectNum = 1;
    }

    
    [addTableView endUpdates];
	
}


#pragma mark -
#pragma mark Customer Action
- (void) back:(id)sender
{
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	if([_moduleString isEqualToString:@"ACCOUNT"]&& _iAccountViewController != nil)
	{
 		
 		NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.fromDate];
		[parts1 setHour:0];
		[parts1 setMinute:0];
		[parts1 setSecond:0];
		_iAccountViewController.startDate=  [[NSCalendar currentCalendar] dateFromComponents:parts1] ;
		
		NSDateComponents* parts2 = [ [NSCalendar currentCalendar] components:flags fromDate: self.toDate];
		[parts2 setHour:23];
		[parts2 setMinute:59];
		[parts2 setSecond:59];
		_iAccountViewController.endDate =  [[NSCalendar currentCalendar] dateFromComponents:parts2] ;
        appDelegate.settings.accDRstring =@"Custom";
        appDelegate.settings.accDRstartDate = _iAccountViewController.startDate;
        appDelegate.settings.accDRendDate = _iAccountViewController.endDate;
        NSError *errors =nil;
        if(![appDelegate.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        }
        
        [_iAccountViewController reFlashTableViewData];
        [_iAccountViewController setDateDurDescByDate];
	}
    else if(_categoryViewController != nil)
    {
        NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.fromDate];
        [parts1 setHour:0];
        [parts1 setMinute:0];
        [parts1 setSecond:0];
        _categoryViewController.startDate=  [[NSCalendar currentCalendar] dateFromComponents:parts1] ;
        
        NSDateComponents* parts2 = [ [NSCalendar currentCalendar] components:flags fromDate: self.toDate];
        [parts2 setHour:23];
        [parts2 setMinute:59];
        [parts2 setSecond:59];
        _categoryViewController.endDate =  [[NSCalendar currentCalendar] dateFromComponents:parts2] ;
        appDelegate.settings.accDRstring =@"Custom";
        appDelegate.settings.accDRstartDate = _iAccountViewController.startDate;
        appDelegate.settings.accDRendDate = _iAccountViewController.endDate;
        NSError *errors =nil;
        if(![appDelegate.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        }
        [_categoryViewController refreshView];
    }
	
	PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegete.pvt = nonePopup;
        
    [appDelegete.AddPopoverController dismissPopoverAnimated:YES];
 
}

-(IBAction)PvalueChange
{
	if(_selectNum == 0)
	{
		self.fromDate = _dateSelectPick.date;
		NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
		[formatDate setDateStyle:NSDateFormatterMediumStyle];
		[formatDate setTimeStyle:NSDateFormatterNoStyle];
		NSString *dateString = [formatDate stringFromDate:self.fromDate];
		self.startDateLabel.text = dateString;
	}
	else
	{
		self.toDate = _endDatePicker.date;
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

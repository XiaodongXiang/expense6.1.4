//
//  ipad_DateRangeTransactionViewController.m
//  PocketExpense
//
//  Created by MV on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_DateRangeTransactionViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_ReportCategoryPopCell.h"
#import "Transaction.h"
#import "ipad_ReportCashFlowViewController.h"
#import "Payee.h"

@implementation ipad_DateRangeTransactionViewController

#pragma mark init Nav bar
-(void)initMemoryDefine
{
    
	outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
    monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM, yyyy"];
    
}

-(void)initNavBarStyle
{

}

#pragma mark -Nav bar button Action

//- (void) compareAction:(id)sender
//{
// 
//    ipad_DateRangeTransactionCompareSelectViewController *compareViewController =[[ipad_DateRangeTransactionCompareSelectViewController alloc] initWithStyle:UITableViewStylePlain];
//    compareViewController.bcd = self.bcd;
//    compareViewController.dateRangeStr = self.dateRangeStr;
//    compareViewController.isExpense = typeSeg.selectedSegmentIndex ? FALSE:TRUE;
//    [self.navigationController pushViewController:compareViewController animated:YES];
//    [compareViewController release];
//}

#pragma mark Table view methods
- (void)configureTransactionCell:(ipad_ReportCategoryPopCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Transaction *transcation=nil ;
    if([_bcd.thisDaytTransactionArray count] > 0)
    {
        transcation = [_bcd.thisDaytTransactionArray objectAtIndex:indexPath.row];
        if (indexPath.row == [_bcd.thisDaytTransactionArray count]-1) {
            cell.bgImageView.image = [UIImage imageNamed:@"ipad_pop_cell_a2_320_60.png"];
        }
        else
        {
            cell.bgImageView.image = [UIImage imageNamed:@"ipad_pop_cell_a1_320_60.png"];
            
        }

    }

    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([transcation.category.categoryType isEqualToString:@"EXPENSE"] || [transcation.childTransactions count]>0)
    {
        if (transcation.payee!=nil && [transcation.payee.name length]>0) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        
        [cell.spentLabel setTextColor:[appDelegete.epnc getAmountRedColor]];
        cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
    }
    else if ([transcation.category.categoryType isEqualToString:@"INCOME"])
    {
        if (transcation.payee!=nil && [transcation.payee.name length]>0) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        
        cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
        
        [cell.spentLabel setTextColor:[appDelegete.epnc getAmountGreenColor]];
    }
    else
    {
        [cell.spentLabel setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",transcation.expenseAccount.accName,transcation.incomeAccount.accName ];
        cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
        
    }
    
    outputFormatter.dateStyle = NSDateFormatterMediumStyle;
    outputFormatter.timeStyle = NSDateFormatterNoStyle;
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
 	NSString* time = [outputFormatter stringFromDate:transcation.dateTime];
	cell.timeLabel.text = time;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
 	return 1;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
        return 22;
 }


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    
    UIView* headerView = [[UIView alloc] init] ;
    
	UIImageView* imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_pop_title_320_22.png"]];
	imageView.frame = CGRectMake(0,0 , 320, 22);
 	[headerView addSubview:imageView];

    
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 482, 22)];
	[stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
 	
 	[stringLabel setTextColor:[UIColor colorWithRed:140.f/255.f green:150.f/255.f blue:156.f/255.f alpha:1]];
	[stringLabel setBackgroundColor:[UIColor clearColor]];
	stringLabel.textAlignment = NSTextAlignmentLeft;
//    if ([iReportCashFlowViewController.reportTypeString isEqualToString:@"expense"]) {
//        stringLabel.text = NSLocalizedString(@"VC_Expense", nil);
//    }
//    else
//        stringLabel.text = NSLocalizedString(@"VC_Income", nil);
//    stringLabel.text = section?@"Income":@"Expense";
	[headerView addSubview:stringLabel];

    
    
    UILabel *stringLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 22)];	
    [stringLabel1 setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
	
	
 	[stringLabel1 setTextColor:[UIColor colorWithRed:140.f/255.f green:150.f/255.f blue:156.f/255.f alpha:1]];
	[stringLabel1 setBackgroundColor:[UIColor clearColor]];
	stringLabel1.textAlignment = NSTextAlignmentRight;
    stringLabel1.text = [appDelegate.epnc formatterString:_bcd.totalAmount];
	[headerView addSubview:stringLabel1];

	return headerView;
}
*/
 
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_bcd.thisDaytTransactionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  	static NSString *CellIdentifier = @"ipad_ReportCategoryPopCell";
	ipad_ReportCategoryPopCell *cell = (ipad_ReportCategoryPopCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[ipad_ReportCategoryPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    [self configureTransactionCell:cell atIndexPath:indexPath  ];
 	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
}
#pragma mark view life cycle
- (void)viewDidLoad 
{
    [self initMemoryDefine];
    [self initNavBarStyle];
 	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated 
{     
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];	
    if([_dateRangeStr isEqualToString:@"Weekly"] || [_dateRangeStr isEqualToString:@"Biweekly"])
    {
        titleLabel.frame = CGRectMake(0, 0, 200, 44);
    }
    
   [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7){
        [titleLabel setTextColor:[UIColor blackColor]];
    }
    else
        [titleLabel setTextColor:[UIColor whiteColor]];
    
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = [monthFormatter stringFromDate:_bcd.dateTime];
    self.navigationItem.titleView = 	titleLabel;
    
    [super viewWillAppear:animated];
}
-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 360);
}

-(IBAction)typeSegChangedAction:(id)sender
{
    [self.myTablewView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return TRUE;
	
}

#pragma mark view release and dealloc
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

//- (void)viewDidUnload 
//{
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}




@end

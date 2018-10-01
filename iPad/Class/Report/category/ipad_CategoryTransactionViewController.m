//
//  TripsViewController.m
//  Mileage Buddy
//
//  Created by Tommy on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ipad_CategoryTransactionViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "ipad_ReportCategoryPopCell.h"
#import "ipad_ReportCategotyViewController.h"
#import "Payee.h"

@implementation ipad_CategoryTransactionViewController
@synthesize outputFormatter;
@synthesize ct,pt;
#pragma mark init Nav bar
-(void)initMemoryDefine
{
    
	outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
 
}

//-(void)initNavBarStyle
//{
//    
////    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_cell_484_44.png"] forBarMetrics:UIBarMetricsDefault];
//    
////	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
////	customerButton.frame = CGRectMake(0, 0, 46, 28);
////	[customerButton setImage: [UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
////	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
////	
////	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
////	
////	self.navigationItem.leftBarButtonItem = leftButton;
////	[leftButton release];
//
//}

#pragma mark -Nav bar button Action

- (void) cancel:(id)sender
{
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Table view methods
- (void)configureTransactionCell:(ipad_ReportCategoryPopCell *)cell atIndexPath:(NSIndexPath *)indexPath
{   Transaction *transcation=nil;
    
    if(ct !=nil)
    {
        CategoryItem *ci =[ct.categoryArray objectAtIndex:indexPath.section];
    
         transcation = [ci.transArray objectAtIndex:indexPath.row];
        if (indexPath.row == [ci.transArray count]-1) {
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
        cell.spentLabel.text =[appDelegete.epnc formatterString:0-[transcation.amount  doubleValue]];
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
    if(ct!=nil)
	return [ct.categoryArray  count];
    
    return 1;
}

 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(ct !=nil)
    {
        CategoryItem *ci =[ct.categoryArray objectAtIndex:section]; 
        if([ci.transArray count] == 0) return 0;
        return 20;

    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(ct == nil) return nil;
      CategoryItem *ci =[ct.categoryArray objectAtIndex:section]; 
    if([ci.transArray count] == 0) return nil;
    

 	UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 482, 20)];
	[stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
 	
 	[stringLabel setTextColor:[appDelegate.epnc getAmountGrayColor]];
	[stringLabel setBackgroundColor:[UIColor clearColor]];
	stringLabel.textAlignment = NSTextAlignmentLeft;
     stringLabel.text = ci.c.categoryName;
    
    
    UILabel *stringLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 300, 20)];
    [stringLabel1 setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
 	[stringLabel1 setTextColor:[appDelegate.epnc getAmountGrayColor]];
	[stringLabel1 setBackgroundColor:[UIColor clearColor]];
	stringLabel1.textAlignment = NSTextAlignmentRight;
     stringLabel1.text =[appDelegate.epnc formatterString:ci.categoryAmount];

	UIView* headerView = [[UIView alloc] init] ;
	UIImageView* imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_head_330_22.png"]];
	imageView.frame = CGRectMake(0,0 , 355, 22);
	[headerView addSubview:imageView];

	[headerView addSubview:stringLabel];
    [headerView addSubview:stringLabel1];



	return headerView;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    CategoryItem *ci =[ct.categoryArray objectAtIndex:section];
    return [ci.transArray count];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
}
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}
 #pragma mark view life cycle
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self initMemoryDefine];
//    [self initNavBarStyle];
	
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_pop_nav_320_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
   

}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 43)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7){
        [titleLabel setTextColor:[UIColor blackColor]];
    }
    else
        [titleLabel setTextColor:[UIColor blackColor]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = ct.cateName;
    
	self.navigationItem.titleView = 	titleLabel;
    
    [self.tableView reloadData];
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return TRUE;
	
}

-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 480);
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

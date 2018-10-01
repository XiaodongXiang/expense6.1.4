//
//  TranscationCategorySelectViewController.m
//  PokcetExpense
//
//  Created by Tommy on 3/7/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

#import "SettingPayeeViewController.h"

#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "PayeeSettingCell.h"
#import "Payee.h"

#import "SettingPayeeEditViewController.h"
#import "UIViewAdditions.h"

@implementation SettingPayeeViewController


#pragma mark -customer API
-(void)initMemoryDefine
{
    _reminderLabelText.text = NSLocalizedString(@"VC_PayeeNoReminder", nil);
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Payee", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;

    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];

}


#pragma mark getData souce

- (void)getDataSouce;
{
    
    [self getFetchRequestResultsController];
// 	NSError *error =nil;
//	
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//	
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
//	[fetchRequest setEntity:entity];
//    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
//    [fetchRequest setPredicate:predicate];
//	
//	// Edit the sort key as appropriate.
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//	
//	[fetchRequest setSortDescriptors:sortDescriptors];
// 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    [payeesArray setArray:objects];

    
    if([[_fetchRequestResultsController sections]count]==0)
	{
		_noRecordView.hidden = NO;
		
	}
	else {
		_noRecordView.hidden = YES;
	}
	
	[_mytableview reloadData];

}
#pragma nav bar button action
 
- (void) back:(id)sender
{
	
	[[self navigationController] popViewControllerAnimated:YES]; 
}
- (void)add:(id)sender
{
	self.settingPayeeEditViewController =[[SettingPayeeEditViewController alloc] initWithNibName:@"SettingPayeeEditViewController" bundle:nil];
	self.settingPayeeEditViewController .typeOftodo = @"ADD";
 	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.settingPayeeEditViewController ];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TableView
-(void)editPayeeAction:(id)sender
{
//    DetailPayeeViewController *editController =[[DetailPayeeViewController alloc] initWithNibName:@"DetailPayeeViewController" bundle:nil];
//    Payee *tmpPayee = (Payee *)[payeesArray objectAtIndex:[sender tag]];
//    editController.payees = tmpPayee;	
//    editController.typeOftodo = @"Edit";
//    [self.navigationController pushViewController:editController animated:YES];
//    [editController release];
    
}
- (void)configureSearchPayeeCell:(PayeeSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections]objectAtIndex:indexPath.section];

    
	Payee *searchPayee = (Payee *)[[sectionInfo objects]objectAtIndex:indexPath.row];
    

 	if (searchPayee.category != nil)
    {
        cell.categoryLabel.text = searchPayee.category.categoryName;
    }
    else
    {
        cell.categoryLabel.text = @"Others";
    }
    cell.payeeLabel.text = searchPayee.name;
    
    if ((indexPath.section == [[_fetchRequestResultsController sections]count]-1) && (indexPath.row == [[sectionInfo objects] count]-1))
        cell.line.left = 0;
    else
        cell.line.left = 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [[_fetchRequestResultsController sections]count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections]objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"PayeeSettingCell";
    PayeeSettingCell *cell = (PayeeSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PayeeSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;//
        
    }

      [self configureSearchPayeeCell:cell atIndexPath:indexPath];
   	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	
	return 50.0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections]objectAtIndex:indexPath.section];
    Payee *tmpPayee = (Payee *)[[sectionInfo objects]objectAtIndex:indexPath.row];
    
    self.settingPayeeEditViewController =[[SettingPayeeEditViewController alloc] initWithNibName:@"SettingPayeeEditViewController" bundle:nil];
    self.settingPayeeEditViewController.payees = tmpPayee;
    self.settingPayeeEditViewController.typeOftodo = @"Edit";
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:self.settingPayeeEditViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}


 
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FALSE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    
    if ([[_fetchRequestResultsController sections] count]>0)
    {
        style = UITableViewCellEditingStyleDelete;
    }
	return style;
}

 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([[_fetchRequestResultsController sections] count]>0)
	{
		AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections]objectAtIndex:indexPath.section];
        Payee *tmpPayee = (Payee *)[[sectionInfo objects]objectAtIndex:indexPath.row];
        [appDelegate_iPhone.epdc deletePayee_sync:tmpPayee];
        [self getDataSouce];
	}
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [_fetchRequestResultsController sectionIndexTitles];
//}

#pragma mark view  life cycle
- (void)viewDidLoad 
{
 	[self initNavBarStyle];
    [self initMemoryDefine];
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.mytableview.separatorColor = RGBColor(226, 226, 226);
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self getDataSouce];
}

-(void)refleshUI{
    if (self.settingPayeeEditViewController != nil) {
        [self.settingPayeeEditViewController refleshUI];
    }
    else
        [self getDataSouce];
}

-(NSFetchedResultsController *)getFetchRequestResultsController
{
    _fetchRequestResultsController = nil;
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"state contains [c] %@",@"1"];
    [fetch setPredicate:pre];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *sorts = [[NSArray alloc]initWithObjects:sort, nil];
    [fetch setSortDescriptors:sorts];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:@"groupByName" cacheName:@"Root"];
    [fetchController  performFetch:&error];
    _fetchRequestResultsController = fetchController;
    return _fetchRequestResultsController;
}

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

//
//  ipad_SettingPayeeViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import "ipad_SettingPayeeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "Payee.h"
#import "ipad_SettingPayeeEditViewController.h"
#import "ipad_PayeeSettingCell.h"

@interface ipad_SettingPayeeViewController ()

@end

@implementation ipad_SettingPayeeViewController

#pragma mark -customer API
-(void)initMemoryDefine
{
    _reminderLabelText.text = NSLocalizedString(@"VC_PayeeNoReminder", nil);
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	back.frame = CGRectMake(0, 0, 30, 30);
	[back setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Payee", nil);
    self.navigationItem.titleView = titleLabel;
    
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
    _mytableview.dataSource = nil;
    _mytableview.delegate = nil;
	[[self navigationController] popViewControllerAnimated:YES];
}
- (void)add:(id)sender
{
	self.iSettingPayeeEditViewController =[[ipad_SettingPayeeEditViewController alloc] initWithNibName:@"ipad_SettingPayeeEditViewController" bundle:nil];
	self.iSettingPayeeEditViewController .typeOftodo = @"ADD";
    [self.navigationController pushViewController:self.iSettingPayeeEditViewController animated:YES];
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
- (void)configureSearchPayeeCell:(ipad_PayeeSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
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
    
    if ((indexPath.section == [[_fetchRequestResultsController sections]count]-1) && (indexPath.row == [[sectionInfo objects] count]-1)) {
        cell.bgImage.image = [UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"];
    }
    else{
        cell.bgImage.image = [UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"];
    }
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
    static NSString *CellIdentifier = @"Cell";
    ipad_PayeeSettingCell *cell = (ipad_PayeeSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[ipad_PayeeSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
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
    
    self.iSettingPayeeEditViewController =[[ipad_SettingPayeeEditViewController alloc] initWithNibName:@"ipad_SettingPayeeEditViewController" bundle:nil];
    self.iSettingPayeeEditViewController.payees = tmpPayee;
    self.iSettingPayeeEditViewController.typeOftodo = @"Edit";
    [self.navigationController pushViewController:self.iSettingPayeeEditViewController animated:YES];
}



- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FALSE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	if ([[_fetchRequestResultsController sections]count]>0)
	{
		if(_mytableview.editing == FALSE)
		{
			style = UITableViewCellEditingStyleDelete;
		}
	}
	return style;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [_fetchRequestResultsController sectionIndexTitles];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[_fetchRequestResultsController sections] count] > 0)
	{
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections]objectAtIndex:indexPath.section];
        Payee *tmpPayee = (Payee *)[[sectionInfo objects]objectAtIndex:indexPath.row];
        
		PokcetExpenseAppDelegate *appDelegate_iPhone =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPhone.epdc deletePayee_sync:tmpPayee];
        [self getDataSouce];
	}
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

#pragma mark view  life cycle
- (void)viewDidLoad
{
 	[self initNavBarStyle];
    [self initMemoryDefine];
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.iSettingPayeeEditViewController = nil;
	[self getDataSouce];
}

-(void)refleshUI{
    if (self.iSettingPayeeEditViewController != nil) {
        [self.iSettingPayeeEditViewController refleshUI];
    }
    else
    {
        [self getDataSouce];
    }
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

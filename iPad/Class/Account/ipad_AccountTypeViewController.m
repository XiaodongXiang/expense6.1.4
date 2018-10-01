 
#import "ipad_AccountTypeViewController.h"
#import "Accounts.h"
#import "ipad_AccountTypeCell.h"
#import "ipad_AccountTypeEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_AccountEditViewController.h"
#import "AppDelegate_iPad.h"
@implementation ipad_AccountTypeViewController

 #pragma mark -
#pragma mark System Events
-(void) viewDidLoad
{	
	[super viewDidLoad];
    if( [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] isEqualToString:@"7"])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initNavStyle];
 	accountTypeList =  [[NSMutableArray alloc] init]  ;
}


-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0,30, 30);
	[customerButton setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
	[customerButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
    
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
	
    
	UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 30,30);
    [customerButton1 setImage: [UIImage imageNamed:@"ipad_icon_add_30_30.png"] forState:UIControlStateNormal];
    [customerButton1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
	
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    titleLabel.text = NSLocalizedString(@"VC_SelectType", nil);
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
 	self.navigationItem.titleView = 	titleLabel;
}
-(void)getDataSource
{
    
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
 	[accountTypeList setArray:objects];
    [_type_tableView reloadData];

    NSIndexPath *jumpIndexPath = nil;
    if(_accEditView != nil && _accEditView.accountType!=nil)
    {
        for(int i=0;i<[accountTypeList count];i++)
        {
            AccountType *oneAccountType = [accountTypeList objectAtIndex:i];
            if (oneAccountType == _accEditView.accountType)
            {
                jumpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
        [_type_tableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    
	
 	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return TRUE;
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
    
    [self getDataSource];
    

}

-(void)refleshUI
{
    [self getDataSource];
    [_type_tableView reloadData];
}




- (void)add:(id)sender
{
 
    ipad_AccountTypeEditViewController *addController =[[ipad_AccountTypeEditViewController alloc] initWithNibName:@"ipad_AccountTypeEditViewController" bundle:nil];
    addController.iAccountTypeViewController = self;
  	addController.editModule = @"ADD";
    [self.navigationController pushViewController:addController animated:YES];


}

- (void) back:(id)sender
{
	
	[[self navigationController] popViewControllerAnimated:YES]; 
}
#pragma mark TableView Events
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [accountTypeList count];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
	static NSString *CellIdentifier = @"AccountSelectCell";
    ipad_AccountTypeCell *cell = (ipad_AccountTypeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[ipad_AccountTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
 		cell.selectionStyle = UITableViewCellSelectionStyleDefault;//
	}
	
	AccountType* tmpAccountType = (AccountType *)[accountTypeList objectAtIndex:indexPath.row];
	cell.nameLabel.text = tmpAccountType.typeName;
	cell.headImageView.image = [UIImage imageNamed:tmpAccountType.iconName];
	if (_accEditView.accountType == tmpAccountType)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    if (indexPath.row== [accountTypeList count]-1)
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_j2_320_44.png"]];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"]];

    }
    cell.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
  	return cell;	
}


-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	AccountType* tmpAccountType = [accountTypeList objectAtIndex:indexPath.row];
	if([tmpAccountType.isDefault boolValue]) 
	{
		return UITableViewCellEditingStyleNone;
	}
	return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(!tableView.editing)
	{
		NSManagedObject *currentType =_accEditView.accountType;
		
		if (currentType != nil) {
			NSInteger index = [accountTypeList indexOfObject:currentType];
			NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
			checkedCell.accessoryType = UITableViewCellAccessoryNone;
            
        }
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        _accEditView.accountType= [accountTypeList objectAtIndex:indexPath.row]  ;
		_accEditView.typeLabel.text = _accEditView.accountType.typeName;
		// Deselect the row.
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除一个accountType之前需要把相关的account的type改成默认的，然后同步到dropbox中以后把这条accountType删除
        AccountType *deleteAccountType = [accountTypeList objectAtIndex:indexPath.row];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.epdc deleteAccountTypeRel:deleteAccountType];
        
//		[accountTypeList removeObjectAtIndex:indexPath.row];
//		
//		[type_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [self getDataSource];
        AccountType *tmpdefaultAccountType=nil;
        
        BOOL isFound=FALSE;
        
        for (int i=0; i<[accountTypeList  count]; i++) {
            AccountType *at = [accountTypeList objectAtIndex:i];
            if([at.typeName isEqualToString:@"Others"])
            {
                isFound= TRUE;
                tmpdefaultAccountType = at;
                break;
            }
        }
        if(!isFound &&[accountTypeList count ]>0)
            tmpdefaultAccountType = [accountTypeList objectAtIndex:0];
        
        self.accEditView.accountType = tmpdefaultAccountType;
        self.accEditView.typeLabel.text = _accEditView.accountType.typeName;

	}   
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
//- (void)viewDidUnload 
//{
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}



@end

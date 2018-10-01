//
//  FrequencyViewController.m
//  PillTracker
//
//  Created by Joe Jia on 3/17/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "AccountTypeViewController.h"
#import "Accounts.h"
#import "AccountSelectCell.h"
#import "AccountTypeEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AccountEditViewController.h"

#import "AppDelegate_iPhone.h"
#import "DropboxSyncTableDefine.h"

@implementation AccountTypeViewController

 #pragma mark -
#pragma mark System Events
-(void) viewDidLoad
{	
	[super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStyle];
    [self initPoint];
    
		
  	
}

-(void)initNavStyle
{
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    
    [self.navigationController.navigationBar doSetNavigationBar];
    
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;

	
	UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 30,30);
    [customerButton1 setImage: [UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
    [customerButton1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];

	self.navigationItem.title = NSLocalizedString(@"VC_SelectType", nil);

}

-(void)initPoint{
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
	self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.frame =CGRectMake(0, 0, 320, 406);
	accountTypeList = [[NSMutableArray alloc] init];
}

-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
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
    [self.tableView reloadData];

    //tableview跳转
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
        [self.tableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
	
}
 
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	[self getDataSource];
}


-(void)reflashUI{
    [self getDataSource];
}


- (void)add:(id)sender
{
 	
	AccountTypeEditViewController *addController =[[AccountTypeEditViewController alloc] initWithNibName:@"AccountTypeEditViewController" bundle:nil];
  	addController.editModule = @"ADD";
    addController.iAccountTypeViewController = self;
  	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
	[[self navigationController] presentViewController:navigationController animated:YES  completion:nil];
}

#pragma mark TableView Events
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
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
    AccountSelectCell *cell = (AccountSelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AccountSelectCell" owner:nil options:nil]lastObject];
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
        cell.lineX.constant = 0;
    }
    else
        cell.lineX.constant = 46;

	
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
	if(!self.tableView.editing)
	{
		NSManagedObject *currentType = _accEditView.accountType;
		
		if (currentType != nil)
        {
			NSInteger index = [accountTypeList indexOfObject:currentType];
			NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
			UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
			checkedCell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		// Set the checkmark accessory for the selected row.
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
		
		// Update the type of the recipe instance
		_accEditView.accountType= [accountTypeList objectAtIndex:indexPath.row]  ;
		_accEditView.typeLabel.text = _accEditView.accountType.typeName;
        _accEditView.formerSelectedBtn.selected=NO;

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
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPhone.epdc deleteAccountTypeRel:deleteAccountType];
        
		[accountTypeList removeObjectAtIndex:indexPath.row];
		
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        

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

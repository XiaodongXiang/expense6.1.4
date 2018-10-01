//
//  FatherCategorySelectedViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import "FatherCategorySelectedViewController.h"
#import "CategoryEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "RecurringTypeCell.h"

@interface FatherCategorySelectedViewController ()

@end

@implementation FatherCategorySelectedViewController
@synthesize categoryEditViewController,myTableView,parentCategoryArray,parentCategory,categoryType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPoint];
    [self initNavStyle];
    [self getExpenseorIncomeFatherCategory];
}

-(void)initNavStyle{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Parent Category", nil);
}
-(void)initPoint
{
    parentCategoryArray = [[NSMutableArray alloc]init];
}
-(void)getExpenseorIncomeFatherCategory{
    [parentCategoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *entityName = @"Category";
	NSString *orderName = @"categoryName";
    NSError  *error = nil;
    NSDictionary *sub;
    if ([self.categoryType isEqualToString:@"expense"]) {
        sub= [[NSDictionary alloc]initWithObjectsAndKeys:@"EXPENSE",@"Type",nil];
        
    }
    else
        sub =[[NSDictionary alloc]initWithObjectsAndKeys:@"INCOME",@"Type",nil];
    NSFetchRequest *fetcheRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchParentCategoy" substitutionVariables:sub];
    
	//根据picktype来定义entityForName
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[appDelegate managedObjectContext]];
	[fetcheRequest setEntity:entity];
	NSSortDescriptor *sortDescriptor;
 	NSArray *sortDescriptors;
	
 	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:orderName ascending:YES];
	sortDescriptors= [[NSArray alloc] initWithObjects:sortDescriptor,nil];
	[fetcheRequest setSortDescriptors:sortDescriptors];
    NSArray *tmpArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetcheRequest error:&error]];

    [parentCategoryArray setArray:tmpArray];
    [myTableView reloadData];
}

#pragma mark Btn Action

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parentCategoryArray count]+1;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *cellIdentifier = @"RecurringTypeCell";
	
 	RecurringTypeCell *cell = (RecurringTypeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[NSBundle mainBundle]loadNibNamed:@"RecurringTypeCell" owner:nil options:nil]lastObject];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
    
    Category *c=nil;
    if (indexPath.row==0)
    {
        cell.nameLabel.text = @"None";
    }
    else
    {
        c = (Category *)[self.parentCategoryArray objectAtIndex:(indexPath.row-1)];
        cell.nameLabel.text = c.categoryName;
    }
	
    
    
    
    //给选中的category做标记
    if (self.parentCategory==nil)
    {
        if (indexPath.row==0)
        {
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
        }
        else
             cell.accessoryType = UITableViewCellAccessoryNone;
            
    }
    else
    {
        if (self.parentCategory == c) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == [parentCategoryArray count])
    {
        cell.lineX.constant = 0;
    }
    else
    {
        cell.lineX.constant = 15;
    }
    cell.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.categoryEditViewController!=nil)
    {
        if (indexPath.row==0)
        {
            self.parentCategory = nil;
            self.categoryEditViewController.selectPCategory = self.parentCategory;
            self.categoryEditViewController.suCategoryNameLabel.text = @"None";
        }
        else
        {
            self.parentCategory = [self.parentCategoryArray objectAtIndex:indexPath.row-1];
            self.categoryEditViewController.selectPCategory = self.parentCategory;
            self.categoryEditViewController.suCategoryNameLabel.text = self.parentCategory.categoryName;
        }
        
        
        if (self.parentCategory==nil)
        {
            NSInteger rowIndex = [self.parentCategoryArray  indexOfObject:@0];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
            checkedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSInteger rowIndex = [self.parentCategoryArray  indexOfObject:self.parentCategory];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
            checkedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // Set the checkmark accessory for the selected row.
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.navigationController popViewControllerAnimated:YES];

    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

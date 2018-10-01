//
//  ipad_FatherCategorySelectedViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import "ipad_FatherCategorySelectedViewController.h"
#import "ipad_CategoryEditViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface ipad_FatherCategorySelectedViewController ()

@end

@implementation ipad_FatherCategorySelectedViewController
@synthesize icategoryEditViewController,myTableView,parentCategoryArray,parentCategory,categoryType;

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
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ];
    
    
  	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[UIColor colorWithRed:48.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Parent Category", nil);
    self.navigationItem.titleView = 	titleLabel;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *cellIdentifier = @"Cell";
	
 	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
    
    Category *c=nil;
    if (indexPath.row==0)
    {
        cell.textLabel.text = @"None";
    }
    else
    {
        c = (Category *)[self.parentCategoryArray objectAtIndex:(indexPath.row-1)];
        cell.textLabel.text = c.categoryName;
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.icategoryEditViewController!=nil)
    {
        if (indexPath.row==0)
        {
            self.parentCategory = nil;
            self.icategoryEditViewController.selectPCategory = self.parentCategory;
            self.icategoryEditViewController.suCategoryNameLabel.text = @"None";
        }
        else
        {
            self.parentCategory = [self.parentCategoryArray objectAtIndex:indexPath.row-1];
            self.icategoryEditViewController.selectPCategory = self.parentCategory;
            self.icategoryEditViewController.suCategoryNameLabel.text = self.parentCategory.categoryName;
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

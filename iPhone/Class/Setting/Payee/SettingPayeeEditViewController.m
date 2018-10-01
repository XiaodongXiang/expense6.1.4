//
//  DetailPayeeViewController.m
//  PokcetExpense
//
//  Created by ZQ on 9/10/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "SettingPayeeEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"
#import "RegexKitLite.h"
#import "Payee.h"

#import "BillCategoryViewController.h"
#import "TransactionCategoryViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation SettingPayeeEditViewController

@synthesize nameCell,categoryCell,noteCell;
@synthesize nameText,CategoryLabel,noteText;
@synthesize	showCellTable;
@synthesize typeOftodo;
@synthesize payees,categories;
@synthesize transactionCategoryViewController;
@synthesize nameLabelText,categoryLabelText,memoLabelText;

#pragma mark view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self initNavBarStyle];
    [self initControlStyleAndEvent];
    [self setControlValueByTransaction];
    
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    CategoryLabel.text = self.categories.categoryName;
    [self setDefaultCategory];
    [showCellTable reloadData];

}

-(void)refleshUI{
    if (self.transactionCategoryViewController != nil) {
        [self.transactionCategoryViewController refleshUI];
    }
}
#pragma mark Btn Action
-(void)initNavBarStyle
{

    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

    
    UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 90, 30);
    [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    
    [customerButton setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
 	[customerButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveBtn.titleLabel setMinimumScaleFactor:0];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [saveBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];

    if ([self.typeOftodo isEqualToString:@"Edit"])
    {
		self.navigationItem.title = NSLocalizedString(@"VC_EditPayee", nil);

 	}
	else
	{
	 	self.navigationItem.title = NSLocalizedString(@"VC_NewPayee", nil);
        
 	}
}

-(void)initControlStyleAndEvent
{
	nameLabelText.text = NSLocalizedString(@"VC_Name", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    memoLabelText.text = NSLocalizedString(@"VC_Memo", nil);
    
 	nameCell.textLabel.text =@"Name";
	categoryCell.textLabel.text =@"Category";
	noteCell.textLabel.text =@"Note";
	
	nameCell.textLabel.hidden = YES;
	categoryCell.textLabel.hidden = YES;
	noteCell.textLabel.hidden = YES;
    [nameText becomeFirstResponder];
    
//    [nameCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [categoryCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [noteCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j2_320_44.png"]]];
    self.nameLineHigh.constant = EXPENSE_SCALE;
    self.categoryLineHigh.constant = EXPENSE_SCALE;
    self.memoLineHigh.constant = EXPENSE_SCALE;
}

-(void)setControlValueByTransaction
{
    if( [self.typeOftodo isEqualToString:@"Edit"] )
	{
		
		if (self.payees.category != nil)
		{
			self.categories = self.payees.category;
		}
        
 		self.nameText.text = self.payees.name;
 		
		self.noteText.text = self.payees.memo;
 		
 	}
 	else 
	{
 		self.CategoryLabel.text = @"Others";
 	}
    
  	[self setDefaultCategory];
	self.CategoryLabel.text = self.categories.categoryName;
    
	NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.showCellTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
	
    
	
}

-(void)setDefaultCategory{
    if(self.categories == nil)
	{
		PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
		NSError *error =nil;
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
		[fetchRequest setEntity:entity];
		
        
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray* objects = [[NSMutableArray alloc]initWithArray: [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
		
		
		
		for (Category *tmpCategory in objects)
		{
			if([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"EXPENSE"])
			{
				self.categories = tmpCategory;
				break;
			}
		}
        
	}
}


#pragma mark Btn Action
- (void) back:(id)sender
{

    if ([self.typeOftodo isEqualToString:@"ADD"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}


- (void) save:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
 	NSError *errors;
    
 	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"state contains [c] %@",@"1"];
    [fetchRequest setPredicate:pre];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors];
	
	NSMutableArray	*payeesList =	[[NSMutableArray alloc] initWithArray:objects];

    
    //check if has been delete
    if (self.payees != nil)
    {
        BOOL hasFound = NO;
        for (int i=0; i<[payeesList count]; i++)
        {
            Payee *onePayee = [payeesList objectAtIndex:i];
            if (onePayee == self.payees)
            {
                hasFound = YES;
                break;
            }

        }
        if (!hasFound)
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
            return;
        }
    }
	
	if([nameText.text length] == 0 )//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Name is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;

		return;
	}
 	else if([CategoryLabel.text length] == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Category is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;

		return;
	}
 	
	for (Payee *tmpPayee in payeesList)
	{
		if([tmpPayee.name isEqualToString:self.nameText.text]&&tmpPayee!=self.payees && tmpPayee.category == self.categories)
		{

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Payee with this category already exists.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
			[alert show];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alert;
			return;
		}
	}
    
 	if(self.payees == nil)
 	{
        
		self.payees = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:context];
    }
    
    self.payees.name = self.nameText.text;
	self.payees.category = self.categories;
 	self.payees.memo = self.noteText.text;
    
    
    self.payees.dateTime = [NSDate date];
    self.payees.state = @"1";
    if ([self.typeOftodo isEqualToString:@"ADD"]) {
        self.payees.uuid = [EPNormalClass GetUUID];
    }
    
	if(![context save:&errors])
	{
		NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
	}
    
    //sync
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryPayeeDataFromLocal:self.payees];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updatePayeeFromLocal:self.payees];
    }

    
    if ([self.typeOftodo isEqualToString:@"Edit"])
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];

    }
    else
    	[self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row==0) {
        return nameCell;
    }
    else if (indexPath.row==1)
        return categoryCell;
    else
        return noteCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:indexPath];
	if ([checkedCell.textLabel.text isEqualToString:@"Name"]) {
        [noteText resignFirstResponder];
        [nameText becomeFirstResponder];
    }
    else if([checkedCell.textLabel.text isEqualToString:@"Category"])
	{
 		[nameText resignFirstResponder];
        [noteText resignFirstResponder];
        
        self.transactionCategoryViewController = [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
        self.transactionCategoryViewController.tvc_payeeEditViewController = self;
        self.transactionCategoryViewController.tcvc_transactionEditViewController = nil;
        [self.navigationController pushViewController:self.transactionCategoryViewController animated:YES];
  	}
 	else if ([checkedCell.textLabel.text isEqualToString:@"Note"])
	{
 		[nameText resignFirstResponder];
        [noteText becomeFirstResponder];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [nameText resignFirstResponder];
    [noteText resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return TRUE;
}

#pragma mark view release and dealloc

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end

//
//  AccountPickerViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import "ipad_AccountPickerViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "ipad_TranscactionQuickEditViewController.h"
#import "ipad_AccountEditViewController.h"

#import "ipad_AccountPickerCell.h"

#import "Accounts.h"
#import "iPad_GeneralViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface ipad_AccountPickerViewController ()

@end

@implementation ipad_AccountPickerViewController

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
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavBarStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.iAccountEditViewController = nil;
    [self getDataSource];
}

-(void)refleshUI
{
    if (self.iAccountEditViewController != nil)
    {
        [self.iAccountEditViewController refleshUI];
    }
    else
    {
        [self getDataSource];
    }
}

#pragma mark viewDidLoad
-(void)initNavBarStyle
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn setImage:[UIImage imageNamed:@"navigation_add.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,addBar];
    

    
    UILabel *tileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [tileLabel  setTextAlignment:NSTextAlignmentCenter];
    [tileLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [tileLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    tileLabel.backgroundColor = [UIColor clearColor];
    tileLabel.text = NSLocalizedString(@"VC_SelectAccount", nil);
    self.navigationItem.titleView = tileLabel;

    
}


-(void)initPoint
{
    accountArray = [[NSMutableArray alloc]init];
}

-(void)getDataSource
{
    [accountArray removeAllObjects];
 	NSError *error =nil;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    //sync
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [accountArray setArray:objects];
    [_mytableView reloadData];

    //tableview 跳转
    NSIndexPath *jumpIndexPath = nil;
    if(_transactionEditViewController != nil && _selectedAccount!=nil)
    {
        for (int i=0; i<[accountArray count]; i++)
        {
            Accounts *tmpAccount = [accountArray objectAtIndex:i];
            if (tmpAccount == _selectedAccount)
            {
                jumpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
        [_mytableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

#pragma mark btn Action
-(void)back:(id)sender
{
    if (self.transactionEditViewController != nil)
    {
        if (self.accountType == 0)
        {
            self.transactionEditViewController.accounts = self.selectedAccount;
            self.transactionEditViewController.accountLabel.text = self.selectedAccount.accName;
            self.transactionEditViewController.clearedSwitch.on = [self.selectedAccount.autoClear boolValue];
        }
        else if (self.accountType == 1)
        {
            self.transactionEditViewController.fromAccounts = self.selectedAccount;
            self.transactionEditViewController.fromAccountLabel.text = self.selectedAccount.accName;
            if ([self.transactionEditViewController.toAccounts.autoClear boolValue] && [self.selectedAccount.autoClear boolValue]) {
                self.transactionEditViewController.clearedSwitch.on = YES;
            }
            else
                self.transactionEditViewController.clearedSwitch.on = NO;
            
        }
        else
        {
            self.transactionEditViewController.toAccounts = self.selectedAccount;
            self.transactionEditViewController.toAccountLabel.text = self.selectedAccount.accName;
            if ([self.transactionEditViewController.fromAccounts.autoClear boolValue] && [self.selectedAccount.autoClear boolValue]) {
                self.transactionEditViewController.clearedSwitch.on = YES;
            }
            else
                self.transactionEditViewController.clearedSwitch.on = NO;
        }
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addBtnPressed:(UIButton *)SENDER
{

    self.iAccountEditViewController =[[ipad_AccountEditViewController alloc] initWithNibName:@"ipad_AccountEditViewController" bundle:nil];
    //push过去的
	self.iAccountEditViewController.typeOftodo = @"IPAD_ADD";
    self.iAccountEditViewController.accountPickerViewController = self;
    [self.navigationController pushViewController:self.iAccountEditViewController animated:YES];
}
#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *cellIdentifierPar = @"cell";
	
 	ipad_AccountPickerCell *cell = (ipad_AccountPickerCell *)[_mytableView dequeueReusableCellWithIdentifier:cellIdentifierPar];
	if (cell == nil)
	{
		cell = [[ipad_AccountPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPar];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
    [self configCell:cell atIndex:indexPath];
	return cell;
    
}

-(void)configCell:(ipad_AccountPickerCell *)tmpCell atIndex:(NSIndexPath *)path
{
    Accounts *oneAccount = [accountArray objectAtIndex:path.row];
    tmpCell.nameLabel.text = oneAccount.accName;
    //给选中的cell做标记
    if (oneAccount == self.selectedAccount) {
        tmpCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (path.row == [accountArray count]-1)
    {
        tmpCell.bgImage.image = [UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"];

    }
    else
    {
        tmpCell.bgImage.image = [UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"];

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedAccount != nil) {
        NSInteger index = [accountArray indexOfObject:self.selectedAccount];
        NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    self.selectedAccount = [accountArray objectAtIndex:indexPath.row];
    // Update the type of the recipe instance
    
    if (self.transactionEditViewController != nil)
    {
        if (self.accountType == 0)
        {
            self.transactionEditViewController.accounts = self.selectedAccount;
            self.transactionEditViewController.accountLabel.text = self.selectedAccount.accName;
            self.transactionEditViewController.clearedSwitch.on = [self.selectedAccount.autoClear boolValue];
            
        }
        else if (self.accountType == 1)
        {
            self.transactionEditViewController.fromAccounts = self.selectedAccount;
            self.transactionEditViewController.fromAccountLabel.text = self.selectedAccount.accName;
            if ([self.transactionEditViewController.toAccounts.autoClear boolValue] && [self.selectedAccount.autoClear boolValue]) {
                self.transactionEditViewController.clearedSwitch.on = YES;
            }
            else
                self.transactionEditViewController.clearedSwitch.on = NO;
        }
        else
        {
            self.transactionEditViewController.toAccounts = self.selectedAccount;
            self.transactionEditViewController.toAccountLabel.text = self.selectedAccount.accName;
            if ([self.transactionEditViewController.fromAccounts.autoClear boolValue] && [self.selectedAccount.autoClear boolValue]) {
                self.transactionEditViewController.clearedSwitch.on = YES;
            }
            else
                self.transactionEditViewController.clearedSwitch.on = NO;
        }

    }
    else if (self.generalViewController != nil)
    {
        self.generalViewController.defaultAccount.others = nil;
        self.generalViewController.defaultAccount.dateTime_sync = [NSDate date];
        
        self.selectedAccount.others = @"Default";
        self.selectedAccount.dateTime_sync = [NSDate date];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:self.generalViewController.defaultAccount];
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:self.selectedAccount];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateAccountFromLocal:self.generalViewController.defaultAccount];
            [[ParseDBManager sharedManager]updateAccountFromLocal:self.selectedAccount];
        }
        self.generalViewController.defaultAccount = self.selectedAccount;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

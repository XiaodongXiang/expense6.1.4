//
//  AccountPickerViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-3-24.
//
//

#import "AccountPickerViewController.h"
#import "AccountPickerCell.h"
#import "TransactionEditViewController.h"
#import "Accounts.h"
#import "PokcetExpenseAppDelegate.h"
#import "AccountEditViewController.h"
#import "GeneralViewController.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"
@interface AccountPickerViewController ()

@end

@implementation AccountPickerViewController

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
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.accountEditViewController = nil;
    [self getDataSource];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

}

-(void)refleshUI
{
    if (self.accountEditViewController != nil) {
        [self.accountEditViewController reflashUI];
    }
    else
    {
        [self getDataSource];
    }
}

#pragma mark viewDidLoad
-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,addBar];

    self.navigationItem.title = NSLocalizedString(@"VC_SelectAccount", nil);
}


-(void)initPoint
{
    _accountArray = [[NSMutableArray alloc]init];
}

-(void)getDataSource
{
    [_accountArray removeAllObjects];
 	NSError *error =nil;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [_accountArray setArray:objects];
    [_mytableView reloadData];

    //tableview 跳转
    NSIndexPath *jumpIndexPath = nil;
    if(_transactionEditViewController != nil && _selectedAccount!=nil)
    {
        for (int i=0; i<[_accountArray count]; i++)
        {
            Accounts *tmpAccount = [_accountArray objectAtIndex:i];
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
        [self.navigationController popViewControllerAnimated:YES];
    
     
}

-(void)addBtnPressed:(UIButton *)SENDER
{
    self.accountEditViewController =[[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:nil];
	self.accountEditViewController.typeOftodo = @"ADD";
    self.accountEditViewController.accountPickerViewController = self;
 	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.accountEditViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
#pragma mark Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accountArray count];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *cellIdentifierPar = @"cell";
    AccountPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierPar];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AccountPickerCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        

    }
    [self configCell:cell atIndex:indexPath];
    cell.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
	return cell;
    
}

-(void)configCell:(AccountPickerCell *)tmpCell atIndex:(NSIndexPath *)path
{
    Accounts *oneAccount = [_accountArray objectAtIndex:path.row];
    tmpCell.nameLabel.text = oneAccount.accName;
    //给选中的cell做标记
    if (oneAccount == self.selectedAccount) {
        tmpCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (path.row == [_accountArray count]-1)
    {
        tmpCell.lineX.constant = 0;
    }
    else
    {
        tmpCell.lineX.constant = 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
//    for (Accounts* acc in array) {
//        acc.others = @"";
//    }
    
    if (self.selectedAccount != nil) {
        NSInteger index = [_accountArray indexOfObject:self.selectedAccount];
        NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectedAccount.others = nil;
        self.selectedAccount.dateTime_sync = [NSDate date];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        if ([PFUser currentUser]) {
         [[ParseDBManager sharedManager]updateAccountFromLocal:self.selectedAccount];
        }
    }
    
    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    self.selectedAccount = [_accountArray objectAtIndex:indexPath.row];
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

//
//  TransactionRecurringViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import "TransactionRecurringViewController.h"
#import "TransactionEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "RecurringTypeCell.h"

@interface TransactionRecurringViewController ()

@end

@implementation TransactionRecurringViewController
@synthesize myTableView,recurringType,recurringTypeArray;
@synthesize transactionEditViewController;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myTableView reloadData];
}

-(void)initPoint
{
    recurringTypeArray= [NSMutableArray arrayWithObjects:
                               @"Never",@"Daily", @"Weekly",@"Every 2 Weeks",@"Every 3 Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every 4 Months",@"Every 5 Months",@"Every 6 Months",@"Every Year",nil];
}
-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];

    self.navigationItem.title = NSLocalizedString(@"VC_Repeat", nil);
}
#pragma mark Btn Action

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recurringTypeArray count];
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
    
    NSString *recurringLabelText = [self.recurringTypeArray objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    cell.nameLabel.text =   [appDelegate.epnc changeRecurringTexttoLocalLangue:recurringLabelText];
	
    
    //给选中的category做标记
    if ([self.recurringType isEqualToString:[self.recurringTypeArray objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == [self.recurringTypeArray count]-1)
    {
        cell.lineX.constant = 0;
    }
    else
    {
        cell.lineX.constant = 15;

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.transactionEditViewController!=nil)
    {
        
        RecurringTypeCell *checkedCell = (RecurringTypeCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.recurringType = [appDelegate.epnc changeLocalLanguetoRecurringText:checkedCell.nameLabel.text];
        
        
        self.transactionEditViewController.recurringType = self.recurringType;
        self.transactionEditViewController.recurringLabel.text = checkedCell.nameLabel.text;
        
        
        
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

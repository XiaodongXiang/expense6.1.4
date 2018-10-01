//
//  ipad_TransactionRecurringViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-15.
//
//

#import "ipad_TransactionRecurringViewController.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface ipad_TransactionRecurringViewController ()

@end

@implementation ipad_TransactionRecurringViewController
@synthesize myTableView,recurringType,recurringTypeArray;
@synthesize itransactionEditViewController;

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
-(void)initNavStyle{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn]];
    
    
  	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel  setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"VC_Repeat", nil);
    self.navigationItem.titleView = 	titleLabel;
}
#pragma mark Btn Action

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recurringTypeArray count];
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
    
    NSString *recurringLabelText = [self.recurringTypeArray objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    cell.textLabel.text =   [appDelegate.epnc changeRecurringTexttoLocalLangue:recurringLabelText];
	
    
    
    
    //给选中的category做标记
    if ([self.recurringType isEqualToString:[self.recurringTypeArray objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.itransactionEditViewController!=nil)
    {
        
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.recurringType = [appDelegate.epnc changeLocalLanguetoRecurringText:checkedCell.textLabel.text];
        
        self.itransactionEditViewController.recurringType = self.recurringType;
        self.itransactionEditViewController.recurringLabel.text = checkedCell.textLabel.text;

        
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

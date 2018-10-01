//
//  RecurringViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import "RecurringViewController.h"
#import "AppDelegate_iPhone.h"
#import "BillEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "RecurringTypeCell.h"

@interface RecurringViewController ()

@end

@implementation RecurringViewController
@synthesize myTableView,recurringArray,recurringType;
@synthesize billEditViewController;

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
    
    [self initPoint];
    [self initNavStyle];
    [self initContext];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)initPoint
{
    recurringArray = [[NSMutableArray alloc]initWithObjects:
                       @"Never", @"Weekly",@"Two Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every Year",nil];
}

-(void)initNavStyle{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Repeat", nil);

    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

}

-(void)initContext{
    ;
}


-(void)cancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [recurringArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RecurringTypeCell";
    
    RecurringTypeCell *cell = (RecurringTypeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecurringTypeCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    cell.nameLabel.text = [appDelegate.epnc  changeRecurringTypetoLocalLangue_bill:[recurringArray objectAtIndex:indexPath.row]];
    
    if ([self.recurringType isEqualToString:[recurringArray objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row==[self.recurringArray count]-1)
        cell.lineX.constant = 0;
    else
        cell.lineX.constant = 15;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.recurringType != nil) {
        NSInteger index = [recurringArray indexOfObject:self.recurringType];
        NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.billEditViewController.recurringType = [recurringArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.billEditViewController.cycleLabel.text = [appDelegate.epnc changeRecurringTypetoLocalLangue_bill:[recurringArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

#pragma mark PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [recurringArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *titleText = [recurringArray objectAtIndex:row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    return [appDelegate.epnc changeRecurringTypetoLocalLangue_bill:titleText];
}


@end

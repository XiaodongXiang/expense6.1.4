//
//  iPad_BillCycleViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import "iPad_BillCycleViewController.h"
#import "ipad_BillEditViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface iPad_BillCycleViewController ()

@end

@implementation iPad_BillCycleViewController
@synthesize myTableView,recurringArray,recurringType;
@synthesize iBillEditViewController;


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

-(void)initPoint{
    recurringArray = [[NSMutableArray alloc]initWithObjects:
                      @"Never", @"Weekly",@"Two Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every Year",nil];
}

-(void)initNavStyle{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Repeat", nil);
    self.navigationItem.titleView = 	titleLabel;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 30, 30);
	[customerButton setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [customerButton setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
 	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
//    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
//    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
//    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [saveBtn.titleLabel setMinimumScaleFactor:0];
//    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [saveBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
//    [saveBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
//
//    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
//    [saveBtn release];
//    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];
//    [saveBar release];
}

-(void)initContext{
    ;
}

#pragma mark Btn Action
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
    
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    cell.textLabel.text = [appDelegate.epnc  changeRecurringTypetoLocalLangue_bill:[recurringArray objectAtIndex:indexPath.row]];
    
    if ([self.recurringType isEqualToString:[recurringArray objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    if (indexPath.row==[self.recurringArray count]-1)
    {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    }
    else
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    
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
    self.iBillEditViewController.recurringType = [recurringArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.iBillEditViewController.cycleLabel.text = [appDelegate.epnc changeRecurringTypetoLocalLangue_bill:[recurringArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}




@end

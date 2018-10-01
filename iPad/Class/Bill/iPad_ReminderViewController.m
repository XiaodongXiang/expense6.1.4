//
//  iPad_ReminderViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import "iPad_ReminderViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_BillEditViewController.h"

@interface iPad_ReminderViewController ()

@end

@implementation iPad_ReminderViewController

@synthesize myTableView,reminederDateCell,reminderTimeCell,reminederDateLabel,reminderTimeLabel,reminderTime,picker,datePicker,dateFormatter,reminderTypeArray,iBillEditViewController,reminderType;
@synthesize reminderLabelText,reminderTimeLabelText;
@synthesize datePickerCell,pickerCell,selectedRowIndexPath;


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
    [self initTableViewCellLabel];
    [self initNavStyle];
    [self initContext];
}

-(void)initPoint{
    reminderLabelText.text = NSLocalizedString(@"VC_Remind Me", nil);
    reminderTimeLabelText.text = NSLocalizedString(@"VC_ReminderAt", nil);
    
    [reminederDateCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]]];
    [reminderTimeCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]]];
    
    
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"K : mm aa"];
    
    reminderTypeArray = [[NSMutableArray alloc]initWithObjects:
                         @"None", @"1 day before", @"2 days before",
                         @"3 days before", @"1 week before", @"2 weeks before", @"on date of event",nil];
    
    datePicker.backgroundColor = [UIColor whiteColor];
    picker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ([self.reminderType length]==0 || [self.reminderType isEqualToString:@"No Reminder"]) {
        self.reminderType = @"None";
    }

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.reminederDateLabel.text = [appDelegate.epnc changeReminderTexttoLocalLangue:self.reminderType];
}

-(void)initTableViewCellLabel
{
    reminederDateCell.textLabel.text = @"Date";
    reminderTimeCell.textLabel.text = @"Time";
    pickerCell.textLabel.text = @"Picker";
    datePickerCell.textLabel.text = @"DatePicker";
    
    reminederDateCell.textLabel.hidden = YES;
    reminderTimeCell.textLabel.hidden = YES;
    pickerCell.textLabel.hidden = YES;
    datePickerCell.textLabel.hidden = YES;
}

-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Reminder", nil);
    self.navigationItem.titleView = 	titleLabel;
    
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 30, 30);
	[customerButton setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [customerButton setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
 	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveBtn.titleLabel setMinimumScaleFactor:0];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [saveBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];
}

-(void)initContext{
    if (reminderType != nil)
    {
        [picker  selectRow:[reminderTypeArray indexOfObject:reminderType] inComponent:0 animated:NO];
    }
    
    if (self.reminderTime == nil) {
        reminderTimeLabel.text = @"";
    }
    else{
        reminderTimeLabel.text = [dateFormatter stringFromDate:self.reminderTime];
        [datePicker setDate:self.reminderTime animated:YES];
    }
    
    picker.hidden = NO;
    [picker reloadAllComponents];
}

#pragma mark Btn Action
-(void)cancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(UIButton *)sender{
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (self.reminderTime == nil && ![self.reminderType isEqualToString:@"None"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_'Remind At' is required.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        appDelegate_iPhone.appAlertView = alertView;
        [alertView show];
        return;
    }
    
    if ([self.reminderType isEqualToString:@"None"])
    {
        self.iBillEditViewController.remindLabel.text = [NSString stringWithFormat:@"%@",reminederDateLabel.text];
    }
    else
        self.iBillEditViewController.remindLabel.text = [NSString stringWithFormat:@"%@ %@",reminederDateLabel.text,[dateFormatter stringFromDate:self.reminderTime]];
    
    self.iBillEditViewController.reminderDateString  = self.reminderType;
    self.iBillEditViewController.reminderTime = self.reminderTime;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)datePickerValueChanged:(id)sender{
    self.reminderTime = datePicker.date;
    reminderTimeLabel.text = [dateFormatter stringFromDate:self.reminderTime];
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row==0)
    {
        return 44;
    }
    if (selectedRowIndexPath == nil)
    {
        return 44;
    }
    if (selectedRowIndexPath.row==0)
    {
        if (indexPath.row==1)
        {
            return 216;
        }
        else if(indexPath.row==2)
            return 44;
    }
    if (indexPath.row==1)
    {
        return 44;
    }
    else
        return 216;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([reminderType isEqualToString:@"None"])
    {
        if (self.selectedRowIndexPath) {
            return 2;
        }
        else
            return 1;
    }
    else
    {
        if (self.selectedRowIndexPath)
        {
            return 3;
        }
        else
        {
            return 2;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([reminderType isEqualToString:@"None"])
    {
        if (self.selectedRowIndexPath)
        {
            if (indexPath.row==0)
            {
                return reminederDateCell;
            }
            else
                return pickerCell;
        }
        else
            return reminederDateCell;
    }
    //else
    if (self.selectedRowIndexPath)
    {
        if (self.selectedRowIndexPath.row==0)
        {
            if (indexPath.row==0)
            {
                return reminederDateCell;
            }
            else if (indexPath.row==1)
                return pickerCell;
            else
                return reminderTimeCell;
        }
        if (indexPath.row==0)
        {
            return reminederDateCell;
        }
        else if (indexPath.row==1)
            return reminderTimeCell;
        else
            return datePickerCell;
    }
    if (indexPath.row==0)
    {
        return reminederDateCell;
    }
    else
        return reminderTimeCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    [myTableView beginUpdates];
    if (self.selectedRowIndexPath)
    {
        if (indexPath.row==self.selectedRowIndexPath.row)
        {
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;
        }
        else
        {
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            if (indexPath.row > self.selectedRowIndexPath.row) {
                indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedRowIndexPath = indexPath;
            [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
    else
    {
        self.selectedRowIndexPath = indexPath;
        [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(selectedRowIndexPath.row+1) inSection:selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [myTableView endUpdates];

    
}


-(void)deleteDatePickerCell
{
    selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (selectedRowIndexPath==nil)
    {
        BOOL pickerCellisShow = NO;
        if ([[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"Picker"])
        {
            pickerCellisShow = YES;
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        if ([[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"DatePicker"])
        {
            if (pickerCellisShow)
            {
                [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
                [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else if (selectedRowIndexPath.section==0 && selectedRowIndexPath.row==0)
    {
        [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
    else if (selectedRowIndexPath.section==0 && selectedRowIndexPath.row==2)
    {
        if ([[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"Picker"])
        {
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}


#pragma mark PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [reminderTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *titleText = [reminderTypeArray objectAtIndex:row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    return [appDelegate.epnc changeReminderTexttoLocalLangue:titleText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    reminderType = [reminderTypeArray objectAtIndex:row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    reminederDateLabel.text = [appDelegate.epnc changeReminderTexttoLocalLangue:reminderType];
    
    [myTableView beginUpdates];
    if ([reminderType isEqualToString:@"None"])
    {
        if ([myTableView numberOfRowsInSection:0]==3)
        {
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;
        }
        else if ([myTableView numberOfRowsInSection:0]==2)
        {
            ;
        }
        else if( [myTableView numberOfRowsInSection:0]==4 )
        {
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;
        }
    }
    else
    {
        if ([myTableView numberOfRowsInSection:0]==2)
            [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [myTableView endUpdates];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ReminderViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import "ReminderViewController.h"
#import "BillEditViewController.h"
#import "AppDelegate_iPhone.h"

@interface ReminderViewController ()

@end

@implementation ReminderViewController


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
    [self initTableViewCellLabel];
    [self initContext];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)initPoint{
    _reminderLabelText.text = NSLocalizedString(@"VC_Remind Me", nil);
    _reminderTimeLabelText.text = NSLocalizedString(@"VC_ReminderAt", nil);
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    [_dateFormatter setDateFormat:@"K : mm aa"];
    
    _reminderTypeArray = [[NSMutableArray alloc]initWithObjects:
                          @"None", @"1 day before", @"2 days before",
                         @"3 days before", @"1 week before", @"2 weeks before", @"on date of event",nil];
    
    _datePicker.backgroundColor = [UIColor whiteColor];
    _picker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ([self.reminderType length]==0 || [self.reminderType isEqualToString:@"No Reminder"]) {
        self.reminderType = @"None";
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.reminederDateLabel.text = [appDelegate.epnc changeReminderTexttoLocalLangue:self.reminderType];
    
    if ([self.reminderType isEqualToString:@"None"]) {
        
        _reminderDateCellL.constant = 0;
    }
    else{
        _reminderDateCellL.constant = 15;
    }


    
    _selectedRowIndexPath = nil;

    
    _reminderDateCellLineH.constant = EXPENSE_SCALE;
    _reminderAtLineH.constant = EXPENSE_SCALE;
    _datePickerLineH.constant = EXPENSE_SCALE;
    _pickerLineH.constant = EXPENSE_SCALE;
}



-(void)initNavStyle{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Reminder", nil);

    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveBtn.titleLabel setMinimumScaleFactor:0];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [saveBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [saveBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];
}

-(void)initContext{
    if (_reminderType != nil)
    {
        if ([_reminderType isEqualToString:@"No Reminder"])
        {
            _reminderType = @"None";
        }
        [_picker  selectRow:[_reminderTypeArray indexOfObject:_reminderType] inComponent:0 animated:NO];
    }
    
    if (self.reminderTime == nil) {
        _reminderTimeLabel.text = @"";
    }
    else{
        _reminderTimeLabel.text = [_dateFormatter stringFromDate:self.reminderTime];
        [_datePicker setDate:self.reminderTime animated:YES];
    }
    [_picker reloadAllComponents];
}

-(void)initTableViewCellLabel
{
    _reminederDateCell.textLabel.text = @"Date";
    _reminderTimeCell.textLabel.text = @"Time";
    _pickerCell.textLabel.text = @"Picker";
    _datePickerCell.textLabel.text = @"DatePicker";
    
    _reminederDateCell.textLabel.hidden = YES;
    _reminderTimeCell.textLabel.hidden = YES;
    _pickerCell.textLabel.hidden = YES;
    _datePickerCell.textLabel.hidden = YES;
}
#pragma mark Btn Action
-(void)cancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(UIButton *)sender{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (self.reminderTime == nil && ![self.reminderType isEqualToString:@"None"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_'Remind At' is required.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        appDelegate_iPhone.appAlertView = alertView;
        [alertView show];
        return;
    }
    
    if ([self.reminderType isEqualToString:@"None"])
    {
        self.billEditViewController.remindLabel.text = [NSString stringWithFormat:@"%@",_reminederDateLabel.text];
    }
    else
        self.billEditViewController.remindLabel.text = [NSString stringWithFormat:@"%@ %@",_reminederDateLabel.text,[_dateFormatter stringFromDate:self.reminderTime]];
    self.billEditViewController.reminderDateString  = _reminderType;
    self.billEditViewController.reminderTime = self.reminderTime;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)datePickerValueChanged:(id)sender{
    [self changeReminderTime];
}

-(void)changeReminderTime
{
    self.reminderTime = _datePicker.date;
    _reminderTimeLabel.text = [_dateFormatter stringFromDate:self.reminderTime];
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 44;
    }
    if (_selectedRowIndexPath == nil)
    {
        return 44;
    }
    //selectedRowIndexPath != nil
    if (_selectedRowIndexPath.row==0)
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
    return 216;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_reminderType isEqualToString:@"None"])
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
    if ([_reminderType isEqualToString:@"None"])
    {
        if (self.selectedRowIndexPath)
        {
            if (indexPath.row==0)
            {
                return _reminederDateCell;
            }
            else
                return _pickerCell;
        }
        else
            return _reminederDateCell;
    }
    //else
    if (self.selectedRowIndexPath)
    {
        if (self.selectedRowIndexPath.row==0)
        {
            if (indexPath.row==0)
            {
                return _reminederDateCell;
            }
            else if (indexPath.row==1)
                return _pickerCell;
            else
                return _reminderTimeCell;
        }
        if (indexPath.row==0)
        {
            return _reminederDateCell;
        }
        else if (indexPath.row==1)
            return _reminderTimeCell;
        else
            return _datePickerCell;
    }
    if (indexPath.row==0)
    {
        return _reminederDateCell;
    }
    else
        return _reminderTimeCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_myTableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    [_myTableView beginUpdates];
    if (self.selectedRowIndexPath)
    {
        if (indexPath.row==self.selectedRowIndexPath.row)
        {
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;
        }
        else
        {
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            if (indexPath.row > self.selectedRowIndexPath.row) {
                indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedRowIndexPath = indexPath;
            [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];

        }
    }
    else
    {
        self.selectedRowIndexPath = indexPath;
        [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(_selectedRowIndexPath.row+1) inSection:_selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_myTableView endUpdates];
    
    
//    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
//    
//    if ([cell.textLabel.text isEqualToString:@"Date"] && selectedRowIndexPath!=indexPath)
//    {
//        selectedRowIndexPath = indexPath;
//    }
//    else if ([cell.textLabel.text isEqualToString:@"Time"] && selectedRowIndexPath!=indexPath)
//    {
//        selectedRowIndexPath = indexPath;
//    }
//    else
//        selectedRowIndexPath = nil;
//
//    [self insertorDelegateDatePickerCell];
}

-(void)deleteDatePickerCell
{
    _selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (_selectedRowIndexPath==nil)
    {
        BOOL pickerCellisShow = NO;
        if ([[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"Picker"])
        {
            pickerCellisShow = YES;
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        if ([[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"DatePicker"])
        {
            if (pickerCellisShow)
            {
                [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
                [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
    else if (_selectedRowIndexPath.section==0 && _selectedRowIndexPath.row==0)
    {
        [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

        
    }
    else if (_selectedRowIndexPath.section==0 && _selectedRowIndexPath.row==2)
    {
        if ([[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text isEqualToString:@"Picker"])
        {
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

    }

}




#pragma mark PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_reminderTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *titleText = [_reminderTypeArray objectAtIndex:row];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    return [appDelegate.epnc changeReminderTexttoLocalLangue:titleText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _reminderType = [_reminderTypeArray objectAtIndex:row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _reminederDateLabel.text = [appDelegate.epnc changeReminderTexttoLocalLangue:_reminderType];
    
    [_myTableView beginUpdates];
    if ([_reminderType isEqualToString:@"None"])
    {
        _reminderDateCellL.constant = 0;
        if ([_myTableView numberOfRowsInSection:0]==3)
        {
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;

        }
        else if ([_myTableView numberOfRowsInSection:0]==2)
        {
            ;
        }
        else if( [_myTableView numberOfRowsInSection:0]==4 )
        {
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedRowIndexPath = nil;

        }
    }
    else
    {
        _reminderDateCellL.constant = 15;

        [self changeReminderTime];
         if ([_myTableView numberOfRowsInSection:0]==2)
             [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_myTableView endUpdates];

    
//    if (![reminderType isEqualToString:@"None"]) {
//        [reminederDateCell  setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    }
//    else{
//        [reminederDateCell  setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_j2_320_44.png"]]];
//        self.reminderTime = nil;
//
//    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

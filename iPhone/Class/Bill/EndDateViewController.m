//
//  EndDateViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-8-21.
//
//

#import "EndDateViewController.h"
#import "BillEditViewController.h"
#import "AppDelegate_iPhone.h"

@interface EndDateViewController ()

@end

@implementation EndDateViewController

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
    [self initNavBarStyle];
    [self initContex];
    
    
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=backBtn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)initContex
{
    if (self.endDate != nil)
    {
        self.endDatePicker.date = self.endDate;
    }

}
-(void)initPoint
{
    _endLineH.constant = EXPENSE_SCALE;
    _dateLineH.constant = EXPENSE_SCALE;
    _forverLineH.constant = EXPENSE_SCALE;
    
    _selectedRowIndexPath = nil;
    [_endDatePicker addTarget:self action:@selector(datePickerValueChange) forControlEvents:UIControlEventValueChanged];
    
    _endDatePicker.minimumDate = self.billEditViewController.starttime;
    _endDatePicker.maximumDate = nil;
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = @"End Repeat";
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedRowIndexPath && indexPath.row==self.selectedRowIndexPath.row+1)
    {
        return 216;
    }
    else
        return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedRowIndexPath)
    {
        return 3;
    }
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
//    if ([mytableView numberOfRowsInSection:0]==2)
//    {
//        [endDateCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    }
//    else
//        [endDateCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
    
    
    if (self.endDate==nil)
    {
        _forverCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        _endDateCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
   

    
    if (indexPath.row==0)
    {
        return _forverCell;
    }
    else if (indexPath.row==1)
        return _endDateCell;
    else
        return _datePickerCell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [tableView beginUpdates];
    if (self.selectedRowIndexPath)
    {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section] ] withRowAnimation:UITableViewRowAnimationFade];
        
        self.selectedRowIndexPath = nil;

        
        
    }
    else
    {
        if (indexPath.row==1)
        {
            self.selectedRowIndexPath = indexPath;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedRowIndexPath.row+1) inSection:self.selectedRowIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }

    [tableView endUpdates];

    
    if (indexPath.row==0)
    {
        _endDateCell.accessoryType =UITableViewCellAccessoryNone;
    }
    else
        _forverCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row==0)
    {
        self.endDate = nil;
    }
    else
        self.endDate = _endDatePicker.date;
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
}

-(void)datePickerValueChange
{
    self.endDate = _endDatePicker.date;
}



#pragma mark Btn Action
-(void)back:(id)sender
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];

    self.billEditViewController.endtime = self.endDate;
    if (self.endDate == nil)
    {
        self.billEditViewController.endDateLabel.text = NSLocalizedString(@"VC_Forever", nil);
    }
    else
        self.billEditViewController.endDateLabel.text = [outputFormatter stringFromDate:self.endDate];
    
    [self.navigationController popViewControllerAnimated:YES];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

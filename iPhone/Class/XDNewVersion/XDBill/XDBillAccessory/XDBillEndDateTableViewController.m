//
//  XDBillEndDateTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import "XDBillEndDateTableViewController.h"

@interface XDBillEndDateTableViewController ()
{
    BOOL _showPicker;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation XDBillEndDateTableViewController

-(void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_endDate) {
        self.secondCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.firstCell.accessoryType = UITableViewCellAccessoryNone;
        self.datePicker.date = _endDate;
    }else{
        self.secondCell.accessoryType = UITableViewCellAccessoryNone;
        self.firstCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnEndDate:)]) {
        [self.xxdDelegate returnEndDate:_endDate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickerValueChanged:(id)sender {
    _endDate = self.datePicker.date;
    self.dateLabel.text = [self returnInitDate:_endDate];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
       
        return _showPicker?224:0.01;
    }
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.firstCell;
    }else if (indexPath.row == 1){
        return self.secondCell;
    }else{
        return self.datePickerCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        self.firstCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.secondCell.accessoryType = UITableViewCellAccessoryNone;
        _endDate = nil;
        self.dateLabel.text = nil;
        self.datePicker.date = [NSDate date];
        _showPicker = NO;
    }
    
    if (indexPath.row == 1) {
        _showPicker = !_showPicker;
        self.firstCell.accessoryType = UITableViewCellAccessoryNone;
        self.secondCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _endDate = _endDate?:[NSDate date];
        self.dateLabel.text = [self returnInitDate:_endDate];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}
@end

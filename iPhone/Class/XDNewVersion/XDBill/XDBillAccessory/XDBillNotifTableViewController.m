//
//  XDBillNotifTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import "XDBillNotifTableViewController.h"

@interface XDBillNotifTableViewController ()
{
    NSString* _remindMeString;
    NSDate* _dateTime;
    
    NSArray* _remindMeArray;
    
    BOOL _dayPickerShow;
    BOOL _timePickerShow;
    
}
@property (weak, nonatomic) IBOutlet UILabel *remindMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindMeDetailLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (weak, nonatomic) IBOutlet UILabel *remindAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindAtDetailLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fourthCell;

@end

@implementation XDBillNotifTableViewController
@synthesize remindStr,remindDate;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (remindDate) {
        _timePickerShow = YES;
        _dateTime = remindDate;
        self.timePicker.date = remindDate;
        self.remindAtDetailLabel.text= [self reminderDatePickValueChange:remindDate];

    }
    
    if (remindStr) {
        _remindMeString = remindStr;
        if (![remindStr isEqualToString:@"None"]) {
            _dayPickerShow = YES;
            
            
//            NSLog(@"%ld",[_remindMeArray indexOfObject:remindStr]);
//            [self.dayPicker selectedRowInComponent:[_remindMeArray indexOfObject:remindStr]];
            [self.dayPicker selectRow:[_remindMeArray indexOfObject:remindStr] inComponent:0 animated:NO];
        }
    }else{
        
        _remindMeString = _remindMeArray[0];
    }
    self.remindMeDetailLabel.text = _remindMeString;

    [self.tableView reloadData];

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _remindMeArray = @[@"None", @"1 day before", @"2 days before",
                           @"3 days before", @"1 week before", @"2 weeks before", @"on date of event"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.title = NSLocalizedString(@"VC_Reminder", nil);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)cancelClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)saveClick{
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnBillNotifRemindMe:remindAt:)]) {
        [self.xxdDelegate returnBillNotifRemindMe:_remindMeString remindAt:_dateTime];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)timeValueChange:(id)sender {
    _dateTime = self.timePicker.date;
    self.remindAtDetailLabel.text= [self reminderDatePickValueChange:self.timePicker.date];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return _dayPickerShow?224:0.01;
    }
    if (indexPath.row == 3) {
        return _timePickerShow?191:0.01;
    }
    if (indexPath.row == 2) {
        if ([_remindMeString isEqualToString:@"None"] || !_remindMeString) {
            return 0.01;
        }
    }
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.firstCell;
    }else if (indexPath.row == 1){
        return self.secondCell;
    }else if (indexPath.row == 2){
        return self.thirdCell;
    }else{
        return self.fourthCell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        _dayPickerShow = !_dayPickerShow;
        _timePickerShow = NO;
    }
    
    if (indexPath.row == 2) {
        _timePickerShow = !_timePickerShow;
        _dayPickerShow = NO;
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

#pragma mark - picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_remindMeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *titleText = [_remindMeArray objectAtIndex:row];
    
    return [self changeReminderTexttoLocalLangue:titleText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _remindMeString = _remindMeArray[row];
    self.remindMeDetailLabel.text = _remindMeString;
    if (row > 0) {
        _dateTime = [NSDate date];
        self.remindAtDetailLabel.text = [self reminderDatePickValueChange:_dateTime];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }else{
        _dateTime = nil;
        _timePickerShow = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

-(NSString *)changeReminderTexttoLocalLangue:(NSString *)reminderText
{
    if ([reminderText isEqualToString:@"None"])
    {
        return  NSLocalizedString(@"VC_None", nil);
    }
    else if ([reminderText isEqualToString:@"1 day before"])
    {
        return NSLocalizedString(@"VC_1daybefore", nil);
    }
    else if ([reminderText isEqualToString:@"2 days before"])
    {
        return  NSLocalizedString(@"VC_2daysbefore", nil);
    }
    else if ([reminderText isEqualToString:@"3 days before"])
    {
        return  NSLocalizedString(@"VC_3daysbefore", nil);
    }
    else if ([reminderText isEqualToString:@"1 week before"])
    {
        return  NSLocalizedString(@"VC_1weekbefore", nil);
    }
    else if ([reminderText isEqualToString:@"2 weeks before"])
    {
        return  NSLocalizedString(@"VC_2weeksbefore", nil);
    }else
    {
        return  NSLocalizedString(@"VC_ondateofevent", nil);
    }
}

#pragma mark - other
-(NSString*)reminderDatePickValueChange:(NSDate*)date;
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeStyle=NSDateFormatterShortStyle;
    dateFormatter.dateStyle=NSDateFormatterNoStyle;
    
    return  [dateFormatter stringFromDate:date];
}
@end

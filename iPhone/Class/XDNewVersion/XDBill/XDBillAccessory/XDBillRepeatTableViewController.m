//
//  XDBillRepeatTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/2.
//

#import "XDBillRepeatTableViewController.h"

@interface XDBillRepeatTableViewController ()
{
    NSArray* _dataArr;
}
@end

@implementation XDBillRepeatTableViewController

-(void)setRepeatString:(NSString *)repeatString{
    _repeatString = repeatString;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = @[@"Never", @"Weekly",@"Two Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every Year"];
    self.navigationItem.title = NSLocalizedString(@"VC_Repeat", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
}
-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([_repeatString isEqualToString:_dataArr[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* arr = [tableView visibleCells];
    for (UITableViewCell* cell in arr) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnBillRepeatSelect:)]) {
        [self.xxdDelegate returnBillRepeatSelect:_dataArr[indexPath.row]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

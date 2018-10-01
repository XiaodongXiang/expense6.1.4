//
//  XDRepeatTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/25.
//

#import "XDRepeatTableViewController.h"

@interface XDRepeatTableViewController ()
@property(nonatomic,strong)NSArray* dataArr;
@end


@implementation XDRepeatTableViewController

static NSString* cellID = @"cellID";

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"Never",@"Daily", @"Weekly",@"Every 2 Weeks",@"Every 3 Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every 4 Months",@"Every 5 Months",@"Every 6 Months",@"Every Year", nil];
    }
    return _dataArr;
}

-(void)setRepeatStr:(NSString *)repeatStr{
    _repeatStr = repeatStr;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Repeat";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:cellID];
    }
    NSString* str = self.dataArr[indexPath.row];
    cell.textLabel.text = str;
    if ([str isEqualToString:_repeatStr]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UIAccessibilityTraitNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* arr = [tableView visibleCells];
    for (UITableViewCell* Cell in arr) {
      Cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if ([self.repeatDelegate respondsToSelector:@selector(returnSelectedRepeat:)]) {
        [self.repeatDelegate returnSelectedRepeat:self.dataArr[indexPath.row]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
//    NSLog(@"repeatVc dealloc");
}
@end

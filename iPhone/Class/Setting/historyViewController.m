//
//  historyViewController.m
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/18.
//

#import "historyViewController.h"

@interface historyViewController ()
@property(nonatomic, strong)NSArray * array;
@end

@implementation historyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"VC_Update History", nil);
    self.tableView.tableFooterView= [[UIView alloc]initWithFrame:CGRectZero];
}

-(NSArray *)array{
    if (!_array) {
        _array = @[@"v 6.1.4\n- Compatible with iOS 12\n- Support add transaction in widget\n- Minor bug fixes",@"v 6.1.3\n- Fixed subcategory statistics issue\n- Fixed transaction sorting issue\n- Fixed time display issue in exported CSV file",@"v 6.1.2\n- Crash fixes\n- Optimize display in exported reports\n- Sync issue fixes\n- Minor bug fixes",@"v 6.1.1\n- Fixed crash when iPhone‘s calendar is set to Buddhist calendar\n- Show Net Worth in Accounts page\n- Add subcategory reporting\n- Deepen the uncleared transaction's color",@"v 6.1\n- All new design, delightful interaction and better structure\n- Optimized for iPhone X, support Face ID\n- Support 3D Touch\n- Bug fixes"];

    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 100)];
    label.font = [UIFont fontWithName:FontSFUITextRegular size:14];
    label.numberOfLines = 0;
    [cell.contentView addSubview:label];
    
    label.text = self.array[indexPath.row];
    return cell;
    
}

@end

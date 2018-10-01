//
//  XDBudgetSelectTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/16.
//

#import "XDBudgetSelectTableViewController.h"
#import "Category.h"
#import "CategorySelect.h"
@interface XDBudgetSelectTableViewController ()
{
    NSMutableArray* _newMuArr;
}
@property(nonatomic, strong)NSArray* dataArr;
@property(nonatomic, strong)NSMutableArray * muArr;

@end

@implementation XDBudgetSelectTableViewController

-(void)setSelectMuArr:(NSMutableArray *)selectMuArr{
    _selectMuArr = selectMuArr;
    
    _newMuArr = [NSMutableArray array];
    for (int i = 0; i < selectMuArr.count; i++) {
        CategorySelect* cs = selectMuArr[i];
        if (cs.category) {
            [_newMuArr addObject:cs.category];
            [self.muArr addObject:cs.category];
        }
    }
    
    [self.tableView reloadData];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.muArr = [NSMutableArray array];
    }
    return self;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[XDDataManager shareManager] fetchParentExpenseCategory];
    }
    return _dataArr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.selectDelegate respondsToSelector:@selector(returnSelectCategoryArray:)]) {
        [self.selectDelegate returnSelectCategoryArray:self.muArr];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];

}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = RGBColor(226, 226, 226);

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Category* cate = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:FontSFUITextRegular size:16];
    cell.textLabel.textColor = RGBColor(85, 85, 85);
    cell.imageView.image = [UIImage imageNamed:cate.iconName];
    cell.textLabel.text = cate.categoryName;
    if ([_newMuArr containsObject:cate]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    Category* cate = self.dataArr[indexPath.row];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.muArr containsObject:cate]) {
            [self.muArr removeObject:cate];
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (![self.muArr containsObject:cate]) {
            [self.muArr addObject:cate];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    view.backgroundColor = RGBColor(246, 246, 246);
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 20)];
    label.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    label.textColor = RGBColor(154, 154, 154);
    label.text = NSLocalizedString(@"VC_SELECTCATEGORIESFORMONITOR", nil);
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
@end

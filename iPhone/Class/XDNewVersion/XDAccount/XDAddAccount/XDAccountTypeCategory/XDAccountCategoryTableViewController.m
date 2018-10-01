//
//  XDAccountCategoryTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/13.
//

#import "XDAccountCategoryTableViewController.h"
#import "AccountType.h"
#import "XDNewTypeTableViewController.h"
@interface XDAccountCategoryTableViewController ()<XDNewTypeTableViewDelegate>
@property(nonatomic, strong)NSMutableArray* dataMuArr;
@end

@implementation XDAccountCategoryTableViewController

-(NSMutableArray *)dataMuArr{
    if (!_dataMuArr) {
        _dataMuArr = [NSMutableArray arrayWithArray:[[XDDataManager shareManager]getObjectsFromTable:@"AccountType" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES]]]];
    }
    return _dataMuArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addClick) image:[UIImage imageNamed:@"add_category"]];

    
    self.title = @"Edit Account";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
}


-(void)addClick{
    XDNewTypeTableViewController* vc = [[XDNewTypeTableViewController alloc]initWithNibName:@"XDNewTypeTableViewController" bundle:nil];
    vc.addDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMuArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    AccountType* type = self.dataMuArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:type.iconName];
    cell.textLabel.text = type.typeName;
    
    CGSize itemSize = CGSizeMake(44, 44);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XDNewTypeTableViewController* vc = [[XDNewTypeTableViewController alloc]initWithNibName:@"XDNewTypeTableViewController" bundle:nil];
    vc.accountType = self.dataMuArr[indexPath.row];
    vc.addDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - XDNewTypeTableViewDelegate
-(void)updateAccountType{
    [self.tableView reloadData];
}

-(void)addNewAccountType:(AccountType *)newType{
    [self.dataMuArr insertObject:newType atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountType* account = self.dataMuArr[indexPath.row];
    account.state = @"0";
    account.updatedTime = [NSDate date];
    [[XDDataManager shareManager] saveContext];
    // 删除模型
    [self.dataMuArr removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

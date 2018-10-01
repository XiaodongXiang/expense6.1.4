//
//  XDEditTransCategorySplitTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/11.
//

#import "XDEditTransCategorySplitTableViewController.h"
#import "XDCategorySplitTableViewCell.h"
#import "XDCategorySplitTableViewController.h"
@interface XDEditTransCategorySplitTableViewController ()<XDCategorySplitCellDelegate>

@property(nonatomic, strong)NSMutableArray * muArr;


@end

@implementation XDEditTransCategorySplitTableViewController
@synthesize editSplitCategoryMuArr,addVc;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit Split";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"Split" style:UIBarButtonItemStylePlain target:self action:@selector(splitClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = cancel;

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
   
    self.muArr = [NSMutableArray arrayWithArray:editSplitCategoryMuArr];
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)splitClick{
    XDCategorySplitTableViewController* splitVc = [[XDCategorySplitTableViewController alloc]init];
    splitVc.editSplitMuArr = self.muArr;
    splitVc.splitDelegate = (id)addVc;
    [self.navigationController pushViewController:splitVc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    [self.muArr removeObjectAtIndex:indexPath.row];
    //删除数据，和删除动画
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDCategorySplitTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCategorySplitTableViewCell" owner:self options:nil]lastObject];
    }
    CategorySelect* cs = self.muArr[indexPath.row];
    cell.categorySelect = cs;
    cell.delegate = self;
    
    return cell;
}

-(void)returnSplitAmount:(XDCategorySplitTableViewCell *)cell{
    if (cell.categorySelect.amount == 0) {
        if ([self.muArr containsObject:cell.categorySelect]) {
            [self.muArr removeObject:cell.categorySelect];
        }
    }else{
        if (![self.muArr containsObject:cell.categorySelect]) {
            [self.muArr addObject:cell.categorySelect];
        }
    }
}

@end

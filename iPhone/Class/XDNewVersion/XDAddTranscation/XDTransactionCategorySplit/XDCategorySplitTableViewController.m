//
//  XDCategorySplitTableViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/31.
//

#import "XDCategorySplitTableViewController.h"
#import "XDCategorySplitTableViewCell.h"
#import "PokcetExpenseAppDelegate.h"
#import "CategorySelect.h"
@interface XDCategorySplitTableViewController ()<XDCategorySplitCellDelegate>

@property(nonatomic, strong)NSMutableArray* dataArr;
@property(nonatomic, strong)NSMutableArray * selectSplitMuArr;

@end

@implementation XDCategorySplitTableViewController
@synthesize editSplitMuArr;

-(void)getCategoryData{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys: [NSNull null],@"EMPTY" ,nil];
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchExpenseCategory" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.dataArr = [NSMutableArray array];
    for (int i = 0; i < objects.count; i++) {
        CategorySelect* cs = [[CategorySelect alloc]init];
        cs.category = objects[i];
        cs.amount = 0.0;
        cs.memo = @"";
        cs.isSelect = NO;
        
        [self.dataArr addObject:cs];
    }
    
    if (editSplitMuArr) {
        for (int i = 0; i < self.dataArr.count; i++) {
            CategorySelect* cs = self.dataArr[i];
            for (CategorySelect* ccs in editSplitMuArr) {
                if (ccs.category == cs.category) {
                    [self.dataArr replaceObjectAtIndex:i withObject:ccs];
                }
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (editSplitMuArr) {
        self.selectSplitMuArr = [NSMutableArray arrayWithArray:editSplitMuArr];
    }else{
        self.selectSplitMuArr = [NSMutableArray array];
    }
    [self getCategoryData];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCategorySplitTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    if (editSplitMuArr) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];

    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneClick{
    [self.view endEditing:YES];
    if ([self.splitDelegate respondsToSelector:@selector(returnSelectedSplitArray:)]) {
        [self.splitDelegate returnSelectedSplitArray:self.selectSplitMuArr];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDCategorySplitTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCategorySplitTableViewCell" owner:self options:nil]lastObject];
    }
    CategorySelect* cs = self.dataArr[indexPath.row];
    cell.categorySelect = cs;
    cell.delegate = self;
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -XDCategorySplitCellDelegate
-(void)returnSplitAmount:(XDCategorySplitTableViewCell *)cell{

//    NSLog(@"%@-123321--%f",cell.categorySelect.category.categoryName,cell.categorySelect.amount);
    if (cell.categorySelect.amount == 0) {
        if ([self.selectSplitMuArr containsObject:cell.categorySelect]) {
            [self.selectSplitMuArr removeObject:cell.categorySelect];
        }
    }else{
        if (![self.selectSplitMuArr containsObject:cell.categorySelect]) {
            [self.selectSplitMuArr addObject:cell.categorySelect];
        }
    }
    

}
@end

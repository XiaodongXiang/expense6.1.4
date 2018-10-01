//
//  XDTransactionAccountView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import "XDTransactionAccountView.h"
#import "XDTransactionHelpClass.h"
#import "XDTransactionAccountTableViewCell.h"
@interface XDTransactionAccountView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray* accountArr;

@end
@implementation XDTransactionAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.accountArr = [XDTransactionHelpClass getTransactionAccounts];
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorColor = RGBColor(226, 226, 226);

    }
    return self;
}

-(void)refreshData{
    self.accountArr = [XDTransactionHelpClass getTransactionAccounts];
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accountArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDTransactionAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDTransactionAccountTableViewCell" owner:self options:nil]lastObject];;
    }
    if (indexPath.row == 0) {
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = RGBColor(226, 226, 226);
        [cell.contentView addSubview:view];
    }
    Accounts* account =  self.accountArr[indexPath.row];
    cell.account = account;
    if (_transAccount == account) {
        cell.accountSelected = YES;
    }else{
        cell.accountSelected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDTransactionAccountTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accountSelected = !cell.accountSelected;
    if ([self.accountDelegate respondsToSelector:@selector(returnSelectedAccount:)]) {
        [self.accountDelegate returnSelectedAccount:self.accountArr[indexPath.row]];
    }
}


@end

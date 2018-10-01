//
//  XDTitleAccountTableView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/22.
//

#import "XDTitleAccountTableView.h"
#import "XDTransactionHelpClass.h"
#import "Accounts.h"
#import "XDTransactionAccountTableViewCell.h"

@interface XDTitleAccountTableView()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath* _indexPath;
}
@property(nonatomic, strong)NSArray* dataArr;

@end
@implementation XDTitleAccountTableView


+(instancetype)view{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [XDTransactionHelpClass getTransactionAccounts];
        if (self.dataArr.count > 6) {
            self.height = 6 * 56 + 28;
        }else{
            self.height = (self.dataArr.count + 1) * 56;
        }
        self.rowHeight = 56;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorColor = RGBColor(226, 226, 226);
        
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

-(void)refreshUI{
    self.dataArr = [XDTransactionHelpClass getTransactionAccounts];
    if (self.dataArr.count > 6) {
        self.height = 6 * 56 + 28;
    }else{
        self.height = (self.dataArr.count + 1) * 56;
    }
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDTransactionAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDTransactionAccountTableViewCell" owner:self options:nil]lastObject];;
    }
  
    if (indexPath == _indexPath) {
        cell.accountSelected = YES;
    }
    if (indexPath.row == 0) {
        cell.accountIcon.image = [UIImage imageNamed:@"all account"];
        cell.accountName.text = @"All Accounts";
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = RGBColor(226, 226, 226);
        [cell.contentView addSubview:view];
    }else{
        Accounts* account = self.dataArr[indexPath.row-1];
        cell.account = account;

    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray* array = [tableView visibleCells];
    XDTransactionAccountTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (XDTransactionAccountTableViewCell* aCell in array) {
        if (aCell != cell) {
            aCell.accountSelected = NO;
        }
    }
    cell.accountSelected = YES;
    _indexPath = indexPath;
//
//
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.selectedDelegate respondsToSelector:@selector(returnSelectedAccount:)]) {
            if (indexPath.row != 0) {
                Accounts* account = self.dataArr[indexPath.row-1];
                [self.selectedDelegate returnSelectedAccount:account];
            }else{
                [self.selectedDelegate returnSelectedAccount:nil];
            }
        }
    });
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


@end

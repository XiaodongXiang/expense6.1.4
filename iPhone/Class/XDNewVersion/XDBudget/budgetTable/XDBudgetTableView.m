//
//  XDBudgetTableView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import "XDBudgetTableView.h"
#import "BudgetTableViewCell.h"
#import "BudgetCountClass.h"
@interface XDBudgetTableView()<UITableViewDelegate,UITableViewDataSource>
{
    double _allAmount;
    double _allExpense;
    
}
@property(nonatomic, strong)BudgetCountClass * firstBCL;

@property(nonatomic, strong)UIImageView * emptyImageView;

@end

@implementation XDBudgetTableView

-(UIImageView *)emptyImageView{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty state4"]];
        _emptyImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        _emptyImageView.contentMode = UIViewContentModeCenter;
        _emptyImageView.hidden = YES;
        _emptyImageView.userInteractionEnabled = YES;
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"creat budget"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"creat budget_press"] forState:UIControlStateHighlighted];

        btn.frame = CGRectMake(0, 0, 189 , 77);
        [btn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.center = CGPointMake(SCREEN_WIDTH/2, self.height/2+100);
        
        [_emptyImageView addSubview:btn];
        
        [self addSubview:_emptyImageView];
    }
    return _emptyImageView;
}

-(void)createBtnClick{
    if ([self.budgetDelegate respondsToSelector:@selector(createBudgetBtnClick)]) {
        [self.budgetDelegate createBudgetBtnClick];
    }
}

-(void)setBudgetArray:(NSArray *)budgetArray{
    _budgetArray = budgetArray;
    
    _allAmount = 0;
    _allExpense = 0;
    for (BudgetCountClass* class in budgetArray) {
        _allAmount += [class.bt.amount doubleValue];
        _allExpense += class.btTotalExpense;
    }
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.separatorColor = RGBColor(226 , 226 , 226);

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_budgetArray.count == 0) {
        self.emptyImageView.hidden = NO;
    }else{
        self.emptyImageView.hidden = YES;
    }
    
    return _budgetArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 104;
    }
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    BudgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BudgetTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row == 0) {
        cell.expenseAmount = _allExpense;
        cell.allBudgetAmount = _allAmount;
        cell.budgetCountClass = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row >= 1) {
        BudgetCountClass* class = _budgetArray[indexPath.row-1];
        cell.budgetCountClass = class;
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0) {
        BudgetCountClass* class = _budgetArray[indexPath.row-1];
        if ([self.budgetDelegate respondsToSelector:@selector(returnSelectedBudget:transactionArray:)]) {
            [self.budgetDelegate returnSelectedBudget:class.bt transactionArray:_budgetArray];
        }
    }
}
@end

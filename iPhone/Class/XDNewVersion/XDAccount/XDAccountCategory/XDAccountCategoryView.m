//
//  XDAccountCategoryView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/7.
//

#import "XDAccountCategoryView.h"
#import "XDAccountTypeBtn.h"
@interface XDAccountCategoryView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong)NSArray * dataArr;
@property(nonatomic, strong)XDAccountTypeBtn * lastBtn;

@end
@implementation XDAccountCategoryView
-(void)setSelectAccountType:(AccountType *)selectAccountType{
    _selectAccountType = selectAccountType;
    
    for (UIView* view in self.scrollView.subviews) {
        if ([view isKindOfClass:[XDAccountTypeBtn class]]) {
            XDAccountTypeBtn* btn = (XDAccountTypeBtn*)view;
            
            if (btn.accountType == selectAccountType) {
                btn.selected = YES;
                self.lastBtn = btn;

            }
        }
    }
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[XDDataManager shareManager]getObjectsFromTable:@"AccountType" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES]]];
    }
    return _dataArr;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpScrollView];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (IBAction)editClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editBtnClick)]) {
        [self.delegate editBtnClick];
    }
}

-(void)setUpScrollView{
    NSInteger page = self.dataArr.count / 12;
    NSInteger surplus = self.dataArr.count - page * 12;
    if (surplus > 0) {
        page += 1;
    }
    CGFloat width = 75;
    CGFloat height = 80;
    CGFloat xmargin = (SCREEN_WIDTH - 4 * 75 - 30) / 3;
    CGFloat ymargin = (278 - 75 * 3)/4;
    self.scrollView.contentSize = CGSizeMake(page * SCREEN_WIDTH, 0);
    for (int i = 0; i < page; i++) {
        NSInteger num = 12 < self.dataArr.count - i * 12?12:self.dataArr.count - i * 12;
        for (int j = i * 12; j < i * 12 + num; j++) {
            NSInteger x = j / 4 % 3;
            NSInteger y = j % 4;
            XDAccountTypeBtn* btn = [[XDAccountTypeBtn alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH + 15 + (y*(width+xmargin)), x * (ymargin+height), width, height)];
            btn.accountType = self.dataArr[j];
          
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            
        }
    }
}

-(void)btnClick:(XDAccountTypeBtn*)btn{
    
    
    if (btn != self.lastBtn) {
        self.lastBtn.selected = NO;
        btn.selected = YES;
        self.lastBtn = btn;
    }
    
    if ([self.delegate respondsToSelector:@selector(returnSelectedAccountCategory:)]) {
        [self.delegate returnSelectedAccountCategory:btn.accountType];
    }
    
}

@end

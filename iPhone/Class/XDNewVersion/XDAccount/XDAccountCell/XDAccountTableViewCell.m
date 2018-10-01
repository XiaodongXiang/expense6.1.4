//
//  XDAccountTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/5.
//

#import "XDAccountTableViewCell.h"
#import "Accounts.h"
#import "AccountType.h"
#import "CategoryBackView.h"
#import "Transaction.h"
#import "AccountCount.h"
@interface XDAccountTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountTitle;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *accountAmount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidth;

@property(nonatomic, strong)CategoryBackView *categoryBackView;;

@end
@implementation XDAccountTableViewCell

-(void)setAccount:(AccountCount *)account{
    _account = account;
    
    NSArray* array = @[@"8281FF",@"639AF4",@"7AD2FF",@"4CD3B2",@"47D469",@"F2BE44",@"FF965D",@"FD7881",@"D38CF2"];
    self.backView.image = [UIImage imageNamed:array[[_account.accountsItem.accountColor integerValue]]];
    
    
    self.categoryIconImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_account.accountsItem.accountType.iconName componentsSeparatedByString:@"."]firstObject]]] imageWithColor:[UIColor colorWithHexString:array[[_account.accountsItem.accountColor integerValue]]]];
    self.accountTitle.text = _account.accountsItem.accName;
    self.categoryName.text = _account.accountsItem.accountType.typeName;
    self.categoryBackView.roundColor = [UIColor colorWithHexString:array[[_account.accountsItem.accountColor integerValue]]];
    
//    self.accountAmount.text = [XDDataManager moneyFormatter:_account.defaultAmount];

    self.accountAmount.attributedText = [[NSAttributedString alloc]initWithString:[XDDataManager moneyFormatter:_account.defaultAmount] attributes:@{NSKernAttributeName:@(-1.0f)}];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.categoryBackView = [[CategoryBackView alloc]initWithFrame:CGRectMake(15, 22, 46, 46)];
    [self.backView addSubview:self.categoryBackView];
    [self.backView bringSubviewToFront:self.categoryIconImageView];
    
    self.backViewWidth.constant = SCREEN_WIDTH - 20;
}


- (IBAction)editClick:(id)sender {
    if ([self.xxdDelegate respondsToSelector:@selector(selectedAccountEdit:)]) {
        [self.xxdDelegate selectedAccountEdit:_account];
    }
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    if (self.editing == editing)
    {
        return;
    }
    
    [super setEditing:editing animated:animated];

    if (self.editing)
    {
        for (UIView * view in self.subviews) {

            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = nil;
                    }
                }
                UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(-20, -7, 50, 100)];
                image.image = [UIImage imageNamed: @"move"];
                image.contentMode = UIViewContentModeCenter;
                [view addSubview:image];
                
                
            }
        }
        self.backViewWidth.constant = SCREEN_WIDTH - 57;
        self.accountAmount.hidden = YES;
        
        self.editBtn.hidden = NO;
    }else
    {
        self.backViewWidth.constant = SCREEN_WIDTH - 20;
        self.accountAmount.hidden = NO;
        self.editBtn.hidden = YES;

    }
}



@end

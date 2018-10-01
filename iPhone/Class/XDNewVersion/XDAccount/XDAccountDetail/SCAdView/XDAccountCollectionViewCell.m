//
//  XDAccountCollectionViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/9.
//

#import "XDAccountCollectionViewCell.h"
#import "Accounts.h"
#import "AccountType.h"
#import "CategoryBackView.h"
#import "AccountCount.h"
@interface XDAccountCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameL;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeNameT;
@property (weak, nonatomic) IBOutlet UILabel *accountAmount;
@property(nonatomic, strong)CategoryBackView * categoryBackView;
@property (weak, nonatomic) IBOutlet UILabel *reconcileLabel;
@property (weak, nonatomic) IBOutlet UILabel *unclearedLbl;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom2;

@end
@implementation XDAccountCollectionViewCell

-(void)setModel:(id)model{
    
    AccountCount* _account = model;
        
    NSArray* array = @[@"8281FF",@"639AF4",@"7AD2FF",@"4CD3B2",@"47D469",@"F2BE44",@"FF965D",@"FD7881",@"D38CF2"];
    
//    self.backgroundColor = [UIColor colorWithHexString:array[[_account.accountsItem.accountColor integerValue]]];
    self.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_da",array[[_account.accountsItem.accountColor integerValue]]]];
    
    self.imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_account.accountsItem.accountType.iconName componentsSeparatedByString:@"."]firstObject]]] imageWithColor:[UIColor colorWithHexString:array[[_account.accountsItem.accountColor integerValue]]]];
    self.accountNameL.text = _account.accountsItem.accName;
    self.accountTypeNameT.text = _account.accountsItem.accountType.typeName;
    self.accountAmount.text = [XDDataManager moneyFormatter:_account.defaultAmount];
    self.categoryBackView.roundColor = [UIColor colorWithHexString:array[[_account.accountsItem.accountColor integerValue]]];
    if (_account.totalBalance == 0) {
        self.unclearedLbl.hidden = self.reconcileLabel.hidden = YES;
    }else{
        self.reconcileLabel.text = [XDDataManager moneyFormatter:_account.totalBalance];
        self.unclearedLbl.hidden = self.reconcileLabel.hidden = NO;

    }
    self.accountAmount.attributedText = [[NSAttributedString alloc]initWithString:[XDDataManager moneyFormatter:_account.defaultAmount] attributes:@{NSKernAttributeName:@(-1.5f)}];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    self.categoryBackView = [[CategoryBackView alloc]initWithFrame:CGRectMake(13, 20, 44, 44)];
    [self.contentView addSubview:self.categoryBackView];
    [self.contentView bringSubviewToFront:self.imageView];
    
    if (IS_IPHONE_5) {
        self.accountAmount.font = [UIFont fontWithName:FontPingFangRegular size:24];
        self.accountNameL.font = [UIFont fontWithName:FontPingFangRegular size:16];
        self.accountTypeNameT.font = [UIFont fontWithName:FontPingFangRegular size:14];

        self.topLeading1.constant = 15;
        self.topLeading2.constant = 15;
        self.leading3.constant = 37;
        
        self.bottom1.constant = 30;
        self.bottom2.constant = 20;
        
        self.categoryBackView.frame = CGRectMake(13, 15, 44, 44);

    }
}


@end

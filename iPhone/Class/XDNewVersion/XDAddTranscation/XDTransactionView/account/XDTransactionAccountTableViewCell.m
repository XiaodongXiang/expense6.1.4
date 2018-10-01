//
//  XDTransactionAccountTableViewCell.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/25.
//

#import "XDTransactionAccountTableViewCell.h"
#import "AccountType.h"
@interface XDTransactionAccountTableViewCell()
{
    NSArray* _colorArr;
    NSString* _colorStr;
}
@property (weak, nonatomic) IBOutlet UILabel *accountType;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation XDTransactionAccountTableViewCell

-(void)setAccount:(Accounts *)account{
    if (_account != account) {
        _account = account;

        _colorStr = _colorArr[[account.accountColor integerValue]];

        self.accountIcon.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[account.accountType.iconName componentsSeparatedByString:@"."]firstObject]]]imageWithColor:[UIColor whiteColor]];
        
        self.accountIcon.backgroundColor = [UIColor colorWithHexString:_colorStr];
        
        self.accountIcon.layer.cornerRadius = self.accountIcon.width/2;
        self.accountIcon.layer.masksToBounds =  YES;
        
        self.accountName.text = account.accName;
        self.accountType.text = account.accountType.typeName;
        
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _colorArr = @[@"8281FF",@"639AF4",@"7AD2FF",@"4CD3B2",@"47D469",@"F2BE44",@"FF965D",@"FD7881",@"D38CF2"];

}
-(void)setAccountSelected:(BOOL)accountSelected{
    _accountSelected = accountSelected;
    
    if (_accountSelected) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    }else{
        [self.selectedBtn setImage:nil forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  XDAccountTypeBtn.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/8.
//

#import "XDAccountTypeBtn.h"
#import "AccountType.h"
@interface XDAccountTypeBtn()
{
    UIImageView * _imageView;
    UILabel* _titleLbl;
}
@end
@implementation XDAccountTypeBtn

-(void)setAccountType:(AccountType *)accountType{
    _accountType = accountType;
    
    _titleLbl.text = _accountType.typeName;
    _imageView.image = [UIImage imageNamed:_accountType.iconName];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 44, 44)];
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.width, 30)];
        _titleLbl.font = [UIFont fontWithName:FontSFUITextRegular size:12];
        _titleLbl.numberOfLines = 2;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLbl];
        [self addSubview:_imageView];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:RGBColor(246, 246, 246)];
    }else{
        [self setBackgroundColor:[UIColor whiteColor]];

    }
}
@end

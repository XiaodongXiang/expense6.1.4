//
//  XDTransferAccountView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/14.
//

#import "XDTransferAccountView.h"
#import "Accounts.h"
#import "AccountType.h"

@interface XDTransferAccountView()
@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountBigLbl;

@end
@implementation XDTransferAccountView

-(void)setIsFrom:(BOOL)isFrom{
    _isFrom = isFrom;
    if (isFrom) {
        self.accountBigLbl.text = @"From Account";
        self.accountLbl.text = @"From Account";
        self.accountIcon.image = [UIImage imageNamed:@"from account_icon"];
    }else{
        self.accountBigLbl.text = @"To Account";
        self.accountLbl.text = @"To Account";
        self.accountIcon.image = [UIImage imageNamed:@"to account_icon"];

    }
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.width = SCREEN_WIDTH/2-40;
    self.height = 115;
    
    self.accountName.hidden = YES;
    self.accountLbl.hidden = YES;
    

}

-(void)setAccount:(Accounts *)account{
    _account = account;
    
    self.accountName.hidden = NO;
    self.accountLbl.hidden = NO;
    self.accountBigLbl.hidden = YES;
    
    self.accountIcon.image = [UIImage imageNamed:account.accountType.iconName];
    self.accountName.text = account.accName;
    
}


@end

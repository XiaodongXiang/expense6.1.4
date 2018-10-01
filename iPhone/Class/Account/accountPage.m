//
//  accountPage.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/2.
//
//

#import "accountPage.h"
#import "AppDelegate_iPhone.h"
@implementation accountPage
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

        _backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 225, 110)];
        [self addSubview:_backgroundImage];
        
        _accountType=[[UIImageView alloc]initWithFrame:CGRectMake(0, 17, 30, 26)];
        [self addSubview:_accountType];
        
        _accountName=[[UILabel alloc]initWithFrame:CGRectMake(35, 15, 175, 20)];
        _accountName.textColor=[UIColor whiteColor];
        [_accountName setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [_accountName setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_accountName];
        
        _accountTypeName=[[UILabel alloc]initWithFrame:CGRectMake(60, 35, 150, 15)];
        _accountTypeName.textColor=[UIColor whiteColor];
        [_accountTypeName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_accountTypeName setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_accountTypeName];
        
        _totalMoney=[[UILabel alloc]initWithFrame:CGRectMake(10, 68, 200, 22)];
        _totalMoney.textColor=[UIColor whiteColor];
        _totalMoney.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:19];
        [_totalMoney setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_totalMoney];
        
        _unclearMoney=[[UILabel alloc]initWithFrame:CGRectMake(10, 85, 200, 15)];
        _unclearMoney.textColor=[UIColor whiteColor];
        _unclearMoney.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
        [_unclearMoney setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_unclearMoney];
        
        self.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

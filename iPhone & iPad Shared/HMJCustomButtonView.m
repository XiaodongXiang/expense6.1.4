//
//  HMJCustomButtonView.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-12.
//
//

#import "HMJCustomButtonView.h"

@implementation HMJCustomButtonView
@synthesize iconBtn,iconSelectedBg;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        iconSelectedBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:iconSelectedBg];
        
        iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(4, 4, 36, 36)];
        [self addSubview:iconBtn];
        
        
    }
    return self;
}

@end

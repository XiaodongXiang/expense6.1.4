//
//  ClearCusBtn.m
//  PocketExpense
//
//  Created by MV on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClearCusBtn.h"

@implementation ClearCusBtn
@synthesize t;

- (id)init{
    if (self = [super init]) 
	{
        [self setImage:[UIImage imageNamed:@"ipad_check_mark_30_30.png"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"ipad_check_mark2_30_30.png"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

 
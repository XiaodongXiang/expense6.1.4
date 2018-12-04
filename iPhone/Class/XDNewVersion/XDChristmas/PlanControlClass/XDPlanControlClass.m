//
//  XDPlanControlClass.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/4.
//

#import "XDPlanControlClass.h"

@implementation XDPlanControlClass

+(instancetype)shareControlClass{
    static XDPlanControlClass* g_class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_class = [[XDPlanControlClass alloc]init];
    });
    return g_class;
}

-(void)setChristmasView:(XDOverviewChristmasViewA *)christmasView{
    self.planType = ChristmasPlanA;
    
    if (self.planType == ChristmasPlanA) {
        
        [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_8"] forState:UIControlStateNormal];
    }else{
        [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_banner_8"] forState:UIControlStateNormal];
    }
}

-(BOOL)needShow{
    return YES;
}


@end

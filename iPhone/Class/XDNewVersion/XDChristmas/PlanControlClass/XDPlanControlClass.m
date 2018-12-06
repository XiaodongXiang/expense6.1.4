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
    
    if (self.planType == ChristmasPlanA) {
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"christmas_banner_plus"] forState:UIControlStateNormal];
        }
        
    }else{
        if (IS_IPHONE_5) {
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone se"] forState:UIControlStateNormal];
        }else if (IS_IPHONE_6){
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_banner_8"] forState:UIControlStateNormal];
        }else{
            [christmasView.christmasBtn setImage:[UIImage imageNamed:@"Bchristmas_iPhone 8plus"] forState:UIControlStateNormal];
        }
    }
}

-(BOOL)needShow{
    return YES;
}


-(ChristmasPlanType)planType{
    
    return random()%2;
}

-(ChristmasSubPlan)planSubType{
    return random()%2;
}

-(ChristmasPlanCategory)planCategory{
    return random()%4;
}
@end

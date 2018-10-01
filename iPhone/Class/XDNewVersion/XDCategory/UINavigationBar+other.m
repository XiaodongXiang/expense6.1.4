//
//  UINavigationBar+other.m
//  PocketExpense
//
//  Created by 晓东 on 2018/5/15.
//

#import "UINavigationBar+other.h"

@implementation UINavigationBar (other)

-(void)setColor:(UIColor*)color{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=10.0f) {

        if (IS_IPHONE_X) {
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, 88)];
            view.backgroundColor = color;
            
            [self setValue:view forKey:@"backgroundView"];
        }else{
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
            view.backgroundColor = color;
            
            [self setValue:view forKey:@"backgroundView"];
        }
    }else{
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
    }
}


@end

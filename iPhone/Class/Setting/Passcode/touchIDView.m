//
//  touchIDView.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/5.
//
//

#import "touchIDView.h"

@implementation touchIDView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        float imageW=200;
        UIImageView *imageTouch=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-imageW)/2, 55, imageW, imageW)];
        imageTouch.image=[UIImage imageNamed:@"icon"];
        imageTouch.contentMode = UIViewContentModeCenter;
        [self addSubview:imageTouch];
        
        if (IS_IPHONE_X) {
            
            UIImageView *imageTouch1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-imageW)/2, 280, 70, 70)];
            imageTouch1.image=[UIImage imageNamed:@"face id"];
            imageTouch1.contentMode = UIViewContentModeCenter;
            imageTouch1.centerX =  SCREEN_WIDTH/2;
            [self addSubview:imageTouch1];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 370, 200, 20)];
            label.text = @"Face ID";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:FontSFUITextRegular size:16];
            label.textColor = RGBColor(125, 125, 125);
            label.centerX =  SCREEN_WIDTH/2;
            
            [self addSubview:label];
        }else{
            
            UIImageView *imageTouch1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-imageW)/2, 280, 70, 70)];
            imageTouch1.image=[UIImage imageNamed:@"print-1"];
            imageTouch1.contentMode = UIViewContentModeCenter;
            imageTouch1.centerX =  SCREEN_WIDTH/2;

            [self addSubview:imageTouch1];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 370, 200, 20)];
            label.text = @"Touch ID";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:FontSFUITextRegular size:16];
            label.textColor = RGBColor(125, 125, 125);
            label.centerX =  SCREEN_WIDTH/2;
            
            [self addSubview:label];
        }
        
        
    }
    return self;
}
@end

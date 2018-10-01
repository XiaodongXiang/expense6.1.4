//
//  MyPageControl.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/12/15.
//
//

#import "MyPageControl.h"

@interface MyPageControl ()

@end

@implementation MyPageControl

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self updateDots];
    }
    return self;
}

-(void) updateDots
{
    float interval;
    if (IS_IPHONE_5)
    {
        interval=16;
    }
    else
    {
        interval=12;
    }
    UIImage *inactiveImage = [UIImage imageNamed:@"pilot_point1"];
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView *dot = [self.subviews objectAtIndex:i];
        for (UIView *views in dot.subviews)
        {
            [views removeFromSuperview];
        }
        dot.backgroundColor=[UIColor clearColor];
        if (i==0)
        {
            dot.frame=CGRectMake(self.frame.size.width/2-interval-1.5*inactiveImage.size.width, 6.5, inactiveImage.size.width, inactiveImage.size.height);
            NSLog(@"%@",dot);
        } 
        else if(i==1)
        {
            dot.frame=CGRectMake(self.frame.size.width/2-0.5*inactiveImage.size.width, 6.5, inactiveImage.size.width, inactiveImage.size.height);
            NSLog(@"%@",dot);

        }
        else
        {
            dot.frame=CGRectMake(self.frame.size.width/2+interval+0.5*inactiveImage.size.width,65, inactiveImage.size.width, inactiveImage.size.height);
            NSLog(@"%@",dot);

        }
        UIImageView *dotImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, inactiveImage.size.width, inactiveImage.size.height)];

        dotImage.image=inactiveImage;
        [dot addSubview:dotImage];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

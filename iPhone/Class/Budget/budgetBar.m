//
//  budgetBar.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/5.
//
//

#import "budgetBar.h"

@interface budgetBar()
{
    BOOL _isBig;
    float _ratio;
    UIColor *_color;
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation budgetBar
-(id)initWithFrame:(CGRect)frame type:(BOOL)isBig ratio:(float)ratio color:(UIColor *)color
{
    if (self= [super initWithFrame:frame])
    {
        
        _isBig=isBig;
        _ratio=ratio;
        _color=color;
        
        _width=frame.size.width;
        _height=frame.size.height;
        
        [self setRatio];
    }
    return self;
}
-(void)setRatio
{
    
    
    UIView *left=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _width*_ratio, _height)];
    
    
    left.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [self addSubview:left];
    
    UIView *right=[[UIView alloc]initWithFrame:CGRectMake(_width*_ratio, 0, _width-_width*_ratio, _height)];
    right.backgroundColor=_color;
    [self addSubview:right];
    
    UIImageView *top=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    if (_isBig)
    {
        top.image=[UIImage imageNamed:[NSString customImageName:@"budget_first_bg"]];
    }
    else
    {
        top.image=[UIImage imageNamed:[NSString customImageName:@"budget_second_bg"]];
    }
    [self addSubview:top];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

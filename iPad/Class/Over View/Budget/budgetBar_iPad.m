//
//  budgetBar_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/27.
//
//

#import "budgetBar_iPad.h"

@interface budgetBar_iPad ()
{
    NSString *_barType;
    float _ratio;
    UIColor *_color;
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation budgetBar_iPad
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(id)initWithFrame:(CGRect)frame type:(NSString *)barType ratio:(float)ratio color:(UIColor *)color
{
    if (self= [super initWithFrame:frame])
    {
        
        _barType=barType;
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
    
    if (_ratio > 1 || _ratio < -1) {
        _ratio = 1;
    }
    UIImageView *left=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width*_ratio, _height)];
    left.image=[self imageWithColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1]];
    [self addSubview:left];
    
    UIImageView *right=[[UIImageView alloc]initWithFrame:CGRectMake(_width*_ratio, 0, _width-_width*_ratio, _height)];
    right.image=[self imageWithColor:_color];
    [self addSubview:right];
    
    
    _top=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];

    _top.image=[UIImage imageNamed:[NSString stringWithFormat:@"iPad_budgetBar_%@",_barType]];
    
    [self addSubview:_top];
}
@end

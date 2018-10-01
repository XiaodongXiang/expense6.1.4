//
//  CategoryBackView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/16.
//

#import "CategoryBackView.h"

@implementation CategoryBackView

-(void)setRoundColor:(UIColor *)roundColor{
    _roundColor = roundColor;
    
    [self setNeedsDisplay];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.width/2;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:self.width/2 - 3 startAngle:0 endAngle:M_PI*2 clockwise:YES];

    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    
    UIBezierPath* path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2) radius:self.width/2 - 2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    path1.lineWidth = 4;
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] set];
    [path1 stroke];
    
}

@end

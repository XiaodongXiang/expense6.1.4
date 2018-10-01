//
//  UIView+XDExtension.m
//  myapp2
//
//  Created by APPXY on 16/1/19.
//  Copyright © 2016年 APPXY. All rights reserved.
//

#import "UIView+XDExtension.h"

@implementation UIView (XDExtension)

-(CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

-(CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

-(CGFloat)maxX
{
    return self.x + self.width;
}

-(CGFloat)maxY
{
    return self.y + self.height;
}

-(CGSize)size
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

-(void)setX:(CGFloat)X
{
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}

-(void)setY:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end

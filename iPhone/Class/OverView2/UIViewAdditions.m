/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "UIViewAdditions.h"

@implementation UIView (KalAdditions)

- (CGFloat)left
{
  return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)right
{
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)top
{
  return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)bottom
{
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)width
{
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height
{
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


-(void) animationFromScale:(CGFloat) scale1 toScale:(CGFloat) scale2
{
    CGRect oRect = self.frame;
    CGFloat _width = (scale2 - scale1) * oRect.size.width;
    CGFloat _height = (scale2 - scale1) * oRect.size.height;
    
    self.transform = CGAffineTransformMakeScale(scale1, scale1);
    self.frame = CGRectMake(oRect.origin.x + _width/2.f,
                            oRect.origin.y + _height,
                            self.width, self.height);
    self.alpha = 0.5;
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 1.0f;
                         self.transform = CGAffineTransformMakeScale(scale2, scale2);
                         self.frame = oRect;
                     }
                     completion:^(BOOL finished){
                     }];
}
@end

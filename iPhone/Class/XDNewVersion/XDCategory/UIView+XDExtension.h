//
//  UIView+XDExtension.h
//  myapp2
//
//  Created by APPXY on 16/1/19.
//  Copyright © 2016年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XDExtension)

- (CGFloat)x;

- (CGFloat)y;

- (CGFloat)centerX;

- (CGFloat)centerY;

- (CGFloat)maxX;

- (CGFloat)maxY;

- (CGFloat)width;

- (CGFloat)height;

- (CGSize)size;

- (void) setX:(CGFloat)X;

- (void) setY:(CGFloat)Y;

- (void) setWidth:(CGFloat)width;

- (void) setHeight:(CGFloat)height;

- (void) setCenterX:(CGFloat)centerX;

- (void) setCenterY:(CGFloat)centerY;

- (void) setSize:(CGSize)size;
@end

//
//  avatorImageView.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/23.
//
//

#import "avatorImageView.h"

#define LINE_BORDER_WIDTH 0

@interface avatorImageView ()
{
    UIImage *originalImage;
}

@end
@implementation avatorImageView

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        originalImage = image;
        
        
        [self draw];
    }
    return self;
}

-(void)draw
{
    _pathColor=[UIColor blackColor];
    _pathWidth=0;
    _borderColor=[UIColor blackColor];
    CGRect rect;
    rect.size = self.frame.size;
    rect.origin = CGPointMake(0, 0);
    
    CGRect rectImage = rect;
    rectImage.origin.x += _pathWidth;
    rectImage.origin.y += _pathWidth;
    rectImage.size.width -= _pathWidth*2.0;
    rectImage.size.height -= _pathWidth*2.0;
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size,0,0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    

    CGContextAddEllipseInRect(ctx, rect);
     
    
    CGContextClip(ctx);
    [originalImage drawInRect:rectImage];
    
    
    
    //Add intern and extern line
    rectImage.origin.x -= LINE_BORDER_WIDTH/2.0;
    rectImage.origin.y -= LINE_BORDER_WIDTH/2.0;
    rectImage.size.width += LINE_BORDER_WIDTH;
    rectImage.size.height += LINE_BORDER_WIDTH;
    
    rect.origin.x += LINE_BORDER_WIDTH/2.0;
    rect.origin.y += LINE_BORDER_WIDTH/2.0;
    rect.size.width -= LINE_BORDER_WIDTH;
    rect.size.height -= LINE_BORDER_WIDTH;
    
    CGContextSetStrokeColorWithColor(ctx, [_borderColor CGColor]);
    CGContextSetLineWidth(ctx, LINE_BORDER_WIDTH);
    
    CGContextStrokeEllipseInRect(ctx, rectImage);
    CGContextStrokeEllipseInRect(ctx, rect);

    
    
    //Add center line
    float centerLineWidth = _pathWidth - LINE_BORDER_WIDTH*2.0;
    
    rectImage.origin.x -= LINE_BORDER_WIDTH/2.0+centerLineWidth/2.0;
    rectImage.origin.y -= LINE_BORDER_WIDTH/2.0+centerLineWidth/2.0;
    rectImage.size.width += LINE_BORDER_WIDTH+centerLineWidth;
    rectImage.size.height += LINE_BORDER_WIDTH+centerLineWidth;
    
    CGContextSetStrokeColorWithColor(ctx, [_pathColor CGColor]);
    CGContextSetLineWidth(ctx, centerLineWidth);
    
    CGContextStrokeEllipseInRect(ctx, rectImage);
    
    
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

}
@end

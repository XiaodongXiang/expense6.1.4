//
//  OverViewBudgetPiCharView.m
//  PocketExpense
//
//  Created by humingjing on 14-3-25.
//
//

#import "OverViewBudgetPiCharView.h"
#import "QuartzCore/QuartzCore.h" // for CALayer
#include <math.h>
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation OverViewBudgetPiCharView
@synthesize availableAmount,spent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float misssector = 90;
 	UIColor *blueColor = [UIColor colorWithRed:12.f/255.f green:164.f/255.f blue:227.f/255.f alpha:1];
    UIColor *redColor = [UIColor colorWithRed:243.f/255.f green:61.f/255.f blue:36.f/255.f alpha:1];
    UIColor *gray = [UIColor colorWithRed:192.f/255.f green:192.f/255.f blue:192.f/255.f alpha:1];
    UIColor *transparentColor = [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1];
    
    CGRect parentViewBounds = self.bounds;
	CGFloat x = (CGRectGetWidth(parentViewBounds)-1)/2+0.5;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2+0.5;
    CGFloat r =CGRectGetHeight(parentViewBounds)/2;
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

    if (availableAmount==0)
    {
        double startdegrees = 90+ misssector/2;

        //use whiteColor to draw,need to use this way 画里面的小圆
        CGContextSetFillColor(ctx, CGColorGetComponents( [ transparentColor CGColor]));
        //X,Y半径
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees +360), 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
    }
    else
    {

        if(spent<=0)
        {
            double startdegrees = 90+ misssector/2;

            //use whiteColor to draw,need to use this way 画里面的小圆
            CGContextSetFillColor(ctx, CGColorGetComponents( [gray CGColor]));
            //X,Y半径
            CGContextMoveToPoint(ctx, x, y);
            CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees +360), 0);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
            
            
        }
        else
        {
            if(spent<=availableAmount)
            {
                double startdegrees = 90+ misssector/2;

                CGContextSetFillColor(ctx, CGColorGetComponents( [blueColor CGColor]));
                CGContextMoveToPoint(ctx, x, y);
                
                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees + spent/availableAmount*(360-misssector)), 0);
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
                
                startdegrees += spent/availableAmount*(360-misssector);
                
                CGContextSetFillColor(ctx, CGColorGetComponents( [gray CGColor]));
                CGContextMoveToPoint(ctx, x, y);
                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees+(availableAmount- spent)/availableAmount*(360-misssector)), 0);
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
            }
            else if(spent>availableAmount&&spent<=2*availableAmount)
            {
                double startdegrees = 90+ misssector/2;
                
                CGContextSetFillColor(ctx, CGColorGetComponents( [redColor CGColor]));
                //X,Y半径
                CGContextMoveToPoint(ctx, x, y);
                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees+360), 0);
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
                
//                double startdegrees = 90+ misssector/2;
//                //blue
//                CGContextSetFillColor(ctx, CGColorGetComponents( [blueColor CGColor]));
//                CGContextMoveToPoint(ctx, x, y);
//                NSLog(@"from %f to %f",startdegrees,startdegrees +(1-(spent-availableAmount)/spent));
//                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees +(1-(spent-availableAmount)/spent)*(360-misssector)), 0);
//                CGContextClosePath(ctx);
//                CGContextFillPath(ctx);
//                
//                startdegrees += (1-(spent-availableAmount)/spent)*(360-misssector);
//                
//                //red
//                CGContextSetFillColor(ctx, CGColorGetComponents( [redColor CGColor]));
//                CGContextMoveToPoint(ctx, x, y);
//                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees +(spent-availableAmount)/spent*(360-misssector)), 0);
//                CGContextClosePath(ctx);
//                CGContextFillPath(ctx);
              
            }
            //red
            else
            {
                double startdegrees = 90+ misssector/2;

                CGContextSetFillColor(ctx, CGColorGetComponents( [redColor CGColor]));
                //X,Y半径
                CGContextMoveToPoint(ctx, x, y);
                CGContextAddArc(ctx, x, y,   r,  radians(startdegrees), radians(startdegrees+360), 0);
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
    
            }
        }
    }
//    
//    
//    //use whiteColor to draw,need to use this way 画里面的小圆
//    CGContextSetFillColor(ctx, CGColorGetComponents( [ [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1] CGColor]));
//    //X,Y半径
//    CGContextMoveToPoint(ctx, x, y);
//    CGContextAddArc(ctx, x, y,   45,  radians(0), radians(360), 0);
//    CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
    
}

@end

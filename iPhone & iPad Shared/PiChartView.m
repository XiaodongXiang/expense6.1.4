//
//  PiChartView.m
//  Bill Buddy
//
//  Created by Tommy on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PiChartView.h"
#import "QuartzCore/QuartzCore.h" // for CALayer
#include <math.h>

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation PiChartViewItem
 

@synthesize cName,cColor,cData,cPercent,indexOfMemArr,cImage;
@synthesize category,transactionArray;

-(id)initWithName:(NSString *)n color:(UIColor *)c data:(double)d  ;
{
	if ((self = [super init])) {
 		cName = n;
		cColor =  c ;
		cData	= d;
		cPercent = 0.0;
        indexOfMemArr =-1;
        cImage = nil;
        
        transactionArray = [[NSMutableArray alloc]init];
	}
	return self;
}


-(NSString *)cName;
{
	return cName;
}
-(UIColor *)cColor;
{
	return cColor;
}
-(double)cData
{
	return cData;
}
-(double)cPercent
{
	return cPercent;
}



@end

@implementation PiChartView

@synthesize catdataArray,catdataArray1,clickIndex,delX,delY;
@synthesize canBetouch;
@synthesize delegate;
@synthesize iReportCategotyViewController;

- (void)allocArray
{
	catdataArray = [[NSMutableArray alloc] init] ;
    catdataArray1 = [[NSMutableArray alloc] init] ;
    clickIndex =-1;
    canBetouch = TRUE;
}

- (void)setCateData:(NSMutableArray *)data
{
    [catdataArray removeAllObjects];
  	[catdataArray setArray:data];
}

- (void)setCateData1:(NSMutableArray *)data
{
    [catdataArray1 removeAllObjects];
  	[catdataArray1 setArray:data];
}

- (void)drawRect:(CGRect)rect
{
	CGRect parentViewBounds = self.bounds;
	CGFloat x = CGRectGetWidth(parentViewBounds)/2;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2;
	
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	//CGContextConcatCTM(ctx, CGAffineTransformMakeRotation(M_PI));
	// define stroke color
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
 	// define line width
	CGContextSetLineWidth(ctx, 4.0);
	
    if([catdataArray count] + [catdataArray1 count] == 0)
    {
        CGContextSetFillColor(ctx, CGColorGetComponents( [ [UIColor colorWithRed:150.f/255.0 green:150.f/255.0 blue:150.f/255.0 alpha:1.f] CGColor]));
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y, (rect.size.height)/2,  radians(0), radians(360), 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
	
	// need some values to draw pie charts
	double startdegrees = -90;
	UIColor *drawColor = nil;
	PiChartViewItem *tmpPiItem;
    
  	for (int i = 0 ; i<[catdataArray count];i++)
	{
		tmpPiItem =[catdataArray objectAtIndex:i];
        
 		drawColor = tmpPiItem.cColor;
        
 		CGContextSetFillColor(ctx, CGColorGetComponents( [ drawColor CGColor]));
        if(clickIndex == i)
        {
            CGContextMoveToPoint(ctx, x+delX, y+delY);
            
            CGContextAddArc(ctx, x+delX, y+delY, (rect.size.height)/2,  radians(startdegrees), radians(startdegrees+tmpPiItem.cPercent*360), 0);
            
        }
        else
        {
            CGContextMoveToPoint(ctx, x, y);
            
            CGContextAddArc(ctx, x, y, (rect.size.height)/2,  radians(startdegrees), radians(startdegrees+tmpPiItem.cPercent*360), 0);
        }
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
		startdegrees +=tmpPiItem.cPercent*360;
	}
	
    for (int i = 0 ; i<[catdataArray1 count];i++)
	{
		tmpPiItem =[catdataArray1 objectAtIndex:i];
        
 		drawColor = tmpPiItem.cColor;
 		CGContextSetFillColor(ctx, CGColorGetComponents( [ drawColor CGColor]));
        CGContextMoveToPoint(ctx, x+delX, y+delY);
		CGContextAddArc(ctx, x+delX, y+delY, (rect.size.height)/2,  radians(startdegrees), radians(startdegrees+tmpPiItem.cPercent*360), 0);
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
		startdegrees +=tmpPiItem.cPercent*360;
	}
    
    
    //use whiteColor to draw,need to use this way 画里面的小圆
    CGContextSetFillColor(ctx, CGColorGetComponents( [ [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1] CGColor]));
    //X,Y半径
    CGContextMoveToPoint(ctx, x, y);
    float r= 45;
    if (_expenseViewController != nil)
    {
        if (IS_IPHONE_6PLUS)
            
            r = 58;
        else if (IS_IPHONE_6)
            r = 53;
        else
            r = 45;
    }
    else if (self.iReportCategotyViewController!=nil)
    {
        r = 86;
    }
    else if(self.categoryViewController != nil)
    {
        r=130;
    }
    
    if (_whiteCycleR>0)
        r = _whiteCycleR;
    
    CGContextAddArc(ctx, x, y,   r,  radians(0), radians(360), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
    if(!canBetouch || ([catdataArray count] +[catdataArray1 count] == 0)) return;
 	UITouch *touch = [touches anyObject];
	CGPoint p1 = [touch locationInView:self];
	CGRect parentViewBounds = self.bounds;
	CGFloat x = CGRectGetWidth(parentViewBounds)/2;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    
    float delz = ABS(sqrt(fabs((p1.x -x) * (p1.x -x)) + fabs((p1.y -y) * (p1.y -y))));
    float r =(self.frame.size.height)/2-10;
    if(delz > r) return;
    
    float degrees=0;
    if(p1.x >=x &&p1.y>=y)
    {
        degrees = atan2(fabs(p1.y -y),fabs(p1.x -x)) * 180 / PI;
    }
    else if(p1.x <x &&p1.y>=y)
    {
        degrees =90+ atan2(fabs(p1.x -x),fabs(p1.y -y)) * 180 / PI;
    }
    else    if(p1.x <x &&p1.y<y)
    {
        degrees =180+ atan2(fabs(p1.y -y),fabs(p1.x -x)) * 180 / PI;
        
    }
    else if(p1.x >=x &&p1.y<y)
    {
        degrees =270+ atan2(fabs(p1.x -x),fabs(p1.y -y)) * 180 / PI-360;
        
    }
    
   	int startdegrees =  -90;
    int enddegrees = -90;
    
	PiChartViewItem *tmpPiItem;
    delX =0;
    delY=0;
    
  	for (int i = 0 ; i<[catdataArray count];i++)
	{
		tmpPiItem =[catdataArray objectAtIndex:i];
        
        startdegrees =enddegrees;
		enddegrees  =startdegrees +tmpPiItem.cPercent*360;
        double countdegrees = startdegrees +abs(enddegrees-startdegrees)/2;
        
        if(degrees>=startdegrees&&degrees<=enddegrees)
        {
            if(clickIndex ==i)
            {
                clickIndex =-1;
            }
            else
            {
                
                if(countdegrees >=0 &&countdegrees<90)
                {
                    int countdegrees1 = startdegrees+abs(enddegrees-startdegrees)/2  ;
                    
                    delX=fabs( cos(countdegrees1*PI/180)) * 10  ;
                    delY=fabs( sin(countdegrees1*PI/180)) * 10  ;
                    
                }
                else if(countdegrees >=90 &&countdegrees<180)
                {
                    int countdegrees1 = startdegrees+abs(enddegrees-startdegrees)/2- 90 ;
                    
                    delX= -fabs(sin(countdegrees1*PI/180)) * 10  ;
                    delY= fabs(cos(countdegrees1*PI/180)) * 10  ;
                }
                else   if(countdegrees >=180 &&countdegrees<270)
                {
                    int countdegrees1 = startdegrees+abs(enddegrees-startdegrees)/2-180 ;
                    
                    delX= -fabs(cos(countdegrees1*PI/180) )* 10  ;
                    delY= -fabs(sin(countdegrees1*PI/180)) * 10  ;
                }
                // else if(countdegrees >=270 &&countdegrees<360)
                else if(countdegrees >=-90 &&countdegrees<0)
                {
                    int countdegrees1 = startdegrees+abs(enddegrees-startdegrees)/2+90 ;
                    
                    delX= fabs(sin(countdegrees1*PI/180) )* 10  ;
                    delY= -fabs(cos(countdegrees1*PI/180)) * 10  ;
                }
                
                
                clickIndex =i;
            }
            [self.delegate PiChartViewDelegateByIndex:clickIndex];
            
            [self setNeedsDisplay];
            break;
        }
	}
    
}

-(void)setOneCateArcByIndex:(NSInteger)i
{
   	int startdegrees = -90;
    int enddegrees = -90;
    
	PiChartViewItem *tmpPiItem;
    delX =0;
    delY=0;
    
  	for (int k = 0 ; k<[catdataArray count];k++)
	{
		tmpPiItem =[catdataArray objectAtIndex:k];
        
        startdegrees =enddegrees;
		enddegrees  =startdegrees +tmpPiItem.cPercent*360;
        double countdegrees = startdegrees +(enddegrees-startdegrees)/2;
        
        if(k == i)
        {
            
            if(countdegrees >=0 &&countdegrees<90)
            {
                int countdegrees1 = startdegrees+(enddegrees-startdegrees)/2  ;
                
                delX=fabs( cos(countdegrees1*PI/180)) * 10  ;
                delY=fabs( sin(countdegrees1*PI/180)) * 10  ;
                
            }
            else if(countdegrees >=90 &&countdegrees<180)
            {
                int countdegrees1 = startdegrees+(enddegrees-startdegrees)/2- 90 ;
                
                delX= -fabs(sin(countdegrees1*PI/180)) * 10  ;
                delY= fabs(cos(countdegrees1*PI/180)) * 10  ;
                
            }
            else   if(countdegrees >=180 &&countdegrees<270)
            {
                int countdegrees1 = startdegrees+(enddegrees-startdegrees)/2-180 ;
                
                delX= -fabs(cos(countdegrees1*PI/180) )* 10  ;
                delY= -fabs(sin(countdegrees1*PI/180)) * 10  ;
                
            }
            else if(countdegrees >=-90 &&countdegrees<0)
            {
                int countdegrees1 = startdegrees+(enddegrees-startdegrees)/2+90 ;
                
                delX= fabs(sin(countdegrees1*PI/180) )* 10  ;
                delY= -fabs(cos(countdegrees1*PI/180)) * 10  ;
                
            }
            clickIndex =i;
            
            [self setNeedsDisplay];
            break;
            
        }
        
    }
    
    
}


 @end

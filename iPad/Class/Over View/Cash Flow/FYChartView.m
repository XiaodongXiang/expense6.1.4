//
//  FYChartView.m
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import "FYChartView.h"
#import "AppDelegate_iPad.h"

#define LEFTX 13.5
#define TOP 0
#define VIEW_WITH 532
#define VIEW_HIGH 150
#define WITH 491
#define HIGH 167
#define HIGH_WITH_BOTTOM    128

@interface FYChartView ()

@property (nonatomic, strong) NSMutableArray *valueItemArray;
@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UIView *slideLineView;

@end

@implementation FYChartView
{
    @private
    BOOL    isLoaded;                   //is already load
    float   horizontalItemWidth;        //horizontal item width
    float   verticalItemHeight;         //vertical item width
    float   maxVerticalValue;           //max vertical value
//    CGSize  verticalTextSize;           //vertical text size
}
@synthesize cashFlowTypeIsIncome;
@synthesize valueItemArray;
@synthesize descriptionView;
@synthesize slideLineView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //default line width
        self.rectanglelineWidth = 1.0f;
        self.lineWidth = 1.0f;
        
        //default line color
        self.rectangleLineColor = [UIColor blackColor];
        self.lineColor = [UIColor blackColor];
        
        self.hideDescriptionViewWhenTouchesEnd = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (isLoaded)   return;
    
    //画格子线
    [self drawRectangleAndVerticalText:rect];
    
    
    //画数据
    [self drawValueLine2:rect];
    
    
    if (self.descriptionView){
        NSLog(@"desciptionView remove");
        [self.descriptionView removeFromSuperview];
    }
    
    
    isLoaded = YES;
  }



//画线
- (void)drawRectangleAndVerticalText:(CGRect)rect
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    //设置画笔的颜色 粗细
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);

    NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfValue2ItemCountInChartView:self];
    float itemWidth = WITH / numberOfHorizontalItemCount;

    //画最底下的横线
    CGContextMoveToPoint(currentContext, LEFTX-13.5, rect.origin.y+HIGH);
    CGContextAddLineToPoint(currentContext, itemWidth*numberOfHorizontalItemCount+LEFTX+13.5, rect.origin.y+HIGH);
    CGContextStrokePath(currentContext);
    
    //画横坐标的小竖线
    CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
    
    //画竖线
    if (appDelegate_iPad.mainViewController.overViewController.noRecordLabel.hidden)
    {
        
        CGFloat lengths[] = {3,2};
        CGContextSetLineDash(currentContext, 0, lengths,2);
        [[UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1] setFill];
        CGContextSetStrokeColorWithColor(currentContext, [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1].CGColor);
        
        CGContextSetLineWidth(currentContext, EXPENSE_SCALE);
        
        NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfValue2ItemCountInChartView:self];
        float itemWidth = WITH / numberOfHorizontalItemCount;
        
        for (int i = 0; i <=numberOfHorizontalItemCount; i++)
        {
                CGContextMoveToPoint(currentContext, itemWidth*i+LEFTX, TOP);
                CGContextAddLineToPoint(currentContext,
                                        itemWidth*i+LEFTX,
                                        HIGH);
                CGContextClosePath(currentContext);
                CGContextStrokePath(currentContext);
        }


    }
    
    
}


//画折线
- (void)drawValueLine2:(CGRect)rect
{
    if (!self.dataSource)   return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    //共有多少天
    NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfValue2ItemCountInChartView:self];
    if (!numberOfHorizontalItemCount)   return;
    
    //获取item的yvalue放在一个数组里，方便小标签获取
    NSMutableArray *valueItems = [NSMutableArray array];
    for (int i = 0; i < numberOfHorizontalItemCount; i++)
    {
        float value = [self.dataSource chartView:self value2AtIndex:i];
        [valueItems addObject:[NSNumber numberWithFloat:value]];
        
        if (value >= maxVerticalValue)
            maxVerticalValue = value;
    }
    self.valueItemArray = valueItems;

    //计算横坐标上每一个格子多长，以及y坐标上面一个像素代表多少值
    horizontalItemWidth = WITH / numberOfHorizontalItemCount;
    verticalItemHeight = (HIGH-7) / maxVerticalValue;

    
     const CGFloat *components = CGColorGetComponents(self.lineColor2.CGColor);
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.overViewController.noRecordLabel.hidden)
    {
        
        for (int i = 0; i < valueItems.count - 1; i++)
        {
            float value = [(NSNumber *)valueItems[i] floatValue];
            CGPoint point = [self valuePoint:value atIndex:i];
            float nextValue = [(NSNumber *)valueItems[i +1] floatValue];
            CGPoint nextPoint = [self valuePoint:nextValue atIndex:i + 1];
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIColor *brokenLineColor = self.lineColor2;
            //画圆
            CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
            CGContextSetLineWidth(context, 2.0);
            CGContextSetFillColor(context, CGColorGetComponents(brokenLineColor.CGColor));
            CGContextAddArc(context, point.x, point.y, 2, 0, 360, 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
            //画折线
            CGContextSetRGBFillColor(context,components[0], components[1], components[2], 0.15);
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            CGContextSetStrokeColorWithColor(context, self.lineColor2.CGColor);
            CGContextSetLineWidth(context, self.lineWidth);
            CGFloat lengths1[] = {3,0};
            CGContextSetLineDash(context, 0, lengths1,2);
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
            //画最后一个圆
            if (i==valueItems.count -2)
            {
                CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
                CGContextSetLineWidth(context, 2.0);
                CGContextSetFillColor(context, CGColorGetComponents(brokenLineColor.CGColor));
                CGContextAddArc(context, nextPoint.x, nextPoint.y, 2, 0, 360, 0);
                CGContextClosePath(context);
                CGContextFillPath(context);
            }
        }
        
        //画大片涂层
        CGContextSetRGBFillColor(context, 243.f/255.f, 61.f/255.f, 36.f/255.f, 0.15);
            
        //第一个如果不是0的话，就要多画一个点来设置正确的起始点
        float value = [(NSNumber *)valueItems[0] floatValue];
        CGPoint point = [self valuePoint:value atIndex:0];

        if (value != 0)
        {
            CGContextMoveToPoint(context, LEFTX, HIGH);
        }
        else
            CGContextMoveToPoint(context, LEFTX, point.y);
        
        for (long int i=0; i<[valueItems count]; i++)
        {
            float value = [(NSNumber *)valueItems[i] floatValue];
            double onePercent;
            if (maxVerticalValue==0)
            {
                onePercent = 0;
            }
            else
                onePercent = value/maxVerticalValue;
            
            double oneLocation =(1-onePercent)*HIGH;
            
            CGContextAddLineToPoint(context, LEFTX+ horizontalItemWidth*i, oneLocation);
            //当最后一个点不是0的时候，就要多加一个结束点
            if (i == [valueItems count]-1) {
                if (onePercent!=0) {
                    CGContextAddLineToPoint(context, LEFTX+horizontalItemWidth*i, HIGH);
                }
            }
        }
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
    }
    
    
    
    //draw horizontal title
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAtIndex:)])
    {
        UIColor *numColor = [UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1];
        UIFont *numFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
        for (int i = 0; i < valueItems.count; i++)
        {
            NSString *title = [self.dataSource chartView:self horizontalTitleAtIndex:i];
            if (title && i%2==0)
            {
                float value = [(NSNumber *)valueItems[i] floatValue];
                CGPoint point = [self valuePoint:value atIndex:i];
                
//                UIFont *font = [UIFont systemFontOfSize:10.0f];
//                CGSize size = [title sizeWithFont:font];
                NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:10.0f],NSFontAttributeName, nil];
                CGSize size = [title sizeWithAttributes:tmpAttr];

                HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
                if ([self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAlignmentAtIndex:)])
                {
                    alignment = [self.dataSource chartView:self horizontalTitleAlignmentAtIndex:i];
                }
                CGFloat yOffset=0;
                if (alignment == HorizontalTitleAlignmentLeft)
                {
                  //  [title drawAtPoint:CGPointMake(point.x, rect.size.height - size.height+yOffset) withFont:font];
                    [title drawAtPoint:CGPointMake(point.x, rect.size.height - 15+yOffset) withAttributes:[NSDictionary dictionaryWithObjects:@[numFont,numColor] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]]];
                }
                else if (alignment == HorizontalTitleAlignmentCenter)
                {
                   // [title drawAtPoint:CGPointMake(point.x - size.width * 0.5f, rect.size.height - size.height+yOffset) withFont:font];
                    [title drawAtPoint:CGPointMake(point.x - size.width * 0.5f, rect.size.height - 15+yOffset) withAttributes:[NSDictionary dictionaryWithObjects:@[numFont,numColor] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]]];
                }
                else if (alignment == HorizontalTitleAlignmentRight)
                {
                  //  [title drawAtPoint:CGPointMake(point.x - size.width, rect.size.height - size.height+yOffset) withFont:font];
                    [title drawAtPoint:CGPointMake(point.x - size.width, rect.size.height - 15+yOffset) withAttributes:[NSDictionary dictionaryWithObjects:@[numFont,numColor] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName]]];
                    
                }
            }
        }
    }
}

#pragma mark - custom method

/**
 *  value item point at index
 */
- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
//    retPoint.x = index * horizontalItemWidth + verticalTextSize.width;
    retPoint.x = index * horizontalItemWidth + LEFTX;

    if (value==0)
    {
        retPoint.y=HIGH+TOP;
    }
    else
    retPoint.y = HIGH - value * verticalItemHeight+TOP;
    
    return retPoint;
}

/**
 *  display description view
 */
- (void)descriptionViewPointWithTouches:(NSSet *)touches
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate_iPad.mainViewController.overViewController.noRecordLabel.hidden) {
        return;
    }
    CGSize size = self.frame.size;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / horizontalItemWidth;
        float remainder = location.x - intValue * horizontalItemWidth;
        
        int index = intValue + (remainder >= horizontalItemWidth * 0.5f ? 1 : 0);
        if (index < self.valueItemArray.count)
        {
            float value = [(NSNumber *)self.valueItemArray[index] floatValue];
            CGPoint point = [self valuePoint:value atIndex:index];
            
            if ([self.dataSource respondsToSelector:@selector(chartView:descriptionViewAtIndex:)])
            {
                UIView *tmpDescriptionView = [self.dataSource chartView:self descriptionViewAtIndex:index];
                CGRect frame = tmpDescriptionView.frame;
                if (point.x + frame.size.width > size.width)
                {
                    frame.origin.x = point.x - frame.size.width/2 + 2;
                    
                }
                else
                { frame.origin.x = point.x - frame.size.width/2 + 2;
                   // frame.origin.x = point.x-frame.size.width/2;
                }
                
                if (frame.size.height + point.y > size.height)
                {
                    frame.origin.y = point.y - frame.size.height-8.0;
                }
                else
                {   frame.origin.y = point.y - frame.size.height-8.0;
                   // frame.origin.y = point.y;
                }
                
                tmpDescriptionView.frame = frame;
                
                if (self.descriptionView){
                [self.descriptionView removeFromSuperview];
                }
                
                //滑动时候，移动的那条线
                if (!self.slideLineView)
                {
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake
                                         (0.0f,
                                          0,
                                          1.0f,
                                          HIGH)
                                         ] ;

                    lineView.backgroundColor = [UIColor clearColor];
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                }
                
                //draw line
                CGRect slideLineViewFrame = self.slideLineView.frame;
              
                slideLineViewFrame.origin.x = point.x;
                slideLineViewFrame.origin.y=point.y;
                slideLineViewFrame.size.height=self.frame.size.height-point.y-HIGH;

                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:tmpDescriptionView];
                self.descriptionView = tmpDescriptionView;
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)])
                {
                    [self.delegate chartView:self didMovedToIndex:index];
                }
            }
        }
    }
}

- (void)reloadData
{
    isLoaded = NO;
    [self.valueItemArray removeAllObjects];
    horizontalItemWidth = .0f;
    verticalItemHeight = .0f;
    maxVerticalValue = .0f;
    if (self.descriptionView)   [self.descriptionView removeFromSuperview];
    if (self.slideLineView)   self.slideLineView.hidden = YES;
    [self setNeedsDisplay];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.valueItemArray || !self.valueItemArray.count || !self.dataSource) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)   [self.descriptionView removeFromSuperview];
}

@end

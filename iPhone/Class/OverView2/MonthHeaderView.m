//
//  MonthHeaderView.m
//  MSCal
//
//  Created by wangdong on 11/1/13.
//  Copyright (c) 2013 dongdong.wang. All rights reserved.
//

#import "MonthHeaderView.h"

extern CGFloat headerHeight_WD;
@implementation MonthHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addHeaderView];
    }
    return self;
}

-(void) addHeaderView
{
    /*
    
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    NSUInteger firstWeekday = [[NSCalendar timezoneCalendar] firstWeekday];
    NSUInteger i = firstWeekday - 1;
    
    int index = 1000;
    float _width = tileWidth_WD;
    for (CGFloat xOffset = 0.f; xOffset < self.width; xOffset += _width, i = (i+1)%7)
    {
        CGRect weekdayFrame = CGRectMake(xOffset, 0, _width, headerHeight_WD);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.tag = index;
        index ++;
        
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11.0f];
        weekdayLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [self addSubview:weekdayLabel];
    }
     */
}

- (void)redrawHeaderViewWhenFirstweekdayChanged
{
    /*
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    NSUInteger firstWeekday = [[NSCalendar timezoneCalendar] firstWeekday];
    NSUInteger j = firstWeekday - 1;
    
    for (int i = 1000; i<1007; i++, j = (j+1)%7)
    {
        UILabel *label = (UILabel *)[self viewWithTag:i];
        label.text = [weekdayNames objectAtIndex:j];
    }
     */
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    self.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 0.5);
//    CGContextSetAllowsAntialiasing(context, false);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0].CGColor);
//    CGContextMoveToPoint(context, 0, rect.size.height-0.25);
//    CGContextAddLineToPoint(context, self.width,rect.size.height-0.25);
//    CGContextStrokePath(context);
//}


@end

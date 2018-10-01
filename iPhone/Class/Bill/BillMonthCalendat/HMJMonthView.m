//
//  HMJMonthView.m
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import "HMJMonthView.h"
#import "HMJMonthLogic.h"
#import "HMJMonthGridView.h"

@implementation HMJMonthView
@synthesize gridView,logic,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame delegate:(id<HMJMonthViewDelegate>)theDelegate logic:(HMJMonthLogic *)theLogic withShowModule:(BOOL)m
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        
        delegate = theDelegate;
        logic = theLogic;
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
//        self.autoresizesSubviews = YES;
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        gridView = [[HMJMonthGridView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,48) logic:logic delegate:delegate];
        gridView.backgroundColor = [UIColor clearColor];
        [self addSubview:gridView];
    }
    return self;
}


- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }
-(void)slideNone{
    [gridView slideNone];
}


- (void)showPrevious5Month
{
    if (!gridView.transitioning)
        [delegate showPrevious5Month];
}

- (void)showFollowing5Month
{
    if (!gridView.transitioning)
        [delegate showFollowing5Month];
}


-(void)setNeedsDisplay
{
    [self.gridView setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//-(void)dealloc{
//    [gridView release];
//    
//    [super dealloc];
//}

@end

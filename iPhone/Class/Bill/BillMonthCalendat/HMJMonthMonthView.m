//
//  HMJMonthMonthView.m
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import "HMJMonthMonthView.h"
#import "HMJMonthGridView.h"
#import "HMJMonthTileView.h"

extern const CGSize  hmjTileSize;

@implementation HMJMonthMonthView

- (id)initWithFrame:(CGRect)frame
{
    double with = SCREEN_WIDTH/5.0;
    
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<5; i++) {
            CGRect r = CGRectMake(i*
                                  with, 0, with, hmjTileSize.height);
            HMJMonthTileView *tmpTile =[[HMJMonthTileView alloc] initWithFrame:r] ;
            tmpTile.tag = i;
            [self addSubview:tmpTile];
        }
    }
    
    return self;

}


- (void)showDates:(NSArray *)mainDates
{
    for (HMJMonthTileView *tile in self.subviews)
    {
        [tile resetState];
    }
    
    int i=0;
    for (HMJMonthTileView *tile in self.subviews) {
        tile.date = [mainDates objectAtIndex:i];
        i++;

    }

 	[self sizeToFit];
	[self setNeedsDisplay];
}

- (HMJMonthTileView *)tileForDate:(KalDate_bill_iPhone *)date
{
    HMJMonthTileView *tile = nil;
    for (HMJMonthTileView *t in self.subviews) {
        if ([t.date isEqual:date]) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (HMJMonthTileView *)mediumTileOf5Month
{
    HMJMonthTileView *tile = nil;
    for (HMJMonthTileView *t in self.subviews) {
        if (t.frame.origin.x > 120) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

-(void)setNeedsDisplay
{
    for (HMJMonthTileView *t in self.subviews) {
        [t setNeedsDisplay];
        }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

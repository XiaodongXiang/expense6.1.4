//
//  HMJMonthGridView.m
//  KalMonth
//
//  Created by humingjing on 14-4-7.
//  Copyright (c) 2014年 APPXY_DEV. All rights reserved.
//

#import "HMJMonthGridView.h"
#import "HMJMonthMonthView.h"
#import "HMJMonthLogic.h"
#import "HMJMonthTileView.h"
#import "UIViewAdditions_bill_iPhone.h"

#import "HMJMonthView.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "BillsViewController.h"
#import "KalDate_bill_iPhone.h"

//with不能是0，不然不会刷新
CGSize hmjTileSize = { 64.f, 48.f };

extern  CGSize hmjTileSize;
#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

@implementation HMJMonthGridView
@synthesize logic,frontMonthView,backMonthView,selectedTile,transitioning,isTouch;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame logic:(HMJMonthLogic *)theLogic delegate:(id<HMJMonthViewDelegate>)theDelegate{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //添加手势，横滑手势
        UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toRight:)];
        swipRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipRight];
        
        UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toLeft:)];
        
        swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipLeft];
        
        //初始化页面
        self.clipsToBounds = YES;
        logic = theLogic ;
        delegate = theDelegate;
        CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        
        frontMonthView = [[HMJMonthMonthView alloc] initWithFrame:monthRect];
        backMonthView = [[HMJMonthMonthView alloc] initWithFrame:monthRect];
        backMonthView.hidden = YES;
        frontMonthView.backgroundColor = [UIColor clearColor];
        backMonthView.backgroundColor = [UIColor clearColor];
        [self addSubview:backMonthView];
        [self addSubview:frontMonthView];
        
        [self jumpToSelectedMonth];
        //    [self selectTodayIfVisible];
	}
	return self;
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }
-(void)slideNone{
    [self slide:SLIDE_NONE];
}

- (void)jumpToSelectedMonth
{
    [self slide:SLIDE_NONE];
}



- (void)slide:(int)direction
{
    transitioning = YES;
    
    [backMonthView showDates:logic.monthesInSelectedMonthGroup];
    
    // At this point, the calendar logic has already been advanced or retreated to the
    // following/previous month, so in order to determine whether there are
    // any cells to keep, we need to check for a partial week in the month
    // that is sliding offscreen.
    
    [self swapMonthsAndSlide:direction keepOneRow:NO];
    
    self.selectedTile = [frontMonthView mediumTileOf5Month];
}

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.left = frontMonthView.right;
    } else if (direction == SLIDE_DOWN) {
        backMonthView.left = -frontMonthView.right;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.left = -backMonthView.left;
        
        backMonthView.left = 0.f;

        [self swapMonthViews];
    }
    [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    transitioning = NO;
    backMonthView.hidden = YES;
}

- (void)swapMonthViews
{
    HMJMonthMonthView *tmp = backMonthView;
	backMonthView = frontMonthView;
	frontMonthView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

#pragma mark UIGuesture Mehod
-(void)toRight:(UISwipeGestureRecognizer *)guester{
    [delegate showPrevious5Month];
}
-(void)toLeft:(UISwipeGestureRecognizer *)guester{
    [delegate showFollowing5Month];
}


#pragma mark Touches
- (void)setSelectedTile:(HMJMonthTileView *)tile
{
    
    if (selectedTile != tile&&tile.date!=nil)
    {
        selectedTile.selected = NO;
        selectedTile = tile ;
        tile.selected = YES;
    }
    
    [delegate didSelectMonth:tile.date];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if ([hitView isKindOfClass:[HMJMonthTileView class]]) {
        HMJMonthTileView *tile = (HMJMonthTileView*)hitView;
        
        self.selectedTile = tile;

    }
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *VCArray=appDelegate.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    NSDate *tmpdate = [self.selectedTile.date NSDate];
    tmpBillsViewController.bvc_MonthStartDate = tmpdate;
    
//    tmpBillsViewController.bvc_MonthStartDate = [self.selectedTile.date NSDate];
    tmpBillsViewController.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:tmpBillsViewController.bvc_MonthStartDate];
    //显示当前的那个月的交易
    [tmpBillsViewController  getCurrentMonthBillArrayandReloadDayKalView];
}

-(void)setNeedsDisplay
{
    [frontMonthView setNeedsDisplay];
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

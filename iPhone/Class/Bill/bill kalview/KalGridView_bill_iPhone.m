/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView_bill_iPhone.h"
#import "KalView_bill_iPhone.h"
#import "KalMonthView_bill_iPhone.h"
#import "KalTileView_bill_iPhone.h"
#import "KalLogic_bill_iPhone.h"
#import "KalDate_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"

#import "BillsViewController.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "BillsViewController.h"


#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2




extern  CGSize kTileSize_iPad;

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView_bill_iPhone ()
- (void)selectTodayIfVisible;
- (void)swapMonthViews;
@end

@implementation KalGridView_bill_iPhone

@synthesize selectedTile, highlightedTile, transitioning,isIpadShow,isTouch;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic_bill_iPhone *)theLogic delegate:(id<KalViewDelegate_bill_iPhone>)theDelegate withShowModule:(BOOL)m
{
    if (self = [super initWithFrame:frame]) {

    
    //初始化页面
    self.clipsToBounds = YES;
    logic = theLogic;
    delegate = theDelegate;
    CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
    
    frontMonthView = [[KalMonthView_bill_iPhone alloc] initWithFrame:monthRect withShowStatus:isIpadShow];
    backMonthView = [[KalMonthView_bill_iPhone alloc] initWithFrame:monthRect withShowStatus:isIpadShow];
    backMonthView.hidden = YES;
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];
    
    [self jumpToSelectedMonth];
//    [self selectTodayIfVisible];
	}
	return self;
}

 
- (void)sizeToFit
{
  self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView_bill_iPhone *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = tile ;
    tile.highlighted = YES;
    [tile setNeedsDisplay];
  }
}

- (void)setSelectedTile:(KalTileView_bill_iPhone *)tile
{
    
  if (selectedTile != tile&&tile.date!=nil) 
  {
    
    selectedTile.selected = NO;
    selectedTile = tile ;
    tile.selected = YES;
      
      [delegate didSelectDate:tile.date];

  }
    
//    if(!isIpadShow)
//        [delegate didSelectDate:tile.date];
//    else {
//        [delegate didSelectDate:tile.date showPanel:TRUE withFrame:tile.frame];
    
//    }
//    isTouch = FALSE;

}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if (!hitView)
    return;
  
  if ([hitView isKindOfClass:[KalTileView_bill_iPhone class]])
  {
    KalTileView_bill_iPhone *tile = (KalTileView_bill_iPhone*)hitView;
      isTouch = TRUE;
    if (tile.belongsToAdjacentMonth) 
	{
 //     self.highlightedTile = tile;
    } else
    {
      self.highlightedTile = nil;
      self.selectedTile = tile;
    }
  }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//  [self receivedTouches:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//  [self receivedTouches:touches withEvent:event];
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if ([hitView isKindOfClass:[KalTileView_bill_iPhone class]]) {
    KalTileView_bill_iPhone *tile = (KalTileView_bill_iPhone*)hitView;
     // isTouch = TRUE;

    if (tile.belongsToAdjacentMonth) 
    {
        ;
    } else {
        logic.baseDate = [tile.date NSDate];
      self.selectedTile = tile;
    }
  }
  self.highlightedTile = nil;
}

#pragma mark UIGuesture Mehod
-(void)toRight:(UISwipeGestureRecognizer *)guester{
    [delegate showPreviousMonth];
}
-(void)toLeft:(UISwipeGestureRecognizer *)guester{
    [delegate showFollowingMonth];
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP)
    {
        backMonthView.left = frontMonthView.right;
    }
    else if (direction == SLIDE_DOWN)
    {
        backMonthView.left = -frontMonthView.right;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.left = -backMonthView.left;
        
        backMonthView.left = 0.f;
        
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];

}

- (void)slide:(int)direction
{
  transitioning = YES;
  
  [backMonthView showDates:logic.daysInSelectedMonth
      leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
     trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
  
  // At this point, the calendar logic has already been advanced or retreated to the
  // following/previous month, so in order to determine whether there are 
  // any cells to keep, we need to check for a partial week in the month
  // that is sliding offscreen.
  
  BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
                    || (direction == SLIDE_DOWN  && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
  
  [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
  
  self.selectedTile = [frontMonthView firstTileOfMonth];
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }
-(void)slideNone{
    [self slide:SLIDE_NONE];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  transitioning = NO;
  backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectTodayIfVisible
{
  KalTileView_bill_iPhone *todayTile = [frontMonthView todaysTileIfVisible];
  if (todayTile)
    self.selectedTile = todayTile;
}

- (void)swapMonthViews
{
  KalMonthView_bill_iPhone *tmp = backMonthView;
	backMonthView = frontMonthView;
	frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE];
}

- (void)paidmarkTilesForDates:(NSArray *)dates  withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
    [frontMonthView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran];
}
- (void)unpaidmarkTilesForDates { [frontMonthView unpaidmarkTilesForDates]; }

- (KalDate_bill_iPhone *)selectedDate { return selectedTile.date; }

#pragma mark -

//- (void)dealloc
//{
//  [selectedTile release];
//  [highlightedTile release];
//  [frontMonthView release];
//  [backMonthView release];
//  [logic release];
//  [super dealloc];
//}

@end

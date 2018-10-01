/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "AppDelegate_iPad.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

const CGSize kTileSize_iPad = { 54,54};
CGSize kTileSize_Bill_iPad = {54,54};


static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()
@property (nonatomic, retain) KalTileView *selectedTile;
@property (nonatomic, retain) KalTileView *highlightedTile;
@property (nonatomic,assign) BOOL isFrontMonthViewPackUp;
- (void)swapMonthViews;
@end

@implementation KalGridView

@synthesize selectedTile, highlightedTile, transitioning;
@synthesize kalTableView;
@synthesize isFrontMonthViewPackUp;
@synthesize isTouch;
@synthesize isBillShow;
- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate
{
  if (self = [super initWithFrame:frame])
  {
    self.clipsToBounds = YES;
    logic = theLogic ;
    delegate = theDelegate;
    
    CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
    frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
    backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
    backMonthView.hidden = YES;
      
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];

    [self jumpToSelectedMonth];
      self.backgroundColor=[UIColor whiteColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
 // [[UIImage imageNamed:@"Kal.bundle/kal_grid_background.png"] drawInRect:rect];
  //[[UIColor colorWithRed:0.63f green:0.65f blue:0.68f alpha:1.f] setFill];
    [[UIColor whiteColor]setFill];
  CGRect line;
  line.origin = CGPointMake(0.f, self.height - 1.f);
  line.size = CGSizeMake(self.width, 1.f);
  CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

- (void)sizeToFit
{
  self.height = frontMonthView.height;
}
#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = tile ;
    tile.highlighted = YES;
    [tile setNeedsDisplay];
  }
}
 
- (void)setSelectedTile:(KalTileView *)tile
{
    AppDelegate_iPad *appDelegate_iPad = ( AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
  if (selectedTile != tile)
  {
    selectedTile.selected = NO;
    selectedTile = tile ;
    tile.selected = YES;
      
      if (appDelegate_iPad.mainViewController.currentViewSelect==0)
      {
          [delegate didSelectDate:tile.date];

      }
      
  }
    
    if (appDelegate_iPad.mainViewController.currentViewSelect!=0)
    {
        [delegate didSelectDate:tile.date withFram:tile.frame];
        
    }

}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if (!hitView)
    return;
  
  if ([hitView isKindOfClass:[KalTileView class]])
  {
    KalTileView *tile = (KalTileView*)hitView;
      
    isTouch = TRUE;
    if (tile.belongsToAdjacentMonth)
    {
      self.highlightedTile = tile;
    }
    else
    {
        self.highlightedTile = nil;
        self.selectedTile = tile;
    }
  }
}

-(void)monthViewPackOff
{
    if (isFrontMonthViewPackUp)
    {
        [UIView beginAnimations:kSlideAnimationId context:NULL];
      
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];//animationDidStop:finished:context:)];
        frontMonthView.top =0;
        kalTableView.frame=CGRectMake(0, frontMonthView.frame.size.height, kalTableView.frame.size.width, kalTableView.frame.size.height);
        kalTableView.alpha=0;
        [UIView commitAnimations];
        [UIView setAnimationsEnabled:YES];
        isFrontMonthViewPackUp=NO;
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}
-(void)animationMoveTo:(NSInteger )index
{  if(isFrontMonthViewPackUp==NO){
    [UIView beginAnimations:kSlideAnimationId context:NULL];
   // {
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    kalTableView.alpha=1;
        frontMonthView.top = frontMonthView.top-index*107;
        kalTableView.frame=CGRectMake(kalTableView.frame.origin.x, 107.543, kalTableView.frame.size.width, 595);
           //}
    [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
    isFrontMonthViewPackUp=YES;
}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if ([hitView isKindOfClass:[KalTileView class]])
  {
    KalTileView *tile = (KalTileView*)hitView;
      
      //标识 人为点击
      AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
      appDelegate.mainViewController.iBillsViewController.needShowSelectedDateBillViewController = YES;
      
    if (tile.belongsToAdjacentMonth)
    {
        if ([tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending)
        {
            [delegate showFollowingMonth];
        }
        else
        {
            [delegate showPreviousMonth];
        }
        self.selectedTile = [frontMonthView tileForDate:tile.date];
    }
    else
    {
        logic.baseDate = [tile.date NSDate];
        self.selectedTile = tile;
    }
  }
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    AppDelegate_iPad *appDelegaet_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        if (appDelegaet_iPhone.mainViewController.currentViewSelect==0) {
            backMonthView.top = keepOneRow
            ? frontMonthView.bottom - kTileSize_iPad.height
            : frontMonthView.bottom;
        }
        else
            backMonthView.top = keepOneRow
            ? frontMonthView.bottom - kTileSize_Bill_iPad.height
            : frontMonthView.bottom;
        
    } else if (direction == SLIDE_DOWN) {
        NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
        NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
        if (appDelegaet_iPhone.mainViewController.currentViewSelect==0) {
            backMonthView.top = -numWeeksToSlide * kTileSize_iPad.height;

        }
        else
            backMonthView.top = -numWeeksToSlide * kTileSize_Bill_iPad.height;
    } else {
        backMonthView.top = 0.f;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL];
    {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.top = -backMonthView.top;
        backMonthView.top = 0.f;
        
        frontMonthView.alpha = 0.f;
        backMonthView.alpha = 1.f;
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    }
    [UIView commitAnimations];
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
                 || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
  
  [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
  
    
    if (direction == SLIDE_NONE)
    {
        //5.3.2
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        KalTileView *firstTile = (KalTileView *)[frontMonthView firstTileOfMonth];
        NSDate *startDate = [firstTile.date NSDate];
        NSDate *lastDate = [appDelegate.epnc getMonthEndDate:startDate];
        if ([appDelegate.epnc dateCompare:[NSDate date] withDate:startDate]>=0 && [appDelegate.epnc dateCompare:[NSDate date] withDate:lastDate]<=0)
             
        {
            self.selectedTile = [frontMonthView  tileForDate:[KalDate dateFromNSDate:[NSDate date]]];
        }
        else
             self.selectedTile = [frontMonthView firstTileOfMonth];


    }
    else
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

- (void)selectDate:(KalDate *)date
{
  self.selectedTile = [frontMonthView tileForDate:date];
}

- (void)swapMonthViews
{
  KalMonthView *tmp = backMonthView;
    
  backMonthView = frontMonthView;
  frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
    
  [self slide:SLIDE_NONE];
}
- (void)paidmarkTilesForDates:(NSArray *)dates  withDates1:(NSArray *)dates1 isTran:(BOOL)isTran{ [frontMonthView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran]; }
- (void)unpaidmarkTilesForDates { [frontMonthView unpaidmarkTilesForDates]; }

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return selectedTile.date; }



@end

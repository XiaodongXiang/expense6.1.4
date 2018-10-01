/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "OverViewMonthViewController.h"
#import "KalViewController_week.h"

#import "KalGridView_week.h"
#import "KalView_week.h"
#import "KalMonthView_week.h"
#import "KalTileView_week.h"
#import "KalLogic_week.h"
#import "KalDate_week.h"
#import "KalPrivate_week.h"
#import "NSDateAdditions.h"

#import "OverViewMonthViewController.h"


#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2
#define SLIDE_FROM_MONTH_TO_WEEK 3
#define SLIDE_FROM_WEEK_TO_MONTH 4

CGSize kTileSize_main = {0,53.f};

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView_week ()
@property (nonatomic, strong) KalTileView_week *highlightedTile;
- (void)swapMonthViews;
@end

@implementation KalGridView_week

@synthesize selectedTile, highlightedTile, transitioning;
@synthesize frontMonthView,backMonthView;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic_week *)theLogic delegate:(id<KalViewDelegate_week>)theDelegate
{


  if (self = [super initWithFrame:frame])
  {
      
      //添加手势，横滑手势
      UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toRight:)];
      swipRight.direction = UISwipeGestureRecognizerDirectionRight;
      [self addGestureRecognizer:swipRight];
      
      UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toLeft:)];
      
      swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      [self addGestureRecognizer:swipLeft];
      
      
    self.clipsToBounds = YES;
    logic = theLogic ;
    delegate = theDelegate;
    CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
    frontMonthView = [[KalMonthView_week alloc] initWithFrame:monthRect];
    backMonthView = [[KalMonthView_week alloc] initWithFrame:monthRect];
    backMonthView.hidden = NO;
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];

    [self jumpToSelectedMonth];
  }
  return self;
}




#pragma mark Touches

- (void)setHighlightedTile:(KalTileView_week *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = tile ;
    tile.highlighted = YES;
    [tile setNeedsDisplay];
  }
}

- (void)setSelectedTile:(KalTileView_week *)tile
{
    //edit tile before and tile new
  if (selectedTile != tile)
  {
      selectedTile.selected = NO;
      selectedTile = tile ;
      tile.selected = YES;
      [delegate didSelectDate:tile.date];
      
      AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
      [appDelegate_iPhone.overViewController performSelector:@selector(createAddBtn) withObject:nil];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if ([hitView isKindOfClass:[KalTileView_week class]]) {
      
    KalTileView_week *tile = (KalTileView_week*)hitView;
      
      AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
      //选择日期与滑动日历都会发送一个通知
      [[NSNotificationCenter defaultCenter]postNotificationName:@"swipIndex" object:nil];
      [appDelegate.overViewController resetAllDate];

      if (tile.belongsToAdjacentMonth) {
          return;
      }
      else
      {
          appDelegate.overViewController.kalViewController.kalView.tableView.hidden = NO;
          
          
          //新加的一句
          self.selectedTile = tile;
          
          // 填上这一句会导致回到星期的时候起始时间不正确
          // logic.baseDate = [tile.date NSDate];
//          logic.baseDate = [[self.selectedTile.date NSDate] cc_dateByMovingToFirstDayOfTheWeek];
          appDelegate.overViewController.kalViewController.logic.baseDate = [[self.selectedTile.date NSDate] cc_dateByMovingToFirstDayOfTheWeek];
         if (logic.calenderDisplayMode == CalendarViewModeMonth)
         {
             //先把界面中的周显示出来，然后设置选中的那一天，然后跳到那个页面开始刷新数据
             [appDelegate.overViewController.kalViewController showCurrentMonth];
             [appDelegate.overViewController.kalViewController.kalView selectDate:[KalDate_week dateFromNSDate:[selectedTile.date NSDate]]];
         }
          if (logic.calenderDisplayMode == CalendarViewModeMonth)
          {
              //因为需要由monthviewcontroller返回的时候，weekviewcontroll中的monthviewcontroller已经为nil了，就需要一个通知来让monthviewcontroller返回
              [[NSNotificationCenter defaultCenter]postNotificationName:@"monthviewpop" object:nil];
              
          }
          else
          {
              NSDateFormatter *weekFormatter = [[NSDateFormatter alloc]init];
              [weekFormatter setDateFormat:@"EEEE"];
              
              NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
              [dayFormatter setDateFormat:@"dd"];
              
              
//              NSString *tmpWeekString = [[weekFormatter stringFromDate:[self.selectedDate NSDate]] uppercaseString];
//              NSString *dayString = [dayFormatter stringFromDate:[self.selectedDate NSDate]];
//              NSString *finalString =[ NSString stringWithFormat:@"%@ %@",tmpWeekString,dayString];
         
              
              appDelegate.overViewController.monthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[self.selectedDate NSDate]];
              appDelegate.overViewController.monthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:appDelegate.overViewController.monthStartDate];
          }
      }

      
  }
    
    
  self.highlightedTile = nil;
}


#pragma mark Guester Action
-(void)toRight:(UISwipeGestureRecognizer *)guester{
    [delegate showPreviousMonth];
}
-(void)toLeft:(UISwipeGestureRecognizer *)guester{
    [delegate showFollowingMonth];
}

#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.left = frontMonthView.right;
        backMonthView.top=0.f;
    }
    else if (direction == SLIDE_DOWN) {
        backMonthView.left = -frontMonthView.right;
        backMonthView.top=0.f;
    }
    else if (direction==SLIDE_FROM_MONTH_TO_WEEK){
        backMonthView.top  = 0.f;

        backMonthView.left = 0.f;
        frontMonthView.top = 0.f;
        frontMonthView.left= 0.f;
        
    }
    else{
        backMonthView.top  = 0.f;
        backMonthView.left = 0.f;
        frontMonthView.top = 0.f;
        frontMonthView.left= 0.f;
    }
    
    // trigger the slide animation
    //转换月-->周
    if (direction == SLIDE_FROM_MONTH_TO_WEEK) {
        [UIView beginAnimations:kSlideAnimationId context:NULL]; {
            [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            
            frontMonthView.left =0;
            
            backMonthView.left = 0.f;
            
            
            self.height = backMonthView.height;
            
            [self swapMonthViews];
        } [UIView commitAnimations];
        [UIView setAnimationsEnabled:YES];
        
    }
    else if (direction==SLIDE_FROM_WEEK_TO_MONTH){
        [UIView beginAnimations:kSlideAnimationId context:NULL]; {
            [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            
            frontMonthView.left = 0;
            
            backMonthView.left = 0.f;
            
            
            self.height = backMonthView.height;
            
            [self swapMonthViews];
        } [UIView commitAnimations];
        [UIView setAnimationsEnabled:YES];
        


    }
    else{
        [UIView beginAnimations:kSlideAnimationId context:NULL]; {
            [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            
            frontMonthView.left = -backMonthView.left;
            
            backMonthView.left = 0.f;
            
            
            self.height = backMonthView.height;
            
            [self swapMonthViews];
        }
        [UIView commitAnimations];
        [UIView setAnimationsEnabled:YES];
    }
    
    
}
-(void)monthToWeekAnimationFinished{
    frontMonthView.top=0.f;
    frontMonthView.height = kTileSize_main.height;
    //改变frontView的大小之后，更换frontView与backgroundView的层次
//    [self swapMonthViews];
}

- (void)slide:(int)direction
{
  transitioning = YES;
  
    //在这里更新数据的
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

    if (logic.calenderDisplayMode == 1) {
        self.selectedTile = [frontMonthView firstTileOfMonth];
    }
}

//点击一个日期，将月份转换成周
-(void)slideInThisMonth:(int)direction{
    transitioning = YES;
//    [frontMonthView showDates:logic.daysInSelectedMonth
//leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
//trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
//    [frontMonthView sizeToFit];
    
    [backMonthView showDates:logic.daysInSelectedMonth
        leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
       trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
    [backMonthView sizeToFit];
    BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
    || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0)
    ;
    [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
//    self.selectedTile = [frontMonthView firstTileOfMonth];
}


- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }
-(void)slideInThisMonth{
    
    if (logic.calenderDisplayMode==0 && self.frame.size.height <= kTileSize_main.height) {
        [self slideInThisMonth:SLIDE_FROM_WEEK_TO_MONTH];
    }
    else if (logic.calenderDisplayMode==1)
        [self slideInThisMonth:SLIDE_FROM_MONTH_TO_WEEK];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  transitioning = NO;
  backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectDate:(KalDate_week *)date
{
  self.selectedTile = [frontMonthView tileForDate:date];
}

- (void)swapMonthViews
{
  KalMonthView_week *tmp = backMonthView;
  backMonthView = frontMonthView;
  frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE];
}

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }

- (KalDate_week *)selectedDate { return selectedTile.date; }




#pragma mark ChangeMonthViewtoWeekView
-(void)changeMonthViewToWeekView{
    [delegate showCurrentMonth];
    [frontMonthView sizeToFit];
    [backMonthView sizeToFit];
}

#pragma mark Week Calender Methed
- (void)paidmarkTilesForDates:(NSArray *)dates  withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{ [frontMonthView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran];
}



@end

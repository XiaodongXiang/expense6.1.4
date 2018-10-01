/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView_bill_iPhone.h"
#import "KalGridView_bill_iPhone.h"
#import "KalLogic_bill_iPhone.h"
#import "KalPrivate_bill_iPhone.h"
#import "PokcetExpenseAppDelegate.h"

@interface KalView_bill_iPhone ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

//static const CGFloat kHeaderHeight = 68.f;
static  CGFloat kHeaderHeight = 22.f;

//static const CGFloat kMonthLabelHeight = 18.f;

@implementation KalView_bill_iPhone
@synthesize delegate, tableView,isIpadShow,selectedDate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_bill_iPhone>)theDelegate logic:(KalLogic_bill_iPhone *)theLogic withShowModule:(BOOL)m
{
  if ((self = [super initWithFrame:frame])) 
  {
      self.backgroundColor = [UIColor whiteColor];
      self.clipsToBounds = YES;
      
	  isIpadShow = m;
	  if(isIpadShow)
      {
          kHeaderHeight=30.f;
      }

    delegate = theDelegate;
    logic = theLogic ;
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
   self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] ;
    [self addSubviewsToHeaderView:_headerView];
      _headerView.backgroundColor = [UIColor colorWithRed:123/255.0 green:213/255.0 blue:255/255.0 alpha:1];
    [self addSubview:_headerView];
      
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] ;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      contentView.backgroundColor = [UIColor clearColor];
      contentView.frame = CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight);
      contentView.backgroundColor = [UIColor clearColor];
      contentView.clipsToBounds = YES;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }
-(void)slideNone{
    [gridView slideNone];
}

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
	// Add column labels for each weekday (adjusting based on the current locale's first weekday)
	NSArray *weekdayNames = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
    
//    int firstWeekday = 1;
//    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
//    if ([defaults2 integerForKey:@"CalendarDateStly"])
//    {
//        firstWeekday = [defaults2 integerForKey:@"CalendarDateStly"];
//    }
//    //设置标题
//    NSUInteger i = firstWeekday-1;
    
    
    //设置星期
    int firstWeekday = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekday = 2;
    }
    //设置标题
    NSUInteger i = firstWeekday-1;

    
    
    double tmpOffset = SCREEN_WIDTH/7.0;
	double labelH = 0.f;
	
	if(isIpadShow)
	{
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_week_601_22.png"]];
             titleView.frame = CGRectMake(3.0, 8, 603, 22);
        [headerView addSubview:titleView];
		tmpOffset =85.f;
		labelH = 32.f;
		for (CGFloat xOffset = 2.f; xOffset < 595.f; xOffset += tmpOffset, i = (i+1)%7) 
		{
			CGRect weekdayFrame = CGRectMake(xOffset, 3.0, tmpOffset, labelH);
			UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
			weekdayLabel.backgroundColor = [UIColor clearColor];
		 		weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.f];
				weekdayLabel.textColor =[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.f];
		 	weekdayLabel.textAlignment = NSTextAlignmentCenter;
			weekdayLabel.text = [weekdayNames objectAtIndex:i];
			[headerView addSubview:weekdayLabel];
		}
		
	}
    //iPhone界面
	else {
//        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"week_bg_320_22.png"]];
//        titleView.frame = CGRectMake(0.0, 0, SCREEN_WIDTH,22);
//        [headerView addSubview:titleView];

		labelH = 22.f;
        
        NSArray *weekdayNames1 = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
        //  NSArray *fullWeekdayNames1 = [[[[NSDateFormatter alloc] init] autorelease] standaloneWeekdaySymbols];
        NSMutableArray *weekdayNames = [[NSMutableArray alloc]init];
        for (int i=0; i<7; i++) {
            NSString *str = [weekdayNames1 objectAtIndex:i];
            NSString *strUPPER = [str uppercaseString];
            [weekdayNames addObject:strUPPER];
        }
        

		for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += tmpOffset, i = (i+1)%7) 
		{
			CGRect weekdayFrame = CGRectMake(xOffset, 0.0, tmpOffset, labelH);
			UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
			weekdayLabel.backgroundColor = [UIColor clearColor];
			 		weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
			weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.textColor =[UIColor whiteColor];

			weekdayLabel.text = [weekdayNames objectAtIndex:i];
			[headerView addSubview:weekdayLabel];
		}
	}
	
}

- (void)addSubviewsToContentView:(UIView *)contentView
{

    
    
	CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
	if( isIpadShow)
	{
		fullWidthAutomaticLayoutFrame = CGRectMake((self.width-85.0*7.0 )/2, 0.f, 85.0*7.0 , 0.f);
	}
	// The tile grid (the calendar body)
	gridView = [[KalGridView_bill_iPhone alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate withShowModule:isIpadShow ];
	[gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
	[contentView addSubview:gridView];
    
    tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = YES;
    [contentView addSubview:tableView];
	
	if( isIpadShow)
	{
		gridView.backgroundColor = [UIColor clearColor];
        //添加三条线
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(3, 0, 1, 431)];
        leftLine.backgroundColor = [UIColor colorWithRed:193.f/255.f green:193.f/255.f blue:193.f/255.f alpha:1];
        [contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(605, 0, 1, 431)];
        rightLine.backgroundColor = [UIColor colorWithRed:193.f/255.f green:193.f/255.f blue:193.f/255.f alpha:1];
        [contentView addSubview:rightLine];
        
        UIView *bottomLine =[[UIView alloc]initWithFrame:CGRectMake(4, 431, 602, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:193.f/255.f green:193.f/255.f blue:193.f/255.f alpha:1];
        [contentView addSubview:bottomLine];
	}

	[gridView sizeToFit];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
  if (object == gridView && [keyPath isEqualToString:@"frame"]) 
  {

     CGFloat gridBottom = gridView.top + gridView.height;
      CGRect frame = tableView.frame;
      frame.origin.y = gridBottom;
      
//      if(gridView.superview.height >= gridBottom)
          frame.size.height = gridView.superview.height - gridBottom;
//      else
//          frame.size.height = 0;

	  if( isIpadShow)
	  {
	      shadowView.top = gridBottom+20.0;

	  }
	  else {
		  shadowView.top = gridBottom;

	  }
      
      tableView.frame = frame;

    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else 
  {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectTodayIfVisible { [gridView selectTodayIfVisible]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
    [gridView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran];
}
- (void)unpaidmarkTilesForDates { [gridView unpaidmarkTilesForDates]; }

- (KalDate_bill_iPhone *)selectedDate { return gridView.selectedDate; }

//- (void)dealloc
//{
//  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
//  [logic release];
//  
//  [headerTitleLabel release];
//  [gridView removeObserver:self forKeyPath:@"frame"];
//  [gridView release];
//  //[tableView release];
//  [shadowView release];
//  [super dealloc];
//}

@end

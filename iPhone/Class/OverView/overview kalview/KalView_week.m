/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView_week.h"
#import "KalGridView_week.h"
#import "KalLogic_week.h"
#import "KalPrivate_week.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "KalDate_week.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface KalView_week ()
//- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end


@implementation KalView_week

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_week>)theDelegate logic:(KalLogic_week *)theLogic
{
  if ((self = [super initWithFrame:frame])) {
    _delegate = theDelegate;
    logic = theLogic;
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
      UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, frame.size.width, frame.size.height)];
      contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
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

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [_gridView slideDown]; }
- (void)slideUp { [_gridView slideUp]; }
-(void)slideinThisMonth{
    [_gridView  slideInThisMonth];
}

- (void)showPreviousMonth
{
  if (!_gridView.transitioning)
    [_delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!_gridView.transitioning)
    [_delegate showFollowingMonth];
}

-(void)showCurrentMonth{
    [_delegate showCurrentMonth];
}


- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
    
    double tileHigh = 0;

    if (IS_IPHONE_5)
    {
        tileHigh=375/7;
    }
    else
    {
        tileHigh = SCREEN_WIDTH/7;
    }

  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, tileHigh);

  // The tile grid (the calendar body)
  _gridView = [[KalGridView_week alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:_delegate];
  [_gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:_gridView];
   
    


    if (logic.calenderDisplayMode==1)
    {
        _tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = YES;
        [contentView addSubview:_tableView];
    }
    else
    {
        _balanceView = [[UIView alloc]init];
        _balanceView.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [contentView addSubview:_balanceView];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
        bgImageView.image = [UIImage imageNamed:[NSString customImageName:@"bg_320_65.png"]];
        [_balanceView addSubview:bgImageView];
        
        //text
        NSLog(@"with:%f",SCREEN_WIDTH);
        
        double everyWith = SCREEN_WIDTH/3.0;
        UILabel *expenseStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, everyWith, 30)];
        expenseStringLabel.text = NSLocalizedString(@"VC_EXPENSE", nil);
        [expenseStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
        [expenseStringLabel setTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
        expenseStringLabel.textAlignment = NSTextAlignmentCenter;
        expenseStringLabel.backgroundColor = [UIColor clearColor];
        [_balanceView addSubview:expenseStringLabel];
        
        UILabel *incomeStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(everyWith, 0, everyWith, 30)];
        incomeStringLabel.text = NSLocalizedString(@"VC_INCOME", nil);
        [incomeStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
        [incomeStringLabel setTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
        incomeStringLabel.textAlignment = NSTextAlignmentCenter;
        incomeStringLabel.backgroundColor = [UIColor clearColor];
        [_balanceView addSubview:incomeStringLabel];
        
        UILabel *balanceStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(everyWith*2, 0, everyWith, 30)];
        balanceStringLabel.text = NSLocalizedString(@"VC_BALANCE", nil);
        [balanceStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
        [balanceStringLabel setTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
        balanceStringLabel.textAlignment = NSTextAlignmentCenter;
        balanceStringLabel.backgroundColor = [UIColor clearColor];
        [_balanceView addSubview:balanceStringLabel];

        //amount
        double  amountLabelY = 17;
        AppDelegate_iPhone *appDelegate_iphone = ( AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _expenseAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, amountLabelY, everyWith, 30)];
        _expenseAmountLabel.textColor = [UIColor colorWithRed:243.0/255 green:61.0/255 blue:36.0/255 alpha:1];
        [_expenseAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:15]];
        _expenseAmountLabel.textAlignment = NSTextAlignmentCenter;
        _expenseAmountLabel.backgroundColor = [UIColor clearColor];
        _expenseAmountLabel.adjustsFontSizeToFitWidth = YES;
        [_balanceView addSubview:_expenseAmountLabel];
        
        _incomeAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(everyWith, amountLabelY, everyWith, 30)];
        _incomeAmountLabel.textColor = [UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1];
        [_incomeAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:15]];
        _incomeAmountLabel.textAlignment = NSTextAlignmentCenter;
        _incomeAmountLabel.backgroundColor = [UIColor clearColor];
        incomeStringLabel.adjustsFontSizeToFitWidth = YES;
        [_balanceView addSubview:_incomeAmountLabel];
        
        _balanceAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(everyWith*2, amountLabelY,everyWith, 30)];
        _balanceAmountLabel.textColor = [UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1];
        [_balanceAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:15]];
        _balanceAmountLabel.textAlignment = NSTextAlignmentCenter;
        _balanceAmountLabel.backgroundColor = [UIColor clearColor];
        balanceStringLabel.adjustsFontSizeToFitWidth = YES;
        [_balanceView addSubview:_balanceAmountLabel];
        
        //image
        double imageX = 10;
        if (IS_IPHONE_6PLUS)
        {
            imageX = 20;
        }
        else if (IS_IPHONE_6)
            imageX = 15;
        _expenseAmountImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 35, 30, 30)];
        [_balanceView addSubview:_expenseAmountImage];
        
        _incomeAmountImage= [[UIImageView alloc]initWithFrame:CGRectMake(imageX+everyWith, 35, 30, 30)];
        [_balanceView addSubview:_incomeAmountImage];
        
        _balanceAmountImage= [[UIImageView alloc]initWithFrame:CGRectMake(imageX+everyWith*2+2, 35, 30, 30)];
        [_balanceView addSubview:_balanceAmountImage];
        
        //percent
        double percentLabelY = 35;
        double percentLabelX = 35;
        if (IS_IPHONE_6PLUS)
        {
            percentLabelX = 50;
        }
        else if (IS_IPHONE_6)
            percentLabelX =40;

        _expensePercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(percentLabelX, percentLabelY, 70, 30)];
        _expensePercentLabel.backgroundColor = [appDelegate_iphone.epnc getAmountGrayColor];;
        [_expensePercentLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:12]];
        _expensePercentLabel.textAlignment = NSTextAlignmentLeft;
        _expensePercentLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        _expensePercentLabel.backgroundColor = [UIColor clearColor];
        [_balanceView addSubview:_expensePercentLabel];
        
        _incomePercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(percentLabelX + everyWith, percentLabelY, 80, 30)];
        _incomePercentLabel.backgroundColor = [appDelegate_iphone.epnc getAmountGrayColor];
        [_incomePercentLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:12]];
        _incomePercentLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        _incomePercentLabel.backgroundColor = [UIColor clearColor];
        _incomePercentLabel.textAlignment = NSTextAlignmentLeft;
        [_balanceView addSubview:_incomePercentLabel];
        
        _balancePercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(percentLabelX+everyWith*2, percentLabelY, 80, 30)];
        _balancePercentLabel.backgroundColor = [appDelegate_iphone.epnc getAmountGrayColor];
        _balancePercentLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        [_balancePercentLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:12]];
        _balancePercentLabel.textAlignment = NSTextAlignmentLeft;
        _balancePercentLabel.backgroundColor = [UIColor clearColor];
        [_balanceView addSubview:_balancePercentLabel];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *purchasePrice = [userDefaults stringForKey:PURCHASE_PRICE];

    UIImage *adsImage=[UIImage imageNamed:[NSString customImageName:@"advertisement"]];

    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    appdelegate.adsView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-79-70-adsImage.size.height, SCREEN_WIDTH, adsImage.size.height)];
    appdelegate.adsView.backgroundColor=[UIColor colorWithPatternImage:adsImage];
    [contentView addSubview:appdelegate.adsView];

    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-80, (adsImage.size.height-30)/2, 80, 30)];
    priceLabel.text=purchasePrice;
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.textColor=[UIColor whiteColor];
    priceLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [appdelegate.adsView addSubview:priceLabel];
    if (appdelegate.isPurchased)
    {
        [appdelegate.adsView removeFromSuperview];
    }
    
    UIButton *adsBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adsImage.size.height)];
    adsBtn.backgroundColor=[UIColor clearColor];
    [adsBtn addTarget:self action:@selector(adsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [appdelegate.adsView addSubview:adsBtn];
    
  [_gridView sizeToFit];
    
}

-(void)adsBtnClicked:(id)sender
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.inAppPM canMakePurchases])
    {
        [appDelegate.inAppPM  purchaseProUpgrade];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate_iPhone *appdelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
  if (object == _gridView && [keyPath isEqualToString:@"frame"])
  {
    CGFloat gridBottom = _gridView.top + _gridView.height;
    CGRect frame = _tableView.frame;
    frame.origin.y = gridBottom;
      
  
      if (_tableView.frame.size.height == SCREEN_WIDTH /7 )
      {
          if (appdelegate.isPurchased)
          {
              //          frame.size.height = SCREEN_HEIGHT - 70 - 64 - 13;
              frame.size.height = SCREEN_HEIGHT - 64 - 70 - 59 - 17 + 61.33;
          }
          else
          {
              frame.size.height = SCREEN_HEIGHT - 64 - 70 - 59 - 17 - 50 + 61.33;
          }

      }

      else
      {
          if (appdelegate.isPurchased)
    {
        frame.size.height = SCREEN_HEIGHT - 64 - 70 - 59 - 17 ;
    }
    else
    {
        frame.size.height = SCREEN_HEIGHT - 64 - 70 - 59 - 17 - 50 ;
    }
      }
           //设置x
      if (logic.calenderDisplayMode==1)
      {
          _tableView.frame = frame;
          shadowView.top = gridBottom;
      }
      else
      {
          _balanceView.frame = CGRectMake(_balanceView.frame.origin.x, gridBottom, SCREEN_WIDTH, _balanceView.frame.size.height);
      }
   

    
  }
  else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"])
  {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  }
  else
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

- (void)jumpToSelectedMonth { [_gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate_week *)date
{
    [_gridView selectDate:date];
}

- (BOOL)isSliding { return _gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [_gridView markTilesForDates:dates]; }

- (KalDate_week *)selectedDate { return _gridView.selectedDate; }

#pragma mark Week Calender Method
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran
{
    [_gridView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran];
}


@end

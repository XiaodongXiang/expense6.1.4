/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

#import "AppDelegate_iPad.h"
#import "ipad_BillEditViewController.h"


@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 69;

static const    CGFloat kHeaderHeight_Bill = 69;

@implementation KalView
@synthesize kalheaderView;
@synthesize delegate, tableView;
@synthesize gridView;
@synthesize isBillShow;
@synthesize headerTitleLabel;
@synthesize logic;
@synthesize totalAmountLabel,paidAmountLabel,dueAmountLabel,balanceView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
  if ((self = [super initWithFrame:frame]))
  {
      delegate = theDelegate;
      logic = theLogic ;
      [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
      self.autoresizesSubviews = YES;
      self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      
      AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
      if (appDelegate_iPad.mainViewController.currentViewSelect==0)
      {
          kalheaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] ;
          [self addSubviewsToHeaderView:kalheaderView];
          [self addSubview:kalheaderView];
          
          UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, 378, frame.size.height - kHeaderHeight)] ;
          contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
          [self addSubviewsToContentView:contentView];
          [self addSubview:contentView];
          
      }
      else
      {
          isBillShow=YES;

          kalheaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 378, kHeaderHeight_Bill)] ;
          [self addSubviewsToHeaderView:kalheaderView];
          [self addSubview:kalheaderView];
          
          UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight_Bill,378, frame.size.height - kHeaderHeight_Bill)];
          contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
          [self addSubviewsToContentView:contentView];
          [self addSubview:contentView];
      }
      
      
    }
  
  return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic withShowModule:(BOOL)m
{
    if ((self = [super initWithFrame:frame]))
    {
        isBillShow=YES;
        self.backgroundColor = [UIColor clearColor];
        
        delegate = theDelegate;
        logic = theLogic;
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
//        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
//        [self addSubviewsToHeaderView:headerView];
//        [self addSubview:headerView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight-42.0)] ;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = [UIColor clearColor];
        contentView.frame = CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight);
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
//    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
//    {

        
        // Draw the selected month name centered and at the top of the view
        CGRect monthLabelFrame = CGRectMake(89,
                                            0,
                                            200,
                                            46);
        headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
        headerTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        headerTitleLabel.textAlignment =NSTextAlignmentCenter;
//        headerTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_header_text_fill.png"]];
//        [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
        [monthFormatter setDateFormat:@"MMMM yyyy"];
        headerTitleLabel.text = [monthFormatter stringFromDate:self.logic.baseDate];
        headerTitleLabel.textColor=[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
        [headerView addSubview:headerTitleLabel];
        
        
        // Create the previous month button on the left side of the view
        CGRect previousMonthButtonFrame = CGRectMake(56,
                                                     8,
                                                     30,30);
        UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
        [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
        [previousMonthButton setImage:[UIImage imageNamed:@"overview_arrow_left"] forState:UIControlStateNormal];
        previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:previousMonthButton];
        
        // Create the next month button on the right side of the view
        CGRect nextMonthButtonFrame = CGRectMake(378-56-30,8,30,30);
        UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
        [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
        [nextMonthButton setImage:[UIImage imageNamed:@"overview_arrow_right"] forState:UIControlStateNormal];
        nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:nextMonthButton];
        
        NSArray *weekdayNames1 = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
        NSMutableArray *weekdayNames = [[NSMutableArray alloc]init];
        for (int i=0; i<7; i++)
        {
            NSString *str = [weekdayNames1 objectAtIndex:i];
            NSString *strUPPER = [str uppercaseString];
            [weekdayNames addObject:strUPPER];
        }
        
        //设置星期
        int firstWeekday = 1;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        
        if([appDelegate.settings.others16 isEqualToString:@"2"])
        {
            firstWeekday = 2;
        }
        //设置标题
        NSUInteger i = firstWeekday-1;
        int num=0;
        for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += headerView.frame.size.width/7.0, i = (i+1)%7)
        {
            CGRect weekdayFrame = CGRectMake(xOffset, 44, 54, 25);
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor clearColor];
            weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.textColor = [UIColor colorWithRed:166.0/255.f green:166/255.f blue:166/255.f alpha:1.f];
            weekdayLabel.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
            weekdayLabel.text = [weekdayNames objectAtIndex:i];
            [weekdayLabel setAccessibilityLabel:[weekdayNames objectAtIndex:i]];

            if (num ==0 )
            {
                firstLabel = weekdayLabel ;
            }
            else if (num==1)
            {
                secondLabel=weekdayLabel ;
            }
            else if (num==2)
            {
                thirdLabel=weekdayLabel ;
            }
            else if (num==3)
            {
                forthLabel=weekdayLabel ;
            }
            else if (num==4)
            {
                fifthLabel=weekdayLabel ;
            }
            else if (num==5)
            {
                sixthiLabel=weekdayLabel ;
            }
            else if (num==6)
            {
                seventhLabel=weekdayLabel;
            }
            [headerView addSubview:weekdayLabel];
            
            num ++;
        }

//    }
//    else
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"MMMM, yyyy"];
//        const CGFloat kChangeMonthButtonWidth = 30.0f;
//        const CGFloat kChangeMonthButtonHeight = 30.0f;
//        const CGFloat kHeaderVerticalAdjust = 13.f;
//        
//        CGRect monthLabelFrame = CGRectMake(0,
//                                            kHeaderVerticalAdjust,
//                                            headerView.frame.size.width,
//                                            kMonthLabelHeight+7);
//        
//        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
//        headImageView.image = [UIImage imageNamed:@"ipad_title_bill_630_70.png"];
//        [headerView addSubview:headImageView];
//        
//        headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
//        headerTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
//        headerTitleLabel.backgroundColor = [UIColor clearColor];
//        headerTitleLabel.textAlignment =NSTextAlignmentCenter;
//        headerTitleLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
//        headerTitleLabel.text =[dateFormatter stringFromDate:self.logic.baseDate];
//
//        [headerView addSubview:headerTitleLabel];
//        
//        // Create the previous month button on the left side of the view
//        CGRect previousMonthButtonFrame = CGRectMake(200,
//                                                     kHeaderVerticalAdjust-4,
//                                                     kChangeMonthButtonWidth,
//                                                     kChangeMonthButtonHeight);
//        UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
//        [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
//        [previousMonthButton setImage:[UIImage imageNamed:@"ipad_arrow1_left_30_30.png"] forState:UIControlStateNormal];
//        previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:previousMonthButton];
//        
//        
//        // Create the next month button on the right side of the view
//        CGRect nextMonthButtonFrame = CGRectMake(400,
//                                                 kHeaderVerticalAdjust-4,
//                                                 kChangeMonthButtonWidth,
//                                                 kChangeMonthButtonHeight);
//        UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
//        [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
//        [nextMonthButton setImage:[UIImage imageNamed:@"ipad_arrow1_right_30_30.png"] forState:UIControlStateNormal];
//        nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:nextMonthButton];
//        
//        NSArray *weekdayNames1 = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
//        NSMutableArray *weekdayNames = [[NSMutableArray alloc]init];
//        for (int i=0; i<7; i++) {
//            NSString *str = [weekdayNames1 objectAtIndex:i];
//            NSString *strUPPER = [str uppercaseString];
//            [weekdayNames addObject:strUPPER];
//        }
//        
//        //设置星期
//        int firstWeekday = 1;
//        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        
//        
//        if([appDelegate.settings.others16 isEqualToString:@"2"])
//        {
//            firstWeekday = 2;
//        }
//        //设置标题
//        NSUInteger i = firstWeekday-1;
//
//        int num = 0;
//        for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 90.f, i = (i+1)%7)
//        {
//            CGRect weekdayFrame = CGRectMake(xOffset, 52.f, 90.f, 20.f);
//            
//            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
//            
//            weekdayLabel.backgroundColor = [UIColor clearColor];
//            weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
//            weekdayLabel.textAlignment = NSTextAlignmentCenter;
//            weekdayLabel.textColor = [UIColor colorWithRed:175.f/255.f green:175.f/255.f blue:175.f/255.f alpha:1.f];
//            weekdayLabel.text = [weekdayNames objectAtIndex:i];
//            [weekdayLabel setAccessibilityLabel:[weekdayNames objectAtIndex:i]];
//
//            if (num ==0 )
//            {
//                firstLabel = weekdayLabel ;
//            }
//            else if (num==1)
//            {
//                secondLabel=weekdayLabel ;
//            }
//            else if (num==2)
//            {
//                thirdLabel=weekdayLabel ;
//            }
//            else if (num==3)
//            {
//                forthLabel=weekdayLabel ;
//            }
//            else if (num==4)
//            {
//                fifthLabel=weekdayLabel ;
//            }
//            else if (num==5)
//            {
//                sixthiLabel=weekdayLabel ;
//            }
//            else if (num==6)
//            {
//                seventhLabel=weekdayLabel;
//            }
//            
//            [headerView addSubview:weekdayLabel];
//            
//            num ++;
//        }
//    }
}

-(void)resetWeekStyle:(UIView *)tmpHeaderView
{
    NSArray *weekdayNames1 = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
    NSMutableArray *weekdayNames = [[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        NSString *str = [weekdayNames1 objectAtIndex:i];
        NSString *strUPPER = [str uppercaseString];
        [weekdayNames addObject:strUPPER];
    }
    
    //设置星期
    int firstWeekday = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        firstWeekday = 2;
    }
    //设置标题
    NSUInteger i = firstWeekday-1;
    
    for (int num=0;num<7;num++)
    {
        UILabel *weekdayLabel;
        if (num ==0 )
        {
            weekdayLabel = firstLabel;
        }
        else if (num==1)
        {
            weekdayLabel = secondLabel;
        }
        else if (num==2)
        {
            weekdayLabel = thirdLabel;
        }
        else if (num==3)
        {
            weekdayLabel = forthLabel;
        }
        else if (num==4)
        {
            weekdayLabel = fifthLabel;
        }
        else if (num==5)
        {
            weekdayLabel = sixthiLabel;
        }
        else if (num==6)
        {
            weekdayLabel = seventhLabel;
        }
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        i = (i+1)%7;

    }

}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
    {
        CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.frame.size.width, 0.f);
        CGRect fullWidthAutomaticLayoutFrame1 = CGRectMake(0, 0.f, 378, 0.f);
        
        gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
        [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        gridView.clipsToBounds = YES;
        [contentView addSubview:gridView];
        gridView.backgroundColor = [UIColor clearColor];
        
        //tableview
        tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame1 style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.showsVerticalScrollIndicator = NO;
        gridView.kalTableView=tableView;
        [contentView addSubview:tableView];

        [gridView sizeToFit];
        
        //添加addTransaction按钮
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 533, 378, 72)];
        bottomView.backgroundColor=[UIColor whiteColor];
        [contentView addSubview:bottomView];
        
        UIButton *addTransBtn= [[UIButton alloc]initWithFrame:CGRectMake(114, 11, 150, 50)];
        [addTransBtn addTarget:self action:@selector(transAddBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [addTransBtn setImage:[UIImage imageNamed:@"overview_button_add"] forState:UIControlStateNormal];
        [addTransBtn setImage:[UIImage imageNamed:@"overview_button_add_click"] forState:UIControlStateHighlighted];
        [bottomView addSubview:addTransBtn];
    }
    else
    {
        CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.frame.size.width, 0.f);
        CGRect fullWidthAutomaticLayoutFrame1 = CGRectMake(0, 0.f, 378, 0.f);

        gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
        [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        [contentView addSubview:gridView];
        
        
        //tableview
        tableView=[[UITableView alloc]initWithFrame:fullWidthAutomaticLayoutFrame1 style:UITableViewStylePlain];
        tableView.backgroundColor=[UIColor clearColor];
        tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.showsVerticalScrollIndicator=NO;
        gridView.kalTableView=tableView;
        [contentView addSubview:tableView];
        
        //添加底下的金额
        balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 378, 64)];

        balanceView.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        balanceView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:balanceView];

        UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 378, EXPENSE_SCALE)];
        topLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [balanceView addSubview:topLine];
        
        UIView *leftLine=[[UIView alloc]initWithFrame:CGRectMake(126, 17, EXPENSE_SCALE, 25)];
        leftLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [balanceView addSubview:leftLine];
        
        UIView *rightLine=[[UIView alloc]initWithFrame:CGRectMake(126*2, 17, EXPENSE_SCALE, 25)];
        rightLine.backgroundColor=[UIColor colorWithRed: 218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [balanceView addSubview:rightLine];
        
        
        //text
        UILabel *totalStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,12, 126, 15)];
        totalStringLabel.text = [NSLocalizedString(@"VC_Total", nil)uppercaseString];;
        [totalStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [totalStringLabel setTextColor:[UIColor colorWithRed:168/255.f green:168/255.f blue:168/255.f alpha:1]];
        totalStringLabel.textAlignment = NSTextAlignmentCenter;
        totalStringLabel.backgroundColor = [UIColor clearColor];
        [balanceView addSubview:totalStringLabel];
        
        UILabel *paidStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(126, 12, 126, 15)];
        paidStringLabel.text = [NSLocalizedString(@"VC_Paid", nil)uppercaseString];
        [paidStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [paidStringLabel setTextColor:[UIColor colorWithRed:168/255.f green:168/255.f blue:168/255.f alpha:1]];
        paidStringLabel.textAlignment = NSTextAlignmentCenter;
        paidStringLabel.backgroundColor = [UIColor clearColor];
        [balanceView addSubview:paidStringLabel];
        
        UILabel *dueStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(252, 12, 126, 15)];
        dueStringLabel.text = [NSLocalizedString(@"VC_Due", nil)uppercaseString];
        [dueStringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [dueStringLabel setTextColor:[UIColor colorWithRed:168/255.f green:168/255.f blue:168/255.f alpha:1]];
        dueStringLabel.textAlignment = NSTextAlignmentCenter;
        dueStringLabel.backgroundColor = [UIColor clearColor];
        [balanceView addSubview:dueStringLabel];
        
        //amount
        double  amountLabelY = 30;
        PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        totalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, amountLabelY, 126, 20)];
        totalAmountLabel.textColor = [UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1];
        [totalAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        totalAmountLabel.textAlignment = NSTextAlignmentCenter;
        totalAmountLabel.backgroundColor = [UIColor clearColor];
        totalAmountLabel.adjustsFontSizeToFitWidth = YES;
        [balanceView addSubview:totalAmountLabel];
        
        paidAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(126, amountLabelY, 126, 20)];
        paidAmountLabel.textColor = [UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1];
        [paidAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        paidAmountLabel.textAlignment = NSTextAlignmentCenter;
        paidAmountLabel.backgroundColor = [UIColor clearColor];
        paidAmountLabel.adjustsFontSizeToFitWidth = YES;
        [balanceView addSubview:paidAmountLabel];
        
        dueAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(252, amountLabelY, 126, 20)];
        dueAmountLabel.textColor = [UIColor colorWithRed:94.0/255 green:94.0/255 blue:94.0/255 alpha:1];
        [dueAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:17]];
        dueAmountLabel.textAlignment = NSTextAlignmentCenter;
        dueAmountLabel.backgroundColor = [UIColor clearColor];
        dueAmountLabel.adjustsFontSizeToFitWidth = YES;
        [balanceView addSubview:dueAmountLabel];
        
        [gridView sizeToFit];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((appDelegate_iPad.mainViewController.currentViewSelect==0 && !isBillShow) || (appDelegate_iPad.mainViewController.currentViewSelect==4&&isBillShow))
    {
        if (object == gridView && [keyPath isEqualToString:@"frame"]) {
            CGFloat gridBottom = gridView.top + gridView.height;
            CGRect frame = tableView.frame;
            frame.origin.y = gridBottom;
            float bottomViewH;
            if (appDelegate_iPad.mainViewController.currentViewSelect==0)
            {
                bottomViewH=72;
            }
            else
            {
                bottomViewH=64;
            }
            frame.size.height = tableView.superview.height - gridBottom-bottomViewH;
            tableView.frame = frame;
            
            if (appDelegate_iPad.mainViewController.currentViewSelect!=0)
            {
                balanceView.frame = CGRectMake(balanceView.frame.origin.x, gridView.superview.height-62, balanceView.frame.size.width, balanceView.frame.size.height);
            } 
        }
        else if([keyPath isEqualToString:@"selectedMonthNameAndYear"])
        {
            AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            if (appDelegate_iPad.mainViewController.currentViewSelect==0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MMMM, yyyy"];
                
                self.headerTitleLabel.text =[dateFormatter stringFromDate:self.logic.baseDate];
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MMMM, yyyy"];
                
                self.headerTitleLabel.text =[dateFormatter stringFromDate:self.logic.baseDate];
            }
            
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
   
}

- (void)setHeaderTitleText:(NSMutableAttributedString *)text
{
  headerTitleLabel.attributedText = text;
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }
- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran{ [gridView paidmarkTilesForDates:dates withDates1: dates1 isTran:isTran]; }

- (void)unpaidmarkTilesForDates { [gridView unpaidmarkTilesForDates]; }
- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

#pragma mark Btn Action
-(void)transAddBtnPressed:(UIButton *)sender
{
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    //1.creat
    appDelegate.mainViewController.overViewController.iTransactionViewController=[[ipad_TranscactionQuickEditViewController alloc]initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    //2.configure
    appDelegate.mainViewController.overViewController.iTransactionViewController.transactionDate = appDelegate.mainViewController.overViewController.kalViewController.selectedDate;
    appDelegate.mainViewController.overViewController.iTransactionViewController.typeoftodo=@"IPAD_ADD";
    appDelegate.mainViewController.overViewController.iTransactionViewController.iOverViewViewController = appDelegate.mainViewController.overViewController;
    
    //3.create navigationViewController
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:appDelegate.mainViewController.overViewController.iTransactionViewController];
    
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [appDelegate.mainViewController presentViewController:navigationController animated:YES completion:nil];
    appDelegate.mainViewController.popViewController = navigationController ;

}
-(void)addBtnPressed:(UIButton *)sender
{
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    
    ipad_BillEditViewController *billEditViewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    billEditViewController.typeOftodo = @"IPAD_ADD";
    billEditViewController.iBillsViewController = appDelegate_iPad.mainViewController.iBillsViewController;
    billEditViewController.starttime = [self.selectedDate NSDate];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:billEditViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    
    [appDelegate_iPad.mainViewController.iBillsViewController presentViewController:navigationController animated:YES completion:nil];
	navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           100,
//                                                           480,
//                                                           490
//                                                           );

}
- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  
  [gridView removeObserver:self forKeyPath:@"frame"];

}

@end

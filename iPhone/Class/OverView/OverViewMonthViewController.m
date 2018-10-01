//
//  OverViewMonthViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-3-25.
//
//

#import "OverViewMonthViewController.h"
#import "AppDelegate_iPhone.h"

#import "OverViewWeekCalenderViewController.h"

#import "KalViewController_week.h"
#import "KalView_week.h"
#import "KalGridView_week.h"
#import "KalLogic_week.h"
#import "EventKitDataSource_week.h"
#import "KalDate_week.h"
#import "NSDateAdditions.h"

@interface OverViewMonthViewController ()

@end

@implementation OverViewMonthViewController
@synthesize kalViewController,monthTransactionArray,dateFormater,calenderDataSource,monthStartDate,monthEndDate,selectedDate,headTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initPoint];
    [self initNavStyle];
    [self initCalenderView];
    [self showContex];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self resetData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}
#pragma mark View Did Load Method
-(void)initPoint
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.monthStartDate = [appDelegate_iPhone.epnc getStartDateWithDateType:2 fromDate:self.selectedDate];
	self.monthEndDate = [appDelegate_iPhone.epnc getEndDateDateType:2 withStartDate:self.monthStartDate];
    
    monthTransactionArray = [[NSMutableArray alloc]init];
    
    dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM yyyy"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back) name:@"monthviewpop" object:nil];
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -1.f;
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    [addBtn setTitle:NSLocalizedString(@"VC_Today", nil) forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    addBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [addBtn.titleLabel setMinimumScaleFactor:0];
    [addBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [addBtn addTarget:self action:@selector(todayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,addBar];
    self.navigationItem.leftBarButtonItem = nil;

    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    leftBtn.hidden = YES;
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    
    
	headTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
	[headTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[headTitle setTextColor:[UIColor whiteColor]];
    [headTitle setTextAlignment:NSTextAlignmentCenter];
	[headTitle setBackgroundColor:[UIColor clearColor]];
	headTitle.text = @"";
	self.navigationItem.titleView = 	headTitle;
}

-(void)initCalenderView{
    
    //不能自动释放
    kalViewController = [[KalViewController_week alloc]init];
    kalViewController.title = @"hello";
    self.calenderDataSource = [[EventKitDataSource_week alloc] init];
    kalViewController.dataSource = self.calenderDataSource;
    kalViewController.delegate = self.calenderDataSource;
    kalViewController.kalView.gridView.selectedDate =  [KalDate_week  dateFromNSDate:self.selectedDate ];
    [kalViewController.dataSource getCalendarView:self.calenderDataSource];
    [self.view addSubview:kalViewController.view];
}

-(void)showContex
{
    headTitle.text = [dateFormater stringFromDate:self.monthStartDate];
}

#pragma mark View Will Appear Method
-(void)resetData{
    [self.kalViewController reloadData];
}

#pragma mark Btn Action
-(void)back
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    //              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(void)todayBtnPressed:(UIButton *)sender
{
    //从month页面返回到week页面的时候，需要设置week页面的logic.baseDate为一周的第一天
    AppDelegate_iPhone *appdelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//    appdelegate_iphone.overViewController.monthContainBtn.selected = NO;
    appdelegate_iphone.overViewController.kalViewController.logic.baseDate = [[NSDate date] cc_dateByMovingToFirstDayOfTheWeek];
    [appdelegate_iphone.overViewController.kalViewController showCurrentMonth];
    [appdelegate_iphone.overViewController.kalViewController.kalView selectDate:[KalDate_week dateFromNSDate:[NSDate date]]];
    
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

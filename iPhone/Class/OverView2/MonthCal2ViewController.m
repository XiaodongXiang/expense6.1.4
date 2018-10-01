//
//  MonthCal2ViewController.m
//  MSCal
//
//  Created by wangdong on 3/6/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import "MonthCal2ViewController.h"
#import "CalendarCell.h"
#import "MonthHeaderView.h"

#import "UIViewController+Animation.h"
#import "HelpClass.h"
#import "UIViewAdditions.h"
#import "PlannerClass.h"

#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "KalViewController_week.h"
#import <ParseUI/ParseUI.h>
#import "NSDateAdditions.h"

//#import "WDDailyViewController.h"
//#import "WDSettingsViewController.h"

const CGFloat headerHeight_WD = 18.f;

@interface MonthCal2ViewController ()
{
    //星期
    MonthHeaderView *headerView;
    //标记是不是第一次进入这个页面，是的话，设置cell的位置。
    BOOL             isFirst;
    NSDate          *baseDate;
    //屏幕中第一行cell与最后一行cell的第一个提起
    NSDate          *firstCelldate;
    NSDate          *lastCelldate;
    NSIndexPath     *firstIndexPath;
    NSIndexPath     *lastIndexPath;
    
    //标记tableview进入某一行是jump,还是滑动进来的
    BOOL            jump;
    NSDate          *jumpDate;
    BOOL            reloadTaskRightNow;
    
    BOOL           justReload;
    //重新加载的日期
    NSDate         *reloadDate;
    
    NSInteger       numbersOfRows;
    
    NSString *yearAndMonthStr;
    NSDateFormatter *monthAndYearFormatter;
    NSString *monthStr;
}
@end

@implementation MonthCal2ViewController
@synthesize _tableView;
@synthesize delegate;

-(void)dealloc
{
    delegate = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //设置tableview
    headerView = [[MonthHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight_WD)];
//    [self.view addSubview:headerView];
    _tableView.clipsToBounds = NO;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
//    baseDate = [[NSDate date] getFirstDayInMonth:NSCalendarTypeTimezone];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    baseDate = [appDelegate.overViewController.kalViewController.selectedDate getFirstDayInMonth:NSCalendarTypeTimezone];

    justReload = NO;
    jump = NO;
    isFirst = YES;
    reloadTaskRightNow = YES;
    
    //????
//    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.top, SCREEN_WIDTH, 12)];
//    gradientView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:gradientView];
//    
//    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = [gradientView bounds];
//    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor colorWithWhite:1. alpha:0.0].CGColor];
//    [gradientView.layer addSublayer:gradientLayer];
    
    //初始化tableview的行数
    numbersOfRows = 80000;
    CGFloat decelerationRate = UIScrollViewDecelerationRateFast +(UIScrollViewDecelerationRateNormal - UIScrollViewDecelerationRateFast) * .52;
    [_tableView setValue:[NSValue valueWithCGSize:CGSizeMake(decelerationRate,decelerationRate)] forKey:@"_decelerationFactor"];
    
    if (IS_IPHONE_6PLUS)
    {
        cellHigh = SCREEN_WIDTH/7;
    }
    else if (IS_IPHONE_6)
        cellHigh = SCREEN_WIDTH/7;
    else
        cellHigh = 375/7;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (isFirst)
    {
        jump = YES;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numbersOfRows/2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        isFirst = NO;
    }
    //将tableview cell的位置放中间
    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIInterfaceOrientation interfaceOrientation =[UIApplication sharedApplication].statusBarOrientation;
//    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        app.dataInit_iPhone.viewLocation = ViewLocationAtWeek;
//    }
//    else
//    {
//        app.dataInit_iPhone.viewLocation = ViewLocationAtMonth;
//    }
//    app.dataInit_iPhone.viewLocation = ViewLocationAtMonth;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    if (app.dataInit_iPhone.dailyVController)
//    {
        //刷新数据
//        [_tableView reloadData];
//        app.dataInit_iPhone.dailyVController = nil;
//    }
}

#pragma mark - 跳转到某一天


-(CGRect) rectInShowCalendarView:(NSDate *)date
{
    double tileWidth_WD = SCREEN_WIDTH/7.0;
    double MonthRowHeight = 0;
    if (IS_IPHONE_6PLUS)
    {
        MonthRowHeight = SCREEN_WIDTH/7;
    }
    else if (IS_IPHONE_6)
        MonthRowHeight = SCREEN_WIDTH/7;
    else
        MonthRowHeight = 375/7;
    date = [date getStartTimeInDay:NSCalendarTypeTimezone];
    NSDateComponents * jumpDc = [date dateComponentsYMDcalType:NSCalendarTypeTimezone];
    NSArray *visibleArray  = _tableView.visibleCells;
    NSInteger    fisrtRow = [[_tableView indexPathForCell:[visibleArray objectAtIndex:0]] row];
    CGRect rect = CGRectMake(0,  _tableView.top , tileWidth_WD, MonthRowHeight);
    
    for (UITableViewCell *cell in visibleArray)
    {
        CalendarCell *calCell = (CalendarCell *)cell;
        NSDateComponents * firstDc = [calCell.firstDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
        NSDateComponents * lastDc = [calCell.lastDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
        if ((firstDc.year == jumpDc.year && firstDc.month == jumpDc.month)
            && (jumpDc.day >= firstDc.day && jumpDc.day <= lastDc.day))
        {
            NSInteger dis = 0;
            if (firstDc.day == 1) {
                dis = 7 - calCell.dateArray.count;
            }
            NSInteger row = [[_tableView indexPathForCell:calCell] row];
            rect = CGRectMake((jumpDc.day - firstDc.day + dis)*tileWidth_WD,
                              (row - fisrtRow)*MonthRowHeight + _tableView.top,
                              tileWidth_WD, MonthRowHeight);
            break;
        }
    }
    return rect;
}

/*
- (void)dateStringWithDate:(NSDate *)date ShowMonth:(BOOL)showMonth
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [monthAndYearFormatter setTimeZone:[NSTimeZone timeZoneWithName:app.dataInit_iPhone.setting.gTimeZone]];
    if (!date) {
        date = [NSDate date];
        if (_tableView.visibleCells.count > 0) {
            date = [(CalendarCell *)[_tableView.visibleCells objectAtIndex:0] firstDate];
        }
    }
    
    [monthAndYearFormatter setDateFormat:@"yyyy"];
    yearAndMonthStr = [monthAndYearFormatter stringFromDate:date];
    
    [monthAndYearFormatter setDateFormat:@"M"];
    monthStr = [PlannerClass getMonthStrAtIndex:[[monthAndYearFormatter stringFromDate:date] integerValue] - 1];
    
    self.navigationItem.title = yearAndMonthStr;
    if ([delegate respondsToSelector:@selector(monthCal2ViewController:showDateStr:)])
    {
        [delegate monthCal2ViewController:self showDateStr:[NSString stringWithFormat:@"%@ %@",monthStr,yearAndMonthStr]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - zoom to dayViewController
-(void)zoomoutDayViewController:(NSDate *)zoomDate FromRect:(CGRect) fromRect
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
 
    WDDailyViewController *dailyVc = app.dataInit_iPhone.dailyVController;
    if (!app.dataInit_iPhone.dailyVController)
    {
        dailyVc = [[WDDailyViewController alloc] initWithNibName:@"WDDailyViewController" bundle:nil];
        app.dataInit_iPhone.dailyVController = dailyVc;
    }
    dailyVc.date = zoomDate;
    
    NSString *title = [dailyVc dateStringFromDate:zoomDate];
    [dailyVc setLeftItem:title];
    
    fromRect = CGRectMake(fromRect.origin.x,
                          fromRect.origin.y - _tableView.contentOffset.y + _tableView.top,
                          fromRect.size.width,
                          fromRect.size.height);
//    [self zoomoutViewController:dailyVc fromRect:fromRect];
    [self presentViewController:dailyVc fromRect:fromRect];
 
}
*/

#pragma  mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numbersOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CalendarCell";
	CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
	{
		NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"CalendarCell" owner:self options:nil];
		for (id object in array)
		{
			if ([object isKindOfClass:[CalendarCell class]])
			{
				cell = (CalendarCell *)object;
                cell.width = SCREEN_WIDTH;
                cell.height = [tableView rowHeight];
			}
		}
	}
    CalendarCell *firstCell = nil;
    CalendarCell *lastCell  = nil;
    NSArray *visibleArray = [tableView visibleCells];
    

    if (justReload)
    {
        //获取屏幕上的第一天
        NSDate *tempdate = reloadDate;
        
        NSArray *weekArray = [self getDateWeekArray:tempdate];
        [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
        lastIndexPath = indexPath;
        firstIndexPath = indexPath;
        justReload = NO;
        reloadDate = nil;
        
        return cell;
    }
    if (visibleArray.count > 0)
    {
        //获取屏幕上的第一行，最后一行
        firstCell = [visibleArray objectAtIndex:0];
        lastCell  = [visibleArray lastObject];
        
        //如果要显示的cell比当前的cell朝后
        if (indexPath.row > [[tableView indexPathForCell:lastCell] row])
        {
            NSDate *tempdate = nil;
            //可以直接设置跳转至哪个日期。
            if (jump) {
                tempdate = jumpDate;
                if (!tempdate) {
                    tempdate = baseDate;
                }
                jump = NO;
            }
            //获取最后一个cell,以及最后一个cell的日期
            else
            {
                lastCelldate = [lastCell lastDate];
                tempdate = [lastCelldate getDateByYear:0 month:0 day:1 hour:0 minute:0 second:0
                                            getDatetype:GetDateTypeAddSubtract
                                           calendarType:NSCalendarTypeTimezone];
            }
            
            
            NSArray *weekArray = [self getDateWeekArray:tempdate];
            [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
            lastIndexPath = indexPath;
        }
        else if (indexPath.row < [[tableView indexPathForCell:firstCell] row])
        {
            NSDate *tempdate = nil;
            if (jump) {
                tempdate = jumpDate;
                if (!tempdate) {
                    tempdate = baseDate;
                }
                jump = NO;
            }
            else
            {
                firstCelldate = [firstCell firstDate];
                tempdate = [firstCelldate getDateByYear:0 month:0 day:-1 hour:0 minute:0 second:0
                                            getDatetype:GetDateTypeAddSubtract
                                           calendarType:NSCalendarTypeTimezone];
                
            }
            
            NSArray *weekArray = [self getDateWeekArray:tempdate];
            [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
            firstIndexPath = indexPath;
        }
    }
    else
    {
        if (jump) {
            NSDate *tempdate = jumpDate;
            if (!tempdate) {
                tempdate = baseDate;
            }
            jump = NO;
            NSArray *weekArray = [self getDateWeekArray:tempdate];
            [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
            firstIndexPath = indexPath;
            lastIndexPath = indexPath;
        }
        else if (indexPath.row > lastIndexPath.row)
        {
            NSDate *tempdate = [lastCelldate getDateByYear:0 month:0 day:1 hour:0 minute:0 second:0
                                                getDatetype:GetDateTypeAddSubtract
                                               calendarType:NSCalendarTypeTimezone];;
            
            NSArray *weekArray = [self getDateWeekArray:tempdate];
            [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
            lastIndexPath = indexPath;
        }
        else if(indexPath.row < firstIndexPath.row)
        {
            NSDate *tempdate = [firstCelldate getDateByYear:0 month:0 day:-1 hour:0 minute:0 second:0
                                                getDatetype:GetDateTypeAddSubtract
                                               calendarType:NSCalendarTypeTimezone];
            NSArray *weekArray = [self getDateWeekArray:tempdate];
            
            [cell setDateArray:weekArray indexPath:indexPath reloadTask:reloadTaskRightNow];
            firstIndexPath = indexPath;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHigh;
}
//scroll view滑动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSDate *showDate = nil;
    NSArray *visibleArray = nil;
    if (scrollView.dragging || scrollView.decelerating) {
        visibleArray = [_tableView visibleCells];
    }
    
    if ([visibleArray count] > 0) {
        CalendarCell *cell = [visibleArray objectAtIndex:0];
        showDate = cell.firstDate;
    }
    else if (jump)
    {
        showDate = jumpDate;
    }
    else if (firstCelldate)
    {
        showDate = firstCelldate;
    }
    else
    {
        showDate = baseDate;
    }
    [self showOverViewMonthLabelText];
//    [self dateStringWithDate:showDate ShowMonth:scrollView.dragging];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    reloadTaskRightNow = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger off = round((targetContentOffset->y)/cellHigh);
    targetContentOffset->y = off*cellHigh;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSDate *showDate = [NSDate date];
    NSArray *visibleArray = [_tableView visibleCells];
    if ([visibleArray count] > 0) {
        CalendarCell *cell = [visibleArray objectAtIndex:0];
        showDate = cell.firstDate;
    }
    
    
    //设置overview页面的时间
    [self showOverViewMonthLabelText];

//    [self dateStringWithDate:showDate ShowMonth:scrollView.dragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndDecelerating:scrollView];

    }
    


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    reloadTaskRightNow = YES;
    scrollView.scrollEnabled = NO;
    for (CalendarCell *cell in _tableView.visibleCells) {
//        if (cell.hadClearTaskInfo) {
//            [cell reloadTaskInfoWhenScrollEnd];
//        }
        [cell reloadTaskInfoWhenScrollEnd];

    }
    scrollView.scrollEnabled = YES;
    
    
    //显示日期
    [self showOverViewMonthLabelText];
}

-(void)showOverViewMonthLabelText
{
    //显示日期
    NSDate *showDate = [NSDate date];
    NSArray *visibleArray = [_tableView visibleCells];
    if ([visibleArray count] > 0) {
        CalendarCell *cell = [visibleArray objectAtIndex:0];
        showDate = cell.firstDate;
    }
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MMMM yyyy"];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPhone.overViewController.navigationItem.title=[monthFormatter stringFromDate:showDate];
    [appDelegate_iPhone.overViewController addSubviewsToHeaderView:appDelegate_iPhone.overViewController.headerView withDate:[showDate cc_dateByMovingToFirstDayOfTheMonth]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return NO;
}

#pragma mark - getDates
- (NSMutableArray *)getDateWeekArray:(NSDate *)weekDate
{
    //星期天为1
    int firstWeekDay = 1;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
        firstWeekDay = 2;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:firstWeekDay];

    
//	NSCalendar *calendar = [NSCalendar timezoneCalendar];
    
	NSMutableArray *weekList = [NSMutableArray array];
	NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:weekDate];
    
    if ([self sameMonth:weekFirstDate compare:weekDate]) {
        [weekList addObject:weekFirstDate];
    }
    NSDate *tempDate = [NSDate date];
    
	for(int i = 1; i < 7; i ++)
	{
        tempDate = [weekFirstDate getDateByYear:0 month:0 day:i hour:0 minute:0 second:0
                                    getDatetype:GetDateTypeAddSubtract
                                   calendarType:NSCalendarTypeTimezone];
        if ([self sameMonth:tempDate compare:weekDate]) {
            [weekList addObject:tempDate];
        }
	}
	NSArray *sortArray = [weekList sortedArrayUsingSelector:@selector(compare:)];
	[weekList removeAllObjects];
	[weekList addObjectsFromArray:sortArray];
	
	return weekList;
}

-(BOOL) sameMonth:(NSDate *)date1 compare:(NSDate *)date2
{
    NSDateComponents * d1 = [[NSCalendar timezoneCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents * d2 = [[NSCalendar timezoneCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    if (d1.year == d2.year && d1.month == d2.month) {
        return YES;
    }
    return NO;
}




#pragma mark - redraw
-(void) reloadTableView:(NSDate *)date
{
    reloadDate = [date getFirstDayInMonth:NSCalendarTypeTimezone];
    justReload  = YES;
    [_tableView reloadData];
//    [self dateStringWithDate:reloadDate ShowMonth:YES];
}
-(void) transferDateWhenTimezoneChangedFrom:(NSString *) oldZone to:(NSString *) newZone
{
    justReload = YES;
    if (_tableView.visibleCells.count > 0)
    {
        CalendarCell * firstCell = [_tableView.visibleCells objectAtIndex:0];
        NSDate *tempDate = firstCell.firstDate;
        if (reloadDate) {
            tempDate = reloadDate;
        }
        
        [[NSCalendar timezoneCalendar] setTimeZone:[NSTimeZone timeZoneWithName:oldZone]];
        NSDateComponents *com = [[NSCalendar timezoneCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
        
        [[NSCalendar timezoneCalendar] setTimeZone:[NSTimeZone timeZoneWithName:newZone]];
        [[NSDate timezoneDateFormatter] setTimeZone:[NSTimeZone timeZoneWithName:newZone]];
        
        reloadDate = [tempDate getDateByYear:com.year month:com.month day:com.day hour:0 minute:0 second:0
                               getDatetype:GetDateTypeModification calendarType:NSCalendarTypeTimezone];
    }
    else
    {
        reloadDate = [[NSDate date] getStartTimeInDay:NSCalendarTypeTimezone];
    }
}
-(void) redrawMonthViewWhenFirstWeekdayChanged
{
    [headerView redrawHeaderViewWhenFirstweekdayChanged];
    justReload = YES;
    if (_tableView.visibleCells.count > 0 && !reloadDate)
    {
        CalendarCell * firstCell = [_tableView.visibleCells objectAtIndex:0];
        reloadDate = firstCell.firstDate;
    }
}

//-(void) reloadViewWhenAddOrEditEvent
//{
//    for (CalendarCell *cell in _tableView.visibleCells) {
//        [cell reloadEventInfoWhenAddorEdit];
//    }
//}

-(void) reloadViewWhenAddOrEditTask
{
    for (CalendarCell *cell in _tableView.visibleCells) {
        [cell reloadTaskInfoWhenScrollEnd];
    }
}

-(void) reloadViewWhenAddOrEditNote
{
    
}

-(void) reloadTableView
{
    justReload  = YES;
    //初始化reloadDate
    if (!reloadDate)
    {
        reloadDate = [[_tableView.visibleCells objectAtIndex:0] firstDate];
    }
    [_tableView reloadData];
}

#pragma mark - navigation title

-(NSDate *)dateAtMiddle
{
    NSArray *visibleArray = [_tableView visibleCells];
    
    NSDate *todayMonth = [[NSDate date] getStartTimeInDay:NSCalendarTypeTimezone];
    NSDateComponents * todayDc = [todayMonth dateComponentsYMDcalType:NSCalendarTypeTimezone];
    
    BOOL today = NO;
    for (CalendarCell *cell in visibleArray) {
        NSDateComponents * firstDc = [cell.firstDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
        NSDateComponents * lastDc = [cell.lastDate dateComponentsYMDcalType:NSCalendarTypeTimezone];
        if ((firstDc.year == todayDc.year && firstDc.month == todayDc.month)
            && (todayDc.day >= firstDc.day && todayDc.day <= lastDc.day))
        {
            today = YES;
            break;
        }
    }
    if (today) {
        return todayMonth;
    }
    
    NSInteger index  = 0;
    if (visibleArray.count > 0) {
        index = visibleArray.count/2;
        return [(CalendarCell *)[visibleArray objectAtIndex:index] firstDate];
    }
    return [NSDate date];
}

@end

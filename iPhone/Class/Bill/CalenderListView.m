//
//  CalenderListView.m
//  BillKeeper
//
//  Created by APPXY_DEV on 13-9-5.
//  Copyright (c) 2013年 APPXY_DEV. All rights reserved.
//

#import "CalenderListView.h"
#import "CalenderListCell.h"

#import "AppDelegate_iPhone.h"
#import "BillsViewController.h"


#define MONTH_TABLE_FROMYEAR 1990
#define MONTH_TABLE_TOYEAR 2090

@implementation CalenderListView
@synthesize clv_monthTableView,startDate,endDate,clv_monthDataArray,clv_greenImageView,clv_monthLabel,clv_yearLabel,clv_expiredImage;
@synthesize clv_billSelectedIndexPath,clv_expiredArray;
@synthesize clv_billsViewController;

//在xib文件中拉控件会调用这个方法
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initPoint];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initPoint];
    }
    return self;
}

-(void)initPoint{
    yearFormatter = [[NSDateFormatter alloc]init];
    [yearFormatter setDateFormat:@"yyyy"];
    monthFormatter =[[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MMM"];
    
    clv_monthDataArray = [[NSMutableArray alloc]init];
    clv_expiredArray = [[NSMutableArray alloc]init];
    
    clv_monthDateFormatter = [[NSDateFormatter alloc]init];
    [clv_monthDateFormatter setDateFormat:@"EEE,MMM dd"];
    
    //计算起始年的第一个月第一天
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
    //NSDateComponents需要先根据时间来初始化
    NSDateComponents *componentsFromyear = [cal components:unitFlags fromDate:[NSDate date]];
    componentsFromyear.year = MONTH_TABLE_FROMYEAR;
    [componentsFromyear setMonth:1];
    [componentsFromyear setDay:1];;
    [componentsFromyear setHour:0];
    [componentsFromyear setMinute:0];
    [componentsFromyear setSecond:0];
    NSDate *fromday = [cal dateFromComponents:componentsFromyear];
    
    
    //计算结束年的最后一个月最后一天
    NSDateComponents *componentsToyear = [cal components:unitFlags fromDate:[NSDate date]];
    componentsToyear.year = MONTH_TABLE_TOYEAR;
    [componentsToyear setMonth:12];
    [componentsToyear setDay:31];
    [componentsToyear setHour:23];
    [componentsToyear setMinute:59];
    [componentsToyear setSecond:59];
    NSDate *toDay = [cal dateFromComponents:componentsToyear];
    
    
    //当计算月份，或者年的时候，unitFlagsMonth 要是具体的年或者月，而不能使所有的总和
    unsigned int unitFlagsMonth = NSMonthCalendarUnit;
    NSDateComponents *components = [cal components:unitFlagsMonth fromDate:fromday toDate:toDay options:0];
    
    monthTableRowCount = [components month];
    
    for (int i=0; i<monthTableRowCount; i++) {
        NSDateComponents *oneCellComponent = [cal components:unitFlags fromDate:fromday];
        [oneCellComponent setMonth:oneCellComponent.month+i];
        NSDate *oneCellDate = [cal dateFromComponents:oneCellComponent];
        [clv_monthDataArray addObject:oneCellDate];

    }

    
    clv_monthTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, 65, 320)];
    clv_monthTableView.delegate = self;
    clv_monthTableView.dataSource = self;
    clv_monthTableView.showsVerticalScrollIndicator = NO;
    clv_monthTableView.showsHorizontalScrollIndicator = NO;
    clv_monthTableView.backgroundColor = [UIColor clearColor];
    clv_monthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    clv_monthTableView.center = CGPointMake(clv_monthTableView.bounds.size.height/2.0, 25.5);
    clv_monthTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:clv_monthTableView];
    [clv_monthTableView reloadData];
    

    [self setMonthTableCellatNowMonth];
    
    //创建一个显示选中月份的控件
    clv_greenImageView = [[UIImageView alloc]initWithFrame:CGRectMake(128, 0, 64, 58)];
    clv_greenImageView.image = [UIImage imageNamed:@"month_64_58_sel.png"];
    [self addSubview:clv_greenImageView];
    
    clv_monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 63, 30)];
    [clv_monthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    clv_monthLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
    clv_monthLabel.textAlignment = NSTextAlignmentCenter;
    [clv_greenImageView addSubview:clv_monthLabel];
    
    clv_yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 63, 60)];
    [clv_yearLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    clv_yearLabel.textAlignment = NSTextAlignmentCenter;
    clv_yearLabel.textColor = [UIColor colorWithRed:111.f/255.f green:139.f/255.f blue:181.f/255.f alpha:1];
    [clv_greenImageView addSubview:clv_yearLabel];
    
    clv_expiredImage = [[UIImageView alloc]initWithFrame:CGRectMake(28, 45, 8, 8)];
    clv_expiredImage.image = [UIImage imageNamed:@"mark_red.png"];
    clv_expiredImage.hidden = YES;
    [clv_greenImageView addSubview:clv_expiredImage];
    
    clv_yearLabel.text =  [yearFormatter stringFromDate:self.startDate];
    clv_monthLabel.text = [monthFormatter stringFromDate:self.startDate];
}

-(void)setMonthTableCellatNowMonth{
    
    long start=0;
    long end = nil;
    long i=0;
    NSDate *today = [NSDate date];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
   
    for(start=0,end=monthTableRowCount;start<=end;)
    {
        i= start+(end-start)/2;
        NSDate *halfDate = [clv_monthDataArray objectAtIndex:i];
        if ([appDelegate.epnc monthCompare:today withDate:halfDate]==0) {
            selectedMonth = i;
            break;
        }
        else if ([appDelegate.epnc dateCompare:today withDate:halfDate]>0){
            start = i-1;
        }
        else
            end = i+1;
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:selectedMonth inSection:0];
    [clv_monthTableView scrollToRowAtIndexPath:index
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    

    [self getMonthStartDay];
    [self getMonthEndDay];
    
}


-(void)getMonthStartDay{
    //计算起始年的第一个月第一天
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
    //NSDateComponents需要先根据时间来初始化
    NSDateComponents *componentsFromyear = [cal components:unitFlags fromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
    componentsFromyear.year = componentsFromyear.year;
    [componentsFromyear setDay:1];;
    [componentsFromyear setHour:0];
    [componentsFromyear setMinute:0];
    [componentsFromyear setSecond:0];
    NSDate *fromday = [cal dateFromComponents:componentsFromyear];
    self.startDate = fromday;

    
}

-(void)getMonthEndDay{
    //计算结束年的最后一个月最后一天
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *componentsToyear = [cal components:unitFlags fromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
    componentsToyear.year = componentsToyear.year;
    componentsToyear.month = componentsToyear.month+1;
    [componentsToyear setDay:1];
     [componentsToyear setHour:0];
    [componentsToyear setMinute:0];
    [componentsToyear setSecond:-1];
    NSDate *toDay = [cal dateFromComponents:componentsToyear];
    
    self.endDate = toDay;
}


#pragma mark UITableViewDataSource protocol conformance
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return monthTableRowCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(void)configCell:(CalenderListCell *)cell atIndex:(NSIndexPath *)index{
    NSDate *selectedDate = [clv_monthDataArray objectAtIndex:selectedMonth];
    NSDate *monthCellDate = [clv_monthDataArray objectAtIndex:index.row];
    cell.monthLabel.text = [monthFormatter stringFromDate:monthCellDate];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if ([appDelegate.epnc monthCompare:monthCellDate withDate:[NSDate date]]==0) {
        cell.monthLabel.textColor = [UIColor colorWithRed:49.f/255.f green:60.f/255.f blue:72.f/255.f alpha:1];
    }
    else
        cell.monthLabel.textColor = [UIColor colorWithRed:96.f/255.f green:114.f/255.f blue:127.f/255.f alpha:1];
    
    
     //判断当前的时间是不是前一个月，或者前两个月，或者下一个月，或者下两个月
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int flags1 = NSMonthCalendarUnit;
    //cell的日期与选中的date的比较相差
    NSDateComponents *component = [cal components:flags1 fromDate:monthCellDate toDate:selectedDate options:nil];
    
   
    
    cell.pastBillImage.hidden = yearFormatter;
    //相差1 == 上一个月
    if (component.month==1)
    {
        NSString *tmpExpireString = [clv_expiredArray objectAtIndex:1];
        if ([tmpExpireString isEqualToString:@"1"])
        {
            cell.pastBillImage.hidden = NO;
        }
        else
            cell.pastBillImage.hidden = YES;
    }
    else if (component.month == 2)
    {
        NSString *tmpExpireString = [clv_expiredArray objectAtIndex:0];
        if ([tmpExpireString isEqualToString:@"1"])
        {
            cell.pastBillImage.hidden = NO;
        }
        else
        {
            cell.pastBillImage.hidden = YES;
        }
    }
    else if(component.month == -1){
        NSString *tmpExpireString = [clv_expiredArray objectAtIndex:3];
        if ([tmpExpireString isEqualToString:@"1"])
        {
            cell.pastBillImage.hidden = NO;
        }
        else
        {
            cell.pastBillImage.hidden = YES;
        }
    }
    else if (component.month == -2){
        NSString *tmpExpireString = [clv_expiredArray objectAtIndex:4];
        if ([tmpExpireString isEqualToString:@"1"])
        {
            cell.pastBillImage.hidden = NO;
        }
        else
        {
            cell.pastBillImage.hidden = YES;
        }
    }
    else
        cell.pastBillImage.hidden = YES;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *listIdentify = @"list";
    CalenderListCell *monthCell = [tableView dequeueReusableCellWithIdentifier:listIdentify];
    if (!monthCell) {
        monthCell = [[CalenderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdentify] ;
        monthCell.accessoryType = UITableViewCellAccessoryNone;
        monthCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configCell:monthCell atIndex:indexPath];
    return monthCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [clv_monthTableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    selectedMonth = indexPath.row;
    
    
    clv_yearLabel.text =  [yearFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
    clv_monthLabel.text = [monthFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.clv_billsViewController.bvc_MonthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
    self.clv_billsViewController.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.clv_billsViewController.bvc_MonthStartDate];
    [self.clv_billsViewController  resetData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == clv_monthTableView && !decelerate) {
        int moveNum = scrollView.contentOffset.y/64;
        [clv_monthTableView setContentOffset:CGPointMake(0, 64*moveNum) animated:YES];
        selectedMonth = moveNum+2;
        
        clv_yearLabel.text =  [yearFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        clv_monthLabel.text = [monthFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        self.clv_billsViewController.bvc_MonthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        self.clv_billsViewController.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.clv_billsViewController.bvc_MonthStartDate];
        
        [self.clv_billsViewController  resetData];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == clv_monthTableView) {
        selectedMonth = (int)(clv_monthTableView.contentOffset.y / 64) + 2;
        [clv_monthTableView setContentOffset:CGPointMake(0, 64*(selectedMonth-2)) animated:NO];
        
        clv_yearLabel.text =  [yearFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        clv_monthLabel.text = [monthFormatter stringFromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        self.clv_billsViewController.bvc_MonthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[clv_monthDataArray objectAtIndex:selectedMonth]];
        self.clv_billsViewController.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.clv_billsViewController.bvc_MonthStartDate];
        
        [self.clv_billsViewController  resetData];
    }
    
}


@end

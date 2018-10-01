//
//  CalendarCell.m
//  TestCal
//
//  Created by wangdong on 3/3/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import "CalendarCell.h"
#import "HelpClass.h"
#import "UIViewAdditions.h"

@interface CalendarCell ()
{
    NSTimeInterval lastUpdate;
    NSIndexPath     *indexPath;
    
    BOOL reloadTaskNow;
    double MonthRowHeight;
}
@end

@implementation CalendarCell
@synthesize hadClearTaskInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ;
    }
    return self;
}

-(void)awakeFromNib
{
    if (IS_IPHONE_6PLUS)
    {
        MonthRowHeight = SCREEN_WIDTH/7;
        dataViewHigh = 50;
    }
    else if (IS_IPHONE_6)
    {
        MonthRowHeight = SCREEN_WIDTH/7;
        dataViewHigh = 30;
    }
    else
    {
        MonthRowHeight = 375/7;
        dataViewHigh = 27;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//获取这段时间内的数据，然后刷新
-(void) setDateArray:(NSArray *)array indexPath:(NSIndexPath *)_indexPath reloadTask:(BOOL) reloadTask
{
    dateView.dateArray = array;
    [dateView  setNeedsDisplay];
    
    lastUpdate = [[NSDate date] timeIntervalSince1970];
    reloadTaskNow = reloadTask;
    hadClearTaskInfo = NO;
    [self reloadDataView];

//    BOOL uploadRightNow = NO;
//    if (reloadTask)
//    {
//        lastUpdate = [[NSDate date] timeIntervalSince1970];
//        reloadTaskNow = reloadTask;
//        hadClearTaskInfo = NO;
//        [self reloadDataView];
//    }
//    else
//    {
//        hadClearTaskInfo = YES;
//        reloadTaskNow = NO;
//        if (lastUpdate == 0 )
//        {
//            lastUpdate = [[NSDate date] timeIntervalSince1970];
//            uploadRightNow = YES;
//        }
//        else
//        {
//            NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
//            NSTimeInterval dis = nowTime - lastUpdate;
//            lastUpdate  = nowTime;
//            uploadRightNow = dis > 0.5;
//        }
//        
////        if (dataView) {
////            [dataView removeFromSuperview];
////            dataView = nil;
////        }
//        
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
//        
////        [dataView clearAllInfo];
//        if (uploadRightNow) {
//            [self reloadDataView];
//        }
//        else
//        {
////            [dataView redrawColorView];
//            [self performSelector:@selector(reloadDataView) withObject:nil afterDelay:0.00];
//        }
//    }
}

-(void) reloadDataView
{
    NSDate *startDate = [dateView.dateArray objectAtIndex:0];
    NSDate *endDate = [[dateView.dateArray lastObject] getEndTimeInDay:NSCalendarTypeTimezone];
    

    


        if (!dataView)
        {
        dataView = [[MonthCalDataView alloc]initWithFrame:CGRectMake(0, MonthRowHeight-dataViewHigh, self.width, dataViewHigh)];
//        dataView.backgroundColor = [UIColor blueColor];
            dataView.userInteractionEnabled = NO;
        [self.contentView addSubview:dataView];
    }
    
//    if (reloadTaskNow) {
//        dataView.alpha = 0.0f;
//    }
    
    [dataView fetchTransactionFromDate:startDate endDate:endDate refreshTask:reloadTaskNow];
//    [dataView fetchEventDataFromDate:startDate endDate:endDate refreshTask:reloadTaskNow];
}

-(NSDate *)firstDate
{
    if (dateView.dateArray.count > 0) {
        return [dateView.dateArray objectAtIndex:0];
    }
    return nil;
}
-(NSDate *)lastDate
{
    if (dateView.dateArray.count > 0) {
        return [dateView.dateArray lastObject];
    }
    return nil;
}

-(NSArray *) dateArray
{
    return dateView.dateArray;
}

//当滚动结束的时候，刷新数据
-(void) reloadTaskInfoWhenScrollEnd
{
    hadClearTaskInfo = NO;
    if (!dataView)
    {
        dataView = [[MonthCalDataView alloc] initWithFrame:CGRectMake(0, MonthRowHeight-dataViewHigh, self.width, dataViewHigh)];
        dataView.userInteractionEnabled = NO;
//        dataView.backgroundColor = [UIColor clearColor];
        [self addSubview:dataView];
    }
//    dataView.backgroundColor = [UIColor redColor];
    
//    NSDate *startDate = [dateView.dateArray objectAtIndex:0];
//    NSDate *endDate = [dateView.dateArray lastObject];
//    [dataView fetchUncompletedTaskDataFromDate:startDate endDate:endDate];

}

//-(void) reloadEventInfoWhenAddorEdit
//{
//    if (!dataView) {
//        dataView = [[CalDataView alloc] init];
//        dataView.userInteractionEnabled = NO;
//        dataView.backgroundColor = [UIColor clearColor];
//        dataView.frame = CGRectMake(0, 0, self.width, MonthRowHeight);
//        [self addSubview:dataView];
//    }
//    NSDate *startDate = [dateView.dateArray objectAtIndex:0];
//    NSDate *endDate = [[dateView.dateArray lastObject] getEndTimeInDay:NSCalendarTypeTimezone];
//    [dataView fetchEventDataFromDate:startDate endDate:endDate refreshTask:NO];
//}

@end

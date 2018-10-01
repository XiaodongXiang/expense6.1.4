//
//  MonthCal2ViewController.h
//  MSCal
//
//  Created by wangdong on 3/6/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WDTouchRemoveView.h"

/*==============日历view,用tableview来设置日历的==================*/
@protocol MonthCalDelegate ;
@interface MonthCal2ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //这个tableview就是日历
    IBOutlet UITableView *_tableView;
    double cellHigh;
}

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, assign) id<MonthCalDelegate> delegate;

//移动到哪一天
//-(void)scrollToDate:(NSDate *)date  animation:(BOOL) animation;
//重新加载tableview的数据
-(void) reloadTableView:(NSDate *)date;
-(CGRect) rectInShowCalendarView:(NSDate *)date;
//-(void)zoomoutDayViewController:(NSDate *)zoomDate FromRect:(CGRect) fromRect;


-(void) redrawMonthViewWhenFirstWeekdayChanged;
//-(void) reloadViewWhenAddOrEditEvent;
-(void) reloadViewWhenAddOrEditTask;
-(void) reloadViewWhenAddOrEditNote;

-(void) transferDateWhenTimezoneChangedFrom:(NSString *) oldZone to:(NSString *) newZone;
-(void) reloadTableView;

-(NSDate *)dateAtMiddle;

@end

@protocol MonthCalDelegate <NSObject>

@optional
-(void)monthCal2ViewController:(MonthCal2ViewController *)monthController showDateStr:(NSString *)showDateStr;

@end
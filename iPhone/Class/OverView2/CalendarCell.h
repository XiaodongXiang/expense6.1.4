//
//  CalendarCell.h
//  TestCal
//
//  Created by wangdong on 3/3/14.
//  Copyright (c) 2014 dongdong.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalDateView.h"
#import "MonthCalDataView.h"
@interface CalendarCell : UITableViewCell
{
    IBOutlet CalDateView *dateView;
    IBOutlet MonthCalDataView *dataView;
    double dataViewHigh;
}
@property (nonatomic, assign) BOOL hadClearTaskInfo;

-(void) setDateArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath reloadTask:(BOOL) reloadTask;

-(void) reloadTaskInfoWhenScrollEnd;
//-(void) reloadEventInfoWhenAddorEdit;

-(NSDate *)firstDate;
-(NSDate *)lastDate;
-(NSArray *)dateArray;
@end

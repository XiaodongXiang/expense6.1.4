//
//  XDCalendarView.h
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CalendarDay,
    CalendarMonth
}CalendarType;

@protocol XDCalendarViewDelegate <NSObject>

@optional
-(void)returnCurrentShowDate:(NSDate*)date;
-(void)returnSelectedDate:(NSDate*)date;
-(void)returnCalendarFrame:(CGRect)rect;
@end

@interface XDCalendarView : UIView
@property(nonatomic, weak)id<XDCalendarViewDelegate> delegate;
@property(nonatomic, assign)CalendarType calendarType;

-(void)reloadCalendarView;

-(void)scrollToToday;
@end

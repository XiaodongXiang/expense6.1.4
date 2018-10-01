//
//  XDCalendarView.m
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDCalendarView.h"
#import "XDMonthCollectionView.h"
#import "XDCalendarClass.h"
#import "XDDayCollectionView.h"
#import "Setting+CoreDataClass.h"
#import "XDDayButton.h"
typedef enum {
    calendarModelDay,
    calendarModelMonth
}calendarModel;



@interface XDCalendarView()<XDMonthCollectionViewDelegate,XDDayCollectionViewDelegate>
{
    CGFloat _selectedDayBtnY;
    __block BOOL _isAnimating;
}
@property(nonatomic,strong)XDMonthCollectionView* monthCollectionView;
@property(nonatomic, strong)XDDayCollectionView * dayCollectionView;
@property(nonatomic, assign)calendarModel calendarModel;

@end
@implementation XDCalendarView

-(void)setCalendarType:(CalendarType)calendarType{
    _calendarType = calendarType;
    if (calendarType == CalendarDay) {
        [self calendarDayShow];
    }else{
        [self calendarMonthShow];
    }
}

- (XDMonthCollectionView *)monthCollectionView{
    if (!_monthCollectionView) {
        _monthCollectionView = [XDMonthCollectionView monthView];
        _monthCollectionView.clipsToBounds = YES;
        _monthCollectionView.monthViewDelegate = self;
        _monthCollectionView.dayViewSelectedDate = [[XDCalendarClass shareCalendarClass] getCurrentDayInitDay];
    }
    return _monthCollectionView;
}

-(XDDayCollectionView *)dayCollectionView{
    if (!_dayCollectionView) {
        _dayCollectionView = [XDDayCollectionView dayView];
        _dayCollectionView.clipsToBounds = YES;
        _dayCollectionView.dayDelegate = self;
        _dayCollectionView.selectedDate = [[XDCalendarClass shareCalendarClass] getCurrentDayInitDay];
    }
    return _dayCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.calendarType = CalendarDay;
        [self addSubview:self.monthCollectionView];
        [self addSubview:self.dayCollectionView];
//        self.dayCollectionView.hidden = YES;
//        self.dayCollectionView.alpha = 0;
//        _selectedDayBtnY = 0;

        self.clipsToBounds = YES;
        
        
        UISwipeGestureRecognizer* swipeUpGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
        swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUpGesture];

        UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
        swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeDownGesture];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dayBtnFrameChange:) name:@"ChangeDayButtonFrame" object:nil];
        
        [self setupWeekLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarFirstDayChange) name:@"calendarFirstDayChange" object:nil];


    }
    return self;
}

-(void)calendarDayShow{
    _calendarType = CalendarDay;
    if (_isAnimating == NO) {
        self.dayCollectionView.alpha = 1;
        self.dayCollectionView.hidden = NO;
        self.dayCollectionView.frame = CGRectMake(0, _selectedDayBtnY+20, [UIScreen mainScreen].bounds.size.width, 53);
        
        [UIView animateWithDuration:0.2 animations:^{
//            self.monthCollectionView.transform = CGAffineTransformMakeScale(1, 1./6.f);
//            self.monthCollectionView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 53);
            self.monthCollectionView.y = -_selectedDayBtnY+20;
            self.dayCollectionView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 53);
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 73);
//            self.monthCollectionView.alpha = 0;
            _isAnimating = YES;
        } completion:^(BOOL finished) {
//            self.monthCollectionView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 53);
//            self.monthCollectionView.hidden = YES;
            _isAnimating = NO;

        }];
        if ([self.delegate respondsToSelector:@selector(returnCalendarFrame:)]) {
            [self.delegate returnCalendarFrame:self.frame];
        }
    }
}

-(void)calendarMonthShow{
    _calendarType = CalendarMonth;

    if (_isAnimating == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            self.monthCollectionView.y = 20;
            self.dayCollectionView.frame = CGRectMake(0, _selectedDayBtnY+20, [UIScreen mainScreen].bounds.size.width, 53);
            self.monthCollectionView.hidden = NO;
            self.monthCollectionView.alpha = 1;
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 338);
            _isAnimating = YES;
        } completion:^(BOOL finished) {
            self.dayCollectionView.hidden = YES;
            self.dayCollectionView.alpha = 0;
            _isAnimating = NO;
        }];
        if ([self.delegate respondsToSelector:@selector(returnCalendarFrame:)]) {
            [self.delegate returnCalendarFrame:self.frame];
        }
    }
}

-(void)swipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (self.calendarType != CalendarDay) {
            [self calendarDayShow];
        }
    }else{
        if (self.calendarType != CalendarMonth) {
            [self calendarMonthShow];
        }
    }
}

-(void)dayBtnFrameChange:(NSNotification*)notif{
    XDDayButton* btn = notif.object;
    if (_selectedDayBtnY != btn.frame.origin.y) {
        _selectedDayBtnY = btn.frame.origin.y;
        if (_calendarType == CalendarDay) {
            self.monthCollectionView.y = -_selectedDayBtnY+20;
        }
    }
}

-(void)calendarFirstDayChange{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    [self setupWeekLabel];
}

-(void)setupWeekLabel{
    
    Setting * setting = [[[XDDataManager shareManager] getObjectsFromTable:@"Setting"]lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *weekdayNames = [dateFormatter shortWeekdaySymbols];
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width/7.f);
    
    NSMutableArray* muarr = [NSMutableArray arrayWithArray:weekdayNames];
    [muarr removeObjectAtIndex:0];
    [muarr addObject:[weekdayNames firstObject]];
    
    if ([setting.others16 integerValue] == 1) {
        for (int i = 0; i<weekdayNames.count; i++) {
            CGRect weekdayFrame = CGRectMake(width * i, 0, width, 20);
            
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor whiteColor];
            weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.font = [UIFont fontWithName:FontSFUITextRegular size:12.];
            weekdayLabel.textColor = RGBColor(200, 200, 200);
            weekdayLabel.text = [weekdayNames objectAtIndex:i];
            weekdayLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            weekdayLabel.layer.borderWidth = 3;
            weekdayLabel.userInteractionEnabled = YES;
            weekdayLabel.clipsToBounds = YES;
            [self addSubview:weekdayLabel];
        }
    }else{
        
        for (int i = 0; i<muarr.count; i++) {
            CGRect weekdayFrame = CGRectMake(width * i, 0, width, 20);
            
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
            weekdayLabel.backgroundColor = [UIColor whiteColor];
            weekdayLabel.textAlignment = NSTextAlignmentCenter;
            weekdayLabel.font = [UIFont fontWithName:FontSFUITextRegular size:12.];
            weekdayLabel.textColor = RGBColor(200, 200, 200);
            weekdayLabel.text = [muarr objectAtIndex:i];
            weekdayLabel.userInteractionEnabled = YES;
            weekdayLabel.clipsToBounds = YES;
            weekdayLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            weekdayLabel.layer.borderWidth = 2;
            [self addSubview:weekdayLabel];
        }
    }
}

#pragma mark - XDMonthCollectionViewDelegate
-(void)returnCurrentMonth:(NSDate *)date{
    if ([self.delegate respondsToSelector:@selector(returnCurrentShowDate:)]) {
        [self.delegate returnCurrentShowDate:date];
    }
}
-(void)returnSelectedDate:(NSDate *)selectedDate{
    if ([self.delegate respondsToSelector:@selector(returnSelectedDate:)]) {
        [self.delegate returnSelectedDate:selectedDate];
    }
    self.dayCollectionView.selectedDate = selectedDate;
}

#pragma mark - XDDayCollectionViewDelegate
-(void)returnDayCollectionViewSelected:(NSDate *)date{
    if ([self.delegate respondsToSelector:@selector(returnSelectedDate:)]) {
        [self.delegate returnSelectedDate:date];
    }
    self.monthCollectionView.dayViewSelectedDate = date;
    [self returnCurrentMonth:date];
}

#pragma mark - other

-(void)reloadCalendarView{
    [self.monthCollectionView reloadData];
    [self.dayCollectionView reloadData];
}


-(void)scrollToToday{
    self.monthCollectionView.dayViewSelectedDate = [[XDCalendarClass shareCalendarClass] getCurrentDayInitDay];
    self.dayCollectionView.selectedDate = [[XDCalendarClass shareCalendarClass] getCurrentDayInitDay];

}

@end

//
//  XDMonthCollectionViewCell.m
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDMonthCollectionViewCell.h"
#import "XDDayButton.h"
#import "XDCalendarClass.h"

@interface XDMonthCollectionViewCell()<XDDayButtonDelegate>
{
    NSMutableDictionary* _muDic;
    NSInteger _lastBtnTag;
    NSDate* _nextMonth;
}
@end

@implementation XDMonthCollectionViewCell
-(void)setSelectedDate:(NSDate *)selectedDate{
        _selectedDate = selectedDate;
        [self setupSelectedBtnWithDate];
    

}

-(void)setCalendarModel:(XDCalendarModel *)calendarModel{
        _calendarModel = calendarModel;
        
        [self setupCalendarModel];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _muDic = [NSMutableDictionary dictionary];
        
        [self initWithCalendarDay];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


-(void)initWithCalendarDay{
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/7;
    CGFloat height = 53;
    
    for (int i = 0; i < 42; i++) {
        
        CGFloat x = i % 7;
        CGFloat y = i / 7;
     
        
        XDDayButton* btn = [[XDDayButton alloc]initWithFrame:CGRectMake(x * width, y*height, width, height)];
        btn.tag = i;
        btn.delegate = self;
        [_muDic setObject:btn forKey:[NSString stringWithFormat:@"%d",i]];
        
        [self.contentView addSubview:btn];
                
    }
}

-(void)setupCalendarModel{
    NSDate* currentMonth = _calendarModel.calendarMonth?:[NSDate date];
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:currentMonth];
    components.month += 1;
    NSDate* nextMonthDate = [GMTCalendar() dateFromComponents:components];
    _nextMonth = nextMonthDate;
    
    for (int i = 0; i < _muDic.count; i++) {
        NSDate* date = _calendarModel.allDaysInMonthArr[i];
        
        XDDayButton* btn = _muDic[[NSString stringWithFormat:@"%d",i]];

        btn.date = date;
        
        if ([date compare:currentMonth] == NSOrderedAscending || [date compare:nextMonthDate] == NSOrderedDescending || [date compare:nextMonthDate] == NSOrderedSame) {
            btn.showCover = YES;
        }else{
            btn.showCover = NO;
        }
    }
}

-(void)setupSelectedBtnWithDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
        
    for (XDDayButton* btn in self.contentView.subviews) {
       
        btn.selected = NO;

        if ([_selectedDate compare:btn.date] == NSOrderedSame && _selectedDate) {

            btn.selected = YES;
            if ([_calendarModel.currentMonthArr containsObject:_selectedDate]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDayButtonFrame" object:btn];
            }
        }
    }
}

-(NSInteger)getDayNumWithModel:(NSDate*)date
{
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:date];
    
    return components.day;
}


-(void)cancelAllBtnSelected{
    for (UIButton* button in self.contentView.subviews) {
        button.selected = NO;
    }
}
#pragma mark - XDDayButtonDelegate
-(void)returnButtonSelected:(XDDayButton *)btn{
    
    for (UIButton* button in self.contentView.subviews) {
        button.selected = NO;
    }
    
    btn.selected = YES;
    
    
    if ([self.monthDelegate respondsToSelector:@selector(returnselectedDayWithDate:)]) {
        [self.monthDelegate returnselectedDayWithDate:btn.date];
    }
    
    if ([self.monthDelegate respondsToSelector:@selector(returnCurrentCellWithSelectedBtn:)]) {
        [self.monthDelegate returnCurrentCellWithSelectedBtn:self];
    }
    
    if ([btn.date compare:_calendarModel.calendarMonth] == NSOrderedAscending || [btn.date compare:_nextMonth] == NSOrderedDescending || [btn.date compare:_nextMonth] == NSOrderedSame) {
        
        if ([self.monthDelegate respondsToSelector:@selector(returnLastOrNextMonthDate:)]) {
            [self.monthDelegate returnLastOrNextMonthDate:btn.date];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDayButtonFrame" object:btn];

}

-(NSDate* )getCurrentMonth:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents* components = [GMTCalendar() components:dayInfoUnits fromDate:date];
    
    return [GMTCalendar() dateFromComponents:components];
}

@end

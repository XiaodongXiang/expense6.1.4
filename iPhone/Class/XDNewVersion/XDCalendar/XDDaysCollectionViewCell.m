//
//  XDDaysCollectionViewCell.m
//  calendar
//
//  Created by 晓东 on 2018/1/8.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import "XDDaysCollectionViewCell.h"
#import "XDDayButton.h"
#import "XDCalendarClass.h"

@interface XDDaysCollectionViewCell()<XDDayButtonDelegate>{
    NSMutableDictionary* _muDic;
}

@end
@implementation XDDaysCollectionViewCell

-(void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [self setupSelectedBtnWithDate];
}

-(void)setDayDataArr:(NSArray *)dayDataArr{
    _dayDataArr = dayDataArr;
    
    [self setupSevenData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _muDic = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor whiteColor];

        [self initWithCalendarDay];
    }
    return self;
}


-(void)initWithCalendarDay{
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < 7; i++) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/7;
        CGFloat height = 53;
        
        XDDayButton* btn = [[XDDayButton alloc]initWithFrame:CGRectMake(i * width, 0, width, height)];
        btn.tag = i;
        btn.delegate = self;
        [_muDic setObject:btn forKey:[NSString stringWithFormat:@"%d",i]];
        
        [self.contentView addSubview:btn];
        
    }
}

-(void)setupSevenData{
    
    for (int i = 0; i < _muDic.count; i++) {
        NSDate* date = _dayDataArr[i];
        
        XDDayButton* btn = _muDic[[NSString stringWithFormat:@"%d",i]];
        
        btn.date = date;

    }
}

-(void)setupSelectedBtnWithDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    for (XDDayButton* btn in self.contentView.subviews) {
        btn.selected = NO;
        
        if ([_selectedDate compare:btn.date] == NSOrderedSame && _selectedDate) {
            
            btn.selected = YES;
        }
    }
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
    
    if ([self.delegate respondsToSelector:@selector(returnDaysSelectedBtn:)]) {
        [self.delegate returnDaysSelectedBtn:btn.date];
    }
}

@end

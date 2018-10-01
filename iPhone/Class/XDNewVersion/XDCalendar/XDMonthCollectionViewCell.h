//
//  XDMonthCollectionViewCell.h
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDCalendarModel.h"

@class XDMonthCollectionViewCell;

@protocol XDMonthCollectionViewCellDelegate<NSObject>

-(void)returnCurrentCellWithSelectedBtn:(XDMonthCollectionViewCell*)cell;
-(void)returnselectedDayWithDate:(NSDate*)date;
-(void)returnLastOrNextMonthDate:(NSDate*)date;

@end

@interface XDMonthCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)XDCalendarModel * calendarModel;
@property(nonatomic, strong)NSDate * selectedDate;

@property(nonatomic, weak)id<XDMonthCollectionViewCellDelegate> monthDelegate;

-(void)cancelAllBtnSelected;
@end

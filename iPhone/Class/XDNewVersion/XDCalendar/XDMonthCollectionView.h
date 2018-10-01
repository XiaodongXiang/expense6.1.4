//
//  XDMonthCollectionView.h
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDMonthCollectionViewDelegate<NSObject>

-(void)returnCurrentMonth:(NSDate*)date;
-(void)returnSelectedDate:(NSDate*)selectedDate;

@end

@interface XDMonthCollectionView : UICollectionView
+(instancetype)monthView;

@property(nonatomic, weak)id<XDMonthCollectionViewDelegate> monthViewDelegate;

@property(nonatomic, strong)NSDate * dayViewSelectedDate;


@end

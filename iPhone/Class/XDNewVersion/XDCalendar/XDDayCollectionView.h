//
//  XDDayCollectionView.h
//  calendar
//
//  Created by 晓东 on 2018/1/3.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDDayCollectionViewDelegate <NSObject>

-(void)returnDayCollectionViewSelected:(NSDate*)date;

@optional
-(void)returnHasData:(BOOL)hasData;
@end
@interface XDDayCollectionView : UICollectionView
@property(nonatomic, weak)id<XDDayCollectionViewDelegate> dayDelegate;
@property(nonatomic, strong)NSDate * selectedDate;

+(instancetype)dayView;

@end

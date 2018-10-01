//
//  XDBillCalCollectionViewCell.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import <UIKit/UIKit.h>
#import "XDCalendarModel.h"

@protocol XDBillCalCollectionDelegate <NSObject>
-(void)returnSelectDate:(NSDate*)date;
-(void)returnOtherMonth:(NSDate*)date;

@end
@interface XDBillCalCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)XDCalendarModel * model;

@property(nonatomic, weak)id<XDBillCalCollectionDelegate> xxdDelegate;
@property(nonatomic, strong)NSDate * selectedDate;

@property(nonatomic, strong)NSMutableArray * dataMuArr;

@end

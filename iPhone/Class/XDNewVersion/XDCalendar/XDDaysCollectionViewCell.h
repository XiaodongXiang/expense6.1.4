//
//  XDDaysCollectionViewCell.h
//  calendar
//
//  Created by 晓东 on 2018/1/8.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDDaysCollectionViewCell;
@protocol  XDDaysCollectionViewCellDelegate<NSObject>
-(void)returnDaysSelectedBtn:(NSDate*)date;
@end
@interface XDDaysCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)NSArray * dayDataArr;

@property(nonatomic, strong)NSDate * selectedDate;
@property(nonatomic, weak)id<XDDaysCollectionViewCellDelegate> delegate;
@end

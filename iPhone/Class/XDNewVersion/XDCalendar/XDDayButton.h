//
//  XDDayButton.h
//  calendar
//
//  Created by 晓东 on 2018/1/2.
//  Copyright © 2018年 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDDayButton;
@protocol XDDayButtonDelegate<NSObject>
-(void)returnButtonSelected:(XDDayButton*)btn;

@end

@interface XDDayButton : UIButton

@property(nonatomic, weak)id<XDDayButtonDelegate> delegate;

@property(nonatomic, strong)UILabel * dayLbl;
@property(nonatomic, strong)UILabel * expenseLbl;
@property(nonatomic, strong)UILabel * incomeLbl;

@property(nonatomic, assign)BOOL showCover;
@property(nonatomic, strong)NSDate * date;


@end

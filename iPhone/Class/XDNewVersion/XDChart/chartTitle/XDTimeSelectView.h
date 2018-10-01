//
//  XDTimeSelectView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/2/27.
//

#import <UIKit/UIKit.h>
#import "XDDateSelectedModel.h"
@protocol XDTimeSelectViewDelegate <NSObject>

-(void)returnFourBtnSelected:(DateSelectedType)type;
-(void)returnSaveBtnClick;
-(void)returnCustomStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

-(void)returnSubTime:(NSDate*)date index:(NSInteger)index;
@end
@interface XDTimeSelectView : UIView

@property(nonatomic, weak)id<XDTimeSelectViewDelegate> delegate;

-(void)refreshUI;


@end

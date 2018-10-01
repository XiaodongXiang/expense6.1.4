//
//  XDBillCalView.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import <UIKit/UIKit.h>

@protocol XDBillCalViewDelegate <NSObject>
-(void)returnSelectedDate:(NSDate*)date;
-(void)returnCurrentMonth:(NSDate*)date;
@end
@interface XDBillCalView : UIView

@property(nonatomic, weak)id<XDBillCalViewDelegate> xxdDelegate;

-(void)refreshUI;

@end

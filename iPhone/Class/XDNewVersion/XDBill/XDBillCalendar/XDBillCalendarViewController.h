//
//  XDBillCalendarViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/30.
//

#import <UIKit/UIKit.h>
#import "BillFather.h"
@protocol XDBillCalendarViewDelegate <NSObject>
-(void)returnCurrentMonthDate:(NSDate*)date;
-(void)returnSelectBillFather:(BillFather*)billFather;

-(void)returnSelectedBillEdit:(BillFather*)billFather;
-(void)returnSelectedDate:(NSDate*)date;
@end

@interface XDBillCalendarViewController : UIViewController
@property(nonatomic, weak)id<XDBillCalendarViewDelegate> xxdDelegate;


-(void)refreshCalendarAndBill;

@end

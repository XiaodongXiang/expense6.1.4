//
//  XDAddBillViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/3/30.
//

#import <UIKit/UIKit.h>

//@class EP_BillRule;
@class BillFather;
@protocol XDAddBillViewDelegate <NSObject>
-(void)returnBillCompletion;
@end

@interface XDAddBillViewController : UIViewController
@property(nonatomic, strong)BillFather * billFather;
@property(nonatomic, weak)id<XDAddBillViewDelegate> delegate;

@property(nonatomic, strong)NSDate * selectedDate;


@end

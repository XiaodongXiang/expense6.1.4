//
//  OverViewMonthViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-3-25.
//
//

#import <UIKit/UIKit.h>

@class KalViewController_week;

@interface OverViewMonthViewController : UIViewController
{
    KalViewController_week *kalViewController;
    id                  calenderDataSource;
    NSDate              *selectedDate;

    NSMutableArray *monthTransactionArray;
    NSDate *monthStartDate;
    NSDate  *monthEndDate;
    NSDateFormatter *dateFormater;
    UILabel     *headTitle;

}
@property(nonatomic,strong) KalViewController_week *kalViewController;
@property(nonatomic,strong) id                  calenderDataSource;
@property(nonatomic,strong) NSDate              *selectedDate;
@property(nonatomic,strong)UILabel     *headTitle;


@property(nonatomic,strong) NSMutableArray *monthTransactionArray;
@property(nonatomic,strong)NSDate *monthStartDate;
@property(nonatomic,strong)NSDate  *monthEndDate;
@property(nonatomic,strong)NSDateFormatter *dateFormater;

-(void)back;
-(void)resetData;
@end

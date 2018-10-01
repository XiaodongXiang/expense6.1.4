//
//  BillsViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-2.
//
//

#import <UIKit/UIKit.h>
#import "CalenderListView.h"

#import "KalView_bill_iPhone.h"
#import "KalLogic_bill_iPhone.h"
#import "KalDataSource_bill_iPhone.h"

#import "BillEditViewController.h"

#import "HMJMonthView.h"
#import "HMJMonthGridView.h"
#import "HMJMonthTileView.h"
#import "HMJMonthLogic.h"
#import "SWTableViewCell.h"

@class PaymentViewController;
@class AccountEditViewController;

@protocol BillsViewDelegate <NSObject>

@optional
-(void)returnSelectedBill:(BillFather*)billFather;
-(void)returnSelectedEditBill:(BillFather*)billFather;
@end

@interface BillsViewController : UIViewController<UIActionSheetDelegate,KalViewDelegate_bill_iPhone, KalDataSourceCallbacks_bill_iPhone,HMJMonthViewDelegate,SWTableViewCellDelegate>
{

    double                      totalPastAmount;
    double                      totalSevenDayAmount;
    double                      totalThirthDayAmount;
    
    double                      totalExpenseAmount;
    double                      totalExpensePaidAmount;
}

@property(nonatomic, weak)id<BillsViewDelegate> delegate;


//righBar View
@property(nonatomic,strong)IBOutlet UIView       *bvc_rightNavBarContainView;
@property(nonatomic,strong)IBOutlet UIButton     *bvc_calenderBtn;
@property(nonatomic,strong)IBOutlet UIButton     *bvc_addBtn;

//bill list contain view
@property(nonatomic,strong)IBOutlet UIView       *billListContainView;
@property(nonatomic,strong)IBOutlet UITableView  *bvc_tableView;
@property(nonatomic,strong)IBOutlet UIView       *noRecordView;
@property(nonatomic,strong)IBOutlet UILabel      *noRecordLabel;

//bill list界面需要的
@property(nonatomic,strong)NSMutableArray        *bl_bill1Array;
@property(nonatomic,strong)NSMutableArray        *bl_bill2Array;
@property(nonatomic,strong)NSMutableArray        *bl_totalBillsArray;
@property(nonatomic,strong)NSMutableArray        *bl_pastMutableArray;
@property(nonatomic,strong)NSMutableArray        *bl_7MutableArray;
@property(nonatomic,strong)NSMutableArray        *bl_30MutableArray;
@property(nonatomic,strong)NSDate                *thirtyDaysLater;
@property(nonatomic,strong)NSDate                *yestary;
@property(nonatomic,strong)NSDate                *sevendaysLater;

//月份日历
@property(nonatomic,strong)IBOutlet UIView       *bvc_kalViewAndMonthViewContainView;
@property(nonatomic,strong)HMJMonthView          *kalView;
@property(nonatomic,strong)HMJMonthLogic         *kalLogic;
@property(nonatomic,strong)KalView_bill_iPhone   *bvc_kalView;
@property(nonatomic,strong)KalLogic_bill_iPhone  *bvc_kalLogic;
@property(nonatomic,strong)id                    dataSource;
//做时间上的变化
@property(nonatomic,strong)NSDateComponents      *c;

@property(nonatomic,strong)NSDate                *bvc_MonthStartDate;
@property(nonatomic,strong)NSDate                *bvc_MonthEndDate;

//array
@property(nonatomic,strong)NSMutableArray        *bvc_Bill1Array;
@property(nonatomic,strong)NSMutableArray        *bvc_bill2Array;
@property(nonatomic,strong)NSMutableArray        *bvc_BillAllArray;
@property(nonatomic,strong)NSMutableArray        *bvc_unpaidArray;
@property(nonatomic,strong)NSMutableArray        *bvc_paidArray;
//存储month日历五个月份底下的过期交易的数组
@property(nonatomic,strong)NSMutableArray        *bvc_monthTableViewExpiredDataArray;

@property(nonatomic,strong)NSDateFormatter       *outputFormatterCell;

@property(nonatomic,strong)NSIndexPath           *swipIndex;
@property(nonatomic,assign)NSInteger             swipIntergerCalendar;
@property(nonatomic,strong)NSIndexPath           *bvc_deleteIndex;
@property(nonatomic,strong)BillFather            *bvc_billFatherCalendar;

//payment view 部件
@property(nonatomic,strong)IBOutlet UIView       *bvc_paymentView;
@property(nonatomic,strong)NSDateFormatter       *bvc_dateFormatter;
@property(nonatomic,strong)IBOutlet UILabel      *bvc_dateLabel;
@property(nonatomic,strong)IBOutlet UIPageControl*bvc_pageControl;
@property(nonatomic,strong)IBOutlet UIImageView  *bvc_categoryImage;
@property(nonatomic,strong)IBOutlet UILabel      *bvc_billName;
@property(nonatomic,strong)IBOutlet UILabel      *bvc_amountLabel;
@property(nonatomic,strong)IBOutlet UIImageView  *bvc_expiredImage;
@property(nonatomic,strong)IBOutlet UIImageView  *bvc_recurringImage;
@property(nonatomic,strong)IBOutlet UIImageView  *bvc_reminderImage;
@property(nonatomic,strong)IBOutlet UILabel      *bvc_recurringLabel;
@property(nonatomic,strong)IBOutlet UILabel      *bvc_reminderLabel;
@property(nonatomic,strong)IBOutlet UIButton     *bvc_cancleBtn;
@property(nonatomic,strong)IBOutlet UIButton     *bvc_payBtn;
@property(nonatomic,assign)NSInteger             bvc_indexOfBill;
@property(nonatomic,strong)NSMutableArray        *bvc_selectedPaymentBillArray;

@property(nonatomic,strong)BillEditViewController*billEditViewController;
@property(nonatomic,strong)PaymentViewController *paymentViewController;


-(void)resetData;
//sync
-(void)refleshUI;

//kalview
- (void)showPreviousMonth;
- (void)showFollowingMonth;
-(void)showSelectedMonth;
-(void)didSelectDate:(KalDate_bill_iPhone *)date;
-(void)getCurrentMonthBillArrayandReloadDayKalView;

//HMJMonthView
- (void)showPrevious5Month;
- (void)showFollowing5Month;

-(void)celldeleteBtnPressed:(HMJButton *)sender isCalenderTableViewBill:(BillFather *)calendarBillFather;
-(void)resetCalendarStyle;



@end

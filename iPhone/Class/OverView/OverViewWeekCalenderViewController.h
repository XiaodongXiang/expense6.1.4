//
//  OverViewWeekCalenderViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-3.
//
//

#import <UIKit/UIKit.h>
#import "AccountsViewController.h"
#import "AccountsViewController.h"
#import "BillsViewController.h"
#import "ExpenseViewController.h"
#import "SettingViewController.h"

#import "MonthCal2ViewController.h"

@class OverViewMonthViewController;
@class KalViewController_week;
@class OverViewBudgetPiCharView;
@class OverViewMonthViewController;
@class TransactionEditViewController;
@class BudgetViewController;
@class BillsViewController;

typedef void(^returnAddBtnClick)(NSDate* date);

@interface OverViewWeekCalenderViewController : UIViewController<UINavigationControllerDelegate,MonthCalDelegate>


@property(nonatomic,strong)IBOutlet UIView      *overViewWeekView;

@property(nonatomic, copy)returnAddBtnClick ClickBlock;


//kalview
@property(nonatomic,strong)IBOutlet UIView              *kalContailView;
@property(nonatomic,strong)id                           calenderDataSource;
@property(nonatomic,strong) KalViewController_week      *kalViewController;
@property(nonatomic,strong)IBOutlet UILabel             *notransactionLabel;
@property (strong, nonatomic) IBOutlet UIView *notransactionImage;
@property(nonatomic,strong)OverViewMonthViewController  *overViewMonthViewController;

@property(nonatomic,strong) NSDate              *oneDayStartDay;
@property(nonatomic,strong) NSDate              *oneDayEndDay;
@property(nonatomic,strong) NSDate              *startDate;//周第一天
@property(nonatomic,strong) NSDate              *endDate;//周最后一天
@property(nonatomic,strong) NSDate				*monthStartDate;//这个月开始的时间
@property(nonatomic,strong) NSDate				*monthEndDate;//这个月结束的时间

@property(nonatomic,strong) NSMutableArray      *weekTransactionArray;
@property(nonatomic,strong) NSMutableArray      *monthTransactionArray;
@property(nonatomic,strong) NSMutableArray      *dayTransactionArray;

@property(nonatomic,strong)AccountSearchViewController      *accountSearchViewController;
@property(nonatomic,strong)SettingViewController            *settingViewController;
//@property(nonatomic,strong)TransactionEditViewController    *transactionEditViewController;
@property(nonatomic,strong)BillsViewController              *billsViewController;

//月份日历
@property(nonatomic,weak)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)MonthCal2ViewController *calViewController;
@property(nonatomic,weak)IBOutlet UIView *headerView;
@property(nonatomic,assign)BOOL isShowMonthCalendar;

@property(nonatomic,strong)UIView *adsView;
//title
@property(nonatomic,assign)NSString *titleYear;
@property(nonatomic,assign)NSString *titleMonth;
-(void)reflashData;
-(void)reflashUI;
-(void)initNavStyle;
-(double)getSelectedMonthNetWorth:(NSDate *)date isMonthViewControllerBalance:(BOOL)isMonthViewControllerBalance;
-(void)getthisWeekAllTransaction;
-(void)resetAllDate;
-(void)movetoSelectedDate:(NSDate *)tmpDate;
-(void)reloadCalendarView;

-(void)resetCalendarStyle;
-(void)resetStyleWithAds;

-(void)getTitleYearAndMonth;
-(void)createAddBtn;
-(void)addSubviewsToHeaderView:(UIView *)headerView withDate:(NSDate *)date;
@end

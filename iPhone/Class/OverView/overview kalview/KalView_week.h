/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalGridView_week, KalLogic_week, KalDate_week;
@protocol KalViewDelegate_week, KalDataSourceCallbacks_week;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *       |                                         |
 *       |           table view (events)           |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */
@interface KalView_week : UIView
{
    UILabel                     *headerTitleLabel;
    UIImageView                 *shadowView;
    KalLogic_week               *logic;
}

@property (nonatomic, strong) id<KalViewDelegate_week>  delegate;
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) UIView                    *balanceView;

@property (nonatomic, strong) KalDate_week              *selectedDate;
@property (nonatomic, strong)KalGridView_week           *gridView;

@property(nonatomic,strong)UILabel                      *expenseAmountLabel;
@property(nonatomic,strong)UILabel                      *incomeAmountLabel;
@property(nonatomic,strong)UILabel                      *balanceAmountLabel;
@property(nonatomic,strong)UIImageView                  *expenseAmountImage;
@property(nonatomic,strong)UIImageView                  *incomeAmountImage;
@property(nonatomic,strong)UIImageView                  *balanceAmountImage;
@property(nonatomic,strong)UILabel                      *expensePercentLabel;
@property(nonatomic,strong)UILabel                      *incomePercentLabel;
@property(nonatomic,strong)UILabel                      *balancePercentLabel;
@property(nonatomic,strong)UIView                       *adsView;
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_week>)delegate logic:(KalLogic_week *)logic;
- (BOOL)isSliding;
- (void)selectDate:(KalDate_week *)date;
- (void)markTilesForDates:(NSArray *)dates;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")
-(void)slideinThisMonth;


//week calender method
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
//- (void)addSubviewsToHeaderView:(UIView *)headerView;
@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate_week

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate_week *)date;
-(void)showCurrentMonth;

@end

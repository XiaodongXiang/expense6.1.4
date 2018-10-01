/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class KalGridView_bill_iPhone, KalLogic_bill_iPhone, KalDate_bill_iPhone;
@protocol KalViewDelegate_bill_iPhone, KalDataSourceCallbacks_bill_iPhone;

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
@interface KalView_bill_iPhone : UIView
{
  UILabel *headerTitleLabel;
  KalGridView_bill_iPhone *gridView;
  UITableView *tableView;
  UIImageView *shadowView;
  id<KalViewDelegate_bill_iPhone> delegate;
  KalLogic_bill_iPhone *logic;
	BOOL isIpadShow;

}

@property (nonatomic, strong) id<KalViewDelegate_bill_iPhone> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) KalDate_bill_iPhone *selectedDate;
@property (nonatomic, assign) BOOL isIpadShow;
@property (nonatomic, strong)UIView *headerView;
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_bill_iPhone>)theDelegate logic:(KalLogic_bill_iPhone *)theLogic withShowModule:(BOOL)m;
- (BOOL)isSliding;
- (void)selectTodayIfVisible;
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
- (void)unpaidmarkTilesForDates;
// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
-(void)slideNone;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")
- (void)addSubviewsToHeaderView:(UIView *)headerView;
@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate_bill_iPhone

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate_bill_iPhone *)date;
//- (void)didSelectDate:(KalDate_bill_iPhone *)date showPanel:(BOOL)showp withFrame:(CGRect )r;

@end

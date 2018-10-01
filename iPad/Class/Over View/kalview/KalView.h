/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

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
@interface KalView : UIView
{
    UIView *kalheaderView;
  UILabel *headerTitleLabel;
  KalGridView *gridView;
  UITableView *tableView;
  id<KalViewDelegate> delegate;
  KalLogic *logic;
    BOOL isBillShow;


    UIView      *balanceView;
    UILabel     *totalAmountLabel;
    UILabel     *paidAmountLabel;
    UILabel     *dueAmountLabel;
    
    
    UILabel     *firstLabel;
    UILabel     *secondLabel;
    UILabel     *thirdLabel;
    UILabel     *forthLabel;
    UILabel     *fifthLabel;
    UILabel     *sixthiLabel;
    UILabel     *seventhLabel;
}
@property (nonatomic, strong)UIView *kalheaderView;
@property (nonatomic, strong) id<KalViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) KalDate *selectedDate;
@property (nonatomic,strong)    KalGridView *gridView;
@property(nonatomic,assign) BOOL isBillShow;
@property(nonatomic,strong)UILabel *headerTitleLabel;
@property(nonatomic,strong) KalLogic *logic;

@property(nonatomic,strong)UIView      *balanceView;
@property(nonatomic,strong)UILabel     *totalAmountLabel;
@property(nonatomic,strong)UILabel     *paidAmountLabel;
@property(nonatomic,strong)UILabel     *dueAmountLabel;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;
- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic withShowModule:(BOOL)m;
- (BOOL)isSliding;
- (void)selectDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
-(void)slideNone;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")


-(void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
- (void)unpaidmarkTilesForDates;
- (void)setHeaderTitleText:(NSString *)text;
-(void)resetWeekStyle:(UIView *)tmpHeaderView;
@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate *)date;
-(void)didSelectDate:(KalDate *)date withFram:(CGRect)r;
@end

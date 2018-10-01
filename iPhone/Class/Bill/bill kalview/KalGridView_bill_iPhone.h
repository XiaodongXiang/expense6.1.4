/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class KalTileView_bill_iPhone, KalMonthView_bill_iPhone, KalLogic_bill_iPhone, KalDate_bill_iPhone;
@protocol KalViewDelegate_bill_iPhone;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 */
@interface KalGridView_bill_iPhone : UIView
{
  id<KalViewDelegate_bill_iPhone> delegate;  // Assigned.
  KalLogic_bill_iPhone *logic;
  KalMonthView_bill_iPhone *frontMonthView;
  KalMonthView_bill_iPhone *backMonthView;
  KalTileView_bill_iPhone *selectedTile;
  KalTileView_bill_iPhone *highlightedTile;
  BOOL transitioning;
	BOOL isIpadShow;
    BOOL isTouch;

}

@property (nonatomic, strong) KalTileView_bill_iPhone *selectedTile;
@property (nonatomic, strong) KalTileView_bill_iPhone *highlightedTile;
@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, readonly) KalDate_bill_iPhone *selectedDate;
@property (nonatomic, assign) BOOL isIpadShow;
@property (nonatomic, assign) BOOL isTouch;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic_bill_iPhone *)theLogic delegate:(id<KalViewDelegate_bill_iPhone>)theDelegate withShowModule:(BOOL)m;
- (void)selectTodayIfVisible;
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1  isTran:(BOOL)isTran ;
- (void)unpaidmarkTilesForDates;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
-(void)slideNone;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end

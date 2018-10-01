/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView_week, KalMonthView_week, KalLogic_week, KalDate_week;
@protocol KalViewDelegate_week;

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
@interface KalGridView_week : UIView
{
  id<KalViewDelegate_week> delegate;  // Assigned.
  KalLogic_week *logic;
  KalMonthView_week *frontMonthView;
  KalMonthView_week *backMonthView;
  KalTileView_week *selectedTile;
  KalTileView_week *highlightedTile;
  BOOL transitioning;
}

@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, strong) KalDate_week *selectedDate;
@property (nonatomic, strong) KalMonthView_week *frontMonthView;
@property (nonatomic, strong) KalMonthView_week *backMonthView;
@property (nonatomic,strong)KalTileView_week *selectedTile;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic_week *)logic delegate:(id<KalViewDelegate_week>)delegate;
- (void)selectDate:(KalDate_week *)date;
- (void)markTilesForDates:(NSArray *)dates;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
- (void)jumpToSelectedMonth;    // see comment on KalView

-(void)slideInThisMonth;
-(void)changeMonthViewToWeekView;

//Week Calender Method
- (void)paidmarkTilesForDates:(NSArray *)dates  withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
@end

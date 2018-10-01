/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView, KalMonthView, KalLogic, KalDate;
@protocol KalViewDelegate;

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
@interface KalGridView : UIView
{
  id<KalViewDelegate> delegate;  // Assigned.
  KalLogic *logic;
  KalMonthView *frontMonthView;
  KalMonthView *backMonthView;
  KalTileView *selectedTile;
  KalTileView *highlightedTile;
  BOOL transitioning;
    BOOL isTouch;
    BOOL isBillShow;
}
//在girdView中关联kalView中的tableView
@property (nonatomic,assign) UITableView *kalTableView;
@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, readonly) KalDate *selectedDate;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic,assign) BOOL isBillShow;
- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalViewDelegate>)delegate;
- (void)selectDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;
- (void)paidmarkTilesForDates:(NSArray *)dates  withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
- (void)unpaidmarkTilesForDates;
// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
-(void)slideNone;
- (void)jumpToSelectedMonth;    // see comment on KalView
-(void)monthViewPackOff;
@end

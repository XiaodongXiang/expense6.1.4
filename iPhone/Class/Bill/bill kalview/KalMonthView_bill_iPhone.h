/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class KalTileView_bill_iPhone, KalDate_bill_iPhone;

@interface KalMonthView_bill_iPhone : UIView
{
  NSUInteger numWeeks;
	
	BOOL isIpadShow;
    double tileHigh;
}

@property (nonatomic) NSUInteger numWeeks;
@property (nonatomic) BOOL isIpadShow;

//- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalTileView_bill_iPhone *)todaysTileIfVisible;
- (KalTileView_bill_iPhone *)firstTileOfMonth;
- (KalTileView_bill_iPhone *)tileForDate:(KalDate_bill_iPhone *)date;
- (void)paidmarkTilesForDates:(NSArray *)dates withDates1:(NSArray *)dates1 isTran:(BOOL)isTran;
 
- (void)unpaidmarkTilesForDates;
- (id)initWithFrame:(CGRect)frame withShowStatus:(BOOL)s ;

@end

/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@protocol KalDataSourceCallbacks_week;

@protocol KalDataSource_week <NSObject, UITableViewDataSource>
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks_week>)delegate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)removeAllItems;

-(void)getCalendarView:(UIViewController *)_calendarView;
-(void)getTableView:(UITableView *)_tableView;


@end

@protocol KalDataSourceCallbacks_week <NSObject>
- (void)loadedDataSource:(id<KalDataSource_week>)dataSource;
@end

#pragma mark -

/*
 *    SimpleKalDataSource
 *    -------------------
 *
 *  A null implementation of the KalDataSource protocol.
 *
 */

@interface SimpleKalDataSource_week: NSObject <KalDataSource_week>
{
}
//+ (SimpleKalDataSource_week*)dataSource;
@end

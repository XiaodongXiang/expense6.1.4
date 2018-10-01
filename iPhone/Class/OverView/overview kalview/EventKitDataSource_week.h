/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal_week.h"
#import <EventKit/EventKit.h>

#import <dispatch/dispatch.h>
#import "OverViewCell.h"
#import "DuplicateTimeViewController.h"
#import "SWTableViewCell.h"

@class EKEventStore, EKEvent,KalViewController_week,DuplicateTimeViewController;

@interface EventKitDataSource_week: NSObject <KalDataSource_week,OverViewCellDelegate,DuplicateTimeViewControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,SWTableViewCellDelegate>
{
  NSMutableArray *items;            // The list of events corresponding to the currently selected day in the calendar. These events are used to configure cells vended by the UITableView below the calendar month view.
  NSMutableArray *events;           // Must be used on the main thread
  EKEventStore *eventStore;         // Must be used on a background thread managed by eventStoreQueue
  dispatch_queue_t eventStoreQueue; // Serializes access to eventStore and offloads the query work to a background thread.
    
    KalViewController_week *calendarView;
    UITableView *eventTableView;
    
    NSIndexPath  *swipCellIndexPath;
    NSDate     *duplicateDate;
    

}

@property(nonatomic,strong)NSIndexPath  *swipCellIndexPath;
@property(nonatomic,strong)NSDate     *duplicateDate;
@property(nonatomic,strong)DuplicateTimeViewController *duplicateDateViewController;

+ (EventKitDataSource_week *)dataSource;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol.

@end

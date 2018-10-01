/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal_bill_iPhone.h"
#import <dispatch/dispatch.h>
#import "SWTableViewCell.h"
@class BillsViewController;
@class EKEventStore, EKEvent;

@interface EventKitDataSource_bill_iPhone : NSObject <KalDataSource_bill_iPhone,UIActionSheetDelegate,UIScrollViewDelegate,SWTableViewCellDelegate>
{
  NSMutableArray *items;            
  NSMutableArray *events;          
  EKEventStore *eventStore;         // Must be used on a background thread managed by eventStoreQueue
  dispatch_queue_t eventStoreQueue; // Serializes access to eventStore and offloads the query work to a background thread.
    
    BillsViewController *calendarView;
    UITableView *eventTableView;
    NSInteger selectedInterger;
    
    float yValue;
    float yValeNow;
    float yOrigan;
    
    NSDateFormatter *dateFormatter;
}

+ (EventKitDataSource_bill_iPhone *)dataSource;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol.

@end

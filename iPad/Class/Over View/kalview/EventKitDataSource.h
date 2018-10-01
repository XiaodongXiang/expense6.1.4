/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"
#import <dispatch/dispatch.h>
#import "ipad_OverViewCell.h"
#import "DuplicateTimeViewController.h"
#import "SWTableViewCell.h"

@class BillsViewController;
@class EKEventStore, EKEvent;

@interface EventKitDataSource : NSObject <KalDataSource,UIActionSheetDelegate,UIScrollViewDelegate,OverViewCellDelegate,DuplicateTimeViewControllerDelegate,SWTableViewCellDelegate>
{
  NSMutableArray *items;            
  NSMutableArray *events;          
  EKEventStore *eventStore;         // Must be used on a background thread managed by eventStoreQueue
  dispatch_queue_t eventStoreQueue; // Serializes access to eventStore and offloads the query work to a background thread.
    
    BillsViewController *calendarView;
    UITableView *eventTableView;
    
    float yValue;
    float yValeNow;
    float yOrigan;
    
    NSDateFormatter *monthDayYearFormatter;
    NSDateFormatter *weekFormatter;
    NSInteger  swipCellIndex;
    NSDate     *duplicateDate;
    
    UIButton *addNewBtn;
    UILabel   *footlabelText;

    DuplicateTimeViewController *duplicateDateViewController;
    
}

@property(nonatomic,assign)NSInteger  swipCellIndex;
@property(nonatomic,strong)NSDate     *duplicateDate;
@property(retain,setter = setaddNewBtn:,getter = addNewBtn) UIButton *addNewBtn;
@property(nonatomic,strong)DuplicateTimeViewController *duplicateDateViewController;
@property(nonatomic,strong)NSMutableArray *selDateBillsArray;

+ (EventKitDataSource *)dataSource;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol.

@end

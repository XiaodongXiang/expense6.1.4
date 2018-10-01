/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource_bill_iPhone.h"
#import <EventKit/EventKit.h>
#import "AppDelegate_iPhone.h"
#import "KalView_bill_iPhone.h"
#import "BillsCell.h"

#import "OverViewWeekCalenderViewController.h"
#import "PaymentViewController.h"
#import "BillEditViewController.h"
#import "HMJButton.h"

#import "BillsViewController.h"
#import "KalDate_bill_iPhone.h"
#import "BillFather.h"
#import "Category.h"
#import "CustomBillCell.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource_bill_iPhone ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventKitDataSource_bill_iPhone

+ (EventKitDataSource_bill_iPhone *)dataSource
{
  return [[[self class] alloc] init] ;
}

- (id)init
{
  if ((self = [super init])) {
    eventStore = [[EKEventStore alloc] init];
    events = [[NSMutableArray alloc] init];
    items = [[NSMutableArray alloc] init];
    eventStoreQueue = dispatch_queue_create("com.thepolypeptides.nativecalexample", NULL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EKEventStoreChangedNotification object:nil];
      
      selectedInterger = -1;
      
      UISwipeGestureRecognizer *swipGuester = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGuesterAction:)];
      [swipGuester setDirection:(UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionDown)];
      [eventTableView  addGestureRecognizer:swipGuester];
      
      dateFormatter = [[NSDateFormatter alloc]init];
      dateFormatter.dateStyle = NSDateFormatterMediumStyle;
      dateFormatter.timeStyle = NSDateFormatterNoStyle;
      [dateFormatter setLocale:[NSLocale currentLocale]];
  }
  return self;
}

////当要滑动tableView的时候保存起始的frame

//---获取KalViewController中的日历
-(void)getCalendarView:(BillsViewController *)_calendarView{
    calendarView = _calendarView;
}
-(void)getTableView:(UITableView *)_tableView{
    eventTableView = _tableView;
}

- (void)eventStoreChanged:(NSNotification *)note
{
//  [[NSNotificationCenter defaultCenter] postNotificationName:KalDataSourceChangedNotification object:nil];
}


- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath
{
  return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *tmpView  = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)]autorelease];
//    tmpView.backgroundColor = [UIColor redColor];
//    return tmpView;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIButton *upandDoneBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 16)]autorelease];
//    [upandDoneBtn setImage:[UIImage imageNamed:@"icon_up.png"] forState:UIControlStateNormal];
//    [upandDoneBtn setImage:[UIImage imageNamed:@"icon_down.png"] forState:UIControlStateSelected];
//    BOOL isselected = eventTableView.frame.origin.y > 0 ?NO:YES;
//    upandDoneBtn.selected = isselected;
//    upandDoneBtn.backgroundColor = [UIColor clearColor];
//    [upandDoneBtn addTarget:self action:@selector(upBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    return upandDoneBtn;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    static NSString *identifier = @"BillsCell";
    CustomBillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)

    {
      cell = [[CustomBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.delegate=self;
        float width;
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            width=53;
        }
        else
        {
            width=63;
        }
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
    }

    [self configCell:cell atIndex:indexPath];
    return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}
-(void)configCell:(CustomBillCell *)cell atIndex:(NSIndexPath *)path
{
    BillFather *onebillfather = [items objectAtIndex:path.row];
    cell.categoryIconImage.image = [UIImage imageNamed:onebillfather.bf_category.iconName];
    cell.nameLabel.text = onebillfather.bf_billName;
    cell.dateLabel.text = [dateFormatter stringFromDate:onebillfather.bf_billDueDate];
    //amount
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    double lestAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([onebillfather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[onebillfather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else{
        [paymentArray setArray:[onebillfather.bf_billItem.billItemHasTransaction allObjects]];
    }
    for (int i=0; i<[paymentArray count]; i++) {
        Transaction *onePayment = [paymentArray objectAtIndex:i];
        if ([onePayment.state isEqualToString:@"1"]) {
            lestAmount += [onePayment.amount doubleValue];
        }
    }
    
    double dueAmount = onebillfather.bf_billAmount-lestAmount;
    if (dueAmount<0) {
        dueAmount = 0;
    }
	cell.amountLabel.text = [appDelegate.epnc formatterString:dueAmount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate_iPhone *appdeledateiPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    NSMutableArray *VCArray=appdeledateiPhone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    if (tmpBillsViewController.swipIntergerCalendar!=-1)
    {
        tmpBillsViewController.swipIntergerCalendar = -1;
        [tmpBillsViewController.bvc_kalView.tableView reloadData];
        return;
    }
    BillFather *seleBillFather = [items objectAtIndex:indexPath.row];
    
    PaymentViewController *paymentViewController = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
    paymentViewController.billFather = seleBillFather;
    
    //隐藏tabbar
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    paymentViewController.hidesBottomBarWhenPushed = TRUE;
    appDelegate.customerTabbarView.hidden = YES;
    
    [tmpBillsViewController.navigationController pushViewController:paymentViewController animated:YES];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    yValue = eventTableView.contentOffset.y;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    yValeNow = eventTableView.contentOffset.y;
//    float dragValue = yValeNow - yValue;
//    
//    float tableViewYValueNow = (eventTableView.frame.origin.y-dragValue)>0?(eventTableView.frame.origin.y-dragValue):0;
//    
//    eventTableView.frame = CGRectMake(eventTableView.frame.origin.x, tableViewYValueNow, eventTableView.frame.size.width, eventTableView.frame.size.height);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if ((targetContentOffset->y < velocity.y) && (eventTableView.frame.origin.y>10) && [items count]>0) {
//        eventTableView.frame = CGRectMake(eventTableView.frame.origin.x, 0, eventTableView.frame.size.width, eventTableView.superview.frame.size.height);
//    }
//    else
//        [[eventTableView.superview viewWithTag:1000] sizeToFit];
//}

-(void)upBtnPressed:(UIButton *)sender{
    if (sender.selected) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [[eventTableView.superview viewWithTag:1000] sizeToFit];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        eventTableView.frame = CGRectMake(eventTableView.frame.origin.x, 0, eventTableView.frame.size.width, eventTableView.superview.frame.size.height);
        [UIView commitAnimations];
    }
    sender.selected = !sender.selected;
}

#pragma mark KalDataSource protocol conformance
//获取整个月的数据
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks_bill_iPhone>)delegate
{
  // asynchronous callback on the main thread
    [events removeAllObjects];
    [items removeAllObjects];
    AppDelegate_iPhone *appdelegateiphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *VCArray=appdelegateiphone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    [events setArray:tmpBillsViewController.bvc_BillAllArray];
    
    [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  // synchronous callback on the main thread
  return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

//获取选中的这一天的数据
-(void)loadItemsforselectedDay
{
    [items removeAllObjects];
    AppDelegate_iPhone *appdelegateiphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    
    NSMutableArray *VCArray=appdelegateiphone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    for (int i=0; i<[events count]; i++)
    {
        BillFather *billfather = [events objectAtIndex:i];

        if ([appdelegateiphone.epnc dateCompare:[tmpBillsViewController.bvc_kalView.selectedDate NSDate]  withDate:billfather.bf_billDueDate]==0)
        {
            [items addObject:billfather];
        }
    }
    
    NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"bf_billDueDate" ascending:NO];
    [items sortUsingDescriptors:[[NSArray alloc] initWithObjects:sort, nil]];
}

- (void)removeAllItems
{
  // synchronous callback on the main thread
  [items removeAllObjects];
}

#pragma mark Btn Action
-(void)celleditBtnPressed:(NSIndexPath *)indexPath{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *VCArray=appDelegate_iphone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    BillsViewController *billsViewController = tmpBillsViewController;
    
    billsViewController.swipIntergerCalendar = -1;
    
    BillEditViewController *billEditViewController = [[BillEditViewController alloc]initWithNibName:@"BillEditViewController" bundle:nil];
    
    BillFather *oneBillFather = [items objectAtIndex:indexPath.row];
    billEditViewController .typeOftodo = @"EDIT";
    billEditViewController .billFather = oneBillFather;
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:billEditViewController];
    [billsViewController presentViewController:navigationViewController animated:YES completion:nil];
 
}
-(void)celldeleteBtnPressed:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *VCArray=appDelegate_iphone.menuVC.navigationControllerArray;
    BillsViewController *tmpBillsViewController=(BillsViewController *)[VCArray objectAtIndex:8];
    
    BillFather *oneBillFather = [items objectAtIndex:indexPath.row];
    [tmpBillsViewController celldeleteBtnPressed:nil isCalenderTableViewBill:oneBillFather];
}

#pragma mark -

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (EKEvent *event in events)
    if (IsDateBetweenInclusive(event.startDate, fromDate, toDate))
      [matches addObject:event];
  
  return matches;
}

#pragma mark ActionSheet delegaet

//- (void)dealloc
//{
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:nil];
//
//  dispatch_sync(eventStoreQueue, ^{
//  });
//  dispatch_release(eventStoreQueue);
//
//    [dateFormatter release];
//  [super dealloc];
//}
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[eventTableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self celleditBtnPressed:indexPath];
            break;
            
        default:
            [self celldeleteBtnPressed:indexPath];
            break;
    }
}
@end

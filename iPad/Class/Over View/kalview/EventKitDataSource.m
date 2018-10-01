/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource.h"
#import <EventKit/EventKit.h>
#import "KalView.h"
#import "KalDate.h"
#import "Category.h"
#import "AppDelegate_iPad.h"
#import "ipad_MainViewController.h"
#import "iPad_OverViewViewController.h"
#import "KalViewController.h"

#import "ipad_OverViewCell.h"
#import "Payee.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "ipad_SearchRelatedViewController.h"
#import "ipad_BillsCell.h"
#import "BillFather.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "BillsCell.h"
#import "ipad_LeftBillsCell.h"
#import "Custom_iPadOverViewCell.h"
#import "Custom_iPad_LeftBBillsCell.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"
#import "ipad_BillEditViewController.h"
static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventKitDataSource
@synthesize swipCellIndex,duplicateDate;
@synthesize addNewBtn,duplicateDateViewController;

+ (EventKitDataSource *)dataSource
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
      
      swipCellIndex = -1;
      
      UISwipeGestureRecognizer *swipGuester = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGuesterAction:)];
      [swipGuester setDirection:(UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionDown)];
      [eventTableView  addGestureRecognizer:swipGuester];
      
      monthDayYearFormatter = [[NSDateFormatter alloc]init];
      [monthDayYearFormatter setDateFormat:@"MMM dd, yyyy"];
      
      weekFormatter = [[NSDateFormatter alloc]init];
      [weekFormatter setDateFormat:@"EEE, "];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
    {
        return 30;
    }
    else
    {
        return EXPENSE_SCALE;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
    {
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 378, 30)];
    NSString *dateString1;
    if ([appDelegate_iPad.epnc dateIsToday:appDelegate_iPad.mainViewController.overViewController.kalViewController.selectedDate]) {
        dateString1 =  [NSString stringWithFormat:@"%@, ",NSLocalizedString(@"VC_Today", nil)];
    }
    else
        dateString1 = [weekFormatter stringFromDate:appDelegate_iPad.mainViewController.overViewController.kalViewController.selectedDate];
    
    NSString *dateString2 = [monthDayYearFormatter stringFromDate:appDelegate_iPad.mainViewController.overViewController.kalViewController.selectedDate];
    NSString *dateString = [NSString stringWithFormat:@"%@%@",dateString1,dateString2];
    
    UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 378, EXPENSE_SCALE)];
    topLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [headerView addSubview:topLine];
    
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 30-EXPENSE_SCALE, 378, EXPENSE_SCALE)];
    bottomLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [headerView addSubview:bottomLine];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, headerView.frame.size.height)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerLabel.textColor = [UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    headerLabel.adjustsFontSizeToFitWidth = YES;
    [headerLabel setMinimumScaleFactor:0];
    headerLabel.text = dateString;
    [headerView addSubview:headerLabel];
    
    //计算总额
    double totalSpend = 0;
    double totalIncome =0;
    for (int i=0; i<[items count]; i++) {
        Transaction *oneTransaction =[items objectAtIndex:i];
        if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
            totalSpend += [oneTransaction.amount doubleValue];
        }
        else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
            totalIncome += [oneTransaction.amount doubleValue];
        }
        else if ([[oneTransaction.childTransactions allObjects]count]>0){
            totalSpend += [oneTransaction.amount doubleValue];
        }

    }

    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(378-15-150, 0, 150, headerView.frame.size.height)];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.textColor = [UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1];
    [amountLabel setFont:[appDelegate_iPad.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    [amountLabel setText:[appDelegate_iPad.epnc formatterString:(totalIncome-totalSpend)]];
    [headerView addSubview:amountLabel];
    
        return headerView;
    }
    else
    {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 378, EXPENSE_SCALE)];
        line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        return line;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 60)];
//    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad_main_cell_310_60.png"]];
//    [footView addSubview:bgImage];
//    
//    addNewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 310, 60)];
//    [addNewBtn setImage:[UIImage imageNamed:@"ipad_new_transaction.png"] forState:UIControlStateNormal];
//    [addNewBtn setImage:[UIImage imageNamed:@"ipad_new_transaction_sel"] forState:UIControlStateHighlighted];
//    addNewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    addNewBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    addNewBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0 , 0, 0);
//    [addNewBtn addTarget:self action:@selector(addNewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [addNewBtn addTarget:self action:@selector(addBtnHighlighted:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragInside];
//    [addNewBtn addTarget:self action:@selector(addBtnNomal:) forControlEvents:UIControlEventTouchDragOutside];
//    [footView addSubview:addNewBtn];
//    
//    footlabelText = [[UILabel alloc]initWithFrame:CGRectMake(39, 0, 200, 60)];
//    [footView addSubview:footlabelText];
//    [footlabelText setText:NSLocalizedString(@"VC_NewTransaction_iPad", nil)];
//    [footlabelText setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
//    [footlabelText setTextColor:[UIColor colorWithRed:12.f/255.f green:164.f/255.f blue:227.f/255.f alpha:1]];
//    [footView addSubview:footlabelText];
//    
//    return footView;
//}

-(void)addBtnHighlighted:(id)sender
{
    [footlabelText setTextColor:[UIColor colorWithRed:94.f/255.f green:99.f/255.f blue:117.f/255.f alpha:1]];
    [addNewBtn setImage:[UIImage imageNamed:@"ipad_new_transaction_sel"] forState:UIControlStateNormal];


}

-(void)addBtnNomal:(id)sender
{
    [footlabelText setTextColor:[UIColor colorWithRed:12.f/255.f green:164.f/255.f blue:227.f/255.f alpha:1]];
    [addNewBtn setImage:[UIImage imageNamed:@"ipad_new_transaction.png"] forState:UIControlStateNormal];

}

//-(void)setaddNewBtn:(id)sender
//{
//    if (addNewBtn.state == UIControlStateHighlighted)
//    {
//        [footlabelText setTextColor:[UIColor grayColor]];
//    }
//    else
//    {
//        [footlabelText setTextColor:[UIColor blueColor]];
//    }
//}
//
//-(UIButton *)addNewBtn{
//    return addNewBtn;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [items count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyCell";
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (appDelegate.mainViewController.currentViewSelect==0)
    {
        Custom_iPadOverViewCell *cell = (Custom_iPadOverViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[Custom_iPadOverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.delegate = self;
            
        }
        cell.tag = indexPath.row;
        
        [self configureTranscationCell:cell atIndexPath:indexPath];
        [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:53];
        return cell;
    }
    else
    {
        Custom_iPad_LeftBBillsCell *cell = (Custom_iPad_LeftBBillsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[Custom_iPad_LeftBBillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        cell.delegate=self;
        [cell setRightUtilityButtons:[self billCellEditBtnsSet] WithButtonWidth:53];
        [self configureBillCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}
-(NSArray *)billCellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:@"sideslip_relation"] selectedIcon:[UIImage imageNamed:@"sideslip_relation_click"]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:@"sideslip_delete"] selectedIcon:[UIImage imageNamed:@"sideslip_delete_click"]];
    return btns;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:@"sideslip_relation"] selectedIcon:[UIImage imageNamed:@"sideslip_relation_click"]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:@"sideslip_copy"] selectedIcon:[UIImage imageNamed:@"sideslip_copy_click"]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:@"sideslip_delete"] selectedIcon:[UIImage imageNamed:@"sideslip_delete_click"]];
    return btns;
}
-(void)configureBillCell:(Custom_iPad_LeftBBillsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    BillFather *onebillfather = [items objectAtIndex:indexPath.row];
    cell.categoryIconImage.image = [UIImage imageNamed:onebillfather.bf_category.iconName];
    cell.nameLabel.text = onebillfather.bf_billName;
    cell.dateLabel.text = [monthDayYearFormatter stringFromDate:onebillfather.bf_billDueDate];
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
- (void)configureTranscationCell:(Custom_iPadOverViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];

        
    Transaction *transactions = [items objectAtIndex:indexPath.row];
    
    if (transactions.payee != nil) {
        cell.nameLabel.text = transactions.payee.name;
    }
    else if ([transactions.notes length]>0)
        cell.nameLabel.text = transactions.notes;
    else
        cell.nameLabel.text = @"-";
    
    //Expense
    if([transactions.category.categoryType isEqualToString:@"EXPENSE"]  ||[transactions.childTransactions count]>0)
    {
        if ([transactions.childTransactions count]>0) {
            cell.categoryIconImage.image = [UIImage imageNamed:@"icon_mind.png"];
            
        }
        else
            cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
        [cell.amountLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        cell.accountNameLabel.text =expenseName;
        
    }
    //Income
    else if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
        [cell.amountLabel setTextColor:[UIColor colorWithRed:46.0/255 green:218.0/255 blue:87.0/255 alpha:1.0]];
        
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        cell.accountNameLabel.text = incomeString;
        
    }
    //transfer
    else{
        cell.categoryIconImage.image = [UIImage imageNamed:@"iocn_transfer.png"];
        [cell.amountLabel setTextColor:[UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1.0]];
        
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        
        cell.accountNameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
        
        
    }
    
    cell.amountLabel.text = [appDelegate.epnc formatterString:[transactions.amount doubleValue]];
    
    return;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.mainViewController.currentViewSelect==0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (self.swipCellIndex != -1) {
            self.swipCellIndex = -1;
            [eventTableView reloadData];
            return;
        }
        
        Transaction *tmpTransaction = (Transaction *)[items objectAtIndex:indexPath.row];
        
        appDelegate.mainViewController.overViewController.iTransactionViewController=[[ipad_TranscactionQuickEditViewController alloc] initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
        appDelegate.mainViewController.overViewController.iTransactionViewController.transaction = tmpTransaction;
        appDelegate.mainViewController.overViewController.iTransactionViewController.typeoftodo = @"IPAD_EDIT";
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:appDelegate.mainViewController.overViewController.iTransactionViewController];
        
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [appDelegate.mainViewController presentViewController:navigationController animated:YES completion:nil];
        //为什么present完再修改fram是有效的呢？
        
        appDelegate.mainViewController.popViewController = navigationController ;

    }
    else
    {
        if (self.swipCellIndex != -1)
        {
            self.swipCellIndex = -1;
            [tableView reloadData];
            return;
        }
        BillFather *oneBillFather= [items objectAtIndex:indexPath.row];
        PokcetExpenseAppDelegate * pckDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //先让pop消失，然后再弹出新的东西
        if([pckDelegate.AddPopoverController isPopoverVisible])
        {
            [pckDelegate.AddPopoverController dismissPopoverAnimated:YES];
        }
        
        AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainViewController.iBillsViewController payBillWithBills:oneBillFather];

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (swipCellIndex!=-1)
    {
        self.swipCellIndex = -1;
        [eventTableView reloadData];
        return;
    }
}

#pragma mark Btn Action
- (IBAction)addNewBtnPressed:(id)sender
{
    [footlabelText setTextColor:[UIColor colorWithRed:12.f/255.f green:164.f/255.f blue:227.f/255.f alpha:1]];
    [addNewBtn setImage:[UIImage imageNamed:@"ipad_new_transaction.png"] forState:UIControlStateNormal];
    
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];

    //1.creat
    appDelegate.mainViewController.overViewController.iTransactionViewController=[[ipad_TranscactionQuickEditViewController alloc]initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    //2.configure
    appDelegate.mainViewController.overViewController.iTransactionViewController.transactionDate = appDelegate.mainViewController.overViewController.kalViewController.selectedDate;
    appDelegate.mainViewController.overViewController.iTransactionViewController.typeoftodo=@"IPAD_ADD";
    appDelegate.mainViewController.overViewController.iTransactionViewController.iOverViewViewController = appDelegate.mainViewController.overViewController;
    
    //3.create navigationViewController
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:appDelegate.mainViewController.overViewController.iTransactionViewController];

    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [appDelegate.mainViewController presentViewController:navigationController animated:YES completion:nil];
    //为什么present完再修改fram是有效的呢？
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           0,
//                                                           480,
//                                                           490
//                                                           );
    appDelegate.mainViewController.popViewController = navigationController ;

}
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
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    //获取这一周 或者这一月的所有数据
//    PokcetExpenseAppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    //直接使用overview页面获取的trans
    if (appDelegate_iPad.mainViewController.currentViewSelect == 0) {
        [events setArray:appDelegate_iPad.mainViewController.overViewController.monthTransactionArray];

    }
    //获取选中的那一天的数据
    [delegate loadedDataSource:self];
    [eventTableView reloadData];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    // synchronous callback on the main thread
    [items removeAllObjects];
    if ([events count] > 0) {
        [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
        
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
        NSArray *sortedArray = [items sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sort, nil]];
        [items setArray:sortedArray];
    }

}
-(void)loadBillItemsFromDate:(NSDate *)date
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];

    [items removeAllObjects];
    
    for (int i = 0;i< [appDelegate_iPad.mainViewController.iBillsViewController.selectedMonthBillAllArray count]; i++)
    {
        BillFather *b = [appDelegate_iPad.mainViewController.iBillsViewController.selectedMonthBillAllArray objectAtIndex:i];
        if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:date] == 0)
        {
            [items addObject:b];
            
        }
        else if([appDelegate_iPad.epnc dateCompare:b.bf_billDueDate withDate:date] == 1)
        {
            break;
        }
    }


}
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  // synchronous callback on the main thread
  return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

//获取选中的这一天的数据
-(void)loadItemsforselectedDay{
    [items removeAllObjects];
    
    for (int i=0; i<[events count]; i++) {
        ;
    }
}

- (void)removeAllItems
{
  // synchronous callback on the main thread
  [items removeAllObjects];
}

#pragma mark -
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (Transaction *event in events)
    if (IsDateBetweenInclusive(event.dateTime, fromDate, toDate))
      [matches addObject:event];
  
  return matches;
}

#pragma mark BtnAction
-(void)cellSearchBtnPressed:(NSIndexPath *)indexPath{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    ipad_SearchRelatedViewController *searchRelatedViewController= [[ipad_SearchRelatedViewController alloc]initWithNibName:@"ipad_SearchRelatedViewController" bundle:nil];
    searchRelatedViewController.transaction = [items objectAtIndex:indexPath.row];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchRelatedViewController];
    
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [appDelegate_iPad.mainViewController.overViewController presentViewController:navigationController animated:YES completion:nil];
    //为什么present完再修改fram是有效的呢？
    appDelegate_iPad.mainViewController.popViewController = navigationController;

}

-(void)cellDuplicateBtnPressed:(NSIndexPath *)indexPath{

    self.duplicateDate = [NSDate date];
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    duplicateDateViewController= [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController" bundle:nil];
    duplicateDateViewController.delegate = self;
    duplicateDateViewController.view.frame = CGRectMake(0, 0, 1024,768);
    [appDelegate_iPhone.mainViewController.view addSubview:duplicateDateViewController.view];
}

-(void)cellDeleteBtnPressed:(NSIndexPath *)indexPath{

    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    Transaction *trans = [items objectAtIndex:indexPath.row];
    
    if (![trans.recurringType isEqualToString:@"Never"]) {
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
//        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        
        swipCellIndex = indexPath.row;
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        UITableViewCell *selectedCell = [eventTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        CGPoint point1 = [eventTableView convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
        [actionsheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
        appDelegate.appActionSheet = actionsheet;
        return;
        
    }
    else
    {
        [appDelegete.epdc deleteTransactionRel:trans];
        swipCellIndex=-1;
        AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPhone.mainViewController.overViewController refleshData];
    }
    
}
-(void)celleditBtnPressed:(NSIndexPath *)indexPath
{
    

    BillFather *billFather = [items objectAtIndex:indexPath.row];
    ipad_BillEditViewController *iBillEditVoewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    
    
    iBillEditVoewController .typeOftodo = @"IPAD_EDIT";
    iBillEditVoewController .billFather = billFather;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:iBillEditVoewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
    
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;

    [eventTableView reloadData];
    
}

-(void)celldeleteBtnPressed:(NSIndexPath *)indexPath isCalenderTableViewBill:(BillFather *)calendarBillFather
{
    
    
    BillFather *billFather = [items objectAtIndex:indexPath.row];
    if (![billFather.bf_billRecurringType isEqualToString:@"Never"])
    {
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to delete this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:billFather.bf_billName];
        NSString *meg = string1;
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        //        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        [actionsheet showFromRect:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-50,[UIScreen mainScreen].bounds.size.height/2.0-50, 100,100) inView:appDelegate.mainViewController.view animated:YES];
        
        appDelegate.appActionSheet = actionsheet;
        
        
        return;
    }
    //非循环 删除BK_Bill BK_Payment
    else
    {
        if (billFather.bf_billRule != nil)
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            NSError *error = nil;
            
            billFather.bf_billRule.state = @"0";
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        
        [items removeObjectAtIndex:indexPath.row];
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
        
    }
    
    [eventTableView reloadData];

}

#pragma mark DuplicateTimeViewController delegate
-(void)setDuplicateDateDelegate:(NSDate *)date
{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (goon)
    {
        Transaction *selectedTrans = [items objectAtIndex:swipCellIndex];
        [appDelegate.epdc duplicateTransaction:selectedTrans withDate:duplicateDate];
    }
    swipCellIndex=-1;
    
    [appDelegate_iPhone.mainViewController.overViewController refleshData];
}

#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.mainViewController.currentViewSelect==0)
    {
        
	if(buttonIndex == 1)
		;
	else
	{
        Transaction *trans = [items objectAtIndex:swipCellIndex];
        
 		[appDelegate.epdc deleteTransactionRel:trans];
        
    }
    swipCellIndex=-1;
        [appDelegate.mainViewController.overViewController refleshData];
    }
    else
    {
        NSError *error = nil;
        
        BillFather *billFather = [items objectAtIndex:swipCellIndex];
        
        if (buttonIndex==2)
        {
            swipCellIndex = nil;
            [eventTableView reloadData];
            return;
        }
        //删除后面所有的bill,billItem，修改transaction
        else if (buttonIndex==1)
        {
            //如果是循环的第一条bill，需要删除这个循环,bill2中相关连的数据
            if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
            {
                
                //删除bill2数组
                NSMutableArray *tmpbill2Array =[[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
                for (int i=0; i<[tmpbill2Array count]; i++) {
                    EP_BillItem *billo = [tmpbill2Array objectAtIndex:i];
                    
                    billo.dateTime = [NSDate date];
                    billo.state = @"0";
                    if (![appDelegate.managedObjectContext save:&error]) {
                        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                        
                    }
                    //                if (appDelegate.dropbox.drop_account.linked) {
                    //                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
                    //                    //                    [appDelegate.managedObjectContext deleteObject:billo];
                    //
                    //                }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                    }
                }
                
                //删除bill
                billFather.bf_billRule.dateTime = [NSDate date];
                billFather.bf_billRule.state = @"0";
                if (![appDelegate.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
                //            if (appDelegate.dropbox.drop_account.linked) {
                //                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
                //            }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
                }
            }
            else
            {
                //---给老bill设置截止日期,删除这日期以后的bill2
                NSMutableArray *bill2array = [[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
                NSMutableArray *deleteBill2array = [[NSMutableArray alloc]init];
                //获取要删除的bill2
                for (int i=0; i<[bill2array count]; i++)
                {
                    EP_BillItem *billo = [bill2array objectAtIndex:i];
                    if ([appDelegate.epnc dateCompare:billo.ep_billItemDueDateNew withDate:billFather.bf_billDueDate]>=0) {
                        [deleteBill2array addObject:billo];
                    }
                }
                
                //删除bill2
                for (int i=0; i<[deleteBill2array count]; i++)
                {
                    EP_BillItem *billo = [deleteBill2array objectAtIndex:i];
                    billo.state = @"0";
                    billo.dateTime = [NSDate date];
                    [appDelegate.managedObjectContext save:&error];
                    //                if (appDelegate.dropbox.drop_account.linked) {
                    //                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
                    //                }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                    }
                }
                
                //修改由 billBrose中的billfather
                NSCalendar *cal = [NSCalendar currentCalendar];
                unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDateComponents *components = [cal components:flags fromDate:billFather.bf_billDueDate];
                [components setMonth:components.month];
                [components setDay:components.day -1 ];
                NSDate *billFatherendDate =[[NSCalendar  currentCalendar]dateFromComponents:components];
                //-----当删除后面所有的账单的时候，要把永久循环设置为NO
                billFather.bf_billRule.ep_billEndDate = billFatherendDate;
                billFather.bf_billRule.dateTime = [NSDate date];
                
                if (![appDelegate.managedObjectContext save:&error])
                {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
                //            if (appDelegate.dropbox.drop_account.linked) {
                //                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
                //            }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
                }
            }
            
            
        }
        //只是本次的bill
        else
        {
            //循环BK_Bill的第一个BK_BillObject,修改BK_Bill duedate
            if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
            {
                if (billFather.bf_billItem!=nil)
                {
                    billFather.bf_billItem.state = @"0";
                    billFather.bf_billItem.dateTime = [NSDate date];
                    if (![appDelegate.managedObjectContext save:&error])
                    {
                        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    }
                    //                if (appDelegate.dropbox.drop_account.linked)
                    //                {
                    //                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billFather.bf_billItem];
                    //                    //                    [appDelegate.managedObjectContext deleteObject:billFather.bf_billItem];
                    //                }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateBillItemFormLocal:billFather.bf_billItem];
                    }
                }
                
                billFather.bf_billRule.ep_billDueDate = [appDelegate.epnc getDate:billFather.bf_billDueDate byCycleType:billFather.bf_billRecurringType];
                billFather.bf_billRule.dateTime = [NSDate date];
                if (![appDelegate.managedObjectContext save:&error])
                {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
                //            if (appDelegate.dropbox.drop_account.linked)
                //            {
                //                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
                //            }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
                }
            }
            else
            {
                //----------在bill2中记下一条记录，并且删除这个bill2对应的payment
                EP_BillItem *deleteBillobject;
                if (billFather.bf_billItem == nil)
                {
                    
                    deleteBillobject = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
                    deleteBillobject.uuid = [EPNormalClass GetUUID];
                }
                else{
                    deleteBillobject =billFather.bf_billItem;
                }
                //配置被删除的bill2对象
                deleteBillobject.ep_billisDelete = [NSNumber numberWithBool:YES];
                deleteBillobject.ep_billItemName = billFather.bf_billName;
                deleteBillobject.ep_billItemAmount = [NSNumber numberWithDouble:billFather.bf_billAmount];
                deleteBillobject.ep_billItemDueDate = billFather.bf_billDueDate;
                if (deleteBillobject.ep_billItemDueDateNew == nil) {
                    deleteBillobject.ep_billItemDueDateNew = billFather.bf_billDueDate;
                }
                deleteBillobject.ep_billItemRecurringType = billFather.bf_billRecurringType;
                deleteBillobject.ep_billItemEndDate = billFather.bf_billEndDate;
                deleteBillobject.ep_billItemNote = billFather.bf_billNote;
                deleteBillobject.ep_billItemReminderDate = billFather.bf_billReminderDate;
                deleteBillobject.ep_billItemReminderTime = billFather.bf_billReminderTime;
                
                deleteBillobject.billItemHasBillRule = billFather.bf_billRule;
                deleteBillobject.billItemHasCategory = billFather.bf_category;
                deleteBillobject.billItemHasPayee = billFather.bf_payee;
                deleteBillobject.billItemHasTransaction = nil;
                
                deleteBillobject.dateTime = [NSDate date];
                deleteBillobject.state = @"1";
                if (![appDelegate.managedObjectContext save:&error])
                {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
                //            if (appDelegate.dropbox.drop_account.linked) {
                //                [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteBillobject];
                //            }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteBillobject];
                }
            }
        }
        
        [items removeObjectAtIndex:swipCellIndex];
        swipCellIndex = nil;
        
        [eventTableView reloadData];
        
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
    }
}


#pragma mark OverViewCell Delegate
-(void)setTableViewIndex:(long)inDexInterger
{
    if (self.swipCellIndex == -1) {
        self.swipCellIndex = inDexInterger;
        [eventTableView reloadData];
    }
    else{
        self.swipCellIndex = -1;
        [eventTableView reloadData];
    }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:nil];
}
#pragma mark - SWTableviewCell Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.mainViewController.currentViewSelect==0)
    {
        NSIndexPath *indexPath=[eventTableView indexPathForCell:cell];
        swipCellIndex=indexPath.row;
    switch (index)
        {
        case 0:
            [self cellSearchBtnPressed:indexPath];
            break;
        case 1:
            [self cellDuplicateBtnPressed:indexPath];
            break;
        default:
            [self cellDeleteBtnPressed:indexPath];
            break;
        }
    }
    else
    {
        NSIndexPath *indexPath=[eventTableView indexPathForCell:cell];
        swipCellIndex=indexPath.row;
        switch (index)
        {
            case 0:
                [self celleditBtnPressed:indexPath];
                break;
            default:
                [self celldeleteBtnPressed:indexPath isCalenderTableViewBill:nil];
                break;
        }
    }
}
@end

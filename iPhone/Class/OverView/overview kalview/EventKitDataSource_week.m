/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource_week.h"
#import <EventKit/EventKit.h>
#import "KalView_week.h"
#import "KalDate_week.h"
#import "KalTileView_week.h"
#import "NSDateAdditions.h"
#import "KalViewController_week.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "OverViewMonthViewController.h"

#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "Payee.h"
#import "OverViewCell.h"
#import "Category.h"
#import "Accounts.h"
#import "TransactionEditViewController.h"

#import "DuplicateTimeViewController.h"
#import "KalLogic_week.h"
#import "SearchRelatedViewController.h"
#import "EPNormalClass.h"
#import "CustomOverViewCell.h"



static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource_week ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventKitDataSource_week
@synthesize swipCellIndexPath,duplicateDate,duplicateDateViewController;

+ (EventKitDataSource_week *)dataSource
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
      
      self.swipCellIndexPath = nil;
      self.duplicateDate = [NSDate date];
      
//      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gridViewPreseeed) name:@"gridview" object:nil];
      
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(swipIndexReset) name:@"swipIndex" object:nil];
      
  }
  return self;
}

//-(void)gridViewPreseeed
//{
//    self.swipCellIndex = -1;
////    [eventTableView.tableView reloadData];
////    return;
//}

-(void)swipIndexReset
{
    self.swipCellIndexPath = nil;
}

//---获取KalViewController中的日历
-(void)getCalendarView:(KalViewController_week *)_calendarView{
    calendarView = _calendarView;
}
-(void)getTableView:(UITableView *)_tableView{
    eventTableView = _tableView;
}

- (void)eventStoreChanged:(NSNotification *)note
{
  [[NSNotificationCenter defaultCenter] postNotificationName:KalDataSourceChangedNotification_week object:nil];
}

#pragma mark BtnAction
-(void)cellSearchBtnPressed:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    SearchRelatedViewController *searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
    searchRelatedViewController.transaction = [items objectAtIndex:indexPath.row];
    searchRelatedViewController.hidesBottomBarWhenPushed = TRUE;
    [appDelegate_iPhone.overViewController.navigationController pushViewController:searchRelatedViewController animated:YES];
}

-(void)cellDuplicateBtnPressed:(NSIndexPath *)indexPath{

    self.duplicateDate = [NSDate date];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    self.duplicateDateViewController= [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController_iPhone" bundle:nil];
    duplicateDateViewController.delegate = self;
    [appDelegate_iPhone.overViewController.view.window addSubview:duplicateDateViewController.view];
}

-(void)cellDeleteBtnPressed:(NSIndexPath *)indexPath{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    Transaction *trans = [items objectAtIndex:indexPath.row];
    
    if (![trans.recurringType isEqualToString:@"Never"])
    {
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionsheet;
        return;

    }
    else
    {
        [appDelegete.epdc deleteTransactionRel:trans];
        self.swipCellIndexPath=nil;
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPhone.overViewController resetAllDate];
//        [eventTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}



#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MyCell";
  CustomOverViewCell *cell = (CustomOverViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell==nil)
  {
    cell = [[CustomOverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

      
  }
    cell.tag = indexPath.row;
    float width;
    if (IS_IPHONE_4)
    {
        width=53;
    }
    else if (IS_IPHONE_5)
    {
        width = 53;
    }
    else
    {
        width=63;
    }
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
    
    cell.delegate = self;

    [self configureTranscationCell:cell atIndexPath:indexPath];
    return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}
-(void)setTableViewIndex:(long)inDexInterger{
    if (self.swipCellIndexPath == nil)
    {
        self.swipCellIndexPath = [NSIndexPath indexPathForRow:inDexInterger inSection:0];
        [eventTableView reloadData];
    }
    else
    {
        self.swipCellIndexPath=nil;
        [eventTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.swipCellIndexPath != nil)
    {
        self.swipCellIndexPath = nil;
        [eventTableView reloadData];
        return;
    }
    self.swipCellIndexPath = nil;
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    Transaction *tmpTransaction = (Transaction *)[items objectAtIndex:indexPath.row];
    

    
    TransactionEditViewController *transactionEditViewController =[[TransactionEditViewController alloc] initWithNibName:@"TransactionEditViewController" bundle:nil];
    transactionEditViewController.transaction = tmpTransaction;
    transactionEditViewController.typeoftodo = @"EDIT";
    UINavigationController *navigationviewcontroller = [[UINavigationController alloc]initWithRootViewController:transactionEditViewController];
    [appDelegate.overViewController presentViewController:navigationviewcontroller animated:YES completion:nil];

    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndexPath!=nil)
    {
        self.swipCellIndexPath = nil;
        [eventTableView reloadData];
        return;
    }
}

#pragma mark UITableViewDataSource protocol conformance
- (void)configureTranscationCell:(CustomOverViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    Transaction *transactions = [items objectAtIndex:indexPath.row];
    
    NSLog(@"dateTime = %@",transactions.dateTime);
    
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
        if ([transactions.childTransactions count]>0)
        {
            cell.categoryIconImage.image = [UIImage imageNamed:@"icon_mind.png"];

            NSMutableArray *childTransactionArray =  [[NSMutableArray alloc]initWithArray:[transactions.childTransactions allObjects ]];
            double totalAmount = 0;
            for (int i=0; i<[childTransactionArray count]; i++)
            {
                Transaction *oneTrans = [childTransactionArray objectAtIndex:i];
                if ([oneTrans.state isEqualToString:@"1"]) {
                    totalAmount += [oneTrans.amount doubleValue];
                }
                
            }
            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:totalAmount];

        }
        else
        {
            cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
            cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];

        }
        cell.amountLabel.textColor=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        cell.accountNameLabel.text =expenseName;
        
    }
    //Income
    else if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.categoryIconImage.image = [UIImage imageNamed:transactions.category.iconName];
        cell.amountLabel.textColor=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
        
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        cell.accountNameLabel.text = incomeString;
        
        cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];

    }
    //transfer
    else
    {
        cell.categoryIconImage.image = [UIImage imageNamed:@"iocn_transfer.png"];
        [cell.amountLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
        
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];

        cell.accountNameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
        
        cell.amountLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];

    }
//    //首页不需要显示这两个icon
//    cell.memoImage.hidden = YES;
//    cell.photoImage.hidden = YES;
    //cycle
//    if (![transactions.recurringType isEqualToString:@"Never"]) cell.cycleImageView.hidden = NO;
//    else
//        cell.cycleImageView.hidden = YES;
    

    
//    if (indexPath.row == [items count]-1) {
//        cell.backgroundImage.image = [UIImage imageNamed:@"cell_320_60.png"];
//    }
//    else
//        cell.backgroundImage.image = [UIImage imageNamed:@"cell_320_60.png"];
    
//    cell.backgroundImage.image = [UIImage imageNamed:@"cell_320_60.png"];
    return;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if ([items count]==0){
        appDelegate_iPhone.overViewController.notransactionLabel.hidden = NO;
        appDelegate_iPhone.overViewController.notransactionImage.hidden=NO;
    }else{
        appDelegate_iPhone.overViewController.notransactionLabel.hidden = YES;
        appDelegate_iPhone.overViewController.notransactionImage.hidden=YES;
    }
  return [items count];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks_week>)delegate
{
    [events removeAllObjects];
    [items removeAllObjects];
    
    
    //获取这一周 或者这一月的所有数据
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSError *error =nil;

   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:fromDate,@"startDate",toDate,@"endDate",nil];
 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    [events setArray:objects1];

    
    //获取选中的那一天的数据
    [delegate loadedDataSource:self];
    [eventTableView reloadData];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    
    if (appDelegate.overViewController.overViewMonthViewController == nil) {
        [appDelegate.overViewController.kalViewController.kalView paidmarkTilesForDates:events withDates1:nil isTran:YES];
    }
    else
    {
        NSMutableArray *transactionArray_lastMonth = [[NSMutableArray alloc]init];
        NSDate *lastMonth_StartDate = [appDelegete.epnc getPerDate:fromDate byCycleType:@"Monthly"];
        NSDate *lastMonth_EndDate = [appDelegete.epnc getPerDate:toDate byCycleType:@"Monthly"];
        NSDictionary *subs_lastMonth = [NSDictionary dictionaryWithObjectsAndKeys:lastMonth_StartDate,@"startDate",lastMonth_EndDate,@"endDate",nil];
        
        NSFetchRequest *fetchRequest_lastMonth = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs_lastMonth];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest_lastMonth setSortDescriptors:sortDescriptors];
        
        NSArray *objects1_lastMonth = [[NSArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest_lastMonth error:&error]];
        [transactionArray_lastMonth setArray:objects1_lastMonth];
     
        
        double lastMonth_netWorth = [appDelegate.overViewController getSelectedMonthNetWorth:lastMonth_EndDate isMonthViewControllerBalance:YES];
        double thisMonth_netWorth = [appDelegate.overViewController getSelectedMonthNetWorth:toDate isMonthViewControllerBalance:YES];
        
        [self calculateAllMonthTransactionWithLastMonthTransaction:transactionArray_lastMonth withLastNetWorth:lastMonth_netWorth withThisMonthNetWorth:thisMonth_netWorth];
        
        [appDelegate.overViewController.overViewMonthViewController.kalViewController.kalView paidmarkTilesForDates:events withDates1:nil isTran:YES];
//        [appDelegate.overViewController setBudgetSouceAndLayOut_NS];
        
    }
    
}

-(void)calculateAllMonthTransactionWithLastMonthTransaction:(NSMutableArray *)lastMonthTransaction withLastNetWorth:(double)tmpLastNetWorth withThisMonthNetWorth:(double)tmpThisNetWorth
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    //在month页面
    if (appDelegate.overViewController.overViewMonthViewController != nil)
    {
        //calculate this month transaction
        double totalSpend = 0;
        double totalIncome =0;
//        double balance = 0;
        for (int i=0; i<[events count]; i++)
        {
            Transaction *oneTransaction =[events objectAtIndex:i];
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
        
//        balance = totalIncome - totalSpend;
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        appDelegate.overViewController.overViewMonthViewController.kalViewController.kalView.expenseAmountLabel.text = [appDelegate.epnc formatterStringWithOutPositive:totalSpend];
        appDelegate.overViewController.overViewMonthViewController.kalViewController.kalView.incomeAmountLabel.text = [appDelegate.epnc formatterStringWithOutPositive:totalIncome];
        appDelegate.overViewController.overViewMonthViewController.kalViewController.kalView.balanceAmountLabel.text = [appDelegate.epnc formatterStringWithOutPositive:tmpThisNetWorth];
        
        //calculate last month transaction
        double totalSpend_lastMonth = 0;
        double totalIncome_lastMonth =0;
//        double balance_lastMonth = 0;
        
        
        for (int i=0; i<[lastMonthTransaction count]; i++)
        {
            Transaction *oneTransaction =[lastMonthTransaction objectAtIndex:i];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                totalSpend_lastMonth += [oneTransaction.amount doubleValue];
            }
            else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
                totalIncome_lastMonth += [oneTransaction.amount doubleValue];
            }
            else if ([[oneTransaction.childTransactions allObjects]count]>0){
                totalSpend_lastMonth += [oneTransaction.amount doubleValue];
            }
        }
//        balance_lastMonth = totalIncome_lastMonth - totalSpend_lastMonth;
        
        //compare
        KalView_week *tmpKalView = appDelegate.overViewController.overViewMonthViewController.kalViewController.kalView;
        
        //expense
        double expensePercent;
        if (totalSpend_lastMonth != 0) {
            expensePercent = fabs(totalSpend - totalSpend_lastMonth)/totalSpend_lastMonth * 100;
        }
        else if(totalSpend == 0)
            expensePercent = 0.00;
        else
            expensePercent = 100;
        if (totalSpend_lastMonth > totalSpend)
        {
            tmpKalView.expenseAmountImage.image = [UIImage imageNamed:@"arrow2_10_90.png"];
//            tmpKalView.expenseAmountImage.frame = CGRectMake(10, 35, 30, 30);
        }
        else if(totalSpend_lastMonth < totalSpend)
        {
            tmpKalView.expenseAmountImage.image = [UIImage imageNamed:@"arrow_10_90.png"];
//            tmpKalView.expenseAmountImage.frame = CGRectMake(10, 35, 30, 30);
        }
        else
        {
            tmpKalView.expenseAmountImage.image = [UIImage imageNamed:@"arrow4.png"];
//            tmpKalView.expenseAmountImage.frame = CGRectMake(10, 35, 30,30);
        }
        //expense amount color
        if (totalSpend>0)
            tmpKalView.expenseAmountLabel.textColor = [appDelegate.epnc getAmountRedColor];
        else if (totalSpend == 0)
            tmpKalView.expenseAmountLabel.textColor = [appDelegate.epnc getAmountGrayColor];
        
        tmpKalView.expensePercentLabel.text = [[NSString stringWithFormat: @"%.2f",expensePercent] stringByAppendingString:@"%"];
        
        ///////////////income
        double incomePercent = 0.00;
        if (totalIncome_lastMonth != 0) {
            incomePercent = fabs(totalIncome - totalIncome_lastMonth)/totalIncome_lastMonth * 100;
        }
        else if(totalIncome == 0)
            incomePercent = 0;
        else
            incomePercent = 100;
        if (totalIncome_lastMonth > totalIncome)
        {
            tmpKalView.incomeAmountImage.image = [UIImage imageNamed:@"arrow2_10_90.png"];
//            tmpKalView.incomeAmountImage.frame = CGRectMake(10+everyWith, 35, 30, 30);
        }
        else if(totalIncome_lastMonth < totalIncome)
        {
            tmpKalView.incomeAmountImage.image = [UIImage imageNamed:@"arrow_10_90.png"];
//            tmpKalView.incomeAmountImage.frame = CGRectMake(10+everyWith, 35, 30, 30);
        }
        else
        {
            tmpKalView.incomeAmountImage.image = [UIImage imageNamed:@"arrow4.png"];;
//            tmpKalView.incomeAmountImage.frame = CGRectMake(11+everyWith, 35, 30, 30);
        }
        //income amount color
        if (totalIncome>0)
            tmpKalView.incomeAmountLabel.textColor = [appDelegate.epnc getAmountGreenColor];
        else if (totalIncome == 0)
            tmpKalView.incomeAmountLabel.textColor = [appDelegate.epnc getAmountGrayColor];
        tmpKalView.incomePercentLabel.text = [[NSString stringWithFormat: @"%.2f",incomePercent] stringByAppendingString:@"%"];
    
        //////////////balance
        double balancePercent;
        if (tmpLastNetWorth != 0)
        {
            balancePercent = fabs(tmpThisNetWorth - tmpLastNetWorth)/fabs(tmpLastNetWorth) * 100;
        }
        else if(tmpThisNetWorth == 0)
            balancePercent = 0;
        else
            balancePercent = 100;
        if (tmpLastNetWorth > tmpThisNetWorth)
        {
            tmpKalView.balanceAmountImage.image = [UIImage imageNamed:@"arrow2_10_90.png"];
//            tmpKalView.balanceAmountImage.frame = CGRectMake(10+everyWith*2+2, 35, 30, 30);
        }
        else if(tmpLastNetWorth < tmpThisNetWorth)
        {
            tmpKalView.balanceAmountImage.image = [UIImage imageNamed:@"arrow_10_90.png"];
//            tmpKalView.balanceAmountImage.frame = CGRectMake(10+everyWith*2+2, 35, 30, 30);
        }
        else
        {
            tmpKalView.balanceAmountImage.image = [UIImage imageNamed:@"arrow4.png"];
//            tmpKalView.balanceAmountImage.frame = CGRectMake(11+everyWith*2, 35, 30, 30);
        }
        //balance amount textcolor
        if (tmpThisNetWorth>0)
            tmpKalView.balanceAmountLabel.textColor = [appDelegate.epnc getAmountGreenColor];
        else if (tmpThisNetWorth < 0)
            tmpKalView.balanceAmountLabel.textColor = [appDelegate.epnc getAmountRedColor];
        else
            tmpKalView.balanceAmountLabel.textColor = [appDelegate.epnc getAmountGrayColor];
        tmpKalView.balancePercentLabel.text = [[NSString stringWithFormat: @"%.2f",balancePercent] stringByAppendingString:@"%"];
    }
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  // synchronous callback on the main thread
  return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  // synchronous callback on the main thread
    [items removeAllObjects];
    if ([events count] > 0)
    {
        [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
        NSArray *sortedArray = [items sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sort, nil]];
        [items setArray:sortedArray];
    }
}

- (void)removeAllItems
{
  // synchronous callback on the main thread
  [items removeAllObjects];
}

#pragma mark -
- (Transaction *)eventAtIndexPath:(NSIndexPath *)indexPath
{
    return [items objectAtIndex:indexPath.row];
}

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (Transaction *event in events)
    if (IsDateBetweenInclusive(event.dateTime, fromDate, toDate))
    {
        [matches addObject:event];

    }
  
  return matches;
}



#pragma mark DuplicateTimeViewController delegate
-(void)setDuplicateDateDelegate:(NSDate *)date{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (goon)
    {
       
        Transaction *selectedTrans = [items objectAtIndex:self.swipCellIndexPath.row];
        [appDelegate.epdc duplicateTransaction:selectedTrans withDate:self.duplicateDate];

        self.swipCellIndexPath=nil;
        [appDelegate_iPhone.overViewController resetAllDate];
    }
    else
    {
        self.swipCellIndexPath=nil;
        [appDelegate_iPhone.overViewController resetAllDate];

    }
}

#pragma mark UIAlertView Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

	if(buttonIndex == 1)
		;
	else
	{
        Transaction *trans = [items objectAtIndex:self.swipCellIndexPath.row];

 		[appDelegate_iPhone.epdc deleteTransactionRel:trans];
        
    }
    self.swipCellIndexPath=nil;
    
    [appDelegate_iPhone.overViewController resetAllDate];
}
#pragma mark - SWTableviewCell Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[eventTableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self cellSearchBtnPressed:indexPath];
            swipCellIndexPath=indexPath;
            break;
        case 1:
            [self cellDuplicateBtnPressed:indexPath];
            swipCellIndexPath=indexPath;
            break;
        default:
            [self cellDeleteBtnPressed:indexPath];
            swipCellIndexPath=indexPath;
            break;
    }
}

@end

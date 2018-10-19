//
//  ipad_ReportCashFlowViewController.m
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import "ipad_ReportCashFlowViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_ReportCategotyViewController.h"
#import "ipad_ReportCashFlowCell.h"
#import "ReportBrokenLineView.h"
#import "ipad_DateRangeTransactionViewController.h"
#import "TranDataRect.h"
@import Firebase;
@implementation BarChartData
@synthesize totalAmount;
@synthesize  tranArray;
@synthesize titleString;
@synthesize startDate;
@synthesize endDate;
@synthesize brokenLineTitle;
- (id)init{
    if (self = [super init])
	{
        tranArray =[[NSMutableArray alloc] init];
        titleString = @"-";
        
    }
    return self;
}


@end


@interface ipad_ReportCashFlowViewController ()

@end

@implementation ipad_ReportCashFlowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化指针，以及需要的数组。
    [self initPoint];
    [FIRAnalytics setScreenName:@"report_cashflow_main_view_ipad" screenClass:@"ipad_ReportCashFlowViewController"];
}

-(void)initPoint
{

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    totalExpenseAmount = 0;
    totalIncomeAmount = 0;
    
    [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisYear", nil)forState:UIControlStateNormal];
    [_thisYearBtn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    [_lastYearBtn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    [_LastTweleveBtn setTitle:NSLocalizedString(@"VC_Last12Months", nil) forState:UIControlStateNormal];
    _thisYearBtn.selected = YES;
    _lastYearBtn.selected = NO;
    _LastTweleveBtn.selected = NO;
    
    _totalTextLabel.text = NSLocalizedString(@"VC_Total", nil);

    
    _cashStartDate =[appDelegate.epnc getStartDate:@"This Year"];
    _cashEndDate = [appDelegate.epnc getEndDate: _cashStartDate withDateString:@"This Year"];
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    [_dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [_totalExpenseLabe setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:20]];
    [_totalIncomeLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:20]];

    _transactionByDateArray = [[NSMutableArray alloc]init];
    
    
    //btn action
    [_dateDurBtn addTarget:self action:@selector(dateDurBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_thisYearBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_lastYearBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_LastTweleveBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //selected
    
    [_thisYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_lastYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_LastTweleveBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    

    
    //highlighted
    [_thisYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_lastYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_LastTweleveBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    
    
    //selected && higthlighted
    [_thisYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_lastYearBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_LastTweleveBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    //未选中时候的颜色
    [_thisYearBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_lastYearBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_LastTweleveBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    
    
    //dataSelBtn textLabel Fram
    [_thisYearBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_lastYearBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_LastTweleveBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    
    [_thisYearBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_lastYearBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_LastTweleveBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
   
    _yValue1.backgroundColor = [UIColor clearColor];
    _yValue2.backgroundColor = [UIColor clearColor];
    _yValue3.backgroundColor = [UIColor clearColor];
    _yValue4.backgroundColor = [UIColor clearColor];
    _yValue5.backgroundColor = [UIColor clearColor];
    _yValue6.backgroundColor = [UIColor clearColor];
    
    
    _dateDurBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_dateDurBtn.titleLabel setMinimumScaleFactor:0];
    _dateRangeSelView.hidden = YES;
    
    
    _bgImageView.frame = CGRectMake(_bgImageView.frame.origin.x,_bgImageView.frame.origin.y, _bgImageView.frame.size.width, 36*3+16);
    [_bgImageView setImage:[[UIImage imageNamed:@"ipad_pop_154_88.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 30, 0)]];
    _barChartView.contentSize = CGSizeMake(365/7 * 12, _barChartView.frame.size.height);
    
    [_totalExpenseLabe setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:20]];
    [_totalIncomeLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:20]];

    [_totalExpenseLabe setTextColor:[appDelegate.epnc getAmountRedColor]];
    [_totalIncomeLabel setTextColor:[appDelegate.epnc getAmountGreenColor]];
}



#pragma mark resetData
////每次从其他页面进入这个页面的时候都会重新设置参数，刷新数据。
-(void)reFlashTableViewData
{
    //获取有transaction的category数据
    [self getCashFlowData];
    [_cashFlowTable reloadData];
}


#pragma mark getPicharview Data
//获取picharview的数组
-(void)getCashFlowData
{
    if (_thisYearBtn.selected)
    {
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    }
    else if (_lastYearBtn.selected)
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    else
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_Last12Months", nil)  forState:UIControlStateNormal];


    
    NSString *tmpString1 = [_dateFormatter stringFromDate:_cashStartDate];
    NSString *tmpString2 = [_dateFormatter stringFromDate:_cashEndDate];
    _dateLabel.text = [NSString stringWithFormat:@"%@ － %@",tmpString1,tmpString2];
    
    ////////////////////////Cash Report
    //获取这段时间内的交易
    NSError *error = nil;
    if (![self fetchedResultsByDateController_getData]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    [_transactionByDateArray removeAllObjects];
    
    //创建cash report需要的最初的不带有值的数组存放于transactionByDateArray中
    [self createCashArray];
    
    //将获取的transaction替换掉最初的数据， 存储brokenline数组设置expense amount,income amount,transaction array
    [self calculateSortArrayandReplaceCashArray];
    //设置折现图中的数据
    [self setBarChartViewData];
    [_cashFlowTable reloadData];

}

-(void)createCashArray
{
    [_transactionByDateArray removeAllObjects];
    
    unsigned flag1 = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    NSDateComponents *dateComponent =  [[NSCalendar currentCalendar]components:flag1 fromDate:_cashStartDate];
    
    for (int i=0; i<12; i++)
    {
        NSDate *oneDate = [[NSCalendar  currentCalendar]dateFromComponents:dateComponent];
        BrokenLineObject *oneBrokenLineObject = [[BrokenLineObject alloc]initWithDay:oneDate];
        [_transactionByDateArray addObject:oneBrokenLineObject];
        dateComponent.year = dateComponent.year;
        dateComponent.month = dateComponent.month + 1;
    }
}
-(void)calculateSortArrayandReplaceCashArray
{
    //获取数组的个数
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //计算某一个月份最大的金额
    double maxOfBarAmount = 0;
    for (long i=0; i<[[self.fetchedResultsByDateController sections] count]; i++)
    {
        //获取每个section的总expense amount,income amount
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsByDateController sections]objectAtIndex:i];
        double  itemTotalExpenseAmount = 0;
        double  itemTotalIncomeAmount = 0;
        
        for (long int k=0;k<[sectionInfo numberOfObjects]; k++)
        {
            Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:k];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"])
            {
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
            else if(oneTransaction.category == nil && oneTransaction.expenseAccount!= nil ){
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if (oneTransaction.category ==nil && oneTransaction.incomeAccount!= nil){
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
        }
        double maxBetwenExpenseandIncome = itemTotalExpenseAmount>itemTotalIncomeAmount?itemTotalExpenseAmount:itemTotalIncomeAmount;
        maxOfBarAmount = maxOfBarAmount>maxBetwenExpenseandIncome?maxOfBarAmount:maxBetwenExpenseandIncome;
    }
    
    //计算每一部分占最大金额的百分比
    for (long i=0; i<[[self.fetchedResultsByDateController sections] count]; i++)
    {
        //获取每个section的总expense amount,income amount
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsByDateController sections]objectAtIndex:i];
        double  itemTotalExpenseAmount = 0;
        double  itemTotalIncomeAmount = 0;
        
        for (long int k=0;k<[sectionInfo numberOfObjects]; k++)
        {
            Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:k];
            if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"])
            {
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"])
            {
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
            else if(oneTransaction.category == nil && oneTransaction.expenseAccount!= nil ){
                itemTotalExpenseAmount += [oneTransaction.amount doubleValue];
            }
            else if (oneTransaction.category ==nil && oneTransaction.incomeAccount!= nil){
                itemTotalIncomeAmount += [oneTransaction.amount doubleValue];
            }
        }
        
        //将获取到的section信息 替换cash array中的数据
        Transaction *oneTransaction = [[sectionInfo objects]objectAtIndex:0];
        NSDate *oneDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:oneTransaction.dateTime];
        
        
        for (int k=0; k<12; k++) {
            BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:k];
            if ([appDelegate.epnc monthCompare:oneDate withDate:oneBrokenLineObject.dateTime]==0) {
                oneBrokenLineObject.expenseAmount = itemTotalExpenseAmount;
                oneBrokenLineObject.incomeAmount = itemTotalIncomeAmount;
                [oneBrokenLineObject.thisDaytTransactionArray removeAllObjects];
                [oneBrokenLineObject.thisDaytTransactionArray setArray:[sectionInfo objects]];
                oneBrokenLineObject.maxAmount = maxOfBarAmount;
                break;
            }
        }
    }
    
    
    totalIncomeAmount = 0;
    totalExpenseAmount = 0;
    for (int k=0; k<12; k++) {
        BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:k];
        totalExpenseAmount += oneBrokenLineObject.expenseAmount;
        totalIncomeAmount += oneBrokenLineObject.incomeAmount;
    }
    
    _totalExpenseLabe.text = [appDelegate.epnc formatterString:totalExpenseAmount];
    _totalIncomeLabel.text = [appDelegate.epnc formatterString:totalIncomeAmount];
}
-(void)setBarChartViewData
{
    double w = 365/7.0;
    NSDateFormatter *tmpMonthFormatter =[[NSDateFormatter alloc]init];
    [tmpMonthFormatter setDateFormat:@"MMM"];
    for (UIView *view in [_barChartView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i =0;i<[_transactionByDateArray count] ;   i++)
    {
        BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:i];
        
        TranDataRect *tdRect= [[TranDataRect alloc] initWithFrame: CGRectMake(w*i, 0,w ,_barChartView.frame.size.height )];
        tdRect.dateStringLabel.text = [[tmpMonthFormatter stringFromDate:oneBrokenLineObject.dateTime]uppercaseString];
        [tdRect setViewByMaxValue:oneBrokenLineObject.maxAmount withIncAmount:oneBrokenLineObject.incomeAmount withExpAmount:oneBrokenLineObject.expenseAmount anmtied:FALSE];
        [_barChartView addSubview:tdRect];
    }
}

-(void)dateDurBtnPressed:(id)sender
{
    if (_dateRangeSelView.hidden)
    {
        _dateRangeSelView.hidden = NO;
    }
    else
        _dateRangeSelView.hidden = YES;
}

-(void)resetCashFlowBtnState
{
    _thisYearBtn.selected = NO;
    _lastYearBtn.selected = NO;
    _LastTweleveBtn.selected = NO;
}


-(void)cashFlowTimeBtnPressed:(UIButton *)sender
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    
    if ((_thisYearBtn.selected && sender==_thisYearBtn) || (_lastYearBtn.selected && sender == _lastYearBtn) || (_LastTweleveBtn.selected && sender==_LastTweleveBtn))
    {
        _dateRangeSelView.hidden = YES;
        return;
        
    }
    else if (sender==_thisYearBtn)
    {
        _thisYearBtn.selected = YES;
        _LastTweleveBtn.selected = NO;
        _lastYearBtn.selected = NO;
        
        _cashStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    }
    else if (sender==_lastYearBtn)
    {
        _lastYearBtn.selected = YES;
        _thisYearBtn.selected = NO;
        _LastTweleveBtn.selected = NO;
        
        component.year = component.year-1;
        component.month = 1;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _cashStartDate = [cal dateFromComponents:component];
        _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    }
    else
    {
        
        _LastTweleveBtn.selected = YES;
        _thisYearBtn.selected = NO;
        _lastYearBtn.selected = NO;
        component.year = component.year;
        component.month = component.month -11;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _cashStartDate = [cal dateFromComponents:component];
        NSDateComponents *comp2 = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:_cashStartDate];
        [comp2 setYear:1];
        [comp2 setMonth:0];
        [comp2 setDay:-1];
        [comp2 setHour:23];
        [comp2 setMinute:59];
        [comp2 setSecond:59];
        
        _cashEndDate =  [cal dateByAddingComponents:comp2 toDate:_cashStartDate options:0];
    }
    
    _dateRangeSelView.hidden = YES;
    [self getCashFlowData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_transactionByDateArray  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ipad_ReportCashFlowCell *cell = (ipad_ReportCashFlowCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ipad_ReportCashFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    [self configureReportCategoryCell:cell atIndexPath:indexPath withTableView:tableView ];
    return cell;
}

- (void)configureReportCategoryCell:(ipad_ReportCashFlowCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tb{
    // Configure the cell
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:indexPath.row];
    
    //time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    cell.dateLabel.text =  [[dateFormatter stringFromDate:oneBrokenLineObject.dateTime]uppercaseString];
    
    
    //BGIMAGE
    if (indexPath.row == [_transactionByDateArray count]-1) {
        if ([_transactionByDateArray count]==6) {
            cell.line.hidden = YES;
        }
        else
            cell.line.hidden = NO;


    }
    else
    {
        cell.line.hidden = NO;
    }
    cell.inAmountLabel.text = [appDelegate.epnc formatterString:oneBrokenLineObject.incomeAmount];
    cell.outamountLabel.text = [appDelegate.epnc formatterString:oneBrokenLineObject.expenseAmount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _dateRangeSelView.hidden = YES;
    [self SelectCashAtIndexPath:indexPath withTable:tableView];
    
}

- (void)SelectCashAtIndexPath:(NSIndexPath *)indexPath withTable:(UITableView *)tb
{
    CGRect r=   [tb rectForRowAtIndexPath:indexPath];
    
    BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:indexPath.row];
    
    if([oneBrokenLineObject.thisDaytTransactionArray count] == 0) return;
    ipad_DateRangeTransactionViewController *editController = [[ipad_DateRangeTransactionViewController alloc] initWithStyle:UITableViewStylePlain];
    editController.iReportCashFlowViewController = self;
    editController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    editController.bcd =oneBrokenLineObject;
    
    if (_thisYearBtn.selected)
    {
        editController.dateRangeStr = @"This Year";
    }
    else if (_lastYearBtn.selected)
        editController.dateRangeStr = @"Last Year";
    else
        editController.dateRangeStr = @"Last 12 Months";
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.pvt = categoryDateTranList;
    
	UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:editController];
 	appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
	appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,380);
	appDelegate.AddPopoverController.delegate = self;
    appDelegate.AddPopoverController.delegate = self;
    CGPoint offset = tb.contentOffset;
    [appDelegate.AddPopoverController presentPopoverFromRect:CGRectMake(r.origin.x+480, (r.origin.y-offset.y) + tb.frame.origin.y , r.size.width, r.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
   
}


//------------------------获取起始时间下的交易数组，按照category分类
- (NSFetchedResultsController *)fetchedResultsByDateController_getData{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError * error=nil;
    NSDictionary *subs;
    subs = [NSDictionary dictionaryWithObjectsAndKeys:_cashStartDate,@"startDate",_cashEndDate,@"endDate", nil];
    
    
    NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDate_ExceptTransfer" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController* fetchedResults;
    fetchedResults= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:appDelegete.managedObjectContext
                                                          sectionNameKeyPath:@"groupByMonthString"
                                                                   cacheName:@"Root"];
    self.fetchedResultsByDateController = fetchedResults;
    [fetchedResults performFetch:&error];
    
    return _fetchedResultsByDateController;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ;
}
@end

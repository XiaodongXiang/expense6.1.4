//
//  ipad_ReportCategotyViewController.m
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import "ipad_ReportCategotyViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_CategoryCellDetail.h"
#import "ipad_CategoryTransactionViewController.h"
#import "CustomDateRangeViewController.h"


#pragma mark Custom Class Define - dateRangeCount
@implementation DateRangeCount
@synthesize titleString,startDate,endDate;

@end


///////
#pragma mark Custom Class Define - CategoryTotal
@implementation CategoryTotal
@synthesize cateName,totalAmount,hasChildCategory,categoryArray;
-(id)init
{
    
    if (self = [super init])
    {
        cateName = @"";
        
        categoryArray =[[NSMutableArray alloc] init];
        
    }
    return self;
}


@end

////////
#pragma mark CategoryItem
@implementation CategoryItem
@synthesize c,cName,transArray,categoryAmount;


-(id)init
{
    
    if (self = [super init])
    {
        transArray =[[NSMutableArray alloc] init];
        cName = @"";
    }
    return self;
}


@end

@interface ipad_ReportCategotyViewController ()

@end

@implementation ipad_ReportCategotyViewController

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
}

-(void)initPoint
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterShortStyle];
    [outputFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [_totalAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:20]];
    
    subDateRangeArray = [[NSMutableArray alloc] init];
    categoryTransactionArray = [[NSMutableArray alloc]init];
    piViewDateArray = [[NSMutableArray alloc]init];
    categoryArrayList = [[NSMutableArray alloc]init];

    
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    _date1Btn.selected = YES;
    _date2Btn.selected = NO;
    _date3Btn.selected = NO;
    _date4Btn.selected = NO;
    _date5Btn.selected = NO;
    _date6Btn.selected = NO;
    _date7Btn.selected = NO;

    [_reportTypeBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_reportTypeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateSelected];
    [_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    
    [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisMonth", nil) forState:UIControlStateNormal];
    [_date1Btn setTitle:NSLocalizedString(@"VC_ThisMonth", nil) forState:UIControlStateNormal];
    [_date2Btn setTitle:NSLocalizedString(@"VC_LastMonth", nil) forState:UIControlStateNormal];
    [_date3Btn setTitle:NSLocalizedString(@"VC_ThisQuarter", nil) forState:UIControlStateNormal];
    [_date4Btn setTitle:NSLocalizedString(@"VC_LastQuarter", nil) forState:UIControlStateNormal];
    [_date5Btn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    [_date6Btn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    [_date7Btn setTitle:NSLocalizedString(@"VC_CustomRange", nil) forState:UIControlStateNormal];
    
    //圆形图
    _piExpchartView.iReportCategotyViewController = self;
  	[_piExpchartView allocArray];
    _piExpchartView.canBetouch = FALSE;
    
    //btn action
    [_reportTypeBtn addTarget:self action:@selector(reportTypeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dateDurBtn addTarget:self action:@selector(dateDurBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_expenseBtn addTarget:self action:@selector(reportTypeBtnPressed_expenseorIncome:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(reportTypeBtnPressed_expenseorIncome:) forControlEvents:UIControlEventTouchUpInside];
    [_date1Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date2Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date3Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date4Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date5Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date6Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date7Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //selected
    [_expenseBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_incomeBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date1Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date2Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date3Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date4Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date5Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date6Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_date7Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];

    //highlighted
    [_expenseBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_incomeBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date1Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date2Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date3Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date4Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date5Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date6Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_date7Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
   
    //selected && higthlighted
    [_expenseBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_incomeBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date1Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date2Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date3Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date4Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date5Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date6Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_date7Btn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    
    //未选中时候的颜色
    [_expenseBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_incomeBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date1Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date2Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date3Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date4Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date5Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date6Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_date7Btn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    
    
    [_expenseBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_incomeBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date1Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date2Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date3Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date4Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date5Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date6Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_date7Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    
    
    //dataSelBtn textLabel Fram
    [_expenseBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_incomeBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date1Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date2Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date3Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date4Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date5Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date6Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_date7Btn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    
    
    _dateDurBtn.titleLabel.frame = CGRectMake(0, 0, 90, 30);
    _dateDurBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_dateDurBtn.titleLabel setMinimumScaleFactor:0];
    
    _reportTypeView.hidden = YES;
    _dateRangeSelView.hidden = YES;
    
    _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
    _categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_categoryStartDate];
}

#pragma mark resetData
////每次从其他页面进入这个页面的时候都会重新设置参数，刷新数据。
-(void)reFlashTableViewData
{
    [self reFlashTableViewDataInThisViewController];
}
-(void)reFlashTableViewDataInThisViewController
{
    
    //获取有transaction的category数据
    [self getCategoryDataSouce];
    [self setAllCategoryPiViewData];
    [self setAllCategoryPiViewLayout];
    [_myTableView reloadData];
}
//将这段时间内的transaction按照一级分类分组，存放在category数组中
- (void)getCategoryDataSouce
{
    if (_date1Btn.selected)
    {
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisMonth", nil) forState:UIControlStateNormal];
    }
    else if (_date2Btn.selected)
    {
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_LastMonth", nil) forState:UIControlStateNormal];

    }
    else if (_date3Btn.selected)
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisQuarter", nil) forState:UIControlStateNormal];

    else if (_date4Btn.selected)
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_LastQuarter", nil) forState:UIControlStateNormal];

    else if(_date5Btn.selected)
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];

    else if(_date6Btn.selected)
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];

    else
        [_dateDurBtn setTitle:NSLocalizedString(@"VC_CustomRange", nil) forState:UIControlStateNormal];


    [self setTimeLabelText];
    
    [categoryArrayList removeAllObjects];
    
    //获取所有具有transaction的category
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSDictionary *subs;
    if (_expenseBtn.selected) {
        subs = [NSDictionary dictionaryWithObjectsAndKeys:@"EXPENSE",@"REPORTTYPE", nil];
    }
    else
    {
        subs = [NSDictionary dictionaryWithObjectsAndKeys:@"INCOME",@"REPORTTYPE", nil];
        
    }
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"iPad_fetchCategoryHasTransactionandSelectedType" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
    
    
    //判断这个category是不是子cateogry,是的话，获取他的父category
    for (int i =0; i<[tmpCategoryArray count];i++) {
        Category *c = [tmpCategoryArray objectAtIndex:i];
        
        NSString *searchForMe = @":";
        NSRange range = [c.categoryName rangeOfString : searchForMe];
        
        //如果是一个子category，搜索父category
        if (range.location != NSNotFound) {
            NSArray * seprateSrray = [c.categoryName componentsSeparatedByString:@":"];
            NSString *parName = [seprateSrray objectAtIndex:0];
            
            NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
            
            NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];		// Edit the
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
            
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            
            
            if([tmpParCategoryArray count]>0)
            {
                Category *pc =  [tmpParCategoryArray lastObject];
                BOOL isFound = FALSE;
                
                //如果这个子category的父category在以及收集的categorylist里面，那么就需要将这个父category的统计值改变
                for (int j=0; j<[categoryArrayList count]; j++)
                {
                    CategoryTotal *ct = [categoryArrayList objectAtIndex:j];
                    
                    if([pc.categoryName isEqualToString:ct.cateName])
                    {
                        
                        [self upDateCategoryTotal:ct withCategory:c];
                        
                        isFound = TRUE;
                        break;
                    }
                }
                
                //如果这个子cagory的父category不在已经收集到的categorylist里面就需要重新创建一个关于category信息的对象
                if(!isFound)
                {
                    [self initNewExpCategoryTotalToMemory:pc withCategory:c];
                }
                
                
                isFound = FALSE;
            }
        }
        //如果不是子category
        else
        {
            [self initNewExpCategoryTotalToMemory:c withCategory:nil];
        }
   	}
    
}
//获取picharview的数组
-(void)setAllCategoryPiViewData
{
    
    [piViewDateArray removeAllObjects];
    
    PiChartViewItem *tmpPiChartViewItem;
    
    double totalAmount =0;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //计算所有category的totalAmount,制作存放picharview的数组
    for (int i=0; i<[categoryArrayList count];i ++) {
        CategoryTotal *ct =[categoryArrayList objectAtIndex:i];
        totalAmount +=ct.totalAmount ;
        
        
        if(ct.totalAmount>0  )
        {
            tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:ct.cateName color: [UIColor clearColor]  data:ct.totalAmount];
            tmpPiChartViewItem.indexOfMemArr = i;
            
            [piViewDateArray addObject:tmpPiChartViewItem];
            
        }
    }
    
    NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
    
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    
    [piViewDateArray sortUsingDescriptors:sorts];
    
    
    PiChartViewItem *tmpPiItem;
    int colorName=0;
    
    if(totalAmount == 0)
    {
        for (int i = 0; i<[piViewDateArray count];i++)
        {
            tmpPiItem =[piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = 1.0/[piViewDateArray count];
            tmpPiItem.cColor =  [appDelegate.epnc getExpColor:colorName];
            if(colorName == 9) colorName =0;
            else
                colorName ++;
        }
        
    }
    else
    {
        for (int i = 0; i<[piViewDateArray count];i++)
        {
            tmpPiItem =[piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = tmpPiItem.cData/totalAmount;
            if (_expenseBtn.selected) {
                tmpPiItem.cColor =  [appDelegate.epnc getExpColor:colorName];
                
            }
            else
            {
                tmpPiItem.cColor =  [appDelegate.epnc getIncColor:colorName];
                
            }
            if(colorName == 9) colorName =0;
            else
                colorName ++;
            
            
        }
    }
    
    _totalAmountLabel.text = [appDelegate.epnc formatterString:totalAmount];
}
-(void)setAllCategoryPiViewLayout
{
    
    [_piExpchartView setCateData:piViewDateArray ];
    [self.piExpchartView setNeedsDisplay];
    
    if([piViewDateArray count] == 0)self.myTableView.tableFooterView.hidden = YES;
    else {
        self.myTableView.tableFooterView.hidden = NO;
    }
}
-(void)setTimeLabelText
{
    NSString *startString = [outputFormatter stringFromDate:_categoryStartDate];
    NSString *endSrting = [outputFormatter stringFromDate:_categoryEndDate];
    _dateDurDesc.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
}

#pragma mark BtnAction
-(void)reportTypeBtnPressed:(UIButton *)sender
{
    _dateRangeSelView.hidden = YES;
    if (_reportTypeView.hidden) {
        _reportTypeView.hidden = NO;
    }
    else
    {
        _reportTypeView.hidden = YES;

    }
}

-(void)reportTypeBtnPressed_expenseorIncome:(UIButton *)sender
{
    if (sender==_expenseBtn)
    {
        if (_expenseBtn.selected)
        
        {
            _reportTypeView.hidden = YES;
            return;
        }
        else
        {
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
            [_reportTypeBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
        }
    }
    else
    {
        if (_incomeBtn.selected)
        {
            _reportTypeView.hidden = YES;
            return;
        }
        else
        {
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"16_CAT_INC"];
            
            _expenseBtn.selected = NO;
            _incomeBtn.selected = YES;
            [_reportTypeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
        }
    }
    _reportTypeView.hidden = YES;
    [self reFlashTableViewDataInThisViewController];
}

-(void)dateDurBtnAction:(id)sender
{
    _reportTypeView.hidden = YES;
    _dateRangeSelView.hidden = !_dateRangeSelView.hidden;
}

//dateRange事件：重新设置起始时间，刷新数据
-(void)dateRangeBtnPressed:(UIButton *)sender
{
    [self resetDateRangeBtnState];
    sender.selected = YES;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *startcomponent = [[NSDateComponents alloc] init] ;
    NSDateComponents *endcomponent = [[NSDateComponents alloc] init] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    if (_date1Btn.selected)
    {
        _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_categoryStartDate];
        
    }
    else if (_date2Btn.selected)
    {
        [startcomponent setMonth:-1];
        [endcomponent setMonth:1];
        [endcomponent setDay:-1];
        NSDate *tmpStartDate = [cal dateByAddingComponents:startcomponent toDate:[NSDate date] options:0];
        _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:tmpStartDate];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_categoryStartDate];
//        self.dateType=1;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_LTMO"];
        
    }
    else if (_date3Btn.selected)
    {
        if (component.month==1 || component.month==2 || component.month==3) {
            [component setMonth:1];
        }
        else if (component.month==4 || component.month==5 || component.month==6){
            [component setMonth:4];
            
        }
        else if (component.month==7 || component.month==8 || component.month==9){
            [component setMonth:7];
            
        }
        else{
            [component setMonth:10];
            
        }
        [component setDay:1];
        [component setHour:0];
        [component setMinute:0];
        [component setSecond:1];
        
        
        _categoryStartDate = [cal dateFromComponents:component];
        NSDateComponents *comp = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:_categoryStartDate];
        comp.year = comp.year;
        comp.month = comp.month + 3;
        comp.day = 0;
        comp.hour = 23;
        comp.minute = 59;
        comp.second = 59;
        _categoryEndDate = [cal dateFromComponents:comp];
//        self.dateType=2;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_THQT"];
        
    }
    else if (_date4Btn.selected)
    {
        _categoryStartDate =[appDelegate.epnc getStartDate:@"Last Quarter"];
        _categoryEndDate = [appDelegate.epnc getEndDate:_categoryStartDate withDateString:@"Last Quarter"];
//        self.dateType=3;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_LTQT"];
        
    }
    else if (_date5Btn.selected)
    {
        _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_categoryStartDate];
//        self.dateType=4;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_THYR"];
        
    }
    else if (_date6Btn.selected)
    {
        component.year = component.year-1;
        component.month = 1;
        component.day = 1;
        component.hour=0;
        component.minute=0;
        component.second=0;
        
        _categoryStartDate = [cal dateFromComponents:component];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_categoryStartDate];
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_LTYR"];
        
        
    }
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.pvt = dateRangePopup;
        CustomDateRangeViewController *customDateRangeViewController =[[CustomDateRangeViewController alloc] initWithNibName:@"CustomDateRangeViewController" bundle:nil];
        customDateRangeViewController.moduleString = @"ACCOUNT";
        customDateRangeViewController.categoryViewController = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customDateRangeViewController];
        appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
        appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,360.0);
        appDelegate.AddPopoverController.delegate = self;
        [appDelegate.AddPopoverController presentPopoverFromRect:_dateDurBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_CUST"];
        
    }
    _dateRangeSelView.hidden = YES;
    [self reFlashTableViewDataInThisViewController];
}

-(void)resetDateRangeBtnState
{
    _date1Btn.selected = NO;
    _date2Btn.selected = NO;
    _date3Btn.selected = NO;
    _date4Btn.selected = NO;
    _date5Btn.selected = NO;
    _date6Btn.selected = NO;
    _date7Btn.selected = NO;
}
#pragma mark getPicharview Data
//更新父category的信息,然后创建一个新的对象，来存储这个category底下所有的交易，交易的金额，以及名字等信息
-(void)upDateCategoryTotal:(CategoryTotal *)ct withCategory:(Category *)c;
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:_categoryStartDate,@"startDate",_categoryEndDate,@"endDate",c,@"category", nil];
    NSFetchRequest *fetchRequestExp = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"iPad_fetchTransactionByCategoryWithDate" substitutionVariables:subs];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequestExp setSortDescriptors:sortDescriptors];
    
    NSError *error =nil;
    
    NSArray *objectsExp = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestExp error:&error];
    if([objectsExp count]>0)
    {
        CategoryItem *ci = [[CategoryItem alloc] init];
        ci.c = c;
        for (int j=0; j<[objectsExp count];j++)
        {
            Transaction *entry = (Transaction *)[objectsExp objectAtIndex:j];
            ci.categoryAmount +=[entry.amount doubleValue];
        }
        ct.totalAmount +=ci.categoryAmount;
        
        [ci.transArray setArray:objectsExp];
        [ct.categoryArray addObject:ci];
        
    }
    
}

//创建一个新的cateogory来存储具有同一个父cateogry的所有子cateogry的统计
-(void)initNewExpCategoryTotalToMemory:(Category *)c   withCategory:(Category *)cc;
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:_categoryStartDate,@"startDate",_categoryEndDate,@"endDate",c,@"category", nil];
    NSFetchRequest *fetchRequestExp = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"iPad_fetchTransactionByCategoryWithDate" substitutionVariables:subs];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequestExp setSortDescriptors:sortDescriptors];
    
    NSError *error =nil;
    
    NSArray *objectsExp = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestExp error:&error];
    if([objectsExp count]>0||  cc !=nil)
    {
        CategoryTotal *ct = [[CategoryTotal alloc] init];
        CategoryItem *ci = [[CategoryItem alloc] init];
        ct.cateName = c.categoryName;
        ci.c = c;
        
        for (int j=0; j<[objectsExp count];j++)
        {
            Transaction *entry = (Transaction *)[objectsExp objectAtIndex:j];
            ci.categoryAmount +=[entry.amount doubleValue];
        }
        ct.totalAmount +=ci.categoryAmount;
        
        [ci.transArray setArray:objectsExp];
        [ct.categoryArray addObject:ci];
        [categoryArrayList addObject:ct];
        if(cc !=nil)
        {
            [self upDateCategoryTotal:ct withCategory:cc  ];
        }
        
    }
    
}

-(void)hidePopView
{
    _reportTypeView.hidden = YES;
    _dateRangeSelView.hidden = YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [piViewDateArray  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ipad_CategoryCellDetail *cell = (ipad_CategoryCellDetail *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ipad_CategoryCellDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    [self configureReportCategoryCell:cell atIndexPath:indexPath withTableView:tableView ];
    return cell;
}

- (void)configureReportCategoryCell:(ipad_CategoryCellDetail *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tb{
    // Configure the cell
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    PiChartViewItem *tmpPiItem = [piViewDateArray objectAtIndex:indexPath.row];
    
    
    //name
    cell.nameLabel.text = tmpPiItem.cName;
    
    //color label
    [cell.colorLabel setBackgroundColor:tmpPiItem.cColor];
    cell.colorLabel.hidden = NO;
    
    //percent
    cell.percentLabel.text = [[NSString stringWithFormat: @"%.2f",tmpPiItem.cPercent*100] stringByAppendingString:@"%"];
    
    //spent
    if(_expenseBtn.selected)
    {
        [cell.spentLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
    }
    else
    {
        [cell.spentLabel setTextColor:[appDelegate.epnc getAmountGreenColor]];
    }
    cell.spentLabel.text = [appDelegate.epnc formatterString: tmpPiItem.cData];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _reportTypeView.hidden = YES;
    _dateRangeSelView.hidden = YES;
    [self SelectCategoryAtIndexPath:indexPath withTable:tableView];
    
}

- (void)SelectCategoryAtIndexPath:(NSIndexPath *)indexPath withTable:(UITableView *)tb
{
    CategoryTotal *ct=nil;
    PiChartViewItem *tmpPiItem;
    CGRect r=   [tb rectForRowAtIndexPath:indexPath];
    
    tmpPiItem=    [piViewDateArray objectAtIndex:indexPath.row];

    
    ct  =  [categoryArrayList objectAtIndex:tmpPiItem.indexOfMemArr];

    ipad_CategoryTransactionViewController *editController = [[ipad_CategoryTransactionViewController alloc] initWithStyle:UITableViewStylePlain];
    editController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    editController.tableView.showsVerticalScrollIndicator = NO;
    editController.ct= ct;
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.pvt = categoryPayeeTranList;
 	
	UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:editController];
//    [navigationController.navigationBar setTintColor: [UIColor colorWithRed:75.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0]];
    
 	appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
	appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,480);
	appDelegate.AddPopoverController.delegate = self;
    CGPoint offset = tb.contentOffset;
    [appDelegate.AddPopoverController presentPopoverFromRect:CGRectMake(r.origin.x+480, (r.origin.y-offset.y) + tb.frame.origin.y , r.size.width, r.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
 	

}


@end

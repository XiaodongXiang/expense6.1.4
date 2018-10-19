//
//  ipad_ReportComparisonViewController.m
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import "ipad_ReportComparisonViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_ReportCategotyViewController.h"
#import "ipad_CategoryCmpCell.h"
@import Firebase;
@implementation CategoryCmp
@synthesize categoryAmount1;
@synthesize categoryAmount2;
@synthesize diffCategoryAmount;
@synthesize category;

@end


@interface ipad_ReportComparisonViewController ()

@end

@implementation ipad_ReportComparisonViewController
@synthesize vsLabel,compareBtn,accountBtn,categoryBtn,dateDurBtn,dateRangeSelView,dataSelBtn,dataSelBtn1,dataSelBtn2,dataSelBtn3,dataSelBtn4,dataSelBtn5,dataSelBtn6,subdateRangeSelView,myTableView,dateLabel,dateRangeString,outputFormatter,subdateDurBtn,dateDurDesc;
@synthesize startDate,endDate,subDateRangeArray,compareArrayList;
@synthesize reportTypeString,reportTypeView,compareConditionArray;

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
    //初始化subdateRange的格子数以及title
    [self initDateRangeMemoryDefine];
    [FIRAnalytics setScreenName:@"report_comparison_view_ipad" screenClass:@"ipad_ReportComparisonViewController"];
}

-(void)initPoint
{
    [self resetData];
    outputFormatter = [[NSDateFormatter alloc] init];
 	[outputFormatter setDateStyle:NSDateFormatterShortStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    
	[dateDurBtn setTitle:dateRangeString forState:UIControlStateNormal];
    
    subDateRangeArray = [[NSMutableArray alloc] init];
    compareArrayList = [[NSMutableArray alloc]init];
    
    [self resetDateDurDescByDate];
    
    [dateDurBtn addTarget:self action:@selector(dateDurBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [subdateDurBtn addTarget:self action:@selector(subdateDurBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dataSelBtn addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn1 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn2 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn3 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn4 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn5 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dataSelBtn6 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [dataSelBtn6 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    
    [dataSelBtn.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn1.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn2.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn3.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn4.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn5.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
    [dataSelBtn6.titleLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1]];
}

-(void)initDateRangeMemoryDefine
{
    [self reSetDateRangeViewBtnStyle];
    
    if([dateRangeString isEqualToString:@"Weekly"])
    {
        dataSelBtn1.selected = YES;
        [dataSelBtn1.titleLabel setHighlighted:YES];
        numOfBarColumn = 5;
        
    }
    else if([dateRangeString isEqualToString:@"Biweekly"])
    {
        dataSelBtn2.selected = YES;
        [dataSelBtn2.titleLabel setHighlighted:YES];
        numOfBarColumn = 5;
        
    }
    
    else if([dateRangeString isEqualToString:@"Monthly"])
    {
        dataSelBtn3.selected = YES;
        [dataSelBtn3.titleLabel setHighlighted:YES];
        numOfBarColumn = 12;
        
    }
    else if([dateRangeString isEqualToString:@"Quarterly"])
    {
        dataSelBtn4.selected = YES;
        [dataSelBtn4.titleLabel setHighlighted:YES];
        numOfBarColumn = 5;
        
    }
    else if([dateRangeString isEqualToString:@"Yearly"])
    {
        dataSelBtn5.selected = YES;
        [dataSelBtn5.titleLabel setHighlighted:YES];
        numOfBarColumn = 5;
        
    }
    else   if([dateRangeString isEqualToString:@"Custom"])
    {
        dataSelBtn6.selected = YES;
        [dataSelBtn6.titleLabel setHighlighted:YES];
        numOfBarColumn = 0;
        
    }
    else   if([dateRangeString isEqualToString:@"All Dates"])
    {
        dataSelBtn.selected = YES;
        [dataSelBtn.titleLabel setHighlighted:YES];
        numOfBarColumn = 12;
        
    }
    
    
    
    
}

//设置第二种时间选择的btn
-(void)reSetSubDateRangeViewBtnValue
{
    [subDateRangeArray removeAllObjects];
    for (UIView * v in [subdateRangeSelView subviews]) {
        [v removeFromSuperview];
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDateFormatter *tmpFmt = [[NSDateFormatter alloc] init];
    [tmpFmt setDateStyle:NSDateFormatterLongStyle];
    NSInteger linecount =0;
    if([dateRangeString isEqualToString:@"Monthly"])
    {
        subdateRangeSelView.frame = CGRectMake(350, 60, 154, 568);
        linecount =13;
        [tmpFmt setDateFormat:@"MMM yyyy"];
        
    }
    else
    {
        subdateRangeSelView.frame = CGRectMake(350, 60, 154, 248);
        linecount =5;
        [tmpFmt setDateFormat:@"yyyy"];
        
    }
    //设置右边下拉菜单按钮
    for(int i=0;i<linecount;i++)
    {
        DateRangeCount *drc = [[DateRangeCount alloc] init];
        drc.startDate = [appDelegate.epnc getStartDate:dateRangeString beforCycleCount:i];
        drc.endDate = [appDelegate.epnc getEndDate:drc.startDate dateCycleString:dateRangeString];
        if( [dateRangeString isEqualToString:@"Quarterly"])
        {
            NSDateComponents *tmpday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:drc.startDate];
            NSString *qStr=@"Q1";
            if([tmpday month] ==1)
            {
                qStr=@"Q1";
            }
            else    if([tmpday month] ==4)
            {
                qStr=@"Q2";
            }
            else    if([tmpday month] ==7)
            {
                qStr=@"Q3";
            }
            else    if([tmpday month] ==10)
            {
                qStr=@"Q4";
            }
            
            drc.titleString = [NSString stringWithFormat:@"%@ %@",[tmpFmt stringFromDate:drc.startDate],qStr];
        }
        else
        {
            drc.titleString = [NSString stringWithFormat:@"%@",[tmpFmt stringFromDate:drc.startDate] ];
            
        }
        [subDateRangeArray addObject:drc];
        UIButton *tmpbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        tmpbutton.selected =i? FALSE:TRUE;
        if(!i)    [subdateDurBtn setTitle:drc.titleString forState:UIControlStateNormal];
        
        if (i==0) {
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_44_sel.png"] forState:UIControlStateSelected];
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_44.png"] forState:UIControlStateNormal];
            tmpbutton.frame = CGRectMake(0,0, 140, 44);
            
            [tmpbutton setTag:i ];
            [tmpbutton setTitleColor:[UIColor colorWithRed:0.0/255.f green:0.0/255.0 blue:0.0/255.0 alpha:1.f] forState:UIControlStateNormal];
            [tmpbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [tmpbutton setTitleEdgeInsets:UIEdgeInsetsMake(12, 40, 0, 0)];
            [tmpbutton setTitle:drc.titleString forState:UIControlStateNormal];
            [tmpbutton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
            
            [tmpbutton.titleLabel setHighlightedTextColor:[UIColor blackColor]];
            [tmpbutton addTarget:self action:@selector(subdataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [subdateRangeSelView addSubview:tmpbutton];
        }
        else if(i>0 && i!=linecount-1){
            tmpbutton.frame = CGRectMake(0,44+ 36*(i-1), 140, 36);
            
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36.png"] forState:UIControlStateNormal];
            
            [tmpbutton setTag:i ];
            [tmpbutton setTitleColor:[UIColor colorWithRed:0.0/255.f green:0.0/255.0 blue:0.0/255.0 alpha:1.f] forState:UIControlStateNormal];
            [tmpbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [tmpbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
            [tmpbutton setTitle:drc.titleString forState:UIControlStateNormal];
            [tmpbutton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
            
            [tmpbutton.titleLabel setHighlightedTextColor:[UIColor whiteColor]];
            [tmpbutton addTarget:self action:@selector(subdataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [subdateRangeSelView addSubview:tmpbutton];
        }
        else{
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
            [tmpbutton setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36.png"] forState:UIControlStateNormal];
            tmpbutton.frame = CGRectMake(0, 44+36*(linecount-2), 140, 36);
            
            [tmpbutton setTag:i ];
            [tmpbutton setTitleColor:[UIColor colorWithRed:0.0/255.f green:0.0/255.0 blue:0.0/255.0 alpha:1.f] forState:UIControlStateNormal];
            [tmpbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [tmpbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
            [tmpbutton setTitle:drc.titleString forState:UIControlStateNormal];
            [tmpbutton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
            
            [tmpbutton.titleLabel setHighlightedTextColor:[UIColor blackColor]];
            [tmpbutton addTarget:self action:@selector(subdataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [subdateRangeSelView addSubview:tmpbutton];
        }
        
        
    }
}

//设置时间文字的显示
-(void)setDateDurDescByDate
{
    if([dateRangeString isEqualToString:@"Monthly"]||
       [dateRangeString isEqualToString:@"Quarterly"]||
       [dateRangeString isEqualToString:@"Yearly"]||
       [dateRangeString isEqualToString:@"All Dates"])
    {
        dateDurDesc.text =@"";
    }
    else
    {
        NSDateFormatter *tmpFmt = [[NSDateFormatter alloc] init];
        [tmpFmt setDateStyle:NSDateFormatterLongStyle];
        [tmpFmt setDateFormat:@"MMM dd, yyyy"];
        dateDurDesc.text =[NSString stringWithFormat:@"%@ - %@",[tmpFmt stringFromDate:self.startDate],[tmpFmt stringFromDate:self.endDate]];
    }
    
}

//还原初始的数据
-(void)resetData
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dateRangeString = @"All Dates";
    
    self.startDate =[appDelegate.epnc getStartDate:dateRangeString];
    self.endDate = [appDelegate.epnc getEndDate: self.startDate withDateString:dateRangeString];
    
    dateRangeSelView.hidden = YES;
    subdateRangeSelView.hidden = YES;
}

-(void)resetDateDurDescByDate
{
    if([dateRangeString isEqualToString:@"Monthly"]||
       [dateRangeString isEqualToString:@"Quarterly"]||
       [dateRangeString isEqualToString:@"Yearly"])
    {
        [self reSetSubDateRangeViewBtnValue];
        subdateDurBtn.hidden = NO;
        
    }
    else
    {
        subdateDurBtn.hidden = YES;
    }
    
    [self setDateDurDescByDate];
}

//重新设置subdatebtn的数组
-(void)reSetDateRangeViewBtnStyle
{
    dataSelBtn.selected = NO;
    dataSelBtn1.selected = NO;
    dataSelBtn2.selected = NO;
    dataSelBtn3.selected = NO;
    dataSelBtn4.selected = NO;
    dataSelBtn5.selected = NO;
    dataSelBtn6.selected = NO;
    
    [dataSelBtn.titleLabel setHighlighted:FALSE];
    [dataSelBtn1.titleLabel setHighlighted:FALSE];
    [dataSelBtn2.titleLabel setHighlighted:FALSE];
    [dataSelBtn3.titleLabel setHighlighted:FALSE];
    [dataSelBtn4.titleLabel setHighlighted:FALSE];
    [dataSelBtn5.titleLabel setHighlighted:FALSE];
    [dataSelBtn6.titleLabel setHighlighted:FALSE];
    
}



#pragma mark BtnAction
-(void)dateDurBtnAction:(id)sender
{
    reportTypeView.hidden = YES;
    subdateRangeSelView.hidden = YES;
    dateRangeSelView.hidden = !dateRangeSelView.hidden;
}

//dateRange事件：重新设置起始时间，刷新数据
-(void)dataRangeBtnAction:(id)sender
{
    dateRangeString = [[(UIButton *)sender titleLabel] text];
    if([dateRangeString isEqualToString:@"Monthly"]||
       [dateRangeString isEqualToString:@"Quarterly"]||
       [dateRangeString isEqualToString:@"Yearly"])
    {
        [self reSetSubDateRangeViewBtnValue];
        subdateDurBtn.hidden = NO;
        
    }
    else
    {
        subdateDurBtn.hidden = YES;
    }
    
    if([dateRangeString isEqualToString:@"All Dates"] ||[dateRangeString isEqualToString:@"Monthly"] ||[dateRangeString isEqualToString:@"Month to date"]  )
    {
        numOfBarColumn = 12;
        
    }
    else if([dateRangeString isEqualToString:@"Weekly"]||
            [dateRangeString isEqualToString:@"Biweekly"]||
            [dateRangeString isEqualToString:@"Quarterly"]||
            [dateRangeString isEqualToString:@"Quarter to date"]||
            [dateRangeString isEqualToString:@"Yearly"]||
            [dateRangeString isEqualToString:@"Year to date"]) {
        numOfBarColumn = 5;
        
    }
    else {
        numOfBarColumn = 0;
        
    }
    
    
    [self reSetDateRangeViewBtnStyle];
    [(UIButton *)sender setSelected:YES];
//    [[(UIButton *)sender titleLabel] setHighlighted:YES];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(![dateRangeString isEqualToString:@"Custom"])
    {
        if([dateRangeString isEqualToString:@"Monthly"]||
           [dateRangeString isEqualToString:@"Quarterly"]||
           [dateRangeString isEqualToString:@"Yearly"])
        {
            DateRangeCount *drc = [subDateRangeArray objectAtIndex:0];
            self.startDate = drc.startDate;
            self.endDate = drc.endDate;
            
        }
        else {
            self.startDate =[appDelegate.epnc getStartDate:dateRangeString];
            self.endDate = [appDelegate.epnc getEndDate:startDate withDateString:dateRangeString];
            
        }
        [self reFlashTableViewDataInThisViewController];
        [self setDateDurDescByDate];
        
    }
    else
    {

        
    }
    
    dateRangeSelView.hidden =YES;
}

-(void)subdateDurBtnAction:(id)sender
{
    reportTypeView.hidden = YES;
    dateRangeSelView.hidden =YES;
    subdateRangeSelView.hidden = !subdateRangeSelView.hidden;
}

-(void)subdataRangeBtnAction:(id)sender
{
    subdateRangeSelView.hidden =YES;
    
    [self reSetSubDateRangeViewBtnStyle];
    
    [(UIButton *)sender setSelected:YES];
    [[(UIButton *)sender titleLabel] setHighlighted:YES];
    
    NSInteger selTag = [(UIButton *)sender tag];
    [subdateDurBtn setTitle:[[(UIButton *)sender titleLabel] text] forState:UIControlStateNormal];
    
    DateRangeCount *drc = [subDateRangeArray objectAtIndex:selTag];
    self.startDate = drc.startDate;
    self.endDate = drc.endDate;
    [self reFlashTableViewDataInThisViewController];
    
}
-(void)reSetSubDateRangeViewBtnStyle
{
    
    for(UIView *subview in [subdateRangeSelView subviews]) {
        if([subview isKindOfClass:UIButton.class]) {
            [(UIButton *)subview setSelected:NO];
            [[(UIButton *)subview titleLabel] setHighlighted:NO];
        }
    }
    
}

#pragma mark resetData
////每次从其他页面进入这个页面的时候都会重新设置参数，刷新数据。
-(void)reFlashTableViewData
{
    [self resetData];
    [self resetDateDurDescByDate];
    [self reFlashTableViewDataInThisViewController];
}
-(void)reFlashTableViewDataInThisViewController
{
    //获取有transaction的category数据
    [self getCategoryDataSouce];
    [self setAllCategoryPiViewData];
    [self setAllCategoryPiViewLayout];
    [myTableView reloadData];
}

#pragma mark getPicharview Data
//创建category数据
- (void)getCategoryDataSouce
{
    /*
	[reportArrayList removeAllObjects];
    
    //获取所有具有transaction的category
	PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSError *error = nil;
	NSDictionary *subs;
    if ([reportTypeString isEqualToString:@"expense"]) {
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
 	[sortDescriptor release];
	[sortDescriptors release];
    
    //判断这个category是不是子cateogry,是的话，获取他的父category
 	for (int i =0; i<[tmpCategoryArray count];i++) {
		Category *c = [tmpCategoryArray objectAtIndex:i];
        
 		NSString *searchForMe = @":";
		NSRange range = [c.categoryName rangeOfString : searchForMe];
		
        //如果是一个子category
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
			
			[sortDescriptor release];
			[sortDescriptors release];
            
            
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
			[tmpParCategoryArray release];
 		}
        //如果不是子category
        else
        {
            [self initNewExpCategoryTotalToMemory:c withCategory:nil];
        }
   	}
	
	[tmpCategoryArray release];
     */
}

//更新父category的信息,然后创建一个新的对象，来存储这个category底下所有的交易，交易的金额，以及名字等信息
-(void)upDateCategoryTotal:(CategoryTotal *)ct withCategory:(Category *)c;
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"startDate",self.endDate,@"endDate",c,@"category", nil];
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
    /*
    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"startDate",self.endDate,@"endDate",c,@"category", nil];
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
        [ct release];
        if(cc !=nil)
        {
            [self upDateCategoryTotal:ct withCategory:cc  ];
        }
        
    }
    */
}

//获取picharview的数组
-(void)setAllCategoryPiViewData
{
    /*
 	[piViewDateArray removeAllObjects];
    
	PiChartViewItem *tmpPiChartViewItem;
    
 	double totalAmount =0;
    
    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //计算所有category的totalAmount,制作存放picharview的数组
	for (int i=0; i<[categoryArrayList count];i ++) {
        CategoryTotal *ct =[categoryArrayList objectAtIndex:i];
        totalAmount +=ct.totalAmount ;
        
        
        if(ct.totalAmount>0  )
        {
            tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:ct.cateName color: [UIColor clearColor]  data:ct.totalAmount];
            tmpPiChartViewItem.indexOfMemArr = i;
            
            [piViewDateArray addObject:tmpPiChartViewItem];
            [tmpPiChartViewItem release];
            
        }
    }
    
	NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
	
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
	
 	[piViewDateArray sortUsingDescriptors:sorts];
    
	[sort release];
	[sorts release];
    
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
            if ([reportTypeString isEqualToString:@"expense"]) {
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
    */
}

-(void)setAllCategoryPiViewLayout
{
    
    /*
    if([piViewDateArray count] == 0)self.myTableView.tableFooterView.hidden = YES;
    else {
        self.myTableView.tableFooterView.hidden = NO;
    }
    
    //    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //    lblTotalExp.text = [appDelegate.epnc formatterString: 0-totalExpAmount];
    //
    //    lblTotalInc.text = [appDelegate.epnc formatterString:totalIncAmount];
    */
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
    /*
    return [piViewDateArray  count];
     */
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ipad_CategoryCmpCell *cell = (ipad_CategoryCmpCell *)[self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ipad_CategoryCmpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//    CategoryCmp *cc;
//    if([cateExpCmpDataArray count] > 0 && [cateIncCmpDataArray count] > 0)
//    {
//        
//        if( indexPath.section==0)
//        {
//            cc = [cateExpCmpDataArray objectAtIndex:indexPath.row];
//        }
//        else {
//            cc = [cateIncCmpDataArray objectAtIndex:indexPath.row];
//            
//        }
//        
//        
//    }
//    else if([cateExpCmpDataArray count] >0 )
//    {
//        cc = [cateExpCmpDataArray objectAtIndex:indexPath.row];
//        
//    }
//    else if([cateIncCmpDataArray count] >0 )
//    {
//        cc = [cateIncCmpDataArray objectAtIndex:indexPath.row];
//        
//    }
//    
//    cell.nameLabel.text = cc.category.categoryName;
//    cell.amount1Label.text =[appDelegate.epnc formatterString:cc.categoryAmount1];
//    cell.amount2Label.text =[appDelegate.epnc formatterString:cc.categoryAmount2];
//    cell.diffAmountLabel.text =[appDelegate.epnc formatterString:cc.categoryAmount1-cc.categoryAmount2];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dateRangeSelView.hidden = YES;
    subdateRangeSelView.hidden = YES;
    [self SelectCategoryAtIndexPath:indexPath withTable:tableView];
    
}

- (void)SelectCategoryAtIndexPath:(NSIndexPath *)indexPath withTable:(UITableView *)tb
{
    /*
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
    
 	appDelegate.AddPopoverController= [[[UIPopoverController alloc] initWithContentViewController:navigationController] autorelease];
	appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,480);
	appDelegate.AddPopoverController.delegate = self;
    CGPoint offset = tb.contentOffset;
    [appDelegate.AddPopoverController presentPopoverFromRect:CGRectMake(r.origin.x+480, (r.origin.y-offset.y) + tb.frame.origin.y , r.size.width, r.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
 	
 	[navigationController release];
	[editController release];
    */
}


@end

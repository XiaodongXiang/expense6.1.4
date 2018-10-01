//
//  ipad_EmailViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import "ipad_EmailViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_ExportSelectedCategoryViewController.h"
#import "ipad_ExportSelectedAccountViewController.h"


@interface ipad_EmailViewController ()

@end

@implementation ipad_EmailViewController
@synthesize myTableView;
@synthesize startDate,endDate,cellAccount;
@synthesize lblStartDate,lblEndDate,lblCategory;
@synthesize datePicker;
@synthesize categoryArray;
@synthesize category,accounts,lblAccount;
@synthesize cellGroupBy,cellCategory, cellStartDate,cellEndDate,cellSequence;
@synthesize fetchedResultsController,accountArray;
@synthesize selectedIndex;
@synthesize groupCategoryBtn,groupAccountBtn,sequenceAscBtn,sequenceDesBtn;
@synthesize groupByLabelText,categoryLabelText,accountsLabelText,startFromLabelText,endToLabelText,sequenceLabelText;
@synthesize datepickerCell,endDatePicker,endDatePickerCell;

#pragma mark View cycle life
-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavBarStyle];
	[self initMemoryDefine];
    [self getDataSouce];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[self.myTableView reloadData];
//	NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:0];
//	[self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - viewdidload Methed
-(void)initMemoryDefine
{
    lblAccount.text = NSLocalizedString(@"VC_All", nil);
    lblCategory.text = NSLocalizedString(@"VC_All", nil);
    groupByLabelText.text = NSLocalizedString(@"VC_Group By", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    accountsLabelText.text = NSLocalizedString(@"VC_Accounts", nil);
    startFromLabelText.text = NSLocalizedString(@"VC_Start From", nil);
    endToLabelText.text = NSLocalizedString(@"VC_End To", nil);
    sequenceLabelText.text = NSLocalizedString(@"VC_Sequence", nil);
    
    [groupCategoryBtn setTitle:NSLocalizedString(@"VC_Category", nil) forState:UIControlStateNormal];
    [groupCategoryBtn setTitle:NSLocalizedString(@"VC_Category", nil) forState:UIControlStateSelected];
    [groupAccountBtn setTitle:NSLocalizedString(@"VC_Account", nil) forState:UIControlStateNormal];
    [groupAccountBtn setTitle:NSLocalizedString(@"VC_Account", nil) forState:UIControlStateSelected];
    [sequenceAscBtn setTitle:NSLocalizedString(@"VC_Ascending", nil) forState:UIControlStateNormal];
    [sequenceAscBtn setTitle:NSLocalizedString(@"VC_Ascending", nil) forState:UIControlStateSelected];
    [sequenceDesBtn setTitle:NSLocalizedString(@"VC_Descending", nil) forState:UIControlStateNormal];
    [sequenceDesBtn setTitle:NSLocalizedString(@"VC_Descending", nil) forState:UIControlStateSelected];

    cellGroupBy.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellCategory.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellAccount.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellStartDate.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellEndDate.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellSequence.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    
	groupAccountBtn.selected = NO;
    groupCategoryBtn.selected = YES;
    sequenceAscBtn.selected = YES;
    sequenceDesBtn.selected = NO;
    [groupAccountBtn addTarget:self action:@selector(groupAccountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [groupCategoryBtn addTarget:self action:@selector(groupCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sequenceAscBtn addTarget:self action:@selector(sequenceAscBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sequenceDesBtn addTarget:self action:@selector(sequenceDesBtn:) forControlEvents:UIControlEventTouchUpInside];
    
	categoryArray = [[NSMutableArray alloc] init];
    accountArray = [[NSMutableArray alloc]init];
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //设置开始时间和结束时间，默认的是最近一个星期
	if (self.startDate == nil)
	{
 		NSDateComponents* dc = [[NSDateComponents alloc] init];
		[dc setDay:-6];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
  		self.startDate = [appDelegate.epnc getFirstSecByDate:[gregorian dateByAddingComponents:dc toDate: [NSDate date] options:0]];
 		NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
		[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSString* stime = [outputFormatter stringFromDate:self.startDate];
		NSString* etime = [outputFormatter stringFromDate:[NSDate date] ];
		lblStartDate.text = stime;
		lblEndDate.text = etime;
		self.endDate = [appDelegate.epnc getLastSecByDate:[NSDate date]];
	}
    
    [self setDatePicerRange];

    
    
    [datePicker addTarget:self
                   action:@selector(dateSelected)
         forControlEvents:UIControlEventValueChanged];
    [endDatePicker addTarget:self
                   action:@selector(dateSelected)
            forControlEvents:UIControlEventValueChanged];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    endDatePicker.datePickerMode = UIDatePickerModeDate;
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[flexible,leftBar];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [nextBtn setTitle:NSLocalizedString(@"VC_Send", nil) forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [nextBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [nextBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:nextBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    [titleLabel  setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"VC_Transaction(CSV)", nil);
    self.navigationItem.titleView = titleLabel;
}

//获取所有的category数据
#pragma mark - get data source
-(void) getDataSouce
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	[categoryArray removeAllObjects];
    
    NSError *error =nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [categoryArray setArray:objects];

    
    [accountArray removeAllObjects];
    NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity_account = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest_account setEntity:entity_account];
    [fetchRequest_account setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor_account = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors_account = [[NSArray alloc] initWithObjects:sortDescriptor_account, nil];
    [fetchRequest_account setSortDescriptors:sortDescriptors_account];
    NSArray* objects_account = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error];
    [accountArray setArray:objects_account];

}


//-(float) calculateHeightOfTextFromWidth:(NSString*) text withFontSize:(float)fontSize andWedith:(float)w
//{
//	[text retain];
//	
//	CGSize suggestedSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(w, FLT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
//    
////    CGSize suggestesSize1 = [text boundingRectWithSize:[UIFont systemFontOfSize:fontSize] options:NSStringDrawingTruncatesLastVisibleLine attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
//	
//	[text release];
//	return suggestedSize.height==0? fontSize:suggestedSize.height;
//	//NSInteger lineCount = suggestedSize.height/fontSize;
//	//return lineCount==1? 1:lineCount+1;
//}


#pragma mark - nav bar button action
-(void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

//发送数据
-(void)nextPressed
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"19_EXPT_CSV"];
    [self sendCsv];
}

-(void)sendCsv
{
    
	NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSString* start = [outputFormatter stringFromDate:self.startDate];
	NSString* end = [outputFormatter stringFromDate:self.endDate];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        //		// We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            PokcetExpenseAppDelegate*  appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate]; // get the main app delegate
            MFMailComposeViewController *mail =[[MFMailComposeViewController alloc] init];
            
            NSMutableArray *mailSendArray = [[NSMutableArray alloc] init];
            
            NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"MM/dd/yyyy KK:mm aa"];
            
            NSDateFormatter *dayFormatter =[[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"MM/dd/yyyy"];
            
            mail.mailComposeDelegate = self;//必须的 否则无法关闭发邮件页面
            
            //1.写标题
            [mail setSubject:[NSString stringWithFormat:@"Transaction Data: %@ - %@", start, end]];
            
            
            //3.获取transaction array
            NSMutableArray* mutableObjects = [[NSMutableArray alloc] initWithArray:[self getTransactionByAccountandCategory]];
            
            //添加时间
            [mailSendArray addObject:@"Pocket Expense Report"];
            NSString *dateFromstarttoEndDate = [NSString stringWithFormat:@"%@ - %@",[dayFormatter stringFromDate:self.startDate],[dayFormatter stringFromDate:self.endDate]];
            [mailSendArray addObject:dateFromstarttoEndDate];
            [mailSendArray addObject:@"\n"];
            
            //添加金额
            //设置分组的数据
            double tmpIncome=0,tmpSpent=0;
            double tmpClear=0,tmpUnClear=0;
            
            for (int i=0; i<[mutableObjects count];i++) {
                Transaction *t=[mutableObjects objectAtIndex:i];
                if([t.category.categoryType isEqualToString:@"EXPENSE"])
                {
                    tmpSpent +=[t.amount doubleValue];
                    if([t.isClear boolValue])
                    {
                        tmpClear -= [t.amount doubleValue];
                    }
                    else
                    {
                        tmpUnClear -= [t.amount doubleValue];
                        
                    }
                }
                else if([t.category.categoryType isEqualToString:@"EXPENSE"])
                {
                    
                    tmpIncome += [t.amount doubleValue];
                    if([t.isClear boolValue])
                    {
                        tmpClear += [t.amount doubleValue];
                    }
                    else
                    {
                        tmpUnClear += [t.amount doubleValue];
                        
                    }
                    
                }
                
            }
            
            //使用\"进行分列
            Category *oneCategory = [categoryArray objectAtIndex:0];
            if ([oneCategory.categoryType isEqualToString:@"EXPENSE"]) {
                [mailSendArray addObject:[NSString stringWithFormat:@"\"expense\",\"%@\"",[appDelegate.epnc formatterString:(0-tmpSpent)]]];
            }
            else{
                [mailSendArray addObject:[NSString stringWithFormat:@"\"income\",\"%@\"",[appDelegate.epnc formatterString:(0-tmpUnClear)]]];
            }
            
            //增加uncleared
            [mailSendArray addObject:[NSString stringWithFormat:@"uncleared,%@",[appDelegate.epnc formatterString:tmpUnClear]]];
            [mailSendArray addObject:@"\n"];
            [mailSendArray addObject:@"\n"];
            
            //4.标题行
            [mailSendArray addObject:@"Date&Time,Account,Category,Payee/Place,Amount,Cleared,Note"];
            
            
            for(int j = 0; j < mutableObjects.count; j++)
            {
                Transaction* reading = [mutableObjects objectAtIndex:j];
                NSString* amount;
                if ([reading.category.categoryType isEqualToString:@"EXPENSE"]) {
                    amount = [appDelegate.epnc formatterString:(0-[reading.amount doubleValue])];
                }
                else{
                    amount = [appDelegate.epnc formatterString:[reading.amount doubleValue]];
                }
                
                NSString* account ;
                if([reading.category.categoryType isEqualToString:@"EXPENSE"])
                {
                    account=[NSString stringWithFormat:@"%@",reading.expenseAccount.accName];
                }
                else {
                    account=[NSString stringWithFormat:@"%@",reading.incomeAccount.accName];
                }
                
                
                NSString* categoryString ;
                if( reading.category==nil)
                {
                    categoryString = @"";
                }
                else
                {
					categoryString = [NSString stringWithFormat:@"%@",  reading.category.categoryName];
                }
                
                NSString* payeeName ;
                if( reading.payee==nil)
                {
                    payeeName = @"";
                }
                else
                {
                    payeeName = [NSString stringWithFormat:@"%@",  reading.payee.name];
                }
                
                
                
                NSString* datetime = [outputFormatter stringFromDate:reading.dateTime];
                NSString* clear = @"";
                if([reading.isClear boolValue] == FALSE )
                {
                    clear = @"No";
                }
                else
                {
                    clear = @"Yes";
                }
                NSString* note  = [NSString stringWithFormat:@"%@",reading.notes];
                if (reading.notes == nil)
                {
                    note = @"";
                }
                [mailSendArray addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",datetime,account,categoryString,payeeName,amount,clear,note]];
            }
            
            
            //4.添加正文
            NSString * str = @"<Html>The attachment is exported from PocketExpense for the iPhone and iPod Touch.<br> The data is formatted in 'Comma Separated Value'(CSV) format and may be imported by many common spreadsheet applications.</Html>";
            [mail setMessageBody:str isHTML:YES];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSDate * dateNow = [NSDate date];
            NSDateFormatter *formatDateNow = [[NSDateFormatter alloc] init];
            [formatDateNow setDateFormat:@"yyyyMMdd"];
            NSString *dateStrNow = [formatDateNow stringFromDate:dateNow];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"PocketExpenseData.csv"];
            
            //向文件中添加内容
            NSString *dtabContents = [mailSendArray componentsJoinedByString:@"\n"];
            [dtabContents writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            [mail addAttachmentData:[NSData dataWithContentsOfFile:appFile]
                           mimeType:@"text/csv"
                           fileName:[NSString stringWithFormat:@"PocketExpense_data_%@.csv",dateStrNow]];
            [self presentViewController:mail animated:YES completion:nil];

            
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_No Mail Accounts", nil) message:NSLocalizedString(@"VC_Please set up a mail account in order to send mail.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            [alertView show];
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
            appDelegate.appAlertView = alertView;
        }
        
    }
}

-(NSMutableArray *)getTransactionByAccountandCategory{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //2.获取相应的account,category的交易
    NSError * error=nil;
	NSDictionary *subs;
	NSString *fetchName;
	NSMutableArray *tmpfilterTranscation = [[NSMutableArray alloc] init];
    
    //获取的选中的account
    for (int i = 0; i<[accountArray count];i++) {
        
        //获取每一个选中的account底下每一个选中的category底下的交易
        Accounts *as = [accountArray objectAtIndex:i];
        
        for (int j = 0; j<[categoryArray count];j++) {
            Category *cs = [categoryArray objectAtIndex:j];
            
            subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",as,@"expenseAccount" ,self.startDate,@"startDate",self.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
            fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateAll";
            
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [tmpfilterTranscation addObjectsFromArray:objects];

        }
        
    }
    
    
    NSSortDescriptor* sort1;
    NSMutableArray *sorArray = [[NSMutableArray alloc]init];
    if (groupCategoryBtn.selected)
    {
        if (sequenceAscBtn.selected)
        {
            sort1 = [[NSSortDescriptor alloc]initWithKey:@"category.categoryName" ascending:YES];
            [sorArray addObject:sort1];
            
        }
        else
        {
            sort1 = [[NSSortDescriptor alloc]initWithKey:@"category.categoryName" ascending:NO];
            [sorArray addObject:sort1];
            
            
        }
    }
    else
    {
        if (sequenceAscBtn.selected)
        {
            sort1 = [[NSSortDescriptor alloc]initWithKey:@"expenseAccount.accName" ascending:YES];
            NSSortDescriptor* sort2 =[[NSSortDescriptor alloc]initWithKey:@"incomeAccount.accName" ascending:YES];
            [sorArray addObject:sort1];
            [sorArray addObject:sort2];

        }
        else
        {
            sort1 = [[NSSortDescriptor alloc]initWithKey:@"expenseAccount.accName" ascending:NO];
            NSSortDescriptor* sort2 =[[NSSortDescriptor alloc]initWithKey:@"incomeAccount.accName" ascending:NO];
            [sorArray addObject:sort1];
            [sorArray addObject:sort2];

        }

        
        
    }
    
    //把数组按照account,或者cateogy一下
    NSArray *ar = [tmpfilterTranscation sortedArrayUsingDescriptors:sorArray];
    
    NSMutableArray *filterTranscation = [[NSMutableArray alloc]init];
    [filterTranscation setArray:ar];
    
    
//    NSLog(@"////////////////////");
//    //打印原本的数组
//    for (int i=0; i<[filterTranscation count]; i++) {
//        Transaction *oneTransaction = [filterTranscation objectAtIndex:i];
//    }
    
    return filterTranscation;
}
-(void)groupCategoryBtnPressed:(id)sender{
    groupCategoryBtn.selected = YES;
    groupAccountBtn.selected = NO;
}

-(void)groupAccountBtnPressed:(id)sender{
    groupCategoryBtn.selected = NO;
    groupAccountBtn.selected = YES;
}

-(void)sequenceAscBtn:(id)sender{
    sequenceAscBtn.selected = YES;
    sequenceDesBtn.selected = NO;
}

-(void)sequenceDesBtn:(id)sender{
    sequenceAscBtn.selected = NO;
    sequenceDesBtn.selected = YES;
}


-(void)dateSelected
{
    PokcetExpenseAppDelegate* appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (self.selectedIndex.row == 3)
	{
		self.startDate = [appDelegate.epnc getFirstSecByDate:self.datePicker.date];
        
		if ([appDelegate.epnc dateIsToday:self.startDate])
		{
			lblStartDate.text = @"Today";
		}
		else
		{
            NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
            [outputFormatter setTimeStyle:NSDateFormatterNoStyle];
            lblStartDate.text = [outputFormatter stringFromDate:self.startDate];
		}
	}
	else if (self.selectedIndex.row == 4)
	{
		self.endDate = [appDelegate.epnc getLastSecByDate:self.endDatePicker.date];
        
        
        if ([appDelegate.epnc dateIsToday:self.endDate])
        {
            lblEndDate.text = @"Today";
        }
        else
        {
            NSDateFormatter* outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
            [outputFormatter setTimeStyle:NSDateFormatterNoStyle];
            lblEndDate.text  = [outputFormatter stringFromDate:self.endDate];
            
        }
 	}
}
#pragma mark TableView Delegate and DataSource
-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex)
    {
        return 7;
    }
    else
        return 6;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex && indexPath.row==self.selectedIndex.row+1)
        return 216;
    else
        return 44.0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	if (indexPath.row == 0)
    {
        return cellGroupBy;
    }
    else if(indexPath.row == 1)
    {
        return cellCategory;
    }
    else if (indexPath.row==2)
        return cellAccount;
    else if(indexPath.row == 3)
    {
        return cellStartDate;
    }
    else if (indexPath.row==4)
    {
        if (self.selectedIndex.row==3)
        {
            return datepickerCell;
        }
        else
            return cellEndDate;
    }
    if (self.selectedIndex.row==4)
    {
        return endDatePickerCell;
    }
    else
        return cellSequence;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

    if (indexPath.row == 1)
    {
        ipad_ExportSelectedCategoryViewController *exportViewContoller = [[ipad_ExportSelectedCategoryViewController alloc]initWithNibName:@"ipad_ExportSelectedCategoryViewController" bundle:nil];
        exportViewContoller.iEmailViewController = self;
        [self.navigationController pushViewController:exportViewContoller animated:YES];
    }
    else if (indexPath.row == 2){
        ipad_ExportSelectedAccountViewController *accountViewController = [[ipad_ExportSelectedAccountViewController alloc]initWithNibName:@"ipad_ExportSelectedAccountViewController" bundle:nil];
        accountViewController.emailViewController = self;
        [self.navigationController pushViewController:accountViewController animated:YES];
    }

    [tableView beginUpdates];
    if (self.selectedIndex)
    {
        if (indexPath.row != self.selectedIndex.row)
        {
            if ((self.selectedIndex.row==3 && indexPath.row==5) || (self.selectedIndex.row==4&&indexPath.row==3))
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
                if (indexPath.row > self.selectedIndex.row) {
                    indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
                }
                self.selectedIndex = indexPath;
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
                self.selectedIndex = nil;


            }
            
        }
        else
        {
            if (self.selectedIndex.row==3||self.selectedIndex.row==4)
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            self.selectedIndex = nil;
        }
        
        
    }
    else
    {
        if (indexPath.row==3||indexPath.row==4)
        {
            self.selectedIndex = indexPath;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
       
        
    }
    
    if (self.selectedIndex)
    {
        [self setDatePicerRange];
    }
    
    [myTableView endUpdates];

    
    
}

-(void)setDatePicerRange
{
    datePicker.date = self.startDate;
    datePicker.maximumDate = self.endDate;
    datePicker.minimumDate = nil;
    
    endDatePicker.date = self.endDate;
    endDatePicker.minimumDate = self.startDate;
    endDatePicker.maximumDate = nil;
}



#pragma mark Mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

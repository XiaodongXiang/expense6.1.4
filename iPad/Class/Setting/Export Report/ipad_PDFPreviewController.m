//
//  ipad_PDFPreviewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "ipad_PDFPreviewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "AccountSelect.h"
#import "CategorySelect.h"
#import "Category.h"
#import "Accounts.h"
#import "ReaderScrollView.h"

#import "ipad_ReportViewController.h"
#import "ipad_RepTransactionFilterViewController.h"
#import "ipad_RepCashflowFilterViewController.h"

@interface ipad_PDFPreviewController ()

@end

@implementation ipad_PDFPreviewController
#define NAV_AREA_SIZE_IPHONE 48.0f

#define CURRENT_PAGE_KEY_IPHONE @"CurrentPage"
#define TRANSCATION_PDF_NAME_IPHONE @"PocketExpenseReport_Transaction.pdf"
#define CASHFLOW_PDF_NAME_IPHONE @"PocketExpenseReport_CashFlow.pdf"
#define BILL_PDF_NAME_IPHONE @"PocketExpenseReport_Bill.pdf"
#define BUDGET_PDF_NAME_IPHONE @"PocketExpenseReport_Budget.pdf"

#define CONTENT_BEGIN_Y_IPHONE 28.0
#define CONTENT_BEGIN_X_IPHONE 40.0
#define CONTENT_END_X_IPHONE 590.0
#define CONTENT_END_Y_IPHONE 750
#define CONTENT_SECTION_HEIGH_IPHONE 20.0

#define CONTENT_HEADTITLE_SIZE_IPHONE 34.0
#define CONTENT_TITLE_SIZE_IPHONE 12.0
#define CONTENT_TEXT_SIZE_IPHONE 10.0
#define CONTENT_LINE_OFFSET 5.0

#define PAGERECT_IPHONE   CGRectMake(0, 0, 630, 891)
#define CONTENT_DATE_COLUMN_IPHONE 5
#define TAP_AREA_SIZE 48.0f


@synthesize     repTranFilterVC,repCashFlowFilterVC,repBudgetFilterVC,repBillFilterVC;
@synthesize     pdfType,pdfPageCount,isAccount;
@synthesize     theScrollView,indicatorView;
@synthesize     tranAccountSelectArray,tranCategorySelectArray,budgetSelectArray,billCategorySelectArray;
@synthesize     itr,icr,ibrep,ibr;
@synthesize     activityIndicatorView;
@synthesize     cunrrentpdfPageIndex;
@synthesize psCenter,psLeft,psRight,attrLeft,attrRight,attrCenter,attrBoldCenter,attrBoldMTLeft;

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[ReaderScrollView class]])
    {
        return YES;
    }
    
	return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = cunrrentpdfPageIndex; // Current page #
            
            
			ReaderContentView *targetView = [contentViews objectAtIndex:page];
            
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[targetView zoomIncrement]; break;
				}
                    
				case 2: // Two finger double tap: zoom --
				{
					[targetView zoomDecrement]; break;
				}
			}
            
			return;
		}
        
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			//[self incrementPageNumber];
            return;
		}
        
		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;
        
		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			//[self decrementPageNumber];
            return;
		}
	}
}

-(void)addGestureRecognizer
{
	//UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	//singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
    
	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1;
    doubleTapOne.numberOfTapsRequired = 2;
    doubleTapOne.delegate = self;
    
	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2;
    doubleTapTwo.numberOfTapsRequired = 2;
    doubleTapTwo.delegate = self;
    
	//[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
    
	//[self.view addGestureRecognizer:singleTapOne]; [singleTapOne release];
	[self.view addGestureRecognizer:doubleTapOne];
	[self.view addGestureRecognizer:doubleTapTwo];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;          // any offset changes
{
    CGFloat pageWidth = scrollView.frame.size.width;
    cunrrentpdfPageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark DataSource
-(void)setAccountSelectDataSource
{
	[tranAccountSelectArray  removeAllObjects];
	
	NSError *error =nil;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpAccountArray  = [[NSMutableArray alloc] initWithArray:objects];

	AccountSelect *as;
	for (int i = 0; i<[tmpAccountArray count]; i++) {
		as = [[AccountSelect alloc] init];
		as.account = [tmpAccountArray objectAtIndex:i];
		as.isSelected = TRUE;
		[tranAccountSelectArray addObject:as];
	}
	
}

-(void)setCategorySelectDataSource
{
	[tranCategorySelectArray removeAllObjects];
	[billCategorySelectArray removeAllObjects];
	
 	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSError *error = nil;
	NSDictionary *subs =[[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"ipad_fetchAllCategory" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];

	CategorySelect *cs;
	for (int i = 0; i<[tmpCategoryArray count]; i++) {
		cs = [[CategorySelect alloc] init];
		cs.category = [tmpCategoryArray objectAtIndex:i];
		cs.isSelect = TRUE;
		[tranCategorySelectArray addObject:cs];
		
	}
 	
	NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest1 setEntity:entity];
	
	// Edit the sort key as appropriate.
 	
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSArray *sortDescriptors1 = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor1, nil];
	
	[fetchRequest1 setSortDescriptors:sortDescriptors1];
	NSArray* objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest1 error:&error];
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects1];
 	
 	
	for (int i=0; i<[tmpArray count]; i++) {
		Category *c = [tmpArray objectAtIndex:i];
		if([c.billItem count]>0)
		{
			cs = [[CategorySelect alloc] init];
			cs.category = [tmpArray objectAtIndex:i];
			cs.isSelect = TRUE;
			[billCategorySelectArray addObject:cs];
			
		}
	}
}



-(void)setBudgetSelectDataSource
{
}

#pragma mark - Custom API
-(void)initMemoryDefine
{
    pdfPageCount =0;
    cunrrentpdfPageIndex =-1;
    contentViews = [[NSMutableArray alloc] init] ;
    
	indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicatorView.hidesWhenStopped = YES;
    indicatorView.frame = CGRectMake((self.view.frame.size.width-37)/2, (self.view.frame.size.height-37)/2, 37, 37);
    
    
    psLeft = [[NSMutableParagraphStyle alloc] init];
    [psLeft setAlignment:NSTextAlignmentLeft];
    [psLeft setLineBreakMode:NSLineBreakByTruncatingTail];
    
    psRight = [[NSMutableParagraphStyle alloc] init];
    [psRight setAlignment:NSTextAlignmentRight];
    [psRight setLineBreakMode:NSLineBreakByTruncatingTail];
    
    psCenter = [[NSMutableParagraphStyle alloc] init];
    [psCenter setAlignment:NSTextAlignmentCenter];
    [psCenter setLineBreakMode:NSLineBreakByTruncatingTail];
    
    self.attrLeft = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,psLeft,NSParagraphStyleAttributeName, nil];
    self.attrRight = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,psRight,NSParagraphStyleAttributeName, nil];
    self.attrCenter = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,psCenter,NSParagraphStyleAttributeName, nil];
    self.attrBoldCenter = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:CONTENT_HEADTITLE_SIZE_IPHONE],NSFontAttributeName,psCenter,NSParagraphStyleAttributeName, nil];
    self.attrBoldMTLeft = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:14],NSFontAttributeName,psLeft,NSParagraphStyleAttributeName, nil];
    
    [self.view addSubview:indicatorView];
    
}

-(void)initPDFScrollVeiw
{
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	// init PDF View
	//	CGRect frame = CGRectZero;
	//
	
 	theScrollView = [[ReaderScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2,0, 320, self.view.frame.size.height)];
	theScrollView.userInteractionEnabled = TRUE;
    theScrollView.pagingEnabled = TRUE;
	theScrollView.scrollsToTop = NO;
	theScrollView.directionalLockEnabled = YES;
	theScrollView.showsVerticalScrollIndicator = NO;
	theScrollView.showsHorizontalScrollIndicator = NO;
	theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  	theScrollView.contentSize = theScrollView.bounds.size;
	theScrollView.backgroundColor = [UIColor clearColor];

    theScrollView.delegate = self;
 	[self.view addSubview:theScrollView ];
    
}


-(void)initNavBarStyle
{
    //left btn
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -12.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = @"PDF";
	self.navigationItem.titleView = 	titleLabel;
    
    UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 60,30);
    [customerButton1 setTitle:NSLocalizedString(@"VC_Send", nil) forState:UIControlStateNormal];
    [customerButton1 setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
	[customerButton1 addTarget:self action:@selector(navBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    
}

-(float) calculateHeightOfTextFromWidth:(NSString*) text withFontSize:(float)fontSize andWedith:(float)w
{
//	CGSize suggestedSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(w, FLT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    
    
    NSDictionary *tmpAttr =  [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:fontSize],NSFontAttributeName,psLeft,NSParagraphStyleAttributeName,psLeft,NSParagraphStyleAttributeName,nil];
    CGRect suggestedSize = [text boundingRectWithSize:CGSizeMake(w, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:tmpAttr context:nil];

	return suggestedSize.size.height==0? fontSize:suggestedSize.size.height;
}

-(void)drawTransactionPDF:(TransactionReports *)tr
{
//	NSMutableArray				   *incomeDataArray = [[NSMutableArray alloc] init];
//    NSMutableArray				   *expenseDataArray= [[NSMutableArray alloc] init];
    NSMutableDictionary            *sectionArray = [[NSMutableDictionary alloc] init];
	double tmpIncome=0,tmpSpent=0;
	double tmpClear=0,tmpUnClear=0;
    
    NSError * error=nil;
	NSDictionary *subs;
	NSString *fetchName ;
    NSString *sortString =@"";
    
    if(tr == nil)
    {
        if(repTranFilterVC.accountBtn.selected)
            sortString =@"Account";
        else sortString =@"Category";
    }
    
    else sortString = tr.sortByAccOrCate;
    
	if([sortString isEqualToString:@"Account"])
	{
		isAccount = TRUE;
	}
	else {
		isAccount = FALSE;
	}
    
    BOOL showTransfer =repTranFilterVC.transferSwitch.on;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //分别存放找到的非transfer数组与transfer数据
	NSMutableArray *filterTranscation = [[NSMutableArray alloc] init];
    NSMutableArray *tmpTransfer = [[NSMutableArray alloc] init];
    
    if(tr == nil)
    {
        
        for (int i = 0; i<[repTranFilterVC.tranAccountSelectArray count];i++) {
            Accounts *as = [repTranFilterVC.tranAccountSelectArray objectAtIndex:i];
            
            for (int j = 0; j<[repTranFilterVC.tranCategorySelectArray count];j++) {
                Category *cs = [repTranFilterVC.tranCategorySelectArray objectAtIndex:j];
                
                if([pdfType isEqualToString:@"TRANALL"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",as,@"expenseAccount" ,repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                    fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateAll";
                    
                }
                else if([pdfType isEqualToString:@"TRANEXPENSE"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"expenseAccount", repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                    fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateExpense";
                    
                }
                else if([pdfType isEqualToString:@"TRANINCOME"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                    fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateIncome";
                    
                }
                NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchRequest setSortDescriptors:sortDescriptors];
                NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                [filterTranscation addObjectsFromArray:objects];
                
                
                
            }
            
            if(showTransfer)
            {
                if([pdfType isEqualToString:@"TRANALL"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",as,@"expenseAccount" ,repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate", nil];
                    fetchName =@"iPad_fetchTransferByAccountWithDateAll";
                    
                }
                else if([pdfType isEqualToString:@"TRANEXPENSE"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"expenseAccount", repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate", nil];
                    fetchName =@"iPad_fetchTransferByAccountWithDateExpense";
                    
                }
                else if([pdfType isEqualToString:@"TRANINCOME"])
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",repTranFilterVC.startDate,@"startDate",repTranFilterVC.endDate,@"endDate", nil];
                    fetchName =@"iPad_fetchTransferByAccountWithDateIncome";
                    
                }
                NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchRequest setSortDescriptors:sortDescriptors];
                NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                if(isAccount)
                {
                    [filterTranscation addObjectsFromArray:objects];
                    
                }
                else {
                    for (int k =0; k<[objects count]; k++) {
                        BOOL isFound = FALSE;
                        Transaction *t1 = [objects objectAtIndex:k];
                        
                        for (int l=0; l<[tmpTransfer count]; l++) {
                            Transaction *t2 = [tmpTransfer objectAtIndex:l];
                            if(t1 == t2)
                            {
                                isFound = TRUE;
                                break;
                            }
                        }
                        if(!isFound) [tmpTransfer addObject:t1];
                    }
                }
                
            }
            
        }
    }
    
    if(!isAccount)
    {
        [filterTranscation addObjectsFromArray:tmpTransfer];
        
    }
    NSInteger tCount =[filterTranscation count];
    
	
	for (int i=0; i<[filterTranscation count];i++) {
		Transaction *t=[filterTranscation objectAtIndex:i];
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
		else if([t.category.categoryType isEqualToString:@"INCOME"])
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
		else {
			for (int j = 0; j<[repTranFilterVC.tranAccountSelectArray count];j++) {
				Accounts *as = [repTranFilterVC.tranAccountSelectArray objectAtIndex:j];
				
                if(t.expenseAccount == as)
                {
                    // tmpSpent +=[t.amount doubleValue];
                    if([t.isClear boolValue])
                    {
                        tmpClear -= [t.amount doubleValue];
                    }
                    else
                    {
                        tmpUnClear -= [t.amount doubleValue];
                    }
                }
                else 	if(t.incomeAccount == as)
                {
                    // tmpIncome += [t.amount doubleValue];
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
			
		}
		
		if(isAccount&&t.incomeAccount!=nil&&t.expenseAccount!=nil)
		{
			NSString *key2,*key1;
            
			key1 =t.incomeAccount.accName;
			key2 = t.expenseAccount.accName;
			NSMutableArray *list1 = [sectionArray valueForKey:key1];
			
			if(list1 == nil)
			{
				NSMutableArray *list2 = [[NSMutableArray alloc] init];
				[list2 addObject:t];
				[sectionArray setObject:list2 forKey:key1];
			}
			else
			{
				NSInteger orderIndex = [list1 indexOfObject:t];
				if(!(orderIndex>=0&&orderIndex<[list1 count]))
                    [list1 addObject:t];
			}
			
            list1 = [sectionArray valueForKey:key2];
			
			if(list1 == nil)
			{
				NSMutableArray *list2 = [[NSMutableArray alloc] init];
				[list2 addObject:t];
				[sectionArray setObject:list2 forKey:key2];
			}
			else
			{
				NSInteger orderIndex = [list1 indexOfObject:t];
				if(!(orderIndex>=0&&orderIndex<[list1 count]))
                    
                    [list1 addObject:t];
			}
			
		}
		else {
			NSString *key;
			if(isAccount)
			{
				if(t.incomeAccount!=nil)
				{
					key =t.incomeAccount.accName;
				}
				else {
					key = t.expenseAccount.accName;
				}
				
			}
			else {
                
                if(t.category == nil)
                {
                    key =[NSString stringWithFormat:@"To %@",t.incomeAccount.accName];
                }
				else key =t.category.categoryName;
				
			}
			
			NSMutableArray *list1 = [sectionArray valueForKey:key];
			
			if(list1 == nil)
			{
				NSMutableArray *list2 = [[NSMutableArray alloc] init];
				[list2 addObject:t];
				[sectionArray setObject:list2 forKey:key];
			}
			else
			{
				[list1 addObject:t];
			}
			
			
		}
	}
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Gen Report PDF
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
 	NSString* dateString = [outputFormatter stringFromDate:[NSDate date]];
	NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:TRANSCATION_PDF_NAME_IPHONE];
	const char *filename = [newFilePath UTF8String];
    CFStringRef path = CFStringCreateWithCString (NULL, filename,
												  kCFStringEncodingUTF8);
	CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path,
												  kCFURLPOSIXPathStyle, 0);
	CFRelease (path);
	CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(NULL, 0,
																	&kCFTypeDictionaryKeyCallBacks,
																	&kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
	CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
 	CFRelease(myDictionary);
	CFRelease(url);
	CGRect pageRect = CGRectMake(0, 0, 600, 800);
	
	UIGraphicsBeginPDFContextToFile(newFilePath, pageRect, [NSDictionary dictionary]);
	CGContextRef pdfContext = UIGraphicsGetCurrentContext();
	pdfPageCount =1;
	CGContextSetAllowsAntialiasing(pdfContext, FALSE);
	
	UIGraphicsBeginPDFPage();
	
 	//Draw Title
	CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
	
    [@"Transactions Report" drawInRect:CGRectMake(0, CONTENT_BEGIN_Y_IPHONE, 620, 40) withAttributes:attrBoldCenter];
    
	CGContextSetRGBFillColor (pdfContext, 128.f/255.f, 128.f/255.f,128.f/255.f, 1);
	
    [@"Report Date:" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 90, 300, 40) withAttributes:attrLeft];
    
    [dateString drawInRect:CGRectMake(125, 90, 300, 40) withAttributes:attrLeft];
    
    [@"Generated by Expense 5" drawInRect:CGRectMake(385, 90, 200, 40) withAttributes:attrRight];
    
	
  	
	//Draw Line
	CGContextSetLineWidth(pdfContext, 4.0);
	CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
	
 	CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 110);
	CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE,110);
	CGContextStrokePath(pdfContext);
	
    [repTranFilterVC.lblDateRange.text drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 120, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:attrCenter];
    
	
 	
	//Draw Line
	CGContextSetLineWidth(pdfContext, 1.0);
	CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 145);
	CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, 145);
	CGContextStrokePath(pdfContext);
	CGContextSetRGBFillColor (pdfContext, 88.f/255.f, 88.f/255.f,88.f/255.f, 1);
	
    [@"Total Expense:" drawInRect:CGRectMake(40, 155, 300, 40) withAttributes:attrLeft];
    
    
    [@"Total Cleared:" drawInRect:CGRectMake(260, 155, 300, 40) withAttributes:attrLeft];
    
	
    [@"Total Income:" drawInRect:CGRectMake(40, 175, 300, 40) withAttributes:attrLeft];
    
    [@"Total Uncleared:" drawInRect:CGRectMake(260, 175, 300, 40) withAttributes:attrLeft];
    
	
    [[appDelegate.epnc formatterString:tmpSpent] drawInRect:CGRectMake(140, 155, 300, 40) withAttributes:attrLeft];
    
    [[appDelegate.epnc formatterString:tmpClear] drawInRect:CGRectMake(370, 155, 300, 40) withAttributes:attrLeft];
    
	if(tCount == 1)
	{
        [@"1 Transaction" drawInRect:CGRectMake(385, 155, 200, 40) withAttributes:attrLeft];
        
		
	}
	else {
        [[NSString stringWithFormat:@"%ld Transactions",(long)tCount] drawInRect:CGRectMake(385, 155, 200, 40) withAttributes:attrRight];
        
	}
	
	
    [[appDelegate.epnc formatterString:tmpIncome] drawInRect:CGRectMake(140, 175, 300, 40) withAttributes:attrLeft];
    
    [[appDelegate.epnc formatterString:tmpUnClear] drawInRect:CGRectMake(370, 175, 300, 40) withAttributes:attrLeft];
    
	
	//draw line
 	CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 200);
	CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, 200);
	CGContextStrokePath(pdfContext);
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 	//Draw Conunt Info
	NSInteger contextRecordBegin =220;
	
	NSArray *array ;
	NSMutableArray *list;
 	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    BOOL orderAsc = TRUE;
  	if(orderAsc)
	{
		array= [[sectionArray allKeys] sortedArrayUsingSelector:@selector(psuedoNumericCompareByAsc:)];
	}
	else {
		array= [[sectionArray allKeys] sortedArrayUsingSelector:@selector(psuedoNumericCompareByDesc:)];
		
	}
	
	for (int i = 0; i<[sectionArray count];i++) {
		double totalAmount =0.0;
		NSString *nameLabel =[[array objectAtIndex:i] copy] ;
		CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);
		
// 		[nameLabel drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, 300, 20) withFont:[UIFont fontWithName:@"Arial-BoldMT" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [nameLabel drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, 300, 20) withAttributes:attrBoldMTLeft];
        
		contextRecordBegin+=20;
		CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
		CGContextSetLineWidth(pdfContext, 1.0);
		CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
		CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
		CGContextStrokePath(pdfContext);
		
		CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
		
// 		[@"Date" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [@"Date" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
//		[@"Payee" drawInRect:CGRectMake(180, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [@"Payee" drawInRect:CGRectMake(180, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
		
		if(isAccount)
		{
//			[@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
            
			
 		}
		else {
//			[@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
            
		}
		
//		[@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
		
//		[@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
		
 	 	contextRecordBegin +=CONTENT_SECTION_HEIGH_IPHONE;
		
 		CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
		CGContextAddLineToPoint(pdfContext,  CONTENT_END_X_IPHONE, contextRecordBegin);
		CGContextStrokePath(pdfContext);
		
 		list= [sectionArray valueForKey:[array objectAtIndex:i]];
	 	NSSortDescriptor *sort  = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
		NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
	 	[list sortUsingDescriptors:sorts];
		
		for (int j =0; j<[list count]; j++)
        {
			Transaction *t  =[list objectAtIndex:j];
            NSString *accountValueLabel;
 			NSString *payeeValueLabel = t.payee==nil? @"":t.payee.name;
            
            if(!isAccount)
			{
				if([t.category.categoryType isEqualToString:@"EXPENSE"]||[t.category.categoryType isEqualToString:@"INCOME"])
				{
					accountValueLabel=t.incomeAccount==nil? t.expenseAccount.accName:t.incomeAccount.accName ;
                    
				}
                else if (t.category == nil && [t.childTransactions count]>0)
                {
                    accountValueLabel = t.expenseAccount.accName;
                }
				else
				{
					if(t.incomeAccount !=nil&&t.expenseAccount !=nil)
					{
                        accountValueLabel=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER From", nil),t.expenseAccount.accName ];
					}
					else {
						accountValueLabel = @"transfer";
						
					}
                    
				}
			}
			else {
                if([t.category.categoryType isEqualToString:@"EXPENSE"]||[t.category.categoryType isEqualToString:@"INCOME"])
                {
                    accountValueLabel=t.category==nil? @"":t.category.categoryName;
                }
                else if (t.category == nil && [t.childTransactions count]>0)
                {
                    accountValueLabel = t.expenseAccount.accName;
                }
                else
				{
					if(t.incomeAccount !=nil&&t.expenseAccount !=nil)
					{
						if([t.incomeAccount.accName isEqualToString:nameLabel]&&t.expenseAccount !=nil )
						{
							accountValueLabel=[NSString stringWithFormat:@"From %@",t.expenseAccount.accName];
						}
						else 	if([t.expenseAccount.accName isEqualToString:nameLabel]&&t.incomeAccount !=nil )
						{
							accountValueLabel=[NSString stringWithFormat:@"To %@",t.incomeAccount.accName];
                            
						}
                        
					}
					else {
						accountValueLabel = @"transfer";
						
					}
                    
				}
                
			}
            NSString *amountValueLabel;
			if([t.category.categoryType isEqualToString:@"EXPENSE"]&&[t.amount doubleValue]!=0)
			{
				amountValueLabel=[appDelegate.epnc formatterString:0-[t.amount doubleValue]] ;
				totalAmount -=[t.amount doubleValue];
			}
			else 	if([t.category.categoryType isEqualToString:@"INCOME"]&&[t.amount doubleValue]!=0)
            {
				amountValueLabel=[appDelegate.epnc formatterString:[t.amount doubleValue]] ;
                totalAmount +=[t.amount doubleValue];
                
			}
            else if (t.category == nil && [t.childTransactions count]>0)
            {
                amountValueLabel=[appDelegate.epnc formatterString:0-[t.amount doubleValue]] ;
				totalAmount -=[t.amount doubleValue];
            }
            else {
                if(isAccount)
                {
                    if([t.incomeAccount.accName isEqualToString:nameLabel]&&t.expenseAccount !=nil )
                    {
                        amountValueLabel=[appDelegate.epnc formatterString:[t.amount doubleValue]] ;
                        totalAmount +=[t.amount doubleValue];
                        
                    }
                    else 	if([t.expenseAccount.accName isEqualToString:nameLabel]&&t.incomeAccount !=nil )
                    {
                        amountValueLabel=[appDelegate.epnc formatterString:0-[t.amount doubleValue]] ;
                        totalAmount -=[t.amount doubleValue];
                        
                    }
                    
                }
                else {
                    amountValueLabel=[appDelegate.epnc formatterString:[t.amount doubleValue]] ;
                    totalAmount +=[t.amount doubleValue];
                    
                }
            }
			NSString *dateValueLabel = [outputFormatter stringFromDate:t.dateTime];
 			NSString *memoValueLabel = t.notes;
            
            float rectH=0.0;
			float rectH1 = [self calculateHeightOfTextFromWidth:memoValueLabel  withFontSize:CONTENT_TEXT_SIZE_IPHONE andWedith:110]+CONTENT_LINE_OFFSET *2;
            
            float rectH2 = [self calculateHeightOfTextFromWidth:accountValueLabel  withFontSize:CONTENT_TEXT_SIZE_IPHONE andWedith:120.0]+CONTENT_LINE_OFFSET *2;
            
            float rectH3 = [self calculateHeightOfTextFromWidth:payeeValueLabel  withFontSize:CONTENT_TEXT_SIZE_IPHONE andWedith:70.0]+CONTENT_LINE_OFFSET *2;
            
            rectH = (rectH1>((rectH2>rectH3)? rectH2:rectH3))? rectH1:((rectH2>rectH3)? rectH2:rectH3);
			if([t.isClear boolValue])
			{
				CGContextDrawImage(pdfContext, CGRectMake(40,contextRecordBegin +(rectH-25)/2, 25, 25),[[UIImage imageNamed:@"pdf_cleared.png"]  CGImage]);
				
			}
			else {
				CGContextDrawImage(pdfContext, CGRectMake(40,contextRecordBegin +(rectH-25)/2, 25, 25),[[UIImage imageNamed:@"pdf_uncleared.png"]  CGImage]);
				
			}
			CGContextSetRGBFillColor (pdfContext,100.f/255.f, 100.f/255.f,100.f/255.f, 1);
			
//			[dateValueLabel drawInRect:CGRectMake(80, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TEXT_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [dateValueLabel drawInRect:CGRectMake(80, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withAttributes:attrLeft];
            
//			[payeeValueLabel drawInRect:CGRectMake(180, contextRecordBegin+(rectH-rectH3)/2+CONTENT_LINE_OFFSET, 70.0, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TEXT_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [payeeValueLabel drawInRect:CGRectMake(180, contextRecordBegin+(rectH-rectH3)/2+CONTENT_LINE_OFFSET, 70.0, rectH) withAttributes:attrLeft];
            
            
//            [accountValueLabel drawInRect:CGRectMake(260, contextRecordBegin+(rectH-rectH2)/2+CONTENT_LINE_OFFSET, 120.0, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TEXT_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [accountValueLabel drawInRect:CGRectMake(260, contextRecordBegin+(rectH-rectH2)/2+CONTENT_LINE_OFFSET, 120.0, rectH) withAttributes:attrLeft];
            
 			
//			[amountValueLabel drawInRect:CGRectMake(385, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TEXT_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [amountValueLabel drawInRect:CGRectMake(385, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withAttributes:attrLeft];
            
//            [memoValueLabel drawInRect:CGRectMake(480, contextRecordBegin+(rectH-rectH1)/2+CONTENT_LINE_OFFSET , 110, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TEXT_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
            [memoValueLabel drawInRect:CGRectMake(480, contextRecordBegin+(rectH-rectH1)/2+CONTENT_LINE_OFFSET , 110, rectH) withAttributes:attrLeft];
            
   			contextRecordBegin +=rectH;
			
			CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
			CGContextSetLineWidth(pdfContext, 1.0);
			CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
			CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
			CGContextStrokePath(pdfContext);
 			if(contextRecordBegin>=CONTENT_END_Y_IPHONE&& j!=[list count]-1)
			{
				UIGraphicsBeginPDFPage();
				
				pdfPageCount++;
				contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
				CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);
				
//				[nameLabel drawInRect:CGRectMake(40, contextRecordBegin, 300, 20) withFont:[UIFont fontWithName:@"Arial-BoldMT" size:14] lineBreakMode:NSLineBreakByWordWrapping];
                [nameLabel drawInRect:CGRectMake(40, contextRecordBegin, 300, 20) withAttributes:attrBoldMTLeft];
                
				contextRecordBegin+=20;
				CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
				CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
				
				CGContextSetLineWidth(pdfContext, 1.0);
				CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
				CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
				CGContextStrokePath(pdfContext);
				CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
				
//				[@"Date" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Date" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
//				[@"Payee" drawInRect:CGRectMake(180, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Payee" drawInRect:CGRectMake(180, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
				if(isAccount)
				{
//					[@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                    
				}
				else {
//					[@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                    
				}
				
//				[@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
				
//				[@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
				
				contextRecordBegin +=20;
				
				CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
				CGContextAddLineToPoint(pdfContext,  CONTENT_END_X_IPHONE, contextRecordBegin);
				CGContextStrokePath(pdfContext);
				
 				
			}
		}
		
//        [@"Total:" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [@"Total:" drawInRect:CGRectMake(80, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
//        [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
        [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
        
        contextRecordBegin +=40;
        
 		if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
		{
			UIGraphicsBeginPDFPage();
			pdfPageCount++;
			CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
			
 			contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
 			
		}
		
	}
	
	CGContextStrokePath(pdfContext);
	UIGraphicsEndPDFContext();
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	NSURL *fileURL = [NSURL fileURLWithPath:newFilePath];
    theScrollView.contentSize = CGSizeMake(pdfPageCount*320,0);
	for (UIView *_tmpview in [theScrollView subviews])
	{
        [_tmpview removeFromSuperview];
	}
	
    
    cunrrentpdfPageIndex =0;
	
    for (int i=1; i<=pdfPageCount; i++) {
        
        ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(10+320*(i-1),0,300, 440) fileURL:fileURL page:i password:nil];
        
        //UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"report_pdf_bg.png"]];
        // bgImage.frame=CGRectMake(0, 420*(i-1),300, 420 );
        //[theScrollView addSubview: bgImage];
        
        [theScrollView addSubview:thePDFView1];
        [contentViews addObject:thePDFView1];
        
        //[bgImage release];
    }
    
	
 	[self.indicatorView stopAnimating];
    [self.activityIndicatorView stopAnimating];
    
    
}


-(void)drawCashFlowPDF:(CashFlowReports *)cr
{

	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSError *error = nil;
 	//Gen Report PDF
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
 	NSString* dateString = [outputFormatter stringFromDate:[NSDate date]];
	NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CASHFLOW_PDF_NAME_IPHONE];
	const char *filename = [newFilePath UTF8String];
    CFStringRef path = CFStringCreateWithCString (NULL, filename,
												  kCFStringEncodingUTF8);
	CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path,
												  kCFURLPOSIXPathStyle, 0);
	CFRelease (path);
	CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(NULL, 0,
																	&kCFTypeDictionaryKeyCallBacks,
																	&kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
	CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
 	CFRelease(myDictionary);
	CFRelease(url);
	CGRect pageRect = CGRectMake(0, 0, 620, 877);
	
	UIGraphicsBeginPDFContextToFile(newFilePath, pageRect, [NSDictionary dictionary]);
	CGContextRef pdfContext = UIGraphicsGetCurrentContext();
	pdfPageCount =1;
	CGContextSetAllowsAntialiasing(pdfContext, FALSE);
	
 	UIGraphicsBeginPDFPage();
	
 	//Draw Title
	CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
	
//	[@"Cash Flow Report" drawInRect:CGRectMake(0, CONTENT_BEGIN_Y_IPHONE, 620, 40) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:CONTENT_HEADTITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    [@"Cash Flow Report" drawInRect:CGRectMake(0, CONTENT_BEGIN_Y_IPHONE, 620, 40) withAttributes:attrBoldCenter];
    
	CGContextSetRGBFillColor (pdfContext, 128.f/255.f, 128.f/255.f,128.f/255.f, 1);
	
//	[@"Report Date:" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 90, 300, 40) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
    [@"Report Date:" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 90, 300, 40) withAttributes:attrLeft];
    
//	[dateString drawInRect:CGRectMake(125, 90, 300, 40) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
    [dateString drawInRect:CGRectMake(125, 90, 300, 40) withAttributes:attrLeft];
    
    
//	[@"Generated by Pocket Expense" drawInRect:CGRectMake(390, 90, 200, 40) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping   alignment:NSTextAlignmentRight];
    [@"Generated by Expense 5" drawInRect:CGRectMake(385, 90, 200, 40) withAttributes:attrRight];
    
	
  	
	//Draw Line
	CGContextSetLineWidth(pdfContext, 4.0);
	CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
	
 	CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 110);
	CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE,110);
	CGContextStrokePath(pdfContext);
//	[repCashFlowFilterVC.lblDateRange.text drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 120, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    [repCashFlowFilterVC.lblDateRange.text drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 120, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:attrCenter];
    
	
	
	NSInteger contextRecordBegin =145;
	CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);
	
    NSString *colunmString;
    NSDate   *cfStartDate;
    NSDate   *cfEndDate;
    
    if(cr == nil)
    {
        if ([repCashFlowFilterVC.lblDateColumn.text isEqualToString:NSLocalizedString(@"VC_Week", nil)])
        {
            colunmString = @"Week";
        }
        else
        {
            colunmString = @"Month";
        }
//        colunmString = repCashFlowFilterVC.lblDateColumn.text;
        cfStartDate =repCashFlowFilterVC.startDate;
        cfEndDate = repCashFlowFilterVC.endDate;
    }
    else
    {

        colunmString = cr.columnString;
        cfStartDate =cr.startDate;
        cfEndDate = cr.endDate;
        
    }
    
   	if([colunmString isEqualToString:@"Account"])
	{
 		NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys: cfStartDate,@"startDate",cfEndDate,@"endDate",  nil];
		NSString *fetchName  =@"iPad_fetchTransactionByDateSplit";
		
		NSMutableArray *filterTranscation = [[NSMutableArray alloc] init];
		
		NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
		NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		[filterTranscation addObjectsFromArray:objects];
		NSMutableDictionary *sectionArray = [[NSMutableDictionary alloc] init];
		
	 	for (int i=0; i<[filterTranscation count];i++) {
			Transaction *t=[filterTranscation objectAtIndex:i];
			
			NSString *key;
			
			if(t.incomeAccount!=nil)
			{
				key =t.incomeAccount.accName;
			}
			else {
				key = t.expenseAccount.accName;
			}
			NSMutableArray *list1 = [sectionArray valueForKey:key];
			
			if(list1 == nil)
			{
				NSMutableArray *list2 = [[NSMutableArray alloc] init];
				[list2 addObject:t];
				[sectionArray setObject:list2 forKey:key];
			}
			else
			{
				[list1 addObject:t];
			}
			
			
		}
	}
	else if([colunmString isEqualToString:@"Payee"]){
		
	}
	else {
		NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys: cfStartDate,@"startDate",cfEndDate,@"endDate",  nil];
		NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"ipad_fetchAllHasTranCategory" substitutionVariables:subs];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
		NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		NSMutableArray *categoryArray  = [[NSMutableArray alloc] initWithArray:objects];
        
        
        //过滤数据----
        NSArray *sorts = [NSArray arrayWithObject:[[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:YES]];
        NSMutableArray *categoryArrayNew = [[NSMutableArray alloc]init];
        [categoryArrayNew removeAllObjects];
        for (int i=0; i<[categoryArray count]; i++)
        {
            Category *oneCate = [categoryArray objectAtIndex:i];
            NSArray *trans = [[NSArray alloc]initWithArray:[oneCate.transactions allObjects]];
            
            NSMutableArray *transarrayNew = [[NSMutableArray alloc]init];
            for (int m=0; m<[trans count]; m++)
            {
                Transaction *oneTrans = [trans objectAtIndex:m];
                if ([oneTrans.state isEqualToString:@"1"])
                {
                    [transarrayNew addObject:oneTrans];
                }
            }
            
            NSMutableArray *transarray = [[NSMutableArray alloc]init];
            [transarray setArray:[transarrayNew sortedArrayUsingDescriptors:sorts]];
            if ([transarray count]>0)
            {
                Transaction *firstTrans = [trans firstObject];
                Transaction *lastTrans = [trans lastObject];
                if ([appDelegate.epnc dateCompare:lastTrans.dateTime withDate:cfStartDate]<0)
                {
                    continue;
                }
                
                if ([appDelegate.epnc dateCompare:firstTrans.dateTime withDate:cfEndDate]>0)
                {
                    continue;
                }
                
                [categoryArrayNew addObject:oneCate];
                
            }
            
        }
        
        //将最终的结果按照时间排序
        [categoryArray removeAllObjects];
        [categoryArray setArray:[categoryArrayNew sortedArrayUsingDescriptors:sorts]];
        //过滤数据结束----
		
		NSInteger dateColumn  = [appDelegate.epnc getCountOfInsert:cfStartDate repeatEnd:cfEndDate typeOfRecurring:colunmString];
		dateColumn+=1;
		NSInteger dateRows=0;
		NSInteger lastRowCount = 0;
		NSDate *lastStartDate = cfStartDate ;
		if(dateColumn%CONTENT_DATE_COLUMN_IPHONE == 0)
		{
			dateRows = dateColumn/CONTENT_DATE_COLUMN_IPHONE;
			lastRowCount = CONTENT_DATE_COLUMN_IPHONE;
		}
		else {
			dateRows = dateColumn/CONTENT_DATE_COLUMN_IPHONE+1;
			lastRowCount = dateColumn-(dateRows-1)*CONTENT_DATE_COLUMN_IPHONE;
			
		}
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        if([pdfType isEqualToString:@"ALLFLOW"]||[pdfType isEqualToString:@"INFLOW"] )
        {
//            [@"Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withFont:[UIFont fontWithName:@"Arial-BoldMT" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            [@"Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:attrBoldMTLeft];
            
            contextRecordBegin += CONTENT_SECTION_HEIGH_IPHONE;
            //Draw Line
            CGContextSetLineWidth(pdfContext, 1.0);
            CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
            CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
            CGContextStrokePath(pdfContext);
            
            CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
            if([colunmString isEqualToString:@"Year"])
            {
                [outputFormatter setDateFormat:@"MMM yyyy"];
            }
            else {
                [outputFormatter setDateFormat:@"MMM dd"];
                
            }
            
            for(int i =0 ;i<dateRows;i++)
            {
                
                if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
                {
                    UIGraphicsBeginPDFPage();
                    pdfPageCount++;
                    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                    
                    contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                    
                }
                NSInteger columnCountForRows = (i!= dateRows -1)? CONTENT_DATE_COLUMN_IPHONE:lastRowCount;
//                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
                
                NSDate *rowStartDate;
                CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    if(j==0) rowStartDate = lastStartDate ;
                    if(i==dateRows-1&&j==columnCountForRows-1)
                    {
//                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                        
                        
                    }
                    else {
                        
                        NSDate *tmpDate =[appDelegate.epnc getDate:lastStartDate byCycleType:colunmString];
                        
                        NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                        
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
                        [dc1 setDay:-1];
                        
                        NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                        
                        
//                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                        
                        
                        
//                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                        
                        
                        lastStartDate =tmpDate ;
                        
                    }
                    
                    
                }
                contextRecordBegin +=40;
                
                //Draw Line
                CGContextSetLineWidth(pdfContext, 1.0);
                CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
                CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
                CGContextStrokePath(pdfContext);
                
                NSMutableArray *tmpAmountCount = [[NSMutableArray alloc] init];
                //Draw Context
                for (int k = 0; k<[categoryArray count]; k++) {
                    //
                    NSDate *columnStartDate = rowStartDate;
                    //
                    NSMutableArray *tmpCategoryAmount = [[NSMutableArray alloc] init];
                    
                    if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
                    {
                        UIGraphicsBeginPDFPage();
                        pdfPageCount++;
                        CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                        
                        contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                        
                    }
                    CGContextSetRGBFillColor (pdfContext,100.f/255.f, 100.f/255.f,100.f/255.f, 1);
                    
                    Category *c = [categoryArray objectAtIndex:k];
                    float rectH = [self calculateHeightOfTextFromWidth:c.categoryName  withFontSize:CONTENT_TITLE_SIZE_IPHONE andWedith:150]+20.f;
//                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withAttributes:attrLeft];
                    
                    
                    NSMutableArray *tmpTranscations =[[NSMutableArray alloc] initWithArray:[c.transactions allObjects]];
                    NSSortDescriptor *sort  = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
                    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                    [tmpTranscations sortUsingDescriptors:sorts];
                 
                    NSInteger searchTranscationIndex=-1;
                    if([tmpTranscations count]>0) searchTranscationIndex=0;
                    
                    for (int j=0; j<columnCountForRows; j++)
                    {
                        if(i==dateRows-1&&j==columnCountForRows-1)
                        {
                            double totalAmount=0.0;
                            
                            for (int l=0; l<[tmpTranscations count]; l++) {
                                Transaction *tmpT = [tmpTranscations objectAtIndex:l];
                                if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:cfStartDate]>=0&&[appDelegate.epnc dateCompare:tmpT.dateTime withDate:cfEndDate]<=0)
                                {
                                    if([tmpT.category.categoryType isEqualToString:@"INCOME"])
                                    {
                                        totalAmount +=[tmpT.amount doubleValue];
                                    }
                                }
                                
                            }
                            [tmpCategoryAmount addObject:[NSNumber numberWithDouble:totalAmount ]];
//                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withAttributes:attrLeft];
                            
                            
                        }
                        else {
                            if(searchTranscationIndex ==-1)
                            {
//                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:attrLeft];
                                
                                [tmpCategoryAmount addObject:[NSNumber numberWithDouble:0.0 ]];
                                
                            }
                            else {
                                NSDate *tmpDate =[appDelegate.epnc getDate:columnStartDate byCycleType:colunmString];
                                
                                NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                                
                                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
                                [dc1 setDay:-1];
                                
                                NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                                
                                
                                double totalAmount=0.0;
                                for (long l=searchTranscationIndex; l<[tmpTranscations count]; l++) {
                                    Transaction *tmpT = [tmpTranscations objectAtIndex:l];
                                    if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:columnStartDate]>=0&&[appDelegate.epnc dateCompare:tmpT.dateTime withDate:tmpEndDate]<=0)
                                    {
                                        if([tmpT.category.categoryType isEqualToString:@"INCOME"])
                                        {
                                            totalAmount +=[tmpT.amount doubleValue];
                                        }
                                    }
                                    else if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:tmpEndDate]>0){
                                        searchTranscationIndex =l;
                                        break;
                                    }
                                }
                                columnStartDate =tmpDate ;
                                [tmpCategoryAmount addObject:[NSNumber numberWithDouble:totalAmount ]];
                                
//                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:attrLeft];
                                
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    [tmpAmountCount addObject:tmpCategoryAmount];
                   
                    //contextRecordBegin +=20;
                    contextRecordBegin +=rectH;
                    
                }
                
                
//                [@"Total Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Total Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    double columnAmount =0.0;
                    for (int m =0; m<[tmpAmountCount count];m++) {
                        NSMutableArray *tmpArray = [tmpAmountCount objectAtIndex:m];
                        columnAmount += [[tmpArray objectAtIndex:j] doubleValue];
                    }
                    
//                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                    
                    
                }
                contextRecordBegin +=40;
                
            }
            
            lastStartDate = cfStartDate;
            contextRecordBegin +=2*CONTENT_SECTION_HEIGH_IPHONE;
            
            if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
            {
                UIGraphicsBeginPDFPage();
                pdfPageCount++;
                CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                
                contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                
            }
        }
        if([pdfType isEqualToString:@"ALLFLOW"] ||[pdfType isEqualToString:@"OUTFLOW"])
        {
//            [@"Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withFont:[UIFont fontWithName:@"Arial-BoldMT" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            [@"Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:attrBoldMTLeft];
            
            contextRecordBegin += CONTENT_SECTION_HEIGH_IPHONE;
            //Draw Line
            CGContextSetLineWidth(pdfContext, 1.0);
            CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
            CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
            CGContextStrokePath(pdfContext);
            
            CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
            for(int i =0 ;i<dateRows;i++)
            {
                
                if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
                {
                    UIGraphicsBeginPDFPage();
                    pdfPageCount++;
                    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                    
                    contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                    
                }
                NSInteger columnCountForRows = (i!= dateRows -1)? CONTENT_DATE_COLUMN_IPHONE:lastRowCount;
//                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
                
                NSDate *rowStartDate;
                CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    if(j==0) rowStartDate = lastStartDate;
                    
                    if(i==dateRows-1&&j==columnCountForRows-1)
                    {
//                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE)  withAttributes:attrLeft];
                        
                        
                    }
                    else {
                        NSDate *tmpDate =[appDelegate.epnc getDate:lastStartDate byCycleType:colunmString];
                        
                        NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                        
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
                        [dc1 setDay:-1];
                        
                        NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                        
                        
//                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                        
                        
//                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                        
                        
                        lastStartDate =tmpDate ;
                        
                    }
                    
                    
                }
                contextRecordBegin +=40;
                
                //Draw Line
                CGContextSetLineWidth(pdfContext, 1.0);
                CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
                CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
                CGContextStrokePath(pdfContext);
                NSMutableArray *tmpAmountCount = [[NSMutableArray alloc] init];
                
                //Draw Context
                for (int k = 0; k<[categoryArray count]; k++) {
                    NSMutableArray *tmpCategoryAmount = [[NSMutableArray alloc] init];
                    //
                    NSDate *columnStartDate = rowStartDate ;
                    //
                    
                    if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
                    {
                        UIGraphicsBeginPDFPage();
                        pdfPageCount++;
                        CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                        
                        contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                        
                    }
                    CGContextSetRGBFillColor (pdfContext,100.f/255.f, 100.f/255.f,100.f/255.f, 1);
                    
                    Category *c = [categoryArray objectAtIndex:k];
                    float rectH = [self calculateHeightOfTextFromWidth:c.categoryName  withFontSize:CONTENT_TITLE_SIZE_IPHONE andWedith:150]+20.f;
//                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withAttributes:attrLeft];
                    
                    
                    NSMutableArray *tmpTranscations =[[NSMutableArray alloc] initWithArray:[c.transactions allObjects]];
                    NSSortDescriptor *sort  = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
                    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                    [tmpTranscations sortUsingDescriptors:sorts];
                    
                    NSInteger searchTranscationIndex=-1;
                    if([tmpTranscations count]>0) searchTranscationIndex=0;
                    
                    for (int j=0; j<columnCountForRows; j++)
                    {
                        
                        if(i==dateRows-1&&j==columnCountForRows-1)
                        {
                            double totalAmount=0.0;
                            
                            for (int l=0; l<[tmpTranscations count]; l++) {
                                Transaction *tmpT = [tmpTranscations objectAtIndex:l];
                                if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:cfStartDate]>=0&&[appDelegate.epnc dateCompare:tmpT.dateTime withDate:cfEndDate]<=0)
                                {
                                    if([tmpT.category.categoryType isEqualToString:@"EXPENSE"])
                                    {
                                        totalAmount +=[tmpT.amount doubleValue];
                                    }
                                }
                                
                            }
                            [tmpCategoryAmount addObject:[NSNumber numberWithDouble:totalAmount ]];
                            
//                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withAttributes:attrLeft];
                            
                        }
                        else {
                            if(searchTranscationIndex ==-1)
                            {
//                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:attrLeft];
                                
                                [tmpCategoryAmount addObject:[NSNumber numberWithDouble:0.0 ]];
                                
                            }
                            else {
                                NSDate *tmpDate =[appDelegate.epnc getDate:columnStartDate byCycleType:colunmString];
                                
                                NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                                
                                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                                NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
                                [dc1 setDay:-1];
                                
                                NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                                
                                
                                double totalAmount=0.0;
                                for (long l=searchTranscationIndex; l<[tmpTranscations count]; l++) {
                                    Transaction *tmpT = [tmpTranscations objectAtIndex:l];
                                    if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:columnStartDate]>=0&&[appDelegate.epnc dateCompare:tmpT.dateTime withDate:tmpEndDate]<=0)
                                    {
                                        if([tmpT.category.categoryType isEqualToString:@"EXPENSE"])
                                        {
                                            totalAmount +=[tmpT.amount doubleValue];
                                        }
                                    }
                                    else if([appDelegate.epnc dateCompare:tmpT.dateTime withDate:tmpEndDate]>0){
                                        searchTranscationIndex =l;
                                        break;
                                    }
                                }
                                columnStartDate =tmpDate ;
                                [tmpCategoryAmount addObject:[NSNumber numberWithDouble:totalAmount ]];
                                
//                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:attrLeft];
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    [tmpAmountCount addObject:tmpCategoryAmount];
                    
                    contextRecordBegin +=rectH ;
                    
                }
                
                
//                [@"Total Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                [@"Total Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    double columnAmount =0.0;
                    for (int m =0; m<[tmpAmountCount count];m++) {
                        NSMutableArray *tmpArray = [tmpAmountCount objectAtIndex:m];
                        columnAmount += [[tmpArray objectAtIndex:j] doubleValue];
                    }
                    
//                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withFont:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE] lineBreakMode:NSLineBreakByWordWrapping];
                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:attrLeft];
                    
                }
                contextRecordBegin +=40;
                
            }
        }
	}
	
	CGContextStrokePath(pdfContext);
	UIGraphicsEndPDFContext();
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	NSURL *fileURL = [NSURL fileURLWithPath:newFilePath];
    theScrollView.contentSize = CGSizeMake(pdfPageCount*320,0);
	for (UIView *_tmpview in [theScrollView subviews])
	{		[_tmpview removeFromSuperview];
	}
	
    cunrrentpdfPageIndex =0;
	for (int i=1; i<=pdfPageCount; i++) {
        
        ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(10+320*(i-1),0,300, 440) fileURL:fileURL page:i password:nil];
        //UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"report_pdf_bg.png"]];
        // bgImage.frame=CGRectMake(0, 420*(i-1),300, 420 );
        //[theScrollView addSubview: bgImage];
        
        [theScrollView addSubview:thePDFView1];
        [contentViews addObject:thePDFView1];
        
        //[bgImage release];
    }
    [self.activityIndicatorView stopAnimating];
    
}

-(void)drawBudgetPDF:(BudgetReports *)br
{
    ;
    
}

-(void)drawBillPDF:(BillReports *)brep
{
    ;
}

#pragma mark - Nav bar button action
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navBarBtnAction:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (repTranFilterVC != nil)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"19_EXPT_PDF"];
        
    }
    else
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"19_EXPT_CASH"];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Warning", nil)
                                                                message:NSLocalizedString(@"VC_Can't send email, please check the email config.", nil)
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
            alertView.tag = 0;
            [alertView show];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alertView;
            
        }
    }

	
}
#pragma mark EmailAction
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
 	
	NSString * str = @"<Html>The attachment is exported from PocketExpense for the iPad.</Html>";
 	
	[picker setMessageBody:str isHTML:YES];
	
 	
	if([pdfType isEqualToString:@"TRANALL"]||[pdfType isEqualToString:@"TRANEXPENSE"]||[pdfType isEqualToString:@"TRANINCOME"])
	{
		[picker setSubject:@"Pocket Expense Transaction Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:TRANSCATION_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName: TRANSCATION_PDF_NAME_IPHONE];
		
	}
	else if([pdfType isEqualToString:@"ALLFLOW"]||[pdfType isEqualToString:@"INFLOW"]||[pdfType isEqualToString:@"OUTFLOW"]){
		[picker setSubject:@"Pocket Expense CashFlow Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CASHFLOW_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName: CASHFLOW_PDF_NAME_IPHONE];
		
	}
	else if([pdfType isEqualToString:@"BILL"]){
		[picker setSubject:@"Pocket Expense Bill Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BILL_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName:BILL_PDF_NAME_IPHONE];
		
	}
	else if([pdfType isEqualToString:@"BUDGET"]){
		[picker setSubject:@"Pocket Expense Budget Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BUDGET_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName: BUDGET_PDF_NAME_IPHONE];
		
	}
	
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 	if(buttonIndex == 2)
		return;
	else if(buttonIndex == 0)
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *errors;
        
        if([pdfType isEqualToString:@"TRANALL"]||[pdfType isEqualToString:@"TRANEXPENSE"]||[pdfType isEqualToString:@"TRANINCOME"])
        {
            TransactionReports *tr  = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionReports" inManagedObjectContext:context];
            
            if([pdfType isEqualToString:@"TRANALL"]) tr.transactionRepType = @"All";
            else    if([pdfType isEqualToString:@"TRANEXPENSE"]) tr.transactionRepType = @"Expense";
            else    if([pdfType isEqualToString:@"TRANINCOME"]) tr.transactionRepType = @"Income";
            
            tr.reportName = @"transactionsRep";
            tr.startDate = repTranFilterVC.startDate;
            tr.endDate=repTranFilterVC.endDate;
            if(isAccount)
                tr.sortByAccOrCate =@"Account";
            else   tr.sortByAccOrCate =@"Category";
            
            tr.sortByAsc = [NSNumber numberWithBool:YES];
            tr.genDateTime = [NSDate date];
            for (int i =0 ; i<[repTranFilterVC.tranAccountSelectArray count]; i++) {
                AccountSelect *as = [repTranFilterVC.tranAccountSelectArray objectAtIndex:i];
                if(as.isSelected)
                    [tr addSelAccountsObject:as.account];
            }
            
            for (int i =0 ; i<[repTranFilterVC.tranCategorySelectArray count]; i++) {
                CategorySelect *cs = [repTranFilterVC.tranCategorySelectArray objectAtIndex:i];
                if(cs.isSelect)
                    [tr addSelCategoriesObject:cs.category];
            }
            
        }
        else if([pdfType isEqualToString:@"ALLFLOW"]||[pdfType isEqualToString:@"INFLOW"]||[pdfType isEqualToString:@"OUTFLOW"]){
            CashFlowReports *cr  = [NSEntityDescription insertNewObjectForEntityForName:@"CashFlowReports" inManagedObjectContext:context];
            
            
            cr.reportName = @"cashFlowRep";
            cr.startDate = repCashFlowFilterVC.startDate;
            cr.endDate=repCashFlowFilterVC.endDate;
            cr.columnString =repCashFlowFilterVC.cashDateTypeString;
            cr.genDateTime = [NSDate date];
        }
        else if([pdfType isEqualToString:@"BILL"]){
            
            //            BillReports *br  = [NSEntityDescription insertNewObjectForEntityForName:@"BillReports" inManagedObjectContext:context];
            //
            //            if(repBillFilterVC.segBillTypeFilter.selectedSegmentIndex ==0) br.billRepType = @"All";
            //            else    if(repBillFilterVC.segBillTypeFilter.selectedSegmentIndex ==1) br.billRepType = @"Expense";
            //            else    if(repBillFilterVC.segBillTypeFilter.selectedSegmentIndex ==2) br.billRepType = @"Income";
            //
            //            br.reportName = @"billsRep";
            //            br.startDate = repBillFilterVC.startDate;
            //            br.endDate=repBillFilterVC.endDate;
            //            br.sortByType =repBillFilterVC.lblStatus.text;
            //            br.sortByAsc = [NSNumber numberWithBool:YES];
            //            br.genDateTime = [NSDate date];
            //            for (int i =0 ; i<[repBillFilterVC.billCategorySelectArray count]; i++) {
            //                [br addSelCategoriesObject:[[repBillFilterVC.billCategorySelectArray objectAtIndex:i] category]];
            //            }
            
        }
        else if([pdfType isEqualToString:@"BUDGET"]){
            //             BudgetReports *br  = [NSEntityDescription insertNewObjectForEntityForName:@"BudgetReports" inManagedObjectContext:context];
            //
            //
            //            br.reportName = @"budgetsRep";
            //            br.budgetsIncOrExc = [NSNumber numberWithBool:YES];
            //            br.incHistory = [NSNumber numberWithBool:repBudgetFilterVC.incHistroySwitch.on];
            //            br.incTransaction = [NSNumber numberWithBool:repBudgetFilterVC.incTranSwitch.on];
            //            br.genDateTime = [NSDate date];
            //            for (int i =0 ; i<[repBudgetFilterVC.budgetSelectArray count]; i++) {
            //                [br addSelBudgetsObject:[[repBudgetFilterVC.budgetSelectArray objectAtIndex:i] budgetTemplate]];
            //            }
            
        }
        
        if (![context save:&errors])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            // abort();
        }
//        ipad_ReportViewController *repViewController = [self.navigationController.viewControllers objectAtIndex:0];
//        [repViewController showSaveRepDataView];
        [self.navigationController popToRootViewControllerAnimated:YES];
 	}
	else if(buttonIndex == 1)
	{
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
        }
        
 	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMemoryDefine];
    [self initNavBarStyle];
    [self initPDFScrollVeiw];
    [self addGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.activityIndicatorView startAnimating];
    if([pdfType isEqualToString:@"TRANALL"]||[pdfType isEqualToString:@"TRANEXPENSE"]||[pdfType isEqualToString:@"TRANINCOME"])
    {
        [self performSelector:@selector(drawTransactionPDF:) withObject:itr afterDelay:0.0];
        
    }
    else if([pdfType isEqualToString:@"ALLFLOW"]||[pdfType isEqualToString:@"INFLOW"]||[pdfType isEqualToString:@"OUTFLOW"])
    {
        [self performSelector:@selector(drawCashFlowPDF:) withObject:icr afterDelay:0.0];
        
    }
    else if([pdfType isEqualToString:@"BILL"])
    {
        [self performSelector:@selector(drawBillPDF:) withObject:ibrep afterDelay:0.0];
        
    }
    else if([pdfType isEqualToString:@"BUDGET"])
    {
        [self performSelector:@selector(drawBudgetPDF:) withObject:ibr afterDelay:0.0];
        
        
    }
    

    
}

#pragma mark - View release and dealloc

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}



@end

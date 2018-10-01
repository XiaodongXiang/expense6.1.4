//
//  PDFPreviewController.m
//  PocketExpense
//
//  Created by MV on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PDFPreviewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ReportViewController.h"
#import "RepTransactionFilterViewController.h"
#import "RepCashflowFilterViewController.h"
#import "BudgetDetailClassType.h"
#import "ReaderContentView.h"
#import "ReaderScrollView.h"
#import "AppDelegate_iPhone.h"
#import "AccountSelect.h"
#import "CategorySelect.h"
#import "Payee.h"


#define NAV_AREA_SIZE_IPHONE 48.0f

#define CURRENT_PAGE_KEY_IPHONE @"CurrentPage"
#define TRANSCATION_PDF_NAME_IPHONE @"PocketExpenseReport_Transaction.pdf"
#define CASHFLOW_PDF_NAME_IPHONE @"PocketExpenseReport_CashFlow.pdf"
#define BILL_PDF_NAME_IPHONE @"PocketExpenseReport_Bill.pdf"
#define BUDGET_PDF_NAME_IPHONE @"PocketExpenseReport_Budget.pdf"

#define CONTENT_BEGIN_Y_IPHONE 28.0
#define CONTENT_BEGIN_X_IPHONE 40.0
#define CONTENT_END_X_IPHONE 590.0
#define CONTENT_END_Y_IPHONE 800.0
#define CONTENT_SECTION_HEIGH_IPHONE 20.0

#define CONTENT_HEADTITLE_SIZE_IPHONE 34.0
#define CONTENT_TITLE_SIZE_IPHONE 12.0
#define CONTENT_TEXT_SIZE_IPHONE 10.0
#define CONTENT_LINE_OFFSET 5.0

#define CONTENT_DATE_COLUMN_IPHONE 5
#define TAP_AREA_SIZE 48.0f

//NSString的类别
@interface NSString (Support)
- (NSComparisonResult) psuedoNumericCompareByAsc:(NSString *)otherString;
- (NSComparisonResult) psuedoNumericCompareByDesc:(NSString *)otherString;
@end

@implementation NSString (Support)
- (NSComparisonResult) psuedoNumericCompareByAsc:(NSString *)otherString
{
    NSString *left  = self;
    NSString *right = otherString;
    NSInteger leftNumber, rightNumber;
	
	
    NSScanner *leftScanner = [NSScanner scannerWithString:left];
    NSScanner *rightScanner = [NSScanner scannerWithString:right];
	
    // if both begin with numbers, numeric comparison takes precedence
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber])
	{
        if (leftNumber < rightNumber)
            return NSOrderedDescending;
        if (leftNumber > rightNumber)
            return NSOrderedAscending;
		
        // if numeric values tied, compare the rest
        left = [left substringFromIndex:[leftScanner scanLocation]];
        right = [right substringFromIndex:[rightScanner scanLocation]];
    }
	
    return [left caseInsensitiveCompare:right];
}

- (NSComparisonResult) psuedoNumericCompareByDesc:(NSString *)otherString
{
    NSString *left  = otherString;
    NSString *right = self;
    NSInteger leftNumber, rightNumber;
	
	
    NSScanner *rightScanner = [NSScanner scannerWithString:left];
    NSScanner *leftScanner = [NSScanner scannerWithString:right];
	
    // if both begin with numbers, numeric comparison takes precedence
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber])
	{
        if (leftNumber < rightNumber)
            return NSOrderedDescending;
        if (leftNumber > rightNumber)
            return NSOrderedAscending;
		
        // if numeric values tied, compare the rest
        left = [left substringFromIndex:[leftScanner scanLocation]];
        right = [right substringFromIndex:[rightScanner scanLocation]];
    }
	
    return [left caseInsensitiveCompare:right];
}
@end



@implementation PDFPreviewController
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
    
    //transaction pdf
    if([_pdfType isEqualToString:@"TRANALL"]||[_pdfType isEqualToString:@"TRANEXPENSE"]||[_pdfType isEqualToString:@"TRANINCOME"])
        [self performSelector:@selector(drawTransactionPDF:) withObject:nil afterDelay:0.0];
    
    //flow pdf
    else if([_pdfType isEqualToString:@"ALLFLOW"]||[_pdfType isEqualToString:@"INFLOW"]||[_pdfType isEqualToString:@"OUTFLOW"])
        [self performSelector:@selector(drawCashFlowPDF:) withObject:nil afterDelay:0.0];
}


#pragma mark init
-(void)initMemoryDefine
{
    _pdfPageCount =0;
    _cunrrentpdfPageIndex =-1;
//    _contentViews = [[NSMutableArray alloc] init] ;

    _psCenter = [[NSMutableParagraphStyle alloc] init];
    [_psCenter setAlignment:NSTextAlignmentCenter];
    [_psCenter setLineBreakMode:NSLineBreakByTruncatingTail];
    
    _psLeft = [[NSMutableParagraphStyle alloc] init];
    [_psLeft setAlignment:NSTextAlignmentLeft];
    [_psLeft setLineBreakMode:NSLineBreakByTruncatingTail];
    
    _psRight = [[NSMutableParagraphStyle alloc] init];
    [_psRight setAlignment:NSTextAlignmentRight];
    [_psRight setLineBreakMode:NSLineBreakByTruncatingTail];
    
    self.attrLeft = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,_psLeft,NSParagraphStyleAttributeName, nil];
    self.attrRight = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,_psRight,NSParagraphStyleAttributeName, nil];
    self.attrCenter = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:CONTENT_TITLE_SIZE_IPHONE],NSFontAttributeName,_psCenter,NSParagraphStyleAttributeName, nil];
    self.attrBoldCenter = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:CONTENT_HEADTITLE_SIZE_IPHONE],NSFontAttributeName,_psCenter,NSParagraphStyleAttributeName, nil];
    self.attrBoldMTLeft = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:14],NSFontAttributeName,_psLeft,NSParagraphStyleAttributeName, nil];
    
    
}

-(void)initNavBarStyle
{
    //left btn
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -12.f;

    self.navigationItem.title = @"PDF";
    
    UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 60,30);
    [customerButton1 setTitle:NSLocalizedString(@"VC_Send", nil) forState:UIControlStateNormal];
    [customerButton1 setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [customerButton1 addTarget:self action:@selector(navBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
    self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    
}

//创建ReaderScrollView
-(void)initPDFScrollVeiw
{
    //*init PDF View/
    _theScrollView = [[ReaderScrollView alloc] initWithFrame:CGRectMake(0,5, 320, 460)];
    _theScrollView.userInteractionEnabled = TRUE;
    _theScrollView.pagingEnabled = TRUE;
    _theScrollView.scrollsToTop = NO;
    _theScrollView.directionalLockEnabled = YES;
    _theScrollView.showsVerticalScrollIndicator = NO;
    _theScrollView.showsHorizontalScrollIndicator = NO;
    _theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _theScrollView.delegate = self;
    [self.view addSubview:_theScrollView ];
}

-(void)addGestureRecognizer
{
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1;
    doubleTapOne.numberOfTapsRequired = 2;
    doubleTapOne.delegate = self;
    
    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapTwo.numberOfTouchesRequired = 2;
    doubleTapTwo.numberOfTapsRequired = 2;
    doubleTapTwo.delegate = self;

    [self.view addGestureRecognizer:doubleTapOne];
    [self.view addGestureRecognizer:doubleTapTwo];
}

#pragma mark Draw
-(void)drawTransactionPDF:(TransactionReports *)tr
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableDictionary *sectionArray = [[NSMutableDictionary alloc] init];
    double tmpIncome=0,tmpSpent=0;
    double tmpClear=0,tmpUnClear=0;
    
    NSError *error=nil;
    NSDictionary *subs;
    NSString *fetchName ;
    NSString *sortString =@"";
    
    //判断transaction pdf按account/category分类
    if(_repTranFilterVC.accountBtn.selected)
        sortString =@"Account";
    else
        sortString =@"Category";
    
    if([sortString isEqualToString:@"Account"])
        _isAccount = TRUE;
    else
        _isAccount = FALSE;
    
    BOOL showTransfer =_repTranFilterVC.transferSwitch.on;
    
    
    //分别存放找到的非transfer数组与transfer数据
    NSMutableArray *filterTranscation = [[NSMutableArray alloc] init];
    NSMutableArray *tmpTransfer = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[_repTranFilterVC.tranAccountSelectArray count];i++)
    {
        Accounts *as = [_repTranFilterVC.tranAccountSelectArray objectAtIndex:i];
        
        for (int j = 0; j<[_repTranFilterVC.tranCategorySelectArray count];j++)
        {
            Category *cs = [_repTranFilterVC.tranCategorySelectArray objectAtIndex:j];
            
            if([_pdfType isEqualToString:@"TRANALL"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",as,@"expenseAccount" ,_repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateAll";
            }
            else if([_pdfType isEqualToString:@"TRANEXPENSE"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"expenseAccount", _repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateExpense";
            }
            else if([_pdfType isEqualToString:@"TRANINCOME"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",_repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate",cs,@"category",[NSNull null],@"EMPTY", nil];
                fetchName =@"iPad_fetchTranscationByAccountCategoryWithDateIncome";
            }
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [filterTranscation addObjectsFromArray:objects];
        }
        
        //如果显示transfer就把transfer数据筛选出来
        if(showTransfer)
        {
            if([_pdfType isEqualToString:@"TRANALL"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",as,@"expenseAccount" ,_repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate", nil];
                fetchName =@"iPad_fetchTransferByAccountWithDateAll";
                
            }
            else if([_pdfType isEqualToString:@"TRANEXPENSE"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"expenseAccount", _repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate", nil];
                fetchName =@"iPad_fetchTransferByAccountWithDateExpense";
                
            }
            else if([_pdfType isEqualToString:@"TRANINCOME"])
            {
                subs = [NSDictionary dictionaryWithObjectsAndKeys:as,@"incomeAccount",_repTranFilterVC.startDate,@"startDate",_repTranFilterVC.endDate,@"endDate", nil];
                fetchName =@"iPad_fetchTransferByAccountWithDateIncome";
                
            }
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if(_isAccount)
            {
                [filterTranscation addObjectsFromArray:objects];
                
            }
            else
            {
                for (int k =0; k<[objects count]; k++)
                {
                    BOOL isFound = FALSE;
                    Transaction *t1 = [objects objectAtIndex:k];
                    
                    for (int l=0; l<[tmpTransfer count]; l++)
                    {
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
    
    if(!_isAccount)
    {
        [filterTranscation addObjectsFromArray:tmpTransfer];
        
    }
    NSInteger tCount =[filterTranscation count];
    
    //筛选出来的transaction,计算totalExpense,totalIncome，将trans放到不同account字典所对应的数组中
    for (int i=0; i<[filterTranscation count];i++)
    {
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
        else
        {
            for (int j = 0; j<[_repTranFilterVC.tranAccountSelectArray count];j++)
            {
                Accounts *as = [_repTranFilterVC.tranAccountSelectArray objectAtIndex:j];
                
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
        
        
        if(_isAccount&&t.incomeAccount!=nil&&t.expenseAccount!=nil)
        {
            NSString *key2,*key1;
            
            key1 =t.incomeAccount.accName;
            key2 = t.expenseAccount.accName;
            
            //获取该交易的incomeAccount名称，获取对应该名称的所有交易
            NSMutableArray *list1 = [sectionArray valueForKey:key1];
            
            //将该交易加入到这个account字典所对应的数组中
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
        else
        {
            NSString *key;
            if(_isAccount)
            {
                if(t.incomeAccount!=nil)
                {
                    key =t.incomeAccount.accName;
                }
                else {
                    key = t.expenseAccount.accName;
                }
                
            }
            else
            {
                
                if(t.category == nil)
                {
                    key =[NSString stringWithFormat:@"To %@",t.incomeAccount.accName];
                }
                else
                    key =t.category.categoryName;
                
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
    
    
   
    //*******Gen Report PDF*********//
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
    //这是一个比例么
    CGRect pageRect = CGRectMake(0, 0, 620, 877);

    //开始画PDF，保存在newFilePath文件里
    UIGraphicsBeginPDFContextToFile(newFilePath, pageRect, [NSDictionary dictionary]);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    _pdfPageCount =1;
    CGContextSetAllowsAntialiasing(pdfContext, FALSE);
    
    UIGraphicsBeginPDFPage();
    {
        //-----------------------------头部----------------------------------------
        //Draw Title
        CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
        [@"Transactions Report" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, CONTENT_BEGIN_Y_IPHONE, 620-80, 40) withAttributes:self.attrBoldCenter];
        
        //date
        CGContextSetRGBFillColor (pdfContext, 128.f/255.f, 128.f/255.f,128.f/255.f, 1);
        [@"Report Date:" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 90, 300, 40) withAttributes:self.attrLeft];
        [dateString drawInRect:CGRectMake(125, 90, 300, 40) withAttributes:self.attrLeft];

        [@"Generated by Expense 5" drawInRect:CGRectMake(315, 90,315-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrRight];
        
        //date底下的粗线
        CGContextSetLineWidth(pdfContext, 4.0);
        CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
        
        CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 110);
        CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE,110);
        CGContextStrokePath(pdfContext);
        
        //时间区域
        [_repTranFilterVC.lblDateRange.text drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 120, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrCenter];
        
        
        //Draw Line
        CGContextSetLineWidth(pdfContext, 1.0);
        CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 145);
        CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, 145);
        CGContextStrokePath(pdfContext);
        CGContextSetRGBFillColor (pdfContext, 88.f/255.f, 88.f/255.f,88.f/255.f, 1);
        
        
        [@"Total Expense:" drawInRect:CGRectMake(40, 155, 300, 40) withAttributes:self.attrLeft];
        [@"Total Cleared:" drawInRect:CGRectMake(260, 155, 300, 40) withAttributes:self.attrLeft];
        [@"Total Income:" drawInRect:CGRectMake(40, 175, 300, 40) withAttributes:self.attrLeft];
        [@"Total Uncleared:" drawInRect:CGRectMake(260, 175, 300, 40) withAttributes:self.attrLeft];
        [[appDelegate.epnc formatterString:tmpSpent] drawInRect:CGRectMake(140, 155, 300, 40) withAttributes:self.attrLeft];
        [[appDelegate.epnc formatterString:tmpClear] drawInRect:CGRectMake(370, 155, 300, 40) withAttributes:self.attrLeft];
        [[NSString stringWithFormat:@"%ld Transactions",(long)tCount] drawInRect:CGRectMake(390, 155, 200, 40) withAttributes:self.attrRight];
        [[appDelegate.epnc formatterString:tmpIncome] drawInRect:CGRectMake(140, 175, 300, 40) withAttributes:self.attrLeft];
        [[appDelegate.epnc formatterString:tmpUnClear] drawInRect:CGRectMake(370, 175, 300, 40) withAttributes:self.attrLeft];

        //Draw line
        CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 200);
        CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, 200);
        CGContextStrokePath(pdfContext);
        //-------------------------------------------------------------------------
        
        
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
        
        //---------------每一个category下的trans,统计---------------------------------
        for (int i = 0; i<[sectionArray count];i++) {
            double totalAmount =0.0;
            NSString *nameLabel =[[array objectAtIndex:i] copy] ;
            CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);
            
            //name
            [nameLabel drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, 300, 20) withAttributes:self.attrBoldMTLeft];
            
            contextRecordBegin+=20;
            CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
            CGContextSetLineWidth(pdfContext, 1.0);
            CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
            CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
            CGContextStrokePath(pdfContext);
            
            //date
            CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
            [@"Date" drawInRect:CGRectMake(60, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            
            //payee
            [@"Payee" drawInRect:CGRectMake(160, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            
            //category/account
            if(_isAccount)
                [@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            else
                [@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                
            //amount
            [@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft ];
            
            //memo
            [@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            
            
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
                
                if(!_isAccount)
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
                    if(_isAccount)
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

                [dateValueLabel drawInRect:CGRectMake(60, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withAttributes:self.attrLeft];
                
                CGSize size = [payeeValueLabel sizeWithAttributes:self.attrLeft];
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:8.f],NSFontAttributeName,_psLeft,NSParagraphStyleAttributeName,@(-0.3f),NSKernAttributeName,nil];

                if (size.width >= 80) {
                [payeeValueLabel drawInRect:CGRectMake(160, contextRecordBegin+(rectH-rectH3)/2+CONTENT_LINE_OFFSET, 95.0, rectH) withAttributes:dic];
                }else{
                    [payeeValueLabel drawInRect:CGRectMake(160, contextRecordBegin+(rectH-rectH3)/2+CONTENT_LINE_OFFSET, 95.0, rectH) withAttributes:self.attrLeft];
                }
                
                CGSize accountSize = [accountValueLabel sizeWithAttributes:self.attrLeft];
                if (accountSize.width >= 115) {
                    [accountValueLabel drawInRect:CGRectMake(260, contextRecordBegin+(rectH-rectH2)/2+CONTENT_LINE_OFFSET, 120.0, rectH) withAttributes:dic];

                }else{
                    [accountValueLabel drawInRect:CGRectMake(260, contextRecordBegin+(rectH-rectH2)/2+CONTENT_LINE_OFFSET, 120.0, rectH) withAttributes:self.attrLeft];

                }

                
                [amountValueLabel drawInRect:CGRectMake(385, contextRecordBegin+(rectH-CONTENT_TEXT_SIZE_IPHONE)/2, 200, rectH) withAttributes:self.attrLeft];
                
                CGSize amountSize = [memoValueLabel sizeWithAttributes:self.attrLeft];
                if (amountSize.width >= 100) {
                    [memoValueLabel drawInRect:CGRectMake(480, contextRecordBegin+(rectH-rectH1)/2+CONTENT_LINE_OFFSET , 110, rectH) withAttributes:dic];
                }else{
                    [memoValueLabel drawInRect:CGRectMake(480, contextRecordBegin+(rectH-rectH1)/2+CONTENT_LINE_OFFSET , 110, rectH) withAttributes:self.attrLeft];

                }
                
                contextRecordBegin +=rectH;
                
                CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
                CGContextSetLineWidth(pdfContext, 1.0);
                CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
                CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
                CGContextStrokePath(pdfContext);
                
                //重开一页,不是最后一页
                if(contextRecordBegin>=CONTENT_END_Y_IPHONE&& j!=[list count]-1)
                {
                    UIGraphicsBeginPDFPage();
                    
                    _pdfPageCount++;
                    contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                    CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);

                    [nameLabel drawInRect:CGRectMake(40, contextRecordBegin, 300, 20) withAttributes:self.attrBoldMTLeft];
                    
                    contextRecordBegin+=20;
                    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
                    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                    
                    CGContextSetLineWidth(pdfContext, 1.0);
                    CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
                    CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE, contextRecordBegin);
                    CGContextStrokePath(pdfContext);
                    CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
                    
                    [@"Date" drawInRect:CGRectMake(60, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                    
                    [@"Payee" drawInRect:CGRectMake(160, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                    
                    if(_isAccount)
                    {
                        [@"Category" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
                    }
                    else {
                        [@"Account" drawInRect:CGRectMake(260, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                    }
                    
                    [@"Amount" drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                    
                    [@"Memo" drawInRect:CGRectMake(480, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                    
                    
                    contextRecordBegin +=20;
                    
                    CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, contextRecordBegin);
                    CGContextAddLineToPoint(pdfContext,  CONTENT_END_X_IPHONE, contextRecordBegin);
                    CGContextStrokePath(pdfContext);
                    
                    
                }
            }

            [@"Total:" drawInRect:CGRectMake(60, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(385, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
            
            contextRecordBegin +=20;
            
            //判断每个section是不是要重开一页
            if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
            {
                UIGraphicsBeginPDFPage();
                _pdfPageCount++;
                CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                
                contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                
            }
            
        }
        //-------------------------------------------------------------------------
        CGContextStrokePath(pdfContext);
    }
    
    UIGraphicsEndPDFContext();
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSURL *fileURL = [NSURL fileURLWithPath:newFilePath];
    _theScrollView.contentSize = CGSizeMake(_pdfPageCount*SCREEN_WIDTH,0);
    for (UIView *_tmpview in [_theScrollView subviews])
    {
        [_tmpview removeFromSuperview];
    }
    
    
    _cunrrentpdfPageIndex =0;
    
    for (int i=1; i<=_pdfPageCount; i++) {
        
        ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i-1),0,SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height-64) fileURL:fileURL page:i password:nil];
//        ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(10+320*(i-1),0,300, 440) fileURL:fileURL page:i password:nil];


//        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"report_pdf_bg.png"]];
//         bgImage.frame=CGRectMake(0, 420*(i-1),300, 420 );
//        [theScrollView addSubview: bgImage];
        
        [_theScrollView addSubview:thePDFView1];
//        [_contentViews addObject:thePDFView1];
        
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
    _pdfPageCount =1;
    CGContextSetAllowsAntialiasing(pdfContext, FALSE);
    
    UIGraphicsBeginPDFPage();
    
    //Draw Title
    CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
    
    [@"Cash Flow Report" drawInRect:CGRectMake(0, CONTENT_BEGIN_Y_IPHONE, 620, 40) withAttributes:self.attrBoldCenter];
    
    CGContextSetRGBFillColor (pdfContext, 128.f/255.f, 128.f/255.f,128.f/255.f, 1);
    
    [@"Report Date:" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 90, 300, 40) withAttributes:self.attrLeft];
    
    [dateString drawInRect:CGRectMake(125, 90, 300, 40) withAttributes:self.attrLeft];
    
    [@"Generated by Expense 5" drawInRect:CGRectMake(315, 90,315-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrRight];

    
    
    
    //Draw Line
    CGContextSetLineWidth(pdfContext, 4.0);
    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
    
    CGContextMoveToPoint(pdfContext, CONTENT_BEGIN_X_IPHONE, 110);
    CGContextAddLineToPoint(pdfContext, CONTENT_END_X_IPHONE,110);
    CGContextStrokePath(pdfContext);
    [_repCashFlowFilterVC.lblDateRange.text drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, 120, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrCenter];
    
    
    NSInteger contextRecordBegin =145;
    CGContextSetRGBFillColor (pdfContext,128.f/255.f, 128.f/255.f,128.f/255.f, 1);
    
    NSString *colunmString;
    NSDate   *cfStartDate;
    NSDate   *cfEndDate;
    
    if(cr == nil)
    {
        if ([_repCashFlowFilterVC.lblDateColumn.text isEqualToString:NSLocalizedString(@"VC_Week", nil)])
        {
            colunmString = @"Week";
        }
        else
        {
            colunmString = @"Month";
        }
        cfStartDate =_repCashFlowFilterVC.startDate;
        cfEndDate = _repCashFlowFilterVC.endDate;
    }
    else
    {
        if ([cr.columnString isEqualToString:@"VC_Week"])
        {
            colunmString = @"Week";
        }
        else
        {
            colunmString = @"Month";
        }
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
        //获取这段时间内的category的交易
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
        NSDate *lastStartDate = cfStartDate;
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
        
        if([_pdfType isEqualToString:@"ALLFLOW"]||[_pdfType isEqualToString:@"INFLOW"] )
        {
            [@"Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrBoldMTLeft];
            
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
                    _pdfPageCount++;
                    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                    
                    contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                    
                }
                NSInteger columnCountForRows = (i!= dateRows -1)? CONTENT_DATE_COLUMN_IPHONE:lastRowCount;
                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                
                
                NSDate *rowStartDate;
                CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    if(j==0) rowStartDate = lastStartDate ;
                    if(i==dateRows-1&&j==columnCountForRows-1)
                    {
                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
                    }
                    else {
                        
                        NSDate *tmpDate =[appDelegate.epnc getDate:lastStartDate byCycleType:colunmString];
                        
                        NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                        
                        NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                        NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
                        [dc1 setDay:-1];
                        
                        NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                        
                        
                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
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
                        _pdfPageCount++;
                        CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                        
                        contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                        
                    }
                    CGContextSetRGBFillColor (pdfContext,100.f/255.f, 100.f/255.f,100.f/255.f, 1);
                    
                    Category *c = [categoryArray objectAtIndex:k];
                    float rectH = [self calculateHeightOfTextFromWidth:c.categoryName  withFontSize:CONTENT_TITLE_SIZE_IPHONE andWedith:150]+20.f;
                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withAttributes:self.attrLeft];
                    
                    
                    
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
                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withAttributes:self.attrLeft];
                            
                            
                        }
                        else {
                            if(searchTranscationIndex ==-1)
                            {
                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:self.attrLeft];
                                
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
                                
                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:self.attrLeft];
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    [tmpAmountCount addObject:tmpCategoryAmount];
                    
                    contextRecordBegin +=rectH;
                    
                }
                
                [@"Total Inflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:_attrLeft];
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    double columnAmount =0.0;
                    for (int m =0; m<[tmpAmountCount count];m++) {
                        NSMutableArray *tmpArray = [tmpAmountCount objectAtIndex:m];
                        columnAmount += [[tmpArray objectAtIndex:j] doubleValue];
                    }
                    
                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:_attrLeft];
                }
                contextRecordBegin +=40;
                
                
                
            }
            
            lastStartDate = cfStartDate ;
            contextRecordBegin +=2*CONTENT_SECTION_HEIGH_IPHONE;
            
            if(contextRecordBegin>=CONTENT_END_Y_IPHONE)
            {
                UIGraphicsBeginPDFPage();
                _pdfPageCount++;
                CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                
                contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                
            }
        }
        if([_pdfType isEqualToString:@"ALLFLOW"] ||[_pdfType isEqualToString:@"OUTFLOW"])
        {
            [@"Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin, CONTENT_END_X_IPHONE-CONTENT_BEGIN_X_IPHONE, 40) withAttributes:self.attrBoldMTLeft];
            
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
                    _pdfPageCount++;
                    CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                    
                    contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                    
                }
                NSInteger columnCountForRows = (i!= dateRows -1)? CONTENT_DATE_COLUMN_IPHONE:lastRowCount;
                [@"Category" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrBoldMTLeft];
                
                
                NSDate *rowStartDate;
                CGContextSetRGBFillColor (pdfContext, 60.f/255.f, 60.f/255.f,60.f/255.f, 1);
                
                for (int j=0; j<columnCountForRows; j++)
                {
                    if(j==0) rowStartDate = lastStartDate ;
                    
                    if(i==dateRows-1&&j==columnCountForRows-1)
                    {
                        [@"Total" drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
                    }
                    else {
                        NSDate *tmpDate =[appDelegate.epnc getDate:lastStartDate byCycleType:colunmString];
                        
                        NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:tmpDate];
                        
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                        NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
                        [dc1 setDay:-1];
                        
                        NSDate *tmpEndDate =[gregorian dateByAddingComponents:dc1 toDate:[[NSCalendar currentCalendar] dateFromComponents:parts2] options:0];
                        
                        
                        
                        [[NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:lastStartDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
                        [[NSString stringWithFormat:@"~ %@",[outputFormatter stringFromDate:tmpEndDate]] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2+CONTENT_SECTION_HEIGH_IPHONE, 80, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                        
                        
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
                        _pdfPageCount++;
                        CGContextSetRGBStrokeColor(pdfContext, 144.f/ 255.f, 144.f/ 255.f, 144.f/ 255.f, 1.0);
                        
                        contextRecordBegin = CONTENT_BEGIN_Y_IPHONE;
                        
                    }
                    CGContextSetRGBFillColor (pdfContext,100.f/255.f, 100.f/255.f,100.f/255.f, 1);
                    
                    Category *c = [categoryArray objectAtIndex:k];
                    float rectH = [self calculateHeightOfTextFromWidth:c.categoryName  withFontSize:CONTENT_TITLE_SIZE_IPHONE andWedith:150]+20.f;
                    [c.categoryName drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 150, rectH) withAttributes:self.attrLeft];
                    
                    
                    
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
                            
                            [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 300, rectH) withAttributes:self.attrLeft];
                            
                            
                        }
                        else {
                            if(searchTranscationIndex ==-1)
                            {
                                [[appDelegate.epnc formatterString:0.0] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:self.attrLeft];
                                
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
                                
                                
                                [[appDelegate.epnc formatterString:totalAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(rectH-CONTENT_TITLE_SIZE_IPHONE)/2, 80, rectH) withAttributes:self.attrLeft];
                                
                            }
                            
                        }
                        
                    }
                    
                    [tmpAmountCount addObject:tmpCategoryAmount];
                    
                    
                    
                    contextRecordBegin +=rectH ;
                    
                }
                
                
                [@"Total Outflow" drawInRect:CGRectMake(CONTENT_BEGIN_X_IPHONE, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                
                for (int j=0; j<columnCountForRows; j++) 
                {
                    double columnAmount =0.0;
                    for (int m =0; m<[tmpAmountCount count];m++) {
                        NSMutableArray *tmpArray = [tmpAmountCount objectAtIndex:m];
                        columnAmount += [[tmpArray objectAtIndex:j] doubleValue];
                    }
                    
                    [[appDelegate.epnc formatterString:columnAmount] drawInRect:CGRectMake(190+80*j, contextRecordBegin+(CONTENT_SECTION_HEIGH_IPHONE-CONTENT_TITLE_SIZE_IPHONE)/2, 300, CONTENT_SECTION_HEIGH_IPHONE) withAttributes:self.attrLeft];
                    
                    
                }
                
                contextRecordBegin +=40;
                
            }
        }
    }
    
    CGContextStrokePath(pdfContext);
    UIGraphicsEndPDFContext();
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSURL *fileURL = [NSURL fileURLWithPath:newFilePath];
    _theScrollView.contentSize = CGSizeMake(_pdfPageCount*SCREEN_WIDTH,0);
    for (UIView *_tmpview in [_theScrollView subviews])
    {		[_tmpview removeFromSuperview];
    }
    
    _cunrrentpdfPageIndex =0;
    for (int i=1; i<=_pdfPageCount; i++) {
        
        ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i-1),0,SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height-64) fileURL:fileURL page:i password:nil];
        //UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"report_pdf_bg.png"]];
        // bgImage.frame=CGRectMake(0, 420*(i-1),300, 420 );
        //[theScrollView addSubview: bgImage];
        
        [_theScrollView addSubview:thePDFView1];
//        [_contentViews addObject:thePDFView1];
        
        
        //[bgImage release];
    }
    [self.activityIndicatorView stopAnimating];
    
    
}



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
    /*
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view];
        
		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = _cunrrentpdfPageIndex; // Current page #
            
             
			ReaderContentView *targetView = [_contentViews objectAtIndex:page];
            
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
     */
}


 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;          // any offset changes
{
//    CGFloat pageWidth = scrollView.frame.size.width;
//      _cunrrentpdfPageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _cunrrentpdfPageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;

//    NSLog(@"滑动到了第几页：%ld",(long)_cunrrentpdfPageIndex);
}

#pragma mark DataSource
-(void)setAccountSelectDataSource
{
	[_tranAccountSelectArray  removeAllObjects];
	
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
		[_tranAccountSelectArray addObject:as];
	}
	
}


#pragma mark - Custom API





-(float) calculateHeightOfTextFromWidth:(NSString*) text withFontSize:(float)fontSize andWedith:(float)w
{
//	CGSize suggestedSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(w, FLT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *tmpAttr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:fontSize],NSFontAttributeName, nil];
    CGRect suggestedSize = [text boundingRectWithSize:CGSizeMake(w, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:tmpAttr context:nil];

	return suggestedSize.size.height==0? fontSize:suggestedSize.size.height;
}




#pragma mark - Nav bar button action
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navBarBtnAction:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (_repTranFilterVC != nil)
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
	
 	
	if([_pdfType isEqualToString:@"TRANALL"]||[_pdfType isEqualToString:@"TRANEXPENSE"]||[_pdfType isEqualToString:@"TRANINCOME"])
	{
		[picker setSubject:@"Expense 5 Transaction Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:TRANSCATION_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName: TRANSCATION_PDF_NAME_IPHONE];
		
	}
	else if([_pdfType isEqualToString:@"ALLFLOW"]||[_pdfType isEqualToString:@"INFLOW"]||[_pdfType isEqualToString:@"OUTFLOW"]){
		[picker setSubject:@"Expense 5 CashFlow Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:CASHFLOW_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName: CASHFLOW_PDF_NAME_IPHONE];
		
	}
	else if([_pdfType isEqualToString:@"BILL"]){
		[picker setSubject:@"Expense 5 Bill Report"];
		NSString *newFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BILL_PDF_NAME_IPHONE];
		
		[picker addAttachmentData:[NSData dataWithContentsOfFile:newFilePath] mimeType:@"pdf" fileName:BILL_PDF_NAME_IPHONE];
		
	}
	else if([_pdfType isEqualToString:@"BUDGET"]){
		[picker setSubject:@"Expense 5 Budget Report"];
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
        
        if([_pdfType isEqualToString:@"TRANALL"]||[_pdfType isEqualToString:@"TRANEXPENSE"]||[_pdfType isEqualToString:@"TRANINCOME"])
        {
             TransactionReports *tr  = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionReports" inManagedObjectContext:context];
            
            if([_pdfType isEqualToString:@"TRANALL"]) tr.transactionRepType = @"All";
            else    if([_pdfType isEqualToString:@"TRANEXPENSE"]) tr.transactionRepType = @"Expense";
            else    if([_pdfType isEqualToString:@"TRANINCOME"]) tr.transactionRepType = @"Income";
            
            tr.reportName = @"transactionsRep";
            tr.startDate = _repTranFilterVC.startDate;
            tr.endDate=_repTranFilterVC.endDate;
            if(_isAccount)
            tr.sortByAccOrCate =@"Account";
            else   tr.sortByAccOrCate =@"Category";

            tr.sortByAsc = [NSNumber numberWithBool:YES];
            tr.genDateTime = [NSDate date];
            for (int i =0 ; i<[_repTranFilterVC.tranAccountSelectArray count]; i++) {
                AccountSelect *as = [_repTranFilterVC.tranAccountSelectArray objectAtIndex:i];
                if(as.isSelected)
                    [tr addSelAccountsObject:as.account];
            }
            
            for (int i =0 ; i<[_repTranFilterVC.tranCategorySelectArray count]; i++) {
                CategorySelect *cs = [_repTranFilterVC.tranCategorySelectArray objectAtIndex:i];
                if(cs.isSelect)
                    [tr addSelCategoriesObject:cs.category];
            }
 
        }
        else if([_pdfType isEqualToString:@"ALLFLOW"]||[_pdfType isEqualToString:@"INFLOW"]||[_pdfType isEqualToString:@"OUTFLOW"]){
             CashFlowReports *cr  = [NSEntityDescription insertNewObjectForEntityForName:@"CashFlowReports" inManagedObjectContext:context];
            
            
            cr.reportName = @"cashFlowRep";
            cr.startDate = _repCashFlowFilterVC.startDate;
            cr.endDate=_repCashFlowFilterVC.endDate;
            cr.columnString =_repCashFlowFilterVC.cashDateTypeString;
            cr.genDateTime = [NSDate date];
        }
        else if([_pdfType isEqualToString:@"BILL"]){
            
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
        else if([_pdfType isEqualToString:@"BUDGET"]){
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
//        ReportViewController *repViewController = [self.navigationController.viewControllers objectAtIndex:0];
        //这里写错
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

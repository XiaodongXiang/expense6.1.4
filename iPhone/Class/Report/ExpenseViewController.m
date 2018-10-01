                                                //
//  ExpenseViewController.m
//  PokcetExpense
//
//  Created by Tommy on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "ExpenseViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "Category.h"
#import <QuartzCore/QuartzCore.h>
#import "TransactionRule.h"
#import "BudgetTransfer.h"
#import "AppDelegate_iPhone.h"
#import "EPNormalClass.h"
#import "DateRangeViewController.h"

#import "BrokenLineObject.h"
#import "ADSDeatailViewController.h"

#import "CustomDateViewController.h"
#import "TrackerCell.h"
#import "CashFlowCell.h"
#import "TranDataRect.h"
#import "TranscationCategoryCount.h"
#import "ExpenseSecondCategoryViewController.h"
#import "CashDetailTransactionViewController.h"
#import "UIViewAdditions.h"
#import "UIViewController+MMDrawerController.h"
//#import "UINavigationBar+CustomImage.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define DATERANGEVIEW_WITH 225
#define DATERANGEVIEW_HIGH 44*7
#define RIGHT_BTN_HIGH  44

@implementation ExpenseViewController
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark View Life Cycle
- (void)viewDidLoad{
 	[super viewDidLoad];
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavBarStyle];
    [self initMemoryDefine];
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  doSetNavigationBar];
    self.navigationItem.title =NSLocalizedString(@"VC_Category", nil);
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible2.width = -16;
    if (IS_IPHONE_6PLUS)
    {
        flexible2.width = -20;
    }
    

    
    //right
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chart_time"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarBtnPressed:)];
    rightButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBarBtnPressed:)];
    [_shadowView addGestureRecognizer:tap];
    _shadowView.alpha=0;
}
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appdelegate.menuVC reloadView];
}
-(void)initMemoryDefine
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    totalCategoryExpenseAmount = 0;
    totalCategoryIncomeAmount = 0;
    _leftBarLabel.text = [NSLocalizedString(@"VC_Categories", nil) uppercaseString];
    _leftBarLabel.adjustsFontSizeToFitWidth = YES;
    _expenseBtn.titleLabel.font = [appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:11];
    _incomeBtn.titleLabel.font = [appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:11];
    
    _expenseBtn.width = 165;
    _incomeBtn.width = 165;
    _expenseBtn.left = SCREEN_WIDTH-180;
    _incomeBtn.left = SCREEN_WIDTH-180;
    [self setLeftBarLabelFram];
    
    _categoryBtn.selected = YES;
    _cashFlowBtn.selected = NO;
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    _dateType = 0;
    _thisYearBtn.selected = YES;
    _lastYearBtn.selected = NO;
    _LastTweleveBtn.selected = NO;
    
    [_categoryBtn setTitle:NSLocalizedString(@"VC_Categories", nil)  forState:UIControlStateNormal];
    [_cashFlowBtn setTitle:NSLocalizedString(@"VC_CashFlow", nil)  forState:UIControlStateNormal];
    [_date1Btn setTitle:NSLocalizedString(@"VC_ThisMonth", nil) forState:UIControlStateNormal];
    [_date2Btn setTitle:NSLocalizedString(@"VC_LastMonth", nil) forState:UIControlStateNormal];
    [_date3Btn setTitle:NSLocalizedString(@"VC_ThisQuarter", nil) forState:UIControlStateNormal];
    [_date4Btn setTitle:NSLocalizedString(@"VC_LastQuarter", nil) forState:UIControlStateNormal];
    [_date5Btn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    [_date6Btn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    [_date7Btn setTitle:NSLocalizedString(@"VC_CustomRange", nil) forState:UIControlStateNormal];
    [_thisYearBtn setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    [_lastYearBtn setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    [_LastTweleveBtn setTitle:NSLocalizedString(@"VC_Last12Months", nil) forState:UIControlStateNormal];
    
    
    UIImage *leftImageDefault1 = [UIImage imageNamed:@"list_report.png"];
    UIImage *leftImageDefault2 = [UIImage imageNamed:@"list_report_sel.png"];
    [_categoryBtn setBackgroundImage:leftImageDefault1 forState:UIControlStateSelected|UIControlStateHighlighted];
    [_cashFlowBtn setBackgroundImage:leftImageDefault2 forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [_categoryBtn addTarget:self action:@selector(categoryOrCashFlowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cashFlowBtn addTarget:self action:@selector(categoryOrCashFlowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarBtn addTarget:self action:@selector(navViewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarBtn addTarget:self action:@selector(rightBarBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_expenseBtn addTarget:self action:@selector(expenseOrIncomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(expenseOrIncomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_date1Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date2Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date3Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date4Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date5Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date6Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_date7Btn addTarget:self action:@selector(dateRangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_thisYearBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_LastTweleveBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_lastYearBtn addTarget:self action:@selector(cashFlowTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _date1Btn.tag = 1;
    _date2Btn.tag = 2;
    _date3Btn.tag = 3;
    _date4Btn.tag = 4;
    _date5Btn.tag = 5;
    _date6Btn.tag = 6;
    _date7Btn.tag = 7;
    _date1Btn.selected = YES;
    _date2Btn.selected = NO;
    _date3Btn.selected = NO;
    _date4Btn.selected = NO;
    _date5Btn.selected = NO;
    _date6Btn.selected = NO;
    _date7Btn.selected = NO;
    
    
    
    
    //初始化的时候，设置圆饼图的初始状态为：不可以点击，显示Expense,月类型
    [_pichartView allocArray];
    _pichartView.canBetouch = FALSE;
    _pichartView.delegate = self;
    _dateType = 0;
    
    
    
    _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
    _categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_categoryStartDate];
    _cashStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
    _cashEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_cashStartDate];
    ///////cash part
    _transactionArray = [[NSMutableArray alloc] init];
    _piViewDateArray = [[NSMutableArray alloc] init];
    _piViewDateArray_Income = [[NSMutableArray alloc]init];
    _categoryArrayList = [[NSMutableArray alloc] init];
    _detailTranArray = [[NSMutableArray alloc] init];
    _tmpTransactionByDateArray = [[NSMutableArray alloc]init];
    _transactionByDateArray = [[NSMutableArray alloc]init];
    
    _dateFormatter1 = [[NSDateFormatter alloc]init];
    [_dateFormatter1 setDateFormat:@"MMM dd"];
    _dateFormatter = [[NSDateFormatter alloc]init];
    [_dateFormatter setDateFormat:@"MMM dd, yyyy"];
    _yearFormatter =[[NSDateFormatter alloc]init];
    [_yearFormatter setDateFormat:@"yyyy"];
    _monthFormatter =[[NSDateFormatter alloc]init];
    [_monthFormatter setDateFormat:@"MMMM, yyyy"];
    
    _pichartView.expenseViewController = self;
    _pichartView.whiteCycleR = 35;
    
    _categoryLine.frame = CGRectMake(_categoryLine.frame.origin.x, _categoryLine.frame.origin.y -EXPENSE_SCALE, _categoryLine.frame.size.width, EXPENSE_SCALE);
    _cashFlowLine.frame = CGRectMake(_cashFlowLine.frame.origin.x, _cashFlowLine.frame.origin.y -EXPENSE_SCALE, _cashFlowLine.frame.size.width, EXPENSE_SCALE);
    _barChartView.contentSize = CGSizeMake(_barChartView.frame.size.width*2, _barChartView.frame.size.height);
    
    _expenseBtn.width=165;
    _incomeBtn.width=165;
    
    if(IS_IPHONE_6PLUS)
    {
        _pichartView.left = 40;
    }
    else if (IS_IPHONE_6)
    {
        _pichartView.left = 40;
    }
    else if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        _pichartView.left=15;
    }
    
    UIFont  *font = [appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    NSString *expenseText = NSLocalizedString(@"VC_Expense", nil);
    CGSize  expenseSize = [expenseText sizeWithAttributes:dic];
    
    NSString *incomeText = NSLocalizedString(@"VC_Income", nil);
    CGSize  incomeSize = [incomeText sizeWithAttributes:dic];
    
    CGSize size = expenseSize.width>incomeSize.width?expenseSize:incomeSize;
    CGRect rect = CGRectMake(12, 4, size.width, 21);
    CGRect rectBack = CGRectMake(_expenseBtn.width-12-100, 4, 100, 21);
    expenseFrontLabel = [[UILabel alloc]initWithFrame:rect];
    expenseFrontLabel.textColor = [UIColor whiteColor];
    expenseFrontLabel.font = font;
    expenseFrontLabel.text = expenseText;
    
    incomeFrontLabel = [[UILabel alloc]initWithFrame:rect];
    incomeFrontLabel.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    incomeFrontLabel.font = font;
    incomeFrontLabel.text = incomeText;
    
    expenseBackLabel = [[UILabel alloc]initWithFrame:rectBack];
    expenseBackLabel.textColor = [UIColor whiteColor];
    expenseBackLabel.font = font;
    [expenseBackLabel setTextAlignment:NSTextAlignmentRight];
    
    incomeBackLabel = [[UILabel alloc]initWithFrame:rectBack];
    incomeBackLabel.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    incomeBackLabel.font = font;
    [incomeBackLabel setTextAlignment:NSTextAlignmentRight];

    [_expenseBtn addSubview:expenseFrontLabel];
    [_incomeBtn addSubview:incomeFrontLabel];
    [_expenseBtn addSubview:expenseBackLabel];
    [_incomeBtn addSubview:incomeBackLabel];
    
}

-(void)setLeftBarLabelFram
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentLeft];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attrLeft = @{ NSFontAttributeName: _leftBarLabel.font,NSParagraphStyleAttributeName:ps};
    CGSize labelsize = [_leftBarLabel.text sizeWithAttributes:attrLeft];
    _leftBarLabel.frame = CGRectMake(0, 10, labelsize.width, labelsize.height);
    
    _leftBarArrow.frame = CGRectMake(_leftBarLabel.frame.size.width+10, _leftBarArrow.frame.origin.y, _leftBarArrow.frame.size.width, _leftBarArrow.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _dateRangeView.frame = CGRectMake(SCREEN_WIDTH-10, 5, 0, 0);
    _dateRangeView.layer.cornerRadius=6;
    _dateRangeView.layer.masksToBounds=YES;
    
    _cashTimeView.frame = CGRectMake(_cashTimeView.frame.origin.x, _cashTimeView.frame.origin.y, _cashTimeView.frame.size.width, 0);
    _typeView.frame = CGRectMake(_typeView.frame.origin.x, _typeView.frame.origin.y, _typeView.frame.size.width, 0);
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = NO;
    appDelegate.customerTabbarView.hidden = NO;
//    appDelegate.mainVC.tabBar.hidden = YES;
    
    
    //获取数据
    [self resetData];
    [self resetStyleWithAds];
    
    __weak UIViewController *slf = self;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecongize=NO;
        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            CGPoint location = [touch locationInView:slf.view];
            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 150, SCREEN_HEIGHT), location);
            [appDelegate.menuVC reloadView];
        }
        
        return shouldRecongize;
    }];}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy:MM:dd,H:mm:ss,S"];
//    NSDate *date = [NSDate date];
//    NSLog(@"页面出现的时间：%@",[dateFormatter stringFromDate:date]);
//
//}

-(void)refleshUI{
    {
        [self resetData];
    }
    
}
-(void)resetData
{
    if(_categoryBtn.selected)
        [self getCategoryData];
    else
    {
        [self getCashFlowData];
    }
}

-(void)getCategoryData
{
    [self setTimeLabelText];

    totalCategoryExpenseAmount = 0;
    totalCategoryIncomeAmount = 0;
    [self getCategoryExpenseData];
    [self getCategoryIncomeData];
    
    if (_expenseBtn.selected)
        [self.pichartView setCateData:_piViewDateArray ];
    else
        [self.pichartView setCatdataArray:_piViewDateArray_Income];
        [self.pichartView setNeedsDisplay];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *tmpExpenseAmount;
    NSString *tmpIncomeAmount;
    if (totalCategoryExpenseAmount>999999999)
    {
        tmpExpenseAmount=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:totalCategoryExpenseAmount/1000]];
    }
    else
    {
        tmpExpenseAmount = [appDelegate.epnc formatterString:totalCategoryExpenseAmount];

    }
    if (totalCategoryIncomeAmount>999999999)
    {
        tmpIncomeAmount = [NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:totalCategoryIncomeAmount/1000]];
    }
    else
    {
        tmpIncomeAmount = [appDelegate.epnc formatterString:totalCategoryIncomeAmount];
    }
    
    expenseBackLabel.text = tmpExpenseAmount;
    incomeBackLabel.text = tmpIncomeAmount;

    [_categorytableview reloadData];
}

//获取Expense类型的数据
-(void)getCategoryExpenseData
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [_piViewDateArray removeAllObjects];
    [_categoryArrayList removeAllObjects];//_categoryArrayList存放的是每个父category的交易信息
    int colorName=0;
    PiChartViewItem *tmpPiChartViewItem;
    NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc] init];
    
    
    //获取选中时间段Expense交易
    if (![self fetchedResultsControllerExpenseCategory:YES])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    for (int i=0;i<[[_fetchedResultsController sections] count];i++)
    {
        TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:i];
        cc.categoryName = [sectionInfo name];
        
        NSString *searchForMe = @":";
        NSRange range = [cc.categoryName rangeOfString : searchForMe];
        //1.如果这是一个二级category底下的transaction,那么就需要查找到父层的category,以及父层category下的所有交易
        if (range.location != NSNotFound)
        {
            NSArray * seprateSrray = [cc.categoryName componentsSeparatedByString:@":"];
            NSString *parName = [seprateSrray objectAtIndex:0];
            NSString *childName = [seprateSrray objectAtIndex:1];
            
            //获取父类的category
            NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
            NSFetchRequest *fetchRequest=	[appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //获取父类category的数组
            NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            
            if([tmpParCategoryArray count]>0)
            {
                //获取到父层的category
                Category *pc =  [tmpParCategoryArray lastObject];
                BOOL isFound = FALSE;
                
                //判断找到的这个category是不是在已经保存的有category数组中，如果没有的话，就需要网category数组中添加这个父category的相关信息
                
                for (int j=0; j<[_categoryArrayList count]; j++)
                {
                    TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:j];
                    
                    
                    if([pc.categoryName isEqualToString:cc.categoryName])
                    {
                        [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                        if(cc.c == nil){
                            cc.c = pc;
                        }
                        
                        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                        [cc.transcationArray sortUsingDescriptors:sorts];
                        
                        
                        //计算这个sction底下的金额(一个section代表一个category)
                        isFound = TRUE;
                        double amount =0.0;
                        for (int j=0; j<[[sectionInfo objects]  count];j++)
                        {
                            Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                            amount += [entry.amount doubleValue];

                        }
                        if(amount >0)
                        {
                            ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                            ccc.fullName = [sectionInfo name] ;
                            ccc.categoryName = childName;
                            ccc.amount = amount;
                            [cc.childCateArray addObject:ccc];
                        }
                        break;
                    }
                }
                
                //1.1如果没发现父层category的话,由于这是一个子类，需要创建一个父类
                if(!isFound)
                {
                    TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
                    cc.categoryName = pc.categoryName ;
                    [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                    [_categoryArrayList addObject:cc];
                    if(cc.c == nil)
                    {
                        cc.c = pc;
                    }
                    
                    double amount =0.0;
                    
                    for (int j=0; j<[[sectionInfo objects]  count];j++)
                    {
                        Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                        amount += [entry.amount doubleValue];

                    }
                    if(amount >0)
                    {
                        ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                        ccc.fullName = [sectionInfo name] ;
                        ccc.categoryName = childName;
                        ccc.amount = amount;
                        [cc.childCateArray addObject:ccc];
                    }
                }
            }
        }
        
        //2.这是一个父category
        else
        {
            
            [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
            if(cc.c == nil&&[cc.transcationArray count]>0)
            {
                Transaction *transaction = [cc.transcationArray objectAtIndex:0];
                cc.c = transaction.category;
            }
            [_categoryArrayList addObject:cc];
        }
    }
    
    
    //计算总的金额 以及 创建piViewDateArray
    double categoryTotalAmount = 0;
    for (int i=0;i<[_categoryArrayList count];i++)
    {
        //每一个父category
        TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:i];
        categoryTotalAmount =0;
        if([cc.transcationArray count] > 0)
        {
            for (int j=0; j<[cc.transcationArray  count];j++)
            {
                Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:j];
                categoryTotalAmount +=[entry.amount doubleValue];
                totalCategoryExpenseAmount += [entry.amount doubleValue];
            }
            
            //这里才是建立需要显示的数组
            if(categoryTotalAmount>0)
            {
                //创建圆环需要的数据
                tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:cc.categoryName==nil? @"Not Sure":cc.categoryName color:[UIColor clearColor] data:categoryTotalAmount];
                tmpPiChartViewItem.category = cc.c;
                tmpPiChartViewItem.indexOfMemArr =i;
                [tmpPiViewDateArray addObject:tmpPiChartViewItem];
                
            }
        }
    }
    
    //将获取到的圆环数据按照percent排序
    NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    [tmpPiViewDateArray sortUsingDescriptors:sorts];
    
    
    PiChartViewItem *tmpPiItem;
    [_piViewDateArray removeAllObjects];
    for (int i = 0; i<[tmpPiViewDateArray count];i++)
    {
        tmpPiItem =[tmpPiViewDateArray objectAtIndex:i];
        [_piViewDateArray addObject:tmpPiItem];
    }
    
    

    
    if(totalCategoryExpenseAmount == 0)
    {
        for (int i = 0; i<[_piViewDateArray count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = 1.0/[_piViewDateArray count];
            tmpPiItem.cColor = [appDelegete.epnc getExpColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getExpImage:colorName];
            colorName ++;
            
        }
    }
    else
    {
        for (int i = 0; i<[_piViewDateArray count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray objectAtIndex:i];
            tmpPiItem.cPercent = tmpPiItem.cData/totalCategoryExpenseAmount;
            tmpPiItem.cColor =[appDelegete.epnc getExpColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getExpImage:colorName];
            
            colorName ++;
            
        }
    }
}

-(void)getCategoryIncomeData
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [_piViewDateArray_Income removeAllObjects];
    [_categoryArrayList removeAllObjects];//_categoryArrayList存放的是每个父category的交易信息
    int colorName=0;
    PiChartViewItem *tmpPiChartViewItem;
    NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc] init];
    
    
    //获取选中时间段Expense交易
    if (![self fetchedResultsControllerExpenseCategory:NO])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    for (int i=0;i<[[_fetchedResultsController sections] count];i++)
    {
        TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:i];
        cc.categoryName = [sectionInfo name];
        
        
        NSString *searchForMe = @":";
        NSRange range = [cc.categoryName rangeOfString : searchForMe];
        //1.如果这是一个二级category底下的transaction,那么就需要查找到父层的category,以及父层category下的所有交易
        if (range.location != NSNotFound)
        {
            NSArray * seprateSrray = [cc.categoryName componentsSeparatedByString:@":"];
            NSString *parName = [seprateSrray objectAtIndex:0];
            NSString *childName = [seprateSrray objectAtIndex:1];
            
            //获取父类的category
            NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
            NSFetchRequest *fetchRequest=	[appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //获取父类category的数组
            NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            
            if([tmpParCategoryArray count]>0)
            {
                //获取到父层的category
                Category *pc =  [tmpParCategoryArray lastObject];
                BOOL isFound = FALSE;
                
                //判断找到的这个category是不是在已经保存的有category数组中，如果没有的话，就需要网category数组中添加这个父category的相关信息
                
                for (int j=0; j<[_categoryArrayList count]; j++)
                {
                    TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:j];
                    
                    
                    if([pc.categoryName isEqualToString:cc.categoryName])
                    {
                        [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                        if(cc.c == nil){
                            cc.c = pc;
                        }
                        
                        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                        [cc.transcationArray sortUsingDescriptors:sorts];
                        
                        
                        //计算这个sction底下的金额(一个section代表一个category)
                        isFound = TRUE;
                        double amount =0.0;
                        for (int j=0; j<[[sectionInfo objects]  count];j++)
                        {
                            Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                            amount += [entry.amount doubleValue];
                            
                        }
                        if(amount >0)
                        {
                            ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                            ccc.fullName = [sectionInfo name] ;
                            ccc.categoryName = childName;
                            ccc.amount = amount;
                            [cc.childCateArray addObject:ccc];
                        }
                        break;
                    }
                }
                
                //1.1如果没发现父层category的话,由于这是一个子类，需要创建一个父类
                if(!isFound)
                {
                    TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
                    cc.categoryName = pc.categoryName ;
                    [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                    [_categoryArrayList addObject:cc];
                    if(cc.c == nil)
                    {
                        cc.c = pc;
                    }
                    
                    double amount =0.0;
                    
                    for (int j=0; j<[[sectionInfo objects]  count];j++)
                    {
                        Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                        amount += [entry.amount doubleValue];
                        
                    }
                    if(amount >0)
                    {
                        ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                        ccc.fullName = [sectionInfo name] ;
                        ccc.categoryName = childName;
                        ccc.amount = amount;
                        [cc.childCateArray addObject:ccc];
                    }
                }
            }
        }
        
        //2.这是一个父category
        else
        {
            
            [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
            if(cc.c == nil&&[cc.transcationArray count]>0)
            {
                Transaction *transaction = [cc.transcationArray objectAtIndex:0];
                cc.c = transaction.category;
            }
            [_categoryArrayList addObject:cc];
        }
    }
    
    
    //计算总的金额 以及 创建piViewDateArray
    double categoryTotalAmount=0;
    for (int i=0;i<[_categoryArrayList count];i++)
    {
        //每一个父category
        TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:i];
        categoryTotalAmount =0;
        if([cc.transcationArray count] > 0)
        {
            for (int j=0; j<[cc.transcationArray  count];j++)
            {
                Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:j];
                categoryTotalAmount +=[entry.amount doubleValue];
                totalCategoryIncomeAmount += [entry.amount doubleValue];
            }
            
            //这里才是建立需要显示的数组
            if(categoryTotalAmount>0)
            {
                //创建圆环需要的数据
                tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:cc.categoryName==nil? @"Not Sure":cc.categoryName color:[UIColor clearColor] data:categoryTotalAmount];
                tmpPiChartViewItem.category = cc.c;
                tmpPiChartViewItem.indexOfMemArr =i;
                [tmpPiViewDateArray addObject:tmpPiChartViewItem];
                
            }
        }
    }
    
    //将获取到的圆环数据按照percent排序
    NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    [tmpPiViewDateArray sortUsingDescriptors:sorts];
    
    
    PiChartViewItem *tmpPiItem;
    [_piViewDateArray_Income removeAllObjects];
    for (int i = 0; i<[tmpPiViewDateArray count];i++)
    {
        tmpPiItem =[tmpPiViewDateArray objectAtIndex:i];
        [_piViewDateArray_Income addObject:tmpPiItem];
    }
    
    
    
    
    if(totalCategoryIncomeAmount == 0)
    {
        for (int i = 0; i<[_piViewDateArray_Income count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray_Income objectAtIndex:i];
            tmpPiItem.cPercent = 1.0/[_piViewDateArray_Income count];
            tmpPiItem.cColor = [appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getIncImage:colorName];
            colorName ++;
            
        }
    }
    else
    {
        for (int i = 0; i<[_piViewDateArray_Income count];i++)
        {
            if(colorName == 10)
            {
                colorName = 0;
            }
            
            tmpPiItem =[_piViewDateArray_Income objectAtIndex:i];
            tmpPiItem.cPercent = tmpPiItem.cData/totalCategoryIncomeAmount;
            tmpPiItem.cColor =[appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = [appDelegete.epnc getIncImage:colorName];
            colorName ++;
        }
    }
    
//    [self.pichartView setCateData:_piViewDateArray_Income ];
//    [self.pichartView setNeedsDisplay];
}

-(void)getCashFlowData
{
//    if (_thisYearBtn.selected)
//    {
//        _rightBarLabel.text = [NSLocalizedString(@"VC_ThisYear", nil) uppercaseString];
//    }
//    else if (_lastYearBtn.selected)
//        _rightBarLabel.text = [NSLocalizedString(@"VC_LastYear", nil) uppercaseString];
//    else
//        _rightBarLabel.text = [NSLocalizedString(@"VC_Last12Months", nil) uppercaseString];
    [self setTimeLabelText];
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
    [_cashflowTableView reloadData];



}
-(void)resetStyleWithAds
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.isPurchased)
    {
        _cateandcashContainView.frame = CGRectMake(_cateandcashContainView.frame.origin.x, _cateandcashContainView.frame.origin.y, _cateandcashContainView.frame.size.width, self.view.frame.size.height-50);
    }
    else
    {
        _cateandcashContainView.frame = CGRectMake(_cateandcashContainView.frame.origin.x, _cateandcashContainView.frame.origin.y, _cateandcashContainView.frame.size.width, self.view.frame.size.height);
    }
}
#pragma mark custom API






#pragma mark View Will Appear Method
-(void)setTimeLabelText
{
    if (_categoryBtn.selected)
    {

        NSString *startString = [_dateFormatter stringFromDate:_categoryStartDate];
        NSString *endSrting = [_dateFormatter stringFromDate:_categoryEndDate];
        _categoryDateLabel.text = [NSString stringWithFormat:@"%@ - %@",startString,endSrting ];
    }
    else
    {
        NSString *tmpString1 = [_dateFormatter stringFromDate:_cashStartDate];
        NSString *tmpString2 = [_dateFormatter stringFromDate:_cashEndDate];

        _cashFlowDateLabel.text = [NSString stringWithFormat:@"%@ － %@",tmpString1,tmpString2];


    }
}

//---------2.创建 cash array的数组
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


//-----------3.统计fetchController的分组数据，然后替换cash array中的数据
-(void)calculateSortArrayandReplaceCashArray
{
    //获取数组的个数
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
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
        NSDate *oneDate = [appDelegate_iPhone.epnc getStartDateWithDateType:2 fromDate:oneTransaction.dateTime];
        for (int k=0; k<12; k++) {
            BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:k];
            if ([appDelegate_iPhone.epnc monthCompare:oneDate withDate:oneBrokenLineObject.dateTime]==0) {
                oneBrokenLineObject.expenseAmount = itemTotalExpenseAmount;
                oneBrokenLineObject.incomeAmount = itemTotalIncomeAmount;
                oneBrokenLineObject.maxAmount = maxOfBarAmount;
                break;
            }
        }
    }
}

//------4.给画图的类 填充数组
-(void)setBarChartViewData
{
    double w = (SCREEN_WIDTH-30)/6.0;
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
//
//-(void)getSegmentDataFromCustomDataFirstDate
//{
//}
//
//-(void)setBrokenLineViewOnePage
//{
//}
//
//-(void)getSegmentDataFromeCustomeDataNextPart
//{
//}
//
//-(void)getSegmentDataFromeCustomeDataLastPart
//{
//}
//
//








- (void)SubCateRectDelegate:(NSInteger)i withSelected:(BOOL)isSel withCCIndex:(NSInteger)index
{
    /*
    TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:index];
     double amount=0;
    [_transactionArray removeAllObjects];
    ChildCategoryCount *ccc = [cc.childCateArray objectAtIndex:i];
    ccc.isNeedShowData = isSel;
    
    for (int ii=0; ii<[cc.transcationArray  count];ii++) {
        Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:ii];
        if (([entry.category.categoryType isEqualToString:@"EXPENSE"]&& !_expenseOrIncomeBtn.selected)||
            ([entry.category.categoryType isEqualToString:@"INCOME"] &&_expenseOrIncomeBtn.selected )
            ) 
        {
            if([entry.category.categoryName isEqualToString: cc.categoryName])
            {
                amount += [entry.amount doubleValue];
                [_transactionArray addObject:entry];
                
            }
            else
            {
                
                for(int j = 0;j< [cc.childCateArray count];j++)
                {
                    ChildCategoryCount *tmpccc = [cc.childCateArray objectAtIndex:j];

                     if([entry.category.categoryName isEqualToString:tmpccc.fullName] &&tmpccc.isNeedShowData)
                    {
                        amount += [entry.amount doubleValue];
                        [_transactionArray addObject:entry];
                        
                    }
                }
                
            }
            
        }
    }
     */
}
//----------------------获取所有的交易数据的详细信息，按照时间排序，不分类别
- (void) setDetailTranscationDateSouce{
 	[_detailTranArray removeAllObjects];
    NSError *error =nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	[_detailTranArray setArray:[_fetchedResultsController fetchedObjects] ];
	NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
 	[_detailTranArray sortUsingDescriptors:sorts];

}

- (void)PiChartViewDelegateByIndex:(NSInteger) i;
{
    ;
}

#pragma mark Button Action
-(void)rightBarBtnPressed:(UIButton *)sender
{
    if (_categoryBtn.selected)
    {
        if (_dateRangeView.frame.size.height==0)
        {
            _shadowView.alpha=0.1;
            [self showDateRangeViewAnimation];
        }
        else
        {
            _shadowView.alpha=0;
            [self hideDateRangeViewAnimation];
        }
    }
    else
    {
        if (_cashTimeView.frame.size.height==0)
        {
            _shadowView.alpha=0.1;
            [self showCashDateRangeViewAnimation];
        }
        else
        {
            _shadowView.alpha=0;
            [self hideCashDateRangeViewAnimation];
        }
    }
    
}
-(void)dateRangeBtnPressed:(UIButton *)sender
{
    _shadowView.alpha=0;
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
        self.dateType=0;
        
    }
    else if (_date2Btn.selected)
    {
        [startcomponent setMonth:-1];
		[endcomponent setMonth:1];
		[endcomponent setDay:-1];
        NSDate *tmpStartDate = [cal dateByAddingComponents:startcomponent toDate:[NSDate date] options:0];
        _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:tmpStartDate];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_categoryStartDate];
        self.dateType=1;
        
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
        self.dateType=2;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_THQT"];

    }
    else if (_date4Btn.selected)
    {
        _categoryStartDate =[appDelegate.epnc getStartDate:@"Last Quarter"];
        _categoryEndDate = [appDelegate.epnc getEndDate:_categoryStartDate withDateString:@"Last Quarter"];
        self.dateType=3;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_LTQT"];

    }
    else if (_date5Btn.selected)
    {
        _categoryStartDate = [appDelegate.epnc getStartDateWithDateType:3 fromDate:[NSDate date]];
        _categoryEndDate = [appDelegate.epnc getEndDateDateType:3 withStartDate:_categoryStartDate];
        self.dateType=4;
        
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
        self.dateType=5;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_LTYR"];


    }
    else
    {
        CustomDateViewController *customDateViewController = [[CustomDateViewController alloc]initWithNibName:@"CustomDateViewController" bundle:nil];
        customDateViewController.cdvc_expenseViewController = self;
        
        [self.navigationController pushViewController:customDateViewController animated:YES];
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"15_RANG_CUST"];

    }
    [self hideNavView];
    [self hideDateRangeViewAnimation];
    //设置位置
    //获取数据
    [self getCategoryData];
}

-(void)expenseOrIncomeBtnPressed:(UIButton *)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (sender==_expenseBtn && _expenseBtn.selected)
    {
        return;
    }
    else if (sender==_incomeBtn && _incomeBtn.selected)
        return;
    else if (sender==_expenseBtn)
    {
        _expenseBtn.selected = YES;
        _incomeBtn.selected = NO;
        
        expenseFrontLabel.textColor = [UIColor whiteColor];
        expenseBackLabel.textColor = [UIColor whiteColor];
        incomeFrontLabel.textColor =  [appDelegate.epnc getAmountBlackColor];
        incomeBackLabel.textColor = [appDelegate.epnc getAmountBlackColor];
    }
    else
    {
        _expenseBtn.selected = NO;
        _incomeBtn.selected = YES;
        expenseFrontLabel.textColor = [appDelegate.epnc getAmountBlackColor];
        expenseBackLabel.textColor = [appDelegate.epnc getAmountBlackColor];
        incomeFrontLabel.textColor =  [UIColor whiteColor];
        incomeBackLabel.textColor = [UIColor whiteColor];
    }
    
    [self getCategoryData];
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

-(void)resetCashFlowBtnState
{
    _thisYearBtn.selected = NO;
    _lastYearBtn.selected = NO;
    _LastTweleveBtn.selected = NO;
}

-(void)categoryOrCashFlowBtnPressed:(UIButton *)sender
{
    if (_categoryBtn.selected && sender==_categoryBtn)
    {
        [self hideNavView];
        [self hideCashDateRangeViewAnimation];
        [self hideDateRangeViewAnimation];
        return;
    }
    else if (_cashFlowBtn.selected && sender==_cashFlowBtn)
    {
        [self hideNavView];
        [self hideCashDateRangeViewAnimation];
        [self hideDateRangeViewAnimation];
        return;
    }
    else if(sender==_categoryBtn)
    {
        _cashFlowBtn.selected = NO;
        _categoryBtn.selected = YES;
        _leftBarLabel.text = [NSLocalizedString(@"VC_Categories", nil) uppercaseString];
        [self getCategoryData];
    }
    else
    {
        _cashFlowBtn.selected = YES;
        _categoryBtn.selected = NO;
        _leftBarLabel.text = [NSLocalizedString(@"VC_CASHFLOW", nil) uppercaseString];

        [self getCashFlowData];
    }
    [self setLeftBarLabelFram];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_cateandcashContainView cache:YES];
    [_cateandcashContainView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
    
    [self hideNavView];
    [self hideCashDateRangeViewAnimation];
    [self hideDateRangeViewAnimation];

}

-(void)cashFlowTimeBtnPressed:(UIButton *)sender
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *component = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];

    
    if ((_thisYearBtn.selected && sender==_thisYearBtn) || (_lastYearBtn.selected && sender == _lastYearBtn) || (_LastTweleveBtn.selected && sender==_LastTweleveBtn))
    {
        [self hideCashDateRangeViewAnimation];
        [self hideNavView];
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
    [self hideNavView];
    [self hideCashDateRangeViewAnimation];
    [self getCashFlowData];
}

-(void)navViewBtnPressed:(UIButton *)sender
{
    if (_typeView.frame.size.height==0)
    {
        [self showNavView];
    }
    else
        [self hideNavView];
}

-(void)hideNavView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _typeView.frame = CGRectMake(_typeView.frame.origin.x, _typeView.frame.origin.y, _typeView.frame.size.width, 0);

    [UIView commitAnimations];
}
-(void)showNavView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _typeView.frame = CGRectMake(_typeView.frame.origin.x, _typeView.frame.origin.y, _typeView.frame.size.width, 44*2);
    [UIView commitAnimations];
}
-(void)showDateRangeViewAnimation
{
    if (_categoryBtn.selected)
    {
        [self resetDateRangeBtnState];
        if (_dateType==0)
        {
            _date1Btn.selected = YES;
        }
        else if (_dateType==1)
            _date2Btn.selected = YES;
        else if (_dateType==2)
            _date3Btn.selected = YES;
        else if (_dateType==3)
            _date4Btn.selected = YES;
        else if (_dateType==4)
            _date5Btn.selected = YES;
        else if (_dateType==5)
            _date6Btn.selected = YES;
        else if (_dateType==6)
            _date7Btn.selected = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:0.3];
        _dateRangeView.frame = CGRectMake(SCREEN_WIDTH-121-10, 5, 121, DATERANGEVIEW_HIGH);
        _rightBarArrow.transform = CGAffineTransformMakeRotation(-180*M_PI/180);
        _rightBarArrow.center = _rightBarArrow.center;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:0.3];
        _cashTimeView.frame = CGRectMake(_cashTimeView.frame.origin.x, _cashTimeView.frame.origin.y, _cashTimeView.frame.size.width, RIGHT_BTN_HIGH*3);
        _rightBarArrow.transform = CGAffineTransformMakeRotation(-180*M_PI/180);
        _rightBarArrow.center = _rightBarArrow.center;
        [UIView commitAnimations];
    }
    
}

-(void)hideDateRangeViewAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    _dateRangeView.frame = CGRectMake(SCREEN_WIDTH-10, 5, 0, 0);
    _rightBarArrow.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    _rightBarArrow.center = _rightBarArrow.center;
    [UIView commitAnimations];
}

-(void)showCashDateRangeViewAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    _cashTimeView.frame = CGRectMake(_cashTimeView.frame.origin.x, _cashTimeView.frame.origin.y, _cashTimeView.frame.size.width, RIGHT_BTN_HIGH*3);
    _rightBarArrow.transform = CGAffineTransformMakeRotation(-180*M_PI/180);
    _rightBarArrow.center = _rightBarArrow.center;
    [UIView commitAnimations];
}

-(void)hideCashDateRangeViewAnimation
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.3];
    _cashTimeView.frame = CGRectMake(_cashTimeView.frame.origin.x, _cashTimeView.frame.origin.y, _cashTimeView.frame.size.width, 0);
    _rightBarArrow.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    _rightBarArrow.center = _rightBarArrow.center;
    [UIView commitAnimations];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (tableView == _categorytableview)
    {
        if (_expenseBtn.selected)
            return [_piViewDateArray count];
        else
            return [_piViewDateArray_Income count];
    }
    else
        return [_transactionByDateArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    
    float categoryToLeft;
    float percentToRight;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        categoryToLeft=20;
        percentToRight=124;
    }
    else if (IS_IPHONE_6)
    {
        categoryToLeft=40;
        percentToRight=147;
    }
    else if (IS_IPHONE_6PLUS)
    {
        categoryToLeft=40;
        percentToRight=162;
    }
    
    
    UIColor *textColor = [UIColor colorWithRed:166.f/255.f green:166.f/255.f blue:166.f/255.f alpha:1];
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryToLeft, 7, 100, 15)];
    [monthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    monthLabel.textColor = textColor;
    monthLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-percentToRight-72, 7, 75, 15)];
    [percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    percentLabel.textColor = textColor;
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-70, 7, 70, 15)];
    [amountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    amountLabel.textColor = textColor;
    amountLabel.textAlignment = NSTextAlignmentRight;
   
    monthLabel.text = @"CATEGORY";
    percentLabel.text = @"PERCENT";
    amountLabel.text = @"AMOUNT";

    [headView addSubview:monthLabel];
    [headView addSubview:percentLabel];
    [headView addSubview:amountLabel];

    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView==_categorytableview)
    {
        static NSString *TrackCellIdentifier = @"TrackCell";
        TrackerCell *cell = (TrackerCell *)[tableView dequeueReusableCellWithIdentifier:TrackCellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TrackerCell" owner:nil options:nil]lastObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        //color label上面的投影是在cell里面加的
        [self configureCategoryCell:cell atIndexPath:indexPath];
        return cell;
    }
    else
    {
        static NSString *TrackCellIdentifier = @"CashFlowCell";
        CashFlowCell *cell = (CashFlowCell *)[tableView dequeueReusableCellWithIdentifier:TrackCellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CashFlowCell" owner:nil options:nil]lastObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        //color label上面的投影是在cell里面加的
        [self configureCashFlowCell:cell atIndexPath:indexPath];
        return cell;

    }
   

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_categorytableview)
    {
        PiChartViewItem *tmpPiItemPar;
        if (_expenseBtn.selected)
        {
            tmpPiItemPar= [_piViewDateArray objectAtIndex:indexPath.row];
        }
        else
            tmpPiItemPar= [_piViewDateArray_Income objectAtIndex:indexPath.row];
//        if(tmpPiItemPar.indexOfMemArr ==-1) return;
        
//        TranscationCategoryCount *cc = [_categoryArrayList objectAtIndex:tmpPiItemPar.indexOfMemArr];
        
        _expenseSecondCategoryViewController = [[ExpenseSecondCategoryViewController alloc]initWithNibName:@"ExpenseSecondCategoryViewController" bundle:nil];
        _expenseSecondCategoryViewController.startDate  = _categoryStartDate;
        _expenseSecondCategoryViewController.endDate = _categoryEndDate;
        _expenseSecondCategoryViewController.c = tmpPiItemPar.category;
        _expenseSecondCategoryViewController.dateType = self.dateType;

        _expenseSecondCategoryViewController.isExpenseType = _expenseBtn.selected?YES:NO;
        
        //隐藏tabbar
        _expenseSecondCategoryViewController.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:_expenseSecondCategoryViewController animated:YES];
    }
    else
    {
        BrokenLineObject *oneBrokenLineObject= [_transactionByDateArray objectAtIndex:indexPath.row];
        
        _cashDetailTransactionViewController = [[CashDetailTransactionViewController alloc]initWithNibName:@"CashDetailTransactionViewController" bundle:nil];
        self.cashDetailTransactionViewController.ctvc_startDate = oneBrokenLineObject.dateTime;
        //隐藏tabbar
        self.cashDetailTransactionViewController.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:self.cashDetailTransactionViewController animated:YES];

    }
}

- (void)configureCategoryCell:(TrackerCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    // Configure the cell
    PiChartViewItem *tmpPiItem;
    if (_expenseBtn.selected)
    {
        tmpPiItem= [_piViewDateArray objectAtIndex:indexPath.row];
    }
    else
        tmpPiItem= [_piViewDateArray_Income objectAtIndex:indexPath.row];
    //percent
    cell.percentLabel.text = [[NSString stringWithFormat: @"%.2f",tmpPiItem.cPercent*100] stringByAppendingString:@"%"];
    //category
    cell.categoryLabel.text = tmpPiItem.cName;
    cell.colorLabel.image = tmpPiItem.cImage;
    
    double amount=tmpPiItem.cData;
    if (amount>999999999)
    {
        cell.amountLabel.text = [NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:amount/1000]];
    }
    else
    {
        cell.amountLabel.text = [appDelegate.epnc formatterString:tmpPiItem.cData];
    }
}

- (void)configureCashFlowCell:(CashFlowCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    // Configure the cell
    BrokenLineObject *oneBrokenLineObject = [_transactionByDateArray objectAtIndex:indexPath.row];
    
    
    //date time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM"];
    
    cell.dateLabel.text =  [[dateFormatter stringFromDate:oneBrokenLineObject.dateTime]uppercaseString];


    
    //amount
    cell.inAmountLabel.text = [appDelegate.epnc formatterString:oneBrokenLineObject.incomeAmount];
    cell.outamountLabel.text = [appDelegate.epnc formatterString:oneBrokenLineObject.expenseAmount];
    
    
    

}


#pragma mark -
#pragma mark Fetched results controller
//------------------------获取起始时间下的交易数组，按照category分类
- (NSFetchedResultsController *)fetchedResultsControllerExpenseCategory:(BOOL)isExpenseCategory{
	PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSError * error=nil;
    NSDictionary *subs;
    if (isExpenseCategory)
    {
        subs = [NSDictionary dictionaryWithObjectsAndKeys:_categoryStartDate,@"startDate",_categoryEndDate,@"endDate",@"EXPENSE",@"TYPE", nil];
    }
    else
        subs = [NSDictionary dictionaryWithObjectsAndKeys:_categoryStartDate,@"startDate",_categoryEndDate,@"endDate",@"INCOME",@"TYPE", nil];

 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDateandCategoryType" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSFetchedResultsController* fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																					 managedObjectContext:appDelegete.managedObjectContext
																					   sectionNameKeyPath:@"category.categoryName"
																								cacheName:@"Root"];
	self.fetchedResultsController = fetchedResults;
	[fetchedResults performFetch:&error];

	return _fetchedResultsController;
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


#pragma mark view release and dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    _categorytableview.delegate = nil;
    _categorytableview.dataSource = nil;
    [super viewDidUnload];
}



@end


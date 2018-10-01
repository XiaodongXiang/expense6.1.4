//
//  BudgetViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/21/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "BudgetViewController.h"
#import "BudgetTemplate.h"
#import "BudgetItem.h"
#import "Category.h"
#import "Transaction.h"
#import "BudgetDetailViewController.h"
//#import "TransferViewController.h"
#import "BudgetCountClass.h"
#import "PokcetExpenseAppDelegate.h"
#import "BudgetTransfer.h"
#import "AppDelegate_iPhone.h"
#import "BudgetCell_NS.h"
#import "TransferViewController_NS.h"
#import "TransactionCategorySplitViewController.h"

#import "BudgetListViewController.h"
#import "BudgetSettingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "budgetBar.h"


#define SPENTIMAGE_LEFTX    21
#define SPENT_LEFT_ARC_LEFTX    15
#define BUDGETBAR_ORIGNY    53
#define BUDGETBAR_HIGH  12
#define HALF_ARC_WITH   6
#define HALF_ARC_RIGHT_ORGINX 299

@implementation BudgetViewController

#pragma mark view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavBarStyle];
   	[self initMemoryDefine];
    _norecordString.hidden = NO;
    [self addAdsBtn];
 	
}
-(void)addAdsBtn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *purchasePrice = [userDefaults stringForKey:PURCHASE_PRICE];
    
    UIImage *adsImage=[UIImage imageNamed:[NSString customImageName:@"advertisement"]];
    
    
    UIView *adsView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-adsImage.size.height, SCREEN_WIDTH, adsImage.size.height)];
    adsView.backgroundColor=[UIColor colorWithPatternImage:adsImage];
    [self.view addSubview:adsView];
    
   UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-80, (adsImage.size.height-30)/2, 80, 30)];
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.text=purchasePrice;
    priceLabel.textColor=[UIColor whiteColor];
    priceLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [adsView addSubview:priceLabel];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (appdelegate.isPurchased)
    {
        [adsView removeFromSuperview];
    }
    
    UIButton *adsBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adsImage.size.height)];
    [adsBtn addTarget:self action:@selector(adsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [adsView addSubview:adsBtn];
}
-(void)adsBtnClicked:(id)sender
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.inAppPM canMakePurchases])
    {
        [appDelegate.inAppPM  purchaseProUpgrade];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self refleshUI];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = NO;
    [self resetStyleWithAds];
    appDelegate.customerTabbarView.hidden = NO;
    
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
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
-(void)refleshUI
{
//    [self setStartDateandEndDate];
    [self setTodayLineandTodayLabel];
    [self setMonthTitleByIndex];
    _swipCellIndex = -1;
    [self getDataSouce_New];
    
	[_bc_TableView reloadData];
}
-(void)refleshRecurringStyle
{
    [self setStartDateandEndDate];
    [self setTodayLineandTodayLabel];
    [self setMonthTitleByIndex];
    _swipCellIndex = -1;
    [self getDataSouce_New];
    [_bc_TableView reloadData];
}
-(void)resetStyleWithAds
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.isPurchased)
        _tableviewB.constant = 50;
    else
    
        _tableviewB.constant = 0;
}

#pragma mark View did load Method
-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_Budget", nil);
    
    
    //左按钮
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1],
                                                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17
                                                                      ]}];
    
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation_adjustment"] style:UIBarButtonItemStyleBordered target:self action:@selector(setupaction:)];
    rightButton.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];

    
}
-(void)leftDrawerButtonPress:(id)sender
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [appDelegate.menuVC reloadView];
}

-(void)initMemoryDefine
{
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
   
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tmpBudgetString = [userDefault stringForKey:@"BudgetRepeatType"];
    if ([tmpBudgetString isEqualToString:@"Weekly"])
    {
        budgetRepeatType = @"Weekly";
    }
    else
        budgetRepeatType = @"Monthly";
    spentimage_with = SCREEN_WIDTH - 21*2;
    budgetbar_with = SCREEN_WIDTH - 30;
    _bgImage.image = [UIImage imageNamed:[NSString customImageName:@"budget_bg_320_109.png"]];
    
    _norecordString.text = NSLocalizedString(@"VC_You have no budgets setup. You can create them by tapping the \"Adjust\" button.", nil);
    
 	_budgetArray = [[NSMutableArray alloc] init];
	_noRecordView.hidden = YES;
    dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    dateFormatterWithYear = [[NSDateFormatter alloc]init];
    [dateFormatterWithYear setDateFormat:@"MMM dd, yyyy"];
    monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MMM yyyy"];
    _availLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    
    [_bvc_leftBtn addTarget:self action:@selector(lastMonthBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bvc_rightBtn addTarget:self action:@selector(nextMonthBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    [_setupBtn addTarget:self action:@selector(setupaction:) forControlEvents:UIControlEventTouchUpInside];
    [_transferButton addTarget:self action:@selector(addTransfer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setStartDateandEndDate];
    
    _swipCellIndex = -1;
}

-(void)setStartDateandEndDate
{
    //获取时间
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tmpBudgetString = [userDefault stringForKey:@"BudgetRepeatType"];
    if ([tmpBudgetString isEqualToString:@"Weekly"])
    {
        budgetRepeatType = @"Weekly";
    }
    else
        budgetRepeatType = @"Monthly";
    if([budgetRepeatType isEqualToString:@"Weekly"])
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:1 fromDate:[NSDate date]];
        self.endDate = [appDelegate.epnc getEndDateDateType:1 withStartDate:self.startDate];
    }
    else
    {
        self.startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
        self.endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.startDate];
    }

}

-(void)setTodayLineandTodayLabel
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSDate *monthStartDate=[appDelegate.epnc  getStartDateWithDateType:2 fromDate:[NSDate date]];
    
    NSDate *monthEndDate=[appDelegate.epnc getEndDateDateType:2 withStartDate:monthStartDate];
    unsigned int flag=NSDayCalendarUnit;
    NSDateComponents *componet=[[NSCalendar currentCalendar] components:flag fromDate:monthStartDate toDate:monthEndDate options:nil];
    NSDateComponents *component2=[[NSCalendar currentCalendar] components:flag fromDate:monthStartDate toDate:[NSDate date] options:nil];
    CGFloat monthDays=[componet day]+1;
    CGFloat todayCount=[component2 day]+1;
    CGFloat count=todayCount/monthDays;
    
    _todayView.frame = CGRectMake(20+count*(SCREEN_WIDTH-30) , _todayView.frame.origin.y, _todayView.frame.size.width, _todayView.frame.size.height);
}


//通过标记来获取 上一个或者下一个月份的起始时间与结束时间
-(void)setMonthTitleByIndex
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if ([budgetRepeatType isEqualToString:@"Weekly"])
    {
        _dateTitleLabel.text = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:_startDate],[dateFormatterWithYear stringFromDate:_endDate]];
        if ([appDelegate_iPhone.epnc weekCompare:self.endDate withDate:[NSDate date]]<0) {
            _bvc_rightBtn.enabled = YES;
        }
        else
            _bvc_rightBtn.enabled = NO;
    }
    
    else
    {
        self.dateTitleLabel.text = [monthFormatter stringFromDate:self.endDate];
        if ([appDelegate_iPhone.epnc monthCompare:self.endDate withDate:[NSDate date]]<0) {
            _bvc_rightBtn.enabled = YES;
        }
        else
            _bvc_rightBtn.enabled = NO;
    }
}

#pragma mark   Btn Action
- (IBAction) lastMonthBtnPressed:(id)sender
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if ([budgetRepeatType isEqualToString:@"Weekly"])
    {
        self.startDate = [appDelegate_iPhone.epnc getStartDate:@"Weekly" beforCycleCount:1 withDate:self.startDate];
        self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:1 withStartDate:self.startDate];
    }
    else
    {
        self.startDate = [appDelegate_iPhone.epnc getStartDate:@"MONTHLY" beforCycleCount:1 withDate:self.startDate];
        self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:2 withStartDate:self.startDate];
    }
    
    [self setMonthTitleByIndex];
    [self getDataSouce_New];
    [self.bc_TableView reloadData];
}

- (IBAction) nextMonthBtnPressed:(id)sender
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if ([budgetRepeatType isEqualToString:@"Weekly"])
    {
        self.startDate = [appDelegate_iPhone.epnc getNextDate:self.startDate byCycleType:@"Weekly"];
        self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:1 withStartDate:self.startDate];
    }
    else
    {
        self.startDate = [appDelegate_iPhone.epnc getNextDate:self.startDate byCycleType:@"MONTHLY"];
        self.endDate = [appDelegate_iPhone.epnc getEndDateDateType:2 withStartDate:self.startDate];
    }

    [self setMonthTitleByIndex];
    [self getDataSouce_New];
    [self.bc_TableView reloadData];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) addTransfer:(id)sender
{
    TransferViewController_NS *transferController =[[TransferViewController_NS alloc] initWithNibName:@"TransferViewController_NS" bundle:nil];
    transferController.typeOftodo = @"ADD";
    transferController.startDate = self.startDate;
    transferController.endDate = self.endDate;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transferController];
    [self presentViewController:navigationController animated:YES completion:nil];

}
-(void)setupaction:(id)sender
{
//    self.budgetListViewController = [[BudgetListViewController alloc]initWithNibName:@"BudgetListViewController" bundle:nil];
//    _budgetListViewController.budgetViewController = self;
//    _budgetListViewController.transactionCategorySplitViewController = nil;
//    [self.navigationController pushViewController:_budgetListViewController animated:YES];
    
    _budgetSettingViewController = [[BudgetSettingViewController alloc]initWithNibName:@"BudgetSettingViewController" bundle:nil];
    _budgetSettingViewController.budgetViewController = self;
    
    
    //隐藏tabbar
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    _budgetSettingViewController.hidesBottomBarWhenPushed = TRUE;
    appDelegate.customerTabbarView.hidden = YES;
    [self.navigationController pushViewController:_budgetSettingViewController animated:YES];

}

-(void)deleteBtnPressed:(UIButton *)sender{
    _deleteIndex = sender.tag;
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    BudgetCountClass *bcc = (BudgetCountClass *)[_budgetArray objectAtIndex: _deleteIndex];
    [appDelegete.epdc deleteBudgetRel:bcc.bt] ;
    _swipCellIndex = -1;
    [self getDataSouce_New];
//    [self getDataSouce];
    [_bc_TableView reloadData];
}





#pragma mark Table view methods


- (void)configureBudgetCell_New:(BudgetCell_NS *)cell atIndexPath:(NSIndexPath *)indexPath {
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

 	BudgetCountClass *bcc = (BudgetCountClass *)[_budgetArray objectAtIndex:indexPath.row];
	
    cell.nameLabel.text = bcc.bt.category.categoryName;

    double totalblance = [bcc.bt.amount doubleValue]+bcc.btTotalIncome ;
    double spent =  bcc.btTotalExpense;
    
    UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    UIColor *gray=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];

    //budgetBar
    if (spent>=totalblance)
    {
        cell.budgetBar=[[budgetBar alloc]initWithFrame:CGRectMake(52, 35, SCREEN_WIDTH-52-35, 5) type:NO ratio:totalblance/spent   color:red];
    }
    if (spent<totalblance)
    {
        cell.budgetBar=[[budgetBar alloc]initWithFrame:CGRectMake(52, 35, SCREEN_WIDTH-52-35, 5) type:NO ratio:spent/totalblance  color:gray];
    }
    [cell.contentView addSubview:cell.budgetBar];
    
    
    //设置预算Label位置
    
    NSString *usedStr = [appDelegate.epnc formatterString:spent];
    NSString *allStr = [appDelegate.epnc formatterString:totalblance];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@",usedStr,allStr]];
    
    NSUInteger len = [usedStr length];
    
    UIColor *headColor;
    if (totalblance >= spent)
    {
        headColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    }
    else
    {
        headColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:headColor range:NSMakeRange(0, len)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14] range:NSMakeRange(0, len)];
    
    cell.budgetLabel.attributedText = str;
    
    
    cell.spentLable.text = [NSString stringWithFormat:@"%@",[appDelegate.epnc formatterString:totalblance - spent]];
    
    //设置图片
    cell.icon.image=[UIImage imageNamed:bcc.bt.category.iconName];
    
    cell.bottomLineHeight.constant=1/SCREEN_SCALE;
    
    cell.spentLable.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
    cell.budgetLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:10];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
 	return [_budgetArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"budgetCell";
    BudgetCell_NS *cell = (BudgetCell_NS *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BudgetCell_NS" owner:nil options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.tag = indexPath.row;
    [self configureBudgetCell_New:cell atIndexPath:indexPath];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 	BudgetDetailViewController *logController =[[BudgetDetailViewController alloc] initWithNibName:@"BudgetDetailViewController" bundle:nil];
	BudgetCountClass *bcc = (BudgetCountClass *)[_budgetArray objectAtIndex:indexPath.row];
    
	NSMutableArray *tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[bcc.bt.budgetItems allObjects]];
	NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
	[tmpArrayItem sortUsingDescriptors:sorts];

 
	BudgetItem *budgetTemplateCurrentItem = nil;
    
    budgetTemplateCurrentItem = [tmpArrayItem lastObject];
    logController.startDate = self.startDate;
    logController.endDate = self.endDate;


	logController.budgetTemplate = bcc.bt;
    logController.startDate = self.startDate;
    logController.endDate = self.endDate;
	logController.budgetItem =budgetTemplateCurrentItem;
	logController.typeOftodo = @"DETAIL";
    
    //隐藏tabbar
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    logController.hidesBottomBarWhenPushed = TRUE;
    appDelegate.customerTabbarView.hidden = YES;
  	[[self navigationController] pushViewController:logController animated:YES];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64.0;
}



//删除东西的时候，直接在编辑的editarray 中删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    BudgetCountClass *oneBudgetCount = [_budgetArray objectAtIndex: indexPath.row];
    
    
    [appDelegete.epdc deleteBudgetRel:oneBudgetCount.bt] ;
    [self getDataSouce_New];
    [_bc_TableView reloadData];
}


#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_swipCellIndex!=-1) {
        _swipCellIndex=-1;
        _bc_TableView.scrollEnabled = NO;
        [_bc_TableView reloadData];
        _bc_TableView.scrollEnabled = YES;
        [_bc_TableView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)getDataSouce_New
{
 	[self.budgetArray removeAllObjects];
    _currentBudgetItem = 0;
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
 	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];

	
	double totalBudgetAmount = 0;
	double totalExpense = 0;
    double totalRollover = 0;
    
 	double totalIncome = 0;
	BudgetCountClass *bcc;
    
	NSDictionary *subs;
	for (int i = 0; i<[allBudgetArray count];i++)
    {
		BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
        bcc = [[BudgetCountClass alloc] init];
        bcc.bt = budgetTemplate;
        bcc.btTotalExpense =0;
        bcc.btTotalIncome =0;
		BudgetItem *budgetTemplateCurrentItem =[[budgetTemplate.budgetItems allObjects] lastObject];
        
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
            
            
            //获取该budgetTemplate下 该段时间内的transaction,统计
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"] && [t.state isEqualToString:@"1"])
                {
                    bcc.btTotalExpense +=[t.amount doubleValue];
                    totalExpense +=[t.amount doubleValue];
                }
                else if([t.category.categoryType isEqualToString:@"INCOME"] && [t.state isEqualToString:@"1"]){
                    bcc.btTotalIncome +=[t.amount doubleValue];
                    totalIncome +=[t.amount doubleValue];
                }
                
            }
            
            //获取该budgetTemplate下 该段时间内的transfer,统计
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
            for (int j = 0;j<[tmpArray1 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.endDate]<=0 && [bttmp.state isEqualToString:@"1"])
					bcc.btTotalExpense +=[bttmp.amount doubleValue];
                //totalExpense +=[bttmp.amount doubleValue];
                
            }
            
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
            for (int j = 0; j<[tmpArray2 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:self.endDate]<=0 && [bttmp.state isEqualToString:@"1"])
					bcc.btTotalIncome +=[bttmp.amount doubleValue];
                //totalIncome +=[bttmp.amount doubleValue];
                
            }
            
            ////////////////////获取子类category的交易
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound)
            {
                
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
             
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                bcc.btTotalExpense +=[t.amount doubleValue];
                                totalExpense +=[t.amount doubleValue];
                            }
                            else if([t.category.categoryType isEqualToString:@"INCOME"])
                            {
                                bcc.btTotalIncome +=[t.amount doubleValue];
                                totalIncome +=[t.amount doubleValue];
                            }
                            
                        }
                     
                    }
                }
                
           
            }
            
        }
        
        [_budgetArray addObject:bcc];
  
	}
    
 
    double totalblance = totalBudgetAmount+totalRollover + totalIncome;
    
//    _bvc_allBudgetAmountLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
//    _bvc_allBudgetAmountLabel.text=[appDelegate.epnc formatterString:totalblance];
    
    NSString *usedStr = [appDelegate.epnc formatterString:totalExpense];
    NSString *allStr = [appDelegate.epnc formatterString:totalblance];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@",usedStr,allStr]];
    
    NSUInteger len = [usedStr length];
    
    UIColor *headColor;
    if (totalblance >= totalExpense)
    {
        headColor = [UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
    }
    else
    {
        headColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    }
    
    [str addAttribute:NSForegroundColorAttributeName value:headColor range:NSMakeRange(0, len)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14] range:NSMakeRange(0, len)];

    _bvc_allBudgetAmountLabel.attributedText = str;
    
    
    _availLabel.text = [NSString stringWithFormat:@"%@",[appDelegate.epnc formatterString:totalblance - totalExpense]];

    
    
    

    double spent = totalExpense;
    //构建总budget bar
    
    UIColor *red=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
    UIColor *gray=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];

    budgetBar *topBar;
    if (totalblance==0)
    {
        topBar=[[budgetBar alloc]initWithFrame:CGRectMake(35, 79, SCREEN_WIDTH-70, 10) type:YES ratio:0 color:gray];
    }
    
    else if (spent<totalblance)
    {
        topBar=[[budgetBar alloc]initWithFrame:CGRectMake(35, 79,SCREEN_WIDTH-70, 10) type:YES ratio:spent/totalblance color:gray];
    }
    else
    {
        topBar=[[budgetBar alloc]initWithFrame:CGRectMake(35, 79, SCREEN_WIDTH-70, 10) type:YES ratio:totalblance/spent color:red];
    }
    [self.bvc_headerView addSubview:topBar];
    
    
    
    if([_budgetArray count] > 1)
    {
        self.transferButton.enabled = TRUE;
    }
    else {
        self.transferButton.enabled = FALSE;
    }
	if([_budgetArray count] ==0)
	{
		_noRecordView.hidden = NO;
        
	}
	else {
		_noRecordView.hidden = YES;
        
	}
    
    _totalBudget.text = NSLocalizedString(@"VC_Total", nil);
}

#pragma mark 
#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if(buttonIndex == 1)
	{  
// 		[mytableView setEditing:FALSE animated:YES];
//	 	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//		self.navigationItem.rightBarButtonItem = rightButton;
//		[rightButton release];
		return;
	}
	else
	{
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        BudgetCountClass *bcc = (BudgetCountClass *)[_budgetArray objectAtIndex: _deleteIndex];
        [appDelegete.epdc deleteBudgetRel:bcc.bt] ;
        
        [self getDataSouce_New];
//        [self getDataSouce];
//        if ([budgetArray count] == 0)
//        {
//            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//            self.navigationItem.rightBarButtonItem = rightButton;
//            [rightButton release];
//        }
        
        [_bc_TableView reloadData];
	}
}


#pragma mark view release and dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _bc_TableView.delegate = nil;
    _bc_TableView.dataSource = nil;
}





@end


//
//  TransactionEditViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-5.
//
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#import "ipad_TranscactionQuickEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_MainViewController.h"

//
#import "ipad_TranscationCategorySelectViewController.h"
#import "ipad_TransacationSplitViewController.h"
#import "CategorySelect.h"

#import "DropboxSyncTableDefine.h"
#import "EPNormalClass.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "ipad_AccountPickerViewController.h"
#import "AppDelegate_iPad.h"
#import "ipad_PayeeSearchCell.h"

#import "ipad_AccountViewController.h"
#import "ipad_BudgetViewController.h"
#import "ipad_SelectImageViewController.h"
#import "ipad_TransactionRecurringViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

#import "TestViewController.h"

#import "XDPlanControlClass.h"
#import <Parse/Parse.h>


#import "XDChristmasPlanBPopViewController.h"
#import "XDChristmasPlanAPopViewController.h"
#import "XDIpad_ADSViewController.h"

#import "XDChristmasLiteOneViewController.h"
#import "XDChristmasLitePlanAViewController.h"
#import "XDChristmasPlanAbViewController.h"
#import "XDChristmasPlanBbViewController.h"
@import Firebase;
//#import "ipad_SearchRelatedViewController.h"

#define ANIMATIONCURVE 0.25
@interface ipad_TranscactionQuickEditViewController ()<XDIpad_ADSViewDelegate>
{
}
@property(nonatomic, strong)ADEngineController* interstitial;

@property(nonatomic, strong)XDChristmasPlanAPopViewController* planA;
@property(nonatomic, strong)XDChristmasPlanBPopViewController* planB;
@end

@implementation ipad_TranscactionQuickEditViewController
@synthesize showCellTable,accountCell,fromAccountCell,toAccountCell,amountCell,categoryCell,dateCell,recurringCell,noteCell,imageCell,payeeCell,clearCell,showMoreDetailsCell,datePickerCell,selectedRowIndexPath;
@synthesize isSpliteTrans;
@synthesize payeText,payeeSearchView,payeeSearchTable,expenseBtn,incomeBtn,transferBtn,accountLabel,datePicker,recurringType,payeeString,transactionDate,photosName,documentsPath,memoTextView,fromAccountLabel,toAccountLabel;
@synthesize clearedSwitch,categoryLabel,phontoImageView,recurringLabel,picktype,dateLabel,showMoreDetails;
@synthesize transaction,accounts,fromAccounts,toAccounts,categories,otherCategory_income,otherCategory_expense,payees,typeoftodo,currentNumber;
@synthesize payeeArray,accountArray,categoryArray,pickItemArray,tranExpCategorySelectArray,picureArray,tranCategorySelectedArray,cycleTypeArray;
@synthesize   display,showFoperator,calculateView;
@synthesize thisTransisBeenDelete;
@synthesize transactionCategoryViewController,transactionCategorySplitViewController,outputFormatter,headerDateormatter;
@synthesize sectionHeaderLabel,memoLabel;
@synthesize iOverViewViewController,iAccountViewController,iBudgetViewController,iAccountPickerViewController;
@synthesize cagetoryLabelText,toAccountLabelText,dateLabelText,repeatLabelText,ClearedLabelText,photoLabelText,fromAccountLabelText,accountLabelText,showMoreLabelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //插页广告
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2202 - iPad - Interstitial - NewTransactionSave"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavBarStyle];
    [self initPoint];
    [self initContextShow];

    //获取account,category
    [self getDataSouce];
    [self setDefaultAcc_Cate];

    [self initAllSplitCategoryMemory];
    [self setselectedSplitCategoryMemory];
    //根据 transaction设置 数据
    [self setControlShowTextWithTranscation];
    
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"])
    {
        if (firsttoBeHere==0)
        {
            [payeText becomeFirstResponder];
            
        }
        else
            firsttoBeHere = 1;
    }
    [FIRAnalytics setScreenName:@"add_transaction_main_view_ipad" screenClass:@"ipad_TranscactionQuickEditViewController"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
//    self.iAccountViewController = nil;
    self.transactionCategoryViewController = nil;
    self.transactionCategorySplitViewController = nil;
    self.iAccountPickerViewController = nil;
    
    [self setAmountisLock];
    [self getDataSouce];
    [self setCustomerPick];
    
    if ([tranCategorySelectedArray count]>1)
    {
        self.recurringType = @"Never";
        recurringLabel.text = NSLocalizedString(@"VC_Never", nil);
    }
    [showCellTable reloadData];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
  
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void)refleshUI{
    if (self.transactionCategoryViewController != nil)
    {
        [self.transactionCategoryViewController refleshUI];
    }
    else if (self.transactionCategorySplitViewController != nil)
    {
        [self.transactionCategorySplitViewController refleshUI];
    }
    else if (self.iAccountPickerViewController != nil)
    {
        [self.iAccountPickerViewController refleshUI];
    }
    else{
        //获取account
        [self getDataSouce];
    }
    
}
#pragma mark viewDidLoad
-(void)initNavBarStyle
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [cancelBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelBtn.titleLabel setMinimumScaleFactor:0];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
     [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [doneBtn.titleLabel setMinimumScaleFactor:0];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn] ];

    
    UILabel *tileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [tileLabel  setTextAlignment:NSTextAlignmentCenter];
    [tileLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [tileLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    tileLabel.backgroundColor = [UIColor clearColor];
    if ([self.typeoftodo isEqualToString:@"ADD"]||[self.typeoftodo isEqualToString:@"IPAD_ADD"]) {
        tileLabel.text = NSLocalizedString(@"VC_NewTransaction_iPad", nil);
    }
    else{
        tileLabel.text = NSLocalizedString(@"VC_EditTransaction", nil);
    }
    self.navigationItem.titleView = tileLabel;
}


-(void)initPoint{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [display setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];

    payeText.placeholder = NSLocalizedString(@"VC_Payee", nil);
    cagetoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    accountLabelText.text = NSLocalizedString(@"VC_Account", nil);
    fromAccountLabelText.text = NSLocalizedString(@"VC_FromAccount", nil);
    toAccountLabelText.text = NSLocalizedString(@"VC_ToAccount", nil);
    dateLabelText.text = NSLocalizedString(@"VC_Date", nil);
    repeatLabelText.text = NSLocalizedString(@"VC_Repeat", nil);
    ClearedLabelText.text = NSLocalizedString(@"VC_Cleared", nil);
    photoLabelText.text = NSLocalizedString(@"VC_Photo", nil);
    showMoreLabelText.text = NSLocalizedString(@"VC_Show More Details", nil);
    
    [cagetoryLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [categoryLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
    [accountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [fromAccountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [toAccountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [dateLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [dateLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
    [repeatLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [recurringLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
    [ClearedLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [photoLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
        
    
    [display setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    
    firsttoBeHere = 0;
    
    showCellTable.delegate = self;
    
    outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];
    headerDateormatter = [[NSDateFormatter alloc]init];
    [headerDateormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    accountCell.textLabel.text =@"Account";
    fromAccountCell.textLabel.text = @"From Account";
    toAccountCell.textLabel.text = @"To Account";
    showMoreDetailsCell.textLabel.text = @"Show More";
	amountCell.textLabel.text =@"Amount";
	categoryCell.textLabel.text =@"Category";
	dateCell.textLabel.text =@"Date";
	recurringCell.textLabel.text =@"Recurring";
	noteCell.textLabel.text =@"Note";
	imageCell.textLabel.text =@"Image";
	payeeCell.textLabel.text =@"Payee";
	clearCell.textLabel.text =@"Clear";
    accountCell.textLabel.hidden = YES;
    
    //让首字母自动大写
    payeText.autocapitalizationType = UITextAutocapitalizationTypeWords;
    payeText.autocorrectionType = UITextAutocorrectionTypeNo;

	amountCell.textLabel.hidden = YES;
    fromAccountCell.textLabel.hidden = YES;
    toAccountCell.textLabel.hidden = YES;
    showMoreDetailsCell.textLabel.hidden = YES;
	categoryCell.textLabel.hidden = YES;
	dateCell.textLabel.hidden = YES;
	recurringCell.textLabel.hidden = YES;
	noteCell.textLabel.hidden = YES;
	imageCell.textLabel.hidden = YES;
	payeeCell.textLabel.hidden = YES;
 	clearCell.textLabel.hidden = YES;
    memoTextView.delegate = self;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
	self.documentsPath = [paths objectAtIndex:0];
    
    firsttoBeHere =0;
    payeeSearchView.hidden = YES;
    payeeSearchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_320_118.png"]];
    
  
    datePicker.backgroundColor = [UIColor whiteColor];
    
    payeeArray = [[NSMutableArray alloc]init];
    accountArray = [[NSMutableArray alloc]init];
    cycleTypeArray= [NSMutableArray arrayWithObjects:
 					  @"Never",@"Daily", @"Weekly",@"Every 2 Weeks",@"Every 3 Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every 4 Months",@"Every 5 Months",@"Every 6 Months",@"Every Year",nil] ;
    categoryArray = [[NSMutableArray alloc]init];
    pickItemArray = [[NSMutableArray alloc]init];
    tranCategorySelectedArray = [[NSMutableArray alloc]init];
    
    payeeSearchTable.delegate = self;
    payeeSearchTable.dataSource = self;
    
    [expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transferBtn addTarget:self action:@selector(transferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    
    bBegin= YES;
    backOpen = YES;
    isDotDown = NO;
    fstOperand = 0.00;
    currentNumber =0.00;
    arithmeticFlag = @"=";
    
    thisTransisBeenDelete = NO;
    
    [showCellTable reloadData];
 
    //获取category:expense income default;
    NSError *error =nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [categoryArray setArray:objects];

    
    
    for (Category *tmpCategory in categoryArray)
    {
        if([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"EXPENSE"])
        {
            self.otherCategory_expense = tmpCategory;
        }
        else if ([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"INCOME"])
        {
            self.otherCategory_income = tmpCategory;
        }
    }
    
    self.selectedRowIndexPath = nil;
    
    //xib种先设置个不是date made的，然后再用代码修改成date mode，就可以了
    datePicker.datePickerMode = UIDatePickerModeDate;
}

-(void)initContextShow{
    AppDelegate_iPad *appDelegate_iphone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    payeText.textColor = [appDelegate_iphone.epnc getAmountBlackColor];
    categoryLabel.textColor =[appDelegate_iphone.epnc getGrayColor_156_156_156];
    accountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    fromAccountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    toAccountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    recurringLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    //    memoLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
}
//获取account,获取Category
- (void)getDataSouce
{
    [accountArray removeAllObjects];
 	NSError *error =nil;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [accountArray setArray:objects];

    
    
    
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest1 setEntity:entity1];
    [fetchRequest1 setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors1 = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];
    
    [fetchRequest1 setSortDescriptors:sortDescriptors1];
    NSArray* objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest1 error:&error];
    [categoryArray setArray:objects1];

}

//获取所有的
-(void)initAllSplitCategoryMemory
{
    
    if([[transaction.childTransactions allObjects]count]>1 || [self.categories.categoryType isEqualToString:@"EXPENSE"])
    {
        if(tranExpCategorySelectArray == nil)
        {
            //获取所有的expense类型的category
            tranExpCategorySelectArray =[[NSMutableArray alloc] init];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys: [NSNull null],@"EMPTY" ,nil];
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchExpenseCategory" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
        
            
            //好委婉的方法，先获取所有的category,再获取当前trans下的所有子trans,判断这个子trans下的category,然后将这些子trans的category设置好，保存起来
            CategorySelect *cs;
            for (int i = 0; i<[tmpCategoryArray count]; i++)
            {
                cs = [[CategorySelect alloc] init];
                //获取第一个category
                cs.category = [tmpCategoryArray objectAtIndex:i];
                //判断这个category有没有被当前的 transaction选中
                Transaction *t = [self getTransactionByCategory:cs];
                if(t == nil)
                {
                    cs.amount = 0.0;
                    cs.isSelect = FALSE;
                    cs.memo =@"";
                    
                }
                else
                {
                    cs.isSelect = TRUE;
                    cs.amount = [t.amount doubleValue];
                    cs.memo =t.notes;
                    
                }
                [tranExpCategorySelectArray addObject:cs];
                
            }
        }
        else
        {
            [tranExpCategorySelectArray removeAllObjects];
            
            
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys: [NSNull null],@"EMPTY" ,nil];
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchExpenseCategory" substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
            CategorySelect *cs;
            for (int i = 0; i<[tmpCategoryArray count]; i++)
            {
                cs = [[CategorySelect alloc] init];
                cs.category = [tmpCategoryArray objectAtIndex:i];
                cs.isSelect = FALSE;
                cs.amount = 0.0;
                cs.memo =@"";
                [tranExpCategorySelectArray addObject:cs];
                
            }
        }
    }
}

-(void)setselectedSplitCategoryMemory
{
    if([[transaction.childTransactions allObjects]count]>1)
    {
        if(tranExpCategorySelectArray != nil)
        {
            if(tranCategorySelectedArray == nil)
                tranCategorySelectedArray = [[NSMutableArray alloc] init];
            else
                [tranCategorySelectedArray removeAllObjects];
            
            for (int i=0; i<[tranExpCategorySelectArray count]; i++)
            {
                CategorySelect *categoruSelect = (CategorySelect *)[tranExpCategorySelectArray objectAtIndex:i];
                if(categoruSelect.isSelect)
                {
                    CategorySelect *cs = [[CategorySelect alloc] init];
                    cs.category = categoruSelect.category;
                    cs.amount = categoruSelect.amount;
                    cs.isSelect = categoruSelect.isSelect;
                    cs.memo = categoruSelect.memo;
                    
                    [tranCategorySelectedArray addObject:cs];
                    
                }
            }
            
        }
        if([tranCategorySelectedArray count] == 1)
            self.categories = [((Transaction *)[tranCategorySelectedArray lastObject]) category];
        
    }
    else
    {
        //增添这一句来判断 否则在budget中新建 category是会让category成为nil的
        if (self.transaction != nil) {
            self.categories = self.transaction.category;
            
        }
        
    }
}
-(void)setControlShowTextWithTranscation
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if([self.typeoftodo isEqualToString:@"IPAD_EDIT"])
	{
        
        //payee
		self.payeText.text = self.transaction.payee.name;
        
        //category
        if (self.transaction.category != nil)
		{
			self.categories = self.transaction.category;
            categoryLabel.text = self.categories.categoryName;
            isSpliteTrans = NO;
		}
        else if ([self.transaction.childTransactions count]>0)
        {
            self.categories = nil;
            categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
            isSpliteTrans = YES;
        }
        //amount
        self.currentNumber = [self.transaction.amount doubleValue];
        
	 	self.display.text = [appDelegate.epnc formatterString:[self.transaction.amount doubleValue]];
        
		//date
        NSDate* date = self.transaction.dateTime;
        self.transactionDate = date;
		
        //expense,income,transfer btn
		//account
		if (self.transaction.expenseAccount != nil&&[self.transaction.category.categoryType isEqualToString:@"EXPENSE"])
		{
			self.accounts = self.transaction.expenseAccount;
            accountLabel.text = self.accounts.accName;
            
            expenseBtn.selected = YES;
            incomeBtn.selected = NO;
            transferBtn.selected = NO;
		}
		else if (self.transaction.incomeAccount != nil&&[self.transaction.category.categoryType isEqualToString:@"INCOME"])
		{
			self.accounts = self.transaction.incomeAccount;
            expenseBtn.selected = NO;
            incomeBtn.selected = YES;
            transferBtn.selected = NO;
		}
        else if ([self.transaction.childTransactions count]>0)
        {
            self.accounts = self.transaction.expenseAccount;
            expenseBtn.selected = YES;
            incomeBtn.selected = NO;
            transferBtn.selected = NO;
        }
        else
        {
            expenseBtn.selected = NO;
            incomeBtn.selected = NO;
            transferBtn.selected = YES;
            self.fromAccounts = self.transaction.expenseAccount;
            self.toAccounts = self.transaction.incomeAccount;
            fromAccountLabel.text = self.fromAccounts.accName;
            toAccountLabel.text = self.toAccounts.accName;
        }
        showMoreDetails = YES;
        
        //recurring
		self.recurringType = self.transaction.recurringType;
        
        //memo
        memoTextView.text = self.transaction.notes;
        
        //payee
        self.payees = self.transaction.payee;
        payeText.text = self.transaction.payee.name;
        //photo
        if (self.transaction.photoName != nil)
        {
            self.photosName = transaction.photoName;
			UIImage *selectedImage = [self imageByScalingAndCroppingForSize:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, transaction.photoName]] withTargetSize:CGSizeMake(40,40)];
	 		[self.phontoImageView setImage:selectedImage];
        }
        else
        {
            self.photosName=nil;
            self.phontoImageView.image = nil;
        }
        //cleared
        clearedSwitch.on = [self.transaction.isClear boolValue] ;
        
        [self.payeText resignFirstResponder];
        [memoTextView resignFirstResponder];
        
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationCurve:ANIMATIONCURVE];
        calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
        [UIView commitAnimations];
        
        
 	}
 	else
	{
        //account,btn
        if(!self.accounts)
        {
            BOOL foundDefaultAccount = NO;
            Accounts *tmpDefaultAccount = nil;
            for (int i=0; i<[accountArray count]; i++)
            {
                Accounts *oneAccount = [accountArray objectAtIndex:i];
                if ([oneAccount.others isEqualToString:@"Default"])
                {
                    tmpDefaultAccount = oneAccount;
                    foundDefaultAccount = YES;
                }
            }
            if (!foundDefaultAccount && [accountArray count]>0)
            {
                tmpDefaultAccount = [accountArray objectAtIndex:0];
            }
            if (tmpDefaultAccount)
            {
                self.accounts = tmpDefaultAccount;
            }

        }
        self.fromAccounts = nil;
        self.toAccounts = nil;
        
        expenseBtn.selected = YES;
        incomeBtn.selected = NO;
        transferBtn.selected = NO;
        showMoreDetails = NO;
        //category icon
        payeText.text = @"";
        //amount
        display.text = [appDelegate.epnc formatterString:0];
        isSpliteTrans = NO;
        //recurring
        self.recurringType = @"Never";
        //payee
        if(self.payees==nil )
        {
            self.payeText.text = @"";
        }

        //date
        if (self.transactionDate == nil)
        {
            self.transactionDate = [NSDate date];
        }
        //        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        //        NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.transactionDate];
        //        [parts1 setHour:0];
        //        [parts1 setMinute:0];
        //        [parts1 setSecond:0];
        //        self.transactionDate = [[NSCalendar currentCalendar] dateFromComponents:parts1];
        
        //photo
        self.photosName = nil;
        
        
        //cleared
        if (self.accounts != nil) {
            clearedSwitch.on = [self.accounts.autoClear boolValue];
        }
        else{
            clearedSwitch.on = YES;
        }
        
 	}
    
    if( self.accounts!=nil)
		self.accountLabel.text = self.accounts.accName;
    else
    {
        if ([accountArray count]>0) {
            self.accounts = [accountArray firstObject];
            self.accountLabel.text = self.accounts.accName;
            
        }
        else
            self.accountLabel.text = @"None";
        
    }

    
    //recurring
    self.recurringLabel.text = [appDelegate.epnc changeRecurringTexttoLocalLangue:self.recurringType];
    
    //date
    self.datePicker.date = self.transactionDate;
    
    
    //category icon
    if([self.typeoftodo isEqualToString:@"IPAD_EDIT"])
    {
        
        if ([[self.transaction.childTransactions allObjects] count] > 1)
        {
            categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
        }
        else
        {
            categoryLabel.text = self.transaction.category.categoryName;
        }
        
    }
    else
    {
        if(self.categories == nil)
        {
            if (expenseBtn.selected)
                self.categories = otherCategory_expense;
            
            else if (incomeBtn.selected)
                self.categories = otherCategory_income;
            else
                self.categories = nil;
        }
        categoryLabel.text = self.categories.categoryName;
    }
    
    //date
    self.dateLabel.text = [outputFormatter stringFromDate:self.transactionDate];
    
    //memo
    if ([memoTextView.text length]>0) {
        memoLabel.text = @"";
    }
    else
        memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    
    [showCellTable reloadData];
}

//设置默认的category NotSure
-(void)setDefaultAcc_Cate
{
    if ([self.typeoftodo isEqualToString:@"ADD"]){
        if(self.categories ==nil)
        {
            for (Category *tmpCategory in categoryArray)
            {
                if([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"EXPENSE"])
                {
                    self.categories = tmpCategory;
                    
                    break;
                }
            }
        }
        
    }
   
}

-(Transaction *)getTransactionByCategory:(CategorySelect *)c
{
    if(transaction == nil || [[transaction.childTransactions allObjects] count] <=0 )
        return nil;
    else
    {
        //获取当前编辑的trans下所有的子trans
        for (int i=0; i<[[transaction.childTransactions allObjects] count]; i++)
        {
            //获得子trans的和需要找的category相同的trans
            Transaction *t = [[transaction.childTransactions allObjects] objectAtIndex:i];
            if(c.category == t.category && [t.state isEqualToString:@"1"])
            {
                return t;
            }
        }
        return nil;
    }
    
    return nil;
}



-(void)setAmountisLock{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([tranCategorySelectedArray count]>1) {
        double totalAmount = 0.00;
        for (int i=0; i<[tranCategorySelectedArray count]; i++) {
            CategorySelect *oneCategory = [tranCategorySelectedArray objectAtIndex:i];
            totalAmount += oneCategory.amount;
        }
        currentNumber = totalAmount;
        isSpliteTrans = YES;
        display.text = [appDelegate.epnc formatterString:totalAmount];
        categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
    }
    else if([tranCategorySelectedArray count]==1)
    {
        double totalAmount = 0.00;
        for (int i=0; i<[tranCategorySelectedArray count]; i++) {
            CategorySelect *oneCategory = [tranCategorySelectedArray objectAtIndex:i];
            totalAmount += oneCategory.amount;
        }
        currentNumber = totalAmount;
        isSpliteTrans = YES;
        display.text = [appDelegate.epnc formatterString:totalAmount];
        self.categories = ((CategorySelect *)[tranCategorySelectedArray lastObject]).category;
        categoryLabel.text = self.categories.categoryName;
    }
    //    calculateView.hidden = YES;
    
    //    calculateView.frame = CGRectMake(0, self.view.frame.size.height-calculateView.frame.size.height, 320, calculateView.frame.size.height);
    
}
#pragma mark BtnAction
-(void)back:(id)sender{
    //搜索到以前的图片然后删除
    if (self.photosName != nil && [self.typeoftodo isEqualToString:@"IPAD_ADD"])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.photosName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }
    
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"] || [self.typeoftodo isEqualToString:@"IPAD_EDIT"])
    {
        if (_searchReleatedViewController != nil)
        {
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            [appDelegate_iPad.mainViewController.iAccountViewController reFleshTableViewData_withoutReset];
            [self.navigationController dismissViewControllerAnimated:YES completion:NO];
        }

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)save:(id)sender{
    
    
    //get all transaction
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchTransaction = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSError *error = nil;
    NSMutableArray *transactionArray =  [[NSMutableArray alloc]initWithArray:[appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchTransaction error:&error]];
    
    if (self.transaction != nil) {
        BOOL hasFound = NO;
        for (long i=0; i<[transactionArray count]; i++) {
            Transaction *oneTrans = [transactionArray objectAtIndex:i];
            if (oneTrans == self.transaction)
            {
                hasFound = YES;
                break;
            }
            
        }
        if (!hasFound)
        {
            AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            [appDelegate_iPad.mainViewController.iAccountViewController reFleshTableViewData_withoutReset];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }
    
    if (!isSpliteTrans) {
        [self inputDoubleOperator:@"="];
    }
    
    
//    if([payeText.text length] == 0)
//	{
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:@"Payee is required."
//														   delegate:self cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//        [alertView release];
//        
//		return;
//	}
    
	if([display.text length] == 0 ||  currentNumber  == 0.00)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Amount is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        
		return;
	}
    else if ((expenseBtn.selected || incomeBtn.selected)&&self.accounts == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Account is required.", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        
        return;
    }
    else if(self.fromAccounts == nil&& transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_From Account is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        
		return;
	}
	
	else if(self.toAccounts==nil&& transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_To Account is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        
		return;
	}
	else if(self.fromAccounts == self.toAccounts&& transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Accounts can not be same.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;
        
		return;
	}
    [self performSelector:@selector(saveAction) withObject:nil afterDelay:0.0];
}

-(void)saveAction
{
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"])
    {
        BOOL showRate = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERDONTSHOWAGAIN] boolValue];
        if (!showRate) {
            NSInteger integer = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERIMPORTANTEVENT] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:@(integer + 1) forKey:XDAPPIRATERIMPORTANTEVENT];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *errors;
	
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"])
    {
        if(!clearedSwitch.on)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_UNCL"];
        }
        if ([self.photosName length]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_PTO"];
        }
        if ([memoTextView.text length]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_MEMO"];
        }
        if ([tranCategorySelectedArray count]>1)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_SPLT"];
        }
        if (![self.recurringType isEqualToString:@"Never"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_RECR"];
            
            if ([self.recurringType isEqualToString:@"Daily"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_DLY"];
            }
            else if ([self.recurringType isEqualToString:@"Weekly"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_WKLY"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 2 Weeks"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2WK"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 3 Weeks"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3WK"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 4 Weeks"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4WK"];
                
            }
            else if ([self.recurringType isEqualToString:@"Semimonthly"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_SMMO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Monthly"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_MON"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 2 Months"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2MO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 3 Months"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3MO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 4 Months"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4MO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 5 Months"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_5MO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every 6 Months"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_6MO"];
                
            }
            else if ([self.recurringType isEqualToString:@"Every Year"])
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_YEAR"];
                
            }

        }
    }
    else
    {
        if(!clearedSwitch.on && [transaction.isClear boolValue])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_UNCL"];
        }
        if ([self.photosName length]>0 && !transaction.photoName)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_PTO"];
        }
        if ([memoTextView.text length]>0 && !transaction.notes)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_MEMO"];
        }
        if ([tranCategorySelectedArray count]>1 && [transaction.childTransactions  count]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_SPLT"];
        }
        if ([transaction.recurringType isEqualToString:@"Never"] && ![self.recurringType isEqualToString:@"Never"])
            
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_RECR"];
        }
        
        if ([self.recurringType isEqualToString:@"Daily"] && ![transaction.recurringType isEqualToString:@"Daily"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_DLY"];
        }
        
        if ([self.recurringType isEqualToString:@"Weekly"]  && ![transaction.recurringType isEqualToString:@"Weekly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_WKLY"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 2 Weeks"] && ![transaction.recurringType isEqualToString:@"Every 2 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 3 Weeks"] && ![transaction.recurringType isEqualToString:@"Every 3 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 4 Weeks"] && ![transaction.recurringType isEqualToString:@"Every 4 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Semimonthly"] && ![transaction.recurringType isEqualToString:@"Semimonthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_SMMO"];
        }
        
        if ([self.recurringType isEqualToString:@"Monthly"] && ![transaction.recurringType isEqualToString:@"Monthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_MON"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 2 Months"] && ![transaction.recurringType isEqualToString:@"Every 2 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 3 Months"] && ![transaction.recurringType isEqualToString:@"Every 3 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 4 Months"] && ![transaction.recurringType isEqualToString:@"Every 4 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 5 Months"] && ![transaction.recurringType isEqualToString:@"Every 5 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_5MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 6 Months"] && ![transaction.recurringType isEqualToString:@"Every 6 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_6MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every Year"] && ![transaction.recurringType isEqualToString:@"Every Year"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_YEAR"];
        }

    }

    
    //date
 	if(self.transaction == nil || thisTransisBeenDelete)
 	{
		self.transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
		unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        
		NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
		NSDateComponents*parts1 =[[NSCalendar currentCalendar] components:flags fromDate:self.transactionDate];
		[parts1 setHour:[cmpday1 hour]];
		[parts1 setMinute:[cmpday1 minute]];
		[parts1 setSecond:[cmpday1 second]];
		self.transaction.dateTime = [[NSCalendar currentCalendar] dateFromComponents:parts1];
	}
	else
    {
		self.transaction.dateTime = self.transactionDate;
	}
    
    self.transaction.dateTime_sync = [NSDate date];
    self.transaction.state = @"1";
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"]) {
        self.transaction.uuid = [EPNormalClass GetUUID];
    }
    
    
    //amount
	self.transaction.amount =  [NSNumber numberWithDouble: fabs(currentNumber)];
    
  	//photo
    self.transaction.photoName = self.photosName;
    
    //memo
	self.transaction.notes = memoTextView.text;
	
    //如果一个交易开始是splite类型那么它永远都是splite类型了
    //    if ([tranCategorySelectedArray count]==1) {
    //        CategorySelect *onecs = [tranCategorySelectedArray lastObject];
    //        self.categories = onecs.category;
    //    }
    if([self.categories.categoryType isEqualToString:@"INCOME"])//Income
	{
        if(self.categories !=nil&&[tranCategorySelectedArray count]<=1)
            transaction.category = self.categories;
        else
        {
            transaction.category =nil;
        }
   	 	transaction.transactionType = @"income";
		transaction.incomeAccount = self.accounts;
		transaction.expenseAccount = nil;
        transaction.isClear = self.accounts.autoClear;
 	}
	else if([self.categories.categoryType isEqualToString:@"EXPENSE"] &&[tranCategorySelectedArray count]<=1)//Spent
	{
        if(self.categories !=nil&&[tranCategorySelectedArray count]<=1)
            transaction.category = self.categories;
        else
        {
            transaction.category =nil;
        }
        transaction.transactionType = @"expense";
		transaction.expenseAccount = self.accounts;
		transaction.incomeAccount = nil;
        transaction.isClear = self.accounts.autoClear;
        
	}
    else if ([tranCategorySelectedArray count]>1){
        transaction.transactionType = @"expense";
        transaction.expenseAccount = self.accounts;
		transaction.incomeAccount = nil;
        transaction.isClear = self.accounts.autoClear;
    }
	else
    {
        transaction.category =nil;
        transaction.transactionType = @"transfer";
		transaction.expenseAccount = self.fromAccounts;
		transaction.incomeAccount = self.toAccounts;
        transaction.isClear = self.fromAccounts.autoClear;
	}
    
    //cleared
    transaction.isClear =[NSNumber numberWithBool:clearedSwitch.on];
    //recurring
    transaction.recurringType =  self.recurringType;
    //category
    if( self.categories !=nil&&[tranCategorySelectedArray count]<=1)
        self.categories.others = @"HASUSE";
    
    if( self.categories !=nil&&[tranCategorySelectedArray count]<=1)
    {
        [self.categories addTransactionsObject:transaction];
    }
    
    
    
    
    
    
    
    /* --------HMJ if this is a new payee then inset it-------------*/
    if([payeText.text length]>0)
    {
        NSError *errors;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
        [fetchRequest setPredicate:predicate];
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray* objects =[[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors]];
        
    
        BOOL hasFound = FALSE;
        
        //这样判断的话，当splite类型的交易就会有问题
        for (Payee *tmpPayee in objects)
        {
            
            
            if (!transferBtn.selected)
            {
                if([tmpPayee.name isEqualToString:payeText.text] && tmpPayee.category == self.categories)
                {
                    hasFound = TRUE;
                    self.payees = tmpPayee;
                    break;
                }
            }
            else
            {
                if([tmpPayee.name isEqualToString:payeText.text])
                {
                    hasFound = TRUE;
                    self.payees = tmpPayee;
                    break;
                }
            }
        }
        if(!hasFound )
        {
            AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            self.payees = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
            self.payees.name = payeText.text;
            
//            self.payees.memo = memoTextView.text;
            
            if(self.categories!=nil && [self.categories.categoryType isEqualToString:@"INCOME"])//Income
            {
                self.payees.category = self.categories;
                self.payees.tranType = @"income";
            }
            else if(self.categories!=nil && [self.categories.categoryType isEqualToString:@"EXPENSE"])//Spent
            {
                self.payees.category = self.categories;
                self.payees.tranType = @"expense";
            }
            else
            {
                self.payees.category =otherCategory_expense;
                self.payees.tranType = @"transfer";
            }
            
            self.payees.dateTime = [NSDate date];
            self.payees.state = @"1";
            self.payees.uuid =[EPNormalClass GetUUID];
            
            if (![appDelegate.managedObjectContext save:&errors]) {
                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                
            }
//            AppDelegate_iPad *appDelegaet_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//            if (appDelegaet_iPhone.dropbox.drop_account.linked) {
//                [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.payees];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:self.payees];
            }
        }
        transaction.payee = self.payees;

    }
    else
        self.transaction.payee = nil;
    
    
    
    
    //如果这个transaction有子 trans,就需要删掉旗下的所有子,方便重新建立交易。 当建立了一个多category的trans的时候，不仅要建立每个category下的交易，还需要建立一个总的交易，这个总的交易就是parTran，旗下所有的子category建立的交易就是childCategory
    if ([transaction.childTransactions count] > 0)
    {
        //save local transaction
        for (Transaction *tran in [transaction.childTransactions allObjects]) {
            tran.state=@"0";
            NSError *error;
            [appDelegate.managedObjectContext save:&error];
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:tran];
            }
//            [appDelegate_iPhone.managedObjectContext deleteObject:tran];
        }
        if (![context save:&errors]) {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
            
        }
    }
    
    
    
    
    //如果这个trans是非循环，并且是 income 或者 expense类型的
    if([tranCategorySelectedArray count] > 1 ){
        self.recurringType = @"Never";
        transaction.recurringType = @"Never";
    }
    
    [appDelegate.managedObjectContext save:&errors];

    //自动插入交易
    if(![self.recurringType isEqualToString:@"Never"])
        [appDelegate.epdc autoInsertTransaction:transaction];
    //sync要先上传父类
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:self.transaction];
//        
//    }
    
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:self.transaction];
    }
    
    if( [self.recurringType isEqualToString:@"Never"])
    {
        //如果是多选category
        if([tranCategorySelectedArray count] > 1 )
        {
            //加sprit
            double totalAmount;
            for (int i=0; i<[tranCategorySelectedArray count]; i++)
            {
                CategorySelect *categoruSelect = (CategorySelect *)[tranCategorySelectedArray objectAtIndex:i];
                {
                    totalAmount +=categoruSelect.amount;
//                    transaction.notes = categoruSelect.memo;
                    
                    //建立单个category对应的trans,就是childTransaction
                    Transaction *childTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
                    
                    /*--------配置 childTransaction的所有信息-----*/
                    childTransaction.dateTime = self.transaction.dateTime;
                    childTransaction.amount = [NSNumber numberWithDouble:categoruSelect.amount];
                    //在添加子category的时候，将note也保存进来
//                    childTransaction.notes=categoruSelect.memo;
                    childTransaction.category = categoruSelect.category;
                    if([categoruSelect.category.categoryType isEqualToString:@"INCOME"])
                    {
                        childTransaction.incomeAccount = self.accounts;
                        childTransaction.expenseAccount = nil;
                        
                    }
                    else if([categoruSelect.category.categoryType isEqualToString:@"EXPENSE"])                    {
                        childTransaction.expenseAccount = self.accounts;
                        childTransaction.incomeAccount = nil;
                    }
                    childTransaction.isClear = [NSNumber numberWithBool:YES];
                    childTransaction.recurringType = @"Never";
                    
                    if(categoruSelect.category!=nil)
                        categoruSelect.category.others = @"HASUSE";
                    childTransaction.payee =self.payees;
                    
                    childTransaction.dateTime_sync = [NSDate date];
                    childTransaction.state = @"1";
                    childTransaction.uuid = [EPNormalClass GetUUID];
                    
                    if(categoruSelect.category!=nil)
                    {
                        //给当前的这个category下增加一个交易，添加关系而已
                        [categoruSelect.category addTransactionsObject:childTransaction];
                    }
                    //给当前这个 transaction 添加 childtransaction关系
                    [transaction addChildTransactionsObject:childTransaction];
                    
                    if (![appDelegate.managedObjectContext save:&errors]) {
                        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                        
                    }
                    //sync
//                    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                        [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:childTransaction];
//                    }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateTransactionFromLocal:childTransaction];
                    }
                }
            }
        }
    }
    
    

    

    [appDelegate_iPhone.epdc saveTransaction:self.transaction];
    
    
    
    if(appDelegate_iPhone.mainViewController.currentViewSelect==0)
    {
        [appDelegate_iPhone.mainViewController.overViewController refleshData];
    }
    else if(appDelegate_iPhone.mainViewController.currentViewSelect==1)
        [appDelegate_iPhone.mainViewController.iAccountViewController reFleshTableViewData_withoutReset];
    else if (appDelegate_iPhone.mainViewController.currentViewSelect==2)
        [appDelegate_iPhone.mainViewController.iBudgetViewController reFlashTableViewData];
    else if (appDelegate_iPhone.mainViewController.currentViewSelect==3)
        [appDelegate_iPhone.mainViewController.iReportRootViewController reFlashTableViewData];

    
    appDelegate.pvt  = nonePopup;
    
    
    if([self.typeoftodo isEqualToString:@"IPAD_ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_ADD"];
        if (expenseBtn.selected)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_EXP"];
        }
        else if (transferBtn.selected)
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_TSF"];
        else
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_INC"];
    }
    
    if ([self.typeoftodo isEqualToString:@"IPAD_ADD"] || [self.typeoftodo isEqualToString:@"IPAD_EDIT"]) {
        if (appDelegate_iPhone.mainViewController.currentViewSelect==0) {
            [appDelegate_iPhone.mainViewController.overViewController refleshData];
        }
        else if(appDelegate_iPhone.mainViewController.currentViewSelect==2){
            [appDelegate_iPhone.mainViewController.iBudgetViewController reFlashTableViewData];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];


    //插页广告
    AppDelegate_iPad* appDelegate_ipad = (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        [self.interstitial showInterstitialAdWithTarget:appDelegate_ipad.mainViewController];
    }
    if ([[XDPlanControlClass shareControlClass] everyDayShowOnce]) {
        if ([XDPlanControlClass shareControlClass].planType == ChristmasPlanA) {
            
            self.planA = [[XDChristmasPlanAPopViewController alloc]initWithNibName:@"XDChristmasPlanAPopViewController" bundle:nil];
            self.planA.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.planA show];
            
            [self.planA.getNowBtn addTarget:self action:@selector(christmasPopViewGetNowClick) forControlEvents:UIControlEventTouchUpInside];
            [self.planA.cancelBtn addTarget:self action:@selector(dismissPopView) forControlEvents:UIControlEventTouchUpInside];
            [appDelegate_ipad.mainViewController.view addSubview:self.planA.view];
            
        }else{
            
            self.planB = [[XDChristmasPlanBPopViewController alloc]initWithNibName:@"XDChristmasPlanBPopViewController" bundle:nil];
            self.planB.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.planB show];
            
            [self.planB.openBtn addTarget:self action:@selector(bchristmasPopViewGetNowClick) forControlEvents:UIControlEventTouchUpInside];
            [self.planB.cancelBtn addTarget:self action:@selector(bdismissPopView) forControlEvents:UIControlEventTouchUpInside];
            [appDelegate_ipad.mainViewController.view addSubview:self.planB.view];
            
        }
    }
  
}


-(void)christmasPopViewGetNowClick{
    [self.planA dismiss];
    AppDelegate_iPad* appDelegate_ipad = (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];

//    XDIpad_ADSViewController* adsDetailViewController = [[XDIpad_ADSViewController alloc]initWithNibName:@"XDIpad_ADSViewController" bundle:nil];
//    //        adsDetailViewController.isComeFromSetting = NO;
//    //        adsDetailViewController.pageNum = i;
//    //        adsDetailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
////    adsDetailViewController.xxdDelegate = self;
//    adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    adsDetailViewController.preferredContentSize = CGSizeMake(375, 667);
//
//    adsDetailViewController.view.superview.autoresizingMask =
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
//    [appDelegate_ipad.mainViewController presentViewController:adsDetailViewController animated:YES completion:nil];
    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;
    
    if(subPlan == ChristmasSubPlana){
        
        //        [FIRAnalytics logEventWithName:@"christmas_A_banner_B_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        XDChristmasLitePlanAViewController* christmas = [[XDChristmasLitePlanAViewController alloc]initWithNibName:@"XDChristmasLitePlanAViewController" bundle:nil];
        
        christmas.modalPresentationStyle = UIModalPresentationFormSheet;
        christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        christmas.preferredContentSize = CGSizeMake(375, 667);
        [appDelegate_ipad.mainViewController presentViewController:christmas animated:YES completion:nil];
        
        
    }else if (subPlan == ChristmasSubPlanb){
        //        [FIRAnalytics logEventWithName:@"christmas_A_banner_b_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        XDChristmasPlanAbViewController* christmas = [[XDChristmasPlanAbViewController alloc]initWithNibName:@"XDChristmasPlanAbViewController" bundle:nil];
        
        christmas.modalPresentationStyle = UIModalPresentationFormSheet;
        christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        christmas.preferredContentSize = CGSizeMake(375, 667);
        [appDelegate_ipad.mainViewController presentViewController:christmas animated:YES completion:nil];
    }
    
    [FIRAnalytics logEventWithName:@"christmas_popup_A_getNow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    
}
-(void)dismissPopView{
    [self.planA dismiss];
    
    [FIRAnalytics logEventWithName:@"christmas_popup_A_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    
}


-(void)bchristmasPopViewGetNowClick{
    [self.planB dismiss];
//    XDIpad_ADSViewController* adsDetailViewController = [[XDIpad_ADSViewController alloc]initWithNibName:@"XDIpad_ADSViewController" bundle:nil];
    //        adsDetailViewController.isComeFromSetting = NO;
    //        adsDetailViewController.pageNum = i;
    //        adsDetailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    adsDetailViewController.xxdDelegate = self;
//    adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    adsDetailViewController.preferredContentSize = CGSizeMake(375, 667);
//
//    adsDetailViewController.view.superview.autoresizingMask =
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
//    AppDelegate_iPad* appDelegate_ipad = (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];
//
//    [appDelegate_ipad.mainViewController presentViewController:adsDetailViewController animated:YES completion:nil];
    AppDelegate_iPad* appDelegate_ipad = (AppDelegate_iPad*)[[UIApplication sharedApplication] delegate];

    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;
    
    if(subPlan == ChristmasSubPlana){
        //        [FIRAnalytics logEventWithName:@"christmas_a_banner_B_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        XDChristmasLiteOneViewController* christmas = [[XDChristmasLiteOneViewController alloc]initWithNibName:@"XDChristmasLiteOneViewController" bundle:nil];
        
        christmas.modalPresentationStyle = UIModalPresentationFormSheet;
        christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        christmas.preferredContentSize = CGSizeMake(375, 667);
        [appDelegate_ipad.mainViewController presentViewController:christmas animated:YES completion:nil];
        
    }else if(subPlan == ChristmasSubPlanb){
        //        [FIRAnalytics logEventWithName:@"christmas_a_banner_b_open" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
        
        XDChristmasPlanBbViewController* christmas = [[XDChristmasPlanBbViewController alloc]initWithNibName:@"XDChristmasPlanBbViewController" bundle:nil];
        
        christmas.modalPresentationStyle = UIModalPresentationFormSheet;
        christmas.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        christmas.preferredContentSize = CGSizeMake(375, 667);
        [appDelegate_ipad.mainViewController presentViewController:christmas animated:YES completion:nil];
        
    }
    
    [FIRAnalytics logEventWithName:@"christmas_popup_a_getNow" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    
    
}
-(void)bdismissPopView{
    [self.planB dismiss];
    
    [FIRAnalytics logEventWithName:@"christmas_popup_a_cancel" parameters:@{@"user":[PFUser currentUser].objectId,@"isChristmasNewUser":[XDPlanControlClass shareControlClass].isChristmasNewUser}];
    
}


-(void)btnAmountAction:(id)sender
{
    [self.payeText resignFirstResponder];
    [memoTextView resignFirstResponder];
    
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
    calculateView.frame = CGRectMake(0, self.view.frame.size.height-calculateView.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
    [UIView commitAnimations];
}

-(void)expenseBtnPressed:(UIButton *)sender
{
    expenseBtn.selected = YES;
    incomeBtn.selected = NO;
    transferBtn.selected = NO;
    
    
    if(![self.categories.categoryType isEqualToString:@"EXPENSE"])
    {
        self.categories = otherCategory_expense;
        categoryLabel.text = self.categories.categoryName;
    }
    
    [showCellTable reloadData];
}

-(void)incomeBtnPressed:(UIButton *)sender
{
    expenseBtn.selected = NO;
    incomeBtn.selected = YES;
    transferBtn.selected = NO;
    if(![self.categories.categoryType isEqualToString:@"INCOME"])
    {
        self.categories = otherCategory_income;
        categoryLabel.text = self.categories.categoryName;
    }
    [showCellTable reloadData];

}

-(void)transferBtnPressed:(UIButton *)sender
{
    expenseBtn.selected = NO;
    incomeBtn.selected = NO;
    transferBtn.selected = YES;
    self.categories =  nil;
    categoryLabel.text = self.categories.categoryName;
    [showCellTable reloadData];

}


#pragma mark datePicker event
-(void)dateSelected  //如果不选择 则默认当天日期
{
 	self.transactionDate = self.datePicker.date;
    dateLabel.text = [outputFormatter stringFromDate:datePicker.date];
    sectionHeaderLabel.text = [headerDateormatter  stringFromDate:self.datePicker.date];
}


#pragma mark HMJPickerViewDelegate
-(void)toolBtnPressed{
//    AccountEditViewController *accountEditViewController = [[AccountEditViewController alloc]initWithNibName:@"AccountEditViewController" bundle:nil];
//    accountEditViewController.typeOftodo = @"ADD";
//    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:accountEditViewController];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//    [nav release];
//    [accountEditViewController release];
}

-(void)btnClearedAction:(id)sender{
    clearedSwitch.on = !clearedSwitch.on;
}


- (void) setCustomerPick
{
	[self.pickItemArray removeAllObjects];
    
 	if (picktype == 3)
	{
		for (int i=0; i < [cycleTypeArray count]; i++)
		{
			[self.pickItemArray addObject:[cycleTypeArray objectAtIndex:i]];
		}
	}
}
#pragma mark TextView Delegate
-(IBAction)payeeTextEditChange:(id)sender
{
    [self deleteDatePickerCell];
    if([self.payeText.text length]>0)
    {
        [self getPayeeSearchDataSource];
        
    }
    else
        self.payeeSearchView.hidden = YES;}

-(void)getPayeeSearchDataSource
{
    NSString *text = self.payeText.text;
    [payeeArray removeAllObjects];
    if([text length]!=0)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSError * error=nil;
        NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"name beginswith[c] %@ && state contains[c] %@", text,@"1"];
        [fetchRequest setPredicate:predicate];
 	 	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // genehrate a description that describe which field you want to sort by
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [payeeArray setArray:objects ];
  	
    }
    [self.payeeSearchTable reloadData];
    if([payeeArray count] == 0)
    {
        self.payeeSearchView.hidden = YES;
        
    }
    else {
        float payeeHigh = showCellTable.contentOffset.y;
        self.payeeSearchView.frame = CGRectMake(0, 78, calculateView.frame.size.width, self.payeeSearchView.frame.size.height);
        
        if (payeeHigh!=0)
            self.payeeSearchView.frame = CGRectMake(0, self.payeeSearchView.frame.origin.y-payeeHigh, calculateView.frame.size.width, self.payeeSearchView.frame.size.height);
        
        self.payeeSearchView.hidden = NO;
        
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
//    memoTextView.text =  textView.text;
    if (textView.text.length == 0) {
        memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    }else{
        memoLabel.text = @"";
    }
}

#pragma mark textField delegate
-(IBAction)TextFieldDidBeginEditing:(UITextField *)textField{
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
    calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
    [UIView commitAnimations];

}

-(IBAction)TextDidEnd:(UITextField *)textField
{
    if (textField == payeText) {
        self.payeeString = payeText.text;
    }
    [self inputDoubleOperator:@"="];
}




//---UITextField 当没点击cell点击的是cell中的UITextField的时候，设置当前点击的属于哪个cell
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
//    [self deleteDatePickerCell];
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] <8) {
        hight = showCellTable.frame.size.height-textView.superview.superview.superview.frame.origin.y-textView.frame.size.height;
    }
    else
        hight =showCellTable.frame.size.height-textView.superview.superview.frame.origin.y-textView.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh = 216-hight+35;
        NSLog(@"keyBoardHigh:%f",keyBoardHigh);
        [showCellTable setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
    }
    
}


#pragma mark - tableview delegate
- (void)configureSearchPayeeCell:(ipad_PayeeSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Payee *searchPayee = (Payee *)[payeeArray objectAtIndex:indexPath.row];
    cell.payeeLabel.text = searchPayee.name;
    cell.categoryLabel.text = searchPayee.category.categoryName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==payeeSearchTable) {
        return 1;
    }
    else
    {
        if (showMoreDetails)
        {
            return 4;
        }
        else
            return 2;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==payeeSearchTable) {
        return 0;
    }
    else{
        if (section==0) {
            return 36.f;
        }
        else
            return 25.f;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (showMoreDetails) {
        if (section==3) {
            return 17.5;
        }
        else
            return 0;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	if (tableView==payeeSearchTable)
    {
        return 40.0;
    }
    if (showMoreDetails && indexPath.section == 3 && indexPath.row == 1) {
        return 182;
    }
    //如果选中的是日期这个cell就需要刷新这个cell的高度，如果再次选中这个cell就取消选中这个cell
    else if (self.selectedRowIndexPath.section==1&&self.selectedRowIndexPath.row==2 && indexPath.section==1 && indexPath.row==3)
        return 216;
    else
        return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == showCellTable) {
        if (section==0) {
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, calculateView.frame.size.width, 35)];
            sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, calculateView.frame.size.width-15, 35)];
            NSString *tmpString = [headerDateormatter stringFromDate:self.transactionDate];
            sectionHeaderLabel.text = [tmpString uppercaseString];;
            [sectionHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
            [sectionHeaderLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1.f]];
            [sectionHeaderLabel setBackgroundColor:[UIColor clearColor]];
            sectionHeaderLabel.textAlignment = NSTextAlignmentLeft;
            [headview addSubview:sectionHeaderLabel];
            return headview;
        }
        else
            return nil;
    }
    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==payeeSearchTable) {
        return [payeeArray count];
    }
    
    
    if (section==0) {
        return 2;
    }
    else if (section==1)
    {
        if (showCellTable && self.selectedRowIndexPath.section==1 && self.selectedRowIndexPath.row==2)
        {
            return 4;
        }
        else
            return 3;
        
    }
    if (section==2)
    {
        if ([tranCategorySelectedArray count]>1)
        {
            return 1;
        }
        else
            return 2;
    }
    else
        return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==payeeSearchTable)
    {
        static NSString *CellIdentifier = @"Cell";
        ipad_PayeeSearchCell *cell = (ipad_PayeeSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ipad_PayeeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;//
            
        }
        
        [self configureSearchPayeeCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    else
    {
        //transaction edit cell
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                return payeeCell;
            }
            else
                return amountCell;
        }
        else if (indexPath.section==1)
        {
            if (!showMoreDetails)
            {
                if (expenseBtn.selected || incomeBtn.selected)
                {
                    if (indexPath.row==0)
                    {
                        return categoryCell;
                    }
                    else if(indexPath.row==1)
                        return accountCell;
                    else
                        return showMoreDetailsCell;
                }
                else
                {
                    if (indexPath.row==0)
                    {
                        return fromAccountCell;
                    }
                    else if(indexPath.row==1)
                        return toAccountCell;
                    else
                        return showMoreDetailsCell;
                }
                
            }
            else
            {
                if (expenseBtn.selected || incomeBtn.selected)
                {
                    if (indexPath.row==0)
                    {
                        return categoryCell;
                    }
                    else if(indexPath.row==1)
                        return accountCell;
                    else if(indexPath.row==2)
                        return dateCell;
                    else
                        return datePickerCell;
                }
                else
                {
                    if (indexPath.row==0)
                    {
                        return fromAccountCell;
                    }
                    else if(indexPath.row==1)
                        return toAccountCell;
                    else if(indexPath.row==2)
                        return dateCell;
                    else
                        return datePickerCell;
                }
                
                
            }
        }
        else if (indexPath.section==2)
        {
            if ([tranCategorySelectedArray count]>1)
            {
                if (indexPath.row==0)
                {
                    return clearCell;
                }
            }
            else
            {
                if (indexPath.row==1)
                {
                    return clearCell;
                }
                else
                    return recurringCell;
            }
            
        }
        if (indexPath.row==0)
        {
            return imageCell;
        }
        else
            return noteCell;

    }
    
    
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==payeeSearchTable)
    {
        self.payees=  (Payee *)[payeeArray objectAtIndex:indexPath.row] ;
        
        [self setControlValueByPayee];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.payeeSearchView.hidden = YES;
        
        [payeText resignFirstResponder];
        [memoTextView resignFirstResponder];
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationCurve:ANIMATIONCURVE];
        calculateView.frame = CGRectMake(0, self.view.frame.size.height-calculateView.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([checkedCell.textLabel.text isEqualToString:@"Date"] && self.selectedRowIndexPath==nil)
        {
            self.selectedRowIndexPath = indexPath;
        }
        else
            self.selectedRowIndexPath = nil;
        if([checkedCell.textLabel.text isEqualToString:@"Amount"])
        {
            [payeText resignFirstResponder];
            [memoTextView resignFirstResponder];
            
            if ([self.tranCategorySelectedArray count]<=0)
            {
                [UIView  beginAnimations:nil context:nil];
                [UIView setAnimationCurve:ANIMATIONCURVE];
                calculateView.frame = CGRectMake(0, self.view.frame.size.height - calculateView.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
                [UIView commitAnimations];
            }
            else
            {
                [UIView  beginAnimations:nil context:nil];
                [UIView setAnimationCurve:ANIMATIONCURVE];
                calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
                [UIView commitAnimations];
            }
            
//            [showCellTable reloadData];

        }
        else if([checkedCell.textLabel.text isEqualToString:@"Account"])
        {
            [self hideAllTabPop];
            
            
            self.iAccountPickerViewController = [[ipad_AccountPickerViewController alloc]initWithNibName:@"ipad_AccountPickerViewController" bundle:nil];
            if (self.accounts != nil)
            {
                self.iAccountPickerViewController.selectedAccount = self.accounts;
            }
            self.iAccountPickerViewController.accountType = 0;
            self.iAccountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.iAccountPickerViewController animated:YES];

        }
        else if([checkedCell.textLabel.text isEqualToString:@"From Account"])
        {
            [self hideAllTabPop];
            
            self.iAccountPickerViewController = [[ipad_AccountPickerViewController alloc]initWithNibName:@"ipad_AccountPickerViewController" bundle:nil];
            if (self.fromAccounts != nil)
            {
                self.iAccountPickerViewController.selectedAccount = self.fromAccounts;
            }
            self.iAccountPickerViewController.accountType = 1;
            self.iAccountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.iAccountPickerViewController animated:YES];
            
        }
        else if([checkedCell.textLabel.text isEqualToString:@"To Account"])
        {
            [self hideAllTabPop];
            
            self.iAccountPickerViewController = [[ipad_AccountPickerViewController alloc]initWithNibName:@"ipad_AccountPickerViewController" bundle:nil];
            if (self.fromAccounts != nil)
            {
                self.iAccountPickerViewController.selectedAccount = self.toAccounts;
            }
            self.iAccountPickerViewController.accountType = 2;
            self.iAccountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.iAccountPickerViewController animated:YES];
        }

        else if([checkedCell.textLabel.text isEqualToString:@"Category"])
        {
            [self hideAllTabPop];
            
            if([tranCategorySelectedArray count] >1 /*|| [transaction.childTransactions count]>1*/)
            {
                self.transactionCategorySplitViewController= [[ipad_TransacationSplitViewController alloc]initWithNibName:@"ipad_TransacationSplitViewController" bundle:nil];
                transactionCategorySplitViewController.iTransactionEditViewController = self;
                [self.navigationController pushViewController:transactionCategorySplitViewController animated:YES];
                
            }
            else
            {
                self.transactionCategoryViewController= [[ipad_TranscationCategorySelectViewController alloc]initWithNibName:@"ipad_TranscationCategorySelectViewController" bundle:nil];
                transactionCategoryViewController.transactionEditViewController = self;
                
                [self.navigationController pushViewController:transactionCategoryViewController animated:YES];
            }
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Show More"])
        {
            [self hideAllTabPop];
            
            showMoreDetails = YES;
            
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            
            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)];
            [showCellTable beginUpdates];
            [showCellTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [showCellTable insertSections:sections withRowAnimation:UITableViewRowAnimationBottom];
            [showCellTable endUpdates];
        }
     
        else 	if ([checkedCell.textLabel.text isEqualToString:@"Date"])
        {
            [self.payeText resignFirstResponder];
            [memoTextView resignFirstResponder];
            self.datePicker.date = self.transactionDate;
            
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
            calculateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, calculateView.frame.size.height);
            [UIView commitAnimations];
            
//            [showCellTable reloadData];

        }
        else 	if ([checkedCell.textLabel.text isEqualToString:@"Recurring"])
        {
            ipad_TransactionRecurringViewController *transactionRecurringViewController = [[ipad_TransactionRecurringViewController alloc]initWithNibName:@"ipad_TransactionRecurringViewController" bundle:nil];
            transactionRecurringViewController.recurringType = self.recurringType;
            transactionRecurringViewController.itransactionEditViewController = self;
            [self.navigationController pushViewController:transactionRecurringViewController animated:YES];
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Payee"])
        {
            [payeText becomeFirstResponder];
            
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
            calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
            [UIView commitAnimations];
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Note"])
        {
            [self.payeText resignFirstResponder];
            [memoTextView becomeFirstResponder];
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
            calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
            [UIView commitAnimations];
        }
        else if([checkedCell.textLabel.text isEqualToString:@"Image"])
        {
            
            
            [self.payeText resignFirstResponder];
            [memoTextView resignFirstResponder];
            
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
            calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
            [UIView commitAnimations];
            
            
            
            if ( ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) &&  self.photosName==nil)
            {
                UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                             initWithTitle:nil
                                             delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                             destructiveButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"VC_Photo from Camera", nil),NSLocalizedString(@"VC_Photo from Library", nil),
                                             nil];
                actionSheet.tag = 0;
                
                UITableViewCell *selectedCell = [showCellTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                CGPoint point1 = [showCellTable convertPoint:selectedCell.frame.origin toView:self.view];
                [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view
                                 animated:YES];
                
                PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
                appDelegate.appActionSheet = actionSheet;
            }
            else if(self.photosName == nil)
            {
                UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                             initWithTitle:nil
                                             delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                             destructiveButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"VC_Photo from Library", nil),
                                             nil];
                actionSheet.tag = 1;
                
                UITableViewCell *selectedCell = [showCellTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                CGPoint point1 = [showCellTable convertPoint:selectedCell.frame.origin toView:self.view];
                [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view
                                 animated:YES];
                
                PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
                appDelegate.appActionSheet = actionSheet;
            }
            else if(self.photosName !=nil)
            {
                ipad_SelectImageViewController *selectImageViewController = [[ipad_SelectImageViewController alloc] initWithNibName:@"ipad_SelectImageViewController" bundle:nil];
                selectImageViewController.documentsPath = self.documentsPath ;
                selectImageViewController.imageName = self.photosName ;;
                selectImageViewController.iTransactionEditViewController  = self;
                [self.navigationController pushViewController:selectImageViewController animated:YES];
            }
            
        }
        
        [self insertorDelegateDatePickerCell];

    }
    
    
}

-(void)deleteDatePickerCell
{
    self.selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (self.selectedRowIndexPath.section==1 && self.selectedRowIndexPath.row==2)
    {
        if ([showCellTable numberOfRowsInSection:1]==3)
        {
            [showCellTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else
    {
        if ([showCellTable numberOfRowsInSection:1]==4) {
            [showCellTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}


-(void)hideAllTabPop{
    [self.payeText resignFirstResponder];
    payeeSearchView.hidden = YES;
    [memoTextView resignFirstResponder];
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
    calculateView.frame = CGRectMake(0, self.view.frame.size.height, calculateView.frame.size.width, calculateView.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)setScrollViewOffSetByTableView:(UITableView *)tableView withRow:(NSInteger)r
{
	if(r>3)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
        
		[UIView commitAnimations];
		
	}
}

//payee只修改 category和memo两项
-(void)setControlValueByPayee
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([appDelegate.settings.payeeName boolValue])
        self.payeText.text = self.payees.name;
    
    
    if(self.payees.category !=nil){
        self.categories = self.payees.category;
        self.categoryLabel.text = self.categories.categoryName;
        [tranCategorySelectedArray removeAllObjects];

        //设置transaction type
        if ([self.categories.categoryType isEqualToString:@"EXPENSE"]) {
            expenseBtn.selected = YES;
            incomeBtn.selected = NO;
            transferBtn.selected = NO;
        }
        else if ([self.categories.categoryType isEqualToString:@"INCOME"])
        {
            expenseBtn.selected = NO;
            incomeBtn.selected = YES;
            transferBtn.selected = NO;
        }
    }
    
//    self.memoTextView.text = self.payees.memo;
//    if ([self.payees.memo length]>0) {
//        memoLabel.text = @"";
//    }
//    else
//    {
//        memoLabel.text = @"Memo";
//    }
    
}



- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FALSE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return   UITableViewCellEditingStyleNone;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView!=payeeSearchTable) {
        [self hideAllTabPop];
        
        
    }
    
}

#pragma mark UIImageViewSelectedViewController
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

//选中了一个之后 就将这个数据写到本地文件中
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)selectedImage
				  editingInfo:(NSDictionary *)editingInfo
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
    NSString *imageName =  (__bridge NSString *)string;
    
    //搜索到以前的图片然后删除
    if (self.photosName != nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.photosName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }
    
	self.photosName = imageName;
    
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(selectedImage, 1.f)];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, imageName] atomically:YES];
	
    
 	UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, imageName]];
	UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
	phontoImageView.image = imaged;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.AddSubPopoverController isPopoverVisible])
       [appDelegate.AddSubPopoverController dismissPopoverAnimated:YES];
    
// 	[picker  dismissModalViewControllerAnimated:YES];
}

- (UIImage *)imageFitScreen:(UIImage *)image
{

    

    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(calculateView.frame.size.width,490);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return tempImage;
    
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage withTargetSize: (CGSize)targetSize
{
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else
			if (widthFactor < heightFactor)
			{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

//- (NSUInteger)supportedInterfaceOrientations
//{   //需要强制横屏
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//	return TRUE;
//}
#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //actionsheet是present上来的，需要先将actionsheetdismiss掉，再present新的视图
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}

-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
   	//有摄像机的设备
    if(actionSheet.tag == 0)
    {
        if (buttonIndex == 0)
        {
            AppDelegate_iPad *appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            [appDelegate_ipad.appActionSheet dismissWithClickedButtonIndex:2 animated:NO];
            
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker1.delegate= self;
            
            //新加
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;
            
            UITableViewCell *selectedCell = [showCellTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint point1 = [showCellTable convertPoint:selectedCell.frame.origin toView:self.view];
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2, point1.y, 50.0,50)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

        }
        else if(buttonIndex == 1)
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501.0, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;
            
            UITableViewCell *selectedCell = [showCellTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint point1 = [showCellTable convertPoint:selectedCell.frame.origin toView:self.view];
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2, point1.y, 50.0,50)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            return;
            
            
        }
        else if (buttonIndex == 2)
        {
            return;
        }
    }
    //无摄像头设备
    else if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)
        {
            
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501.0, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;

            
            
            UITableViewCell *selectedCell = [showCellTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint point1 = [showCellTable convertPoint:selectedCell.frame.origin toView:self.view];
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2, point1.y, 50.0,50)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

            
            
            
            
        }
        else if (buttonIndex == 1)
        {
            return;
        }
    }
    
    else if (actionSheet.tag==100|| actionSheet.tag==101){
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
        }
        else
            return;
        
    }
}


#pragma mark Calculate Action
-(IBAction)calculateBtnPressed:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
	long tag = btn.tag;
	
	switch (tag)
	{
            // 初始化清屏
		case hmjclearBtn:	// C    1
			[self calculate_clearAmount];
			break;
            
            // 退格
		case backBtn:	// ←    2
			[self calculate_backSpace];
			break;
            
            // 双操作数运算符
		case plusBtn:	// +    3
		case subBtn:	// -    4
		case mulBtn:	// x    5
		case divBtn:	// ÷    6
		case equalBtn:	// =    9
			[self inputDoubleOperator:sender.titleLabel.text];
			break;
			
            // 增加小数点
		case dotBtn:	// .    10
			[self addDot];
			break;
            
            
            //数字键
        default:
            [self inputNumber:btn.titleLabel.text];
            break;
	}
    
}

-(void)calculate_clearAmount{
    display.text = @"0";
	showFoperator.text = @"C";
	arithmeticFlag = @"=";
	fstOperand = 0;
	currentNumber = 0;
	bBegin = YES;
    currentNumber=0.00;
    
    [self changeFloat:currentNumber];
}

-(void)calculate_backSpace{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSLog(@"currentNumber123:%f",currentNumber);

    showFoperator.text = @"←";
	
	if (backOpen)
	{
		if (display.text.length == 1)
		{
			display.text = @"0";
		}
		else if (![display.text isEqualToString:@""])
		{
			display.text = [display.text substringToIndex:display.text.length -1];
		}
        NSString *newAmountString = [appDelegate.epnc formatterAmount:display.text];

        currentNumber = [newAmountString doubleValue];
	}
}
//按下+ - * / 双操作数运算方法
- (void)inputDoubleOperator: (NSString *)arithmeticSymbol
{
	showFoperator.text = arithmeticSymbol;
    //	backOpen = NO;
    backOpen = YES;
	
	if(![display.text isEqualToString:@""])
	{
        //第一个操作数 100+
		fstOperand = [display.text doubleValue];
		
		if(bBegin)
		{
            //操作符
			arithmeticFlag = arithmeticSymbol;
		}
		else
		{
			if([arithmeticFlag isEqualToString:@"="])
			{
				currentNumber = fstOperand;
			}
            
			else if([arithmeticFlag isEqualToString:@"+"])
			{
                currentNumber += fstOperand;
				display.text = [NSString stringWithFormat:@"%.2f",currentNumber];
                
			}
			else if([arithmeticFlag isEqualToString:@"-"])
			{
                currentNumber -= fstOperand;
				display.text = [NSString stringWithFormat:@"%.2f",currentNumber];
			}
			else if([arithmeticFlag isEqualToString:@"x"])
			{
				currentNumber *= fstOperand;
				display.text = [NSString stringWithFormat:@"%.2f",currentNumber];
			}
			else if([arithmeticFlag isEqualToString:@"÷"])
			{
				if(fstOperand!= 0)
				{
					currentNumber /= fstOperand;
					display.text = [NSString stringWithFormat:@"%.2f",currentNumber];
				}
				else
				{
					display.text = @"nan";
					arithmeticFlag= @"=";
				}
			}
			bBegin= YES;
            
            arithmeticFlag= arithmeticSymbol;

		}
	}
}
- (void)addDot
{
	showFoperator.text = @".";
	
	if(![display.text isEqualToString:@""] && ![display.text isEqualToString:@"-"])
	{
		NSString *currentStr = display.text;
		BOOL notDot = ([display.text rangeOfString:@"."].location == NSNotFound);
		if (notDot)
		{
			currentStr= [currentStr stringByAppendingString:@"."];
			display.text= currentStr;
		}
	}
}
// 数字输入方法
- (void)inputNumber: (NSString *)nbstr
{
    backOpen = YES;
	if(bBegin)
	{
		showFoperator.text = @"";
		display.text = nbstr;
	}
	else
	{
        if (![display.text isEqualToString:@"0"]) {
            display.text = [display.text stringByAppendingString:nbstr];
        }
        else{
            showFoperator.text = @"";
            display.text = nbstr;
        }
		
	}
	bBegin = NO;
}


//---------------将amount转换成字符串-----------------------------------------
- (NSString *)changeFloat:(double)Right
{
	NSString *stringFloat;
	stringFloat = [NSString stringWithFormat:@"%.10f",Right];
	const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
	long i;
    for( i = length-1; i>=0; i--)
    {
        if(floatChars[i] == '0')
			;
		else
		{
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(i == -1)
        returnString =[NSString stringWithFormat:@"%@0.00",[appDelegate.settings.currency substringToIndex:1]];
    //returnString =[appDelegate.epnc formatterString:0];
	else
        /// returnString = [stringFloat substringToIndex:i+1];
        returnString =[NSString stringWithFormat:@"%@%@",[appDelegate.settings.currency substringToIndex:1],[stringFloat substringToIndex:i+1]];
    
    // returnString = [stringFloat substringToIndex:i+1];
    return returnString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

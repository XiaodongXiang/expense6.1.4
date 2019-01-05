//
//  TransactionEditViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-5.
//
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#import "TransactionEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "PayeeSearchCell.h"

#import "AccountEditViewController.h"
#import "TransactionCategoryViewController.h"
#import "TransactionCategorySplitViewController.h"
#import "SelectImageViewController.h"
#import "CategorySelect.h"

#import "DropboxSyncTableDefine.h"
#import "EPNormalClass.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "AccountPickerViewController.h"
#import "TransactionRecurringViewController.h"

#import "ParseDBManager.h"
#import <Parse/Parse.h>


#define ANIMATIONCURVE 0.25


@interface TransactionEditViewController ()
{
    BOOL firsttobehere;
}

@end

@implementation TransactionEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initPoint];
    [self initContextShow];
    //获取account,category
    [self getDataSouce];
    [self setDefaultAcc_Cate];

    [self initAllSplitCategoryMemory];
    [self setselectedSplitCategoryMemory];
    //根据 transaction设置 数据
    [self setControlShowTextWithTranscation];
    [self initNavBarStyle];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    [self setAmountisLock];
    [self getDataSouce];
    [self setCustomerPick];
    
    if ([_tranCategorySelectedArray count]>1)
    {
        self.recurringType = @"Never";
        _recurringLabel.text = NSLocalizedString(@"VC_Never", nil);
    }
    [self.showCellTable reloadData];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([self.typeoftodo isEqualToString:@"ADD"])
    {
        if (firsttobehere)
        {
            [_payeText becomeFirstResponder];
        }
        firsttobehere = NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void)refleshUI{
    if (self.transactionCategoryViewController != nil) {
        [self.transactionCategoryViewController refleshUI];
    }
    else if (self.transactionCategorySplitViewController != nil){
        [self.transactionCategorySplitViewController refleshUI];
    }
    else if (self.accountPickerViewController != nil)
    {
        [self.accountPickerViewController refleshUI];
    }
    else{
        //获取account
        [self getDataSouce];
    }
    
}
#pragma mark viewDidLoad
-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *currentLangue = [EPNormalClass currentLanguage];;
    if ([currentLangue isEqualToString:@"en"])
        cancelBtn.frame = CGRectMake(0, 0,60, 30);
    else
        cancelBtn.frame = CGRectMake(0, 0, 90, 30);
    [cancelBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
     [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ];

    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    if ([currentLangue isEqualToString:@"en"])
    {
        doneBtn.frame = CGRectMake(0, 0,60, 30);
    }
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn] ];
    
    
    //title
    if ([[UIScreen mainScreen] bounds].size.height >= 528)
    {
        if ([self.typeoftodo isEqualToString:@"ADD"])
        {
            self.navigationItem.title = NSLocalizedString(@"VC_NewTransaction", nil);
        }
        else
        {
            self.navigationItem.title = NSLocalizedString(@"VC_EditTransaction", nil);
        }
    }
    else
    {
        self.navigationItem.title = [_outputFormatter stringFromDate:_transactionDate];
    }
    
    

}


-(void)initPoint
{
    _payeText.delegate = self;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [_display setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];

    _payeText.placeholder = NSLocalizedString(@"VC_Payee", nil);
    _cagetoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    _accountLabelText.text = NSLocalizedString(@"VC_Account", nil);
    _fromAccountLabelText.text = NSLocalizedString(@"VC_FromAccount", nil);
    _toAccountLabelText.text = NSLocalizedString(@"VC_ToAccount", nil);
    _dateLabelText.text = NSLocalizedString(@"VC_Date", nil);
    _repeatLabelText.text = NSLocalizedString(@"VC_Repeat", nil);
    _ClearedLabelText.text = NSLocalizedString(@"VC_Cleared", nil);
    _photoLabelText.text = NSLocalizedString(@"VC_Photo", nil);
    _showMoreLabelText.text = NSLocalizedString(@"VC_Show More Details", nil);
    
    
    [_calculator_0 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_0.png"]] forState:UIControlStateNormal];
    [_calculator_1 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_1.png"]] forState:UIControlStateNormal];
    [_calculator_2 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_2.png"]] forState:UIControlStateNormal];
    [_calculator_3 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_3.png"]] forState:UIControlStateNormal];
    [_calculator_4 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_4.png"]] forState:UIControlStateNormal];
    [_calculator_5 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_5.png"]] forState:UIControlStateNormal];
    [_calculator_6 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_6.png"]] forState:UIControlStateNormal];
    [_calculator_7 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_7.png"]] forState:UIControlStateNormal];
    [_calculator_8 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_8.png"]] forState:UIControlStateNormal];
    [_calculator_9 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_9.png"]] forState:UIControlStateNormal];
    [_calculator_c setImage:[UIImage imageNamed:[NSString customImageName:@"btn_empty.png"]] forState:UIControlStateNormal];
    [_calculator_d setImage:[UIImage imageNamed:[NSString customImageName:@"btn_sign_of_division.png"]] forState:UIControlStateNormal];
    [_calculator_m setImage:[UIImage imageNamed:[NSString customImageName:@"btn_multiply.png"]] forState:UIControlStateNormal];
    [_calculator_mi setImage:[UIImage imageNamed:[NSString customImageName:@"btn_minus.png"]] forState:UIControlStateNormal];
    [_calculator_add setImage:[UIImage imageNamed:[NSString customImageName:@"btn_plus.png"]] forState:UIControlStateNormal];
    [_calculator_equal setImage:[UIImage imageNamed:[NSString customImageName:@"btn_equal_sign.png"]] forState:UIControlStateNormal];
    [_calculator_point setImage:[UIImage imageNamed:[NSString customImageName:@"btn_point.png"]] forState:UIControlStateNormal];
    [_calculator_re setImage:[UIImage imageNamed:[NSString customImageName:@"btn_revocation.png"]] forState:UIControlStateNormal];
    
    [_calculator_0 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_0_sel.png"]] forState:UIControlStateSelected];
    [_calculator_1 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_1_sel.png"]] forState:UIControlStateSelected];
    [_calculator_2 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_2_sel.png"]] forState:UIControlStateSelected];
    [_calculator_3 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_3_sel.png"]] forState:UIControlStateSelected];
    [_calculator_4 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_4_sel.png"]] forState:UIControlStateSelected];
    [_calculator_5 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_5_sel.png"]] forState:UIControlStateSelected];
    [_calculator_6 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_6_sel.png"]] forState:UIControlStateSelected];
    [_calculator_7 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_7_sel.png"]] forState:UIControlStateSelected];
    [_calculator_8 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_8_sel.png"]] forState:UIControlStateSelected];
    [_calculator_9 setImage:[UIImage imageNamed:[NSString customImageName:@"btn_9_sel.png"]] forState:UIControlStateSelected];
    [_calculator_c setImage:[UIImage imageNamed:[NSString customImageName:@"btn_empty_sel.png"]] forState:UIControlStateSelected];
    [_calculator_d setImage:[UIImage imageNamed:[NSString customImageName:@"btn_sign_of_division_sel.png"]] forState:UIControlStateSelected];
    [_calculator_m setImage:[UIImage imageNamed:[NSString customImageName:@"btn_multiply_sel.png"]] forState:UIControlStateSelected];
    [_calculator_mi setImage:[UIImage imageNamed:[NSString customImageName:@"btn_minus_sel.png"]] forState:UIControlStateSelected];
    [_calculator_add setImage:[UIImage imageNamed:[NSString customImageName:@"btn_plus_sel.png"]] forState:UIControlStateSelected];
    [_calculator_equal setImage:[UIImage imageNamed:[NSString customImageName:@"btn_equal_sign_sel.png"]] forState:UIControlStateSelected];
    [_calculator_point setImage:[UIImage imageNamed:[NSString customImageName:@"btn_point_sel.png"]] forState:UIControlStateSelected];
    [_calculator_re setImage:[UIImage imageNamed:[NSString customImageName:@"btn_revocation_sel.png"]] forState:UIControlStateSelected];

    

    
    _payeText.autocorrectionType = UITextAutocorrectionTypeNo;
//    _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
    _calculateB.constant = -255;

    self.showCellTable.delegate = self;
    
    
    _outputFormatter = [[NSDateFormatter alloc] init];
    [_outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];
    
    _headerDateormatter = [[NSDateFormatter alloc]init];
    [_headerDateormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    _accountCell.textLabel.text =@"Account";
    _fromAccountCell.textLabel.text = @"From Account";
    _toAccountCell.textLabel.text = @"To Account";
    _showMoreDetailsCell.textLabel.text = @"Show More";
	_amountCell.textLabel.text =@"Amount";
	_categoryCell.textLabel.text =@"Category";
	self.dateCell.textLabel.text =@"Date";
	self.recurringCell.textLabel.text =@"Recurring";
	_noteCell.textLabel.text =@"Note";
	_imageCell.textLabel.text =@"Image";
	_payeeCell.textLabel.text =@"Payee";
	_clearCell.textLabel.text =@"Clear";
    _accountCell.textLabel.hidden = YES;
    
    [_cagetoryLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_categoryLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
    [_accountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_fromAccountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_toAccountLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_dateLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_dateLabel setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_repeatLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_recurringLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];
    [_ClearedLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_photoLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];

    _payeeListBg.image = [UIImage imageNamed:[NSString customImageName:@"payeeBg_320_130.png"]];
    //让首字母自动大写
    _payeText.autocapitalizationType = UITextAutocapitalizationTypeWords;
	_amountCell.textLabel.hidden = YES;
    _fromAccountCell.textLabel.hidden = YES;
    _toAccountCell.textLabel.hidden = YES;
    _showMoreDetailsCell.textLabel.hidden = YES;
	_categoryCell.textLabel.hidden = YES;
	self.dateCell.textLabel.hidden = YES;
	self.recurringCell.textLabel.hidden = YES;
	_noteCell.textLabel.hidden = YES;
	_imageCell.textLabel.hidden = YES;
	_payeeCell.textLabel.hidden = YES;
 	_clearCell.textLabel.hidden = YES;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
	self.documentsPath = [paths objectAtIndex:0];
    
    _firsttoBeHere =0;
    _payeeSearchView.hidden = YES;
    
  
    _datePicker.backgroundColor =[UIColor whiteColor];

    _datePicker.frame=CGRectMake(0, 0, 320, 200);
    
    
    _payeeArray = [[NSMutableArray alloc]init];
    _accountArray = [[NSMutableArray alloc]init];
    _cycleTypeArray= [NSMutableArray arrayWithObjects:
 					  @"Never",@"Daily", @"Weekly",@"Every 2 Weeks",@"Every 3 Weeks",@"Every 4 Weeks",@"Semimonthly", @"Monthly",@"Every 2 Months",@"Every 3 Months",@"Every 4 Months",@"Every 5 Months",@"Every 6 Months",@"Every Year",nil] ;
    _categoryArray = [[NSMutableArray alloc]init];
    _pickItemArray = [[NSMutableArray alloc]init];
    _tranCategorySelectedArray = [[NSMutableArray alloc]init];
    
    _payeeSearchTable.delegate = self;
    _payeeSearchTable.dataSource = self;
    
    [_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_transferBtn addTarget:self action:@selector(transferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    
    _bBegin= YES;
    _backOpen = YES;
    _isDotDown = NO;
    _fstOperand = 0.00;
    _currentNumber =0.00;
    _arithmeticFlag = @"=";
    
    _thisTransisBeenDelete = NO;
    
    firsttobehere = YES;
 
    //获取category:expense income default;
    NSError *error =nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [_categoryArray setArray:objects];

    
    
    for (Category *tmpCategory in _categoryArray)
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
    if(IS_IPHONE_4)
        _payeeSearchViewT.constant = 80;
    else
        _payeeSearchViewT.constant = 80;
}

-(void)initContextShow{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    _payeText.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    _categoryLabel.textColor =[appDelegate_iphone.epnc getGrayColor_156_156_156];
    _accountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    _fromAccountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    _toAccountLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    _recurringLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
}
//获取account,获取Category
- (void)getDataSouce
{
    [_accountArray removeAllObjects];
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
    [_accountArray setArray:objects];

    

    
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest1 setEntity:entity1];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors1 = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];
    
    [fetchRequest1 setSortDescriptors:sortDescriptors1];
    NSArray* objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest1 error:&error];
    [_categoryArray setArray:objects1];

}

//获取所有的
-(void)initAllSplitCategoryMemory
{
    
    if([[_transaction.childTransactions allObjects]count]>1 || [self.categories.categoryType isEqualToString:@"EXPENSE"])
    {
        if(_tranExpCategorySelectArray == nil)
        {
            //获取所有的expense类型的category
            _tranExpCategorySelectArray =[[NSMutableArray alloc] init];
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
                    
                }else{
                    cs.isSelect = TRUE;
                    cs.amount = [t.amount doubleValue];
                    cs.memo =t.notes;
                    
                }
                [_tranExpCategorySelectArray addObject:cs];
                
            }
        }
        else
        {
            [_tranExpCategorySelectArray removeAllObjects];
            
            
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
                [_tranExpCategorySelectArray addObject:cs];
                
            }
        }
        
        
        
    }
    
    
    
    
}

-(void)setselectedSplitCategoryMemory
{
    if([[_transaction.childTransactions allObjects]count]>1)
    {
        if(_tranExpCategorySelectArray != nil)
        {
            if(_tranCategorySelectedArray == nil)
                _tranCategorySelectedArray = [[NSMutableArray alloc] init];
            else
                [_tranCategorySelectedArray removeAllObjects];
            
            for (int i=0; i<[_tranExpCategorySelectArray count]; i++)
            {
                CategorySelect *categoruSelect = (CategorySelect *)[_tranExpCategorySelectArray objectAtIndex:i];
                if(categoruSelect.isSelect)
                {
                    CategorySelect *cs = [[CategorySelect alloc] init];
                    cs.category = categoruSelect.category;
                    cs.amount = categoruSelect.amount;
                    cs.isSelect = categoruSelect.isSelect;
                    cs.memo = categoruSelect.memo;
                    
                    [_tranCategorySelectedArray addObject:cs];
                    
                }
            }
            
        }
        if([_tranCategorySelectedArray count] == 1)
            self.categories = [((Transaction *)[_tranCategorySelectedArray lastObject]) category];
        
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
    
	if([self.typeoftodo isEqualToString:@"EDIT"])
	{

        //payee
		self.payeText.text = self.transaction.payee.name;
        
        //category
        if (self.transaction.category != nil)
		{
			self.categories = self.transaction.category;
            _categoryLabel.text = self.categories.categoryName;
            _isSpliteTrans = NO;
		}
        else if ([self.transaction.childTransactions count]>0)
        {
            self.categories = nil;
            _categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
            _isSpliteTrans = YES;
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
            _accountLabel.text = self.accounts.accName;
            
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
            _transferBtn.selected = NO;
		}
		else if (self.transaction.incomeAccount != nil&&[self.transaction.category.categoryType isEqualToString:@"INCOME"])
		{
			self.accounts = self.transaction.incomeAccount;
            _expenseBtn.selected = NO;
            _incomeBtn.selected = YES;
            _transferBtn.selected = NO;
		}
        else if ([self.transaction.childTransactions count]>0)
        {
            self.accounts = self.transaction.expenseAccount;
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
            _transferBtn.selected = NO;
        }
        else
        {
            _expenseBtn.selected = NO;
            _incomeBtn.selected = NO;
            _transferBtn.selected = YES;
            self.fromAccounts = self.transaction.expenseAccount;
            self.toAccounts = self.transaction.incomeAccount;
            _fromAccountLabel.text = self.fromAccounts.accName;
            _toAccountLabel.text = self.toAccounts.accName;
        }
        _showMoreDetails = YES;
    
        //recurring
		self.recurringType = self.transaction.recurringType;
        
        //memo
        _memoTextView.text = self.transaction.notes;
        
        //payee
        self.payees = self.transaction.payee;
        _payeText.text = self.transaction.payee.name;
        //photo
        if (self.transaction.photoName != nil)
        {
            self.photosName = _transaction.photoName;
			UIImage *selectedImage = [self imageByScalingAndCroppingForSize:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, _transaction.photoName]] withTargetSize:CGSizeMake(40,40)];
	 		[self.phontoImageView setImage:selectedImage];
        }
        else
        {
            self.photosName=nil;
            self.phontoImageView.image = nil;
        }
        //cleared
        _clearedSwitch.on = [self.transaction.isClear boolValue] ;
        
        [self.payeText resignFirstResponder];
        [_memoTextView resignFirstResponder];
        
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationCurve:ANIMATIONCURVE];
//        _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
        _calculateB.constant = -255;

        [UIView commitAnimations];


 	}
 	else
	{
        if (!self.accounts)
        {
            BOOL foundDefaultAccount = NO;
            Accounts *tmpDefaultAccount = nil;
            for (int i=0; i<[_accountArray count]; i++)
            {
                Accounts *oneAccount = [_accountArray objectAtIndex:i];
                if ([oneAccount.others isEqualToString:@"Default"])
                {
                    tmpDefaultAccount = oneAccount;
                    foundDefaultAccount = YES;
                }
            }
            if (!foundDefaultAccount && [_accountArray count]>0)
            {
                tmpDefaultAccount = [_accountArray objectAtIndex:0];
            }
            if (tmpDefaultAccount)
            {
                self.accounts = tmpDefaultAccount;
            }
        }
        
        self.fromAccounts = nil;
        self.toAccounts = nil;
        
        _expenseBtn.selected = YES;
        _incomeBtn.selected = NO;
        _transferBtn.selected = NO;
        _showMoreDetails = NO;
        //category icon
        _payeText.text = @"";
        //amount
        _display.text = [appDelegate.epnc formatterString:0];
        _isSpliteTrans = NO;
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

        
        //photo
        self.photosName = nil;

        
        //cleared
        if (self.accounts != nil) {
            _clearedSwitch.on = [self.accounts.autoClear boolValue];
        }
        else{
            _clearedSwitch.on = YES;
        }
        
 	}
    
    //account
 	if( self.accounts!=nil)
		self.accountLabel.text = self.accounts.accName;
    else
    {
        if ([_accountArray count]>0) {
            self.accounts = [_accountArray firstObject];
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
    if([self.typeoftodo isEqualToString:@"EDIT"])
    {
        
        if ([[self.transaction.childTransactions allObjects] count] > 1)
        {
            _categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
        }
        else
        {
            _categoryLabel.text = self.transaction.category.categoryName;
        }
        
    }
    else
    {
        if(self.categories == nil)
        {
            if (_expenseBtn.selected)
                self.categories = _otherCategory_expense;
            
            else if (_incomeBtn.selected)
                self.categories = _otherCategory_income;
            else
                self.categories = nil;
        }
        _categoryLabel.text = self.categories.categoryName;
    }
    
    //date
    self.dateLabel.text = [_outputFormatter stringFromDate:self.transactionDate];
    
    //memo
    if ([_memoTextView.text length]>0) {
        _memoLabel.text = @"";
    }
    else
        _memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    
    [self.showCellTable reloadData];
    
}

//设置默认的category NotSure
-(void)setDefaultAcc_Cate
{
    
//    if([accountArray count]>0 && accounts ==nil)
//    {
//        Accounts *tmpAccount = (Accounts *)[accountArray objectAtIndex:0];
//        self.accounts = tmpAccount;
//    }
    
    if ([self.typeoftodo isEqualToString:@"ADD"]){
        if(self.categories ==nil)
        {
            for (Category *tmpCategory in _categoryArray)
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
    if(_transaction == nil || [[_transaction.childTransactions allObjects] count] <=0 )
        return nil;
    else
    {
        //获取当前编辑的trans下所有的子trans
        for (int i=0; i<[[_transaction.childTransactions allObjects] count]; i++)
        {
            //获得子trans的和需要找的category相同的trans
            Transaction *t = [[_transaction.childTransactions allObjects] objectAtIndex:i];
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
    if ([_tranCategorySelectedArray count]>1) {
        double totalAmount = 0.00;
        for (int i=0; i<[_tranCategorySelectedArray count]; i++) {
            CategorySelect *oneCategory = [_tranCategorySelectedArray objectAtIndex:i];
            totalAmount += oneCategory.amount;
        }
        _currentNumber = totalAmount;
        _isSpliteTrans = YES;
        _display.text = [appDelegate.epnc formatterString:totalAmount];
        _categoryLabel.text = NSLocalizedString(@"VC_Split", nil);
    }
    else if([_tranCategorySelectedArray count]==1)
    {
        double totalAmount = 0.00;
        for (int i=0; i<[_tranCategorySelectedArray count]; i++) {
            CategorySelect *oneCategory = [_tranCategorySelectedArray objectAtIndex:i];
            totalAmount += oneCategory.amount;
        }
        _currentNumber = totalAmount;
        //hmj 修改
        _isSpliteTrans = YES;
        _display.text = [appDelegate.epnc formatterString:totalAmount];
        self.categories = ((CategorySelect *)[_tranCategorySelectedArray lastObject]).category;
        _categoryLabel.text = self.categories.categoryName;
    }
//    calculateView.hidden = YES;

//    calculateView.frame = CGRectMake(0, self.view.frame.size.height-calculateView.frame.size.height, 320, calculateView.frame.size.height);
    
    
}


#pragma mark BtnAction
-(void)back:(id)sender{
    //搜索到以前的图片然后删除
    if (self.photosName != nil && [self.typeoftodo isEqualToString:@"ADD"])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.photosName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }
    if ([self.typeoftodo isEqualToString:@"ADD"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NO];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:NO];
}
-(void)save:(id)sender{
    
    
    //get all transaction
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
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
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
  

    

    
    if (!_isSpliteTrans) {
        [self inputDoubleOperator:@"="];
    }

    
	if([_display.text length] == 0 ||  _currentNumber  == 0.00)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Amount is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        appDelegate_iPhone.appAlertView = alertView;
        
		return;
	}
    else if ((_expenseBtn.selected || _incomeBtn.selected)&&self.accounts == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Account is required.", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        appDelegate_iPhone.appAlertView = alertView;

        
        return;
    }
    else if(self.fromAccounts == nil&& _transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_From Account is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        appDelegate_iPhone.appAlertView = alertView;

        
		return;
	}
	
	else if(self.toAccounts==nil&& _transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_To Account is required.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        appDelegate_iPhone.appAlertView = alertView;

        
		return;
	}
	else if(self.fromAccounts == self.toAccounts&& _transferBtn.selected)//Spent
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Accounts can not be same.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        appDelegate_iPhone.appAlertView = alertView;

        
		return;
	}
    [self performSelector:@selector(saveAction) withObject:nil afterDelay:0.0];

}

-(void)saveAction
{
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *errors;
    
    if ([self.typeoftodo isEqualToString:@"ADD"])
    {
        if(!_clearedSwitch.on)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_UNCL"];
        }
        if ([self.photosName length]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_PTO"];
        }
        if ([_memoTextView.text length]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_MEMO"];
        }
        if ([_tranCategorySelectedArray count]>1)
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
        if(!_clearedSwitch.on && [_transaction.isClear boolValue])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_UNCL"];
        }
        if ([self.photosName length]>0 && !_transaction.photoName)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_PTO"];
        }
        if ([_memoTextView.text length]>0 && !_transaction.notes)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_MEMO"];
        }
        if ([_tranCategorySelectedArray count]>1 && [_transaction.childTransactions  count]>0)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_SPLT"];
        }
        
        if ([_transaction.recurringType isEqualToString:@"Never"] && ![self.recurringType isEqualToString:@"Never"])
           
        {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_RECR"];
        }
        
        
        if ([self.recurringType isEqualToString:@"Daily"] && ![_transaction.recurringType isEqualToString:@"Daily"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_DLY"];
        }
        
        if ([self.recurringType isEqualToString:@"Weekly"]  && ![_transaction.recurringType isEqualToString:@"Weekly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_WKLY"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 2 Weeks"] && ![_transaction.recurringType isEqualToString:@"Every 2 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 3 Weeks"] && ![_transaction.recurringType isEqualToString:@"Every 3 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 4 Weeks"] && ![_transaction.recurringType isEqualToString:@"Every 4 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4WK"];
        }
        
        if ([self.recurringType isEqualToString:@"Semimonthly"] && ![_transaction.recurringType isEqualToString:@"Semimonthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_SMMO"];
        }
        
        if ([self.recurringType isEqualToString:@"Monthly"] && ![_transaction.recurringType isEqualToString:@"Monthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_MON"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 2 Months"] && ![_transaction.recurringType isEqualToString:@"Every 2 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 3 Months"] && ![_transaction.recurringType isEqualToString:@"Every 3 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 4 Months"] && ![_transaction.recurringType isEqualToString:@"Every 4 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 5 Months"] && ![_transaction.recurringType isEqualToString:@"Every 5 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_5MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every 6 Months"] && ![_transaction.recurringType isEqualToString:@"Every 6 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_6MO"];
        }
        
        if ([self.recurringType isEqualToString:@"Every Year"] && ![_transaction.recurringType isEqualToString:@"Every Year"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_YEAR"];
        }
    }
	
    //date
 	if(self.transaction == nil || _thisTransisBeenDelete)
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
    if ([self.typeoftodo isEqualToString:@"ADD"]) {
        self.transaction.uuid = [EPNormalClass GetUUID];
    }
    
    
    //amount
	self.transaction.amount =  [NSNumber numberWithDouble:fabs(_currentNumber)];
    
  	//photo
    self.transaction.photoName = self.photosName;
    
    //memo
	self.transaction.notes = _memoTextView.text;
	
    //如果一个交易开始是splite类型那么它永远都是splite类型了
//    if ([tranCategorySelectedArray count]==1) {
//        CategorySelect *onecs = [tranCategorySelectedArray lastObject];
//        self.categories = onecs.category;
//    }
    if([self.categories.categoryType isEqualToString:@"INCOME"])//Income
	{
        if(self.categories !=nil&&[_tranCategorySelectedArray count]<=1)
            _transaction.category = self.categories;
        else
        {
            _transaction.category =nil;
        }
   	 	_transaction.transactionType = @"income";
		_transaction.incomeAccount = self.accounts;
		_transaction.expenseAccount = nil;
        _transaction.isClear = self.accounts.autoClear;
 	}
	else if([self.categories.categoryType isEqualToString:@"EXPENSE"] &&[_tranCategorySelectedArray count]<=1)//Spent
	{
        if(self.categories !=nil&&[_tranCategorySelectedArray count]<=1)
            _transaction.category = self.categories;
        else
        {
            _transaction.category =nil;
        }
		_transaction.expenseAccount = self.accounts;
		_transaction.incomeAccount = nil;
        _transaction.isClear = self.accounts.autoClear;
        
	}
    else if ([_tranCategorySelectedArray count]>1){
        _transaction.expenseAccount = self.accounts;
		_transaction.incomeAccount = nil;
        _transaction.isClear = self.accounts.autoClear;
    }
	else
    {
        _transaction.category =nil;
		_transaction.expenseAccount = self.fromAccounts;
		_transaction.incomeAccount = self.toAccounts;
        _transaction.isClear = self.fromAccounts.autoClear;
	}
    
    //cleared
    _transaction.isClear =[NSNumber numberWithBool:_clearedSwitch.on];
    //recurring
    _transaction.recurringType =  self.recurringType;
    //category
    if( self.categories !=nil&&[_tranCategorySelectedArray count]<=1)
        self.categories.others = @"HASUSE";
    
    if( self.categories !=nil&&[_tranCategorySelectedArray count]<=1)
    {
        [self.categories addTransactionsObject:_transaction];
    }
    
    
    
    
    
    
    
    /* --------HMJ if this is a new payee then inset it-------------*/
    if([_payeText.text length]>0)
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
        
        for (Payee *tmpPayee in objects)
        {
            
            if (!_transferBtn.selected)
            {
                if([tmpPayee.name isEqualToString:_payeText.text] && tmpPayee.category == self.categories)
                {
                    hasFound = TRUE;
                    self.payees = tmpPayee;
                    break;
                }
                //判定split数据
                else if (_transaction.childTransactions.count && [tmpPayee.name isEqualToString:_payeText.text])
                {
                    hasFound=TRUE;
                    self.payees=tmpPayee;
                    break;
                }

            }
            else
            {
                if([tmpPayee.name isEqualToString:_payeText.text])
                {
                    hasFound = TRUE;
                    self.payees = tmpPayee;
                    break;
                }
            }
        }
        if(!hasFound )
        {
            AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            self.payees = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
            self.payees.name = _payeText.text;
            
//            self.payees.memo = _memoTextView.text;
            
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
                self.payees.category =_otherCategory_expense;
                self.payees.tranType = @"transfer";
            }
            
            self.payees.dateTime = [NSDate date];
            self.payees.state = @"1";
            self.payees.uuid =[EPNormalClass GetUUID];
            
            if (![appDelegate.managedObjectContext save:&errors]) {
                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                
            }
//            AppDelegate_iPhone *appDelegaet_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//            if (appDelegaet_iPhone.dropbox.drop_account.linked) {
//                [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.payees];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:self.payees];
            }
        }
        
        //当没有payee的时候，需要将这个payee去掉
        _transaction.payee = self.payees;
    }
    else
        _transaction.payee = nil;
    
    
    //如果这个transaction有子 trans,就需要删掉旗下的所有子,方便重新建立交易。 当建立了一个多category的trans的时候，不仅要建立每个category下的交易，还需要建立一个总的交易，这个总的交易就是parTran，旗下所有的子category建立的交易就是childCategory
    if ([_transaction.childTransactions count] > 0)
    {
        //save local transaction
        for (Transaction *tran in [_transaction.childTransactions allObjects]) {
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
    if([_tranCategorySelectedArray count] > 1 ){
        self.recurringType = @"Never";
        _transaction.recurringType = @"Never";
    }
    
 
    [appDelegate.managedObjectContext save:&errors];

    
    if( [self.recurringType isEqualToString:@"Never"])
    {
        //sync
//        if (appDelegate_iPhone.dropbox.drop_account.linked) {
//            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:self.transaction];
//            
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:self.transaction];
        }
        //如果是多选category
        if([_tranCategorySelectedArray count] > 1 )
        {
            //加sprit
            double totalAmount =0;
            for (int i=0; i<[_tranCategorySelectedArray count]; i++)
            {
                CategorySelect *categoruSelect = (CategorySelect *)[_tranCategorySelectedArray objectAtIndex:i];
                {
                    totalAmount +=categoruSelect.amount;
                    
                    //建立单个category对应的trans,就是childTransaction
                    Transaction *childTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
                    
                    /*--------配置 childTransaction的所有信息-----*/
                    childTransaction.dateTime = self.transaction.dateTime;
                    childTransaction.amount = [NSNumber numberWithDouble:categoruSelect.amount];
                    //在添加子category的时候，将note也保存进来
                    childTransaction.category = categoruSelect.category;
                    if([categoruSelect.category.categoryType isEqualToString:@"INCOME"])
                    {
                        childTransaction.incomeAccount = self.accounts;
                        childTransaction.expenseAccount = nil;
                        
                    }
                    else if([categoruSelect.category.categoryType isEqualToString:@"EXPENSE"]){
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
                    [_transaction addChildTransactionsObject:childTransaction];
                    
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
    else
    {
        //自动插入交易
        if(![self.recurringType isEqualToString:@"Never"])
            [appDelegate.epdc autoInsertTransaction:_transaction];
    }
    

    

    
//    [appDelegate_iPhone.epdc saveTransaction:self.transaction];

        
        
        
    
    


    //退出程序
    if([self.typeoftodo isEqualToString:@"ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_ADD"];
        
        if (_expenseBtn.selected)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_EXP"];
        }
        else if (_transferBtn.selected)
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_TSF"];
        else
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_INC"];
        
        if(_isFromHomePage)
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_ADDTRS_HOME"];
        else
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_ADDTRS_ACC"];

    }
    [self.navigationController dismissViewControllerAnimated:YES completion:NO];

    
}

-(void)btnAmountAction:(id)sender
{
    [self.payeText resignFirstResponder];
    [_memoTextView resignFirstResponder];

    
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
//    _calculateView.frame = CGRectMake(0, self.view.frame.size.height-_calculateView.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
    _calculateB.constant = -255;

    [UIView commitAnimations];
}

-(void)expenseBtnPressed:(UIButton *)sender
{
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    _transferBtn.selected = NO;
    
    
    if(![self.categories.categoryType isEqualToString:@"EXPENSE"])
    {
        self.categories = _otherCategory_expense;
        _categoryLabel.text = self.categories.categoryName;
    }
    
    [self.showCellTable reloadData];
}

-(void)incomeBtnPressed:(UIButton *)sender
{
    _expenseBtn.selected = NO;
    _incomeBtn.selected = YES;
    _transferBtn.selected = NO;
    if(![self.categories.categoryType isEqualToString:@"INCOME"])
    {
        self.categories = _otherCategory_income;
        _categoryLabel.text = self.categories.categoryName;
    }
    [self.showCellTable reloadData];
}

-(void)transferBtnPressed:(UIButton *)sender
{
    _expenseBtn.selected = NO;
    _incomeBtn.selected = NO;
    _transferBtn.selected = YES;
    self.categories = nil;
    _categoryLabel.text = self.categories.categoryName;
    [self.showCellTable reloadData];
}

-(void)hideAllTabPop{
    [self.payeText resignFirstResponder];
    _payeeSearchView.hidden = YES;
    [_memoTextView resignFirstResponder];
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
//    _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
    _calculateB.constant = -255;

    [UIView commitAnimations];
}
#pragma mark datePicker event
-(void)dateSelected  //如果不选择 则默认当天日期
{
 	self.transactionDate = self.datePicker.date;
    _dateLabel.text = [_outputFormatter stringFromDate:_datePicker.date];
    _sectionHeaderLabel.text = [_headerDateormatter stringFromDate:self.datePicker.date];
    
    if ([[UIScreen mainScreen]bounds].size.height < 528)
    {
        _tileLabel.text = [_outputFormatter stringFromDate:_transactionDate];
    }
}


#pragma mark HMJPickerViewDelegate
-(void)toolBtnPressed{
    AccountEditViewController *accountEditViewController = [[AccountEditViewController alloc]initWithNibName:@"AccountEditViewController" bundle:nil];
    accountEditViewController.typeOftodo = @"ADD";
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:accountEditViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}

//-(void)btnClearedAction:(id)sender{
//    clearedSwitch.on = !clearedSwitch.on;
//}


- (void) setCustomerPick
{
	[self.pickItemArray removeAllObjects];

 	if (_picktype == 3)
	{
		for (int i=0; i < [_cycleTypeArray count]; i++)
		{
			[self.pickItemArray addObject:[_cycleTypeArray objectAtIndex:i]];
		}
	}
	
}
#pragma mark textField delegate
-(IBAction)TextFieldDidBeginEditing:(UITextField *)textField{

    [self deleteDatePickerCell];
    
    [UIView  beginAnimations:nil context:nil];
    [UIView setAnimationCurve:ANIMATIONCURVE];
//    _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
    _calculateB.constant = -255;

    [UIView commitAnimations];
}

-(IBAction)TextDidEnd:(UITextField *)textField
{
    if (textField == _payeText)
    {
        ;
    }
    [self inputDoubleOperator:@"="];
}


//----payee
-(IBAction)payeeTextEditChange:(id)sender
{
    [self deleteDatePickerCell];
    
    if([self.payeText.text length]>0)
    {
        [self getPayeeSearchDataSource];
        
    }
    else
        self.payeeSearchView.hidden = YES;
}

-(void)getPayeeSearchDataSource
{
    NSString *text = self.payeText.text;
    [_payeeArray removeAllObjects];
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
        [_payeeArray setArray:objects ];

    }
    [self.payeeSearchTable reloadData];
    if([_payeeArray count] == 0)
    {
        self.payeeSearchView.hidden = YES;
        
    }
    else {
        
        
        self.payeeSearchView.hidden = NO;
        
    }
}

//---中英文来回切换的时候
- (void)keyBoardChangeHight:(NSNotification *)notification{
    
//    if ( (([self.tvc_tableView numberOfRowsInSection:0]==9)&&tvc_selectedCellInterger==8) || (([self.tvc_tableView numberOfRowsInSection:0]==8)&&tvc_selectedCellInterger==7)) {
//        NSDictionary *userInfo = [notification userInfo];
//        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];
//        
//        NSLog(@"keyboardRect11111:%f",keyboardRect.size.height);
//        if (keyboardRect.size.height > 216){
//            [self.tvc_tableView setContentOffset:CGPointMake(0, keyBoardHigh+36) animated:YES];
//            
//        }
//        else if(keyboardRect.size.height > 0){
//            [self.tvc_tableView setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
//        }
//        else
//            ;
//    }
}

#pragma mark TextView Delegate
//---UITextField 当没点击cell点击的是cell中的UITextField的时候，设置当前点击的属于哪个cell
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
//    [self deleteDatePickerCell];

    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] <8) {
        hight = self.showCellTable.frame.size.height-_noteCell.frame.origin.y-textView.frame.size.height;
    }
    else
        hight =self.showCellTable.frame.size.height-_noteCell.frame.origin.y-textView.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh = 216-hight;
        NSLog(@"keyBoardHigh:%f",keyBoardHigh);
        [self.showCellTable setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
    }
    
//    [memoTextView becomeFirstResponder];
    
}
-(void)textViewDidChange:(UITextView *)textView
{

//    memoTextView.text =  textView.text;
    if (textView.text.length == 0) {
        _memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    }else{
        _memoLabel.text = @"";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _payeText)
    {
        [_payeText resignFirstResponder];
        [_memoTextView resignFirstResponder];
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationCurve:ANIMATIONCURVE];
        //        _calculateView.frame = CGRectMake(0, self.view.frame.size.height-_calculateView.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
        _calculateB.constant = 0;
        
        [UIView commitAnimations];
    }
    return YES;
}





#pragma mark - tableview delegate
- (void)configureSearchPayeeCell:(PayeeSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Payee *searchPayee = (Payee *)[_payeeArray objectAtIndex:indexPath.row];
    cell.payeeLabel.text = searchPayee.name;
    cell.categoryLabel.text = searchPayee.category.categoryName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_payeeSearchTable) {
        return 1;
    }
    else
    {
        if (_showMoreDetails)
        {
            return 4;
        }
        else
            return 2;

    }
//    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_payeeSearchTable) {
        return 1;
    }
    else{
        if (section==0) {
            if ([[UIScreen mainScreen]bounds].size.height<528 && !_showMoreDetails)
            {
                return 36.f;

            }
            return 36.f;
        }
        else
        {
            return 25.f;

        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_showMoreDetails) {
        if (section==3) {
            return 17.5;
        }
        else
            return 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.showCellTable) {
        if (section==0) {
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
            headview.clipsToBounds = YES;
            _sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 305, 35)];
            NSString *tmpString = [_headerDateormatter stringFromDate:self.transactionDate];
            _sectionHeaderLabel.text = [tmpString uppercaseString];;
            [_sectionHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
            [_sectionHeaderLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1.f]];
            [_sectionHeaderLabel setBackgroundColor:[UIColor clearColor]];
            _sectionHeaderLabel.textAlignment = NSTextAlignmentLeft;
            [headview addSubview:_sectionHeaderLabel];
            return headview;
        }
        else
            return nil;
    }
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	if (tableView==_payeeSearchTable)
    {
        return 40.0;
    }
    else
    {
        
        if (_showMoreDetails && indexPath.section == 3 && indexPath.row == 1) {
            return 182;
        }
        //如果选中的是日期这个cell就需要刷新这个cell的高度，如果再次选中这个cell就取消选中这个cell
        else if (self.selectedRowIndexPath.section==1&&self.selectedRowIndexPath.row==2 && indexPath.section==1 && indexPath.row==3)
            return 216;
        else
            return 44;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_payeeSearchTable) {
        return [_payeeArray count];
    }
    
    
    if (section==0) {
        return 2;
    }
    else if (section==1)
    {
        if (self.showCellTable && self.selectedRowIndexPath.section==1 && self.selectedRowIndexPath.row==2)
        {
            return 4;
        }
        else
            return 3;
        
    }
    if (section==2)
    {
        if ([_tranCategorySelectedArray count]>1)
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
    if (tableView==_payeeSearchTable)
    {
        static NSString *CellIdentifier = @"Cell";
        PayeeSearchCell *cell = (PayeeSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PayeeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//
            
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
                return _payeeCell;
            }
            else
                return _amountCell;
        }
        else if (indexPath.section==1)
        {
            if (!_showMoreDetails)
            {
                if (_expenseBtn.selected || _incomeBtn.selected)
                {
                    if (indexPath.row==0)
                    {
                        return _categoryCell;
                    }
                    else if(indexPath.row==1)
                        return _accountCell;
                    else
                        return _showMoreDetailsCell;
                }
                else
                {
                    if (indexPath.row==0)
                    {
                        return _fromAccountCell;
                    }
                    else if(indexPath.row==1)
                        return _toAccountCell;
                    else
                        return _showMoreDetailsCell;
                }
                
            }
            else
            {
                if (_expenseBtn.selected || _incomeBtn.selected)
                {
                    if (indexPath.row==0)
                    {
                        return _categoryCell;
                    }
                    else if(indexPath.row==1)
                        return _accountCell;
                    else if(indexPath.row==2)
                        return self.dateCell;
                    else
                        return _datePickerCell;
                }
                else
                {
                    if (indexPath.row==0)
                    {
                        return _fromAccountCell;
                    }
                    else if(indexPath.row==1)
                        return _toAccountCell;
                    else if(indexPath.row==2)
                        return self.dateCell;
                    else
                        return _datePickerCell;
                }
                
                
            }
        }
        //    else if (showMoreDetails)
        else if (indexPath.section==2)
        {
            
            if ([_tranCategorySelectedArray count]>1)
            {
                if (indexPath.row==0)
                {
                    return _clearCell;
                }
            }
            else
            {
                if (indexPath.row==1)
                {
                    return _clearCell;
                }
                else
                    return self.recurringCell;
            }
            
        }
        if (indexPath.row==0)
        {
            return _imageCell;
        }
        else
            return _noteCell;
        
    }
    


}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_payeeSearchTable)
    {
        self.payees=  (Payee *)[_payeeArray objectAtIndex:indexPath.row] ;
        
        [self setControlValueByPayee];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.payeeSearchView.hidden = YES;
        
        [_payeText resignFirstResponder];
        [_memoTextView resignFirstResponder];
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationCurve:ANIMATIONCURVE];
//        _calculateView.frame = CGRectMake(0, self.view.frame.size.height-_calculateView.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
        _calculateB.constant = 0;

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
            [_payeText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            
            if ([self.tranCategorySelectedArray count]<=0)
            {
                [UIView  beginAnimations:nil context:nil];
                [UIView setAnimationCurve:ANIMATIONCURVE];
//                _calculateView.frame = CGRectMake(0, self.view.frame.size.height - _calculateView.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
                _calculateB.constant = 0;
                [UIView commitAnimations];
            }
            else
            {
                [UIView  beginAnimations:nil context:nil];
                [UIView setAnimationCurve:ANIMATIONCURVE];
//                _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
                _calculateB.constant = -255;

                [UIView commitAnimations];
            }

        }
        else if([checkedCell.textLabel.text isEqualToString:@"Account"])
        {
            [self hideAllTabPop];

            AccountPickerViewController *tmpAccountPickerViewControllr =[[AccountPickerViewController alloc]initWithNibName:@"AccountPickerViewController" bundle:nil];
            
            self.accountPickerViewController = tmpAccountPickerViewControllr;
            if (self.accounts != nil)
            {
                self.accountPickerViewController.selectedAccount = self.accounts;
            }
            self.accountPickerViewController.accountType = 0;
            self.accountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.accountPickerViewController animated:YES];
            
        }
        else if([checkedCell.textLabel.text isEqualToString:@"From Account"])
        {
            [self hideAllTabPop];
            
            self.accountPickerViewController = [[AccountPickerViewController alloc]initWithNibName:@"AccountPickerViewController" bundle:nil];
            if (self.fromAccounts != nil)
            {
                self.accountPickerViewController.selectedAccount = self.fromAccounts;
            }
            self.accountPickerViewController.accountType = 1;
            self.accountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.accountPickerViewController animated:YES];
            
        }
        else if([checkedCell.textLabel.text isEqualToString:@"To Account"])
        {
            [self hideAllTabPop];
            
            self.accountPickerViewController = [[AccountPickerViewController alloc]initWithNibName:@"AccountPickerViewController" bundle:nil];
            if (self.fromAccounts != nil)
            {
                self.accountPickerViewController.selectedAccount = self.toAccounts;
            }
            self.accountPickerViewController.accountType = 2;
            self.accountPickerViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:self.accountPickerViewController animated:YES];
        }

        else if([checkedCell.textLabel.text isEqualToString:@"Category"])
        {
            [self hideAllTabPop];
            
            if([_tranCategorySelectedArray count] >1 /*|| [transaction.childTransactions count]>1*/)
            {
                self.transactionCategorySplitViewController= [[TransactionCategorySplitViewController alloc]initWithNibName:@"TransactionCategorySplitViewController" bundle:nil];
                self.transactionCategorySplitViewController.tcsvc_transactionEditViewController = self;
                [self.navigationController pushViewController:_transactionCategorySplitViewController animated:YES];
                
            }
            else
            {
                self.transactionCategoryViewController= [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
                self.transactionCategoryViewController.tcvc_transactionEditViewController = self;
                
                [self.navigationController pushViewController:self.transactionCategoryViewController animated:YES];
            }
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Show More"])
        {
            [self hideAllTabPop];
            
            _showMoreDetails = YES;
            
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            
            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)];
            [self.showCellTable beginUpdates];
            [self.showCellTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.showCellTable insertSections:sections withRowAnimation:UITableViewRowAnimationBottom];
            [self.showCellTable endUpdates];
        }
     
        else 	if ([checkedCell.textLabel.text isEqualToString:@"Date"])
        {
            [self.payeText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            self.datePicker.date = self.transactionDate;

            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
            _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
            _calculateB.constant = -255;
            
            
            
            [UIView commitAnimations];
        
            
        }
        else 	if ([checkedCell.textLabel.text isEqualToString:@"Recurring"])
        {

            
            [self.payeText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            

            
            TransactionRecurringViewController *transactionRecurringViewController = [[TransactionRecurringViewController alloc]initWithNibName:@"TransactionRecurringViewController" bundle:nil];
            transactionRecurringViewController.recurringType = self.recurringType;
            transactionRecurringViewController.transactionEditViewController = self;
            [self.navigationController pushViewController:transactionRecurringViewController animated:YES];
            
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Payee"])
        {
            [_payeText becomeFirstResponder];
            
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
//            _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
            _calculateB.constant = -255;

            [UIView commitAnimations];
            
//            calculateView.hidden = YES;
        }
        else if ([checkedCell.textLabel.text isEqualToString:@"Note"])
        {
            [self.payeText resignFirstResponder];
            [_memoTextView becomeFirstResponder];
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
//            _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
            _calculateB.constant = -255;

            [UIView commitAnimations];
            
            
        }
        else if([checkedCell.textLabel.text isEqualToString:@"Image"])
        {

            
            
            [self.payeText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            
            [UIView  beginAnimations:nil context:nil];
            [UIView setAnimationCurve:ANIMATIONCURVE];
//            _calculateView.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _calculateView.frame.size.height);
            _calculateB.constant = -255;

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
                [actionSheet showInView:self.view];
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
                [actionSheet showInView:self.view];
                PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
                appDelegate.appActionSheet = actionSheet;
            }
            else if(self.photosName !=nil)
            {
                SelectImageViewController *selectImageViewController = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil];
                selectImageViewController.documentsPath = self.documentsPath;
                selectImageViewController.imageName = self.photosName ;
                selectImageViewController.sivc_transactionEditViewController = self;
                [self.navigationController pushViewController:selectImageViewController animated:YES];
            }
        }
        
        if (self.selectedRowIndexPath.section==1 && self.selectedRowIndexPath.row==2)
        {
            [self.showCellTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else
        {
            if ([self.showCellTable numberOfRowsInSection:1]==4)
            {
                [self.showCellTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
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
        if ([self.showCellTable numberOfRowsInSection:1]==3)
        {
            [self.showCellTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        if ([self.showCellTable numberOfRowsInSection:1]==4)
        {
            [self.showCellTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


//payee只修改 category和memo两项
-(void)setControlValueByPayee
{
    self.payeText.text = self.payees.name;
    
    
    if(self.payees.category !=nil){
        self.categories = self.payees.category;
        _isSpliteTrans = NO;
        self.categoryLabel.text = self.categories.categoryName;
        [_tranCategorySelectedArray removeAllObjects];
        
        //设置transaction type
        if ([self.categories.categoryType isEqualToString:@"EXPENSE"]) {
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
            _transferBtn.selected = NO;
        }
        else if ([self.categories.categoryType isEqualToString:@"INCOME"])
        {
            _expenseBtn.selected = NO;
            _incomeBtn.selected = YES;
            _transferBtn.selected = NO;
        }
    }
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
    if (scrollView!=_payeeSearchTable)
    {
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
    
//	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(selectedImage, 1.f)];
    
    NSData *imageData=UIImageJPEGRepresentation(selectedImage, 0.1);
    
    
	[imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, imageName] atomically:YES];
	
    
 	UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, imageName]];
	UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
	_phontoImageView.image = imaged;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageFitScreen:(UIImage *)image
{
    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(320,480);
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

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

	//有摄像机的设备
	if(actionSheet.tag == 0)
	{
		if (buttonIndex == 0) //dub不了
		{
			UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
			picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker1.delegate= self;

            [self presentViewController:picker1 animated:YES completion:nil];
            
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];

		}
		if(buttonIndex == 1)
		{
			UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
			picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			picker1.delegate= self;

            [self presentViewController:picker1 animated:YES completion:nil];
            
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];

		}
		if (buttonIndex == 2)
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
			[self presentViewController:picker1 animated:YES completion:nil ];
			
            
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];

		}
		if (buttonIndex == 1)
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

-(void)changeStatusBarStyle:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}

-(void)calculate_clearAmount{
    _display.text = @"0";
	_showFoperator.text = @"C";
	_arithmeticFlag = @"=";
	_fstOperand = 0;
	_currentNumber = 0;
	_bBegin = YES;
    _currentNumber=0.00;
    
    [self changeFloat:_currentNumber];
}

-(void)calculate_backSpace{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSLog(@"currentNumber123:%f",_currentNumber);

    _showFoperator.text = @"←";
	
	if (_backOpen)
	{
		if (_display.text.length == 1)
		{
			_display.text = @"0";
		}
		else if (![_display.text isEqualToString:@""])
		{
			_display.text = [_display.text substringToIndex:_display.text.length -1];
		}
        NSString *newAmountString = [appDelegate.epnc formatterAmount:_display.text];

        _currentNumber = [newAmountString doubleValue];
	}
}
//按下+ - * / 双操作数运算方法
- (void)inputDoubleOperator: (NSString *)arithmeticSymbol
{
	_showFoperator.text = arithmeticSymbol;
    //	backOpen = NO;
    _backOpen = YES;
	
	if(![_display.text isEqualToString:@""])
	{
        //第一个操作数 100+
		_fstOperand = [_display.text doubleValue];
		
		if(_bBegin)
		{
            //操作符
			_arithmeticFlag = arithmeticSymbol;
		}
		else
		{
			if([_arithmeticFlag isEqualToString:@"="])
			{
				_currentNumber = _fstOperand;
			}
            
			else if([_arithmeticFlag isEqualToString:@"+"])
			{
                _currentNumber += _fstOperand;
				_display.text = [NSString stringWithFormat:@"%.2f",_currentNumber];
                
			}
			else if([_arithmeticFlag isEqualToString:@"-"])
			{
                _currentNumber -= _fstOperand;
				_display.text = [NSString stringWithFormat:@"%.2f",_currentNumber];
			}
			else if([_arithmeticFlag isEqualToString:@"x"])
			{
				_currentNumber *= _fstOperand;
				_display.text = [NSString stringWithFormat:@"%.2f",_currentNumber];
			}
			else if([_arithmeticFlag isEqualToString:@"÷"])
			{
				if(_fstOperand!= 0)
				{
					_currentNumber /= _fstOperand;
					_display.text = [NSString stringWithFormat:@"%.2f",_currentNumber];
				}
				else
				{
					_display.text = @"nan";
					_arithmeticFlag= @"=";
				}
			}
			_bBegin= YES;
            
            _arithmeticFlag= arithmeticSymbol;

		}
	}
}
- (void)addDot
{
	_showFoperator.text = @".";
	
	if(![_display.text isEqualToString:@""] && ![_display.text isEqualToString:@"-"])
	{
		NSString *currentStr = _display.text;
		BOOL notDot = ([_display.text rangeOfString:@"."].location == NSNotFound);
		if (notDot)
		{
			currentStr= [currentStr stringByAppendingString:@"."];
			_display.text= currentStr;
		}
	}
}
// 数字输入方法
- (void)inputNumber: (NSString *)nbstr
{
    _backOpen = YES;
	if(_bBegin)
	{
		_showFoperator.text = @"";
		_display.text = nbstr;
	}
	else
	{
        if (![_display.text isEqualToString:@"0"]) {
            _display.text = [_display.text stringByAppendingString:nbstr];
        }
        else{
            _showFoperator.text = @"";
            _display.text = nbstr;
        }
		
	}
	_bBegin = NO;
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

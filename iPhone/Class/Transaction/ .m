//
//  TransactionCategoryViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import "TransactionCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "TransactionCategorySplitViewController.h"
#import "CategoryEditViewController.h"

#import "CategoryCell.h"
#import "Category.h"
#import "CategoryCount.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"

#import "GeneralViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface TransactionCategoryViewController ()


@end

@implementation TransactionCategoryViewController
@synthesize type;

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

    [self initNavStyle];
    [self initPint];

    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17]}];
    
    [self.tcvc_categoryTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    
    
}

-(void)cancelClick{
    if ([self.xxdDelegate respondsToSelector: @selector(returnTransactionCategoryChange)]) {
        [self.xxdDelegate returnTransactionCategoryChange];
    }
//    if (self.navigationController.topViewController == self) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];

    }
 
}

-(void)initNavStyle
{
    
//    [self.navigationController.navigationBar doSetNavigationBar];

    self.tcvc_expenseIncomeView.layer.cornerRadius = 15;
    self.tcvc_expenseIncomeView.layer.masksToBounds = YES;
    self.tcvc_expenseBtn.layer.cornerRadius = 15;
    self.tcvc_expenseBtn.layer.masksToBounds = YES;
    self.tcvc_incomeBtn.layer.cornerRadius = 15;
    self.tcvc_incomeBtn.layer.masksToBounds = YES;
    [self.tcvc_incomeBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];
    [self.tcvc_expenseBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];
    [self.tcvc_incomeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.tcvc_expenseBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    //title
//    _tcvc_headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//    [_tcvc_headLabel  setTextAlignment:NSTextAlignmentCenter];
//    [_tcvc_headLabel setTextColor:[UIColor whiteColor]];
//    [_tcvc_headLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
//    _tcvc_headLabel.backgroundColor = [UIColor clearColor];
//    _tcvc_headLabel.text = NSLocalizedString(@"VC_SelectCategories", nil);

    [_tcvc_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_tcvc_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    self.navigationItem.titleView = _tcvc_expenseIncomeView;

//    if (self.settingViewController != nil || self.tvc_payeeEditViewController != nil || self.generalViewController!=nil)
//    {
//        self.navigationItem.titleView = _tcvc_expenseIncomeView;
//        _tcvc_expenseBtn.selected = YES;
//        _tcvc_incomeBtn.selected = NO;
//    }
//    else
//        self.navigationItem.titleView = _tcvc_headLabel;
//
//    if (self.tcvc_transactionEditViewController != nil )
//    {
//        _tcvc_expenseIncomeView.hidden = YES;
//    }
//    else
//        _tcvc_expenseIncomeView.hidden = NO;
//
//
//
    //general 的时候 不需要 ＋
//    if (!_generalViewController)
//    {
//        UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
//        flexible2.width = 6.f;
//
//        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [addBtn setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
//        [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
//        self.navigationItem.rightBarButtonItems = @[flexible2,addBar];
//    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addBtnPressed:) image:[[UIImage imageNamed:@"navigation_add"] imageWithColor:RGBColor(113, 163, 245)]];
}
-(void)initPint
{
//    _lineH.constant = EXPENSE_SCALE;
//
//    [_tcvc_splitBtn setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];
//    [_tcvc_splitBtn setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateHighlighted];
    [_tcvc_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_tcvc_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    

    _tcvc_allCategoryArray = [[NSMutableArray alloc]init];
    _tcvc_justCategoryArray = [[NSMutableArray alloc]init];
    
    [_tcvc_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_tcvc_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_tcvc_splitBtn addTarget:self action:@selector(splitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.tvc_payeeEditViewController != nil || self.settingViewController != nil || self.generalViewController!=nil)
    {
//        _tvc_tabBarView.hidden = YES;
        _tableviewB.constant = 0;
        
        if (self.tvc_payeeEditViewController != nil) {
            if ([self.tvc_payeeEditViewController.categories.categoryType isEqualToString:@"EXPENSE"]) {
                _tcvc_expenseBtn.selected = YES;
                _tcvc_incomeBtn.selected = NO;
            }
            else
            {
                _tcvc_expenseBtn.selected = NO;
                _tcvc_incomeBtn.selected = YES;
            }
        }
    }
    else{
//        _tvc_tabBarView.hidden = NO;
//        _tableviewB.constant = 47;
        if (self.tcvc_transactionEditViewController != nil && self.tcvc_transactionEditViewController.incomeBtn.selected)
        {
            self.tcvc_incomeBtn.selected = YES;
            self.tcvc_expenseBtn.selected = NO;
//            self.tcvc_splitBtn.hidden = YES;
        }
        else
        {
            self.tcvc_expenseBtn.selected = YES;
            self.tcvc_incomeBtn.selected = NO;
//            self.tcvc_splitBtn.hidden = NO;

        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.categoryEditViewController =nil;
    self.transactionCategorySplitViewController = nil;
    
    if (type == TransactionIncome) {
        [self incomeBtnPressed:nil];
    }else if (type == TransactionExpense){
        [self expenseBtnPressed:nil];
    }
    
    [self getCategoryDataSource];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    if (self.tvc_payeeEditViewController != nil || self.tcvc_transactionEditViewController != nil || _generalViewController!=nil) {
//        //去掉之前的√
//        if (currentType != nil)
//        {
//            NSInteger rowIndex = [_tcvc_allCategoryArray indexOfObject:currentType];
//            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
//            checkedCell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        
//        // Set the checkmark accessory for the selected row.
//        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
//        if(self.tcvc_transactionEditViewController!=nil)
//        {
//            self.tcvc_transactionEditViewController.categories= [(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//            Category *tmpCategory = [[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//            self.tcvc_transactionEditViewController.categoryLabel.text = tmpCategory.categoryName;
//            
//        }
//        else if (self.tvc_payeeEditViewController != nil){
//            self.tvc_payeeEditViewController.categories =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//        }
//        else if (self.generalViewController != nil)
//        {
//            if (_tcvc_expenseBtn.selected)
//            {
//                self.generalViewController.defaultExpenseCategory.isDefault = NO;
//                self.generalViewController.defaultExpenseCategory.dateTime = [NSDate date];
//                
//                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//                
//                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
//                selectedCategory.dateTime = [NSDate date];
//                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//                NSError *error = nil;
//                [appDelegate.managedObjectContext save:&error];
//                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
//                
//                _generalViewController.defaultExpenseCategory = selectedCategory;
//            }
//            else
//            {
//                self.generalViewController.defaultIncomeCategory.isDefault = NO;
//                self.generalViewController.defaultIncomeCategory.dateTime = [NSDate date];
//                
//                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//                
//                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
//                selectedCategory.dateTime = [NSDate date];
//                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//                NSError *error = nil;
//                [appDelegate.managedObjectContext save:&error];
//                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
//                
//                _generalViewController.defaultIncomeCategory = selectedCategory;
//                
//            }
//        }
//        
//        // Deselect the row.
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

//-(void)setParentViewControllerCategory
//{
//    if (self.tvc_payeeEditViewController != nil || self.tcvc_transactionEditViewController != nil || _generalViewController!=nil) {
//        //去掉之前的√
//        if (currentType != nil)
//        {
//            NSInteger rowIndex = [_tcvc_allCategoryArray indexOfObject:currentType];
//            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
//            checkedCell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        
//        // Set the checkmark accessory for the selected row.
//        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
//        if(self.tcvc_transactionEditViewController!=nil)
//        {
//            self.tcvc_transactionEditViewController.categories= [(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//            Category *tmpCategory = [[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//            self.tcvc_transactionEditViewController.categoryLabel.text = tmpCategory.categoryName;
//            
//        }
//        else if (self.tvc_payeeEditViewController != nil){
//            self.tvc_payeeEditViewController.categories =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//        }
//        else if (self.generalViewController != nil)
//        {
//            if (_tcvc_expenseBtn.selected)
//            {
//                self.generalViewController.defaultExpenseCategory.isDefault = NO;
//                self.generalViewController.defaultExpenseCategory.dateTime = [NSDate date];
//                
//                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//                
//                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
//                selectedCategory.dateTime = [NSDate date];
//                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//                NSError *error = nil;
//                [appDelegate.managedObjectContext save:&error];
//                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
//                
//                _generalViewController.defaultExpenseCategory = selectedCategory;
//            }
//            else
//            {
//                self.generalViewController.defaultIncomeCategory.isDefault = NO;
//                self.generalViewController.defaultIncomeCategory.dateTime = [NSDate date];
//                
//                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
//                
//                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
//                selectedCategory.dateTime = [NSDate date];
//                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//                NSError *error = nil;
//                [appDelegate.managedObjectContext save:&error];
//                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
//                
//                _generalViewController.defaultIncomeCategory = selectedCategory;
//                
//            }
//        }
//        
//        // Deselect the row.
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

-(void)refleshUI{
    if (self.categoryEditViewController != nil) {
        [self.categoryEditViewController refleshUI];
    }
    else if (self.transactionCategorySplitViewController != nil ){
        [self.transactionCategorySplitViewController refleshUI];
    }
    else
    {
        [self getCategoryDataSource];

    }
}
#pragma mark BtnAction
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)expenseBtnPressed:(id)sender{
    _tcvc_incomeBtn.selected = NO;
    _tcvc_expenseBtn.selected = YES;
//    _tcvc_splitBtn.hidden = NO;
    
     [self getCategoryDataSource];
}

-(void)incomeBtnPressed:(id)sender{
    _tcvc_incomeBtn.selected = YES;
    _tcvc_expenseBtn.selected = NO;
//    _tcvc_splitBtn.hidden = YES;
    
    [self getCategoryDataSource];
}

-(void)splitBtnPressed:(id)sender{
     self.transactionCategorySplitViewController = [[TransactionCategorySplitViewController alloc] initWithNibName:@"TransactionCategorySplitViewController" bundle:nil];
    
    if(self.tcvc_transactionEditViewController != nil)
    {
        [self.tcvc_transactionEditViewController initAllSplitCategoryMemory];
    }
     self.transactionCategorySplitViewController.tcsvc_transactionEditViewController = self.tcvc_transactionEditViewController;
    [self.navigationController pushViewController:self.transactionCategorySplitViewController animated:YES];
    

}

-(void)addBtnPressed:(id)sender{
    self.categoryEditViewController =[[CategoryEditViewController alloc] initWithNibName:@"CategoryEditViewController" bundle:nil];
	self.categoryEditViewController.editModule = @"ADD";
    //由编辑payee进来的
    if (_tvc_payeeEditViewController != nil)
    {
        _categoryEditViewController.payeeEditViewController = _tvc_payeeEditViewController;
    }
    //由编辑transaction进来的
    else if (_tcvc_transactionEditViewController != nil)
        _categoryEditViewController.transactionEditViewController =  _tcvc_transactionEditViewController;
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.categoryEditViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    

}

-(void)getCategoryDataSource{
    
    [_tcvc_allCategoryArray removeAllObjects];
    [_tcvc_justCategoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *fetchName = @"";
 	if(_tcvc_expenseBtn.selected)
    {
        fetchName = @"fetchCategoryByExpenseType";
    }
    else
    {
        fetchName = @"fetchCategoryByIncomeType";
        
    }
	
    NSError *error = nil;
	NSDictionary *subs = [[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
    [_tcvc_justCategoryArray setArray:tmpCategoryArray];

    
	for (int i =0; i<[tmpCategoryArray count];i++)
    {
		Category *c = [tmpCategoryArray objectAtIndex:i];
		CategoryCount *cc = [[CategoryCount alloc] init];
		cc.categoryItem = c ;
        cc.pcType = noneType;
		
        cc.cateName = c.categoryName;
        
 		NSString *searchForMe = @":";
		NSRange range = [c.categoryName rangeOfString : searchForMe];
		
		if (range.location != NSNotFound)
        {
			NSArray * seprateSrray = [c.categoryName componentsSeparatedByString:@":"];
			NSString *parName = [seprateSrray objectAtIndex:0];
			
			NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
			
            //找到父类的category
			NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
			[fetchRequest setSortDescriptors:sortDescriptors];
            
			NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
			
 			NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
			

            
            //如果当前这个category有父类的category
			if([tmpParCategoryArray count]>0)
			{
				Category *pc =  [tmpParCategoryArray lastObject];
				BOOL isFound = FALSE;
				
                //查询数组中有没有这个父类，有的话，就将找到的这个category设为父类
				for (int j=0; j<[_tcvc_allCategoryArray count]; j++)
				{
					CategoryCount *tmpCC = [_tcvc_allCategoryArray objectAtIndex:j];
					
					if(pc == tmpCC.categoryItem)
					{
                        tmpCC.pcType = parentWithChild;
                        
						isFound = TRUE;
						break;
					}
				}
				
                //如果没找到父类。那么就创建一个父类
				if(!isFound)
				{
					CategoryCount *tmpCC = [[CategoryCount alloc] init];
					tmpCC.categoryItem = pc ;
                    tmpCC.pcType = parentWithChild;
                    tmpCC.cateName = pc.categoryName;
					tmpCC.cellHeight = 44.0;
					[_tcvc_allCategoryArray addObject:tmpCC];
				}
				
			}
            //将当前判断的category设为子类
            cc.pcType = childOnly;
            cc.cateName = [NSString stringWithFormat:@"-%@",[seprateSrray objectAtIndex:1]];
            
			cc.cellHeight = 38.0;
		}
		else
        {
            cc.pcType = parentNoChild;
			cc.cellHeight = 44.0;
		}
        
 		[_tcvc_allCategoryArray addObject:cc];
	}
	
    [_tcvc_categoryTableView reloadData];

    //移动tableview
    NSIndexPath *jumpIndexPath = nil;
    if (_tcvc_transactionEditViewController != nil && _tcvc_transactionEditViewController.categories != nil)
    {
        for(int i=0;i<[_tcvc_allCategoryArray count];i++)
        {
            CategoryCount *tmpCategory = [_tcvc_allCategoryArray objectAtIndex:i];
            if (tmpCategory.categoryItem == _tcvc_transactionEditViewController.categories)
            {
                jumpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
        
        [_tcvc_categoryTableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    else if (_tvc_payeeEditViewController != nil && _tvc_payeeEditViewController.categories != nil)
    {
        for(int i=0;i<[_tcvc_allCategoryArray count];i++)
        {
            CategoryCount *tmpCategory = [_tcvc_allCategoryArray objectAtIndex:i];
            if (tmpCategory.categoryItem == _tvc_payeeEditViewController.categories)
            {
                jumpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
        
        [_tcvc_categoryTableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}

- (void)getDataSouce
{
    [_tcvc_allCategoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *fetchName = @"";
 	if(_tcvc_expenseBtn.selected)
    {
        fetchName = @"fetchCategoryByExpenseType";
    }
    else
    {
        fetchName = @"fetchCategoryByIncomeType";
        
    }
	
    NSError *error = nil;
	NSDictionary *subs = [[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];

    
	for (int i =0; i<[tmpCategoryArray count];i++)
    {
		Category *c = [tmpCategoryArray objectAtIndex:i];
		CategoryCount *cc = [[CategoryCount alloc] init];
		cc.categoryItem = c ;
        cc.pcType = noneType;
		
        cc.cateName = c.categoryName;
        
 		NSString *searchForMe = @":";
		NSRange range = [c.categoryName rangeOfString : searchForMe];
		
		if (range.location != NSNotFound)
        {
			NSArray * seprateSrray = [c.categoryName componentsSeparatedByString:@":"];
			NSString *parName = [seprateSrray objectAtIndex:0];
			
			NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
			
            //找到父类的category
			NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
			[fetchRequest setSortDescriptors:sortDescriptors];
            
			NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
			
 			NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
			

            
            //如果当前这个category有父类的category
			if([tmpParCategoryArray count]>0)
			{
				Category *pc =  [tmpParCategoryArray lastObject];
				BOOL isFound = FALSE;
				
                //查询数组中有没有这个父类，有的话，就将找到的这个category设为父类
				for (int j=0; j<[_tcvc_allCategoryArray count]; j++)
				{
					CategoryCount *tmpCC = [_tcvc_allCategoryArray objectAtIndex:j];
					
					if(pc == tmpCC.categoryItem)
					{
                        tmpCC.pcType = parentWithChild;
                        
						isFound = TRUE;
						break;
					}
				}
				
                //如果没找到父类。那么就创建一个父类
				if(!isFound)
				{
					CategoryCount *tmpCC = [[CategoryCount alloc] init];
					tmpCC.categoryItem = pc ;
                    tmpCC.pcType = parentWithChild;
                    tmpCC.cateName = pc.categoryName;
					tmpCC.cellHeight = 44.0;
					[_tcvc_allCategoryArray addObject:tmpCC];
				}
				
			}
            //将当前判断的category设为子类
            cc.pcType = childOnly;
            cc.cateName = [NSString stringWithFormat:@"-%@",[seprateSrray objectAtIndex:1]];
            
			cc.cellHeight = 38.0;
		}
		else
        {
            cc.pcType = parentNoChild;
			cc.cellHeight = 44.0;
		}
        
 		[_tcvc_allCategoryArray addObject:cc];
	}
	
	
}

#pragma mark Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tcvc_allCategoryArray count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"categoryCell";
	
 	CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	

	if (cell == nil)
	{
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:nil options:nil]lastObject];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
	}
    
	CategoryCount *cc = (CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;
    
    cell.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1];
    //child
	if(cc.cellHeight == 38.0)
	{
        cell.iconX.constant = 49;
        cell.nameX.constant = 83;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
        
		if(![categories.isSystemRecord boolValue])
		{
			cell.accessoryType = UITableViewCellAccessoryDetailButton;
			cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
		}
		else
        {
			cell.accessoryType = UITableViewCellAccessoryNone;
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}
		
        cell.nameLabel.text = cc.categoryItem.categoryName;
        
        //给选中的cell做标记
        if (cc.categoryItem == self.tcvc_transactionEditViewController.categories)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else if (_generalViewController != nil)
        {
            if(cc.categoryItem == _generalViewController.defaultExpenseCategory && _tcvc_expenseBtn.selected )
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else if (cc.categoryItem == _generalViewController.defaultIncomeCategory && _tcvc_incomeBtn.selected)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        
        if (indexPath.row == [_tcvc_allCategoryArray count]-1)
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 83;
        
		return cell;
	}
    //parent
	else
    {
        cell.iconX.constant = 10;
        cell.nameX.constant = 46;
        if(![categories.isSystemRecord boolValue])
        {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
            
        }
        
        cell.nameLabel.text = categories.categoryName;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
        
        
        if (_tcvc_categoryTableView  .editing)
        {
            cell.thisCellisEdit = YES;
            cell.thisCellisEdit = YES;
            
        }
        else{
            cell.thisCellisEdit = NO;
            cell.thisCellisEdit = NO;
        }
        
        //给选中的category做标记
        if (cc.categoryItem == self.tcvc_transactionEditViewController.categories)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else if (_generalViewController != nil)
        {
            if(cc.categoryItem == _generalViewController.defaultExpenseCategory && _tcvc_expenseBtn.selected )
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else if (cc.categoryItem == _generalViewController.defaultIncomeCategory && _tcvc_incomeBtn.selected)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if (indexPath.row == [_tcvc_allCategoryArray count]-1)
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 46;
        
        if (self.tvc_payeeEditViewController  != nil)
        {
            if (self.tvc_payeeEditViewController.categories == categories)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    }
	
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 56;
}

////add index table
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	Category *categories = [tcvc_justCategoryArray objectAtIndex:section];
//    NSString *key = categories.categoryName;
//    return key;
//    
//}
//设置表格的索引数组
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    return tcvc_justCategoryArray;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *currentType;
    if(self.tcvc_transactionEditViewController!=nil)
    {
        currentType=self.tcvc_transactionEditViewController.categories;
        
    }
    else if (self.tvc_payeeEditViewController != nil){
        currentType = self.tvc_payeeEditViewController.categories;
    }
    //点击的话  需不需要加上 编辑category
    else if (self.settingViewController != nil){
        ;
        
    }
    else if (self.generalViewController != nil)
    {
        if (_tcvc_expenseBtn.selected)
        {
            currentType =  self.generalViewController.defaultExpenseCategory;
        }
        else
            currentType = self.generalViewController.defaultIncomeCategory;
    }
  
    
	
    if (self.tvc_payeeEditViewController != nil || self.tcvc_transactionEditViewController != nil || _generalViewController!=nil)
    {
        //去掉之前的√
        if (currentType != nil)
        {
            NSInteger rowIndex = [_tcvc_allCategoryArray indexOfObject:currentType];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
            checkedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // Set the checkmark accessory for the selected row.
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        if(self.tcvc_transactionEditViewController!=nil)
        {
            self.tcvc_transactionEditViewController.categories= [(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
            Category *tmpCategory = [[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
            self.tcvc_transactionEditViewController.categoryLabel.text = tmpCategory.categoryName;
            
        }
        else if (self.tvc_payeeEditViewController != nil)
        {
            self.tvc_payeeEditViewController.categories =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
        }
        else if (self.generalViewController != nil)
        {
            if (_tcvc_expenseBtn.selected)
            {
                self.generalViewController.defaultExpenseCategory.isDefault = NO;
                self.generalViewController.defaultExpenseCategory.dateTime = [NSDate date];
                
                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
                
                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
                selectedCategory.dateTime = [NSDate date];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSError *error = nil;
                [appDelegate.managedObjectContext save:&error];
                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:self.generalViewController.defaultExpenseCategory];
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:selectedCategory];
                    
                }
                
                _generalViewController.defaultExpenseCategory = selectedCategory;
            }
            else
            {
                self.generalViewController.defaultIncomeCategory.isDefault = NO;
                self.generalViewController.defaultIncomeCategory.dateTime = [NSDate date];
                
                Category *selectedCategory =[(CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
                
                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
                selectedCategory.dateTime = [NSDate date];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSError *error = nil;
                [appDelegate.managedObjectContext save:&error];
                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.generalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:self.generalViewController.defaultExpenseCategory];
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:selectedCategory];
                    
                }
                _generalViewController.defaultIncomeCategory = selectedCategory;

            }
        }
        
        // Deselect the row.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
	
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	CategoryCount *cc = (CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *tmpCategory = cc.categoryItem;
    
 	if([tmpCategory.isSystemRecord boolValue])
        return;
    CategoryEditViewController *editController =[[CategoryEditViewController alloc] initWithNibName:@"CategoryEditViewController" bundle:nil];
    
	editController.categories = tmpCategory;
	editController.editModule = @"EDIT";
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:editController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
//	[self.navigationController pushViewController:editController animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FALSE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCount *cc = (CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;
    if (categories == self.tcvc_transactionEditViewController.categories) {
        return UITableViewCellAccessoryNone;
    }
    else
        return UITableViewCellEditingStyleDelete;
}

//除了 setting中的 category，不可以删除category
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	CategoryCount *cc = (CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *tmpCategory = cc.categoryItem;
    
    NSString *msg;
    
    NSMutableString *string1 = nil;
    if(cc.pcType == parentWithChild)
    {
        
        string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete all its transactions, sub-categories ,related bills and budgets.", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpCategory.categoryName];
        msg = string1;
    }
    else
    {
        
        string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete all its transactions, related bills and budgets.", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpCategory.categoryName];
        msg = string1;

        
    }
	
	if(editingStyle == UITableViewCellEditingStyleDelete)
	{
		UIActionSheet *actionSheet= [[UIActionSheet alloc]
									 initWithTitle:msg
									 delegate:self
									 cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
									 destructiveButtonTitle:NSLocalizedString(@"VC_Remove", nil)
									 otherButtonTitles:nil,
									 nil];
		[actionSheet showInView:self.view];
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionSheet;
	
		deleteIndex = indexPath.row;
	}
    
}

#pragma mark UIActionSheet DeleteCategory
//删除单个没有子类category
/*
-(void)deleteCategoryAndRelation:(Category*) category
{
 	
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	
	NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[category.transactions allObjects]];
	
    //save local trans state=0
    for (int i=0; i<[tmpTransactionArray count]; i++)
	{
		Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime_sync = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
    
    //update local->server,delete local trans
    if (appDelegate_iPhone.dropbox.drop_account.linked)
    {
        for (int i=0; i<[tmpTransactionArray count]; i++)
        {
            Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:deleteLog];
        }
    }
	
    
    //set budget
//	if(category.budgetTemplate!=nil){
//        BudgetTemplate *oneBudgetTemplate = category.budgetTemplate;
//        oneBudgetTemplate.state = @"0";
//        oneBudgetTemplate.dateTime = [NSDate date];
//        if (![appDelegate.managedObjectContext save:&error]) {
//            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
//            
//        }
//        //更新budget
//        if (appDelegate_iPhone.dropbox.drop_account.linked){
//            ////这里还需要写东西
//        }
//        
//        [appDelegate.managedObjectContext deleteObject:category.budgetTemplate];
//        
//    }
	
	//注意：这里直接将所有的bill删除了，后期做同步的时候，需要更改
    NSMutableArray *billArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billArray count]; i++)
    {
        EP_BillRule *deleteLog = (EP_BillRule *)[billArray objectAtIndex:i];
        deleteLog.dateTime = [NSDate date];
        deleteLog.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
        
        //add
        if (appDelegate.dropbox.drop_account.linked){
            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:deleteLog];
        }
        //delete
//        [appDelegate.managedObjectContext deleteObject:deleteLog];
    }
    [appDelegate.managedObjectContext save:&error];
    
    NSMutableArray *billItemArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billItemArray count]; i++)
    {
        EP_BillItem *deleteLog = (EP_BillItem *)[billItemArray objectAtIndex:i];
        deleteLog.dateTime = [NSDate date];
        deleteLog.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
        //add
        if (appDelegate.dropbox.drop_account.linked){
            [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteLog];
        }
        //delete
//        [appDelegate.managedObjectContext deleteObject:deleteLog];
    }
    [appDelegate.managedObjectContext save:&error];
	
	
	BudgetTemplate *tmpBudget = category.budgetTemplate;
	if(tmpBudget!=nil)
	{
		NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[tmpBudget.budgetItems allObjects]];
		if(budgetItemArray.count > 0)
		{
			for (int i=0; i<[budgetItemArray count]; i++)
			{
				BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
				
				NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
				for (int j=0; j<[fromTransferArray count]; j++)
				{
					BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
                    //add
                    fromT.dateTime_sync = [NSDate date];
                    fromT.state = @"0";
                    [appDelegate.managedObjectContext save:&error];
                    
                    if (appDelegate.dropbox.drop_account.linked){
                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
                    }
                    //delete
//					[fromT.toBudget removeFromTransferObject:fromT];
//					[appDelegate.managedObjectContext deleteObject:fromT];
					
				}
				
				NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
				for (int j=0; j<[toTransferArray count]; j++)
				{
					BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                    
                    //add
                    toT.dateTime_sync = [NSDate date];
                    toT.state = @"0";
                    [appDelegate.managedObjectContext save:&error];
                    if (appDelegate.dropbox.drop_account.linked)
                    {
                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:toT];
                    }
                    //delete
//					[toT.fromBudget removeToTransferObject:toT];
//					[appDelegate.managedObjectContext deleteObject:toT];
					
				}
				
                //add
                object.dateTime = [NSDate date];
                object.state = @"0";
                [appDelegate.managedObjectContext save:&error];
                if (appDelegate.dropbox.drop_account.linked)
                {
                    [appDelegate.dropbox updateEveryBudgetItemDataFromLocal:object];
                }
                //delete
//				[appDelegate.managedObjectContext deleteObject:object];
			}
		}
        
        //add
        tmpBudget.dateTime = [NSDate date];
        tmpBudget.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        if (appDelegate.dropbox.drop_account.linked)
        {
            [appDelegate.dropbox updateEveryBudgetTemplateDataFromLocal:tmpBudget];
        }
        //delete
//		[appDelegate.managedObjectContext deleteObject:tmpBudget];
	}
    
	category.others = @"";
    
    category.state = @"0";
    category.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    if (appDelegate_iPhone.dropbox.drop_account.linked)
    {
        [appDelegate_iPhone.dropbox updateEveryCategoryDataFromLocal:category];
        [appDelegate.managedObjectContext deleteObject:category];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
	
}
*/

//获取下一个parentCategory
-(NSInteger)getNextParentCategoryIndexFromDeleteIndex
{
    
 	for (long i=deleteIndex+1; i<[_tcvc_allCategoryArray count];i ++) {
		
		CategoryCount *cc =[_tcvc_allCategoryArray objectAtIndex:i];
		
		if(cc.pcType == parentWithChild || cc.pcType == parentNoChild)
		{
			return i;
		}
	}
	
	return deleteIndex;
}


//删除有交易的category
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
        return;
    
    
    //获取要删除的category
	CategoryCount *cc = (CategoryCount *)[_tcvc_allCategoryArray objectAtIndex:deleteIndex];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (self.tcvc_transactionEditViewController != nil) {
        if (cc.categoryItem==self.tcvc_transactionEditViewController.categories) {
            self.tcvc_transactionEditViewController.categories = nil;
        }
        
    }
        //如果这个category是parentCategory
 	if(cc.pcType == parentWithChild)
	{
        
        //之前的categoryArray是获取所有category,包括childCategory,因为他们和parentCategory平级
        //获取下一个ParentCategory的Index
		NSInteger endOfCycle =[self getNextParentCategoryIndexFromDeleteIndex];
		if(endOfCycle == deleteIndex)
		{
			endOfCycle =[_tcvc_allCategoryArray count];
		}
		
        //删掉这个 parentCategory旗下的所有子category
		for (long i=deleteIndex; i<endOfCycle;i ++)
		{
			CategoryCount *cc1 =[_tcvc_allCategoryArray objectAtIndex:i];
 			
//			[self deleteCategoryAndRelation:cc1.categoryItem];
            [appDelegate.epdc deleteCategoryAndRelation:cc1.categoryItem];
            
		}
		
	}
	else
	{
//		[self deleteCategoryAndRelation:cc.categoryItem];
        [appDelegate.epdc deleteCategoryAndRelation:cc.categoryItem];

	}

    [self getDataSouce];
    [self.tcvc_categoryTableView reloadData];
}

-(void)dealloc
{
    _tcvc_categoryTableView.delegate = nil;
    _tcvc_categoryTableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

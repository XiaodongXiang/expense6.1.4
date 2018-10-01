//
//  TransactionCategoryViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import "ipad_TranscationCategorySelectViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "ipad_TransacationSplitViewController.h"
#import "ipad_CategoryEditViewController.h"
#import "ipad_SettingPayeeEditViewController.h"
#import "ipad_BillEditViewController.h"
#import "ipad_SettingViewController.h"

#import "ipad_CategoryCell.h"
#import "Category.h"
#import "CategoryCount.h"
#import "iPad_GeneralViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface ipad_TranscationCategorySelectViewController ()

@end

@implementation ipad_TranscationCategorySelectViewController

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
    
}


-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_icon_back_30_30"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ];
    
    _tcvc_headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [_tcvc_headLabel  setTextAlignment:NSTextAlignmentCenter];
	[_tcvc_headLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [_tcvc_headLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    _tcvc_headLabel.backgroundColor = [UIColor clearColor];
    _tcvc_headLabel.text = NSLocalizedString(@"VC_SelectCategories", nil);
    
    if (self.settingViewController != nil || self.payeeEditViewController != nil || self.genetalViewController != nil)
    {
        self.navigationItem.titleView = _tcvc_expenseIncomeView;
        _tcvc_expenseBtn.selected = YES;
        _tcvc_incomeBtn.selected = NO;
    }
    else
        self.navigationItem.titleView = _tcvc_headLabel;
    
    if (self.transactionEditViewController != nil )
    {
        _tcvc_expenseIncomeView.hidden = YES;
    }
    else
        _tcvc_expenseIncomeView.hidden = NO;
    
    
    if (!self.genetalViewController)
    {
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [addBtn setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
        self.navigationItem.rightBarButtonItems = @[flexible2,addBar];
    }
    


}
-(void)initPint{
     
    [_tcvc_splitBtn setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];
    [_tcvc_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_tcvc_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    
    tcvc_allCategoryArray = [[NSMutableArray alloc]init];
    tcvc_justCategoryArray = [[NSMutableArray alloc]init];
    
    [_tcvc_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_tcvc_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_tcvc_splitBtn addTarget:self action:@selector(splitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.payeeEditViewController != nil || self.settingViewController != nil || self.genetalViewController != nil) {
        _tvc_tabBarView.hidden = YES;
        _tcvc_categoryTableView.frame = self.view.frame;
        
        if (self.payeeEditViewController != nil) {
            if ([self.payeeEditViewController.categories.categoryType isEqualToString:@"EXPENSE"]) {
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
        _tvc_tabBarView.hidden = NO;
        _tcvc_categoryTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-47);
        if (self.transactionEditViewController != nil && self.transactionEditViewController.incomeBtn.selected)
        {
            self.tcvc_incomeBtn.selected = YES;
            self.tcvc_expenseBtn.selected = NO;
            self.tcvc_splitBtn.hidden = YES;
        }
        else
        {
            self.tcvc_expenseBtn.selected = YES;
            self.tcvc_incomeBtn.selected = NO;
            self.tcvc_splitBtn.hidden = NO;
            
        }
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getCategoryDataSource];
}

-(void)refleshUI{
    if (self.categoryEditViewController != nil) {
        [self.categoryEditViewController refleshUI];
    }
    else if (self.transactionCategorySplitViewController != nil ){
        [self.transactionCategorySplitViewController refleshUI];
    }
    else
    {
//        self.categoryEditViewController =nil;
//        self.transactionCategorySplitViewController = nil;
        [self getCategoryDataSource];
        
        
    }
}
#pragma mark BtnAction
-(void)back:(id)sender{
    _tcvc_categoryTableView.delegate = nil;
    _tcvc_categoryTableView.dataSource = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)expenseBtnPressed:(id)sender{
    _tcvc_incomeBtn.selected = NO;
    _tcvc_expenseBtn.selected = YES;
    _tcvc_splitBtn.hidden = NO;
    
    [self getCategoryDataSource];
}

-(void)incomeBtnPressed:(id)sender{
    _tcvc_incomeBtn.selected = YES;
    _tcvc_expenseBtn.selected = NO;
    _tcvc_splitBtn.hidden = YES;
    
    [self getCategoryDataSource];
}

-(void)splitBtnPressed:(id)sender{
    self.transactionCategorySplitViewController = [[ipad_TransacationSplitViewController alloc] initWithNibName:@"ipad_TransacationSplitViewController" bundle:nil];
    
    if(self.transactionEditViewController != nil)
    {
        [self.transactionEditViewController initAllSplitCategoryMemory];
    }
    self.transactionCategorySplitViewController.iTransactionEditViewController = self.transactionEditViewController;
    [self.navigationController pushViewController:self.transactionCategorySplitViewController animated:YES];
    
    
}

-(void)addBtnPressed:(id)sender{
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];

    self.categoryEditViewController =[[ipad_CategoryEditViewController alloc] initWithNibName:@"ipad_CategoryEditViewController" bundle:nil];
	self.categoryEditViewController.editModule = @"ADD";
    
    //由编辑payee进来的
    if (_payeeEditViewController != nil)
    {
        _categoryEditViewController.payeeEditViewController = _payeeEditViewController;
    }
    //由编辑transaction进来的
    else if (_transactionEditViewController != nil)
        _categoryEditViewController.transactionEditViewController = _transactionEditViewController;

    _categoryEditViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController pushViewController:self.categoryEditViewController animated:YES];
    appDelegate1.mainViewController.popViewController = _categoryEditViewController;
}

-(void)getCategoryDataSource{
    
    [tcvc_allCategoryArray removeAllObjects];
    [tcvc_justCategoryArray removeAllObjects];
    
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
    [tcvc_justCategoryArray setArray:tmpCategoryArray];

    
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
				for (int j=0; j<[tcvc_allCategoryArray count]; j++)
				{
					CategoryCount *tmpCC = [tcvc_allCategoryArray objectAtIndex:j];
					
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
					[tcvc_allCategoryArray addObject:tmpCC];
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
        
 		[tcvc_allCategoryArray addObject:cc];
	}
	
	
    [_tcvc_categoryTableView reloadData];
    //移动tableview
    NSIndexPath *jumpIndexPath = nil;
    if (_transactionEditViewController != nil && _transactionEditViewController.categories != nil)
    {
        for(int i=0;i<[tcvc_allCategoryArray count];i++)
        {
            CategoryCount *tmpCategory = [tcvc_allCategoryArray objectAtIndex:i];
            if (tmpCategory.categoryItem == _transactionEditViewController.categories)
            {
                jumpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
        
        [_tcvc_categoryTableView scrollToRowAtIndexPath:jumpIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    else if (_payeeEditViewController != nil && _payeeEditViewController.categories != nil)
    {
        for(int i=0;i<[tcvc_allCategoryArray count];i++)
        {
            CategoryCount *tmpCategory = [tcvc_allCategoryArray objectAtIndex:i];
            if (tmpCategory.categoryItem == _payeeEditViewController.categories)
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
    [tcvc_allCategoryArray removeAllObjects];
    
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
				for (int j=0; j<[tcvc_allCategoryArray count]; j++)
				{
					CategoryCount *tmpCC = [tcvc_allCategoryArray objectAtIndex:j];
					
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
					[tcvc_allCategoryArray addObject:tmpCC];
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
        
 		[tcvc_allCategoryArray addObject:cc];
	}
	
	
}

#pragma mark Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tcvc_allCategoryArray count];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"CellPar";
	static NSString *CellIdentifierChild = @"CellChild";
	
 	ipad_CategoryCell *cellPar = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	ipad_CategoryCell *cellChild = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierChild];
	
	if (cellPar == nil)
	{
		cellPar = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPar];
		cellPar.selectionStyle = UITableViewCellSelectionStyleDefault;
 		cellPar.bgImageView.frame = CGRectMake(0, 0, 320,44.0);
		cellPar.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
        
 		cellPar.subShadowImageView.hidden = YES;
        
        
        cellPar.editingAccessoryType = UITableViewCellAccessoryDetailButton;
	}
    
	if (cellChild == nil)
	{
		cellChild = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierChild] ;
		cellChild.selectionStyle = UITableViewCellSelectionStyleDefault;
 		cellChild.bgImageView.frame = CGRectMake(0, 0, 320,38);
		cellChild.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
  		cellChild.subShadowImageView.hidden = YES;
        cellChild.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        
	}
    
	CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;

    //配置子category
	if(cc.cellHeight == 38.0)
	{
        cellChild.headImageView.frame = CGRectMake(49, 7, 28, 28);
        cellChild.nameLabel.frame = CGRectMake(83, 0, 150, 44);
        
        cellChild.headImageView.image = [UIImage imageNamed:categories.iconName];
		NSInteger tmpIndex =indexPath.row-1;
 		
		if(tmpIndex>=0&&tmpIndex<[tcvc_allCategoryArray count])
		{
			CategoryCount *tmpcc =[tcvc_allCategoryArray objectAtIndex:tmpIndex];
            
			if(tmpcc.pcType == parentWithChild )
			{
                //父级
                
				cellChild.subShadowImageView.hidden = NO;
			}
			else
            {
				cellChild.subShadowImageView.hidden = YES;
			}
            
		}
		else
        {
			cellChild.subShadowImageView.hidden = YES;
			
		}
        
        
        
		if(![categories.isSystemRecord boolValue])
		{
			cellChild.accessoryType = UITableViewCellAccessoryDetailButton;
			cellChild.editingAccessoryType = UITableViewCellAccessoryDetailButton;
		}
		else {
			cellChild.accessoryType = UITableViewCellAccessoryNone;
            cellChild.editingAccessoryType = UITableViewCellAccessoryNone;
            
		}
		
        cellChild.nameLabel.text = cc.cateName;
        
        //给选中的cell做标记
        if (cc.categoryItem == self.transactionEditViewController.categories) {
            cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (_genetalViewController != nil)
        {
            if(cc.categoryItem == _genetalViewController.defaultExpenseCategory && _tcvc_expenseBtn.selected )
            {
                cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else if (cc.categoryItem == _genetalViewController.defaultIncomeCategory && _tcvc_incomeBtn.selected)
                cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }

        
        if (indexPath.row == [tcvc_allCategoryArray count]-1) {
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
            
        }
        else{
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
        }
        
		return cellChild;
	}
	
	cellPar.subShadowImageView.hidden = YES;
	if(![categories.isSystemRecord boolValue])
	{
		cellPar.accessoryType = UITableViewCellAccessoryDetailButton;
        cellPar.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        
	}
	else {
		cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
        
	}
	
	cellPar.nameLabel.text = categories.categoryName;
	cellPar.headImageView.image = [UIImage imageNamed:categories.iconName];
	
    
    if (_tcvc_categoryTableView  .editing) {
        cellPar.thisCellisEdit = YES;
        cellChild.thisCellisEdit = YES;
        
    }
    else{
        cellPar.thisCellisEdit = NO;
        cellChild.thisCellisEdit = NO;
    }
    
    //给选中的category做标记
    if (cc.categoryItem == self.transactionEditViewController.categories) {
        cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if (_genetalViewController != nil)
    {
        if(cc.categoryItem == _genetalViewController.defaultExpenseCategory && _tcvc_expenseBtn.selected )
        {
            cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (cc.categoryItem == _genetalViewController.defaultIncomeCategory && _tcvc_incomeBtn.selected)
            cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
    if (indexPath.row == [tcvc_allCategoryArray count]-1) {
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        
    }
    else{
        cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
    }
    
    if (self.payeeEditViewController  != nil) {
        if (self.payeeEditViewController.categories == categories) {
            cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
            cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cellPar.accessoryType = UITableViewCellAccessoryNone;
            cellChild.accessoryType = UITableViewCellAccessoryNone;
        }
    }
	return cellPar;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
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
    if(self.transactionEditViewController!=nil)
    {
        currentType=self.transactionEditViewController.categories;
        
    }
    else if (self.payeeEditViewController != nil){
        currentType = self.payeeEditViewController.categories;
    }
    else if (self.genetalViewController != nil)
    {
        if (_tcvc_expenseBtn.selected)
        {
            currentType = self.genetalViewController.defaultExpenseCategory;
        }
        else
            currentType = self.genetalViewController.defaultIncomeCategory;
    }
    //点击的话  需不需要加上 编辑category
    else if (self.settingViewController != nil){
        ;
        
    }
    
    
	
    if (self.payeeEditViewController != nil || self.transactionEditViewController != nil || self.genetalViewController != nil) {
        //去掉之前的√
        if (currentType != nil)
        {
            NSInteger rowIndex = [tcvc_allCategoryArray indexOfObject:currentType];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
            checkedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // Set the checkmark accessory for the selected row.
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        if(self.transactionEditViewController!=nil)
        {
            self.transactionEditViewController.categories= [(CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
            Category *tmpCategory = [[tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
            self.transactionEditViewController.categoryLabel.text = tmpCategory.categoryName;
            
        }
        else if (self.payeeEditViewController != nil){
            self.payeeEditViewController.categories =[(CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
        }
        else if (self.genetalViewController != nil)
        {
            if (_tcvc_expenseBtn.selected)
            {
                self.genetalViewController.defaultExpenseCategory.isDefault = NO;
                self.genetalViewController.defaultExpenseCategory.dateTime = [NSDate date];
                
                Category *selectedCategory =[(CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
                
                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
                selectedCategory.dateTime = [NSDate date];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSError *error = nil;
                [appDelegate.managedObjectContext save:&error];
                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.genetalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:self.genetalViewController.defaultExpenseCategory];
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:selectedCategory];
                }
                _genetalViewController.defaultExpenseCategory = selectedCategory;
            }
            else
            {
                self.genetalViewController.defaultIncomeCategory.isDefault = NO;
                self.genetalViewController.defaultIncomeCategory.dateTime = [NSDate date];
                
                Category *selectedCategory =[(CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row] categoryItem];
                
                selectedCategory.isDefault = [NSNumber numberWithBool:YES];
                selectedCategory.dateTime = [NSDate date];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSError *error = nil;
                [appDelegate.managedObjectContext save:&error];
                
//                if (appDelegate.dropbox.drop_account)
//                {
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:self.genetalViewController.defaultExpenseCategory];
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:selectedCategory];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:self.genetalViewController.defaultExpenseCategory];
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:selectedCategory];
                }
                _genetalViewController.defaultIncomeCategory = selectedCategory;

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
	CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *tmpCategory = cc.categoryItem;
    
 	if([tmpCategory.isSystemRecord boolValue])
        return;
    ipad_CategoryEditViewController *editController =[[ipad_CategoryEditViewController alloc] initWithNibName:@"ipad_CategoryEditViewController" bundle:nil];
    
	editController.categories = tmpCategory;
	editController.editModule = @"EDIT";
    
//    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:editController];
//    navigationViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigationViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    navigationViewController.view.backgroundColor = [UIColor clearColor];
	[self.navigationController pushViewController:editController animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FALSE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;
    if (categories == self.transactionEditViewController.categories) {
        return UITableViewCellAccessoryNone;
    }
    else
        return UITableViewCellEditingStyleDelete;
 	return UITableViewCellEditingStyleDelete;
}

//除了 setting中的 category，不可以删除category
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:indexPath.row];
	Category *tmpCategory = cc.categoryItem;
    
    NSString *msg;
    
    if(cc.pcType == parentWithChild)
    {
//        msg=       [NSString stringWithFormat:@"Delete %@ will cause to also delete all its transactions, sub-categories ,related bills and budgets.",tmpCategory.categoryName];
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete all its transactions, sub-categories ,related bills and budgets.", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpCategory.categoryName];
        msg = string1;
        
    }
    else
    {
//        msg=       [NSString stringWithFormat:@"Delete %@ will cause to also delete all its transactions, related bills and budgets.",tmpCategory.categoryName];
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete all its transactions, related bills and budgets.", nil)];
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
		
        UITableViewCell *selectedCell = [_tcvc_categoryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        CGPoint point1 = [_tcvc_categoryTableView convertPoint:selectedCell.frame.origin toView:self.view];
        [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view
                         animated:YES];
        
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionSheet;
		deleteIndex = indexPath.row;
	}
}

#pragma mark UIActionSheet DeleteCategory
/*
//删除单个没有子类category
-(void)deleteCategoryAndRelation:(Category*) category
{
 	
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
	
	NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[category.transactions allObjects]];
	
    //save local trans state=0
    for (int i=0; i<[tmpTransactionArray count]; i++)
	{
		Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime_sync = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
    
    //update local->server,delete local trans
    if (appDelegate.dropbox.drop_account.linked) {
        for (int i=0; i<[tmpTransactionArray count]; i++)
        {
            Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
            [appDelegate.dropbox updateEveryTransactionDataFromLocal:deleteLog];
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
//        if (appDelegate.dropbox.drop_account.linked){
//            ////这里还需要写东西
//        }
//        
//        [appDelegate.managedObjectContext deleteObject:category.budgetTemplate];
//        
//    }
	
	
    //注意：下次做同步的时候，这里需要修改。直接删除bill,没有做保存。bill,以及billitem
    NSMutableArray *billArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billArray count]; i++)
    {
        EP_BillRule *deleteLog = (EP_BillRule *)[billArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        
        if (appDelegate.dropbox.drop_account)
        {
            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:deleteLog];
        }
    }
    
    NSMutableArray *billItemArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billItemArray count]; i++)
    {
        EP_BillItem *deleteLog = (EP_BillItem *)[billItemArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        
        if (appDelegate.dropbox.drop_account)
        {
            [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteLog];
        }
    }
	
	
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
                    fromT.state = @"0";
                    fromT.dateTime_sync = [NSDate date];
                    [appDelegate.managedObjectContext save:&error];
                    
                    if (appDelegate.dropbox.drop_account)
                    {
                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
                    }
				}
				
				NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
				for (int j=0; j<[toTransferArray count]; j++)
				{
					BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                    toT.state = @"0";
                    toT.dateTime_sync = [NSDate date];
                    [appDelegate.managedObjectContext save:&error];
                    
                    if (appDelegate.dropbox.drop_account)
                    {
                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:toT];
                    }

				}
				
                object.state = @"0";
                object.dateTime = [NSDate date];
                [appDelegate.managedObjectContext save:&error];
                
                if (appDelegate.dropbox.drop_account)
                {
                    [appDelegate.dropbox updateEveryBudgetItemDataFromLocal:object];
                }
			}
		}
        
        if (appDelegate.dropbox.drop_account)
        {
            [appDelegate.dropbox updateEveryBudgetTemplateDataFromLocal:tmpBudget];
        }
	}
	
	category.others = @"";
    
    category.state = @"0";
    category.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    if (appDelegate.dropbox.drop_account.linked) {
        [appDelegate.dropbox updateEveryCategoryDataFromLocal:category];
    }
	
}
*/
//获取下一个parentCategory
-(NSInteger)getNextParentCategoryIndexFromDeleteIndex
{
    
 	for (long i=deleteIndex+1; i<[tcvc_allCategoryArray count];i ++) {
		
		CategoryCount *cc =[tcvc_allCategoryArray objectAtIndex:i];
		
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
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //获取要删除的category
	CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:deleteIndex];
    
    if (self.transactionEditViewController != nil) {
        if (cc.categoryItem==self.transactionEditViewController.categories) {
            self.transactionEditViewController.categories = nil;
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
			endOfCycle =[tcvc_allCategoryArray count];
		}
		
        //删掉这个 parentCategory旗下的所有子category
		for (long i=deleteIndex; i<endOfCycle;i ++)
		{
			CategoryCount *cc1 =[tcvc_allCategoryArray objectAtIndex:i];
 			
//			[self deleteCategoryAndRelation:cc1.categoryItem];
            [appDelegate.epdc deleteCategoryAndRelation:cc1.categoryItem];
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

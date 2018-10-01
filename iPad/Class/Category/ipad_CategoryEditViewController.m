//
//  NewGroupViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/15/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "ipad_CategoryEditViewController.h"
#import "ColorLabelView.h"
#import "PokcetExpenseAppDelegate.h"

#import "HMJCustomButtonView.h"
#import "EPNormalClass.h"
#import "ipad_FatherCategorySelectedViewController.h"

#import "AppDelegate_iPad.h"
#import "ipad_SettingPayeeEditViewController.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation ipad_CategoryEditViewController

#pragma mark -view cycle life
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    [self initPoint];
    [self initNavStyle];
    [self initIconBtnArrayandaddBtn];
    [self setControlContex];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [_mytableView reloadData];
}

-(void)refleshUI{
}
-(void)initPoint{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _nameText.placeholder = NSLocalizedString(@"VC_Unnamed", nil);
    _nameLabelText.text = NSLocalizedString(@"VC_Name", nil);
    _typeLabelText.text = NSLocalizedString(@"VC_Type", nil);
    _subCategoryLabelText.text = NSLocalizedString(@"VC_Sub-category Of", nil);
    _iconLabelText.text = NSLocalizedString(@"VC_Icon", nil);
    [_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    
    [_suCategoryNameLabel setHighlightedTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1]];

    
    _nameCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    _typeCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    _subNameCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    
    
    _iconBtnArray = [[NSMutableArray alloc]init];
    _iconArray =[[NSMutableArray alloc]initWithObjects:
                @"bonus.png",@"credit_card-payment.png",@"icon_credit_card2.png",@"salary.png",@"icon_Salary2.png",
                
                @"category_loan.png",
                @"savings-deposit.png",
                @"category_cash.png",
                @"tax-fed.png",
                @"icon_tax2.png",
                
                @"bank_charge.png",
                @"mortgage.png",
                @"rent.png",
                @"auto.png",
                @"icon_auto_gas.png",
                @"homerepair.png",
                @"icon_auto2.png",
                @"medical.png",
                @"charity.png",
                @"insurance.png",
                
                @"icon_ceremony.png",@"education.png",@"icon_business.png",@"icon_health_fitness.png",@"travel.png",@"icon_traffic_other.png",@"airplane.png",@"icon_vocation.png",@"dinning.png",@"icon_commonfood.png",@"icon_fastfood.png",@"icon_tea.png",@"icon_digital_product.png",@"clothing.png",@"icon_health_fitness4.png",@"icon_bag.png",@"icon_wedding.png",@"icon_cosmetics.png",@"icon_comp.png",@"icon_teeth.png",
                
                
                
                
                @"groceries.png",@"icon_vegatable.png",@"icon_favorite.png",@"icon_lunch.png",@"icon_hobby.png",@"gifts.png",@"icon_furniture.png",@"my_kids.png",@"childcare.png",@"my_pets.png",@"my_pets2.png",@"icon_bill.png",@"utilities.png",@"water.png",@"utilities_gas.png",@"cable-TV.png",@"interent.png",@"icon_apple.png",@"Garbage-&-Recycling.png",@"house_hold.png",
                
                
                
                
                @"misc.png",@"health_fitness.png",@"icon_ball.png",@"icon_game.png",@"icon_entertainment.png",@"icon_movie.png",@"icon_party.png",@"icon_book.png",@"icon_star.png",@"icon_heart.png",@"icon_power.png",@"uncategorized.png",@"uncategorized_income.png",
                nil];
    
    
    
    _iconScrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, 252);
    _iconScrollView.delegate = self;
    _iconScrollView.pagingEnabled = YES;
    
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    [_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //是否是parent category
    NSError *error = nil;
    NSArray * seprateSrray = [_categories.categoryName componentsSeparatedByString:@":"];
    if([seprateSrray count] ==1)
    {
        NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",_categories.categoryName];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",_categories.categoryType,@"CATEGORYTYPE",nil];
        NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
        NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
        isParentCategory = NO;
        if ([array count]>0)
        {
            isParentCategory = YES;
        }
    }

}
-(void)initIconBtnArrayandaddBtn{
    [_iconBtnArray removeAllObjects];
    NSInteger startPX = 55.f;
	NSInteger startPY = 20.f;
    int count =0;
    int line = 0;
    int page = 0;
    for (int i=0; i<[_iconArray count]; i++)
    {
        page = i/32;
        count = i- i/8*8;
		line =i/8 - page*4;//4 代表每页有几行
	 	HMJCustomButtonView *tmpBtn = [[HMJCustomButtonView alloc]initWithFrame:CGRectMake(startPX*page+count*50.f,startPY+ line *50.0, 46.0, 46.0)];
		tmpBtn.frame =CGRectMake(startPX+count*55.f+ self.view.frame.size.width*page,startPY+ line *50.0, 46.0, 46.0);
		tmpBtn.iconBtn.tag =i;
		[tmpBtn.iconBtn setImage:[UIImage imageNamed:[_iconArray objectAtIndex:i]] forState:UIControlStateNormal];
 		[tmpBtn.iconBtn addTarget:self action:@selector(cevc_selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        tmpBtn.iconSelectedBg.image = [UIImage imageNamed:@"icon_sel_34_34.png"];
        [_iconBtnArray addObject:tmpBtn];
    }
    
    for (int i=0; i<[_iconBtnArray count]; i++) {
        [_iconScrollView addSubview:[_iconBtnArray objectAtIndex:i]];
    }
}

-(void)cevc_selectBtnAction:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [_nameText resignFirstResponder];
    
	UIButton *tmpBtn =(UIButton *)sender;
    tmpBtn.selected = YES;
    
	_iconName = [_iconArray objectAtIndex:tmpBtn.tag];
    
    for (HMJCustomButtonView *btn in _iconBtnArray) {
        if ([btn isKindOfClass:[HMJCustomButtonView class]]) {
            if (btn.iconBtn.tag == tmpBtn.tag) {
                btn.iconBtn.selected = YES;
                btn.iconSelectedBg.hidden = NO;
            }
            else{
                btn.iconBtn.selected = NO;
                btn.iconSelectedBg.hidden = YES;

            }
        }
    }
    
    
    //是否是parent category
    NSError *error = nil;
    NSArray * seprateSrray = [_categories.categoryName componentsSeparatedByString:@":"];
    if([seprateSrray count] ==1)
    {
        NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",_categories.categoryName];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",_categories.categoryType,@"CATEGORYTYPE",nil];
        NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
        NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
        isParentCategory = NO;
        if ([array count]>0)
        {
            isParentCategory = YES;
        }
    }

    

}

-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    if([_editModule isEqualToString:@"ADD"]||[self.editModule isEqualToString:@"IPAD_ADD"] || [_editModule isEqualToString:@"IPAD_ACCOUNT_ADD"])
	{
		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [titleLabel setTextColor:[UIColor colorWithRed:48.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
		titleLabel.text = NSLocalizedString(@"VC_NewCategory", nil);
		self.navigationItem.titleView = 	titleLabel;
		
 		self.navigationItem.rightBarButtonItem.enabled = FALSE;
		self.iconView.image = [UIImage imageNamed:@"uncategorized.png"];
        
        // 这里是需要天际的
		self.iconName = @"uncategorized.png";
		UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customerButton.frame = CGRectMake(0, 0, 90,30);
        [customerButton setTitleColor:[UIColor colorWithRed:99/255.f green:203/255.f blue:255/255.f alpha:1] forState:UIControlStateNormal];
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

        [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
        [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [customerButton.titleLabel setMinimumScaleFactor:0];
        [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
		UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
		
		self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
		
		
 	}
 	else
	{
		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
        [titleLabel setTextColor:[UIColor colorWithRed:48.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
		titleLabel.text = NSLocalizedString(@"VC_EditCategory", nil);
		self.navigationItem.titleView = 	titleLabel;
		
		
		UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
		customerButton.frame = CGRectMake(0, 0, 90, 30);
        [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
        [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [customerButton.titleLabel setMinimumScaleFactor:0];
        [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [customerButton setTitleColor:[UIColor colorWithRed:90.f/255.f green:121.f/255.f blue:168.f/255.f alpha:1] forState:UIControlStateNormal];
		[customerButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
		UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
		
		self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
		
 		self.navigationItem.rightBarButtonItem.enabled = TRUE;
		self.iconName = _categories.iconName;
        
		self.iconView.image = [UIImage imageNamed:_categories.iconName];
   	}
    
	NSArray * seprateSrray = [_categories.categoryName componentsSeparatedByString:@":"];
    
	if([seprateSrray count] ==2)
	{
		NSString *parName = [seprateSrray objectAtIndex:1];
		
		if([[parName substringToIndex:1] isEqualToString:@" "])
		{
			self.nameText.text =[parName substringFromIndex:1];
		}
		else {
			self.nameText.text =parName;
            
		}
        
		_suCategoryNameLabel.text = [seprateSrray objectAtIndex:0];
        
	}
	else {
		self.nameText.text = _categories.categoryName;
		_suCategoryNameLabel.text = @"None";
        
	}
    if([self.editModule isEqualToString:@"EDIT"])
    {
        if([seprateSrray count] ==2)
        {
            _isEditParCate = FALSE;
        }
        else
        {
            _isEditParCate = TRUE;
            
        }
    }
    else
    {
        _isEditParCate = FALSE;
        
    }
	
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton.frame = CGRectMake(0, 0,90,30);
    [customerButton setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [customerButton setTitleColor:[UIColor colorWithRed:99/255.f green:203/255.f blue:255/255.f alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

	[customerButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];

}


-(void)setControlContex{
    if ([_editModule isEqualToString:@"ADD"]) {
        self.selectPCategory = nil;
        _iconName = @"uncategorized.png";
        _expenseBtn.selected = YES;
        _incomeBtn.selected = NO;
    }
    else
    {
        //设置parcategory文字
        NSArray * seprateSrray = [_categories.categoryName componentsSeparatedByString:@":"];
        
        if([seprateSrray count] ==2)
        {
            NSString *parName = [seprateSrray objectAtIndex:1];
            
            if([[parName substringToIndex:1] isEqualToString:@" "])
            {
                self.nameText.text =[parName substringFromIndex:1];
            }
            else {
                self.nameText.text =parName;
                
            }
            
            _suCategoryNameLabel.text = [seprateSrray objectAtIndex:0];
            //获取parentCategory
            PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            NSError *error = nil;
            
            NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:_suCategoryNameLabel.text,@"cName", nil];
            NSFetchRequest *fetch = [appDelegate_iPhone.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
            NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate_iPhone.managedObjectContext executeFetchRequest:fetch error:&error]];
            if ([objects count]>0) {
                _selectPCategory = [objects lastObject];
            }
            
        }
        else {
            self.nameText.text = _categories.categoryName;
            _suCategoryNameLabel.text = @"None";
            
        }
    
    
        
        if (self.categories !=nil && [self.categories.categoryType isEqualToString:@"EXPENSE"])
        {
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
        }
        else if(self.categories !=nil && [self.categories.categoryType isEqualToString:@"INCOME"])
        {
            _expenseBtn.selected = NO;
            _incomeBtn.selected = YES;
        }
    
    
//        if (self.categories !=nil && [self.categories.categoryType isEqualToString:@"EXPENSE"]) {
//            expenseBtn.selected = YES;
//            incomeBtn.selected = NO;
//        }
//        else if(self.categories !=nil && [self.categories.categoryType isEqualToString:@"INCOME"]){
//            expenseBtn.selected = NO;
//            incomeBtn.selected = YES;
//        }
    }
    
//    if (self.selectPCategory == nil) {
//        suCategoryNameLabel.text = @"None";
//    }
//    else
//        suCategoryNameLabel.text = selectPCategory.categoryName;
    
    
    for (int i=0; i<[_iconArray count]; i++)
    {
        HMJCustomButtonView *selectedBtnView = (HMJCustomButtonView *)[_iconBtnArray objectAtIndex:i];
        if ([[_iconArray objectAtIndex:i] isEqualToString:self.iconName]) {
            
            selectedBtnView.iconBtn.selected = YES;
            selectedBtnView.iconSelectedBg.hidden = NO;
        }
        else{
            selectedBtnView.iconBtn.selected = NO;
            selectedBtnView.iconSelectedBg.hidden = YES;
        }
    }

}


#pragma mark Btn Action
-(void)expenseBtnPressed:(id)sender{
    if (_incomeBtn.selected)
    {
        self.selectPCategory = nil;
        _suCategoryNameLabel.text = @"None";

    }
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
}

-(void)incomeBtnPressed:(id)sender{
    if (_expenseBtn.selected)
    {
        self.selectPCategory = nil;
        _suCategoryNameLabel.text = @"None";

    }
    _expenseBtn.selected = NO;
    _incomeBtn.selected=YES;
}


-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 470);
}
- (void) cancel:(id)sender
{
    if ([self.editModule isEqualToString:@"IPAD_ACCOUNT_ADD"]||[self.editModule isEqualToString:@"IPAD_ACCOUNT_EDIT"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) back:(id)sender
{
    if ([self.editModule isEqualToString:@"IPAD_ACCOUNT_ADD"]||[self.editModule isEqualToString:@"IPAD_ACCOUNT_EDIT"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) save:(id)sender
{
	if([_nameText.text length] == 0)
	{
	 	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Note", nil)
														message:NSLocalizedString(@"VC_Category Name is required.", nil)
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
											  otherButtonTitles:nil];
		[alert show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alert;
		return;
	}
    
    if ([_iconName length]==0 || _iconName == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Note", nil)
														message:NSLocalizedString(@"VC_Category Icon is required.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
											  otherButtonTitles:nil];
		[alert show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alert;
		return;
    }
	NSError *error =nil;
	
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSDictionary *sub;
    NSFetchRequest *fetchRequest;
    NSString  *tmpcategoryType;
    if (_expenseBtn.selected) {
		sub = [[NSDictionary alloc]init];
        fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchExpenseCategory" substitutionVariables:sub];
        
        tmpcategoryType = @"EXPENSE";
    }
    else{
		sub = [[NSDictionary alloc]init];
        fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchIncomeCategory" substitutionVariables:sub];
        tmpcategoryType = @"INCOME";
    }
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

	
	NSMutableArray	*categoryList =	[[NSMutableArray alloc] initWithArray:objects];

	for (Category *tmpType in categoryList)
	{
		if([tmpType.categoryName isEqualToString:self.nameText.text]&&tmpType!=self.categories)
		{
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Note", nil)
															message:NSLocalizedString(@"VC_Category already exists.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
			[alert show];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alert;
			return;
		}
	}
    
	if(_categories == nil)
  	{		
		_categories = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
		_categories.isDefault = [NSNumber numberWithBool:FALSE];
		_categories.isSystemRecord = [NSNumber numberWithBool:FALSE];
		_categories.others = @"HASUSE";
        
	}
	NSString *tmpString = [_nameText.text stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    //categoryType
    _categories.categoryType = tmpcategoryType;

    //parentCategory
	if(_selectPCategory !=nil)
	{
		_categories.categoryName = [NSString stringWithFormat:@"%@: %@",_selectPCategory.categoryName,tmpString];
	}
	else {
		if([_suCategoryNameLabel.text isEqualToString: @"None"])
		{
            ////////////////////get All child category
            NSString *searchForMe = @":";
            NSRange range = [_categories.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound) {
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",_categories.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",_categories.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
            
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    NSArray * seprateSrray = [tmpCate.categoryName componentsSeparatedByString:@":"];
                    if([seprateSrray count] ==2&&tmpCate !=_categories)
                    {
                        NSString *childName = [seprateSrray objectAtIndex:1];
 
                        tmpCate.categoryName = [NSString stringWithFormat:@"%@: %@",tmpString,childName];
                    }
                }
                
            }

            _categories.categoryName = tmpString;

		}
		else {
	 		_categories.categoryName = [NSString stringWithFormat:@"%@: %@",_suCategoryNameLabel.text,tmpString];
            
		}
        
		
	}
    
    
    //icon
	_categories.iconName=self.iconName;
    
    if ([self.editModule isEqualToString:@"ADD"]||[self.editModule isEqualToString:@"IPAD_ACCOUNT_ADD"])
    {
        _categories.uuid = [EPNormalClass GetUUID];
        //category orderIndex
        NSDictionary *sub =[[NSDictionary alloc]init];
        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchParentCategoryAll" substitutionVariables:sub];
        NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *categoryAllArray = [[NSMutableArray alloc]initWithArray:objects];
        
        
        BOOL hasSequence = NO;
        for (int i=0; i<[objects count]; i++)
        {
            Category *oneCategory = [objects objectAtIndex:i];
            if (oneCategory.recordIndex != nil && [oneCategory.recordIndex integerValue]>0)
            {
                hasSequence = YES;
                break;
            }
        }
        
        
        if (hasSequence)
        {
            NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"recordIndex" ascending:YES];
            
            
            NSArray *sorts = [[NSArray alloc]initWithObjects:sort, nil];
            
            [categoryAllArray sortUsingDescriptors:sorts];
            
            Category *lastCategory = [categoryAllArray lastObject];
            
            _categories.recordIndex = [NSNumber numberWithInt:[(lastCategory.recordIndex) intValue] + 1];
        }

        [appDelegate.epnc setFlurryEvent_WithIdentify:@"21_CTG_CUST"];

    }
    _categories.state = @"1";
    _categories.dateTime = [NSDate date];
    
   	if(![appDelegate.managedObjectContext save:&error])
	{
		NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
	}
    
    //sync
//    PokcetExpenseAppDelegate *appdelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//	if (appdelegate_iPhone.dropbox.drop_account.linked) {
//        [appdelegate_iPhone.dropbox  updateEveryCategoryDataFromLocal:self.categories];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateCategoryFromLocal:self.categories];
    }
    if ([self.editModule isEqualToString:@"IPAD_ACCOUNT_ADD"]||[self.editModule isEqualToString:@"IPAD_ACCOUNT_EDIT"])
    {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPad.mainViewController.iAccountViewController reFleshTableViewData_withoutReset];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if ([_editModule isEqualToString:@"ADD"])
        {
            //由Transaction进来的
            if(_transactionEditViewController != nil && [_editModule isEqualToString:@"ADD"])
            {
                _transactionEditViewController.categories = _categories;
                _transactionEditViewController.categoryLabel.text = _categories.categoryName;

            }
            //由新建payee进来的
            else if (_payeeEditViewController != nil && [_editModule isEqualToString:@"ADD"])
            {
                _payeeEditViewController.categories = _categories;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    }

}


#pragma mark HMJPickerViewDelegate
-(void)toolBtnPressed{
    self. selectPCategory = nil;
     _suCategoryNameLabel.text = @"None";
//    customPickerView.hidden = YES;
    
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 368;
    }
    else
        return 44;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return _nameCell;
    }
    else if (indexPath.row==1)
        return _typeCell;
    else if (indexPath.row ==2)
        return  _subNameCell;
    else
        return _iconCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0)
	{
		[self.nameText becomeFirstResponder];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
 		[UIView commitAnimations];
	}
    else if (indexPath.row==1){
        [_nameText resignFirstResponder];
//        customPickerView.hidden = YES;
    }
	else if(indexPath.row == 2)
    {
        [self.nameText resignFirstResponder];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.nameText resignFirstResponder];
        
        if(isParentCategory){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a parent category, and it can not be selected to other parent categories.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
            appDelegate.appAlertView = alert;
            [alert show];
        }
        else{
            ipad_FatherCategorySelectedViewController *fatherCategoryViewController = [[ipad_FatherCategorySelectedViewController alloc]initWithNibName:@"ipad_FatherCategorySelectedViewController" bundle:nil];
            if (_expenseBtn.selected)
            {
                fatherCategoryViewController.categoryType = @"expense";
            }
            else
                fatherCategoryViewController.categoryType = @"income";
            fatherCategoryViewController.parentCategory = self.selectPCategory;
            fatherCategoryViewController.icategoryEditViewController = self;
            [self.navigationController pushViewController:fatherCategoryViewController animated:YES];

        }
    }
    else
    {
        [self.nameText resignFirstResponder];
//        customPickerView.hidden = YES;
        long i=[_iconArray indexOfObject:_iconName];
        [_iconScrollView setContentOffset:CGPointMake(i/32*self.view.frame.size.width, 0)];
        _iconPageController.currentPage =i/32;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}	

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_nameText resignFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i=(scrollView.contentOffset.x+1)/320;
    _iconPageController.currentPage = i;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload {
//}





@end

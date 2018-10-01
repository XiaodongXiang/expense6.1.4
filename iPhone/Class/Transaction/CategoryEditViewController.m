//
//  NewGroupViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/15/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "CategoryEditViewController.h"
#import "ColorLabelView.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"

#import "HMJCustomButtonView.h"
#import "EPNormalClass.h"
#import "FatherCategorySelectedViewController.h"

#import "TransactionCategoryViewController.h"
#import "TransactionEditViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface CategoryEditViewController()

@property (weak, nonatomic) IBOutlet UIView *btnCover;

@end
@implementation CategoryEditViewController


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

    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) title:NSLocalizedString(@"VC_Cancel", nil)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(save:) title:NSLocalizedString(@"VC_Save", nil)];
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
    _iconLabelText.text = NSLocalizedString(@"VC_Icon", nil);
    [_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    
    [_nameLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_typeLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    _subCategoryLabelText.text = NSLocalizedString(@"VC_Sub-category Of", nil);
    [_suCategoryNameLabel setHighlightedTextColor:[appDelegate.epnc getAmountGrayColor]];
    [_iconLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    
    _iconScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 252);
    _iconScrollView.delegate = self;
    _iconScrollView.pagingEnabled = YES;
    
    self.nameLineHigh.constant = EXPENSE_SCALE;
    self.subcategoryLineHigh.constant = EXPENSE_SCALE;
    self.typeLineHigh.constant = EXPENSE_SCALE;
    
    [_expenseBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];
    [_expenseBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(230, 230, 230)] forState:UIControlStateNormal];
    [_incomeBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];
    [_incomeBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(230, 230, 230)] forState:UIControlStateNormal];
    self.btnCover.layer.cornerRadius = 15;
    self.btnCover.layer.masksToBounds = YES;
    _expenseBtn.layer.cornerRadius = 15;
    _expenseBtn.layer.masksToBounds = YES;
    _incomeBtn.layer.cornerRadius = 15;
    _incomeBtn.layer.masksToBounds = YES;
    
    
    _iconBtnArray = [[NSMutableArray alloc]init];
    _iconArray =[[NSMutableArray alloc]initWithObjects:
                @"bonus.png",
                @"credit_card-payment.png",
                @"icon_credit_card2.png",
                @"salary.png",
                @"icon_Salary2.png",
                
                @"category_loan.png",
                @"savings-deposit.png",
                @"category_cash.png",
                @"tax-fed.png",//有其他重复图片
                @"icon_tax2.png",
                
                @"bank_charge.png",
                @"mortgage.png",
                @"rent.png",
                @"auto.png",//有其他重复图片
                @"icon_auto_gas.png",
                
                @"homerepair.png",
                @"icon_auto2.png",
                @"medical.png",
                @"charity.png",
                @"insurance.png",
                
                
                //第二页
                @"icon_ceremony.png",
                @"education.png",
                @"icon_business.png",
                @"icon_health_fitness.png",
                @"travel.png",
                
                @"icon_traffic_other.png",
                @"airplane.png",
                @"icon_vocation.png",
                @"dinning.png",
                @"icon_commonfood.png",
                
                @"icon_fastfood.png",
                @"icon_tea.png",
                @"icon_digital_product.png",
                @"clothing.png",
                @"icon_health_fitness4.png",
                
                @"icon_bag.png",
                @"icon_wedding.png",
                @"icon_cosmetics.png",
                @"icon_comp.png",
                @"icon_teeth.png",
                
                
                
                //第三页
                @"groceries.png",
                @"icon_vegatable.png",
                @"icon_favorite.png"
                ,@"icon_lunch.png",
                @"icon_hobby.png",
                
                @"gifts.png",
                @"icon_furniture.png",
                @"my_kids.png",
                @"childcare.png",
                @"my_pets.png",
                
                @"my_pets2.png",
                @"icon_bill.png",
                @"utilities.png",
                @"water.png",
                @"utilities_gas.png",
                
                @"cable-TV.png",
                @"interent.png",
                @"icon_apple.png",
                @"Garbage-&-Recycling.png",
                @"house_hold.png",
                
                
                
                //第四页
                @"misc.png",
                @"health_fitness.png",
                @"icon_ball.png",
                @"icon_game.png",
                @"icon_entertainment.png",
                
                @"icon_movie.png",
                @"icon_party.png",
                @"icon_book.png",
                @"icon_star.png",
                @"icon_heart.png",
                
                @"icon_power.png",
                @"uncategorized.png",
                @"uncategorized_income.png",
                nil];
    

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
    
    //左边第一个icon上边距，左边距
    NSInteger startPX;
	NSInteger startPY=20;
    double    iconWith2;
    double    iconHigh2;
    if (IS_IPHONE_6PLUS)
    {
        startPX = 53.f;
        iconWith2 = 64;
        iconHigh2 = 64;

    }
    else if (IS_IPHONE_6)
    {
        startPX = 40.f;
        iconWith2 = 60;
        iconHigh2 = 60;

    }else if (IS_IPHONE_X)
    {
        startPX = 40.f;
        iconWith2 = 64;
        iconHigh2 = 64;
        
    }
    else
    {
        startPX = 35.f;
        iconWith2 = 50;
        iconHigh2 = 50;
    }
    int count =0;
    int line = 0;
    int page = 0;
    for (int i=0; i<[_iconArray count]; i++) {
        page = i/20;
        count = i- i/5*5;
		line =i/5 - page*4;
	 	HMJCustomButtonView *tmpBtn = [[HMJCustomButtonView alloc]initWithFrame:CGRectMake(startPX*page+count*iconWith2,startPY+ line *iconHigh2, 44.0, 44.0)];
		tmpBtn.frame =CGRectMake(startPX+count*iconWith2+SCREEN_WIDTH*page,startPY+ line *iconHigh2, 44.0, 44.0);
		tmpBtn.iconBtn.tag =i;
		[tmpBtn.iconBtn setImage:[UIImage imageNamed:[_iconArray objectAtIndex:i]] forState:UIControlStateNormal];
 		[tmpBtn.iconBtn addTarget:self action:@selector(cevc_selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        tmpBtn.iconSelectedBg.image = [UIImage imageNamed:@"icon_sel2_44_44.png"];
        [_iconBtnArray addObject:tmpBtn];
    }
    
    for (int i=0; i<[_iconBtnArray count]; i++) {
        [_iconScrollView addSubview:[_iconBtnArray objectAtIndex:i]];
    }
}

-(void)cevc_selectBtnAction:(id)sender{
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
    

}

-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = 6.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = 6.f;
    
  	if([_editModule isEqualToString:@"ADD"]||[self.editModule isEqualToString:@"IPAD_ADD"])
	{
		self.navigationItem.title = NSLocalizedString(@"VC_NewCategory", nil);
		
 		self.navigationItem.rightBarButtonItem.enabled = FALSE;
		self.iconView.image = [UIImage imageNamed:@"uncategorized.png"];
        
        // 这里是需要天际的
		self.iconName = @"uncategorized.png";
		UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customerButton.frame = CGRectMake(0, 0, 90,30);
        NSString *currentLangue = [EPNormalClass currentLanguage];;
        if ([currentLangue isEqualToString:@"en"])
            customerButton.frame = CGRectMake(0, 0,60, 30);
        [customerButton setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];
        [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
        [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

		[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
		UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
		
		self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
		
		
 	}
 	else
	{
		self.navigationItem.title = NSLocalizedString(@"VC_EditCategory", nil);
		
		
		UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customerButton.frame = CGRectMake(0, 0, 90,30);
        NSString *currentLangue = [EPNormalClass currentLanguage];;
        if ([currentLangue isEqualToString:@"en"])
            customerButton.frame = CGRectMake(0, 0,60, 30);
        [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
        [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        

        
        [customerButton setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];
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
    customerButton.frame = CGRectMake(0, 0, 90,30);
    NSString *currentLangue = [EPNormalClass currentLanguage];;
    if ([currentLangue isEqualToString:@"en"])
        customerButton.frame = CGRectMake(0, 0,60, 30);
    [customerButton setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [customerButton setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];
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
            AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
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

        
        if (self.categories !=nil && [self.categories.categoryType isEqualToString:@"EXPENSE"]) {
            _expenseBtn.selected = YES;
            _incomeBtn.selected = NO;
        }
        else if(self.categories !=nil && [self.categories.categoryType isEqualToString:@"INCOME"]){
            _expenseBtn.selected = NO;
            _incomeBtn.selected = YES;
        }
    }
    for (int i=0; i<[_iconArray count]; i++) {
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
        _selectPCategory = nil;
        _suCategoryNameLabel.text = @"None";
    }
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
}

-(void)incomeBtnPressed:(id)sender{
    if (_expenseBtn.selected)
    {
        _selectPCategory = nil;
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
    			[[self navigationController] dismissViewControllerAnimated:YES completion:nil];

}

- (void) back:(id)sender
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) save:(id)sender
{
	if([_nameText.text length] == 0)
	{
	 	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
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
    if (_expenseBtn.selected)
    {
		sub = [[NSDictionary alloc]init];
        fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchExpenseCategory" substitutionVariables:sub];
        
        tmpcategoryType = @"EXPENSE";
    }
    else
    {
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
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
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
                [fetchRequest setSortDescriptors:sortDescriptors];
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
                        tmpCate.dateTime = [NSDate date];
                        [appDelegate.managedObjectContext save:&error];
//                        if (appDelegate.dropbox.drop_account.linked) {
//                            [appDelegate.dropbox  updateEveryCategoryDataFromLocal:tmpCate];
//                        }
                        if ([PFUser currentUser])
                        {
                            [[ParseDBManager sharedManager]updateCategoryFromLocal:tmpCate];
                        }
                        
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
    
    
    
    if ([self.editModule isEqualToString:@"ADD"])
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
//    AppDelegate_iPhone *appdelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//	if (appdelegate_iPhone.dropbox.drop_account.linked) {
//        [appdelegate_iPhone.dropbox  updateEveryCategoryDataFromLocal:self.categories];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateCategoryFromLocal:self.categories];
    }
	
	if([_editModule isEqualToString:@"EDIT"] )
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
	else
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
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

    }

}


#pragma mark HMJPickerViewDelegate
-(void)toolBtnPressed{
    self. selectPCategory = nil;
     _suCategoryNameLabel.text = @"None";
    
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
        return self.view.frame.size.height-168;
    }
    else
        return 56;
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
    }
	else if(indexPath.row == 2)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.nameText resignFirstResponder];
        
        if(isParentCategory){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a parent category, and it can not be selected to other parent categories.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
            appDelegate.appAlertView = alert;
            [alert show];
        }
        else
        {
            FatherCategorySelectedViewController *fatherCategoryViewController = [[FatherCategorySelectedViewController alloc]initWithNibName:@"FatherCategorySelectedViewController" bundle:nil];
            if (_expenseBtn.selected)
            {
                fatherCategoryViewController.categoryType = @"expense";
            }
            else
                fatherCategoryViewController.categoryType = @"income";
            fatherCategoryViewController.parentCategory = self.selectPCategory;
            fatherCategoryViewController.categoryEditViewController = self;
            [self.navigationController pushViewController:fatherCategoryViewController animated:YES];
            //        customPickerView.hidden = NO;
            //
            //        if (selectPCategory!=nil) {
            //            int i = [parentCategoryArray indexOfObject:selectPCategory];
            //            [customPickerView.hmjPicker  selectRow:i  inComponent:0 animated:NO];
            //        }
            //        else{
            //            [customPickerView.hmjPicker  selectRow:0  inComponent:0 animated:NO];
            //        }

        }
    }
    else
    {
        [self.nameText resignFirstResponder];
        long i=[_iconArray indexOfObject:_iconName];
        [_iconScrollView setContentOffset:CGPointMake(i/20*320, 0)];
        _iconPageController.currentPage = i/20;
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

//
//  TransferViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/23/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "TransferViewController_NS.h"

#import "PokcetExpenseAppDelegate.h"

#import "RegexKitLite.h"
#import "BudgetCountClass.h" 
#import "AppDelegate_iPhone.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation TransferViewController_NS
#pragma mark - custom API

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark -view life cycle
- (void)viewDidLoad
{
	
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavBarStyle];
    [self initMemoryDefine];
    [self initContext];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}


-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_BudgetTransfer", nil);

    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;

    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [doneBtn.titleLabel setMinimumScaleFactor:0];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn] ];
    
    
    UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 90,30);
    [customerButton1 setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [customerButton1.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [customerButton1 setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [customerButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [customerButton1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
    self.navigationItem.leftBarButtonItems = @[flexible2,leftButton];

}

-(void)initMemoryDefine
{
    
    _line1H.constant = EXPENSE_SCALE;
    _line2H.constant = EXPENSE_SCALE;
    _bgImage.image=[UIImage imageNamed:[NSString customImageName:@"budget_transfer_bg"]];
    _fromBgImage.image = [UIImage imageNamed:[NSString customImageName:@"budgetTransferLeft_bg_170_70.png"]];
    _toBgImage.image = [UIImage imageNamed:[NSString customImageName:@"budgetTransfer_bg_170_70.png"]];

    _fromBudgetLabelText.text = NSLocalizedString(@"VC_FromBudget", nil);
    _toBudgetTextLabel.text = NSLocalizedString(@"VC_ToBudget", nil);
    _amountLabelText.text = NSLocalizedString(@"VC_Amount", nil);
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [_amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    [_fromTotalLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    [_toTotalLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];

    
	_selectBudgetArray = [[NSMutableArray alloc] init];
    
    _amountText.delegate = self;
    [_btnToBudget addTarget:self action:@selector(btnToBudgetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _customerPick.hidden = YES;
    _customerPick.backgroundColor = [UIColor whiteColor];
    

}

-(void)initContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget数组，除了frombudget
    [self getDateSource];
    [_customerPick reloadAllComponents];

    
    if ([self.typeOftodo isEqualToString:@"ADD"])
    {
        self.toLabel.text = NSLocalizedString(@"VC_SelectTargetBudget", nil);
        _toBudgetTextLabel.hidden = YES;
        _toTotalLabel.hidden = YES;
        [self calculateBudgetAmountwhenEdit:YES];
    }
    else
    {
        self.toBudget = self.budgetTransfer.toBudget.budgetTemplate;
        self.toLabel.text = self.budgetTransfer.toBudget.budgetTemplate.category.categoryName;
        self.fromBudget = self.budgetTransfer.fromBudget.budgetTemplate;
        
        [self calculateBudgetAmountwhenEdit:YES];
        [self calculateBudgetAmountwhenEdit:NO];
    }
    
    [self setToBudgetTextColor];
    
    self.fromLabel.text = self.fromBudget.category.categoryName;
    
    _amountNum = [_budgetTransfer.amount doubleValue];
    self.amountText.text = [appDelegate.epnc formatterString:_amountNum];

}

-(void)calculateBudgetAmountwhenEdit:(BOOL)isFromBudget
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    BudgetTemplate *budgetTemplate;
    if (isFromBudget) {
        budgetTemplate = self.fromBudget;
    }
    else
        budgetTemplate = self.toBudget;
    
    BudgetItem *budgetTemplateCurrentItem	=[[budgetTemplate.budgetItems allObjects] lastObject];
    
    double btTotalExpense = 0;
    double btTotalIncome = 0;
    if( budgetTemplate.category!=nil)
    {
        NSError *error = nil;
        NSDictionary *subs;
        
        subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
        
        for (int j = 0;j<[tmpArray count];j++) {
            Transaction *t = [tmpArray objectAtIndex:j];
            if([t.category.categoryType isEqualToString:@"EXPENSE"])
            {
                btTotalExpense +=[t.amount doubleValue];
            }
            else if([t.category.categoryType isEqualToString:@"INCOME"]){
                btTotalIncome +=[t.amount doubleValue];
            }
            
        }
        
        NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
        
        for (int j = 0;j<[tmpArray1 count];j++) {
            BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
            btTotalExpense +=[bttmp.amount doubleValue];
            
        }
        
        NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
        
        for (int j = 0; j<[tmpArray2 count];j++) {
            BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
            btTotalIncome +=[bttmp.amount doubleValue];
            
        }
        ////////////////////get All child category
        NSString *searchForMe = @":";
        NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
        
        if (range.location == NSNotFound) {
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
                    
                    for (int k = 0;k<[tmpArray count];k++) {
                        Transaction *t = [tmpArray objectAtIndex:k];
                        if([t.category.categoryType isEqualToString:@"EXPENSE"])
                        {
                            btTotalExpense +=[t.amount doubleValue];
                        }
                        else if([t.category.categoryType isEqualToString:@"INCOME"]){
                            btTotalIncome +=[t.amount doubleValue];
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    //没有把上次留存的值放进去
    if (isFromBudget) {
        _fromTotalLabel.text = [appDelegate.epnc formatterString:[budgetTemplate.amount doubleValue]+btTotalIncome-btTotalExpense];
    }
    else
    {
        _toTotalLabel.text = [appDelegate.epnc formatterString:[budgetTemplate.amount doubleValue]+btTotalIncome-btTotalExpense];
    }

}

#pragma mark - get Data Souce
-(void)getDateSource
{
	[_selectBudgetArray removeAllObjects];
	NSError *error =nil;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的 budget的数据
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];

    //将tobudget移除
    [allBudgetArray removeObject:_fromBudget];
    
    
	BudgetCountClass *bcc;
    
	NSDictionary *subs;
	for (int i = 0; i<[allBudgetArray count];i++) {
		BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
         BudgetItem *budgetTemplateCurrentItem	=[[budgetTemplate.budgetItems allObjects] lastObject];
        bcc = [[BudgetCountClass alloc] init];
        bcc.bt = budgetTemplate;
        bcc.btTotalExpense =0;
        bcc.btTotalIncome =0;

        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
			NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
			NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
			[fetchRequest setSortDescriptors:sortDescriptors];
			NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
      
            
			NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
			
			for (int j = 0;j<[tmpArray count];j++) {
				Transaction *t = [tmpArray objectAtIndex:j];
				if([t.category.categoryType isEqualToString:@"EXPENSE"])
				{
					bcc.btTotalExpense +=[t.amount doubleValue];
 				}
				else if([t.category.categoryType isEqualToString:@"INCOME"]){
					bcc.btTotalIncome +=[t.amount doubleValue];
 				}
				
			}
		
			
			NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
			
			for (int j = 0;j<[tmpArray1 count];j++) {
				BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
				bcc.btTotalExpense +=[bttmp.amount doubleValue];
 				
			}
			
			NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
			
 			for (int j = 0; j<[tmpArray2 count];j++) {
				BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
				bcc.btTotalIncome +=[bttmp.amount doubleValue];
 				
			}
            ////////////////////get All child category
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound) {
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
                        
                        for (int k = 0;k<[tmpArray count];k++) {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                bcc.btTotalExpense +=[t.amount doubleValue];
                             }
                            else if([t.category.categoryType isEqualToString:@"INCOME"]){
                                bcc.btTotalIncome +=[t.amount doubleValue];
                             }
                            
                        }
                     
                  }
                }
                
            }
            
            }
            
        [_selectBudgetArray addObject:bcc];
       
	}

}

#pragma mark - custom button action
-(void)btnToBudgetAction:(id)sender
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	[_amountText resignFirstResponder];
    
    _toBudgetTextLabel.hidden = NO;
    _toTotalLabel.hidden = NO;
    _customerPick.hidden = NO;
    
    if(_toBudget==nil && [_selectBudgetArray count]>0)
    {
        BudgetCountClass *bcc = (BudgetCountClass *)[_selectBudgetArray objectAtIndex:0];
        _toBudget = bcc.bt;
        _toLabel.text = _toBudget.category.categoryName;
        self.toTotalLabel.text  =[appDelegate_iphone.epnc formatterString:[bcc.bt.amount doubleValue]+bcc.btTotalRellover+bcc.btTotalIncome-bcc.btTotalExpense];
        [self setToBudgetTextColor];
    }
}

#pragma mark - text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(textField == _amountText)
	{
		NSString *valueStr;
		if([string length]>0)
		{
			if([_amountText.text length]>12)
				return NO;
			else
			{
				NSArray *tmp = [string componentsSeparatedByString:@"."];
				if([tmp count] >=2)
				{
					return NO;
				}
				string = [string stringByReplacingOccurrencesOfRegex:@"[^0-9.]" withString:@""];
				if([string  isEqualToString: @""])
					return NO;
				valueStr = [NSString stringWithFormat:@"%.1f",[_amountText.text doubleValue]*10];
			}
		}
		else
		{
			valueStr = [NSString stringWithFormat:@"%.3f",[_amountText.text doubleValue]/10];
		}
		_amountText.text = valueStr;
	}
	return YES;	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    _customerPick.hidden = YES;
}
- (IBAction) amountTextDid:(id)sender
{
 	self.amountText.text = [NSString stringWithFormat:@"%.2f",_amountNum];
 }
-(IBAction)EditChanged:(id)sender
{
	_amountNum = [self.amountText.text doubleValue];
}
-(IBAction)TextDidEnd:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	self.amountText.text = [appDelegate.epnc formatterString:_amountNum ];
}

#pragma mark - nav button action
- (void) cancel:(id)sender
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

 }

- (void) save:(id)sender
{
	if([_fromLabel.text length]==0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_From Budget is required.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;

		return;
	}
	if([_toLabel.text length] == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_To Budget is required.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;

		return;
	}
	if([self.amountText.text length] == 0||_amountNum ==0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Amount is required.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.appAlertView = alertView;

		return;
	}
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

 	if([_typeOftodo isEqualToString:@"ADD"]||[_typeOftodo isEqualToString:@"IPAD_ADD"])
    {
	_budgetTransfer= [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTransfer" inManagedObjectContext:appDelegate.managedObjectContext];
        
        
	}
	_budgetTransfer.amount =[NSNumber numberWithDouble:_amountNum ];
 	_budgetTransfer.dateTime = [NSDate date];
    
    //获取frombudget 的budgetTemplate对应哪一个budgetItem
	BudgetItem *formbudgetTemplateCurrentItem = nil;
	BudgetItem *tobudgetTemplateCurrentItem = nil;
	NSMutableArray *tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[_fromBudget.budgetItems allObjects]];
	NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
 	[tmpArrayItem sortUsingDescriptors:sorts];
	for (int i=0; i<[tmpArrayItem count];i++) {
//		BudgetItem *tmpBi = [tmpArrayItem objectAtIndex:i];
//		//if([tmpBi.isCurrent boolValue] )
//		if([appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.startDate ]>=0&&[appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.endDate ]<=0)
//
//		{
//			formbudgetTemplateCurrentItem = tmpBi;
//			break;
//		}
        formbudgetTemplateCurrentItem = [tmpArrayItem lastObject];
	}

    
    //获取toBudgetTemplate对应哪一个budgetItem
 	tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[_toBudget.budgetItems allObjects]];
 	[tmpArrayItem sortUsingDescriptors:sorts];
	for (int i=0; i<[tmpArrayItem count];i++) {
//		BudgetItem *tmpBi = [tmpArrayItem objectAtIndex:i];
//		//if([tmpBi.isCurrent boolValue] )
//		if([appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.startDate ]>=0&&[appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.endDate ]<=0)
//
//		{
//			tobudgetTemplateCurrentItem = tmpBi;
//			break;
//		}
        tobudgetTemplateCurrentItem = [tmpArrayItem lastObject];
	}


	if([_typeOftodo isEqualToString:@"ADD"]||[_typeOftodo isEqualToString:@"IPAD_ADD"] )
	{
		 if(formbudgetTemplateCurrentItem!=nil)
		{
			[formbudgetTemplateCurrentItem addFromTransferObject:_budgetTransfer];
		}
		if(tobudgetTemplateCurrentItem!=nil)
		{
			[tobudgetTemplateCurrentItem addToTransferObject:_budgetTransfer];
		}
		_budgetTransfer.fromBudget  =formbudgetTemplateCurrentItem;
		_budgetTransfer.toBudget  = tobudgetTemplateCurrentItem;
        
        _budgetTransfer.uuid = [EPNormalClass GetUUID];

 	}
	else {
		
		[_budgetTransfer.fromBudget removeFromTransferObject:_budgetTransfer];
		[_budgetTransfer.toBudget removeToTransferObject:_budgetTransfer];
		if(formbudgetTemplateCurrentItem!=nil)
		{
            [appDelegate.epdc ReCountBudgetRollover:_budgetTransfer.fromBudget.budgetTemplate];
             

			[formbudgetTemplateCurrentItem addFromTransferObject:_budgetTransfer];
		}
		if(tobudgetTemplateCurrentItem!=nil)
		{
             [appDelegate.epdc ReCountBudgetRollover:_budgetTransfer.toBudget.budgetTemplate];
            

			[tobudgetTemplateCurrentItem addToTransferObject:_budgetTransfer];
		}
		
		_budgetTransfer.fromBudget  =formbudgetTemplateCurrentItem;
		_budgetTransfer.toBudget  = tobudgetTemplateCurrentItem;
	
	}
    _budgetTransfer.dateTime_sync = [NSDate date];
    _budgetTransfer.state = @"1";
	NSError *error;
	if (![appDelegate.managedObjectContext save:&error]) 
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
    
    [appDelegate.epdc ReCountBudgetRollover:_budgetTransfer.fromBudget.budgetTemplate];
    [appDelegate.epdc ReCountBudgetRollover:_budgetTransfer.toBudget.budgetTemplate];

    //sync
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetTransferDataFromLocal:_budgetTransfer];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetTransfer:_budgetTransfer];
    }

	if([_typeOftodo isEqualToString:@"ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_TSF"];

        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

    }

	else
        [self.navigationController popViewControllerAnimated:YES];
    
 }

#pragma mark UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [_selectBudgetArray count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BudgetCountClass *bcc = (BudgetCountClass *)[_selectBudgetArray objectAtIndex:row];
    return bcc.bt.category.categoryName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([_selectBudgetArray count] > 0)
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

        BudgetCountClass *bcc = (BudgetCountClass *)[_selectBudgetArray objectAtIndex:row];
		self.toBudget = bcc.bt;
        self.toLabel.text = bcc.bt.category.categoryName;
        self.toTotalLabel.text  =[appDelegate.epnc formatterString:[bcc.bt.amount doubleValue]+bcc.btTotalRellover+bcc.btTotalIncome-bcc.btTotalExpense];
        [self setToBudgetTextColor];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 270;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 44;
}


#pragma mark selectBudgetDelegate

-(void)setToBudgetTextColor{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (self.toBudget==nil) {
        [self.toLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
        
    }
    else
        [self.toLabel setTextColor:[UIColor colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1]];
}

#pragma mark view release and dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

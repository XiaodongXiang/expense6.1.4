//
//  NewAccountViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "ipad_AccountEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "Accounts.h"
#import "AccountType.h"
#import "ipad_AccountTypeViewController.h"
#import "RegexKitLite.h"
#import "ipad_AccountPickerViewController.h"
 
#import <Parse/Parse.h>
#import "ParseDBManager.h"
@import Firebase;

@implementation ipad_AccountEditViewController
#pragma mark Customer API

-(void)hideKeyBoard
{
	[self.amountText resignFirstResponder];
 	[self.nameText resignFirstResponder];
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 90, 30);
	[customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [customerButton setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
     [customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
	
 	
	UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton1.frame = CGRectMake(0, 0, 90, 30);
	[customerButton1 setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [customerButton1.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    customerButton1.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton1.titleLabel setMinimumScaleFactor:0];
    [customerButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [customerButton1 setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [customerButton1 setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
     [customerButton1 addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];

	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    
    if([self.typeOftodo isEqualToString:@"IPAD_EDIT"]||[self.typeOftodo isEqualToString:@"EDIT"])
	{
 		titleLabel.text = NSLocalizedString(@"VC_EditAccount", nil);
     }
 	else 
	{
  		titleLabel.text = NSLocalizedString(@"VC_NewAccount", nil);
    }
    
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
 	self.navigationItem.titleView = 	titleLabel;

}

-(void)initControlStyleAndEvent
{
	
    [self.incomeBtn setImage:[UIImage imageNamed:@"ipad_btn_income"] forState:UIControlStateNormal];
    [self.incomeBtn setImage:[UIImage imageNamed:@"ipad_btn_income_sel"] forState:UIControlStateSelected];
    [self.incomeBtn setSelected:YES];
    
    [self.expenseBtn setImage:[UIImage imageNamed:@"ipad_btn_expense_sel"] forState:UIControlStateSelected];
    [self.expenseBtn setImage:[UIImage imageNamed:@"ipad_btn_expense"] forState:UIControlStateNormal];
    
	self.amountText.delegate = self;
    
}

-(void)initMemoryDefine
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [_amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    
    _nameLabelText.text = NSLocalizedString(@"VC_NewAccount", nil);
    _balanceLabelText.text = NSLocalizedString(@"VC_StartBalance", nil);
    _dateLabelText.text = NSLocalizedString(@"VC_OpenDate", nil);
    _typeLabelText.text = NSLocalizedString(@"VC_Type", nil);
    _clearedLabelText.text = NSLocalizedString(@"VC_AutoClear", nil);
    
//    nameCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
//    amountCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
//    TimeCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
//    typeCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
//    autoClearCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];


    fistToBeHere = 0;
    outputFormatter  = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
    aevc_accountTypeArray = [[NSMutableArray alloc]init];
    aevc_accountArray = [[NSMutableArray alloc]init];
    if(_accounts == nil)
	{
		NSError *error =nil;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
		[fetchRequest setEntity:entity];
//        NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"EMPTY" ,nil];
//		NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchAccountType" substitutionVariables:subs];

		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		
		NSMutableArray *accountTypeList = [[NSMutableArray alloc] initWithArray:objects];

        BOOL isFound=FALSE;
        for (int i=0; i<[accountTypeList count]; i++) {
            AccountType *at = [accountTypeList objectAtIndex:i];
            if([at.typeName isEqualToString:@"Checking"])
            {
                isFound= TRUE;
                _accountType = at ;

                break;
            }
        }
        if(!isFound &&[accountTypeList count ]>0)
		_accountType = [ accountTypeList objectAtIndex:0];
        
	}
    else _accountType =_accounts.accountType;
    accAmount =0;

    _selectedRow=0;
    _datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void) setDefaultValueForControler
{
    if(self.accounts!=nil)
    {
        self.nameText.text = self.accounts.accName;
        accAmount = fabs([self.accounts.amount doubleValue ]);

		self.datePicker.date = _accounts.dateTime;

        if([self.accounts.amount doubleValue] < 0)
        {
            
            [self.expenseBtn setSelected:YES];
            [self.incomeBtn setSelected:NO];
            
        }
        else 
        {
            
            [self.expenseBtn setSelected:NO];
            [self.incomeBtn setSelected:YES];
        }
    }
    if(self.accounts.autoClear == nil)
    {
        self.autoClearSwitch.on =TRUE;
        
    }
    else
        self.autoClearSwitch.on =[self.accounts.autoClear boolValue];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
     
    self.amountText.text = [appDelegate.epnc formatterString:accAmount];

  	if ([appDelegate.epnc dateIsToday:_datePicker.date])
	{
		_timeLabel.text = NSLocalizedString(@"VC_Today", nil);
	}
	else 
	{
		_timeLabel.text =  [outputFormatter stringFromDate:_datePicker.date];
	}
    self.typeLabel.text =_accountType.typeName;

}

#pragma mark custom button action




- (IBAction)incomeBtnPressed:(id)sender
{
    [self.incomeBtn setSelected:YES];
    [self.expenseBtn setSelected:NO];
}

- (IBAction)expenseBtnPressed:(id)sender
{
    [self.incomeBtn setSelected:NO];
    [self.expenseBtn setSelected:YES];
}
#pragma mark nav button event

- (void) cancel:(id)sender
{
    //只要是增加了ipad的都是 dismiss
	if([self.typeOftodo isEqualToString:@"IPAD_ADD"])
	{
       [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
	}
    else if ([self.typeOftodo isEqualToString:@"IPAD_EDIT"])
    {
        [[self navigationController]dismissViewControllerAnimated:YES completion:nil];
    }
	else
	{ 
        [[self navigationController] popViewControllerAnimated:YES];
	}
}

- (void) save:(id)sender
{
 	NSError *errors;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
 	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors];
    [aevc_accountArray setArray:objects];

	
	NSMutableArray	*accountsList =	[[NSMutableArray alloc] initWithArray:objects];

    
    if (self.accounts != nil)
    {
        BOOL hasFound = NO;
        for (int i=0; i<[accountsList count]; i++)
        {
            Accounts *oneAccount = [accountsList objectAtIndex:i];
            if (oneAccount == self.accounts)
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
 	if([_nameText.text length] == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Account name is needed.", nil)
														   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
        appDelegate_iPhone.appAlertView = alertView;
        return;
	}
 	
	for (Accounts *tmpAccount in accountsList)
	{
		if([tmpAccount.accName isEqualToString:self.nameText.text]&&tmpAccount!=self.accounts)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_Account Name already exists.", nil)
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
			[alert show];
            appDelegate_iPhone.appAlertView = alert;
			return;
		}
	}
    
    
    if ([self.typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        if (!_autoClearSwitch.on)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"07_ACC_AUOFF"];
        }
    }
    else
    {
        if (_autoClearSwitch.on != [_accounts.autoClear boolValue])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"07_ACC_AUOFF"];
        }
    }
    
    if(_accounts == nil)
        _accounts= [NSEntityDescription insertNewObjectForEntityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    
    //1.name
	_accounts.accName = _nameText.text;
    //2.amount
    if (_incomeBtn.selected==TRUE || accAmount==0)
    {
        _accounts.amount = [NSNumber numberWithDouble:fabs(accAmount)];
    }
    else
    {
        _accounts.amount = [NSNumber numberWithDouble:-fabs(accAmount)];
    }
    //3.accountType
    _accounts.accountType = _accountType;
    
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	//4.dateTime
 	NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.datePicker.date];
	[parts1 setHour:0];
	[parts1 setMinute:0];
	[parts1 setSecond:1];
	_accounts.dateTime = [[NSCalendar currentCalendar] dateFromComponents:parts1];
    //5.autoClear
    _accounts.autoClear = [NSNumber numberWithBool:_autoClearSwitch.on];
    
    //6.orderIndex
    if ([self.typeOftodo isEqualToString:@"IPAD_ADD"]||[self.typeOftodo isEqualToString:@"ADD"]) {
        _accounts.orderIndex =  [NSNumber numberWithLong:[aevc_accountArray count]];
        
        //7.uuiv
        _accounts.uuid =  [EPNormalClass GetUUID];
    }
        
        
    //8.dateTime_sync
    _accounts.dateTime_sync = [NSDate date];
    
    //9.state
    _accounts.state = @"1";
    
    UIButton *btn=_formerSelectedBtn;
    _accounts.accountColor=[NSNumber numberWithInteger:btn.tag];

    
 	if(![appDelegate.managedObjectContext save:&errors])
	{
		NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
	}
    
    //sync
    
//    if ([appDelegate_iPhone.dropbox drop_account] != nil)
//    {
//        [appDelegate_iPhone.dropbox updateEveryAccountDataFromLocal:_accounts];
//    }

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateAccountFromLocal:_accounts];
    }
    
    if ([self.typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        if (_accountPickerViewController != nil)
        {
            _accountPickerViewController.selectedAccount = _accounts;
        }
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"05_ACC_ADD"];
    }
    
  	if([self.typeOftodo isEqualToString:@"IPAD_ADD"]||[self.typeOftodo isEqualToString:@"IPAD_EDIT"])
	{
        if (self.iAccountViewController != nil) {
            [self.iAccountViewController reFleshTableViewData_withoutReset];
        }
        else if (_accountPickerViewController != nil)
        {
            [[self navigationController] popViewControllerAnimated:YES];
            return;
        }
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
	}
	else
	{
        [[self navigationController] popViewControllerAnimated:YES];
	}
}

 
#pragma mark text delegate

-(IBAction)EditChanged:(UITextField *)sender
{
    [self deleteDatePickerCell];
    if (sender == _amountText) {
        accAmount =  [self.amountText.text doubleValue ];
    }
}
-(IBAction)TextDidEnd:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	self.amountText.text = [appDelegate.epnc formatterString:accAmount];

}

 - (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self deleteDatePickerCell];

    if(textField == _amountText)
    {
        if(accAmount ==0)self.amountText.text =@"";
            else
        self.amountText.text = [NSString stringWithFormat:@"%.2f",accAmount];


    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; 
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
		self.amountText.text = valueStr;
	}
	return YES;	

//	if(textField == amountText)
//	{
// 		if([string length]>0)
//		{
//			if([amountText.text length]>12)
//				return NO;
//			else
//			{
//				string = [string stringByReplacingOccurrencesOfRegex:@"[^0-9.]" withString:@""];
//				if([string  isEqualToString: @""])
//					return NO;
//                NSArray *tmp = [amountText.text componentsSeparatedByString:@"."];
//                if ([tmp count]==2) {
//                    if([string isEqualToString:@"."]) return NO;
//                         NSString *tmpString = [tmp objectAtIndex:1];
//                        if([tmpString length]>=2)
//                            return NO;
//                        else
//                            return YES;
//                }
//                else
//                {
//                    return YES;  
//                }
//            }
//		}
//		
//	}
//	return YES;	
}

#pragma mark date picker delegate
-(IBAction)dateSelected
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
  	if ([appDelegate.epnc dateIsToday:_datePicker.date])
	{
		_timeLabel.text = NSLocalizedString(@"VC_Today", nil);
	}
	else 
	{
		
		_timeLabel.text =  [outputFormatter stringFromDate:_datePicker.date];
	}
}
 
#pragma mark Table view methods
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedRow==2 && indexPath.row==3)
    {
        return 216;
    }
    else if (_selectedRow==2 && indexPath.row==6)
    {
        return 119;
    }
    else if (_selectedRow==0 && indexPath.row==5)
    {
        return 119;
    }
    else
        return 44.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedRow==2)
        return 7;
    else
        return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(indexPath.row == 0)
	{
		return _nameCell;
	}
	if (indexPath.row == 1)
	{
		return _amountCell;
	}
	if(indexPath.row == 2)
	{
		return  _TimeCell;
	}
	else
    {
        if (_selectedRow==2)
        {
            if (indexPath.row==3)
            {
                return _datePickerCell;
            }
            else if(indexPath.row == 4)
            {
                return _typeCell;
            }
            else if(indexPath.row == 5)
            {
                return _autoClearCell;
            }
            else
            {
                [self setBackGroundCellBtn];
                return _colorSelectCell;
            }
        }
        else
        {
            if(indexPath.row == 3)
            {
                return _typeCell;
            }
            else if(indexPath.row == 4)
            {
                return _autoClearCell;
            }
            else
            {
                [self setBackGroundCellBtn];
                return _colorSelectCell;
            }
        }
    }
}
-(void)setBackGroundCellBtn
{
    
    
    
    _colorBtnArray=[NSMutableArray array];
    float interval=30;
    UIColor *col1=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:255/255.0 alpha:1];
    UIColor *col2=[UIColor colorWithRed:107/255.0 green:156/255.0 blue:255/255.0 alpha:1];
    UIColor *col3=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
    UIColor *col4=[UIColor colorWithRed:75/255.0 green:211/255.0 blue:177/255.0 alpha:1];
    UIColor *col5=[UIColor colorWithRed:44/255.0 green:204/255.0 blue:81/255.0 alpha:1];
    UIColor *col6=[UIColor colorWithRed:239/255.0 green:185/255.0 blue:53/255.0 alpha:1];
    UIColor *col7=[UIColor colorWithRed:253/255.0 green:133/255.0 blue:68/255.0 alpha:1];
    UIColor *col8=[UIColor colorWithRed:252/255.0 green:83/255.0 blue:96/255.0 alpha:1];
    UIColor *col9=[UIColor colorWithRed:200/255.0 green:115/255.0 blue:239/255.0 alpha:1];
    NSArray *colorArray=@[col1,col2,col3,col4,col5,col6,col7,col8,col9];
    
    for (int i=0; i<9; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15+(30+interval)*i, 38, 30, 30)];
        btn.backgroundColor=[colorArray objectAtIndex:i];
        [btn.layer setCornerRadius:6];
        btn.layer.masksToBounds=YES;
        [_colorSelectCell.contentView addSubview:btn];
        btn.tag=i;
        [btn setImage:[UIImage imageNamed:@"newaccount_selecte"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeAccountColor:) forControlEvents:UIControlEventTouchUpInside];
        [_colorBtnArray addObject:btn];
    }

    NSString *accType=self.accountType.typeName;
    if ([accType isEqualToString:@"Credit Card"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:0];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Debit Card"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:2];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Asset"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:3];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Savings"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:4];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Cash"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:5];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Checking"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:6];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Loan"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:7];
        _formerSelectedBtn.selected=YES;
    }
    else if ([accType isEqualToString:@"Investing/Retirement"])
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:8];
        _formerSelectedBtn.selected=YES;
    }
    else
    {
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:1];
        _formerSelectedBtn.selected=YES;
    }
    
    
    //accountColor有数据,获取存储color
    if (_accounts.accountColor)
    {
        NSInteger *colorNum=[_accounts.accountColor integerValue];
        _formerSelectedBtn.selected=NO;
        _formerSelectedBtn=[_colorBtnArray objectAtIndex:colorNum];
        _formerSelectedBtn.selected=YES;
    }
    
}

-(void)changeAccountColor:(id)sender
{
    _formerSelectedBtn.selected=NO;
    _formerSelectedBtn=sender;
    _formerSelectedBtn.selected=YES;
}

 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_mytableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedRow==0 && indexPath.row==2)
    {
        _selectedRow = 2;
    }
    else
        _selectedRow=0;
    
 	if(indexPath.row == 0)
	{
		[self.nameText becomeFirstResponder];


 	}
    else if(indexPath.row == 1)
	{
		[self.amountText becomeFirstResponder];

    }
	else if (indexPath.row == 2)
	{
		[self hideKeyBoard];

    }
	
	
    else if(indexPath.row == 3)
    {
        [self hideKeyBoard];
         self.iAccountTypeViewController = [[ipad_AccountTypeViewController alloc] initWithNibName:@"ipad_AccountTypeViewController" bundle:nil];
        
		self.iAccountTypeViewController.accEditView = self;
 		[self.navigationController pushViewController:self.iAccountTypeViewController animated:YES];



    }
    [self insertorDelegateDatePickerCell];

}

-(void)deleteDatePickerCell
{
    _selectedRow = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (_selectedRow==2)
    {
        if ([_mytableView numberOfRowsInSection:0]==6)
        {
            [_mytableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else
    {
        if ([_mytableView numberOfRowsInSection:0]==7) {
            [_mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}




#pragma mark View life cycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    if( [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] isEqualToString:@"7"])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
 	[self initNavBarStyle];
    [self initControlStyleAndEvent];
    [self initMemoryDefine];
    [self setDefaultValueForControler];
    
    [FIRAnalytics setScreenName:@"account_edit_view_ipad" screenClass:@"ipad_AccountEditViewController"];

}

- (void)viewWillAppear:(BOOL)animated
{
    
	[super viewWillAppear:animated];
    self.iAccountTypeViewController = nil;

    
    if (fistToBeHere==0 && [self.typeOftodo isEqualToString:@"IPAD_ADD"]) {
        fistToBeHere = 1;
        [_nameText becomeFirstResponder];
    }
    
    [_mytableView reloadData];
}

-(void)refleshUI
{
    if (self.iAccountTypeViewController != nil)
    {
        [self.iAccountTypeViewController refleshUI];
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
	return TRUE;
}

#pragma mark View release and dealloc

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}





@end


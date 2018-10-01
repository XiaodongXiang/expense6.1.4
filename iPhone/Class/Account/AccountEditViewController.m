//
//  NewAccountViewController.m
//
//  Created by BHI_James on 4/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "AccountEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "Accounts.h"
#import "AccountType.h"
#import "AccountTypeViewController.h"
#import "RegexKitLite.h"

#import "AppDelegate_iPhone.h"
#import "DropboxSyncTableDefine.h"
#import "DropboxObject.h"
#import "EPNormalClass.h"
#import <Dropbox/Dropbox.h>
#import "NSStringAdditions.h"
#import "AccountsViewController.h"
#import "PokcetExpenseAppDelegate.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

#import "UIDevice.h"

@interface AccountEditViewController ()
{
}
@end

@implementation AccountEditViewController


#pragma mark - View Init Controls Style and memory pointer
-(void)initPoint
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [_amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    _nameLabelText.text = NSLocalizedString(@"VC_NewAccount", nil);
    _balanceLabelText.text = NSLocalizedString(@"VC_StartBalance", nil);
    _dateLabelText.text = NSLocalizedString(@"VC_OpenDate", nil);
    _typeLabelText.text = NSLocalizedString(@"VC_Type", nil);
    
    _clearedLabelText.text = NSLocalizedString(@"VC_AutoClear", nil);
    
	_pickerArray = [[NSMutableArray alloc] init];
    _outputFormatter  = [[NSDateFormatter alloc] init];
    _aevc_accountTypeArray = [[NSMutableArray alloc]init];
	[_outputFormatter setDateFormat:@"MMM dd, yyyy"];
    _aevc_accountTypeArray = [[NSMutableArray alloc]init];
    _aevc_accountArray = [[NSMutableArray alloc]init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIImage *plusImage=[UIImage imageNamed:[NSString customImageName:@"plus"]];
    UIImage *reduImage=[UIImage imageNamed:[NSString customImageName:@"reduction"]];
    
    self.signView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-plusImage.size.height, plusImage.size.width, plusImage.size.height)];
    self.signBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, plusImage.size.width, plusImage.size.height)];
    [self.signBtn setImage:plusImage forState:UIControlStateSelected];
    [self.signBtn setImage:reduImage forState:UIControlStateNormal];
    [self.signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signBtn setSelected:YES];
    NSInteger windowCount=[UIApplication sharedApplication].windows.count;
    [[[UIApplication sharedApplication].windows objectAtIndex:windowCount-1]addSubview:self.signView];
    [self.signView addSubview:self.signBtn];



	
    [_datePicker addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventValueChanged];
    
   
    
 	self.amountText.delegate = self;
    
    //设置背景图片
    self.accountLineHigh.constant = 1/[UIScreen mainScreen].scale;
    self.balanceLineHigh.constant = 1/[UIScreen mainScreen].scale;
    self.typeLineHigh.constant = 1/[UIScreen mainScreen].scale;
    self.clearLineHigh.constant = 1/[UIScreen mainScreen].scale;
    self.dateLineHigh.constant = 1/[UIScreen mainScreen].scale;
    self.datePickerLineHigh.constant = 1/[UIScreen mainScreen].scale;


    self.selectedIndex = nil;
    
    _nameCell.textLabel.text = @"Name";
    _amountCell.textLabel.text = @"Amount";
    _timeCell.textLabel.text = @"Date";
    _datePickerCell.textLabel.text = @"DatePicker";
    _typeCell.textLabel.text = @"Type";
    _autoClearCell.textLabel.text = @"Clear";
    _nameCell.textLabel.hidden = YES;
    _amountCell.textLabel.hidden = YES;
    _timeCell.textLabel.hidden = YES;
    _datePickerCell.textLabel.hidden = YES;
    _typeCell.textLabel.hidden = YES;
    _autoClearCell.textLabel.hidden = YES;
    
    _datePicker.frame=CGRectMake(0, 0, 320, 200);
}


-(void)initNavStyleWithType
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar doSetNavigationBar];

    
    if([self.typeOftodo isEqualToString:@"EDIT"])
	{
 		self.navigationItem.title = NSLocalizedString(@"VC_EditAccount", nil);
    }
 	else 
	{
		self.navigationItem.title =NSLocalizedString(@"VC_NewAccount", nil);
   	}
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    
    UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 90,30);
    NSString *currentLangue = [EPNormalClass currentLanguage];;
    if ([currentLangue isEqualToString:@"en"])
        customerButton1.frame = CGRectMake(0, 0,60, 30);
    [customerButton1 setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [customerButton1.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [customerButton1 setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1] forState:UIControlStateNormal];
    [customerButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [customerButton1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
    self.navigationItem.leftBarButtonItems = @[flexible2,leftButton];

	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0,90, 30);
    if ([currentLangue isEqualToString:@"en"])
        customerButton.frame = CGRectMake(0, 0,60, 30);
	[customerButton setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1] forState:UIControlStateNormal];
    [customerButton setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
	[customerButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    

}

-(void)initContex{
    //name
    self.nameText.text = self.accounts.accName;

    //amount
    _accAmount = [self.accounts.amount doubleValue];
    
    //date
 	if(_accounts == nil ||_accounts.dateTime ==nil)
	{
 		_datePicker.date = [NSDate date];
		
	}
	else {
		_datePicker.date = _accounts.dateTime;
        
	}
    
    //accountType
	if(self.accounts == nil)
	{
        
        BOOL isFound=FALSE;
        for (int i=0; i<[_aevc_accountTypeArray count]; i++) {
            AccountType *at = [_aevc_accountTypeArray objectAtIndex:i];
            if([at.typeName isEqualToString:@"Others"])
            {
                isFound= TRUE;
                _accountType = at ;
                
                break;
            }
        }
        if(!isFound &&[_aevc_accountTypeArray count ]>0)
            _accountType = [_aevc_accountTypeArray objectAtIndex:0] ;
	}
    else
        _accountType =_accounts.accountType;

    //autoClear
    if(self.accounts.autoClear == nil)
    {
        self.autoClearSwitch.on =TRUE;
        
    }
    else
        self.autoClearSwitch.on =[self.accounts.autoClear boolValue];

    
    if(_accAmount < 0)
	{
        [self.signBtn setSelected:NO];
	}
	else {

        [self.signBtn setSelected:YES];
        
	}
}

-(void)setContexShow{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    
    self.amountText.text = [NSString stringWithFormat:@"%.2f",_accAmount];
	self.typeLabel.text =_accountType.typeName;
    if ([appDelegate_iPhone.epnc dateIsToday:_datePicker.date])
	{
		_timeLabel.text = NSLocalizedString(@"VC_Today", nil);
	}
	else
	{
		_timeLabel.text =  [_outputFormatter stringFromDate:_datePicker.date ];
	}
    [_mytableView reloadData];
}


#pragma mark - get data source

-(void)getAccountDataSource{
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
	// Edit the entity name as appropriate.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
   NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];

    [_aevc_accountArray setArray:tmpAccountArray];

}

-(void)getAccountTypeArray{
    NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [_aevc_accountTypeArray setArray:objects];

}
#pragma mark - nav bar button action

- (void) cancel:(id)sender
{

    [_signBtn removeFromSuperview];
    [_nameText resignFirstResponder];
    [_amountText resignFirstResponder];
    
    if([self.typeOftodo isEqualToString:@"IPAD_ADD"]||[self.typeOftodo isEqualToString:@"IPAD_EDIT"])
    {
			PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate.AddPopoverController dismissPopoverAnimated:YES];
 		}
    else if([self.typeOftodo isEqualToString:@"IPAD_PAY_ADD"]){
			PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate.AddThirdPopoverController dismissPopoverAnimated:YES];

    }
    
    
    else if([self.typeOftodo isEqualToString:@"EDIT"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
 }

- (void) save:(id)sender
{
    
    [_signBtn removeFromSuperview];
    NSError *errors;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
 	
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
            [self dismissViewControllerAnimated:YES completion:nil];
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
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"VC_Account name is needed.", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VC_OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alertAction];
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
    
    
    if ([self.typeOftodo isEqualToString:@"ADD"])
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
	if(_signBtn.selected == TRUE || _accAmount==0)
	{
		_accounts.amount = [NSNumber numberWithDouble:fabs(_accAmount)];
	}
	else
	{
		_accounts.amount = [NSNumber numberWithDouble:-fabs(_accAmount)];
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
    if ([self.typeOftodo isEqualToString:@"ADD"]) {
        _accounts.orderIndex =  [NSNumber numberWithLong:[_aevc_accountArray count]];
        
    //7.uuid
        _accounts.uuid =  [EPNormalClass GetUUID];
    }
    //8.dateTime_sync
    _accounts.dateTime_sync = [NSDate date];
    
    //9.state
    _accounts.state = @"1";

    
    //10.color
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
    if ([PFUser currentUser]) {
        [[ParseDBManager sharedManager]updateAccountFromLocal:_accounts];
    }


    if ([self.typeOftodo isEqualToString:@"ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"05_ACC_ADD"];
        if (_accountPickerViewController != nil)
        {
            _accountPickerViewController.selectedAccount = _accounts;
        }
    }
    else if ([self.typeOftodo isEqualToString:@"EDIT"])
        ;
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];


 }

-(void)keyboardDidShow:(NSNotification *)aNotification
{
    [[[UIApplication sharedApplication].windows lastObject]addSubview:self.signView];
}
#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField == _nameText)
    {
        _amountView.hidden = YES;
        _signView.hidden=YES;

    }
    [[[UIApplication sharedApplication].windows lastObject]addSubview:self.signView];
}
- (IBAction) amountTextDid:(id)sender
{
    

    
    _amountView.hidden = NO;
    _signView.hidden=NO;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
//    self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, 132);
    [UIView commitAnimations];


 }

-(IBAction)EditChanged:(UITextField *)sender
{
    if (sender==_amountText)
    {
        _accAmount =  [self.amountText.text doubleValue] ;
    }
}


-(IBAction)TextDidEnd:(UITextField *)sender
{
    if (sender == _amountText) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.amountText.text = [appDelegate.epnc formatterString:_accAmount];
    }

}
 
 
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

#pragma mark Picker view delege
-(IBAction)dateSelected
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
   	if ([appDelegate.epnc dateIsToday:self.datePicker.date])
	{
		_timeLabel.text = NSLocalizedString(@"VC_Today", nil);
	}
	else
	{
		_timeLabel.text =  [_outputFormatter stringFromDate:self.datePicker.date];
        
	}
	
}
- (IBAction) positiveBtnPressed:(id)sender
{
    [_signBtn setSelected:YES];
}

- (IBAction) negativeBtnPressed:(id)sender
{
    [_signBtn setSelected:NO];
}

-(void)signBtnClick:(id)sender
{
    UIButton *btn=sender;
    if (btn.selected)
    {
        btn.selected=NO;
    }
    else
    {
        btn.selected=YES;
    }
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex && indexPath.row==3)
    {
        return 216;
    }
    else if (self.selectedIndex && indexPath.row==6)
    {
        return 119;
    }
    else if (!self.selectedIndex && indexPath.row==5)
    {
        return 119;
    }
    else
        return 44.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex)
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
	else if (indexPath.row == 1)
	{
 		return _amountCell;
	}
    else if (indexPath.row==2)
        return _timeCell;
    
    else if (self.selectedIndex)
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
            return _autoClearCell;
        else
        {
            [self setBackGroundCellBtn];
            return _backgroundCell;
        }
    }
    if(indexPath.row == 3)
    {
        return _typeCell;
    }
    else if(indexPath.row == 4)
        return _autoClearCell;
	else
    {
        [self setBackGroundCellBtn];
        return _backgroundCell;
    }
}
-(void)setBackGroundCellBtn
{
    

    
    _colorBtnArray=[NSMutableArray array];
    float interval=(SCREEN_WIDTH-15*2-30*6)/5;
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
    
    for (int i=0; i<6; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15+(30+interval)*i, 38, 30, 30)];
        btn.backgroundColor=[colorArray objectAtIndex:i];
        [btn.layer setCornerRadius:6];
        btn.layer.masksToBounds=YES;
        [_backgroundCell.contentView addSubview:btn];
        btn.tag=i;
        [btn setImage:[UIImage imageNamed:@"newaccount_selecte"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeAccountColor:) forControlEvents:UIControlEventTouchUpInside];
        [_colorBtnArray addObject:btn];
    }
    for (int i=0; i<3; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15+(30+interval)*i, 79, 30, 30)];
        btn.backgroundColor=[colorArray objectAtIndex:i+6];
        [btn.layer setCornerRadius:6];
        btn.layer.masksToBounds=YES;
        [_backgroundCell.contentView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"newaccount_selecte"] forState:UIControlStateSelected];
 
        btn.tag=i+6;
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
    UITableViewCell *checkcell = [_mytableView cellForRowAtIndexPath:indexPath];

    [_mytableView beginUpdates];
    
    if (self.selectedIndex)
    {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section] ] withRowAnimation:UITableViewRowAnimationFade];
        self.selectedIndex = nil;
    }
    else
    {
        if (indexPath.row==2)
        {
            self.selectedIndex = indexPath;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.selectedIndex.row+1) inSection:self.selectedIndex.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
        
    
 	if([checkcell.textLabel.text isEqualToString:@"Name"])
	{
		[self.nameText becomeFirstResponder];
         [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
//        self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, 176);
	 	[UIView commitAnimations];
        
        _amountView.hidden = YES;
        _signView.hidden=YES;

	}
	else if([checkcell.textLabel.text isEqualToString:@"Amount"])
	{
		[self.amountText becomeFirstResponder];
        _amountView.hidden = NO;
        _signView.hidden=NO;

        [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
//        self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, 132);
	 	[UIView commitAnimations];


	}
    else if ([checkcell.textLabel.text isEqualToString:@"Date"])
    {
        [self.nameText resignFirstResponder];
        [self.amountText resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
//        self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _amountView.hidden = YES;
        _signView.hidden=YES;

    }
	else if([checkcell.textLabel.text isEqualToString:@"Type"])
	{
        [self.nameText resignFirstResponder];
        [self.amountText resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
//        self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _amountView.hidden = YES;
        _signView.hidden=YES;

 		
		self.accountTypeViewController = [[AccountTypeViewController alloc] initWithStyle:UITableViewStylePlain];
		 
		self.accountTypeViewController.accEditView = self;
 		[self.navigationController pushViewController:self.accountTypeViewController animated:YES];
	}
    [_mytableView endUpdates];
    
}





#pragma mark Table View Scroll delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.nameText resignFirstResponder];
    [self.amountText resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
//    self.mytableView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
   
    _amountView.hidden = YES;
    _signView.hidden=YES;

}
#pragma mark - View Life Cycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavStyleWithType];
    [self initPoint];
    [self getAccountTypeArray];

    [self initContex];
    




    [self.nameText becomeFirstResponder];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{		

	[super viewWillAppear:animated];
    
    self.accountTypeViewController = nil;
    [self getAccountDataSource];
    [self getAccountTypeArray];
    [self setContexShow];
    [_mytableView reloadData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)reflashUI{
    if (self.accountTypeViewController != nil) {
        [self.accountTypeViewController reflashUI];
    }
    else
    {
        [self getAccountDataSource];
        [self getAccountTypeArray];
        [self setContexShow];
    }
}
-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
}



@end

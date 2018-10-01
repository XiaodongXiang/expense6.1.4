//
//  NewBillViewController.m
//  Expense 5
//
//  Created by BHI_James on 5/4/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "BillEditViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"

#import "BillCategoryViewController.h"
#import "RecurringViewController.h"
#import "ReminderViewController.h"
#import "BillPayViewController.h"
#import "EndDateViewController.h"

#import "RegexKitLite.h"
#import "PayeeSearchCell.h"
#import "EPNormalClass.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

static int monthCount = 0;

@implementation BillEditViewController

#pragma mark View DidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _thisBillisBeenDelete = NO;
    [self setTableCellTitleForMark];
    [self initMemoryDefine];
    [self initNavBarStyle];
    [self initControlValueByBill];
    
    
    self.startDatePicker.frame=CGRectMake(0, 0, 320, 200);
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:_amount];
 	self.categoryLabel.text = self.categories.categoryName;
	self.startDateLabel.text = [_outputFormatter stringFromDate:self.starttime];
    
	   
	[self.mytableView reloadData];
    _payeeView.hidden = YES;
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPhone.adsView.hidden = YES;
}

-(void)refleshUI{
    if (self.billCategoryViewController != nil) {
        [self.billCategoryViewController refleshUI];
    }
}

#pragma mark View DidLoad Method
-(void)setTableCellTitleForMark
{
 	_nameCell.textLabel.text =@"Name";
	_amountCell.textLabel.text =@"Amount";
	_payeeCell.textLabel.text =@"Payee";
 	_categoryCell.textLabel.text =@"Category";
	_startDateCell.textLabel.text =@"StartDate";
	_cycleCell.textLabel.text =@"Cycle";
	_remindCell.textLabel.text =@"Remind";
	_notesCell.textLabel.text =@"Notes";
    
    _endDateCell.textLabel.text = @"End date";
    _nameCell.textLabel.hidden = TRUE;
	_amountCell.textLabel.hidden = TRUE;
	_payeeCell.textLabel.hidden = TRUE;
 	_categoryCell.textLabel.hidden = TRUE;
	_startDateCell.textLabel.hidden = TRUE;
	_cycleCell.textLabel.hidden = TRUE;
	_remindCell.textLabel.hidden = TRUE;
	_notesCell.textLabel.hidden = TRUE;
    _endDateCell.textLabel.hidden = TRUE;
}
 
-(void)initMemoryDefine
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [_amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    _nameLabelText.text = NSLocalizedString(@"VC_Name", nil);
    _amountLabelText.text = NSLocalizedString(@"VC_Amount", nil);
    _payeeLabelText.text = NSLocalizedString(@"VC_Payee", nil);
    _categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    _dateLabelText.text = NSLocalizedString(@"VC_DueDate", nil);
    _repeatLabelText.text = NSLocalizedString(@"VC_Repeat", nil);
    _alertLabelText.text = NSLocalizedString(@"VC_Alert", nil);
    
    _endDateLabelText.text = NSLocalizedString(@"VC_EndDate", nil);
    
    _headerDateormatter = [[NSDateFormatter alloc]init];
    [_headerDateormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    _payeeText.autocorrectionType = UITextAutocorrectionTypeNo;

    _categoryLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
    _cycleLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
    _remindLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
    
    [_nameLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_amountLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_payeeLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_categoryLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_categoryLabel setHighlightedTextColor:[appDelegate.epnc getAmountGrayColor]];
    [_dateLabelText  setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_startDateLabel setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_repeatLabelText setHighlightedTextColor:[appDelegate.epnc getAmountBlackColor]];
    [_cycleLabel setHighlightedTextColor:[appDelegate.epnc getAmountGrayColor]];
    [_alertLabelText setHighlightedTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
    [_remindLabel setHighlightedTextColor:[appDelegate.epnc getAmountGrayColor]];


    
    
    selectedCellIntenger = -1;
    if (self.starttime != nil)
    {
        _startDatePicker.date = self.starttime;

    }
    else
        _startDatePicker.date = [NSDate date];
	_isDelete = FALSE;
	_categoryArray = [[NSMutableArray alloc] init];
    _payeeArray = [[NSMutableArray alloc]init];
    
	_outputFormatter = [[NSDateFormatter alloc] init];
	[_outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];
    
	_daysFormatter = [[NSDateFormatter alloc] init];
	[_daysFormatter setDateFormat:@"dd"];
	
	if(self.categories == nil)
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
		NSError *error =nil;
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
		[fetchRequest setEntity:entity];
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
        [fetchRequest setPredicate:predicate];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		[_categoryArray setArray:objects];

		
		
		for (Category *tmpCategory in _categoryArray)
		{
			if([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"EXPENSE"])
			{
				self.categories = tmpCategory;
				break;
			}
		}
	}
    
    [_startDatePicker addTarget:self action:@selector(startDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _payeeText.delegate = self;
    [_payeeText addTarget:self action:@selector(payeeTextEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _selectedRowIndexPath = nil;
    
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;


    if([self.typeOftodo isEqualToString:@"ADD"] )
	{
        self.navigationItem.title = NSLocalizedString(@"VC_NewBill", nil);
  	}
 	else if([self.typeOftodo isEqualToString:@"EDIT"])
	{
		self.navigationItem.title = NSLocalizedString(@"VC_EditBill", nil);
    }
    
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 90, 30);
    [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

 	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveBtn.titleLabel setMinimumScaleFactor:0];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [saveBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];

}

-(void)initControlValueByBill
{
    if([self.typeOftodo isEqualToString:@"ADD"] )
	{
        
		if(self.starttime==nil)
        {
            self.starttime = [NSDate date];
        }
        [_nameText becomeFirstResponder];
        
        _recurringType = @"Never";
        _cycleLabel.text = NSLocalizedString(@"VC_Never", nil);
        
        self.reminderDateString = @"None";
        self.remindLabel.text = NSLocalizedString(@"VC_None", nil);
        
        self.endtime = nil;

 	}
 	else if([self.typeOftodo isEqualToString:@"EDIT"])
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

        self.categories = _billFather.bf_category;
		self.payee = _billFather.bf_payee;
		self.amount = _billFather.bf_billAmount;
        
		self.nameText.text = _billFather.bf_billName;
        self.recurringType = _billFather.bf_billRecurringType;
		self.cycleLabel.text = [appDelegate.epnc changeRecurringTypetoLocalLangue_bill:_billFather.bf_billRecurringType];
        self.reminderDateString = self.billFather.bf_billReminderDate;
        self.reminderTime = self.billFather.bf_billReminderTime;
        if (![self.billFather.bf_billReminderDate isEqualToString:@"None"]&&![self.billFather.bf_billReminderDate isEqualToString:@"No Reminder"])
        {
            NSString *reminderText = [appDelegate.epnc changeReminderTexttoLocalLangue:self.billFather.bf_billReminderDate];
            self.remindLabel.text = [NSString stringWithFormat:@"%@ %@",reminderText,self.billFather.bf_billReminderTime];
        }
        else
            self.remindLabel.text = NSLocalizedString(@"VC_None", nil);
        
		self.memoTextView.text = self.billFather.bf_billNote;
		self.starttime = self.billFather.bf_billDueDate;
		self.endtime = self.billFather.bf_billRule.ep_billEndDate;
		if (self.billFather.bf_payee!= nil)
		{
			self.payeeText.text = self.billFather.bf_payee.name;
		}
		else 
		{
			self.payeeText.text = @"";
		}
		
 		_isDelete = FALSE;
	}
    if(self.payee==nil)
	{
		self.payeeText.text = @"";
	}
	else {
		self.payeeText.text = self.payee.name;
	}
    
    //memo
    if ([_memoTextView.text length]>0) {
        _memoLabel.text = @"";
    }
    else
        _memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    
    //end time
    if (self.endtime == nil)
    {
        _endDateLabel.text = NSLocalizedString(@"VC_Forever", nil);
    }
    else
        _endDateLabel.text = [_outputFormatter stringFromDate:self.endtime];

}




 
- (IBAction)didEndEdit
{
	[_nameText resignFirstResponder];
	[_amountText resignFirstResponder];
}


#pragma mark textField delegate
//name
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self deleteDatePickerCell];
}

//amount
//------amount textField
- (IBAction)amountTextDid:(id)sender
{
    [self deleteDatePickerCell];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:_amount];
    
}

-(IBAction)EditChanged:(id)sender
{
	_amount = [self.amountText.text doubleValue];
}

-(IBAction)TextDidEnd:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:_amount];
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
				if([string  isEqual: @""])
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
    //IOS7上面,UITextField右对齐得时候，输入空格会不显示出来
    else if (textField == _payeeText || textField==_nameText)
    {
        
        if (range.location == textField.text.length && [string isEqualToString:@" "]) {
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@"\u00a0"];
            return NO;
        }
    }
	return YES;
}


//payee
-(void)payeeTextEditChanged:(id)sender
{
    [self deleteDatePickerCell];
    
    if([self.payeeText.text length]>0)
    {
        [self getPayeeSearchDataSource];
        
    }
    else {
        _payeeView.hidden = YES;
    }
}

-(void)getPayeeSearchDataSource{
    
    NSString *text = self.payeeText.text;
    [_payeeArray removeAllObjects];
    if([text length]!=0)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSError * error=nil;
        NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"name beginswith[c] %@ && state contains[c] %@ && category.categoryType LIKE[c] %@", text,@"1",@"EXPENSE"];
        [fetchRequest setPredicate:predicate];
 	 	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; // generate a description that describe which field you want to sort by
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [_payeeArray setArray:objects ];

    }
    [self.payeeTableView reloadData];
    if([_payeeArray count] == 0)
    {
        _payeeView.hidden = YES;
        
    }
    else {
        float payeeHigh = _mytableView.contentOffset.y;
        self.payeeView.frame = CGRectMake(0, 165, 320, self.payeeView.frame.size.height);
        
        if (payeeHigh!=0)
            self.payeeView.frame = CGRectMake(0, self.payeeView.frame.origin.y-payeeHigh, 320, self.payeeView.frame.size.height);
        _payeeView.hidden = NO;
    }
}

//-----textView
//---UITextView 当没点击cell点击的是cell中的UITextField的时候，设置当前点击的属于哪个cell
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] <8) {
        hight = _mytableView.frame.size.height-textView.superview.superview.superview.frame.origin.y-textView.frame.size.height;
    }
    else
        hight =_mytableView.frame.size.height-textView.superview.superview.frame.origin.y-textView.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh_memo = 216-hight;
        [_mytableView setContentOffset:CGPointMake(0, keyBoardHigh_memo) animated:YES];
    }
    
//    [self deleteDatePickerCell];
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





#pragma mark

#pragma mark Table View Scroll delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView == _mytableView) {
        [self.nameText resignFirstResponder];
        [self.amountText resignFirstResponder];
        _payeeView.hidden = YES;
        [_payeeText resignFirstResponder];
        [_memoTextView resignFirstResponder];
        selectedCellIntenger = -1;

    }
}

#pragma mark UIActionSheet
- (void)cancel:(id)sender
{

    
    if ([self.typeOftodo isEqualToString:@"EDIT"]) {
		[[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
	else 	
		[[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)startDatePickerValueChanged:(id)sender{
    if (self.endtime != nil)
    {
        _startDatePicker.minimumDate = nil;
        _startDatePicker.maximumDate = self.endtime;
    }
    self.starttime = _startDatePicker.date;
    _startDateLabel.text =  [_outputFormatter stringFromDate:self.starttime];
}











-(void)setControlValueByPayee{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    _payeeText.text = self.payee.name;
    _amountText.text =[appDelegate.epnc formatterString:[self.payee.tranAmount doubleValue]];
    self.categories = self.payee.category;
    self.categoryLabel.text = self.categories.categoryName;
}



- (void)save:(id)sender
{
    [_amountText resignFirstResponder];
    [_nameText resignFirstResponder];
    [_payeeText resignFirstResponder];
    [_memoTextView resignFirstResponder];
    
    NSError *errors;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	//空值的判断应该根据btn的不同（不同的button事件出现不同的cell）
	monthCount = 0;
	if([_nameText.text length]==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Name is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        
        appDelegate_iphone.appAlertView = alertView;
        return;
    }
    if(_amount  == 0.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        appDelegate_iphone.appAlertView = alertView;

        return;
    }
    
    //不跑
    if ([appDelegate.epnc dateCompare:self.starttime withDate:self.endtime]>0 && ![_recurringType isEqualToString:@"Never"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"VC_Start date should be earlier than End Date.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
											  otherButtonTitles:nil];
		[alert show];
        appDelegate_iphone.appAlertView = alert;

		return;
    }
    
 	NSError *error = nil;
    
    //payee
    if([_payeeText.text length]>0)
    {
        
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors];
        
        NSMutableArray	*payeesList =	[[NSMutableArray alloc] initWithArray:objects];

        BOOL hasFound = FALSE;
        
        for (Payee *tmpPayee in payeesList)
        {
            if([tmpPayee.name isEqualToString:_payeeText.text] && tmpPayee.category == self.categories)
            {
                hasFound = TRUE;
                self.payee = tmpPayee;
                break;
            }
        }
        
        if(!hasFound)
        {
            AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            self.payee = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
            self.payee.name = _payeeText.text;
            self.payee.memo = _memoTextView.text;
            
            if(self.categories!=nil && [self.categories.categoryType isEqualToString:@"INCOME"])//Income
            {
                self.payee.category = self.categories;
            }
            else if(self.categories!=nil && [self.categories.categoryType isEqualToString:@"EXPENSE"])//Spent
            {
                self.payee.category = self.categories;
            }
            
            self.payee.dateTime = [NSDate date];
            self.payee.state = @"1";
            self.payee.uuid =[EPNormalClass GetUUID];
            
            if (![appDelegate.managedObjectContext save:&errors]) {
                
            }
//            AppDelegate_iPhone *appDelegaet_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//            if (appDelegaet_iPhone.dropbox.drop_account.linked) {
//                [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.payee];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:self.payee];
            }
        }

    }
    //如果是增加一个bill的话————是由add进来的,那么不论什么情况都需要先保存到Bill1中
    if([self.typeOftodo isEqualToString:@"ADD"])
    {
        if(self.payee)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_PYE"];
        }
        if ([_recurringType isEqualToString:@"Never"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_REPT"];
        }
        if (![self.reminderDateString isEqualToString:@"None"]) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_ALRT"];
        }

        
        EP_BillRule *oneBill = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
        
        //设置值
        oneBill.ep_billName = _nameText.text;
        oneBill.ep_billAmount = [NSNumber numberWithDouble:_amount];
        
        oneBill.ep_billDueDate = self.starttime;
        oneBill.ep_billEndDate  = self.endtime;

        oneBill.ep_recurringType = _recurringType;
        oneBill.ep_note = _memoTextView.text;
        
        oneBill.ep_reminderDate = self.reminderDateString;
        oneBill.ep_reminderTime = self.reminderTime;
        
        
        oneBill.billRuleHasBillItem = nil;
        oneBill.billRuleHasCategory = self.categories;
        oneBill.billRuleHasPayee = self.payee;
        oneBill.billRuleHasTransaction = nil;
        
        oneBill.dateTime = [NSDate date];
        oneBill.state = @"1";
        oneBill.uuid = [EPNormalClass GetUUID];
     
        if (![appDelegate.managedObjectContext save:&error])
        {
            
        }
        
        //sync
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox  updateEveryBillRuleDataFromLocal:oneBill];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:oneBill];
        }
    }
    
    else{
        if(self.payee != self.billFather.bf_payee)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_PYE"];
        }
        if (![_recurringType isEqualToString:self.billFather.bf_billRecurringType])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_REPT"];
        }
        if (![self.reminderDateString isEqualToString:self.billFather.bf_billReminderDate]) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_ALRT"];
        }

        
        //修改非循环
        if ([self.billFather.bf_billRecurringType isEqualToString:@"Never"])
        {
            //check if has budget
            NSFetchRequest *fetchBillRule =  [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
            
            NSMutableArray *billRuleArray = [[NSMutableArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchBillRule error:&errors]];
            BOOL hasFound = NO;
            for (long int i=0; i<[billRuleArray count]; i++) {
                EP_BillRule *oneBillRule = [billRuleArray objectAtIndex:i];
                if (oneBillRule == self.billFather.bf_billRule)
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
            
            EP_BillRule *thebill = self.billFather.bf_billRule;
            
            thebill.ep_billName = _nameText.text;
            thebill.ep_billAmount = [NSNumber numberWithDouble:_amount];
            thebill.ep_billDueDate = self.starttime;
            thebill.ep_billEndDate = self.endtime;
            thebill.ep_recurringType = _recurringType;
            thebill.ep_reminderDate = self.reminderDateString;
            thebill.ep_reminderTime = self.reminderTime;
            thebill.ep_note = _memoTextView.text;
            
            thebill.billRuleHasPayee = self.payee;
            thebill.billRuleHasCategory = self.categories;
            
            thebill.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }

//            if (appDelegate.dropbox.drop_account.linked)
//            {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:thebill];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:thebill];
            }
            //设置payment页面的billfather
            [self changeBillPaymentPageBillFather];

        }
        //修改循环的bill
        else
        {
            if (self.billFather.bf_billItem != nil)
            {
                NSFetchRequest *fetchBillItem = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillItem"];
                NSMutableArray *billItemArray = [[NSMutableArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchBillItem error:&errors]];
                
                BOOL hasFound = NO;
                for (long int i=0; i<[billItemArray count]; i++) {
                    EP_BillItem *oneBillItem = [billItemArray objectAtIndex:i];
                    if (oneBillItem == self.billFather.bf_billItem)
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
           
//            NSString *meg = [NSString stringWithFormat:@"This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?",self.billFather.bf_billName];
            
            NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?", nil)];
            NSString *searchString = @"%@";
            //range是这个字符串的位置与长度
            NSRange range = [string1 rangeOfString:searchString];
            [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:self.billFather.bf_billName];
            NSString *meg = string1;
            
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
            
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            //在iPhone中最好用这种方法
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            appDelegate.appActionSheet = actionSheet;
       
            return;
        }
        
    }
    

    
    if ([self.typeOftodo isEqualToString:@"ADD"])
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"11_BIL_ADD"];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)changeBillPaymentPageBillFather
{
    if (self.paymentViewController != nil)
    {
        self.paymentViewController.billFather.bf_billName = _nameText.text;
        self.paymentViewController.billFather.bf_billAmount =_amount;
        self.paymentViewController.billFather.bf_billDueDate = self.starttime;
        self.paymentViewController.billFather.bf_billEndDate = self.endtime;
        self.paymentViewController.billFather.bf_billRecurringType = self.recurringType;
        self.paymentViewController.billFather.bf_billReminderDate = self.reminderDateString;
        self.paymentViewController.billFather.bf_billReminderTime = self.reminderTime;
        self.paymentViewController.billFather.bf_billNote = _memoTextView.text;
        
        self.paymentViewController.billFather.bf_payee = self.payee;
        self.paymentViewController.billFather.bf_category = self.categories;
    }
    
}

-(void)NoCyclyBillChangeToCycleBill
{
    
}

//在设置trans state=0之前需要将tran 外键中关于 trans的外键删掉
-(void)beforeSetTransactionStateto0:(Transaction *)trans
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    //account
    [trans.expenseAccount removeExpenseTransactionsObject:trans];
    [trans.incomeAccount removeIncomeTransactionsObject:trans];
    
    //category
    [trans.category removeTransactionsObject:trans];
    
    //payee
    [trans.payee removeTransactionObject:trans];
    
    //billrule
    [trans.transactionHasBillRule removeBillRuleHasTransactionObject:trans];
    
    //billitem
    [trans.transactionHasBillItem removeBillItemHasTransactionObject:trans];
    
    NSError *error = nil;
    if (![appDelegate_iPhone.managedObjectContext save:&error])
    {
        
    }
}



#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _payeeTableView) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_payeeTableView) {
        return 41;
    }
    else
    {
        if (indexPath.section==0 && indexPath.row==5)
        {
            return 216;
        }
        else if (indexPath.section == 2 && indexPath.row==0) {
            return 182;
            
        }
        else
            return 44.0;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (tableView == _payeeTableView) {
        return 1;
    }
    else
        return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _payeeTableView) {
        return [_payeeArray count];
    }
    else{
        
        if ([self.typeOftodo isEqualToString:@"ADD"]) {
            if (section==0) {
                if (_selectedRowIndexPath.section==0 && _selectedRowIndexPath.row==4)
                {
                    return 6;
                }
                else
                    return 5;
            }
            else if (section==1)
            {
                if (![self.recurringType isEqualToString:@"Never"]) {
                    return 3;
                }
                else
                    return 2;

            }
            else
                return 1;
        }
        else{
            if (section==0) {
                return 4;
            }
            else if (section==1)
                return 1;
            else
                return 1;
        }
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    if (section==0) {
        UILabel *sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 305, 35)];
        NSString *tmpString = [_headerDateormatter stringFromDate:_starttime];
        sectionHeaderLabel.text = [tmpString uppercaseString];;
        [sectionHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [sectionHeaderLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1.f]];
        [sectionHeaderLabel setBackgroundColor:[UIColor clearColor]];
        sectionHeaderLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:sectionHeaderLabel];
    }

    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _payeeTableView) {
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
    else{
        
        if ([self.typeOftodo isEqualToString:@"ADD"]) {
            if (indexPath.section==0 && indexPath.row==0) {
                return _nameCell;
            }
            else if (indexPath.section==0 && indexPath.row==1)
                return _amountCell;
            else if (indexPath.section==0 && indexPath.row==2)
                return _payeeCell;
            else if (indexPath.section==0 && indexPath.row==3)
                return _categoryCell;
            
            else if (indexPath.section==0 && indexPath.row==4)
                return _startDateCell;
            else if (indexPath.section==0 && indexPath.row==5)
                return _datePickerCell;
            
            else if (indexPath.section==1)
            {
                if (indexPath.row==0)
                {
                    return _cycleCell;
                }
                else if (![self.recurringType isEqualToString:@"Never"] && indexPath.row==1)
                {
                    return _endDateCell;
                }
                else
                    return _remindCell;
            }
            else
                return _notesCell;
        }
        else{
            if (indexPath.section==0 && indexPath.row==0) {
                return _nameCell;
            }
            else if (indexPath.section==0 && indexPath.row==1)
                return _amountCell;
            else if (indexPath.section==0 && indexPath.row==2)
                return _payeeCell;
            else if (indexPath.section==0 && indexPath.row==3)
                return _categoryCell;
            else if (indexPath.section==1 && indexPath.row==0)
                return _remindCell;
            
            else
                return _notesCell;
        }
        
    }
	
}

- (void)configureSearchPayeeCell:(PayeeSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	Payee *searchPayee = (Payee *)[_payeeArray objectAtIndex:indexPath.row];

    cell.payeeLabel.text = searchPayee.name;
    cell.categoryLabel.text = searchPayee.category.categoryName;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView==_payeeTableView) {
        self.payee=  (Payee *)[_payeeArray objectAtIndex:indexPath.row] ;
        
        [self setControlValueByPayee];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        _payeeView.hidden = YES;

    }
    else{
        
        
        [_mytableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.textLabel.text isEqualToString:@"StartDate"] && _selectedRowIndexPath==nil)
        {
            _selectedRowIndexPath = indexPath;
        }
        else
            _selectedRowIndexPath = nil;
        
        if([cell.textLabel.text isEqualToString:@"Name"])
        {
            [_nameText becomeFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            
            selectedCellIntenger = 0;

            
        }
        else if([cell.textLabel.text isEqualToString:@"Amount"])
        {
            [_nameText resignFirstResponder];
            [_amountText becomeFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            selectedCellIntenger = 0;

            
        }
        else if([cell.textLabel.text isEqualToString:@"Payee"])
        {
            [_payeeText becomeFirstResponder];
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            
            
            selectedCellIntenger = 0;

        }
        else if([cell.textLabel.text isEqualToString:@"Category"])
        {
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            
            _billCategoryViewController  = [[BillCategoryViewController alloc]initWithNibName:@"BillCategoryViewController" bundle:nil];
            self.billCategoryViewController.billEditViewController = self;
            [self.navigationController pushViewController:self.billCategoryViewController animated:YES];
            selectedCellIntenger = 0;

        }
        else if([cell.textLabel.text isEqualToString:@"StartDate"])
        {
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            selectedCellIntenger = 0;
            
//            [mytableView reloadData];
        }
        else if([cell.textLabel.text isEqualToString:@"Cycle"])
        {
            
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;

            RecurringViewController *recurringViewController = [[RecurringViewController alloc]initWithNibName:@"RecurringViewController" bundle:nil];
            recurringViewController.recurringType = _recurringType;
            recurringViewController.billEditViewController = self;
            [self.navigationController pushViewController:recurringViewController animated:YES];
            selectedCellIntenger = 0;
        }
        else if ([cell.textLabel.text isEqualToString:@"End date"])
        {
            EndDateViewController *endDateViewController = [[EndDateViewController alloc]initWithNibName:@"EndDateViewController" bundle:nil];
            endDateViewController.endDate = self.endtime;
            endDateViewController.billEditViewController = self;
            [self.navigationController pushViewController:endDateViewController animated:YES];
        }
        else if([cell.textLabel.text isEqualToString:@"Remind"])
        {
            
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView resignFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            
            ReminderViewController *reminderViewController = [[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
            reminderViewController.reminderType = self.reminderDateString;
            reminderViewController.reminderTime = self.reminderTime;
            reminderViewController.billEditViewController = self;
            [self.navigationController pushViewController:reminderViewController animated:YES];
            selectedCellIntenger = 0;
        }
        else if([cell.textLabel.text isEqualToString:@"Notes"])
        {
            [_nameText resignFirstResponder];
            [_amountText resignFirstResponder];
            [_memoTextView becomeFirstResponder];
            [_payeeText resignFirstResponder];
            _payeeView.hidden = YES;
            selectedCellIntenger = 1;
            
        }
        
        [self insertorDelegateDatePickerCell];

    }
    
	 
}


-(void)deleteDatePickerCell
{
    _selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (_selectedRowIndexPath.section==0 && _selectedRowIndexPath.row==4)
    {
        if ([_mytableView numberOfRowsInSection:0]==5)
        {
            [_mytableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else
    {
        if ([_mytableView numberOfRowsInSection:0]==6) {
            [_mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}


#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    if (buttonIndex==2)
    {
        return;
    }
    //更改掉后面所有的bill
    else if (buttonIndex==1)
    {
        //首先判断当前修改的bill是不是这个bill1中的第一个，如果是第一个的话，就不需要重新创建bill1
        EP_BillRule *anotherBill;
        if ([appDelegate.epnc dateCompare:self.billFather.bf_billDueDate withDate:self.billFather.bf_billRule.ep_billDueDate]==0)
        {
            //------------修改这个循环bill1中的数据
            anotherBill = self.billFather.bf_billRule;
            //修改billItem
            self.billFather.bf_billItem.ep_billItemName = _nameText.text;
            self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:_amount];
            self.billFather.bf_billItem.ep_billItemNote = _memoTextView.text;
            
            self.billFather.bf_billItem.ep_billItemReminderDate = self.reminderDateString;
            self.billFather.bf_billItem.ep_billItemReminderTime = self.reminderTime;
            self.billFather.bf_billItem.billItemHasCategory = self.categories;
            self.billFather.bf_billItem.billItemHasPayee = self.payee;
            
            self.billFather.bf_billItem.dateTime = [NSDate date];
            //transaction还保持原来的
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
            
//            if (appDelegate.dropbox.drop_account.linked){
//                [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
//            }

            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:self.billFather.bf_billItem];
            }
        }
        else
        {
            EP_BillRule *theOldBill = self.billFather.bf_billRule;
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [cal components:flags fromDate:self.billFather.bf_billDueDate];
            [components setMonth:components.month];
            [components setDay:components.day -1 ];
            NSDate *endDate =[[NSCalendar  currentCalendar]dateFromComponents:components];
            
            theOldBill.ep_billEndDate = endDate;
            theOldBill.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
//            if (appDelegate.dropbox.drop_account.linked)
//            {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:theOldBill];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:theOldBill];
            }
            //-------------重新创建 bill1 对象
            anotherBill = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
            anotherBill.uuid = [EPNormalClass GetUUID];
        }
        
        anotherBill.ep_billName = _nameText.text;
        anotherBill.ep_billAmount = [NSNumber numberWithDouble:_amount];
        
        anotherBill.ep_billDueDate = self.starttime;
        anotherBill.ep_recurringType = _recurringType;
        anotherBill.ep_billEndDate = self.endtime;
        
        anotherBill.ep_reminderDate = self.reminderDateString;
        anotherBill.ep_reminderTime = self.reminderTime;
        anotherBill.ep_note = _memoTextView.text;

        
//        anotherBill.billRuleHasBillItem = nil;
        anotherBill.billRuleHasCategory = self.categories;
        anotherBill.billRuleHasPayee = self.payee;
        anotherBill.billRuleHasTransaction = nil;
        
        anotherBill.state = @"1";
        anotherBill.dateTime = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error])
        {
            
        }
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:anotherBill];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:anotherBill];
        }
        //删除旧的bk_billItem对象，将对应的Transaction的外键保存好。
        if ([[self.billFather.bf_billRule.billRuleHasBillItem allObjects]count]>0)
        {
            NSMutableArray *tmpBilloArray = [[NSMutableArray alloc]initWithArray:[self.billFather.bf_billRule.billRuleHasBillItem allObjects]];
            
            for (int tmpi=0; tmpi<[tmpBilloArray count]; tmpi ++)
            {
                EP_BillItem *tmpBillO = [tmpBilloArray objectAtIndex:tmpi];
                
                //如果这个billItem比当前修改的时间迟的话，就将billItem归入newBill中
                if ([tmpBillO.ep_billItemDueDate compare:self.starttime] == NSOrderedDescending) {
                        if ([[tmpBillO.billItemHasTransaction allObjects]count]>0)
                        {
                            //删除后期的billItem
                            tmpBillO.state = @"0";
                            tmpBillO.dateTime = [NSDate date];
                            if (![appDelegate.managedObjectContext save:&error])
                            {
                                
                            }
//                            if (appDelegate.dropbox.drop_account.linked)
//                            {
//                                [appDelegate.dropbox updateEveryBillItemDataFromLocal:tmpBillO];
//                            }
                            if ([PFUser currentUser])
                            {
                                [[ParseDBManager sharedManager]updateBillItemFormLocal:tmpBillO];
                            }
                        }
                    
                }
                
            }
            
        }
        [self changeBillPaymentPageBillFather];
    }
    //只是本次的bill
    else{
        
        //----------1.创建bill2 类
        if (self.billFather.bf_billItem == nil) {
            self.billFather.bf_billItem = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
            //如果是新建一个BillO,那么需要设定他对应Bill中某一天，如果是老的就不需要设定，就是原始的billDuedate
            self.billFather.bf_billItem.ep_billItemDueDate = self.billFather.bf_billDueDate;
            self.billFather.bf_billItem.billItemHasTransaction = nil;
            
            self.billFather.bf_billItem.ep_billItemString1 = [NSString stringWithFormat:@"%@ %@",self.billFather.bf_billRule.uuid,[appDelegate.epnc getUUIDFromData:self.billFather.bf_billDueDate]];
            
            self.billFather.bf_billItem.state=@"1";
            self.billFather.bf_billItem.uuid = [EPNormalClass GetUUID];
            
        }
        self.billFather.bf_billItem.ep_billItemName = _nameText.text;
        self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:_amount];
         self.billFather.bf_billItem.ep_billItemDueDateNew = self.starttime;
        self.billFather.bf_billItem.ep_billItemRecurringType = self.recurringType;
        self.billFather.bf_billItem.ep_billItemEndDate = self.endtime;
        self.billFather.bf_billItem.ep_billItemNote = _memoTextView.text;
        
        self.billFather.bf_billItem.ep_billItemReminderDate = self.reminderDateString;
        self.billFather.bf_billItem.ep_billItemReminderTime = self.reminderTime;
        
        self.billFather.bf_billItem.billItemHasBillRule = self.billFather.bf_billRule;
        self.billFather.bf_billItem.billItemHasCategory = self.categories;
        self.billFather.bf_billItem.billItemHasPayee = self.payee;
        
        self.billFather.bf_billItem.dateTime = [NSDate date];
        //transaction还保持原来的
        
        if (![appDelegate.managedObjectContext save:&error]) {
            
        }
        
//        if (appDelegate.dropbox.drop_account.linked){
//            [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:self.billFather.bf_billItem];
        }
        
        [appDelegate.epdc saveBillItem:self.billFather.bf_billItem];
        
        
        [self changeBillPaymentPageBillFather];
        
        
    }
    

    
    if ([self.typeOftodo isEqualToString:@"ADD"])
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(void)saveOldBillItem:(EP_BillItem *)tmpnewBillItem{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    tmpnewBillItem.ep_billItemName = _nameText.text;
    tmpnewBillItem.ep_billItemAmount = [NSNumber numberWithDouble:_amount];
//    tmpnewBillItem.ep_billItemDueDateNew = self.starttime;
    tmpnewBillItem.ep_billItemRecurringType = self.recurringType;
    tmpnewBillItem.ep_billItemEndDate = self.endtime;
    tmpnewBillItem.ep_billItemNote = _memoTextView.text;
    
    tmpnewBillItem.ep_billItemReminderDate = self.reminderDateString;
    tmpnewBillItem.ep_billItemReminderTime = self.reminderTime;
    
//    tmpnewBillItem.billItemHasBillRule = self.billFather.bf_billRule;
    tmpnewBillItem.billItemHasCategory = self.categories;
    tmpnewBillItem.billItemHasPayee = self.payee;
    
    tmpnewBillItem.dateTime = [NSDate date];
    //transaction还保持原来的
    
    if (![appDelegate.managedObjectContext save:&error]) {
        
    }
//    if (appDelegate.dropbox.drop_account.linked){
//        [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBillItemFormLocal:self.billFather.bf_billItem];
    }
    [appDelegate.epdc saveBillItem:self.billFather.bf_billItem];
}


-(void)changeBK_BillObjecttoBK_BillandchangeBK_Payment:(EP_BillItem *)tmpBillObject{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    //(1)create new billrule
    if ([[tmpBillObject.billItemHasTransaction allObjects]count]>0) {
        EP_BillRule *tmpnewBill = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
        
        tmpnewBill.ep_billName = tmpBillObject.ep_billItemName;
        tmpnewBill.ep_billAmount = tmpBillObject.ep_billItemAmount;
        
        tmpnewBill.ep_billDueDate = tmpBillObject.ep_billItemDueDate;
        tmpnewBill.ep_recurringType = @"Never";
        tmpnewBill.ep_billEndDate = nil;
        
        tmpnewBill.ep_reminderDate = tmpBillObject.ep_billItemReminderDate;
        tmpnewBill.ep_reminderTime = tmpBillObject.ep_billItemReminderTime;
        
        tmpnewBill.billRuleHasBillItem = nil;
        tmpnewBill.billRuleHasPayee = tmpBillObject.billItemHasPayee;
        tmpnewBill.billRuleHasCategory = tmpBillObject.billItemHasCategory;

        tmpnewBill.state = @"1";
        tmpnewBill.dateTime = [NSDate date];
        tmpnewBill.uuid = [EPNormalClass GetUUID];
        if (![appDelegate.managedObjectContext save:&error]) {
            
        }
        //sync
//        if (appDelegate.dropbox.drop_account.linked) {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:tmpnewBill];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:tmpnewBill];
        }
        //create trans,delete old trans,sync
        NSArray *tmpallPayementArray = [[NSArray alloc]initWithArray:[tmpBillObject.billItemHasTransaction allObjects]];
        while ([[tmpBillObject.billItemHasTransaction allObjects]count] > 0) {
            
            Transaction *tmpBillNewPayment = [tmpallPayementArray objectAtIndex:0];
            
            [self createNewTransWithOldPayment:tmpBillNewPayment withNewBillItem:nil withNewBillRule:tmpnewBill];
            
            
            tmpBillNewPayment.state = @"0";
            tmpBillNewPayment.dateTime_sync = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
            //sync
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryTransactionDataFromLocal:tmpBillNewPayment];
//            }
            if ([PFUser currentUser]) {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:tmpBillNewPayment];
            }
        }
        
    }
    
    //删除每一个BK_BillObject中多余的billO
    tmpBillObject.state = @"0";
    tmpBillObject.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        
    }
//    if (appDelegate.dropbox.drop_account.linked) {
//        [appDelegate.dropbox updateEveryBillItemDataFromLocal:tmpBillObject];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBillItemFormLocal:tmpBillObject];
    }
}

-(void)createNewTransWithOldPayment:(Transaction *)payment withNewBillItem:(EP_BillItem *)billItem withNewBillRule:(EP_BillRule *)billRule{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    Transaction *newTrans = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    newTrans.amount = payment.amount;
    newTrans.dateTime = payment.dateTime;
    newTrans.type = payment.type;
    newTrans.recurringType = payment.recurringType;
    newTrans.isClear = payment.isClear;
    newTrans.notes = payment.notes;
    newTrans.photoName = payment.photoName;
    newTrans.payee = payment.payee;
    newTrans.incomeAccount = payment.incomeAccount;
    newTrans.expenseAccount = payment.expenseAccount;
    newTrans.category = payment.category;
    newTrans.childTransactions = payment.childTransactions;
    newTrans.parTransaction = payment.parTransaction;
    
    newTrans.transactionHasBillRule = billRule;
    newTrans.transactionHasBillItem = billItem;

    
    newTrans.dateTime_sync = [NSDate date];
    newTrans.state = @"1";
    newTrans.uuid = [EPNormalClass GetUUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {

    }
    //sync
//    if (appDelegate.dropbox.drop_account.linked) {
//        [appDelegate.dropbox updateEveryTransactionDataFromLocal:newTrans];
//    }
    if ([PFUser currentUser]) {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:newTrans];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    _mytableView.delegate = nil;
    _mytableView.dataSource = nil;
}

@end

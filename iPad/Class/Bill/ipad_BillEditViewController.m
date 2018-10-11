//
//  NewBillViewController.m
//  Expense 5
//
//  Created by BHI_James on 5/4/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "ipad_BillEditViewController.h"
#import "RegexKitLite.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "ipad_BillsViewController.h"
#import "iPad_BillCategoryViewController.h"
#import "iPad_BillCycleViewController.h"
#import "iPad_ReminderViewController.h"

//#import "ipad_DatePickerViewController.h"
//#import "ipad_TranscationPayeeSelectViewController.h"
#import "BudgetTransfer.h"
#import "ipad_PayeeSearchCell.h"
#import "ipad_PaymentViewController.h"
#import "iPad_EndDateViewController.h"


#import <Parse/Parse.h>
#import "ParseDBManager.h"

static int monthCount = 0;

@implementation ipad_BillEditViewController
@synthesize mytableView,payeeTableView;
@synthesize nameCell,amountCell,payeeCell,startDateCell,cycleCell,remindCell,notesCell,categoryCell;
@synthesize nameText,amountText,startDateLabel,payeeText,cycleLabel,remindLabel,categoryLabel,startDatePicker,reminderDateString,reminderTime;
@synthesize outputFormatter,daysFormatter;
@synthesize typeOftodo;
@synthesize starttime,endtime,categories,payee,amount;
@synthesize activityView;
@synthesize categoryArray,payeeArray;
@synthesize isDelete;
@synthesize realBillDueDate;
@synthesize thisBillisBeenDelete;
@synthesize billFather;
@synthesize payeeView;
@synthesize headerDateormatter;
@synthesize memoLabel,memoTextView;
@synthesize iBillsViewController,iPaymentViewController,iBillCategoryViewController;
@synthesize nameLabelText,amountLabelText,payeeLabelText,categoryLabelText,dateLabelText,repeatLabelText,alertLabelText;
@synthesize recurringType;
@synthesize datePickerCell,selectedRowIndexPath,endDateCell,endDateLabel,endDateLabelText;

#pragma mark View DidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    thisBillisBeenDelete = NO;
    [self initNavBarStyle];
    [self initMemoryDefine];
    [self setTableCellTitleForMark];
    [self initControlValueByBill];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    self.iBillCategoryViewController = nil;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:amount];
 	self.categoryLabel.text = self.categories.categoryName;
	self.startDateLabel.text = [outputFormatter stringFromDate:self.starttime];
    
    if (![self.recurringType isEqualToString:@"Never"])
    {
        if (self.endtime != nil)
        {
            self.startDatePicker.maximumDate = self.endtime;
            self.startDatePicker.minimumDate = nil;
        }
        
    }
	[self.mytableView reloadData];
    payeeView.hidden = YES;
    
    
    
}

-(void)refleshUI{
    if (self.iBillCategoryViewController  != nil) {
        [self.iBillCategoryViewController refleshUI];
    }

}

#pragma mark View DidLoad Method
-(void)setTableCellTitleForMark
{
 	nameCell.textLabel.text =@"Name";
	amountCell.textLabel.text =@"Amount";
	payeeCell.textLabel.text =@"Payee";
 	categoryCell.textLabel.text =@"Category";
	startDateCell.textLabel.text =@"StartDate";
	cycleCell.textLabel.text =@"Cycle";
	remindCell.textLabel.text =@"Remind";
	notesCell.textLabel.text =@"Notes";
    endDateCell.textLabel.text = @"End date";

    nameCell.textLabel.hidden = TRUE;
	amountCell.textLabel.hidden = TRUE;
	payeeCell.textLabel.hidden = TRUE;
 	categoryCell.textLabel.hidden = TRUE;
	startDateCell.textLabel.hidden = TRUE;
	cycleCell.textLabel.hidden = TRUE;
	remindCell.textLabel.hidden = TRUE;
	notesCell.textLabel.hidden = TRUE;
    endDateCell.textLabel.hidden = YES;
}

-(void)initMemoryDefine
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    nameLabelText.text = NSLocalizedString(@"VC_Name", nil);
    amountLabelText.text = NSLocalizedString(@"VC_Amount", nil);
    payeeLabelText.text = NSLocalizedString(@"VC_Payee", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    dateLabelText.text = NSLocalizedString(@"VC_DueDate", nil);
    repeatLabelText.text = NSLocalizedString(@"VC_Repeat", nil);
    alertLabelText.text = NSLocalizedString(@"VC_Alert", nil);
    endDateLabelText.text = NSLocalizedString(@"VC_EndDate", nil);
    
    
    headerDateormatter = [[NSDateFormatter alloc]init];
    [headerDateormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    PokcetExpenseAppDelegate *appDelegate_iphone =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [amountText setFont:[appDelegate_iphone.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    
    nameText.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    payeeText.textColor =[appDelegate_iphone.epnc getGrayColor_156_156_156];
    payeeText.autocorrectionType = UITextAutocorrectionTypeNo;
    
    categoryLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    cycleLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    remindLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    
    
    selectedCellIntenger = -1;
    startDatePicker.backgroundColor = [UIColor whiteColor];
    if (self.starttime != nil)
    {
        startDatePicker.date = self.starttime;
        
    }
    else
        startDatePicker.date = [NSDate date];
	isDelete = FALSE;
	categoryArray = [[NSMutableArray alloc] init];
    payeeArray = [[NSMutableArray alloc]init];
    
	outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"ccc, LLL d, yyyy"];
    
	daysFormatter = [[NSDateFormatter alloc] init];
	[daysFormatter setDateFormat:@"dd"];
	
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
		[categoryArray setArray:objects];
	
		for (Category *tmpCategory in categoryArray)
		{
			if([tmpCategory.isDefault boolValue] && [tmpCategory.categoryType isEqualToString:@"EXPENSE"])
			{
				self.categories = tmpCategory;
				break;
			}
		}
	}
    
    [startDatePicker addTarget:self action:@selector(startDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    payeeText.delegate = self;
    [payeeText addTarget:self action:@selector(payeeTextEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    
    
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 90, 30);
    [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];

    [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [customerButton setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
 	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton    *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [saveBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveBtn.titleLabel setMinimumScaleFactor:0];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [saveBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBar =[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[flexible2,saveBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	if([self.typeOftodo isEqualToString:@"IPAD_ADD"] )
	{
        titleLabel.text =NSLocalizedString(@"VC_NewBill", nil);
  	}
 	else
	{
		titleLabel.text = NSLocalizedString(@"VC_EditBill", nil);
    }
    self.navigationItem.titleView = 	titleLabel;
    
}

-(void)initControlValueByBill
{
    if([self.typeOftodo isEqualToString:@"IPAD_ADD"] )
	{
        
		if(self.starttime==nil)
        {
            self.starttime = [NSDate date];
        }

        
        [nameText becomeFirstResponder];
        
        recurringType = @"Never";
        cycleLabel.text = NSLocalizedString(@"VC_Never", nil);
        
        self.reminderDateString = @"None";
        self.remindLabel.text = NSLocalizedString(@"VC_None", nil);

 	}
 	else
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

        
        self.categories = billFather.bf_category;
		self.payee = billFather.bf_payee;
		self.amount = billFather.bf_billAmount;
        
		self.nameText.text = billFather.bf_billName;
		self.recurringType = billFather.bf_billRecurringType;
		self.cycleLabel.text = [appDelegate.epnc changeRecurringTypetoLocalLangue_bill:billFather.bf_billRecurringType];
        self.reminderDateString = self.billFather.bf_billReminderDate;
        self.reminderTime = self.billFather.bf_billReminderTime;
        if (![self.billFather.bf_billReminderDate isEqualToString:@"None"]&& ![self.billFather.bf_billReminderDate isEqualToString:@"No Reminder"]) {
            self.remindLabel.text = [NSString stringWithFormat:@"%@ %@",self.billFather.bf_billReminderDate,self.billFather.bf_billReminderTime];
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
		
 		isDelete = FALSE;
	}
    if(self.payee==nil)
	{
		self.payeeText.text = @"";
	}
	else {
		self.payeeText.text = self.payee.name;
	}
    
    //memo
    if ([memoTextView.text length]>0) {
        memoLabel.text = @"";
    }
    else
        memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    
}





- (IBAction)didEndEdit
{
	[nameText resignFirstResponder];
	[amountText resignFirstResponder];
}

- (IBAction) amountTextDid:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:amount];
    
}

-(IBAction)EditChanged:(id)sender
{
	amount = [self.amountText.text doubleValue];
}

-(IBAction)TextDidEnd:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:amount];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(textField == amountText)
	{
		NSString *valueStr;
		if([string length]>0)
		{
			if([amountText.text length]>12)
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
				valueStr = [NSString stringWithFormat:@"%.1f",[amountText.text doubleValue]*10];
			}
		}
		else
		{
			valueStr = [NSString stringWithFormat:@"%.3f",[amountText.text doubleValue]/10];
		}
		amountText.text = valueStr;
	}
    //IOS7上面,UITextField右对齐得时候，输入空格会不显示出来
    else if (textField == payeeText || textField==nameText)
    {
        
        if (range.location == textField.text.length && [string isEqualToString:@" "]) {
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@"\u00a0"];
            return NO;
        }
    }
	return YES;
}

//---中英文来回切换的时候
//- (void)keyBoardChangeHight:(NSNotification *)notification{
//
//    if (selectedCellIntenger==1) {
//        NSDictionary *userInfo = [notification userInfo];
//        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];
//
//        NSLog(@"keyboardRect11111:%f",keyboardRect.size.height);
//        if (keyboardRect.size.height > 216){
//            [self.mytableView setContentOffset:CGPointMake(0, keyBoardHigh+36) animated:YES];
//
//        }
//        else if(keyboardRect.size.height > 0){
//            [self.mytableView setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
//        }
//        else
//            [self.mytableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
//    else
//        [self.mytableView setContentOffset:CGPointMake(0, 0) animated:YES];
//}

#pragma mark TextView delegate
-(void)textViewDidChange:(UITextView *)textView
{
//    memoTextView.text =  textView.text;
    if (textView.text.length == 0) {
        memoLabel.text = NSLocalizedString(@"VC_Memo", nil);
    }else{
        memoLabel.text = @"";
    }
}

//---UITextField 当没点击cell点击的是cell中的UITextField的时候，设置当前点击的属于哪个cell
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] <8) {
        hight = mytableView.frame.size.height-textView.superview.superview.superview.frame.origin.y-textView.frame.size.height;
    }
    else
        hight =mytableView.frame.size.height-textView.superview.superview.frame.origin.y-textView.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh_memo = 216-hight+35;
        [mytableView setContentOffset:CGPointMake(0, keyBoardHigh_memo) animated:YES];
    }
    
}

#pragma mark Payee Mehod
-(void)payeeTextEditChanged:(id)sender{
    if([self.payeeText.text length]>0)
    {
        [self getPayeeSearchDataSource];
        
    }
    else {
        payeeView.hidden = YES;
    }
}

-(void)getPayeeSearchDataSource{
    
    NSString *text = self.payeeText.text;
    [payeeArray removeAllObjects];
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
        [payeeArray setArray:objects ];

    }
    [payeeTableView reloadData];
    if([payeeArray count] == 0)
    {
        payeeView.hidden = YES;
        
    }
    else {
        float payeeHigh = mytableView.contentOffset.y;
        self.payeeView.frame = CGRectMake(0, 165, self.payeeView.frame.size.width, self.payeeView.frame.size.height);
        
        if (payeeHigh!=0)
            self.payeeView.frame = CGRectMake(0, self.payeeView.frame.origin.y-payeeHigh, self.payeeView.frame.size.width, self.payeeView.frame.size.height);
        payeeView.hidden = NO;
    }
}

#pragma mark

#pragma mark Table View Scroll delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView == mytableView) {
        [self.nameText resignFirstResponder];
        [self.amountText resignFirstResponder];
        payeeView.hidden = YES;
        [payeeText resignFirstResponder];
        [memoTextView resignFirstResponder];
        selectedCellIntenger = -1;
        
    }
}

#pragma mark UIActionSheet
- (void)cancel:(id)sender
{
    
    
    if ([self.typeOftodo isEqualToString:@"IPAD_EDIT"] || [self.typeOftodo isEqualToString:@"IPAD_ADD"]) {
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
	else
        [self.navigationController popViewControllerAnimated:YES];

}

-(void)startDatePickerValueChanged:(id)sender{
    if (self.endtime != nil)
    {
        startDatePicker.minimumDate = nil;
        startDatePicker.maximumDate = self.endtime;
    }
    self.starttime = startDatePicker.date;
    startDateLabel.text =  [outputFormatter stringFromDate:self.starttime];
}











-(void)setControlValueByPayee{
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    payeeText.text = self.payee.name;
    amountText.text =[appDelegate.epnc formatterString:[self.payee.tranAmount doubleValue]];
    self.categories = self.payee.category;
    self.categoryLabel.text = self.categories.categoryName;
}



- (void)save:(id)sender
{
    [nameText resignFirstResponder];
    [payeeText resignFirstResponder];
    [memoTextView resignFirstResponder];
    
    NSError *errors;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPad  *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
	//空值的判断应该根据btn的不同（不同的button事件出现不同的cell）
	monthCount = 0;
	if([nameText.text length]==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Name is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        appDelegate_iPad.appAlertView = alertView;
        return;
    }
    if(amount  == 0.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        appDelegate_iPad.appAlertView = alertView;
        
        return;
    }
    
    //不跑
    if ([appDelegate.epnc dateCompare:self.starttime withDate:self.endtime]>0 && ![recurringType isEqualToString:@"Never"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"VC_Start date should be earlier than End Date.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
											  otherButtonTitles:nil];
		[alert show];
        appDelegate_iPad.appAlertView = alert;
        
		return;
    }
    
 	NSError *error = nil;
    
    //payee
    if([payeeText.text length]>0)
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
            if([tmpPayee.name isEqualToString:payeeText.text] && tmpPayee.category == self.categories)
            {
                hasFound = TRUE;
                self.payee = tmpPayee;
                break;
            }
        }
        
        if(!hasFound)
        {
            AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            self.payee = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
            self.payee.name = payeeText.text;
            self.payee.memo = memoTextView.text;
            
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
                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                
            }
//            AppDelegate_iPad *appDelegaet_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//            if (appDelegaet_iPhone.dropbox.drop_account.linked)
//            {
//                [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.payee];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:self.payee];
            }
        }
        
    }
    //如果是增加一个bill的话————是由add进来的,那么不论什么情况都需要先保存到Bill1中
    if([self.typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        
        if(self.payee)
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_PYE"];
        }
        if ([recurringType isEqualToString:@"Never"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_REPT"];
        }
        if (![self.reminderDateString isEqualToString:@"None"]) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_ALRT"];
        }

        
        
        EP_BillRule *oneBill = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
        
        //设置值
        oneBill.ep_billName = nameText.text;
        oneBill.ep_billAmount = [NSNumber numberWithDouble:amount];
        
        oneBill.ep_billDueDate = self.starttime;
        oneBill.ep_billEndDate  = self.endtime;
        
        oneBill.ep_recurringType = recurringType;
        oneBill.ep_note = memoTextView.text;
        
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
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
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
        if (![recurringType isEqualToString:self.billFather.bf_billRecurringType])
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
            
            EP_BillRule *thebill = billFather.bf_billRule;
            
            thebill.ep_billName = nameText.text;
            thebill.ep_billAmount = [NSNumber numberWithDouble:amount];
            thebill.ep_billDueDate = self.starttime;
            thebill.ep_billEndDate = self.endtime;
            thebill.ep_recurringType = recurringType;
            thebill.ep_reminderDate = self.reminderDateString;
            thebill.ep_reminderTime = self.reminderTime;
            thebill.ep_note = memoTextView.text;
            
            thebill.billRuleHasPayee = self.payee;
            thebill.billRuleHasCategory = self.categories;
            
            thebill.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
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
            
            
            NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?", nil)];
            NSString *searchString = @"%@";
            //range是这个字符串的位置与长度
            NSRange range = [string1 rangeOfString:searchString];
            [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:self.billFather.bf_billName];
            NSString *meg = string1;
            
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_Just This Bill", nil),NSLocalizedString(@"VC_All Future Bills", nil), nil];

            
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            UITableViewCell *selectedCell = [mytableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            CGPoint point1 = [mytableView convertPoint:selectedCell.frame.origin toView:self.view];
            [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view animated:YES];
            
            
            appDelegate.appActionSheet = actionSheet;
          
            return;
        }
        
    }
    
    if ([self.typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"11_BIL_ADD"];
    }
    
    if ([self.typeOftodo isEqualToString:@"IPAD_ADD"] || [self.typeOftodo isEqualToString:@"IPAD_EDIT"])
    {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
    
    
    if (!appDelegate.isPurchased) {
        ADEngineController* interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"ADTEST - Interstitial"];
        [interstitial showInterstitialAdWithTarget:appDelegate_iPad.mainViewController];
    }
}

-(void)changeBillPaymentPageBillFather
{
    if (self.iPaymentViewController != nil)
    {
        self.iPaymentViewController.billFather.bf_billName = nameText.text;
        self.iPaymentViewController.billFather.bf_billAmount =amount;
        self.iPaymentViewController.billFather.bf_billDueDate = self.starttime;
        self.iPaymentViewController.billFather.bf_billEndDate = self.endtime;
        self.iPaymentViewController.billFather.bf_billRecurringType = recurringType;
        self.iPaymentViewController.billFather.bf_billReminderDate = self.reminderDateString;
        self.iPaymentViewController.billFather.bf_billReminderTime = self.reminderTime;
        self.iPaymentViewController.billFather.bf_billNote = memoTextView.text;
        
        self.iPaymentViewController.billFather.bf_payee = self.payee;
        self.iPaymentViewController.billFather.bf_category = self.categories;
    }
    
}

-(void)NoCyclyBillChangeToCycleBill
{
    
}

//在设置trans state=0之前需要将tran 外键中关于 trans的外键删掉
-(void)beforeSetTransactionStateto0:(Transaction *)trans
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
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
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
}



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == payeeTableView) {
        return 1;
    }
    else
        return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == payeeTableView) {
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
    if (tableView==payeeTableView) {
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    if (section==0) {
        UILabel *sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 305, 35)];
        NSString *tmpString = [headerDateormatter stringFromDate:starttime];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == payeeTableView) {
        return [payeeArray count];
    }
    else{
        
        if ([self.typeOftodo isEqualToString:@"IPAD_ADD"]) {
            if (section==0) {
                if (selectedRowIndexPath.section==0 && selectedRowIndexPath.row==4)
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

- (void)configureSearchPayeeCell:(ipad_PayeeSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	Payee *searchPayee = (Payee *)[payeeArray objectAtIndex:indexPath.row];
    
    cell.payeeLabel.text = searchPayee.name;
    cell.categoryLabel.text = searchPayee.category.categoryName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == payeeTableView) {
        static NSString *CellIdentifier = @"Cell";
        ipad_PayeeSearchCell *cell = (ipad_PayeeSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ipad_PayeeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//
            
        }
        
        [self configureSearchPayeeCell:cell atIndexPath:indexPath];
        return cell;
    }
    else{
        
        if ([self.typeOftodo isEqualToString:@"IPAD_ADD"]) {
            if (indexPath.section==0 && indexPath.row==0) {
                return nameCell;
            }
            else if (indexPath.section==0 && indexPath.row==1)
                return amountCell;
            else if (indexPath.section==0 && indexPath.row==2)
                return payeeCell;
            else if (indexPath.section==0 && indexPath.row==3)
                return categoryCell;
            
            else if (indexPath.section==0 && indexPath.row==4)
                return startDateCell;
            else if (indexPath.section==0 && indexPath.row==5)
                return datePickerCell;
            
            else if (indexPath.section==1)
            {
                if (indexPath.row==0)
                {
                    return cycleCell;
                }
                else if (![self.recurringType isEqualToString:@"Never"] && indexPath.row==1)
                {
                    return endDateCell;
                }
                else
                    return remindCell;
            }
            else
                return notesCell;
        }
        else{
            if (indexPath.section==0 && indexPath.row==0) {
                return nameCell;
            }
            else if (indexPath.section==0 && indexPath.row==1)
                return amountCell;
            else if (indexPath.section==0 && indexPath.row==2)
                return payeeCell;
            else if (indexPath.section==0 && indexPath.row==3)
                return categoryCell;
            else if (indexPath.section==1 && indexPath.row==0)
                return remindCell;
            
            else
                return notesCell;

        }
        
    }
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==payeeTableView) {
        self.payee=  (Payee *)[payeeArray objectAtIndex:indexPath.row] ;
        
        [self setControlValueByPayee];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        payeeView.hidden = YES;
        
    }
    else{
        
        [mytableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.textLabel.text isEqualToString:@"StartDate"] && selectedRowIndexPath==nil)
        {
            selectedRowIndexPath = indexPath;
        }
        else
            selectedRowIndexPath = nil;
        
        
        if([cell.textLabel.text isEqualToString:@"Name"])
        {
            [nameText becomeFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            
            selectedCellIntenger = 0;
            
            
        }
        else if([cell.textLabel.text isEqualToString:@"Amount"])
        {
            [nameText resignFirstResponder];
            [amountText becomeFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            selectedCellIntenger = 0;
            
            
        }
        else if([cell.textLabel.text isEqualToString:@"Payee"])
        {
            [payeeText becomeFirstResponder];
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            
            
            selectedCellIntenger = 0;
            
        }
        else if([cell.textLabel.text isEqualToString:@"Category"])
        {
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            
            iPad_BillCategoryViewController *categorySelectedViewController = [[iPad_BillCategoryViewController alloc]initWithNibName:@"iPad_BillCategoryViewController" bundle:nil];
            categorySelectedViewController.iBillEditViewController = self;
            [self.navigationController pushViewController:categorySelectedViewController animated:YES];
            selectedCellIntenger = 0;
            
        }
        else if([cell.textLabel.text isEqualToString:@"StartDate"])
        {
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            selectedCellIntenger = 0;
            
            
        }
        else if([cell.textLabel.text isEqualToString:@"Cycle"])
        {
            
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;

            iPad_BillCycleViewController *recurringViewController = [[iPad_BillCycleViewController alloc]initWithNibName:@"iPad_BillCycleViewController" bundle:nil];
            recurringViewController.recurringType = recurringType;
            recurringViewController.iBillEditViewController = self;
            [self.navigationController pushViewController:recurringViewController animated:YES];
            selectedCellIntenger = 0;
        }
        else if ([cell.textLabel.text isEqualToString:@"End date"])
        {
            iPad_EndDateViewController *endDateViewController = [[iPad_EndDateViewController alloc]initWithNibName:@"iPad_EndDateViewController" bundle:nil];
            endDateViewController.endDate = self.endtime;
            endDateViewController.billEditViewController = self;
            [self.navigationController pushViewController:endDateViewController animated:YES];
        }

        
        else if([cell.textLabel.text isEqualToString:@"Remind"])
        {
            
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView resignFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            
            iPad_ReminderViewController *reminderViewController = [[iPad_ReminderViewController alloc]initWithNibName:@"iPad_ReminderViewController" bundle:nil];
            reminderViewController.reminderType = self.reminderDateString;
            reminderViewController.reminderTime = self.reminderTime;
            reminderViewController.iBillEditViewController = self;
            [self.navigationController pushViewController:reminderViewController animated:YES];
            selectedCellIntenger = 0;
        }
        else if([cell.textLabel.text isEqualToString:@"Notes"])
        {
            [nameText resignFirstResponder];
            [amountText resignFirstResponder];
            [memoTextView becomeFirstResponder];
            [payeeText resignFirstResponder];
            payeeView.hidden = YES;
            selectedCellIntenger = 1;
            
        }
        [self insertorDelegateDatePickerCell];

    }
    
    
}

-(void)deleteDatePickerCell
{
    selectedRowIndexPath = nil;
    [self insertorDelegateDatePickerCell];
}
-(void)insertorDelegateDatePickerCell
{
    if (selectedRowIndexPath.section==0 && selectedRowIndexPath.row==4)
    {
        if ([mytableView numberOfRowsInSection:0]==5)
        {
            [mytableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else
    {
        if ([mytableView numberOfRowsInSection:0]==6) {
            [mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"111");
//}

#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
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
            self.billFather.bf_billItem.ep_billItemName = nameText.text;
            self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:amount];
            self.billFather.bf_billItem.ep_billItemNote = memoTextView.text;
            
            self.billFather.bf_billItem.ep_billItemReminderDate = self.reminderDateString;
            self.billFather.bf_billItem.ep_billItemReminderTime = self.reminderTime;
            self.billFather.bf_billItem.billItemHasCategory = self.categories;
            self.billFather.bf_billItem.billItemHasPayee = self.payee;
            
            self.billFather.bf_billItem.dateTime = [NSDate date];
            //transaction还保持原来的
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            
//            if (appDelegate.dropbox.drop_account.linked){
//                [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
//            }

            if ([PFUser currentUser] && self.billFather.bf_billItem != nil)
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
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
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
        
        anotherBill.ep_billName = nameText.text;
        anotherBill.ep_billAmount = [NSNumber numberWithDouble:amount];
        
        anotherBill.ep_billDueDate = self.starttime;
        anotherBill.ep_recurringType = recurringType;
        anotherBill.ep_billEndDate = self.endtime;
        
        anotherBill.ep_reminderDate = self.reminderDateString;
        anotherBill.ep_reminderTime = self.reminderTime;
        anotherBill.ep_note = memoTextView.text;
        
//        anotherBill.billRuleHasBillItem = nil;
        anotherBill.billRuleHasCategory = self.categories;
        anotherBill.billRuleHasPayee = self.payee;
        anotherBill.billRuleHasTransaction = nil;
        
        anotherBill.state = @"1";
        anotherBill.dateTime = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
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
                if ([tmpBillO.ep_billItemDueDate compare:self.starttime] == NSOrderedDescending)
                {
                    if ([[tmpBillO.billItemHasTransaction allObjects]count]>0)
                    {
                        //删除后期的billItem
                        tmpBillO.state = @"0";
                        tmpBillO.dateTime = [NSDate date];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
//                        if (appDelegate.dropbox.drop_account.linked)
//                        {
//                            [appDelegate.dropbox updateEveryBillItemDataFromLocal:tmpBillO];
//                        }
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
        self.billFather.bf_billItem.ep_billItemName = nameText.text;
        self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:amount];
        self.billFather.bf_billItem.ep_billItemDueDateNew = self.starttime;
        self.billFather.bf_billItem.ep_billItemRecurringType = recurringType;
        self.billFather.bf_billItem.ep_billItemEndDate = self.endtime;
        self.billFather.bf_billItem.ep_billItemNote = memoTextView.text;
        
        self.billFather.bf_billItem.ep_billItemReminderDate = self.reminderDateString;
        self.billFather.bf_billItem.ep_billItemReminderTime = self.reminderTime;
        
        self.billFather.bf_billItem.billItemHasBillRule = self.billFather.bf_billRule;
        self.billFather.bf_billItem.billItemHasCategory = self.categories;
        self.billFather.bf_billItem.billItemHasPayee = self.payee;
        
        self.billFather.bf_billItem.dateTime = [NSDate date];
        //transaction还保持原来的
        
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
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
    
    
    
    if ([self.typeOftodo isEqualToString:@"IPAD_EDIT"] || [self.typeOftodo isEqualToString:@"IPAD_ADD"] )
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)saveOldBillItem:(EP_BillItem *)tmpnewBillItem{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    tmpnewBillItem.ep_billItemName = nameText.text;
    tmpnewBillItem.ep_billItemAmount = [NSNumber numberWithDouble:amount];
    //    tmpnewBillItem.ep_billItemDueDateNew = self.starttime;
    tmpnewBillItem.ep_billItemRecurringType = recurringType;
    tmpnewBillItem.ep_billItemEndDate = self.endtime;
    tmpnewBillItem.ep_billItemNote = memoTextView.text;
    
    tmpnewBillItem.ep_billItemReminderDate = self.reminderDateString;
    tmpnewBillItem.ep_billItemReminderTime = self.reminderTime;
    
    //    tmpnewBillItem.billItemHasBillRule = self.billFather.bf_billRule;
    tmpnewBillItem.billItemHasCategory = self.categories;
    tmpnewBillItem.billItemHasPayee = self.payee;
    
    tmpnewBillItem.dateTime = [NSDate date];
    //transaction还保持原来的
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
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
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
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
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
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
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            //sync
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryTransactionDataFromLocal:tmpBillNewPayment];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:tmpBillNewPayment];
            }
            
        }
        
    }
    
    //删除每一个BK_BillObject中多余的billO
    tmpBillObject.state = @"0";
    tmpBillObject.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
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
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
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
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    //sync
//    if (appDelegate.dropbox.drop_account.linked) {
//        [appDelegate.dropbox updateEveryTransactionDataFromLocal:newTrans];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:newTrans];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    mytableView.delegate = nil;
    mytableView.dataSource = nil;
}

@end

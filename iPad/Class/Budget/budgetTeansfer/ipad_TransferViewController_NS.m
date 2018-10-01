//
//  ipad_TransferViewController_NS.m
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import "ipad_TransferViewController_NS.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "RegexKitLite.h"
#import "BudgetCountClass.h"


#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import "ParseDBManager.h"
#import <Parse/Parse.h>
@interface ipad_TransferViewController_NS ()

@end

@implementation ipad_TransferViewController_NS
@synthesize fromLabel, toLabel;
@synthesize fromTotalLabel,toTotalLabel;

@synthesize btnToBudget;
@synthesize fromBudget,toBudget;
@synthesize selectBudgetArray;
@synthesize customerPick;
@synthesize typeOftodo;
@synthesize budgetTransfer;
@synthesize amountText;
@synthesize amountNum;
@synthesize startDate;
@synthesize endDate;
@synthesize toBudgetTextLabel;
@synthesize fromBudgetLabelText,amountLabelText;




//@synthesize pickerViewBG;

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
}


-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -6.f;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [cancelBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelBtn.titleLabel setMinimumScaleFactor:0];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ];
    
    
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [doneBtn.titleLabel setMinimumScaleFactor:0];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn] ];

    

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    titleLabel.text = NSLocalizedString(@"VC_BudgetTransfer", nil);
    self.navigationItem.titleView = 	titleLabel;
    
}

-(void)initMemoryDefine
{
    fromBudgetLabelText.text = NSLocalizedString(@"VC_FromBudget", nil);
    toBudgetTextLabel.text = NSLocalizedString(@"VC_ToBudget", nil);
    amountLabelText.text = NSLocalizedString(@"VC_Amount", nil);

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    [fromTotalLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    [toTotalLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    
	selectBudgetArray = [[NSMutableArray alloc] init];
    
    amountText.delegate = self;
    [btnToBudget addTarget:self action:@selector(btnToBudgetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    customerPick.hidden = YES;
    customerPick.backgroundColor = [UIColor whiteColor];
    
}

-(void)initContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget数组，除了frombudget
    [self getDateSource];
    [customerPick reloadAllComponents];
    
    
    if ([self.typeOftodo isEqualToString:@"ADD"]||[self.typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        self.toLabel.text = NSLocalizedString(@"VC_SelectTargetBudget", nil);
        toBudgetTextLabel.hidden = YES;
        toTotalLabel.hidden = YES;
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
    
    amountNum = [budgetTransfer.amount doubleValue];
    self.amountText.text = [appDelegate.epnc formatterString:amountNum];
    
}

-(void)calculateBudgetAmountwhenEdit:(BOOL)isFromBudget
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
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
        fromTotalLabel.text = [appDelegate.epnc formatterString:[budgetTemplate.amount doubleValue]+btTotalIncome-btTotalExpense];
    }
    else
    {
        toTotalLabel.text = [appDelegate.epnc formatterString:[budgetTemplate.amount doubleValue]+btTotalIncome-btTotalExpense];
    }
    
}

#pragma mark - get Data Souce
-(void)getDateSource
{
	[selectBudgetArray removeAllObjects];
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
    [allBudgetArray removeObject:fromBudget];
    
    
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
        
        [selectBudgetArray addObject:bcc];
        
	}
    
	
}

#pragma mark - custom button action
-(void)btnToBudgetAction:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate_iphone =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
	[amountText resignFirstResponder];
    
    toBudgetTextLabel.hidden = NO;
    toTotalLabel.hidden = NO;
    customerPick.hidden = NO;
    
    if(toBudget==nil && [selectBudgetArray count]>0)
    {
        BudgetCountClass *bcc = (BudgetCountClass *)[selectBudgetArray objectAtIndex:0];
        toBudget = bcc.bt;
        toLabel.text = toBudget.category.categoryName;
        self.toTotalLabel.text  =[appDelegate_iphone.epnc formatterString:[bcc.bt.amount doubleValue]+bcc.btTotalRellover+bcc.btTotalIncome-bcc.btTotalExpense];
        [self setToBudgetTextColor];
    }
}

#pragma mark - text field delegate
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
				if([string  isEqualToString: @""])
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
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    customerPick.hidden = YES;
}
- (IBAction) amountTextDid:(id)sender
{
 	self.amountText.text = [NSString stringWithFormat:@"%.2f",amountNum];
}
-(IBAction)EditChanged:(id)sender
{
	amountNum = [self.amountText.text doubleValue];
}
-(IBAction)TextDidEnd:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.amountText.text = [appDelegate.epnc formatterString:amountNum ];
}

#pragma mark - nav button action
- (void) cancel:(id)sender
{
	if([typeOftodo isEqualToString:@"IPAD_ADD"]||[typeOftodo isEqualToString:@"IPAD_EDIT"])
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    
    else
        [[self navigationController] popViewControllerAnimated:YES];
}

- (void) save:(id)sender
{
	if([fromLabel.text length]==0)
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
	if([toLabel.text length] == 0)
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
	if([self.amountText.text length] == 0||amountNum ==0)
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
    
 	if([typeOftodo isEqualToString:@"ADD"]||[typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        budgetTransfer= [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTransfer" inManagedObjectContext:appDelegate.managedObjectContext];
	}
	budgetTransfer.amount =[NSNumber numberWithDouble:amountNum ];
 	budgetTransfer.dateTime = [NSDate date];
    
    //获取frombudget 的budgetTemplate对应哪一个budgetItem
	BudgetItem *formbudgetTemplateCurrentItem = nil;
	BudgetItem *tobudgetTemplateCurrentItem = nil;
	NSMutableArray *tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[fromBudget.budgetItems allObjects]];
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
 	tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[toBudget.budgetItems allObjects]];
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

    
	if([typeOftodo isEqualToString:@"ADD"]||[typeOftodo isEqualToString:@"IPAD_ADD"] )
	{
        if(formbudgetTemplateCurrentItem!=nil)
		{
			[formbudgetTemplateCurrentItem addFromTransferObject:budgetTransfer];
		}
		if(tobudgetTemplateCurrentItem!=nil)
		{
			[tobudgetTemplateCurrentItem addToTransferObject:budgetTransfer];
		}
		budgetTransfer.fromBudget  =formbudgetTemplateCurrentItem;
		budgetTransfer.toBudget  = tobudgetTemplateCurrentItem;
        
        budgetTransfer.uuid = [EPNormalClass GetUUID];
        
 	}
	else {
		
		[budgetTransfer.fromBudget removeFromTransferObject:budgetTransfer];
		[budgetTransfer.toBudget removeToTransferObject:budgetTransfer];
		if(formbudgetTemplateCurrentItem!=nil)
		{
            [appDelegate.epdc ReCountBudgetRollover:budgetTransfer.fromBudget.budgetTemplate];
            
            
			[formbudgetTemplateCurrentItem addFromTransferObject:budgetTransfer];
		}
		if(tobudgetTemplateCurrentItem!=nil)
		{
            [appDelegate.epdc ReCountBudgetRollover:budgetTransfer.toBudget.budgetTemplate];
            
            
			[tobudgetTemplateCurrentItem addToTransferObject:budgetTransfer];
		}
		
		budgetTransfer.fromBudget  =formbudgetTemplateCurrentItem;
		budgetTransfer.toBudget  = tobudgetTemplateCurrentItem;
        
	}
    budgetTransfer.dateTime_sync = [NSDate date];
    budgetTransfer.state = @"1";
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
    
    [appDelegate.epdc ReCountBudgetRollover:budgetTransfer.fromBudget.budgetTemplate];
    [appDelegate.epdc ReCountBudgetRollover:budgetTransfer.toBudget.budgetTemplate];
    
    //sync
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetTransferDataFromLocal:budgetTransfer];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetTransfer:budgetTransfer];
    }
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    
    if([typeOftodo isEqualToString:@"IPAD_ADD"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_TSF"];
    }
    
	if([typeOftodo isEqualToString:@"IPAD_ADD"]||[typeOftodo isEqualToString:@"IPAD_EDIT"])
    {
        if (appDelegate_iPad.mainViewController.currentViewSelect==2) {
            [appDelegate_iPad.mainViewController.iBudgetViewController reFlashTableViewData];
        }
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

    }
    
	else
		[[self navigationController] popViewControllerAnimated:YES];
    
}

#pragma mark UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [selectBudgetArray count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BudgetCountClass *bcc = (BudgetCountClass *)[selectBudgetArray objectAtIndex:row];
    return bcc.bt.category.categoryName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([selectBudgetArray count] > 0)
	{
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        BudgetCountClass *bcc = (BudgetCountClass *)[selectBudgetArray objectAtIndex:row];
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
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (self.toBudget==nil) {
        [self.toLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
        
    }
    else
        [self.toLabel setTextColor:[UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1]];
}

#pragma mark view release and dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload {
//}


@end

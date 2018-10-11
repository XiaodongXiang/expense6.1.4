//
//  ipad_BillPaymentViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-18.
//
//

#import "ipad_BillPaymentViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "BillFather.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "Payee.h"
#import "RegexKitLite.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"


@interface ipad_BillPaymentViewController ()

@end

@implementation ipad_BillPaymentViewController
@synthesize paymtnTableVeiw,amountTableViewCell,accountTableViewCell,
dateTableViewCell,amountText,accountLabel,dateLabel,billFather,transaction,accountArray,accountPickerView,datePicker,date,typeoftodo,dateFormatter;
@synthesize amount,account,categoyrArray;
@synthesize amountLabelText,accountLabelText,paymentDateLabelText;

#pragma mark Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initPoint];
    [self initNavStyle];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showContext];
    
    [self getAccountDataSource];
    [self getCategoryDataSource];
    
}

#pragma mark ViewDidLoad Method
-(void)initPoint{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [amountText setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:16]];
    amountLabelText.text = NSLocalizedString(@"VC_Amount", nil);
    accountLabelText.text = NSLocalizedString(@"VC_Account", nil);
    paymentDateLabelText.text = NSLocalizedString(@"VC_PaymentDate", nil);
    
    dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    accountArray = [[NSMutableArray alloc]init];
    categoyrArray = [[NSMutableArray alloc]init];
    accountPickerView.delegate = self;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    datePicker.hidden = YES;
    accountPickerView.hidden = YES;
    [amountText addTarget:self action:@selector(textFieldBegain:) forControlEvents:UIControlEventEditingDidBegin];
    [amountText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [amountText addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    datePicker.backgroundColor = [UIColor whiteColor];
    accountPickerView.backgroundColor = [UIColor whiteColor];
}

-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	back.frame = CGRectMake(0, 0, 30, 30);
	[back setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];	titleLabel.text =  billFather.bf_billName;
	self.navigationItem.titleView = titleLabel;
    
	
 	UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
	[payBtn setTitle:NSLocalizedString(@"VC_Pay", nil) forState:UIControlStateNormal];
    [payBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    [payBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [payBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [payBtn addTarget:self action:@selector(payBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *payBar =[[UIBarButtonItem alloc] initWithCustomView:payBtn];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,payBar];

    
}


-(void)showContext{
    AppDelegate_iPad *appDeleagte_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    if ([self.typeoftodo isEqualToString:@"ADD"]) {
        //显示金额
        
        double paymentAmount = 0.00;
        NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
        if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else{
            [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
        }
        
        for (int i=0; i<[paymentArray count]; i++) {
            Transaction *payment = [paymentArray objectAtIndex:i];
            if ([payment.state isEqualToString:@"1"]) {
                paymentAmount += [payment.amount doubleValue];
                
            }
        }
        
        double unpaidAmount = 0;
        if (billFather.bf_billAmount > paymentAmount) {
            unpaidAmount = billFather.bf_billAmount - paymentAmount;
        }
        
        
        amount = unpaidAmount;
        self.account = nil;
        self.date = [NSDate date];
        
        amountText.text = [appDeleagte_iPhone.epnc formatterString:unpaidAmount];
        accountLabel.text = @"";
        dateLabel.text = [dateFormatter stringFromDate:self.date];
    }
    
    else{
        amount = [self.transaction.amount doubleValue];
        self.account = self.transaction.expenseAccount;
        self.date = self.transaction.dateTime;
        
        amountText.text = [appDeleagte_iPhone.epnc formatterString:amount];
        accountLabel.text = self.account.accName;
        dateLabel.text = [dateFormatter stringFromDate:self.date];
    }
}

-(void)getCategoryDataSource{
    
    AppDelegate_iPad  *appDelegate = (AppDelegate_iPad  *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;
    
    NSFetchRequest *fetchRequest;
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:  nil];
    fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByExpenseType" substitutionVariables:subs];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    [categoyrArray setArray:objects];
	
}

-(void)getAccountDataSource{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetcheRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetcheRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetcheRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,nil];
    [fetcheRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *objects = [[NSMutableArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetcheRequest error:&error]];
    [accountArray setArray:objects];
    [accountPickerView reloadAllComponents];
}
#pragma mark Btn Action
-(void)back:(id)sender{
    if ([self.typeoftodo isEqualToString:@"ADD"] || [self.typeoftodo isEqualToString:@"EDIT"]) {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

//amount text响应
- (void)textFieldBegain:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.amountText.text = [appDelegate.epnc formatterString:amount];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
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
    return YES;
}

//amount text value changed
-(void)textFieldChanged:(id)sender
{
    amount = [self.amountText.text doubleValue];
}


//amount text end
-(void)textFieldEnd:(UITextField *)sender
{
    if (sender == amountText) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.amountText.text = [appDelegate.epnc formatterString:amount];
    }
    
}


-(void)payBtnPressed:(id)sender{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    //将对应的bill2中的数据改变
    EP_BillItem *oneBillObject =  self.billFather.bf_billItem;
    
    if (amount <=0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Amount is needed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
        appDelegate.appAlertView = alertView;
        return;
    }
    if (self.account == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Account is needed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
        appDelegate.appAlertView = alertView;
        return;
    }
    //非循环的，只存在bill中
    if ([self.billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        //保存到payment中
        if ([self.typeoftodo isEqualToString:@"ADD"]) {
            self.transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
        }
        
        
        //payee
        /* --------HMJ if this is a new payee then inset it-------------*/
        if([self.billFather.bf_billName length]>0)
        {
            NSError *errors;
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
            [fetchRequest setPredicate:predicate];
            // Edit the sort key as appropriate.
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray* objects =[[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors]];
            
       
            BOOL hasFound = FALSE;
            
            for (Payee *tmpPayee in objects)
            {
                if([tmpPayee.name isEqualToString:self.billFather.bf_billName] && tmpPayee.category == self.billFather.bf_category)
                {
                    hasFound = TRUE;
                    self.transaction.payee = tmpPayee;
                    break;
                }
            }
            if(!hasFound)
            {
                AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                self.transaction.payee = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
                self.transaction.payee.name = self.billFather.bf_billName;
                
                self.transaction.payee.memo = self.billFather.bf_billNote;
                
                self.transaction.payee.category =self.billFather.bf_category;
                self.transaction.payee.tranType = @"expense";
                
                self.transaction.payee.dateTime = [NSDate date];
                self.transaction.payee.state = @"1";
                self.transaction.payee.uuid =[EPNormalClass GetUUID];
                
                if (![appDelegate.managedObjectContext save:&errors]) {
                    NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                    
                }
//                AppDelegate_iPad *appDelegaet_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//                if (appDelegaet_iPhone.dropbox.drop_account.linked)
//                {
//                    [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.transaction.payee];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updatePayeeFromLocal:self.transaction.payee];
                }
            }
            
        }
        
        
        
        //category
        self.transaction.category = self.billFather.bf_category;
        //amount
        self.transaction.amount =[NSNumber numberWithDouble:amount];
        //date
        self.transaction.dateTime = datePicker.date;
        //amount
        self.transaction.expenseAccount =self.account;
        self.transaction.incomeAccount = nil;
        //recurring
        self.transaction.recurringType = @"Never";
        //picure
        self.transaction.photoName = nil;
        //note
        self.transaction.notes = @"Payment of Bill";
        //cleared
        self.transaction.isClear = [NSNumber numberWithBool:YES];
        //payee
        //        NSString *payeeString = [NSString stringWithFormat:@"Payement of %@",self.billFather.bf_billName];
        //recurring type
        
        self.transaction.transactionHasBillRule = self.billFather.bf_billRule;
        self.transaction.transactionHasBillItem = self.billFather.bf_billItem;
        self.transaction.expenseAccount = self.account;
        
        self.transaction.dateTime_sync = [NSDate date];
        if ([self.typeoftodo isEqualToString:@"ADD"]) {
            self.transaction.uuid = [EPNormalClass GetUUID];
        }
        self.transaction.state = @"1";
        
        NSError *error = nil;
        if(![appDelegate.managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        }
        
        //sync
//        if (appDelegate.dropbox.drop_account.linked) {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:self.transaction];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:self.transaction];
        }
        
        //        [appDelegate.epdc saveTransaction:self.transaction];
        
    }
    //是循环的，修改billObject中的数据
    else{
        if (oneBillObject == nil) {
            oneBillObject = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];//设置bill2中的数据
            {
                oneBillObject.ep_billItemName = self.billFather.bf_billName;
                oneBillObject.ep_billItemAmount = [NSNumber numberWithDouble:self.billFather.bf_billAmount];
                oneBillObject.ep_billItemDueDate = self.billFather.bf_billDueDate;
                oneBillObject.ep_billItemEndDate = self.billFather.bf_billEndDate;
                if (oneBillObject.ep_billItemDueDateNew == nil) {
                    oneBillObject.ep_billItemDueDateNew = oneBillObject.ep_billItemDueDate;
                }
                oneBillObject.ep_billItemRecurringType = self.billFather.bf_billRecurringType;
                oneBillObject.ep_billItemReminderDate = self.billFather.bf_billReminderDate;
                oneBillObject.ep_billItemReminderTime = self.billFather.bf_billReminderTime;
                oneBillObject.ep_billItemNote = self.billFather.bf_billNote;
                
                oneBillObject.ep_billItemString1 = [NSString stringWithFormat:@"%@ %@",self.billFather.bf_billRule.uuid,[appDelegate.epnc getUUIDFromData:self.billFather.bf_billDueDate] ];
                
                oneBillObject.billItemHasBillRule = self.billFather.bf_billRule;
                oneBillObject.billItemHasCategory = self.billFather.bf_category;
                oneBillObject.billItemHasPayee =self.billFather.bf_payee;
                
                oneBillObject.dateTime = [NSDate date];
                oneBillObject.state = @"1";
                oneBillObject.uuid = [EPNormalClass GetUUID];
                //transaction链接在后面
            }
            self.billFather.bf_billItem = oneBillObject;
            NSError *error = nil;
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            //sync
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillItemDataFromLocal:oneBillObject];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:oneBillObject];
            }
        }
        
        //保存到payment中
        if ([self.typeoftodo isEqualToString:@"ADD"]) {
            self.transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
        }
        //payee
        //        self.transaction.payee  = nil;
        
        //payee
        /* --------HMJ if this is a new payee then inset it-------------*/
        if([self.billFather.bf_billName length]>0)
        {
            NSError *errors;
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
            [fetchRequest setPredicate:predicate];
            // Edit the sort key as appropriate.
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray* objects =[[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors]];
            
 
            BOOL hasFound = FALSE;
            
            for (Payee *tmpPayee in objects)
            {
                if([tmpPayee.name isEqualToString:self.billFather.bf_billName] && tmpPayee.category == self.billFather.bf_category)
                {
                    hasFound = TRUE;
                    self.transaction.payee = tmpPayee;
                    break;
                }
            }
            if(!hasFound)
            {
                AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                self.transaction.payee = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
                self.transaction.payee.name = self.billFather.bf_billName;
                
                self.transaction.payee.memo = self.billFather.bf_billNote;
                
                self.transaction.payee.category =self.billFather.bf_category;
                self.transaction.payee.tranType = @"expense";
                
                self.transaction.payee.dateTime = [NSDate date];
                self.transaction.payee.state = @"1";
                self.transaction.payee.uuid =[EPNormalClass GetUUID];
                
                if (![appDelegate.managedObjectContext save:&errors]) {
                    NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                    
                }
//                AppDelegate_iPad *appDelegaet_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//                if (appDelegaet_iPhone.dropbox.drop_account.linked) {
//                    [appDelegaet_iPhone.dropbox updateEveryPayeeDataFromLocal:self.transaction.payee];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updatePayeeFromLocal:self.transaction.payee];
                }
            }
            
        }
        
        
        //category
        self.transaction.category = billFather.bf_category;
        //amount
        self.transaction.amount =[NSNumber numberWithDouble:amount];
        //date
        self.transaction.dateTime = datePicker.date;
        //amount
        self.transaction.expenseAccount =self.account;
        self.transaction.incomeAccount = nil;
        //recurring
        self.transaction.recurringType = @"Never";
        //picure
        self.transaction.photoName = nil;
        //note
        self.transaction.notes = nil;
        //cleared
        self.transaction.isClear = [NSNumber numberWithBool:YES];
        //recurring type
        
        self.transaction.transactionHasBillRule = self.billFather.bf_billRule;
        self.transaction.transactionHasBillItem = self.billFather.bf_billItem;
        self.transaction.expenseAccount = self.account;
        
        self.transaction.dateTime_sync = [NSDate date];
        self.transaction.state = @"1";
        if ([self.typeoftodo isEqualToString:@"ADD"]) {
            self.transaction.uuid =  [EPNormalClass GetUUID];
        }
        
        NSError *error = nil;
        if(![appDelegate.managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        }
        
//        if (appDelegate.dropbox.drop_account.linked) {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:self.transaction];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:self.transaction];
        }
    }
    
    if ([self.typeoftodo isEqualToString:@"ADD"]) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"11_BIL_PAY"];
    }
    
    if ([self.typeoftodo isEqualToString:@"ADD"] || [self.typeoftodo isEqualToString:@"EDIT"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (!appDelegate.isPurchased) {
        ADEngineController* interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"ADTEST - Interstitial"];
        [interstitial showInterstitialAdWithTarget:self.navigationController];
    }
        
}

-(void)datePickerValueChanged{
    self.date = datePicker.date;
    dateLabel.text = [dateFormatter stringFromDate:self.date];
}




#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIImageView *headerView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
//    headerView.backgroundColor = [UIColor whiteColor]
//    return headerView;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0)
        return amountTableViewCell;
    else if (indexPath.section==0 && indexPath.row==1)
        return accountTableViewCell;
    else
        return dateTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        [amountText becomeFirstResponder];
        accountPickerView.hidden = YES;
        datePicker.hidden = YES;
    }
    else if (indexPath.section==0 && indexPath.row==1){
        [amountText resignFirstResponder];
        accountPickerView.hidden = NO;
        datePicker.hidden = YES;
        
        if (self.account == nil && [accountArray count]>0) {
            self.account = [accountArray objectAtIndex:0];
            accountLabel.text = self.account.accName;
        }
        
        [paymtnTableVeiw reloadData];
    }
    else{
        [amountText resignFirstResponder];
        accountPickerView.hidden = YES;
        datePicker.hidden = NO;
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([accountArray count] == 0) return;
	self.account = (Accounts *)[accountArray objectAtIndex:row];
	accountLabel.text = self.account.accName;
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [accountArray count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Accounts *oneAccount = [accountArray objectAtIndex:row];
    return oneAccount.accName;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	
	return 250;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Fetched results controller


@end

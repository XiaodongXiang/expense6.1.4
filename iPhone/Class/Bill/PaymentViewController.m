//
//  PaymentViewController.m
//  Expense 5
//
//  Created by BHI_James on 5/14/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "PaymentViewController.h"
#import "Transaction.h"
 #import "Accounts.h"
#import "PaymentCell.h"
#import "PokcetExpenseAppDelegate.h"
#import "BillPayViewController.h"
#import "TransactionEditViewController.h"
//#import "TransactionRule.h"
#import "AppDelegate_iPhone.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"

#import "BillEditViewController.h"
#import "BillEditViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation PaymentViewController
@synthesize mytableView;
@synthesize paymentList;
@synthesize outputFormatter;
@synthesize billFather;
@synthesize headLabel,dueLabel,paidLabel,leftLabel;
@synthesize needReflshData;
@synthesize addPaymentBtn,billEditViewController;
@synthesize categoryimage,nameLabel;
@synthesize dueLabelText,totalLabelText,paidLabelText,padiContainView,paid2LabelText;

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

//在xcode5上运行在ios8上面不跑
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)refleshUI{
    [self getDataSource];
}
#pragma mark View Will Appear
-(void)initPoint
{
    _lineH.constant = EXPENSE_SCALE;
    _lineT.constant = 233+1-EXPENSE_SCALE;
    dueLabelText.text = NSLocalizedString(@"VC_Due", nil);
    totalLabelText.text = NSLocalizedString(@"VC_Total", nil);
    paidLabelText.text = NSLocalizedString(@"VC_Paid", nil);
    [addPaymentBtn setTitle:NSLocalizedString(@"VC_PayBill", nil) forState:UIControlStateNormal];
    paid2LabelText.text = NSLocalizedString(@"VC_Paid", nil);
    
    
    _billDetailBg.image = [UIImage imageNamed:[NSString customImageName:@"billdetail_bg.png"]];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [dueLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
    [paidLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
    outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];

    paymentList = [[NSMutableArray alloc]init];
    
    [addPaymentBtn addTarget:self action:@selector(addPaymentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initNavStyle
{
    
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -6.f;

    
    headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[headLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[headLabel setTextColor:[UIColor whiteColor]];
    [headLabel setTextAlignment:NSTextAlignmentCenter];
	[headLabel setBackgroundColor:[UIColor clearColor]];
	headLabel.text =  billFather.bf_billName;
	self.navigationItem.titleView = headLabel;
    
	
 	UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[editBtn setImage: [UIImage imageNamed:@"navigation_edit.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *editBar =[[UIBarButtonItem alloc] initWithCustomView:editBtn];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,editBar];


}

-(void)getDataSource{
    categoryimage.image = [UIImage imageNamed:self.billFather.bf_category.iconName];
    nameLabel.text = self.billFather.bf_billName;
    [paymentList removeAllObjects];
    //显示金额
    AppDelegate_iPhone *appDeleagte_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    double paymentAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else{
        [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
    NSArray *sortedArray = [paymentArray sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sort, nil]];
    [paymentArray setArray:sortedArray];
    if ([paymentArray count]>0) {
        for (int i=0; i<[paymentArray count]; i++) {
            Transaction *oneTrans = [paymentArray objectAtIndex:i];
            if ([oneTrans.state isEqualToString:@"1"]) {
                [paymentList addObject:oneTrans];
            }
            
        }
    }
    for (int i=0; i<[paymentList count]; i++) {
        Transaction *payment = [paymentArray objectAtIndex:i];
        paymentAmount += [payment.amount doubleValue];
    }
    
    //设置金额
    headLabel.text = billFather.bf_billName;
    dueLabel.text =[appDeleagte_iPhone.epnc formatterString:billFather.bf_billAmount];
    paidLabel.text = [appDeleagte_iPhone.epnc formatterString:paymentAmount];
    
    double unpaidAmount = 0;
    if (billFather.bf_billAmount > paymentAmount) {
        unpaidAmount = billFather.bf_billAmount - paymentAmount;
    }
    
    if ([appDeleagte_iPhone.epnc dateCompare:self.billFather.bf_billDueDate withDate:[NSDate date]]<0)
    {
        leftLabel.textColor = [UIColor colorWithRed:255/255.f green:93/255.f blue:106/255.f alpha:1];
    }
    else
        leftLabel.textColor = [UIColor colorWithRed:94/255.f green:94/255.f blue:94/255.f alpha:1];
    leftLabel.text = [appDeleagte_iPhone.epnc formatterString:unpaidAmount];

    if (paymentAmount==0) {
        [addPaymentBtn setTitle:NSLocalizedString(@"VC_PayBill", nil) forState:UIControlStateNormal];
        addPaymentBtn.hidden = NO;

    }
    else if (paymentAmount>0 && paymentAmount<billFather.bf_billAmount)
    {
        [addPaymentBtn setTitle:NSLocalizedString(@"VC_AddPayment", nil) forState:UIControlStateNormal];
        addPaymentBtn.hidden = NO;

    }
    else
    {
        addPaymentBtn.hidden = YES;
    }
    
    [mytableView reloadData];
}

-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(SCREEN_WIDTH, 416);
}

#pragma mark Btn Action
- (void) back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editBtnPressed:(id)sender{
    self.billEditViewController = [[BillEditViewController alloc]initWithNibName:@"BillEditViewController" bundle:nil];
    billEditViewController.typeOftodo = @"EDIT";
    billEditViewController.billFather = self.billFather;
    billEditViewController.paymentViewController = self;
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:billEditViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

- (void)addPaymentBtnPressed:(id)sender
{
	 
    BillPayViewController *payController = [[BillPayViewController alloc] initWithNibName:@"BillPayViewController" bundle:nil];
	payController.billFather = self.billFather;
    payController.typeoftodo = @"ADD";
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:payController];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

#pragma mark 
#pragma mark tableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [paymentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,12, 300, 29)];
	[stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
	[stringLabel setTextColor:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1.f]];
	[stringLabel setBackgroundColor:[UIColor clearColor]];
	stringLabel.textAlignment = NSTextAlignmentLeft;
    stringLabel.text =  NSLocalizedString(@"VC_PaymentHistory", nil);
    
    UIView* headerView = [[UIView alloc] init] ;
    UIImageView* imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString customImageName:@"payHistory"]]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
 	[headerView addSubview:imageView];
    [headerView addSubview:stringLabel];
    

	return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	static NSString *CellIdentifier = @"Cell";
	PaymentCell *cell = (PaymentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	Transaction *transaction = (Transaction *)[paymentList objectAtIndex:indexPath.row];
	if([transaction.category.categoryType isEqualToString:@"EXPENSE"])
	{
		cell.accountLabel.text = transaction.expenseAccount.accName;
        cell.categoryImage.image = [UIImage imageNamed:transaction.expenseAccount.accountType.iconName];
 	}
	else 	if([transaction.category.categoryType isEqualToString:@"INCOME"])
	{
		cell.accountLabel.text = transaction.incomeAccount.accName;
        cell.categoryImage.image = [UIImage imageNamed:transaction.incomeAccount.accountType.iconName];

	}


    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	cell.amountLabel.text = [appDelegate.epnc formatterString:[transaction.amount doubleValue]];
	cell.dateLabel.text = [outputFormatter stringFromDate:transaction.dateTime];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Transaction *tmpTransaction = (Transaction *)[paymentList objectAtIndex:indexPath.row];

    BillPayViewController *billPaymentViewController = [[BillPayViewController alloc]initWithNibName:@"BillPayViewController" bundle:nil];
    billPaymentViewController.billFather = self.billFather;
    billPaymentViewController.transaction = tmpTransaction;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:billPaymentViewController];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Transaction *trans = [paymentList objectAtIndex:indexPath.row];
    AppDelegate_iPhone *appDelegate_iPhoen = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;

    trans.dateTime_sync = [NSDate date];
    trans.state = @"0";
    if (![appDelegate_iPhoen.managedObjectContext save:&error]) {
    }
//    if (appDelegate_iPhoen.dropbox.drop_account.linked) {
//        [appDelegate_iPhoen.dropbox updateEveryTransactionDataFromLocal:trans];
//        [appDelegate_iPhoen.managedObjectContext deleteObject:trans];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:trans];
        [appDelegate_iPhoen.managedObjectContext deleteObject:trans];
    }
    [self  getDataSource];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 52;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end

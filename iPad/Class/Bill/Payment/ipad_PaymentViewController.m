//
//  ipad_PaymentViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-18.
//
//

#import "ipad_PaymentViewController.h"
#import "ipad_BillEditViewController.h"
#include "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_PaymentCell.h"
#import "ipad_BillPaymentViewController.h"
#import "Transaction.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface ipad_PaymentViewController ()<ipad_BillPaymentViewDelegate>
@property(nonatomic, strong)ADEngineController* interstitial;

@end

@implementation ipad_PaymentViewController
@synthesize mytableView;
@synthesize paymentList;
@synthesize outputFormatter;
@synthesize billFather;
@synthesize headLabel,dueLabel,paidLabel,leftLabel;
@synthesize needReflshData;
@synthesize addPaymentBtn,iBillEditViewController;
@synthesize categoryimage,nameLabel;
@synthesize dueLabelText,totalLabelText,paidLabelText,padiContainView,paid2LabelText;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2205 - iPad - Interstitial - BillAddPaid"];
        }
    }
    return self;
}
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

//ios 8上面不调用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iBillEditViewController = nil;
    [self getDataSource];
}

-(void)refleshUI{
    if (self.iBillEditViewController != nil)
    {
        [self.iBillEditViewController refleshUI];
    }
    else
    {
        [self getDataSource];
    }
    
}
#pragma mark View Will Appear
-(void)initPoint{
    dueLabelText.text = NSLocalizedString(@"VC_Due", nil);
    totalLabelText.text = NSLocalizedString(@"VC_Total", nil);
    paidLabelText.text = NSLocalizedString(@"VC_Paid", nil);
    [addPaymentBtn setTitle:NSLocalizedString(@"VC_PayBill", nil) forState:UIControlStateNormal];
    paid2LabelText.text = NSLocalizedString(@"VC_Paid", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [leftLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:27]];
    [dueLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
    [paidLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
    
    outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
    paymentList = [[NSMutableArray alloc]init];
    
    [addPaymentBtn addTarget:self action:@selector(addPaymentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -2.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -6.f;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	back.frame = CGRectMake(0, 0, 60, 30);
	[back setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    back.titleLabel.adjustsFontSizeToFitWidth = YES;
    [back.titleLabel setMinimumScaleFactor:0];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [back setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	[headLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[headLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [headLabel setTextAlignment:NSTextAlignmentCenter];
	[headLabel setBackgroundColor:[UIColor clearColor]];
	headLabel.text =  billFather.bf_billName;
	self.navigationItem.titleView = headLabel;
    
	
 	UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[editBtn setImage: [UIImage imageNamed:@"icon_edit2_30_30_1.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *editBar =[[UIBarButtonItem alloc] initWithCustomView:editBtn];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,editBar];

    
}

-(void)getDataSource{
    categoryimage.image = [UIImage imageNamed:self.billFather.bf_category.iconName];
    nameLabel.text = self.billFather.bf_billName;
    [paymentList removeAllObjects];
    //显示金额
    PokcetExpenseAppDelegate *appDeleagte_iPhone =(PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    double paymentAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else{
        [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
    }
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
        leftLabel.textColor = [UIColor colorWithRed:243.f/255.f green:61.f/255.f blue:36.f/255.f alpha:1];
    }
    else
        leftLabel.textColor = [UIColor colorWithRed:54.f/255.f green:55.f/255.f blue:60.f/255.f alpha:1];
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
//        [addPaymentBtn setImage:[UIImage imageNamed:@"btn_paid.png"] forState:UIControlStateNormal];
        addPaymentBtn.hidden = YES;
    }
    
    [mytableView reloadData];
}

-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}

#pragma mark Btn Action
- (void) back:(id)sender
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)editBtnPressed:(id)sender{
    self.iBillEditViewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    self.iBillEditViewController.typeOftodo = @"EDIT";
    self.iBillEditViewController.billFather = self.billFather;
    self.iBillEditViewController.iPaymentViewController = self;
    [self.navigationController pushViewController:self.iBillEditViewController animated:YES];
    
    
}

- (void)addPaymentBtnPressed:(id)sender
{
    
    ipad_BillPaymentViewController *payController = [[ipad_BillPaymentViewController alloc] initWithNibName:@"ipad_BillPaymentViewController" bundle:nil];
	payController.billFather = self.billFather;
    payController.typeoftodo = @"ADD";
    [self.navigationController pushViewController:payController animated:YES];
    
    payController.xxdDelegate = self;
}

-(void)billPaySuccess{
    [self.interstitial showInterstitialAdWithTarget:self];
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
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 480, 29)];
	[stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
	[stringLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:178.f/255.f alpha:1.f]];
	[stringLabel setBackgroundColor:[UIColor clearColor]];
	stringLabel.textAlignment = NSTextAlignmentLeft;
    stringLabel.text =  NSLocalizedString(@"VC_PaymentHistory", nil);
    
    UIView* headerView = [[UIView alloc] init] ;
    UIImageView* imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_category_bar_bill_pay.png"]];
    imageView.frame = CGRectMake(0, 0, 480, 30);
    
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
	ipad_PaymentCell *cell = (ipad_PaymentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[ipad_PaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
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
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    
	cell.amountLabel.text = [appDelegate.epnc formatterString:[transaction.amount doubleValue]];
	cell.dateLabel.text = [outputFormatter stringFromDate:transaction.dateTime];
    if (indexPath.row == [paymentList count]-1)
    {
        cell.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
        
    }
    else
    {
        cell.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
        
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Transaction *tmpTransaction = (Transaction *)[paymentList objectAtIndex:indexPath.row];
    
    ipad_BillPaymentViewController *billPaymentViewController = [[ipad_BillPaymentViewController alloc]initWithNibName:@"ipad_BillPaymentViewController" bundle:nil];
    billPaymentViewController.billFather = self.billFather;
    billPaymentViewController.transaction = tmpTransaction;
    billPaymentViewController.typeoftodo = @"EDIT";
    [self.navigationController pushViewController:billPaymentViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Transaction *trans = [paymentList objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate*appDelegate_iPhoen = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    trans.dateTime_sync = [NSDate date];
    trans.state = @"0";
    if (![appDelegate_iPhoen.managedObjectContext save:&error]) {
        NSLog(@"coca data save fault,error:%@",error);
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
	return 60.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end

//
//  ReportViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-4-16.
//
//

#import "ReportViewController.h"
#import "EmailViewController.h"
#import "RepTransactionFilterViewController.h"
#import "RepCashflowFilterViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ADSDeatailViewController.h"
#import "ADSDeatailViewController.h"
#import "AppDelegate_iPhone.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize myTableView,transactionCSVcell,transactionPDFcell,flowcell,billcell;
@synthesize transactioncsvlabelText,transactionpdflabelText,flowlabelText;
@synthesize proImage1,proImage2;
@synthesize adsDetailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavStyle];
    [self initPoint];
    [myTableView reloadData];
    
    self.myTableView.separatorColor = RGBColor(226, 226, 226);

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_Export Report", nil);
    
    
    transactioncsvlabelText.text = NSLocalizedString(@"VC_Transaction(CSV)", nil);
    transactionpdflabelText.text = NSLocalizedString(@"VC_Transaction(PDF)", nil);
    flowlabelText.text = NSLocalizedString(@"VC_Flow(PDF)", nil);
    
}

-(void)initPoint
{
    self.transCSVhigh.constant = EXPENSE_SCALE;
    self.transPDFhigh.constant = EXPENSE_SCALE;
    self.cashPDFhigh.constant = EXPENSE_SCALE;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.isPurchased)
    {
        proImage1.hidden = NO;
        proImage2.hidden = NO;

    }
    //如果内购成功，三种功能都要被使用
    else
    {
        proImage1.hidden = YES;
        proImage2.hidden = YES;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myTableView reloadData];
}
#pragma mark Btn Action
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)]autorelease];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return transactionCSVcell;
    }
    else if (indexPath.row==1)
        return transactionPDFcell;
    else if (indexPath.row==2)
        return flowcell;
    else
        return billcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (indexPath.row==0)
    {
        EmailViewController *emailViewController = [[EmailViewController alloc]initWithNibName:@"EmailViewController" bundle:nil];
        [self.navigationController pushViewController:emailViewController animated:YES];
    }

    else if (indexPath.row==1)
    {
        if(proImage1.hidden)
        {
            RepTransactionFilterViewController* repTransactionFilterViewController = [[RepTransactionFilterViewController alloc] initWithNibName:@"RepTransactionFilterViewController" bundle:nil];
            [self.navigationController pushViewController:repTransactionFilterViewController animated:YES];
        }
        else
        {
            adsDetailViewController = [[ADSDeatailViewController alloc]initWithNibName:@"ADSDeatailViewController" bundle:nil];
            adsDetailViewController.isComeFromSetting = YES;
            adsDetailViewController.pageNum = 1;
            [appDelegate_iPhone.window addSubview:adsDetailViewController.view];
            return;
        }
        
        
    }
        
    else if (indexPath.row==2)
    {
        if(proImage2.hidden)
        {
            RepCashflowFilterViewController* repCashflowFilterViewController = [[RepCashflowFilterViewController alloc] initWithNibName:@"RepCashflowFilterViewController" bundle:nil];
            [self.navigationController pushViewController:repCashflowFilterViewController animated:YES];
        }
        else
        {
            adsDetailViewController = [[ADSDeatailViewController alloc]initWithNibName:@"ADSDeatailViewController" bundle:nil];
            adsDetailViewController.isComeFromSetting = YES;
            adsDetailViewController.pageNum = 1;
            [appDelegate_iPhone.window addSubview:adsDetailViewController.view];
            return;
        }
        
        
        

    }

     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ipad_ReportViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import "ipad_ReportViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_EmailViewController.h"
#import "ipad_RepTransactionFilterViewController.h"
#import "ipad_RepCashflowFilterViewController.h"
#import "ipad_ADSDeatailViewController.h"
#import "AppDelegate_iPad.h"

@interface ipad_ReportViewController ()

@end

@implementation ipad_ReportViewController
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
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = NSLocalizedString(@"VC_Export Report", nil);
	self.navigationItem.titleView = 	titleLabel;
    
    transactioncsvlabelText.text = NSLocalizedString(@"VC_Transaction(CSV)", nil);
    transactionpdflabelText.text = NSLocalizedString(@"VC_Transaction(PDF)", nil);
    flowlabelText.text = NSLocalizedString(@"VC_Flow(PDF)", nil);
}

-(void)initPoint
{
    transactionCSVcell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    transactionPDFcell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    flowcell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    
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
-(void)backWithPopAdasDetailViewController:(NSInteger)i
{
    AppDelegate_iPad *appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [self dismissViewControllerAnimated:NO completion:^{
        adsDetailViewController = [[ipad_ADSDeatailViewController alloc]initWithNibName:@"ipad_ADSDeatailViewController" bundle:nil];
        adsDetailViewController.isComeFromSetting = NO;
        adsDetailViewController.pageNum = i;
        
        adsDetailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        appDelegate1.mainViewController.popViewController = adsDetailViewController;
        
        //            [self presentViewController:adsDetailViewController animated:YES completion:nil];
        [appDelegate1.mainViewController presentViewController:adsDetailViewController animated:YES completion:nil];
        
        adsDetailViewController.view.superview.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        
        //        adsDetailViewController.view.superview.frame = CGRectMake(
        //                                                                  322,
        //                                                                  100,
        //                                                                  410,
        //                                                                  596
        //                                                                  );
        adsDetailViewController.view.superview.backgroundColor = [UIColor clearColor];
    }];
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
    if (indexPath.row==0)
    {
        ipad_EmailViewController *emailViewController = [[ipad_EmailViewController alloc]initWithNibName:@"ipad_EmailViewController" bundle:nil];
        [self.navigationController pushViewController:emailViewController animated:YES];
    }

    else if (indexPath.row==1)
    {
        if (proImage1.hidden)
        {
            ipad_RepTransactionFilterViewController* repTransactionFilterViewController = [[ipad_RepTransactionFilterViewController alloc] initWithNibName:@"ipad_RepTransactionFilterViewController" bundle:nil];
            [self.navigationController pushViewController:repTransactionFilterViewController animated:YES];
        }
        else
        {
            [self backWithPopAdasDetailViewController:1];
            return;
        }
        
    }
    
    else if (indexPath.row==2)
    {
        if (proImage2.hidden)
        {
            ipad_RepCashflowFilterViewController* repCashflowFilterViewController = [[ipad_RepCashflowFilterViewController alloc] initWithNibName:@"ipad_RepCashflowFilterViewController" bundle:nil];
            [self.navigationController pushViewController:repCashflowFilterViewController animated:YES];
        }
        else
        {
            [self backWithPopAdasDetailViewController:1];
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

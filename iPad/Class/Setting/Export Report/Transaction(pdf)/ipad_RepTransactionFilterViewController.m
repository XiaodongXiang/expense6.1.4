//
//  ipad_RepTransactionFilterViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "ipad_RepTransactionFilterViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_PDFPreviewController.h"
#import "ipad_ExportSelectedAccountViewController.h"
#import "ipad_ExportSelectedCategoryViewController.h"
#import "SetDateRangeViewController_iPad.h"

@interface ipad_RepTransactionFilterViewController ()

@end

@implementation ipad_RepTransactionFilterViewController
@synthesize 	cellType,cellDateRange,cellSort,cellCategory,cellAccount,celltransfer;
@synthesize     startDate,endDate;
@synthesize		accountBtn,cateogryBtn;
@synthesize     lblDateRange,lblCategory,lblAccount,transferSwitch;
@synthesize     tranDateTypeString;
@synthesize     tranAccountSelectArray,tranCategorySelectArray;
@synthesize allBtn,expenseBtn,incomeBtn;
@synthesize typeLabelText,accountsLabelText,categoryLabelText,dateRangeLabelText,sortByLabelText,transferLabelText;
@synthesize generateBtn;
@synthesize myTableView;

#pragma mark
#pragma mark DataSource
#pragma mark - Customer API
-(void)getAccountandCategoryData
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error =nil;
    
    [tranCategorySelectArray removeAllObjects];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [tranCategorySelectArray setArray:objects];
    
    [tranAccountSelectArray removeAllObjects];
    NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity_account = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest_account setEntity:entity_account];
    [fetchRequest_account setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor_account = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors_account = [[NSArray alloc] initWithObjects:sortDescriptor_account, nil];
    [fetchRequest_account setSortDescriptors:sortDescriptors_account];
    NSArray* objects_account = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error];
    [tranAccountSelectArray setArray:objects_account];

}
-(void)initMemoryDefine
{
    lblAccount.text = NSLocalizedString(@"VC_All", nil);
    lblCategory.text = NSLocalizedString(@"VC_All", nil);
    typeLabelText.text = NSLocalizedString(@"VC_Type", nil);
    accountsLabelText.text = NSLocalizedString(@"VC_Accounts", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    dateRangeLabelText.text = NSLocalizedString(@"VC_DateRange", nil);
    sortByLabelText.text = NSLocalizedString(@"VC_Sort By", nil);
    transferLabelText.text = NSLocalizedString(@"VC_Transfer", nil);
    
    [allBtn setTitle:NSLocalizedString(@"VC_All", nil) forState:UIControlStateNormal];
    [expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    [cateogryBtn setTitle:NSLocalizedString(@"VC_Category", nil) forState:UIControlStateNormal];
    [accountBtn setTitle:NSLocalizedString(@"VC_Account", nil) forState:UIControlStateNormal];
    [generateBtn setTitle:NSLocalizedString(@"VC_Run Report", nil) forState:UIControlStateNormal];
    
    cellType.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellAccount.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellCategory.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellDateRange.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    cellSort.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"]];
    celltransfer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    
    tranAccountSelectArray = [[NSMutableArray alloc] init];
    tranCategorySelectArray = [[NSMutableArray alloc]init];
    
    cateogryBtn.selected = YES;
    accountBtn.selected = NO;
    [accountBtn addTarget:self action:@selector(accountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cateogryBtn addTarget:self action:@selector(cateogryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    allBtn.selected = YES;
    expenseBtn.selected = NO;
    incomeBtn.selected = NO;
    [allBtn addTarget:self action:@selector(typeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [expenseBtn addTarget:self action:@selector(typeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [incomeBtn addTarget:self action:@selector(typeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initNavBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(0, 0, 30, 30);
	[backBtn setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = NSLocalizedString(@"VC_Transaction(PDF)", nil);
	self.navigationItem.titleView = 	titleLabel;
}

-(void)setViewControlValue
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![tranDateTypeString isEqualToString:@"Custom"])
    {
        self.startDate = [appDelegate.epnc getStartDate:tranDateTypeString];
        self.endDate = [appDelegate.epnc getEndDate:self.startDate withDateString:tranDateTypeString];
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:NSDateFormatterMediumStyle];
	[outputFormatter setTimeStyle:NSDateFormatterNoStyle];
 	self.lblDateRange.text = [NSString stringWithFormat:@"%@ ~ %@",[outputFormatter stringFromDate:self.startDate],[outputFormatter stringFromDate: self.endDate]];
}
-(IBAction)generateReportBtn:(id)sender;
{
    ipad_PDFPreviewController *pdfPreviewController =[[ipad_PDFPreviewController alloc] initWithNibName:@"ipad_PDFPreviewController" bundle:nil];
    pdfPreviewController.repTranFilterVC = self;
    if(allBtn.selected)
    {
        pdfPreviewController.pdfType =@"TRANALL";
        
    }
    else     if(expenseBtn.selected)
    {
        pdfPreviewController.pdfType =@"TRANEXPENSE";
        
    }
    else     if(incomeBtn.selected)
    {
        pdfPreviewController.pdfType =@"TRANINCOME";
        
    }
    [self.navigationController pushViewController:pdfPreviewController  animated:YES];
    
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)accountBtnPressed:(id)sender
{
    accountBtn.selected = YES;
    cateogryBtn.selected = NO;
}

-(void)cateogryBtnPressed:(id)sender
{
    cateogryBtn.selected = YES;
    accountBtn.selected = NO;
}

-(void)typeBtnSelected:(UIButton *)sender
{
    allBtn.selected = NO;
    expenseBtn.selected = NO;
    incomeBtn.selected = NO;
    if (sender.tag==1)
    {
        allBtn.selected = YES;
    }
    else if (sender.tag==2)
        expenseBtn.selected = YES;
    else
        incomeBtn.selected = YES;
}

#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row ==0)
    {
        return  cellType;
    }
    
 	else if (indexPath.row == 1)
    {
        return cellAccount;
    }
    else if(indexPath.row == 2)
    {
        return cellCategory;
    }
    else if(indexPath.row == 3)
    {
        return cellDateRange;
    }
    else if(indexPath.row == 4)
    {
        return cellSort;
    }
    
    return celltransfer;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        ipad_ExportSelectedAccountViewController *accountViewController = [[ipad_ExportSelectedAccountViewController alloc]initWithNibName:@"ipad_ExportSelectedAccountViewController" bundle:nil];
        accountViewController.transactionPDFViewController = self;
        [self.navigationController pushViewController:accountViewController animated:YES];

        
    }
	else if (indexPath.row == 2)
    {
        ipad_ExportSelectedCategoryViewController *exportViewContoller = [[ipad_ExportSelectedCategoryViewController alloc]initWithNibName:@"ipad_ExportSelectedCategoryViewController" bundle:nil];
        exportViewContoller.iTransactionPDFViewController = self;
        [self.navigationController pushViewController:exportViewContoller animated:YES];
        //         RepSelectCategoryViewController_iPhone *selectCategoryViewController = [[RepSelectCategoryViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
        //        selectCategoryViewController.iTranReportViewController = self;
        //        selectCategoryViewController.selectType =@"TRANSACTIONCATEGORY";
        //        [self.navigationController pushViewController:selectCategoryViewController animated:YES];
        //
        //         [selectCategoryViewController release];
        
    }
    //自定义时间
    else if (indexPath.row == 3)
    {
        SetDateRangeViewController_iPad *setDateRangeViewController = [[SetDateRangeViewController_iPad alloc] initWithStyle:UITableViewStylePlain];
        setDateRangeViewController.iRepTransactionFilterViewController = self;
        setDateRangeViewController.moduleString =@"REPORT_TRANSCATION";
        setDateRangeViewController.dateRangeString = tranDateTypeString;
        [self.navigationController pushViewController:setDateRangeViewController animated:YES];
        
        
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMemoryDefine];
    [self initNavBarStyle];
    [self getAccountandCategoryData];
    
    tranDateTypeString =@"This Month";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setViewControlValue];
    [myTableView reloadData];
}

#pragma mark - Release and Dealloc

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end

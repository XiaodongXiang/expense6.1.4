//
//  RepTransactionFilterViewController.m
//  PocketExpense
//
//  Created by MV on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepTransactionFilterViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "RepSelectCategoryViewController_iPhone.h"
#import "SetDateRangeViewController_iPhone.h"
#import "PDFPreviewController.h"
#import "AppDelegate_iPhone.h"
#import "AccountSelect.h"
#import "CategorySelect.h"
#import "ExportSelectedAccountViewController.h"
#import "ExportSelectedCategoryViewController.h"


@implementation RepTransactionFilterViewController
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
    
    
    generateBtn.layer.cornerRadius=5;
    generateBtn.layer.masksToBounds=YES;
    
//    [cellType  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellAccount setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellCategory  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellDateRange setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [cellSort  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_j1_320_44.png"]]];
//    [celltransfer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_b2_320_44.png"]]];
    self.typeLineHigh.constant = EXPENSE_SCALE;
    self.accountLineHigh.constant = EXPENSE_SCALE;
    self.dateLineHigh.constant = EXPENSE_SCALE;
    self.categoryLineHigh.constant = EXPENSE_SCALE;
    self.sortLineHigh.constant = EXPENSE_SCALE;
    self.transferLineHigh.constant = EXPENSE_SCALE;

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
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_Transaction(PDF)", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    PDFPreviewController *pdfPreviewController =[[PDFPreviewController alloc] initWithNibName:@"PDFPreviewController" bundle:nil];
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
    pdfPreviewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,pdfPreviewController.view.frame.size.height);
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
        ExportSelectedAccountViewController *accountViewController = [[ExportSelectedAccountViewController alloc]initWithNibName:@"ExportSelectedAccountViewController" bundle:nil];
        accountViewController.transactionPDFViewController = self;
        [self.navigationController pushViewController:accountViewController animated:YES];
        
//         RepSelectAccountViewController_iPhone *selectAccountViewController = [[RepSelectAccountViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
//        selectAccountViewController.iReportViewController = self;
//        [self.navigationController pushViewController:selectAccountViewController animated:YES];
//         [selectAccountViewController release];

    }
	else if (indexPath.row == 2)
    {
        ExportSelectedCategoryViewController *exportViewContoller = [[ExportSelectedCategoryViewController alloc]initWithNibName:@"ExportSelectedCategoryViewController" bundle:nil];
        exportViewContoller.transactionPDFViewController = self;
        [self.navigationController pushViewController:exportViewContoller animated:YES];
//         RepSelectCategoryViewController_iPhone *selectCategoryViewController = [[RepSelectCategoryViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
//        selectCategoryViewController.iTranReportViewController = self;
//        selectCategoryViewController.selectType =@"TRANSACTIONCATEGORY";
//        [self.navigationController pushViewController:selectCategoryViewController animated:YES];
//
//         [selectCategoryViewController release];

    }
    else if (indexPath.row == 3)
    {
        SetDateRangeViewController_iPhone *setDateRangeViewController = [[SetDateRangeViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
        setDateRangeViewController.repTransactionFilterViewController = self;
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

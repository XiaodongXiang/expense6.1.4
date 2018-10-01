//
//  CashDetailTransactionViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-31.
//
//

#import "CashDetailTransactionViewController.h"
#import "AppDelegate_iPhone.h"
#import "TransactionEditViewController.h"

#import "ReportTransactionCell.h"

#import "Transaction.h"
#import "Payee.h"
#import "Category.h"
#import "SearchRelatedViewController.h"


@interface CashDetailTransactionViewController ()

@end

@implementation CashDetailTransactionViewController


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
    [self initPoint];
    [self initNavBarStyle];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self getDataSource];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)refleshUI{
    if (self.transactionEditViewController != nil) {
        [self.transactionEditViewController refleshUI];
    }
    else{
        [self getDataSource];
    }
}
#pragma mark View didLoad Method
-(void)initPoint{
    _ctvc_dateFoamatter = [[NSDateFormatter alloc]init];
    _ctvc_dateFoamatter.dateStyle = NSDateFormatterMediumStyle;
    _ctvc_dateFoamatter.timeStyle = NSDateFormatterNoStyle;
    [_ctvc_dateFoamatter setLocale:[NSLocale currentLocale]];
    
    _ctvc_naviTitleDataFormatter = [[NSDateFormatter alloc]init];
    
    _transactionArray = [[NSMutableArray alloc]init];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _ctvc_endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:_ctvc_startDate];
    _swipCellIndex = -1;
}

-(void)initNavBarStyle
{
    [self.ctvc_naviTitleDataFormatter setDateFormat:@"MMM yyyy"];

    
    [self.navigationController.navigationBar doSetNavigationBar];
    
    self.navigationItem.title = [self.ctvc_naviTitleDataFormatter stringFromDate:self.ctvc_startDate];
}

#pragma mark Btn Method
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteBtnPressed:(UIButton *)sender{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    Transaction *trans = [_transactionArray objectAtIndex:sender.tag];
    
    [appDelegete.epdc deleteTransactionRel:trans];
    self.swipCellIndex=-1;
    [self getDataSource];
}

-(void)searchBtnPressed:(UIButton *)sender{
    Transaction *trans = [_transactionArray objectAtIndex:_swipCellIndex];
    self.searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
    self.searchRelatedViewController.transaction = trans;
    [self.navigationController pushViewController:self.searchRelatedViewController animated:YES];
}

#pragma mark View WillAppear
-(void)getDataSource{
    
    [_transactionArray removeAllObjects];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSError * error=nil;
    
  	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.ctvc_startDate,@"startDate",self.ctvc_endDate,@"endDate",  nil];
 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"getTransactionWithDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    NSMutableArray *objects = [[NSMutableArray alloc]initWithArray:[appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error]];

    [_transactionArray setArray:objects];
    
    [_ctvc_tableView reloadData];
	
}
#pragma mark TableView Method
- (void)configureReportCategoryCell:(ReportTransactionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    Transaction *oneTransaction = [_transactionArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = [_ctvc_dateFoamatter stringFromDate:oneTransaction.dateTime];
    
    if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"] ||[oneTransaction.childTransactions count]>0) {
        [cell.amountLabel setTextColor:[UIColor colorWithRed:243.0/255 green:61.0/255 blue:36.0/255 alpha:1]];
        if (oneTransaction.payee!=nil)
        {
            cell.nameLabel.text = oneTransaction.payee.name;
        }
        else if ([oneTransaction.notes length]>0)
            cell.nameLabel.text = oneTransaction.notes;
        else
        {
            cell.nameLabel.text = @"-";
        }
        cell.amountLabel.text = [appDelegate.epnc formatterString:(0-[oneTransaction.amount doubleValue]) ];
        
        
    }
    else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
        [cell.amountLabel setTextColor:[UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1.0]];
        if (oneTransaction.payee!=nil)
        {
            cell.nameLabel.text = oneTransaction.payee.name;
        }
        else
        {
            cell.nameLabel.text = @"-";
        }        cell.amountLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue] ];
        
        
    }
    else{
        [cell.amountLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",oneTransaction.expenseAccount.accName,oneTransaction.incomeAccount.accName ];
        cell.amountLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue] ];
    }
    
    if (_swipCellIndex!=-1 && indexPath.row==_swipCellIndex) {
        [cell  layoutShowTwoCellBtns:YES];
    }
    else
        [cell layoutShowTwoCellBtns:NO];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_transactionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TrackCellIdentifier = @"TrackCell";
    ReportTransactionCell *cell = (ReportTransactionCell *)[tableView dequeueReusableCellWithIdentifier:TrackCellIdentifier];
    if (cell == nil)
    {
        cell = [[ReportTransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TrackCellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.cashDetailViewController = self;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    cell.searchBtn.tag = indexPath.row;
    //color label上面的投影是在cell里面加的
    [self configureReportCategoryCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.swipCellIndex!=-1) {
        self.swipCellIndex=-1;
        [_ctvc_tableView reloadData];
        return;
    }
    
    
    Transaction *tmpTransaction = (Transaction *)[_transactionArray objectAtIndex:indexPath.row];
    
    if (tmpTransaction.parTransaction != nil) {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a part of a transaction split, and it can not be edited alone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        appDelegate_iPhone.appAlertView = alertView;
        [alertView show];
        return;
        
    }
    
	self.transactionEditViewController =[[TransactionEditViewController alloc] initWithNibName:@"TransactionEditViewController" bundle:nil];
    self.transactionEditViewController.transaction = tmpTransaction;
    self.transactionEditViewController.typeoftodo = @"EDIT";
    
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:self.transactionEditViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=-1) {
        self.swipCellIndex=-1;
        _ctvc_tableView.scrollEnabled = NO;
        [_ctvc_tableView reloadData];
        _ctvc_tableView.scrollEnabled = YES;
        [_ctvc_tableView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

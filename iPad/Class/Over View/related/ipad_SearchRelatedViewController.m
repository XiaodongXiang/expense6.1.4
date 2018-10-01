//
//  ipad_SearchRelatedViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-26.
//
//

#import "ipad_SearchRelatedViewController.h"
#import "AppDelegate_iPad.h"
#import "ipad_TranscactionQuickEditViewController.h"

#import "ipad_ReleatedCell.h"

#import "Transaction.h"
#import "Category.h"
#import "Payee.h"

@interface ipad_SearchRelatedViewController ()

@end

@implementation ipad_SearchRelatedViewController
@synthesize transaction,categoryBtn,payeeBtn,myTableView,transactionArray;
@synthesize swipCellIndex,dateTimeFormatter;

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
    [self initPoint];
    [self initNavStyleWithType];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getDataSource];
}

-(void)initNavStyleWithType
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -5.f;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Related", nil);
    self.navigationItem.titleView = 	titleLabel;
    
    
    
    UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton1.frame = CGRectMake(0, 0, 30,30);
    [customerButton1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [customerButton1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
    self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    //	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //	customerButton.frame = CGRectMake(0, 0, 46, 30);
    //	[customerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [customerButton setTitle:@"Save" forState:UIControlStateNormal];
    //	[customerButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    //	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
    //	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    //	[rightButton release];
}

-(void)initPoint{
    [categoryBtn setTitle:NSLocalizedString(@"VC_Category", nil) forState:UIControlStateNormal];
    [payeeBtn setTitle:NSLocalizedString(@"VC_Payee", nil) forState:UIControlStateNormal];
//    [payeeBtn setTitle:NSLocalizedString(@"VC_Payee", nil) forState:UIControlStateSelected];

    transactionArray = [[NSMutableArray alloc]init];
    swipCellIndex = -1;
    categoryBtn.selected = YES;
    payeeBtn.selected = NO;
    
    [categoryBtn addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [payeeBtn addTarget:self action:@selector(payeeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dateTimeFormatter = [[NSDateFormatter alloc]init];
    [dateTimeFormatter setDateFormat:@"MMM dd, yyyy"];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_RELT"];
}

-(void)getDataSource{
    [transactionArray removeAllObjects];
    
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    NSError * error=nil;
    NSFetchRequest *fetchRequest;
    NSDictionary *sub;
    if (categoryBtn.selected)
    {
        if (self.transaction.category != nil )
        {
            if (self.transaction.expenseAccount != nil && self.transaction.incomeAccount!= nil) {
                [myTableView reloadData];
                return;
            }
            
            sub = [[NSDictionary alloc]initWithObjectsAndKeys:self.transaction.category,@"category", nil];
            fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionbyCategory" substitutionVariables:sub];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            [transactionArray setArray:objects];
        }
        //这里不能直接判断self.transaction!=nil,因为会保存指针
        else if(self.transaction.state != nil)
        {
            NSDictionary *sub = [[NSDictionary alloc]init];
            NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchAllTransfer" substitutionVariables:sub];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
            [fetch setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
            [transactionArray setArray:objects];
        }

        
    
    }
    else if(payeeBtn.selected)
    {
        if (transaction.payee != nil) {
            sub = [[NSDictionary alloc]initWithObjectsAndKeys:self.transaction.payee,@"payee", nil];
            fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionbyPayee" substitutionVariables:sub];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        
            NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            [transactionArray setArray:objects];
  
        }
        else if([transaction.notes length]>0)
        {
            fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"notes==%@ && state==1",transaction.notes];
            [fetchRequest setPredicate:pre];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
          
            NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            [transactionArray setArray:objects];
          
        }
        
    }
    
    
    
    
   
    
    [myTableView reloadData];
    
}

#pragma mark Bth Action
-(void)back:(id)sender{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate_iPad.mainViewController.currentViewSelect==0)
    {
        [appDelegate_iPad.mainViewController.overViewController refleshData];

    }
    else if(appDelegate_iPad.mainViewController.iAccountViewController != nil)
        [appDelegate_iPad.mainViewController.iAccountViewController reFleshTableViewData_withoutReset];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)categoryBtnPressed:(id)sender{
    categoryBtn.selected = YES;
    payeeBtn.selected = NO;
    [self getDataSource];
}

-(void)payeeBtnPressed:(id)sender{
    categoryBtn.selected = NO;
    payeeBtn.selected = YES;
    [self getDataSource];
}




#pragma mark tableView method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [transactionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ipad_ReleatedCell *cell = (ipad_ReleatedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ipad_ReleatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    
    [self configureAccountCell:cell atIndexPath:indexPath];
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}
//-------------配置Account cell
- (void)configureAccountCell:(ipad_ReleatedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Transaction *oneTransaction = [transactionArray objectAtIndex:indexPath.row];
	
    //icon,accountName
    if (oneTransaction.category != nil) {
        cell.cateIcon.image = [UIImage imageNamed:oneTransaction.category.iconName];
        
    }
    else if (oneTransaction.expenseAccount!=nil && oneTransaction.incomeAccount!=nil)
    {
        cell.cateIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];

    }
    else
        cell.cateIcon.image = [UIImage imageNamed:@"icon_mind.png"];
    if (oneTransaction.payee != nil) {
        cell.nameLabel.text = oneTransaction.payee.name;
    }
    else if ([oneTransaction.notes length]>0)
    {
        cell.nameLabel.text = oneTransaction.notes;
    }
    else
        cell.nameLabel.text = @"-";

    
    //dateTime
    cell.dateTimeLabel.text = [dateTimeFormatter stringFromDate:oneTransaction.dateTime];
    
    //memo
    if ([oneTransaction.notes length]>0)
        cell.memoIcon.hidden = NO;
    else
        cell.memoIcon.hidden = YES;
    
   
    //photo
    if (oneTransaction.photoName != nil) {
        cell.phonteIcon.hidden = NO;
        if (![oneTransaction.notes length]>0) {
            cell.phonteIcon.frame = CGRectMake(160, 33, 13, 11);
        }
        else
            cell.phonteIcon.frame = CGRectMake(140, 33, 13, 11);
    }
    else
        cell.phonteIcon.hidden = YES;
    
    //amount color
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
        [cell.blanceLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
        
    }
    else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"])
        [cell.blanceLabel setTextColor:[appDelegate.epnc getAmountGreenColor]];
    else
        [cell.blanceLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
    
    
    cell.blanceLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue]];

    
    cell.bgImageView.image = [UIImage imageNamed:@"ipad_cell_480_60.png"];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.swipCellIndex != -1) {
        self.swipCellIndex = -1;
        [myTableView reloadData];
        return;
    }
    
    ipad_TranscactionQuickEditViewController *editController =[[ipad_TranscactionQuickEditViewController alloc] initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    Transaction *transactions = [transactionArray objectAtIndex:indexPath.row];
	editController.transaction = transactions;
	if ([transactions.category.categoryType isEqualToString:@"INCOME"])
	{
		editController.accounts = transactions.incomeAccount;
        
	}
	else if ([transactions.category.categoryType isEqualToString:@"EXPENSE"])
	{
		editController.accounts = transactions.expenseAccount;
        
	}
	else {
		editController.fromAccounts = transactions.expenseAccount;
		editController.toAccounts = transactions.incomeAccount;
	}
	
	editController.categories = transactions.category;
	editController.payees = transactions.payee;
	editController.typeoftodo = @"IPAD_EDIT";
    editController.searchReleatedViewController = self;
	[[self navigationController] pushViewController:editController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        Transaction *trans = [transactionArray objectAtIndex:indexPath.row];
        self.swipCellIndex = indexPath.row;
        AppDelegate_iPad *appDelegete_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        
        if (![trans.recurringType isEqualToString:@"Never"]) {
            
            UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
            actionsheet.tag = 1;
            
            UITableViewCell *selectedCell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            CGPoint point1 = [myTableView convertPoint:selectedCell.frame.origin toView:self.view];
            [actionsheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:self.view
                             animated:YES];
            
            appDelegete_iPhone.appActionSheet = actionsheet;
            return;
            
        }
        else
        {
            [appDelegete_iPhone.epdc deleteTransactionRel:trans];
            self.swipCellIndex=-1;
            [self getDataSource];
        }

	}
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=-1) {
        self.swipCellIndex=-1;
        myTableView.scrollEnabled = NO;
        [myTableView reloadData];
        myTableView.scrollEnabled = YES;
    }
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPad *appDelegete_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    if (buttonIndex==1) {
        ;
    }
    else
    {
        Transaction *trans = [transactionArray objectAtIndex:swipCellIndex];
        [appDelegete_iPhone.epdc deleteTransactionRel:trans];
    }
    self.swipCellIndex=-1;
    [self getDataSource];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

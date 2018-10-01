//
//  ipad_ExportSelectedAccountViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import "ipad_ExportSelectedAccountViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_EmailViewController.h"
#import "ipad_RepTransactionFilterViewController.h"

#import "Accounts.h"
#import "AccountSelect.h"
#import "ipad_ReportAccountListCell.h"

@interface ipad_ExportSelectedAccountViewController ()

@end

@implementation ipad_ExportSelectedAccountViewController
@synthesize accountTable,selecedAccountAmountLabel,selectedAllBtn,selectedItemCount,accountArray,emailViewController;
@synthesize transactionPDFViewController;
@synthesize selectAllLabelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Lift Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNarBarStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getCategoryArray];
}

#pragma mark view did load method
-(void)initNarBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(setExportViewControllerCategoryArray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBar =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,doneBar];

    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    [titleLabel  setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"VC_Accounts", nil);
    self.navigationItem.titleView = titleLabel;
    
}

-(void)initPoint{
    
    selectAllLabelText.text = NSLocalizedString(@"VC_Select All", nil);

    accountArray = [[NSMutableArray alloc]init];
    [selectedAllBtn addTarget:self action:@selector(selectedAllBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getCategoryArray{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [accountArray removeAllObjects];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest1 setEntity:entity1];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest1 setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors1 = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest1 setSortDescriptors:sortDescriptors1];
    NSArray* objects1 = [[NSMutableArray alloc]initWithArray: [appDelegate.managedObjectContext executeFetchRequest:fetchRequest1 error:&error]];
    
    for (int i=0; i<[objects1 count]; i++) {
        Accounts *oneAccount = [objects1 objectAtIndex:i];
        AccountSelect *oneAccountSele = [[AccountSelect alloc]init];
        oneAccountSele.account = oneAccount;
        oneAccountSele.isSelected = NO;
        [accountArray addObject:oneAccountSele];
    }

    
    
	
    //设置哪些category被选中了
    NSMutableArray *emailArray = [[NSMutableArray alloc]init];
    if (self.emailViewController != nil) {
        [emailArray setArray:self.emailViewController.accountArray];
    }
    else if(self.transactionPDFViewController != nil)
        [emailArray setArray:self.transactionPDFViewController.tranAccountSelectArray];
    
    for (int i=0; i<[emailArray count]; i++) {
        Accounts *oneAccount = [emailArray objectAtIndex:i];
        NSUInteger index = [objects1 indexOfObject:oneAccount];
        
        if (index<=[accountArray count]) {
            AccountSelect *oneAccountSelected = [accountArray objectAtIndex:index];
            oneAccountSelected.isSelected = YES;
            
        }
    }
    [accountTable reloadData];
    
    [self setContexShow];
    
}

-(void)setContexShow{
    selectedItemCount = 0;
    BOOL isSelectedAll = YES;
    for (int i=0; i<[accountArray count]; i++) {
        AccountSelect *oneAccountSele = [accountArray objectAtIndex:i];
        if (oneAccountSele.isSelected) {
            selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    
    if (isSelectedAll) {
        selectedAllBtn.selected = YES;
    }
    else
        selectedAllBtn.selected = NO;
    
    selecedAccountAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
}
#pragma mark Btn Action
-(void)back:(id)sender{
    [self setExportViewControllerCategoryArray];
    
}

-(void)setExportViewControllerCategoryArray{
    if (self.emailViewController != nil) {
        [self.emailViewController.accountArray removeAllObjects];
        
    }
    else if(self.transactionPDFViewController != nil)
        [self.transactionPDFViewController.tranAccountSelectArray removeAllObjects];
    
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *selectedArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[accountArray count]; i++) {
        AccountSelect *oneAccount = [accountArray objectAtIndex:i];
        if (oneAccount.isSelected) {
            [selectedArray addObject:oneAccount.account];
        }
    }
    
    if ([selectedArray count]==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Please select at least one account.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
        [alertView show];
        appDelegate_iPhone.appAlertView = alertView;
        return;
    }
    
    if (self.emailViewController != nil) {
        [self.emailViewController.accountArray setArray:selectedArray];
        
    }
    else if(self.transactionPDFViewController != nil)
        [self.transactionPDFViewController.tranAccountSelectArray setArray:selectedArray];
    
    if(selectedItemCount < [accountArray count])
    {
        if (self.emailViewController != nil) {
            self.emailViewController.lblAccount.text = NSLocalizedString(@"VC_Mutiple Accounts", nil);
            
        }
        else if (self.transactionPDFViewController != nil)
            self.transactionPDFViewController.lblAccount.text =NSLocalizedString(@"VC_Mutiple Accounts", nil);
    }
    else
    {
        if (self.emailViewController != nil)
        {
            self.emailViewController.lblAccount.text = NSLocalizedString(@"VC_All", nil);
        }
        else if (self.transactionPDFViewController != nil)
            self.transactionPDFViewController.lblAccount.text =NSLocalizedString(@"VC_All", nil);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectedAllBtnPressed:(id)sender{
    if (!selectedAllBtn.selected) {
        for (int i=0; i<[accountArray count]; i++) {
            AccountSelect *oneAccountSele = [accountArray objectAtIndex:i];
            oneAccountSele.isSelected = YES;
        }
        selectedItemCount = [accountArray count];
    }
    else if (selectedAllBtn.selected){
        for (int i=0; i<[accountArray count]; i++) {
            AccountSelect *oneAccountSele = [accountArray objectAtIndex:i];
            oneAccountSele.isSelected = NO;
        }
        selectedItemCount = 0;
    }
    [accountTable reloadData];
    selectedAllBtn.selected = !selectedAllBtn.selected;
}
#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"CellPar";
	
 	ipad_ReportAccountListCell *cellPar = (ipad_ReportAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	if (cellPar == nil)
	{
		cellPar = [[ipad_ReportAccountListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPar] ;
		cellPar.selectionStyle = UITableViewCellSelectionStyleNone;
 		cellPar.bgImageView.frame = CGRectMake(0, 0, 320,44.0);
		cellPar.bgImageView.image =[UIImage imageNamed:@"cell_b1_320_44.png"];
        cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
	}
    
	AccountSelect *oneAccountSele = (AccountSelect *)[accountArray objectAtIndex:indexPath.row];
	Accounts *oneAccount = oneAccountSele.account;
	
	
	cellPar.nameLabel.text = oneAccount.accName;
	cellPar.headImageView.image = [UIImage imageNamed:oneAccount.accountType.iconName];
	
    
    //给选中的category做标记
    if (oneAccountSele.isSelected) {
        cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cellPar.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row== [accountArray count]-1)
    {
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"];
    }
    else
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_b2_add_transactions.png"];
	return cellPar;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//标记被选中的cell(也就是category)哪些被选中了
    AccountSelect *selectAccount= [accountArray objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(selectAccount.isSelected)
    {
        selectAccount.isSelected = NO;
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedItemCount --;
    }
    else {
        selectAccount.isSelected = YES;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedItemCount ++;
    }
    selecedAccountAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
    if (selectedItemCount == [accountArray count]) {
        selectedAllBtn.selected = YES;
    }
    else
        selectedAllBtn.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

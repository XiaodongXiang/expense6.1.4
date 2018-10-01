//
//  ExportSelectedAccountViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-22.
//
//

#import "ExportSelectedAccountViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "EmailViewController.h"
#import "Accounts.h"
#import "AppDelegate_iPhone.h"
#import "ReportAccountListCell.h"
#import "RepTransactionFilterViewController.h"
#import "AccountSelect.h"


@interface ExportSelectedAccountViewController ()

@end

@implementation ExportSelectedAccountViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -12.f;

    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(setExportViewControllerCategoryArray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBar =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,doneBar];

    self.navigationItem.title = NSLocalizedString(@"VC_Accounts", nil);
}

-(void)initPoint
{
    _lineH.constant = EXPENSE_SCALE;
    
    _selectAllLabelText.text = NSLocalizedString(@"VC_Select All", nil);
    
    _accountArray = [[NSMutableArray alloc]init];
    [_selectedAllBtn addTarget:self action:@selector(selectedAllBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getCategoryArray{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_accountArray removeAllObjects];
    
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
        [_accountArray addObject:oneAccountSele];
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
        
        if (index<=[_accountArray count]) {
            AccountSelect *oneAccountSelected = [_accountArray objectAtIndex:index];
            oneAccountSelected.isSelected = YES;
            
        }
    }

    [_accountTable reloadData];
    
    [self setContexShow];
    
}

-(void)setContexShow{
    _selectedItemCount = 0;
    BOOL isSelectedAll = YES;
    for (int i=0; i<[_accountArray count]; i++) {
        AccountSelect *oneAccountSele = [_accountArray objectAtIndex:i];
        if (oneAccountSele.isSelected) {
            _selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    
    if (isSelectedAll) {
        _selectedAllBtn.selected = YES;
    }
    else
        _selectedAllBtn.selected = NO;
    
    _selecedAccountAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)_selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
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
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *selectedArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[_accountArray count]; i++) {
        AccountSelect *oneAccount = [_accountArray objectAtIndex:i];
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
    
    if(_selectedItemCount < [_accountArray count])
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
    if (!_selectedAllBtn.selected) {
        for (int i=0; i<[_accountArray count]; i++) {
            AccountSelect *oneAccountSele = [_accountArray objectAtIndex:i];
            oneAccountSele.isSelected = YES;
        }
        _selectedItemCount = [_accountArray count];
    }
    else if (_selectedAllBtn.selected){
        for (int i=0; i<[_accountArray count]; i++) {
            AccountSelect *oneAccountSele = [_accountArray objectAtIndex:i];
            oneAccountSele.isSelected = NO;
        }
        _selectedItemCount = 0;
    }
    [_accountTable reloadData];
    _selectedAllBtn.selected = !_selectedAllBtn.selected;
}
#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accountArray count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"ReportAccountListCell";
	
 	ReportAccountListCell *cellPar = (ReportAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	if (cellPar == nil)
	{
		cellPar = [[[NSBundle mainBundle]loadNibNamed:@"ReportAccountListCell" owner:nil options:nil]lastObject];
		cellPar.selectionStyle = UITableViewCellSelectionStyleNone;
        cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
	}
    
	AccountSelect *oneAccountSele = (AccountSelect *)[_accountArray objectAtIndex:indexPath.row];
	Accounts *oneAccount = oneAccountSele.account;
	
	
	cellPar.nameLabel.text = oneAccount.accName;
	cellPar.headImageView.image = [UIImage imageNamed:oneAccount.accountType.iconName];
	
    
    //给选中的category做标记
    if (oneAccountSele.isSelected) {
        cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cellPar.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row== [_accountArray count]-1)
    {
        cellPar.lineX.constant = 0;
    }
    else
        cellPar.lineX.constant = 46;
	return cellPar;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//标记被选中的cell(也就是category)哪些被选中了
    AccountSelect *selectAccount= [_accountArray objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(selectAccount.isSelected)
    {
        selectAccount.isSelected = NO;
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        _selectedItemCount --;
    }
    else {
        selectAccount.isSelected = YES;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedItemCount ++;
    }
    _selecedAccountAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)_selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
    
    if (_selectedItemCount == [_accountArray count]) {
        _selectedAllBtn.selected = YES;
    }
    else
        _selectedAllBtn.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

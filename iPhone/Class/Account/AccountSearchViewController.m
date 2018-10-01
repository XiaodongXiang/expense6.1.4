//
//  AccountSearchViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-18.
//
//

#import "AccountSearchViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "TransactionEditViewController.h"
#import "SearchRelatedViewController.h"
#import "HMJTextField.h"

#import "SearchCellCell.h"
#import "Transaction.h"
#import "Payee.h"
#import "CustomSearchCell.h"
#import "XDAddTransactionViewController.h"
#import "Category.h"
@interface AccountSearchViewController ()<XDAddTransactionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (nonatomic, strong)Category* otherCategory_income;
@end

@implementation AccountSearchViewController
-(Category *)otherCategory_income{
    if (!_otherCategory_income) {
        _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1 and categoryType = %@",@"INCOME"] sortDescriptors:nil]lastObject];
        if (!_otherCategory_income) {
            _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName = %@ and categoryType = %@",@"Others",@"INCOME"] sortDescriptors:nil]lastObject];
            if (!_otherCategory_income) {
                _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryType = %@",@"INCOME"] sortDescriptors:nil]firstObject];
            }
        }
    }
    return _otherCategory_income;
}
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
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    if (IS_IPHONE_X) {
        self.topLeading.constant = 44;
    }
    
    
    
    [self initPoint];
    [self initNarBarStyle];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getTransactionSource];
    [self.asvc_tableView reloadData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
    [self.asvc_textField becomeFirstResponder];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [_asvc_textField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)refleshUI{
    [self getTransactionSource];
    [self.asvc_tableView reloadData];
}

-(void)initPoint{
    _searchBg.image = [UIImage imageNamed:[NSString customImageName:@"Search_Bar.png"]];
    firsttobeHere = NO;
    
    _asvc_textField.placeholder = NSLocalizedString(@"VC_Search", nil);
    [_asvc_textField  setTintColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1]];
    _asvc_transactionArray = [[NSMutableArray alloc]init];
    _swipCellIndex = -1;
    [_asvc_textField setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
    [_asvc_textField becomeFirstResponder];
    _outputFormatter = [[NSDateFormatter alloc] init];
	[_outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
//    NSString *searchText = [NSString stringWithFormat:@"%@, %@, %@",NSLocalizedString(@"VC_Payee", nil),NSLocalizedString(@"VC_Amount", nil),NSLocalizedString(@"VC_Memo", nil)];
//    _asvc_textField.placeholder = searchText;
}

-(void)initNarBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Search", nil);
}

-(void)getTransactionSource{
    [_asvc_transactionArray removeAllObjects];
	NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //搜索所有不是childTrans的transaction,使用过滤的时候
    NSDictionary *sub = [[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscations" substitutionVariables:sub];;
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"(payee.name contains[c] %@ || amount contains[c] %@ || notes contains[c] %@ || category.categoryName contains[c] %@) && state contains[c] %@ && parTransaction==nil ",_asvc_textField.text,_asvc_textField.text,_asvc_textField.text,_asvc_textField.text,@"1"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];
    
//    [asvc_transactionArray removeAllObjects];
//    for (int i=0; i<[tmpAccountArray count]; i++) {
//        Transaction *oneTrans = [tmpAccountArray objectAtIndex:i];
//        if (oneTrans.parTransaction == nil){
//            [asvc_transactionArray addObject:oneTrans];
//        }
//    }
    [_asvc_transactionArray setArray:tmpAccountArray];

}

#pragma mark Btn Action
-(void)back:(id)sender
{
    [_asvc_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cellsearchBtnPressed:(NSIndexPath *)indexPath
{
    self.swipCellIndex = -1;
    
    Transaction *trans = [_asvc_transactionArray objectAtIndex:indexPath.row];
    SearchRelatedViewController *searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
    searchRelatedViewController.transaction = trans;
    
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:searchRelatedViewController];
    [self presentViewController:naviCtrl animated:YES completion:nil];
}

-(void)cellDeleteBtnPresses:(NSIndexPath *)indexPath
{
    
    Transaction *trans = [_asvc_transactionArray objectAtIndex:indexPath.row];;
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (![trans.recurringType isEqualToString:@"Never"]) {
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
        actionsheet.tag = 1;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        appDelegate_iPhone.appActionSheet = actionsheet;
        return;
        
    }
    else
    {
        [appDelegate_iPhone.epdc deleteTransactionRel:trans];
        [self getTransactionSource];
        self.swipCellIndex=-1;
        [self.asvc_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        [self.asvc_tableView reloadData];
    }
}

#pragma mark SearchBar Delegate methods
-(IBAction)textfieldTextChanged:(HMJTextField *)textField
{
    if (!firsttobeHere)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_SRC"];
        firsttobeHere = YES;
    }
    [self getTransactionSource];
    [self.asvc_tableView reloadData];
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//	[asvc_textField resignFirstResponder];
//}

#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_asvc_transactionArray.count == 0) {
        self.emptyImageView.hidden = NO;
    }else{
        self.emptyImageView.hidden = YES;
    }
    return  [_asvc_transactionArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *CellIdentifier = @"Cell";
    CustomSearchCell*cell = (CustomSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
	{
		cell = [[CustomSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
	}
    [self configureTransactionCell:cell atIndexPath:indexPath];
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:63];
    cell.delegate=self;
    
 	return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}

- (void)configureTransactionCell:(CustomSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

	Transaction *transactions = [_asvc_transactionArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    //name,amount,category
//     if([transcation.category.categoryType isEqualToString:@"INCOME"])
//    {
//        //name
//        if (transcation.payee != nil) {
//            cell.nameLabel.text = transcation.payee.name;
//        }
//        else if ([transcation.notes length]>0)
//            cell.nameLabel.text = transcation.notes;
//        else
//            cell.nameLabel.text = @"-";
//        cell.spentLabel.text =[appDelegete.epnc formatterStringWithOutPositive:[transcation.amount  doubleValue]];
//        cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
//        [cell.spentLabel setTextColor:[UIColor colorWithRed:27.0/255 green:200.0/255 blue:72.0/255 alpha:1.0]];
//
//     }
//    else if([transcation.category.categoryType isEqualToString:@"EXPENSE"]||[transcation.childTransactions count]>0)
//    {
//        //name
//        if (transcation.payee != nil) {
//            cell.nameLabel.text = transcation.payee.name;
//        }
//        else if ([transcation.notes length]>0)
//            cell.nameLabel.text = transcation.notes;
//        else
//            cell.nameLabel.text = @"-";
//        if ([transcation.childTransactions count]>0) {
//            cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind.png"];
//            NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[transcation.childTransactions allObjects]];
//            double childTotalAmount = 0;
//            for (int child=0; child <[childArray count]; child++) {
//                Transaction *oneChild = [childArray objectAtIndex:child];
//                if ([oneChild.state isEqualToString:@"1"]) {
//                    childTotalAmount += [oneChild.amount doubleValue];
//                }
//            }
//            cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:(0-childTotalAmount)];
//
//        }
//        else
//        {
//            cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
//
//            cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
//        }
//
//        [cell.spentLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
//     }
//    else
//     {
//        cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
//        [cell.spentLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
//
//        cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",transcation.expenseAccount.accName,transcation.incomeAccount.accName ];
//
//    }

    if([transactions.category.categoryType isEqualToString:@"EXPENSE"]  || [transactions.childTransactions count]>0)
    {
        if ([transactions.childTransactions count]>0)
        {
            cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind.png"];
            
          
            cell.spentLabel.text = [appDelegete.epnc formatterStringWithOutPositive:[transactions.amount  doubleValue]];
            cell.nameLabel.text =@"Split";
            cell.spentLabel.textColor=RGBColor(240, 106, 68);

        }
        else
        {
            cell.categoryIcon.image = [UIImage imageNamed:transactions.category.iconName];
            cell.spentLabel.text = [NSString stringWithFormat:@"-%@",[appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]]];
            cell.nameLabel.text =transactions.payee.name?:@"-";
            cell.spentLabel.textColor=RGBColor(240, 106, 68);
            
            if (transactions.incomeAccount && transactions.expenseAccount && transactions.transactionType == nil) {
                cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
                [cell.spentLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
                
                NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
                NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
                
                cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                
            }
        }
        //        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        
    }  else if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.categoryIcon.image = [UIImage imageNamed:transactions.category.iconName];
        cell.spentLabel.textColor=RGBColor(19, 200, 48);
        
        //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        cell.nameLabel.text = transactions.payee.name?:@"-";
        
        cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
        
        if (transactions.expenseAccount && transactions.incomeAccount && ![transactions.transactionType isEqualToString:@"income"]) {
            cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
            [cell.spentLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
            
            NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
            NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
            
            cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
            
        }
    }
    //transfer
    else
    {
        cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
        [cell.spentLabel setTextColor:[appDelegate_iPhone.epnc getAmountGrayColor]];
        
        NSString *expenseName = [transactions.expenseAccount.accName uppercaseString];
        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",expenseName,incomeString];
        
        cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
        
        if (transactions.category == nil && ![transactions.transactionType isEqualToString:@"transfer"]) {
            if (transactions.expenseAccount && transactions.incomeAccount == nil) {
                cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind_white"];
                cell.spentLabel.text = [NSString stringWithFormat:@"-%@",[appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]]];
                cell.nameLabel.text =NSLocalizedString(@"VC_Split", nil);
                cell.spentLabel.textColor=RGBColor(240, 106, 68);
            }else if(transactions.incomeAccount != nil && transactions.expenseAccount == nil  && [transactions.transactionType isEqualToString:@"income"]){
                if (transactions.payee.category) {
                    if ([transactions.payee.category.categoryType isEqualToString:@"EXPENSE"]) {
                        cell.categoryIcon.image = [UIImage imageNamed:transactions.payee.category.iconName];
                        cell.spentLabel.textColor=RGBColor(240, 106, 68);
                        
                        //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                        cell.nameLabel.text = transactions.payee.name?:@"-";
                        
                        cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                        
                    }else if ([transactions.payee.category.categoryType isEqualToString:@"INCOME"]){
                        cell.categoryIcon.image = [UIImage imageNamed:transactions.payee.category.iconName];
                        cell.spentLabel.textColor=RGBColor(19, 200, 48);
                        
                        //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                        cell.nameLabel.text = transactions.payee.name?:@"-";
                        
                        cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                        
                    }
                }else{
                    cell.categoryIcon.image = [UIImage imageNamed:self.otherCategory_income.iconName];
                    cell.spentLabel.textColor=RGBColor(19, 200, 48);
                    
                    //        NSString *incomeString = [transactions.incomeAccount.accName uppercaseString];
                    cell.nameLabel.text = transactions.payee.name?:@"-";
                    
                    cell.spentLabel.text = [appDelegate_iPhone.epnc formatterString:[transactions.amount doubleValue]];
                    
                }
            }
        }
    }
    
    //time
    NSString* time = [_outputFormatter stringFromDate:transactions.dateTime];
	cell.timeLabel.text = time;
    
    //memo
    if ([transactions.notes length]>0) cell.memoImage.hidden = NO;
    else
        cell.memoImage.hidden = YES;
    
    if (transactions.photoName != nil) {
        cell.phontoImage.hidden = NO;
        if ([transactions.notes length]>0) {
            cell.phontoImage.frame = CGRectMake(160,29, 13, 11);
        }
        else
            cell.phontoImage.frame = CGRectMake(140,29, 13, 11);
    }
    else
        cell.phontoImage.hidden = YES;
    

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.swipCellIndex != -1) {
        self.swipCellIndex = -1;
        [_asvc_tableView reloadData];
        return;
    }
    self.swipCellIndex = -1;
    
//
//    TransactionEditViewController *editController =[[TransactionEditViewController alloc] initWithNibName:@"TransactionEditViewController" bundle:nil];
    XDAddTransactionViewController* editController = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];

   	Transaction *transactions = [_asvc_transactionArray objectAtIndex:indexPath.row];
	editController.editTransaction = transactions;
//    if ([transactions.category.categoryType isEqualToString:@"INCOME"])
//    {
//        editController.accounts = transactions.incomeAccount;
//
//    }
//    else if ([transactions.category.categoryType isEqualToString:@"EXPENSE"])
//    {
//        editController.accounts = transactions.expenseAccount;
//
//    }
//    else {
//        editController.fromAccounts = transactions.expenseAccount;
//        editController.toAccounts = transactions.incomeAccount;
//    }
//
//    editController.categories = transactions.category;
//    editController.payees = transactions.payee;
//    editController.typeoftodo = @"EDIT";
//    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:editController];
//    [self presentViewController:navigationViewController animated:YES completion:nil];
//    tranVc.editTransaction = transcation;
    editController.delegate = self;
    [self presentViewController:editController animated:YES completion:nil];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=-1) {
        self.swipCellIndex=-1;
        _asvc_tableView.scrollEnabled = NO;
        [_asvc_tableView reloadData];
        _asvc_tableView.scrollEnabled = YES;
        return;
    }
    [_asvc_textField resignFirstResponder];
    
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (buttonIndex==1)
    {
        ;
    }
    else
    {
        if (_swipCellIndex > _asvc_transactionArray.count) {
            return;
        }
        Transaction *trans = [_asvc_transactionArray objectAtIndex:_swipCellIndex];;
        [appDelegate_iPhone.epdc deleteTransactionRel:trans];
        [self getTransactionSource];
        
    }
    self.swipCellIndex=-1;
    [self.asvc_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- XDAddTransactionViewDelegate
-(void)addTransactionCompletion{
    [self getTransactionSource];
    [self.asvc_tableView reloadData];
}

#pragma mark - SWTableview
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[_asvc_tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self cellsearchBtnPressed:indexPath];
            break;
        default:
            [self cellDeleteBtnPresses:indexPath];
            break;
    }
}

@end

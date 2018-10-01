//
//  SearchRelatedViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import "SearchRelatedViewController.h"
#import "AppDelegate_iPhone.h"
#import "TransactionEditViewController.h"

#import "ReleatedCell.h"

#import "Transaction.h"
#import "Category.h"
#import "Payee.h"

#import "XDAddTransactionViewController.h"

@interface SearchRelatedViewController ()
@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading;

@end

@implementation SearchRelatedViewController
@synthesize transaction,categoryBtn,payeeBtn,myTableView,transactionArray;
@synthesize swipCellIndex,dateTimeFormatter;
@synthesize duplicateDate;
@synthesize duplicateDateViewController;


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
    
//    [self.myTableView setSeparatorColor:RGBColor(238, 238, 238)];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getDataSource];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];

}

-(void)initNavStyleWithType
{
//    [self.navigationController.navigationBar doSetNavigationBar];
    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];

    self.navigationItem.title = NSLocalizedString(@"VC_Related", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 80, 44);
//    [back setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
//    [back.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
//    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [back setBackgroundColor:[UIColor clearColor]];
//    [back setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [back setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
//    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.rightBarButtonItems = @[leftButton];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    if (IS_IPHONE_X) {
        self.topLeading.constant = 98;
    }else{
        self.topLeading.constant = 74;
    }

}

-(void)cancelClick{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)initPoint{
    
    _line.frame = CGRectMake(_line.frame.origin.x,50-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE);
    [categoryBtn setTitle:NSLocalizedString(@"VC_Category", nil) forState:UIControlStateNormal];
    [payeeBtn setTitle:NSLocalizedString(@"VC_Payee", nil) forState:UIControlStateNormal];
    transactionArray = [[NSMutableArray alloc]init];
    swipCellIndex = -1;
    categoryBtn.selected = YES;
    payeeBtn.selected = NO;
    
    [categoryBtn addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [payeeBtn addTarget:self action:@selector(payeeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dateTimeFormatter = [[NSDateFormatter alloc]init];
    [dateTimeFormatter setDateFormat:@"MMM dd, yyyy"];
    
//    float screenWith = [[UIScreen mainScreen]bounds].size.width;
    
//    categoryBtn.frame = CGRectMake(100+screenWith/2-categoryBtn.frame.size.width, categoryBtn.frame.origin.y, categoryBtn.frame.size.width, categoryBtn.frame.size.height);
//    payeeBtn.frame =CGRectMake(100+screenWith/2, payeeBtn.frame.origin.y, payeeBtn.frame.size.width, payeeBtn.frame.size.height);
//
    [categoryBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [categoryBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];

    [payeeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [payeeBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(113, 163, 245)] forState:UIControlStateSelected];
    
    categoryBtn.layer.cornerRadius = 15;
    categoryBtn.layer.masksToBounds = YES;
    payeeBtn.layer.cornerRadius = 15;
    payeeBtn.layer.masksToBounds = YES;
    self.btnBackView.layer.cornerRadius = 15;
    self.btnBackView.layer.masksToBounds = YES;
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_RELT"];
    
}

-(void)getDataSource{
    [transactionArray removeAllObjects];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError * error=nil;
    NSFetchRequest *fetchRequest;
    NSDictionary *sub;
    if (categoryBtn.selected)
    {
        
        if(self.transaction.category != nil)
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
        else
        {
            NSDictionary *sub = [[NSDictionary alloc]init];
            NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchAllTransfer" substitutionVariables:sub];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
            [fetch setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
            [transactionArray setArray:objects];
        }
        
    }
    else if(payeeBtn.selected){
        if (transaction.payee != nil) {
            sub = [[NSDictionary alloc]initWithObjectsAndKeys:self.transaction.payee,@"payee", nil];
            fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionbyPayee" substitutionVariables:sub];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            [transactionArray setArray:objects];
            
        }
        else
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
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)cellcopyBtnPressed:(UIButton *)sender
{
    self.duplicateDate = [NSDate date];
    self.duplicateDateViewController= [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController_iPhone" bundle:nil];
    duplicateDateViewController.delegate = self;
    [self.view addSubview:duplicateDateViewController.view];
}

-(void)cellDeleteBtnPressed:(UIButton *)sender
{
    Transaction *trans = [transactionArray objectAtIndex:swipCellIndex];
    AppDelegate_iPhone *appDelegete_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if (![trans.recurringType isEqualToString:@"Never"]) {
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
        actionsheet.tag = 1;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        AppDelegate_iPhone *appDelegete_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
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

#pragma mark tableView method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [transactionArray count];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
//    }
//    
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
//    }
//    
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReleatedCell *cell = (ReleatedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ReleatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.cellcopyBtn addTarget:self action:@selector(cellcopyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.celldeleteBtn addTarget:self action:@selector(cellDeleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.searchRelatedViewController = self;
    cell.cellcopyBtn.tag = indexPath.row;
    cell.celldeleteBtn.tag = indexPath.row;
    cell.tag = indexPath.row;
    
    [self configureAccountCell:cell atIndexPath:indexPath];
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}
//-------------配置Account cell
- (void)configureAccountCell:(ReleatedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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
        cell.nameLabel.text = oneTransaction.notes;
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
        if ([oneTransaction.notes length]>0) {
            cell.phonteIcon.frame = CGRectMake(160, 30, 20, 20);
        }
        else
            cell.phonteIcon.frame = CGRectMake(140, 30, 20, 20);
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
    if (cell.tag == swipCellIndex) {
        [cell layoutShowTwoCellBtns:YES];
    }
    else
        [cell layoutShowTwoCellBtns:NO];
    
    cell.bgImageView.image = [UIImage imageNamed:@"cell_320_60.png"];

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.swipCellIndex != -1) {
        self.swipCellIndex = -1;
        [myTableView reloadData];
        return;
    }
    
    XDAddTransactionViewController *editController =[[XDAddTransactionViewController alloc] initWithNibName:@"XDAddTransactionViewController" bundle:nil];
    
    Transaction *transactions = [transactionArray objectAtIndex:indexPath.row];
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
    [self presentViewController:editController animated:YES completion:nil];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=-1) {
        self.swipCellIndex=-1;
        myTableView.scrollEnabled = NO;
        [myTableView reloadData];
        myTableView.scrollEnabled = YES;
    }
}

#pragma mark DuplicateTimeViewController delegate
-(void)setDuplicateDateDelegate:(NSDate *)date
{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (goon)
    {
        Transaction *selectedTrans = [transactionArray objectAtIndex:swipCellIndex];
        [appDelegate.epdc duplicateTransaction:selectedTrans withDate:self.duplicateDate];

        /*
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *errors;
        Transaction *oneTrans = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
        //配置新的  Transaction
        oneTrans.dateTime = self.duplicateDate;
        oneTrans.amount = selectedTrans.amount;
        oneTrans.photoName = selectedTrans.photoName;
        oneTrans.notes = selectedTrans.notes;
        oneTrans.transactionType = selectedTrans.transactionType;
        oneTrans.expenseAccount = selectedTrans.expenseAccount;
        oneTrans.incomeAccount = selectedTrans.incomeAccount;
        oneTrans.payee = selectedTrans.payee;
        oneTrans.isClear = selectedTrans.isClear;
        oneTrans.recurringType = selectedTrans.recurringType;
        oneTrans.parTransaction = selectedTrans.parTransaction;
        
        oneTrans.dateTime_sync = [NSDate date];
        oneTrans.state = @"1";
        oneTrans.uuid = [EPNormalClass GetUUID];
        [appDelegate_iPhone.managedObjectContext save:&errors];
        if (appDelegate_iPhone.dropbox.drop_account.linked) {
            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneTrans];
        }
        
        //如果是多category循环，就需要添加子category
        if ([selectedTrans.childTransactions count]>0) {
            for (int i=0; i<[selectedTrans.childTransactions count]; i++) {
                Transaction *oneSelectedChildTransaction = [[selectedTrans.childTransactions allObjects]objectAtIndex:i];
                
                Transaction *childTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
                //--------配置 childTransaction的所有信息-----/
                childTransaction.dateTime = self.duplicateDate;
                childTransaction.amount = oneSelectedChildTransaction.amount;
                //在添加子category的时候，将note也保存进来
                childTransaction.notes=oneSelectedChildTransaction.notes;
                childTransaction.category = oneSelectedChildTransaction.category;
                
                childTransaction.transactionType = oneSelectedChildTransaction.transactionType;
                childTransaction.incomeAccount =oneSelectedChildTransaction.incomeAccount;
                childTransaction.expenseAccount = oneSelectedChildTransaction.expenseAccount;
                
                childTransaction.isClear = [NSNumber numberWithBool:YES];
                childTransaction.recurringType = @"Never";
                childTransaction.state = @"1";
                childTransaction.dateTime_sync = [NSDate date];
                childTransaction.uuid = [EPNormalClass GetUUID];
                //给这个子category做标记
                if(oneSelectedChildTransaction.category!=nil)
                    childTransaction.category.others = @"HASUSE";
                childTransaction.payee =oneSelectedChildTransaction.payee;
                if(oneSelectedChildTransaction.category!=nil)
                {
                    //给当前的这个category下增加一个交易，添加关系而已
                    [oneSelectedChildTransaction.category addTransactionsObject:childTransaction];
                }
                //给当前这个 transaction 添加 childtransaction关系
                [oneTrans addChildTransactionsObject:childTransaction];
                if (![appDelegate_iPhone.managedObjectContext save:&errors])
                {
                    NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                    
                }
                if (appDelegate_iPhone.dropbox.drop_account.linked) {
                    [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneSelectedChildTransaction];
                }
            }
            
            
        }
        else
            oneTrans.category = selectedTrans.category;
        
        [appDelegate.epdc autoInsertTransaction:oneTrans];
        
        if (![appDelegate_iPhone.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
            
        }
        if (appDelegate_iPhone.dropbox.drop_account.linked)
        {
            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneTrans];
        }
        */
        
    }
    swipCellIndex=-1;
    [self getDataSource];
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPhone *appDelegete_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
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

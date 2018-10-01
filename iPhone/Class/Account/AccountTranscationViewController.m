//
//  AccountTranscationViewController.m
//  PokcetExpense
//
//  Created by Tommy on 2/24/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

/*功能逻辑：先用fetchRequest搜索出所有账户下的transaction，或者是某个account下的trans,按照时间顺序。2.把这些trans按条件（cleared,uncleared）分配到transaction数组中，用一个二维数组表示。然后tableview从这个二维数组中获取。注意：不管用户选择了show cleared,或者hide cleared,某一笔交易之后的runningbalance是固定的。*/

#import "AccountTranscationViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ExpenseCell.h"
#import "TransactionEditViewController.h"
#import "TransactionRule.h"
#import "AppDelegate_iPhone.h"
#import "AccountsViewController.h"
#import "ClearCusBtn.h"
#import "HMJButton.h"
#import "Payee.h"
#import "SearchRelatedViewController.h"
#import "EPNormalClass.h"
#import "AppDelegate_iPhone.h"
#import "DuplicateTimeViewController.h"
#import "OverViewWeekCalenderViewController.h"
#import "StartBalanceTableViewCell.h"
#import "CustomExpenseCell.h"

#import <Parse/Parse.h>

#import "ParseDBManager.h"

#import "accountPage.h"
#import "BHI_Utility.h"

@interface AccountTranscationViewController ()
{
    NSInteger _num;
    //是否第一次进入页面
    BOOL firstIn;
    //5000个cell处的标识
}
@end

@implementation AccountTranscationViewController



#pragma mark view cycle life
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initMemoryDefine];
    [self initNarBarStyle];
    [self createCollectionView];
    [self initBottomView];
    
    
    firstIn=YES;
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self resetData];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
    if (firstIn)
    {
        firstIn=NO;
        if (_accountArray.count!=1)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5000 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    [self.collectionView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.collectionView setContentOffset:CGPointMake(50*240-(SCREEN_WIDTH-225)/2, 0)];
    
}
-(void)resetData{
    [self getfetchedResultsController];
    
	[self setLabelLayoutAndValueByTransactions];
	if([self.fetchRequestResultsController sections]==0)
	{
		_noRecordView.hidden = NO;
	}
	else {
		_noRecordView.hidden = YES;
	}
    
}
-(void)refleshUI{
    if (self.transactionEditViewController != nil)
    {
        [self.transactionEditViewController refleshUI];
    }
    else{
        [self resetData];
    }
}

#pragma mark View Did Load Method
-(void)initBottomView
{
    _reconcileBtnWidth.constant=SCREEN_WIDTH/2;
    _middleLineToLeft.constant=SCREEN_WIDTH/2;
    NSString *string1=@"";
    NSString *string2=@"";
    
    if(_isShowReconcile)
    {
        string1 =NSLocalizedString(@"VC_ReconcileOff", nil);
    }
    else {
        string1 = NSLocalizedString(@"VC_ReconcileOn", nil);
    }
    if(!_isShowCleared )
    {
        string2 = NSLocalizedString(@"VC_ShowCleared", nil);
    }
    else {
        string2 = NSLocalizedString(@"VC_HideCleared", nil);
    }
    
    [self.reconcileBtn setTitle:string1 forState:UIControlStateNormal];
    [self.hiedeBtn setTitle:string2 forState:UIControlStateNormal];
    
    _lineHeight.constant=1/SCREEN_SCALE;
    _lineWidth.constant=1/SCREEN_SCALE;
}

-(void)initMemoryDefine
{
    _lineH.constant = EXPENSE_SCALE;
    if (IS_IPHONE_6PLUS)
    {
        _balanceX.constant = 75;
        _balanceTextX.constant = 75;
        _outstandingTextL.constant = 215;
        _outstandingX.constant = 215;
    }
    else if (IS_IPHONE_6)
    {
        _balanceX.constant = 50;
        _balanceTextX.constant = 50;
        _outstandingTextL.constant = 188;
        _outstandingX.constant = 188;
    }
    else
    {
        _balanceX.constant = 30;
        _balanceTextX.constant = 30;
        _outstandingTextL.constant = 151;
        _outstandingX.constant = 151;
    }
    
	_outputFormatter = [[NSDateFormatter alloc] init];
//	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
    _outputFormatter.dateStyle = NSDateFormatterMediumStyle;
    _outputFormatter.timeStyle = NSDateFormatterNoStyle;
    [_outputFormatter setLocale:[NSLocale currentLocale]];

    
    _sectionFormatter = [[NSDateFormatter alloc] init];
	[_sectionFormatter setDateFormat:@"MMMM yyyy"];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [_balanceLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
    [_outStandingLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
    
    self.swipCellIndex=nil;
    _isShowReconcile=NO;
    _isShowCleared = YES;
    [_dropBtn addTarget:self action:@selector(dropBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _outStandingLabel.adjustsFontSizeToFitWidth = YES;
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    _runningBalanceArray = [[NSMutableArray alloc]init];
    _transactionArray = [[NSMutableArray alloc]init];
    
    _outstandingTextLabel.adjustsFontSizeToFitWidth = YES;
    [_outstandingTextLabel setMinimumScaleFactor:0];
    
    
  
    
    
}

-(void)initNarBarStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];

    
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    
	UIButton *customerButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton1.frame = CGRectMake(0, 0, 30, 30);
	[customerButton1 setImage: [UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
    [customerButton1 addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton1];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];
    

    if ([self.type isEqualToString:@"All"])
        self.navigationItem.title = NSLocalizedString(@"VC_AllTransactions", nil);
    else if ([self.type isEqualToString:@"Uncleared"])
        self.navigationItem.title = NSLocalizedString(@"VC_Uncleared", nil);
    else
        self.navigationItem.title = self.account.accName;
}


-(void)setLabelLayoutAndValueByTransactions
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_transactionArray removeAllObjects];
    [_runningBalanceArray removeAllObjects];
    
    double totalClear,totalUnClear;
    totalClear =0;
    totalUnClear =0;
    
    
    _startAmount = 0;
    if (!self.account)
    {
        //get account array
        NSError *error = nil;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

        
        for (int i=0; i<[objects count]; i++)
        {
            Accounts *tmpAccount = (Accounts *)[objects objectAtIndex:i];
            _startAmount+=[tmpAccount.amount doubleValue];
        }
        
        
    }
    else
    {
        _startAmount = [self.account.amount doubleValue];
    }
    
    
    
  
    
    double lastAmount = _startAmount;
    for (long j=[[self.fetchRequestResultsController sections] count]-1; j>=0;j--)
    {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchRequestResultsController sections] objectAtIndex:j];
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        [sectionArray removeAllObjects];
        for (long k=[sectionInfo numberOfObjects]-1; k>=0; k--)
        {
            
            double currentAmount=0;

            Transaction *transactions = (Transaction *)[[sectionInfo objects]objectAtIndex:k];
            
            if([transactions.category.categoryType isEqualToString:@"EXPENSE"])
            {
                if([transactions.isClear boolValue])
                {
                    totalClear -=[transactions.amount doubleValue];
                }
                else
                {
                    totalUnClear +=[transactions.amount doubleValue];
                    
                }
                currentAmount = 0-[transactions.amount doubleValue];
                
            }
            else if([transactions.category.categoryType isEqualToString:@"INCOME"])
            {
                if([transactions.isClear boolValue])
                {
                    totalClear+=[transactions.amount doubleValue];
                }
                else
                {
                    totalUnClear +=[transactions.amount doubleValue];
                    
                }
                currentAmount = [transactions.amount doubleValue];
                
            }
            else
            {
                if(transactions.expenseAccount == self.account)
                {
                    if([transactions.isClear boolValue])
                    {
                        totalClear -=[transactions.amount doubleValue];
                    }
                    else
                    {
                        totalUnClear +=[transactions.amount doubleValue];
                        
                    }
                    
                    currentAmount = 0-[transactions.amount doubleValue];
                    
                }
                else    if(transactions.incomeAccount == self.account)
                {
                    if([transactions.isClear boolValue])
                    {
                        totalClear+=fabs([transactions.amount doubleValue]);
                    }
                    else
                    {
                        totalUnClear +=fabs([transactions.amount doubleValue]);
                        
                    }
                    currentAmount = fabs([transactions.amount doubleValue]);
                }
            }
            
            //根据uncleared或者是是否显示cleared的状态来收藏transaction
            if ([self.type isEqualToString:@"Uncleared"])
            {
                if(![transactions.isClear boolValue])
                {
                    [sectionArray insertObject:transactions atIndex:0];

                    [_runningBalanceArray insertObject:[NSNumber numberWithDouble:lastAmount +currentAmount] atIndex:0];

                }
                
                
            }
            else
            {
                if (_isShowCleared)
                {
                    [sectionArray insertObject:transactions atIndex:0];
                    [_runningBalanceArray insertObject:[NSNumber numberWithDouble:lastAmount +currentAmount] atIndex:0];

                }
                else if (!_isShowCleared && ![transactions.isClear boolValue])
                {
                    [sectionArray insertObject:transactions atIndex:0];
                    [_runningBalanceArray insertObject:[NSNumber numberWithDouble:lastAmount +currentAmount] atIndex:0];

                }
            }

            
            
            lastAmount =lastAmount + currentAmount;

        }
        
        
        
        if ([sectionArray count]>0)
        {
            [_transactionArray insertObject:sectionArray atIndex:0];
        }
    }

	self.outStandingLabel.text = [appDelegate.epnc formatterString:totalUnClear];
    //这里的balance计算了account起始金额
    self.balanceLabel.text = [appDelegate.epnc formatterString:totalClear - totalUnClear+_startAmount];
    
    _balanceTextLabel.text = NSLocalizedString(@"VC_BALANCE", nil);
    _outstandingTextLabel.text = [NSLocalizedString(@"VC_Uncleared", nil) uppercaseString];
    if ([self.type isEqualToString:@"Uncleared"]) {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _dropBtn.hidden = YES;
        _balanceLabel.hidden = YES;
        _balanceTextLabel.hidden = YES;
//        outStandingLabel.frame = CGRectMake(155, 0, 150, 49);
//        outstandingTextLabel.frame = CGRectMake(15, 0, 100, 49);
        
        _outStandingLabel.textAlignment = NSTextAlignmentRight;
        _outstandingTextLabel.textAlignment = NSTextAlignmentLeft;
        [_outStandingLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_outstandingTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [_balanceLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_balanceTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        
    }
    else if ([self.type isEqualToString:@"All"])
    {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _dropBtn.hidden = NO;
        _balanceLabel.hidden = NO;
        _balanceTextLabel.hidden = NO;
//        balanceLabel.frame = CGRectMake(30, 7, 100, 20);
//        outStandingLabel.frame = CGRectMake(156, 7, 100, 20);
//        balanceTextLabel.frame = CGRectMake(30, 24, 100, 20);
//        outstandingTextLabel.frame = CGRectMake(156, 24, 100, 20);
        _outStandingLabel.textAlignment = NSTextAlignmentCenter;
        _outstandingTextLabel.textAlignment = NSTextAlignmentCenter;

        [_outStandingLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_outstandingTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_balanceLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_balanceTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    }
    else
    {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        _dropBtn.hidden = NO;
        _balanceLabel.hidden = NO;
        _balanceTextLabel.hidden = NO;
//        balanceLabel.frame = CGRectMake(30, 7, 100, 20);
//        outStandingLabel.frame = CGRectMake(156, 7, 100, 20);
//        balanceTextLabel.frame = CGRectMake(30, 24, 100, 20);
//        outstandingTextLabel.frame = CGRectMake(156, 24, 100, 20);
        _outStandingLabel.textAlignment = NSTextAlignmentCenter;
        _outstandingTextLabel.textAlignment = NSTextAlignmentCenter;

        [_outStandingLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_outstandingTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_balanceLabel setFont:[appDelegate_iPhone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:17]];
        [_balanceTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    }
    
    
    
    [_mytableview reloadData];
}

#pragma mark alert view action

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
	 	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];		
 		
	}
}

#pragma mark nav bar event
- (void) back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}
-(void)showDetail:(id)sender
{

}

-(void)addBtnPressed:(id)sender{
    TransactionEditViewController *transactionEditViwController = [[TransactionEditViewController alloc]initWithNibName:@"TransactionEditViewController" bundle:nil];
    transactionEditViwController.accounts = self.account;
    transactionEditViwController.typeoftodo = @"ADD";
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:transactionEditViwController];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

-(void)cellDuplicateBtnPressed:(NSIndexPath *)indexPath{
    
    self.duplicateDate = [NSDate date];
    self.duplicateDateViewController= [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController_iPhone" bundle:nil];
    _duplicateDateViewController.delegate = self;
    [self.view addSubview:_duplicateDateViewController.view];
    
    
}
-(void)cellsearchBtnPressed:(NSIndexPath *)indexPath{
    self.swipCellIndex = nil;
    NSMutableArray *sectionArray = [_transactionArray objectAtIndex:indexPath.section];
    
    Transaction *trans = [sectionArray objectAtIndex:indexPath.row];
    SearchRelatedViewController *searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
    searchRelatedViewController.transaction = trans;
    [self.navigationController pushViewController:searchRelatedViewController animated:YES];
}

-(void)cellDeleteBtnPresses:(NSIndexPath *)indexPath{
    NSMutableArray *sectionArray = [_transactionArray objectAtIndex:indexPath.section];
    Transaction *trans = [sectionArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (![trans.recurringType isEqualToString:@"Never"])
    {
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
        actionsheet.tag = 1;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        appDelegate.appActionSheet = actionsheet;
        return;
        
    }
    else
    {
        [appDelegete.epdc deleteTransactionRel:trans];
        
        [self getfetchedResultsController];
        [self setLabelLayoutAndValueByTransactions];
        if([self.fetchRequestResultsController sections]==0)
        {
            _noRecordView.hidden = NO;
        }
        else {
            _noRecordView.hidden = YES;
        }
        
        self.swipCellIndex=nil;
        [self.mytableview reloadData];
    }

    
    

}

-(void)dropBtnPressed:(id)sender{
    NSString *string1=@"";
    NSString *string2=@"";
    
    if(_isShowReconcile)
    {
        string1 =NSLocalizedString(@"VC_ReconcileOff", nil);
    }
    else {
        string1 = NSLocalizedString(@"VC_ReconcileOn", nil);
    }
    if(!_isShowCleared )
    {
        string2 = NSLocalizedString(@"VC_ShowCleared", nil);
    }
    else {
        string2 = NSLocalizedString(@"VC_HideCleared", nil);
    }
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:string1,string2 ,nil];
    actionSheet.tag = 2;
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.appActionSheet = actionSheet;
    [actionSheet showInView:[[UIApplication sharedApplication]keyWindow ]];
}

#pragma mark Table view methods
-(void)clearTranAction:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [(ClearCusBtn *)sender setSelected:![(ClearCusBtn *)sender isSelected]];
    Transaction *t =  [(ClearCusBtn *)sender t] ;
    t.isClear =[NSNumber numberWithBool:[(ClearCusBtn *)sender isSelected]];
    t.dateTime_sync = [NSDate date];

    NSError *errors;
    if (![t.managedObjectContext save:&errors]) {
        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        
    }
//    if (appDelegate.dropbox.drop_account)
//    {
//        [appDelegate.dropbox updateEveryTransactionDataFromLocal:t];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:t];
    }

    for (int i=0; i<[[t.childTransactions allObjects]count]; i++)
    {
        Transaction *childTransaction = [[t.childTransactions allObjects]objectAtIndex:i];
        childTransaction.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&errors];
        
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:childTransaction];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:childTransaction];
        }
    }
    [self setLabelLayoutAndValueByTransactions];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_transactionArray count]==0)
    {
        return 1;
    }
    else
        return [_transactionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_transactionArray count]>0)
    {
        NSMutableArray *sectionArray = [_transactionArray objectAtIndex:section];

        if (section == [_transactionArray count]-1)
        {
            
            return [sectionArray count]+1;

            
        }
        else
            return [sectionArray count];
    }
    else
    {
        return 1;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if ([[self.fetchRequestResultsController sections]count]>0)
     {
         return 22.0;
     }
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([[self.fetchRequestResultsController sections]count]>0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
        headerView.backgroundColor = [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1];
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchRequestResultsController sections]objectAtIndex:section];
        
        UILabel *headetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 22)];
        headetLabel.text = sectionInfo.name;
        [headetLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [headetLabel setTextColor:[UIColor colorWithRed:172.f/255.f green:173.f/255.f blue:170.f/255.f alpha:1]];
        [headetLabel setTextAlignment:NSTextAlignmentLeft];
        headetLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:headetLabel];
        
        UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EXPENSE_SCALE)];
        topLine.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        [headerView addSubview:topLine];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        line.backgroundColor = [UIColor colorWithRed:216/255.f green:216/255.f blue:216/255.f alpha:1];
        [headerView addSubview:line];
        return headerView;
    }
    else
        return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    static NSString *CellIdentifier = @"Cell";
    static NSString *lastCellIdentifier = @"lastcell";
    CustomExpenseCell *cell = (CustomExpenseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    StartBalanceTableViewCell *lastCell = (StartBalanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];

    //有trans的时候
    if ([_transactionArray count]>0)
    {
        NSMutableArray *sectionArray = [_transactionArray objectAtIndex:indexPath.section];
        if (indexPath.section==[_transactionArray count]-1 && indexPath.row == [sectionArray count]) {
            if (lastCell == nil) {
                lastCell = [[StartBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier] ;
                lastCell.accessoryType = UITableViewCellAccessoryNone;
                lastCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            
            lastCell.amountLabel.text =  [appDelegate_iPhone.epnc formatterString:_startAmount];
            return lastCell;
            
        }
        else
        {
            if(cell == nil)
            {
                cell = [[CustomExpenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                // if(isReconcile)
                {
                    [cell.clearBtn addTarget:self action:@selector(clearTranAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                cell.delegate=self;
                float width ;
                if (IS_IPHONE_4 || IS_IPHONE_5)
                {
                    width = 53;
                }
                else
                {
                    width = 63;
                }
                [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
            }
            [self configureTransactionCell:cell atIndexPath:indexPath];
            return cell;
            
        }

    }
    else
    {
        if (lastCell == nil)
        {
            lastCell = [[StartBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier] ;
            lastCell.accessoryType = UITableViewCellAccessoryNone;
            lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        lastCell.amountLabel.text =  [appDelegate_iPhone.epnc formatterString:_startAmount];
        return lastCell;

    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array;
    if (_transactionArray.count)
    {
        array=[_transactionArray objectAtIndex:indexPath.section];
    }
    if (indexPath.row<array.count)
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 53, 0, 0)];
    }
    
    else
    {
        tableView.separatorInset=UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
}
- (void)configureTransactionCell:(CustomExpenseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionArray = [_transactionArray objectAtIndex:indexPath.section];

	Transaction *transcation = [sectionArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //name,amount,category
    if (_isShowReconcile) {
        cell.categoryIcon.hidden = YES;
    }
    else
        cell.categoryIcon.hidden = NO;
 	if([transcation.category.categoryType isEqualToString:@"INCOME"])
	{
        
        if (transcation.payee != nil) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
        cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
        
        //绿色
        [cell.spentLabel setTextColor:[UIColor colorWithRed:28.0/255 green:201.0/255 blue:70.0/255  alpha:1.0]];
        [cell.spentLabel setHighlightedTextColor:[UIColor colorWithRed:28.0/255 green:201.0/255 blue:70.0/255  alpha:1.0]];
        
 	}
	else if([transcation.category.categoryType isEqualToString:@"EXPENSE"]||[transcation.childTransactions count]>0)
	{
        if (transcation.payee != nil) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        
        if ([transcation.childTransactions count]>0)
        {
            cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind.png"];
            NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[transcation.childTransactions allObjects]];
            double childTotalAmount = 0;
            for (int child=0; child<[childArray count]; child ++)
            {
                Transaction *oneChild = [childArray objectAtIndex:child];
                if ([oneChild.state isEqualToString:@"1"])
                {
                    childTotalAmount += [oneChild.amount doubleValue];
                }
            }
            cell.spentLabel.text =  [appDelegete.epnc formatterString:0-childTotalAmount];

        }
        else
        {
            cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
            cell.spentLabel.text =  [appDelegete.epnc formatterString:0-[transcation.amount  doubleValue]];

        }

        //红色
        [cell.spentLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
        [cell.spentLabel setHighlightedTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
 	}
    else
 	{
        if (([self.type isEqualToString:@"All"] || [self.type isEqualToString:@"Uncleared"]) && transcation.expenseAccount!= nil && transcation.incomeAccount != nil) {
            cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
            [cell.spentLabel setTextColor:[UIColor colorWithRed:54.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1.f]];
            [cell.spentLabel setHighlightedTextColor:[UIColor colorWithRed:54.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1.f]];
        }
        else
        {
            if(transcation.expenseAccount == self.account)
            {
                cell.spentLabel.text =  [appDelegete.epnc formatterString:0-[transcation.amount  doubleValue]];
                //红色
                [cell.spentLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
                [cell.spentLabel setHighlightedTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
                
            }
            else    if(transcation.incomeAccount == self.account)
            {
                //绿色
                cell.spentLabel.text =[appDelegete.epnc formatterString:[transcation.amount  doubleValue]];
                [cell.spentLabel setTextColor:[UIColor colorWithRed:28.0/255 green:201.0/255 blue:70.0/255 alpha:1.0]];
                [cell.spentLabel setHighlightedTextColor:[UIColor colorWithRed:28.0/255 green:201.0/255 blue:70.0/255  alpha:1.0]];
                
            }
        }
        
        cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
		cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",transcation.expenseAccount.accName,transcation.incomeAccount.accName ];
        
	}
	
    
    //time
    NSString* time = [_outputFormatter stringFromDate:transcation.dateTime];
	cell.timeLabel.text = time;

    //cycle
    if (![transcation.recurringType isEqualToString:@"Never"]) {
        cell.cycleImage.hidden = NO;
    }
    else
    {
        cell.cycleImage.hidden = YES;
    }
    
    //memo
    if ([transcation.notes length]>0)
    {
        
        cell.memoImage.hidden = NO;
    }
    else
        cell.memoImage.hidden = YES;
    
    if (cell.cycleImage.hidden) {
        cell.memoImage.frame = CGRectMake(cell.cycleImage.frame.origin.x, cell.memoImage.frame.origin.y, cell.memoImage.frame.size.width, cell.memoImage.frame.size.height);
    }
    else
    {
        cell.memoImage.frame = CGRectMake(cell.cycleImage.frame.origin.x+20, cell.memoImage.frame.origin.y, cell.memoImage.frame.size.width, cell.memoImage.frame.size.height);
    }
    
    if (transcation.photoName != nil) {
        cell.photoImage.hidden = NO;
        
    }
    else
        cell.photoImage.hidden = YES;
    
    if (cell.memoImage.hidden) {
        cell.photoImage.frame = CGRectMake(cell.memoImage.frame.origin.x, cell.photoImage.frame.origin.y, cell.photoImage.frame.size.width, cell.photoImage.frame.size.height);
    }
    else
        cell.photoImage.frame = CGRectMake(cell.memoImage.frame.origin.x+20, cell.photoImage.frame.origin.y, cell.photoImage.frame.size.width, cell.photoImage.frame.size.height);
    
    
    
    //cleared
    if(_isShowReconcile)
    {
        
        cell.clearBtn.t=transcation;
        cell.clearBtn.selected = [transcation.isClear boolValue];
        cell.clearBtn.hidden = NO;
        
    }
    else {
        cell.clearBtn.hidden = YES;
        
    }
    
    //running balance
    double runningAmount = [[_runningBalanceArray objectAtIndex:[self getRunningBalanceCount:indexPath.section atRow:indexPath.row]] doubleValue];
    cell.runningBalaceLabel.text = [appDelegete.epnc formatterString:runningAmount];

    
    //设置背景图片
    if ([transcation.isClear doubleValue])
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
        

    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
//        cell.line.frame = CGRectMake(0, cell.line.frame.origin.y,cell.line.frame.size.width, cell.line.frame.size.height);
//
        [cell setBackgroundColor:[UIColor colorWithRed:235/255.f green:248/255.f blue:255/255.f alpha:1]];
    }
    
    if(indexPath.section != [_transactionArray count]-1)
    {
        if (indexPath.row == [sectionArray count]-1)
            cell.line.frame = CGRectMake(0, cell.line.frame.origin.y,cell.line.frame.size.width, cell.line.frame.size.height);
        else
            cell.line.frame = CGRectMake(46, cell.line.frame.origin.y,cell.line.frame.size.width, cell.line.frame.size.height);
    }
    

    
    //HMJ swip cell show delete duplicate
//    if (self.swipCellIndex.section==indexPath.section && self.swipCellIndex.row==indexPath.row && self.swipCellIndex != nil) {
//        [cell layoutShowTwoCellBtns:YES];
//    }
//    else
//        [cell layoutShowTwoCellBtns:NO];
    
    
}

-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}
-(NSInteger)getRunningBalanceCount:(NSInteger)section atRow:(NSInteger)row
{
    
    if (section==0) {
        return row;
    }
    else
    {
        NSMutableArray *sectionArray = [_transactionArray objectAtIndex:(section-1)];
        return ([sectionArray count]+[self getRunningBalanceCount:(section-1) atRow:row]);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.swipCellIndex != nil)
    {
        self.swipCellIndex = nil;
        [_mytableview reloadData];
        return;
    }
    if ([_transactionArray count]>0)
    {
        NSMutableArray *sectionArray = [_transactionArray objectAtIndex:indexPath.section];
        
        if (!(indexPath.section == [_transactionArray count]-1 && indexPath.row== [sectionArray count]))
        {
            Transaction *transactions = [sectionArray objectAtIndex:indexPath.row];
            
            
            self.transactionEditViewController =[[TransactionEditViewController alloc] initWithNibName:@"TransactionEditViewController" bundle:nil];
            
            
            _transactionEditViewController.transaction = transactions;
            if ([transactions.category.categoryType isEqualToString:@"INCOME"])
            {
                _transactionEditViewController.accounts = transactions.incomeAccount;
                
            }
            else if ([transactions.category.categoryType isEqualToString:@"EXPENSE"])
            {
                _transactionEditViewController.accounts = transactions.expenseAccount;
                
            }
            else {
                _transactionEditViewController.fromAccounts = transactions.expenseAccount;
                _transactionEditViewController.toAccounts = transactions.incomeAccount;
            }
            
            _transactionEditViewController.categories = transactions.category;
            _transactionEditViewController.payees = transactions.payee;
            _transactionEditViewController.typeoftodo = @"EDIT";
            UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:_transactionEditViewController];
            [self presentViewController:navigationViewController animated:YES completion:nil];

        }

    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=nil) {
        self.swipCellIndex=nil;
        _mytableview.scrollEnabled = NO;
        [_mytableview reloadData];
        _mytableview.scrollEnabled = YES;
    }
}

#pragma mark DuplicateTimeViewController delegate
-(void)setDuplicateDateDelegate:(NSDate *)date{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (goon)
    {
        NSMutableArray *sectionArray = [_transactionArray objectAtIndex:_swipCellIndex.section];

        Transaction *selectedTrans = [sectionArray objectAtIndex:_swipCellIndex.row];
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
//        oneTrans.transactionType = selectedTrans.transactionType;
        oneTrans.expenseAccount = selectedTrans.expenseAccount;
        oneTrans.incomeAccount = selectedTrans.incomeAccount;
        oneTrans.payee = selectedTrans.payee;
        oneTrans.isClear = selectedTrans.isClear;
        oneTrans.recurringType = selectedTrans.recurringType;
        oneTrans.category = selectedTrans.category;
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
                //--------配置 childTransaction的所有信息
                childTransaction.dateTime = self.duplicateDate;
                childTransaction.amount = oneSelectedChildTransaction.amount;
                //在添加子category的时候，将note也保存进来
                childTransaction.notes=oneSelectedChildTransaction.notes;
                childTransaction.category = oneSelectedChildTransaction.category;
                
//                childTransaction.transactionType = oneSelectedChildTransaction.transactionType;
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
    _swipCellIndex=nil;
    [self resetData];
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (actionSheet.tag ==1) {
        if (buttonIndex==1)
        {
            ;
        }
        else
        {
            id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchRequestResultsController sections]objectAtIndex:self.swipCellIndex.section];
            
            Transaction *trans = [[sectionInfo objects] objectAtIndex:self.swipCellIndex.row];

            
            [appDelegate_iPhone.epdc deleteTransactionRel:trans];
            
            [self getfetchedResultsController];
            [self setLabelLayoutAndValueByTransactions];
            if([self.fetchRequestResultsController sections]==0)
            {
                _noRecordView.hidden = NO;
            }
            else {
                _noRecordView.hidden = YES;
            }
            
            

        }
        self.swipCellIndex=nil;
        [self.mytableview reloadData];
    }
    else if([actionSheet tag] ==2)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if(buttonIndex == 0)
        {
            _isShowReconcile = !_isShowReconcile;
//            [self.mytableview reloadData];
            
            if(_isShowReconcile)
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_REC"];
            }
            [self setLabelLayoutAndValueByTransactions];
            
        }
        else  if(buttonIndex == 1)
        {
            _isShowCleared = !_isShowCleared;
            
            if (!_isShowCleared)
            {
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_HDCL"];

            }
            [self getfetchedResultsController];
            [self setLabelLayoutAndValueByTransactions];

            [self.mytableview reloadData];
            [self.collectionView reloadData];
            
        }
        
        return;
    }

}

#pragma mark fetchedResultsController
- (NSFetchedResultsController *)getfetchedResultsController
{
	_fetchRequestResultsController  = nil ;
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSError * error=nil;
	NSFetchRequest *fetchRequest;
    if ([self.type isEqualToString:@"All"]||[self.type isEqualToString:@"Uncleared"]) {
        fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"getAllTranscations"] copy];
    }
    else{
        NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:self.account,@"incomeAccount",self.account,@"expenseAccount",nil];
        fetchRequest = [[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationByAccount" substitutionVariables:sub]copy];
    }

    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																								managedObjectContext:appDelegate.managedObjectContext
																								  sectionNameKeyPath:@"groupByDateString"
																										   cacheName:@"Root"];

	[aFetchedResultsController performFetch:&error];

    
    
    
    
    
	self.fetchRequestResultsController = aFetchedResultsController;
	return self.fetchRequestResultsController;
}
-(void)initAccountArray
{
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, sortDescriptor2,nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    _accountArray=[NSMutableArray arrayWithArray:array];
}
#pragma mark - UICollectionView
-(void)createCollectionView
{
    [self initAccountArray];

    if (_accountArray.count==1)
    {
        
        accountPage *page=[[accountPage alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-225)/2, 10, 225, 110)];
        Accounts *accountData=[_accountArray objectAtIndex:0];
        [self configureScrollviewPage:page withAccount:accountData];
        [self.view addSubview:page];
    }
    else
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 110) collectionViewLayout:flowLayout];
        
        
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        
        self.collectionView.showsHorizontalScrollIndicator=NO;
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        self.collectionView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        self.view.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        
        [self.view addSubview:self.collectionView];
    }
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(225, 110);
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10000;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID=@"cell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.row>5000)
    {
        _num=_initOrderIndex+(indexPath.row-5000)%_accountArray.count;
    }
    else
    {
        _num=_initOrderIndex-(5000-indexPath.row)%_accountArray.count;
    }
    if (_num<0)
    {
        _num=_accountArray.count+_num;
    }
    if (_num>=_accountArray.count)
    {
        _num=_num-_accountArray.count;
    }
    
    Accounts *accountData=[_accountArray objectAtIndex:_num];

    accountPage *page=[[accountPage alloc]initWithFrame:CGRectMake(0, 0, 225, 110)];
    
    [self configureScrollviewPage:page withAccount:accountData];
    [cell addSubview:page];
    
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offSet=self.collectionView.contentOffset;
    NSInteger page = roundf(offSet.x / 240);
    NSInteger num;
    
    if (page>5000)
    {
        num=_initOrderIndex+(page - 5000)%_accountArray.count;
    }
    else
    {
        num=_initOrderIndex-(5000-page)%_accountArray.count;
    }
    if (num<0)
    {
        num=_accountArray.count+num;
    }
    if (num>=_accountArray.count)
    {
        num=num-_accountArray.count;
    }
    self.account=[_accountArray objectAtIndex:num];
    
    [self.mytableview reloadData];
    [self refleshUI];
    
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = 225 + 15;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page-(SCREEN_WIDTH-225-1)/2;
    return CGPointMake(targetX, offset.y);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

    CGPoint orifinalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    *targetContentOffset = [self  nearestTargetOffsetForOffset:orifinalTargetContentOffset];
}


-(void)configureScrollviewPage:(accountPage *)page withAccount:(Accounts *)account
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    page.accountType.image=[UIImage imageNamed:[NSString stringWithFormat:@"account_iconbg_%@",account.accountType.iconName]];
    page.accountName.text=account.accName;
    page.accountTypeName.text=account.accountType.typeName;
    
    
    //
    double oneSpent = 0;
    double oneIncome = 0;
    double unclearedAmount = 0;
    
    oneIncome = [account.amount doubleValue];
    NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[account.expenseTransactions allObjects]];
    
    for (int j=0; j<[tmpArrays count];j++)
    {
        Transaction *transactions = (Transaction *)[tmpArrays objectAtIndex:j];
        if ([transactions.state isEqualToString:@"0"])
            continue;
        
        
        if (transactions.parTransaction != nil)
        {
            continue;
        }
        if (![transactions.isClear boolValue])
        {
            unclearedAmount += [transactions.amount doubleValue];
        }
        oneSpent += [transactions.amount doubleValue];
        
    }
    
    NSMutableArray *tmpArrays1 = [[NSMutableArray alloc] initWithArray:[account.incomeTransactions allObjects]];
    
    for (int j=0; j<[tmpArrays1 count];j++)
    {
        Transaction *transactions = (Transaction *)[tmpArrays1 objectAtIndex:j];
        if ([transactions.state isEqualToString:@"0"])
            continue;
        
        if (transactions.parTransaction != nil)
        {
            continue;
        }
        if (![transactions.isClear boolValue])
        {
            unclearedAmount += [transactions.amount doubleValue];
        }
        
        oneIncome += [transactions.amount doubleValue];
        
    }
    
    //

    
    //unclearMoney

    NSString *unclearText=[appDelegate.epnc formatterString:unclearedAmount];
    if (unclearedAmount!=0)
    {
        page.unclearMoney.text=[NSString stringWithFormat:@"Uncleared %@",unclearText];
    }
    else
    {
        page.unclearMoney.text=@"";
    }
    
    
    page.totalMoney.text = [appDelegate.epnc formatterString:oneIncome - oneSpent];
    
    //imageView
    UIColor *col1=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:255/255.0 alpha:1];
    UIColor *col2=[UIColor colorWithRed:107/255.0 green:156/255.0 blue:255/255.0 alpha:1];
    UIColor *col3=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
    UIColor *col4=[UIColor colorWithRed:75/255.0 green:211/255.0 blue:177/255.0 alpha:1];
    UIColor *col5=[UIColor colorWithRed:44/255.0 green:204/255.0 blue:81/255.0 alpha:1];
    UIColor *col6=[UIColor colorWithRed:239/255.0 green:185/255.0 blue:53/255.0 alpha:1];
    UIColor *col7=[UIColor colorWithRed:253/255.0 green:133/255.0 blue:68/255.0 alpha:1];
    UIColor *col8=[UIColor colorWithRed:252/255.0 green:83/255.0 blue:96/255.0 alpha:1];
    UIColor *col9=[UIColor colorWithRed:200/255.0 green:115/255.0 blue:239/255.0 alpha:1];
    NSArray *colorArray=@[col1,col2,col3,col4,col5,col6,col7,col8,col9];
    
    
    
    
    NSString *imageName=[NSString stringWithFormat:@"category_bg_%@",account.accountType.iconName];
    UIImage *backImge=[UIImage imageNamed:[NSString customImageName:imageName]];
    NSInteger colorNum=[account.accountColor integerValue];
    if (account.accountColor)
    {
        colorNum=[account.accountColor integerValue];
    }
    else
    {
        if ([account.accountType.typeName isEqualToString:@"Credit Card"])
        {
            colorNum=0;
        }
        else if ([account.accountType.typeName isEqualToString:@"Debit Card"])
        {
            colorNum=2;
        }
        else if ([account.accountType.typeName isEqualToString:@"Asset"])
        {
            colorNum=3;
        }
        else if ([account.accountType.typeName isEqualToString:@"Savings"])
        {
            colorNum=4;
        }
        else if ([account.accountType.typeName isEqualToString:@"Cash"])
        {
            colorNum=5;
        }
        else if ([account.accountType.typeName isEqualToString:@"Checking"])
        {
            colorNum=6;
        }
        else if ([account.accountType.typeName isEqualToString:@"Loan"])
        {
            colorNum=7;
        }
        else if ([account.accountType.typeName isEqualToString:@"Investing"])
        {
            colorNum=8;
        }
        else
        {
            colorNum=1;
        }

    }
    
    CGColorRef color=[[colorArray objectAtIndex:colorNum] CGColor];
    
    UIImage *image=[UIImage imageFromMaskImage:backImge withColor:color];

    page.backgroundImage.image=image;
    
}

#pragma mark view release and dealloc

- (void)didReceiveMemoryWarning
{
    //Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    //Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - SWTableview
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[_mytableview indexPathForCell:cell];
    switch (index)
    {
        case 0:
            [self cellsearchBtnPressed:indexPath];
            break;
        case 1:
            [self cellDuplicateBtnPressed:indexPath];
            _swipCellIndex = indexPath;
            break;
        default:
            [self cellDeleteBtnPresses:indexPath];
            break;
    }
}

#pragma mark - BottomButtonClick

- (IBAction)hideBtnClick:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    _isShowCleared = !_isShowCleared;
    
    if (!_isShowCleared)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_HDCL"];
        
    }
    [self getfetchedResultsController];
    [self setLabelLayoutAndValueByTransactions];
    
    [self.mytableview reloadData];
    
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    [self initBottomView];
}

- (IBAction)reconcileBtnClick:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    _isShowReconcile = !_isShowReconcile;
    //            [self.mytableview reloadData];
    
    if(_isShowReconcile)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_REC"];
    }
    [self.collectionView reloadData];
    [self setLabelLayoutAndValueByTransactions];
    [self initBottomView];
}


@end

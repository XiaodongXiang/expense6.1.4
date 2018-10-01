//
//  AccountsViewController.m
//  PokcetExpense
//
//  Created by ZQ on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "AccountsViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AccountEditViewController.h"
#import "AccountTranscationViewController.h"
#import "BudgetTemplate.h"
#import "BudgetTransfer.h"
#import "SearchCell.h"
#import "AppDelegate_iPhone.h"
#import "AccountCount.h"
#import "EmailViewController.h"
#import "AccountSearchViewController.h"

#import "DropboxSyncTableDefine.h"
#import "OverViewWeekCalenderViewController.h"

#import "BudgetDetailViewController.h"
#import "TestViewController.h"

//category part need
#import "CategoryEditViewController.h"
#import "CategoryCell.h"
#import "AccountCategoryCount.h"

#import "newAcountCell.h"
#import "BHI_Utility.h"
#import "UIViewController+MMDrawerController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

extern NSString *const syncNeedToReflashUI;

@implementation AccountsViewController

#pragma mark  view life cycle
-(void)awakeFromNib
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   
    _hasBeenViewDidLoad =YES;
    [self initMemoryDefine];
    [self initNarBarStyle];
    [self.indicatorView stopAnimating];
    [self addAdsBtn];
}
-(void)addAdsBtn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *purchasePrice = [userDefaults stringForKey:PURCHASE_PRICE];
    
    UIImage *adsImage=[UIImage imageNamed:[NSString customImageName:@"advertisement"]];
    
    
    UIView *adsView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-adsImage.size.height, SCREEN_WIDTH, adsImage.size.height)];
    adsView.backgroundColor=[UIColor colorWithPatternImage:adsImage];
    [self.view addSubview:adsView];
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-80, (adsImage.size.height-30)/2, 80, 30)];
    priceLabel.text=purchasePrice;
    priceLabel.text=purchasePrice;
    priceLabel.textColor=[UIColor whiteColor];
    priceLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [adsView addSubview:priceLabel];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (appdelegate.isPurchased)
    {
        [adsView removeFromSuperview];
    }
    
    UIButton *adsBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adsImage.size.height)];
    [adsBtn addTarget:self action:@selector(adsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [adsView addSubview:adsBtn];
}
-(void)adsBtnClicked:(id)sender
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.inAppPM canMakePurchases])
    {
        [appDelegate.inAppPM  purchaseProUpgrade];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    


    [self resetData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.customerTabbarView.hidden = NO;
//    appDelegate.mainVC.tabBar.hidden = YES;
    appDelegate.adsView.hidden = NO;
    [self resetStyleWithAds];
    
    __weak UIViewController *slf = self;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [self.mm_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        BOOL shouldRecongize=NO;
        if (drawerController.openSide==MMDrawerSideNone && [gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            CGPoint location = [touch locationInView:slf.view];
            shouldRecongize=CGRectContainsPoint(CGRectMake(0, 0, 150, SCREEN_HEIGHT), location);
            [appDelegate.menuVC reloadView];
        }
        
        return shouldRecongize;
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
#pragma mark  ViewDidLoad
/*=========================初始化指针和NavBar========================*/
-(void)initMemoryDefine
{
    _righBtnPressed = NO;
    
    
    _accountArray = [[NSMutableArray alloc] init];
    
    
    
    netWorthAmount = 0;
    unclearedAmount = 0;
    
    
    
    

//    _accountViewL.constant = 0;
//    _categoryViewL.constant = SCREEN_WIDTH;
//    _progressImageViewL.constant = 0;
    
    _accountContainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)initNarBarStyle
{
    
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Account", nil);
    
    //左按钮
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_sider"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/203.0 alpha:1];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -5.f;
    
    
    rightBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightBtn2 setImage:[UIImage imageNamed:@"navigation_edit"] forState:UIControlStateNormal];
    
    [rightBtn2 setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateSelected];
    [rightBtn2 setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
    
    [rightBtn2 setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
    [rightBtn2.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    rightBtn2.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn2.titleLabel setMinimumScaleFactor:0];
    [rightBtn2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn2 addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
    self.navigationItem.rightBarButtonItems = @[flexible2,addBar];
    
    
    
}
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appdelegate.menuVC reloadView];
}

-(void)resetData
{
    self.accountTransactionViewController = nil;
    self.accountSearchViewController = nil;
    self.accountEditViewController = nil;
    [self resetAccountData];
}

-(void)resetAccountData
{
    [self getAccountDataSouce];
    _selAccountIndex =-1;
}


-(void)reflashUI{
    if (self.accountEditViewController != nil) {
        [self.accountEditViewController reflashUI];
    }
    else if (self.accountTransactionViewController != nil){
        [self.accountTransactionViewController refleshUI];
    }
    else if (self.accountSearchViewController != nil){
        [self.accountSearchViewController refleshUI];
    }
    else{
        [self resetData];
    }
}

-(void)resetStyleWithAds
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.isPurchased)
    {
        _accountContainView.frame = CGRectMake(_accountContainView.frame.origin.x, 0, SCREEN_WIDTH, self.view.frame.size.height-50);
    }
    else
    {
        _accountContainView.frame = CGRectMake(_accountContainView.frame.origin.x, 0, SCREEN_WIDTH, self.view.frame.size.height);
    }
}






#pragma mark get data source
- (void)getAccountDataSouce
{
    //get account array
	[_accountArray removeAllObjects];
	NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor2,nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];

    
    
 	double totalSpend = 0;
	double totalIncome =0;
    unclearedAmount=0;
    
	for (int i=0; i<[tmpAccountArray count]; i++)
	{
 		double oneSpent = 0;
		double oneIncome = 0;
 		Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
        
		oneIncome = [tmpAccount.amount doubleValue];
		totalIncome+=[tmpAccount.amount doubleValue];
		NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[tmpAccount.expenseTransactions allObjects]];
        
		for (int j=0; j<[tmpArrays count];j++)
		{
			Transaction *transactions = (Transaction *)[tmpArrays objectAtIndex:j];
			if ([transactions.state isEqualToString:@"0"])
                continue;
            
            
            if (transactions.parTransaction != nil)
            {
                continue;
            }
            
            if (![transactions.isClear boolValue]) {
                unclearedAmount -= [transactions.amount doubleValue];
            }
 			
			oneSpent += [transactions.amount doubleValue];
			totalSpend+=[transactions.amount doubleValue];
			
		}
		
		NSMutableArray *tmpArrays1 = [[NSMutableArray alloc] initWithArray:[tmpAccount.incomeTransactions allObjects]];
		
		for (int j=0; j<[tmpArrays1 count];j++)
		{
			Transaction *transactions = (Transaction *)[tmpArrays1 objectAtIndex:j];
 			if ([transactions.state isEqualToString:@"0"])
                continue;
            
            if (transactions.parTransaction != nil)
            {
                continue;
            }
            
            if (![transactions.isClear boolValue]) {
                unclearedAmount += [transactions.amount doubleValue];
            }
			oneIncome += [transactions.amount doubleValue];
			totalIncome+=[transactions.amount doubleValue];
			
			
		}
		
        //创建account 数组
        AccountCount *ac = [[AccountCount alloc] init];
		ac.accountsItem = tmpAccount ;
		ac.totalExpense  = oneSpent;
        ac.totalIncome = oneIncome;
        ac.totalBalance = oneIncome-oneSpent;
 		[_accountArray addObject:ac];
 	}
    
    //设置net worth,uncleared worth
    netWorthAmount = totalIncome - totalSpend;
    [self.mytableview reloadData];
}






#pragma mark  button action
-(void)handleGesture:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)addBtnPressed:(id)sender
{
    
    //外部需要的时候，需要用self指针指一下，不然会崩溃。
    self.accountEditViewController =[[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:nil];
    self.accountEditViewController.typeOftodo = @"ADD";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.accountEditViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];

}

-(void)rightBtnPressed:(UIButton *)sender
{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -7;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -7.f;
    sender.selected = !sender.selected;
    
    //add
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (sender.selected)
    {
        _righBtnPressed = YES;
        
        
        
        [addBtn setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
        [addBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addBar =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
        self.navigationItem.leftBarButtonItems = @[flexible,addBar];
        [_mytableview setEditing:YES animated:YES];
        [_mytableview performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
    else
    {
        _righBtnPressed = NO;

        UIButton *menuBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [menuBtn setImage:[UIImage imageNamed:@"navigation_sider"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuBtn];
        self.navigationItem.leftBarButtonItems=@[flexible,left];
        
        [_mytableview setEditing:NO animated:YES];
        [_mytableview performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}


-(void)celleditBtnPressed:(UIButton *)sender{
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:sender.tag];
    self.accountEditViewController =[[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:nil];
	self.accountEditViewController.accounts = ac.accountsItem;
	self.accountEditViewController.typeOftodo = @"EDIT";
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:self.accountEditViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

-(void)cellDeleteBtnPressed:(UIButton *)sender{
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:sender.tag];
    Accounts *tmpAccount = [ac accountsItem];
    _deleteIndex =sender.tag;
    
    NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete its transactions. Are you sure want to delete it?", nil)];

    NSString *searchString = @"%@";
    //range是这个字符串的位置与长度
    NSRange range = [string1 rangeOfString:searchString];
    [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpAccount.accName];
    NSString *msg = string1;
    
    UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                 initWithTitle:msg
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                 destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil)
                                 otherButtonTitles:nil,
                                 nil];
    actionSheet.tag = 1;
    [actionSheet showInView:[[UIApplication sharedApplication]keyWindow ]];
    PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
    appDelegate.appActionSheet = actionSheet;
    
}


#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_accountArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5)
    {
        return 75;
    }
    else if (IS_IPHONE_6)
    {
        return 75;
    }
    else
        return 81;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:_mytableview])
    {
        //create a nib
        static NSString *CellIdentifier = @"Cell";

        newAcountCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"newAcountCell" owner:self options:nil]lastObject];
            
            cell.deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 24, 30, 30)];
            [cell addSubview:cell.deleteBtn];
            cell.deleteBtn.alpha=0;
            cell.deleteBtn.tag=indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(cellDeleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
     
            //
            float height;
            if (IS_IPHONE_6PLUS)
            {
                height=82;
            }
            else
            {
                height=75;
            }
            cell.detailButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-52*2, 0, 52, height)];
            [cell.detailButton setImage:[UIImage imageNamed:@"account_edit_edit"] forState:UIControlStateNormal];
            [cell addSubview:cell.detailButton];
            cell.detailButton.alpha=0;
            cell.detailButton.tag=indexPath.row;
            [cell.detailButton addTarget:self action:@selector(celleditBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [self configureNewAccountCell:cell atIndexIndexPath:indexPath];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    return style;
}


//-------------配置Account cell
-(void)configureNewAccountCell:(newAcountCell *)cell atIndexIndexPath:(NSIndexPath *)indexPath
{
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:indexPath.row];
    cell.accountIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"account_iconbg_%@",ac.accountsItem.accountType.iconName]];
    cell.typeLabel.text=ac.accountsItem.accountType.typeName;
    cell.nameLabel.text=ac.accountsItem.accName;
    
    
    
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
    
    Accounts *account=ac.accountsItem;
    

    NSString *imageName=[NSString stringWithFormat:@"account_bg_%@",ac.accountsItem.accountType.iconName];
    
    UIImage *backImge=[UIImage imageNamed:[NSString customImageName:imageName]];
    
    NSInteger colorNum;
    if (account.accountColor!=nil)
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
    
    cell.backgroundImage.image=image;
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];


    double balanceAmount=ac.defaultAmount+ac.totalIncome-ac.totalExpense;
    
    if (balanceAmount>999999999 || balanceAmount<-999999999)
    {
        cell.balanceLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:balanceAmount/1000]];
    }
    else
    {
        cell.balanceLabel.text = [appDelegate.epnc formatterString:balanceAmount];
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _mytableview)
    {
        self.accountTransactionViewController =[[AccountTranscationViewController alloc] initWithNibName:@"AccountTranscationViewController" bundle:nil];
        //----???????为什么不直接付给他Account?
        _selAccountIndex = indexPath.row;
        AccountCount *oneAccount = [_accountArray objectAtIndex:indexPath.row];
        self.accountTransactionViewController.account = oneAccount.accountsItem;
        self.accountTransactionViewController.accountsViewController  = self;
        //隐藏tabbar
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        self.accountTransactionViewController.hidesBottomBarWhenPushed = TRUE;
        appDelegate.customerTabbarView.hidden = YES;
        self.accountTransactionViewController.initOrderIndex = indexPath.row;
        [self.navigationController pushViewController:self.accountTransactionViewController animated:YES];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_mytableview)
    {
        //return NO就不会有动画了
        return YES;
    }
    else
        return NO;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView.editing)
    {
        
        rightBtn2.selected = YES;
        if (_righBtnPressed)
        {
            return YES;
        }
        else
            return NO;
    }
    else
    {
        rightBtn2.selected = NO;
        return YES;
    }

}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mytableview)
    {
        if ([_accountArray count]>0) {
            AccountCell *cell = (AccountCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.blanceLabel.alpha == 1.0)
            {
                [cell.blanceLabel setAlpha:0.0];
            }
        }
    }
    

}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mytableview)
    {
        if ([_accountArray count]>0) {
            AccountCell *cell = (AccountCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.blanceLabel.alpha == 0)
            {
                [cell.blanceLabel setAlpha:1.0];
            }
        }
    }
}
//当移动一个category去某一个cell的时候，就要将array中的数据顺序进行颠倒，并且重新保存数据库

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    if (tableView == _mytableview)
    {
        //首先保存数据库
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        
        
        //首先保存数据库
        AccountCount *oneAccount = [_accountArray objectAtIndex:sourceIndexPath.row];
        
        [_accountArray  removeObjectAtIndex:sourceIndexPath.row];
        [_accountArray insertObject:oneAccount atIndex:destinationIndexPath.row];
        for (int i=0; i<[_accountArray count]; i++)
        {
            AccountCount *oneA = [_accountArray objectAtIndex:i];
            oneA.accountsItem.orderIndex = [NSNumber numberWithLong: i];
            oneA.accountsItem.dateTime_sync = [NSDate date];
            [appDelegate.managedObjectContext save:&error];
        }
        
        //sync
//        if (appDelegate.dropbox.drop_account.linked) {
//   
//            
//            for (int i=0; i<[_accountArray count]; i++) {
//                AccountCount *oneA = [_accountArray objectAtIndex:i];
//                [appDelegate.dropbox updateEveryAccountDataFromLocal:oneA.accountsItem];
//            }
//            
//        }
        if ([PFUser currentUser])
        {
            for (int i=0; i<_accountArray.count; i++) {
                AccountCount *oneA=[_accountArray objectAtIndex:i];
                [[ParseDBManager sharedManager]updateAccountFromLocal:oneA.accountsItem];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        if (tableView == _mytableview)
        {
            AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:indexPath.row];
            Accounts *tmpAccount = [ac accountsItem];
            _deleteIndex =indexPath.row;
            
            NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete its transactions. Are you sure want to delete it?", nil)];
            
            NSString *searchString = @"%@";
            //range是这个字符串的位置与长度
            NSRange range = [string1 rangeOfString:searchString];
            [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpAccount.accName];
            NSString *msg = string1;
            
            UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                         initWithTitle:msg
                                         delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil)
                                         otherButtonTitles:nil,
                                         nil];
            [actionSheet showInView:[[UIApplication sharedApplication]keyWindow ]];
            actionSheet.tag = 1;
            PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
            appDelegate.appActionSheet = actionSheet;
        }
	}
    
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if(buttonIndex == 1)
            return;
        AccountCount *ac = [_accountArray objectAtIndex:_deleteIndex];
        if(ac.accountsItem == nil) return;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.epdc deleteAccountRel:ac.accountsItem];
        [self getAccountDataSouce];
        [self.mytableview reloadData];
    }
}

#pragma mark Btn Action
-(void)netWorthBtnPressed:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"06_ACCP_NETW"];

    self.accountTransactionViewController = [[AccountTranscationViewController alloc]initWithNibName:@"AccountTranscationViewController" bundle:nil];
    self.accountTransactionViewController.type = @"All";
    [self.navigationController pushViewController:self.accountTransactionViewController animated:YES];
}

-(void)unclearedBtnPressed:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"06_ACCP_UNCL"];
    

    self.accountTransactionViewController = [[AccountTranscationViewController alloc]initWithNibName:@"AccountTranscationViewController" bundle:nil];
    self.accountTransactionViewController.type = @"Uncleared";
    [self.navigationController pushViewController:_accountTransactionViewController animated:YES];
}









- (void)didReceiveMemoryWarning {
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
#pragma mark 
#pragma mark Formatter



@end

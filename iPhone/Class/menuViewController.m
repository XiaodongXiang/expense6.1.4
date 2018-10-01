//
//  menuViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/14.
//
//

#import "menuViewController.h"
#import "menuTableViewCell.h"

#import "OverViewWeekCalenderViewController.h"
#import "AccountsViewController.h"
#import "BudgetViewController.h"
#import "BillsViewController.h"
#import "SummaryViewController_iPhone.h"
#import "UIViewController+MMDrawerController.h"
#import "CashFlowViewController.h"
#import "headerView.h"
#import "footerView.h"

#import "avatorImageView.h"
#import "FSMediaPicker.h"
#import "NetWorthViewController.h"
#import "AccountSearchViewController.h"
#import "AppDelegate_iPhone.h"
#import "BudgetCountClass.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"

#import "NSStringAdditions.h"

@interface menuViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSMediaPickerDelegate>
{
    UITableView *_tableView;
    UIButton *_avatar;
    NSString        *budgetRepeatType;
    NSMutableArray *budgetArray;
    
    UIImageView *syncIcon;
    
    
    headerView *header;
}

@end

@implementation menuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.view.frame=CGRectMake(0, 20, MENU_WIDTH, SCREEN_HEIGHT-20);
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, MENU_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=NO;
    _tableView.backgroundColor=[UIColor colorWithRed:28/255.0 green:44/255.0 blue:52/255.0 alpha:1];
    [self.view addSubview:_tableView];
    _tableView.bounces=NO;
}
#pragma mark - UITableView方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(menuTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"CellReuseID";
    menuTableViewCell *cell=(menuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"menuTableViewCell" owner:self options:nil]lastObject];
    }
    
    
    NSArray *array=@[NSLocalizedString(@"VC_Calendar", nil),NSLocalizedString(@"VC_Account", nil),NSLocalizedString(@"VC_Budget", nil),NSLocalizedString(@"VC_Chart", nil),NSLocalizedString(@"VC_Summary", nil),NSLocalizedString(@"VC_Category", nil),NSLocalizedString(@"VC_CashFlow", nil),NSLocalizedString(@"VC_NetWorth", nil),NSLocalizedString(@"VC_Bills", nil)];
    cell.cellLabel.text=[array objectAtIndex:indexPath.row];
    
    NSArray *array1=@[@"calendar",@"account",@"budget",@"chart",@"summary",@"category",@"cashflow",@"networth",@"bill"];
    NSString *imageName=[NSString stringWithFormat:@"siderbar_%@",[array1 objectAtIndex:indexPath.row]];
    [cell.cellImage setImage:[UIImage imageNamed:imageName]];
    
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7)
    {
        cell.imageToLeft.constant=52;
        [cell.cellTopLine removeFromSuperview];
    }
    if (indexPath.row != 8)
    {
        [cell.cellBottomLine removeFromSuperview];
    }
    if (indexPath.row == 3)
    {
        [cell.arrow removeFromSuperview];
    }
    cell.topLineWidth.constant = MENU_WIDTH-15;
    cell.bottomLineWidth.constant = MENU_WIDTH-15;
    
    if (indexPath.row==3)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        menuTableViewCell *cell=(menuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *navigationController=[self.navigationControllerArray objectAtIndex:indexPath.row];
    
    if (![navigationController isKindOfClass:[UINavigationController class]])
    {
        
        switch (indexPath.row)
        {
            case 0:
                _selectedViewController=(UIViewController *)[[OverViewWeekCalenderViewController alloc]init];
                break;
            case 1:
                _selectedViewController=(UIViewController *)[[AccountsViewController alloc]init];
                break;
            case 2:
                _selectedViewController=(UIViewController *)[[BudgetViewController alloc]init];
                break;
            case 3:
                return indexPath;
                break;
            case 4:
                _selectedViewController=[(UIViewController *)[SummaryViewController_iPhone alloc]init];
                break;
            case 5:
                _selectedViewController=[(UIViewController *)[ExpenseViewController alloc]init];
                break;
            case 6:
                _selectedViewController=[(UIViewController *)[CashFlowViewController alloc]init];
                break;
            case 7:
                _selectedViewController=[(UIViewController *)[NetWorthViewController alloc]init];
                break;
            case 8:
                _selectedViewController = [[BillsViewController alloc]initWithNibName:@"BillsViewController" bundle:nil];
                break;
            default:
                break;
        }
        navigationController=(UINavigationController *)[[UINavigationController alloc]initWithRootViewController:_selectedViewController];
        [self.navigationControllerArray replaceObjectAtIndex:indexPath.row withObject:_selectedViewController];
        
    }
    [self.mm_drawerController setCenterViewController:(UINavigationController *)navigationController withCloseAnimation:YES completion:nil];
    return indexPath;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IS_IPHONE_5)
    {
        return 99;
    }
    else if (IS_IPHONE_4)
    {
        return 70;
    }
    else if (IS_IPHONE_6)
    {
        return 115;
    }
    else
    {
        return 115;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float headerHeight;
    if (IS_IPHONE_5)
    {
        headerHeight=99;
    }
    else if(IS_IPHONE_4)
    {
        headerHeight=39;
    }
    else if (IS_IPHONE_6)
    {
        headerHeight= 115;
    }
    else
    {
        headerHeight= 115;
    }
    return SCREEN_HEIGHT-20-44*9-headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_4)
    {
        return 39;
    }
    else
    {
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    header=[[[NSBundle mainBundle]loadNibNamed:@"headerView" owner:self options:nil]lastObject];
    
    float headerHeight;
    float userNameTop;
    float avatarTop;
    if (IS_IPHONE_5)
    {
        headerHeight=99;
        userNameTop=25;
        avatarTop=24;
    }
    else if (IS_IPHONE_4)
    {
        headerHeight=70;
        userNameTop=8;
        avatarTop=7;
    }
    else if (IS_IPHONE_6)
    {
        headerHeight=115;
        userNameTop=42;
        avatarTop=40;
    }
    else
    {
        headerHeight=115;
        userNameTop=42;
        avatarTop=40;
    }
    
    header.frame=CGRectMake(0, 0, MENU_WIDTH, headerHeight);
    header.userNameToTop.constant=userNameTop;
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
    UIImage *image=[[UIImage alloc]initWithData:imageData];
    if (imageData==nil)
    {
        image=[UIImage imageNamed:@"siderbar_user"];
    }
    _avatar=[[UIButton alloc]initWithFrame:CGRectMake(15, avatarTop, 57, 57)];
    [_avatar setImage:image forState:UIControlStateNormal];
    [_avatar addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
    
    
    [header addSubview:_avatar];
    
    UIImageView *circle=[[UIImageView alloc]initWithFrame:CGRectMake(15, avatarTop, 57, 57)];
    circle.image=[UIImage imageNamed:@"siderbar_circle"];
    [header addSubview:circle];
    
    
    [self getBudgetLeft];
    [self getNetWorthData];

    AppDelegate_iPhone *appdelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    header.usernameLabel.text=[PFUser currentUser].username;
    header.netWorth.text=NSLocalizedString(@"VC_NetWorth", nil);
    header.budgetLabel.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"VC_Left", nil)];
    header.budgetleftLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    header.networthLabel.font=[appdelegate.epnc getMoneyFont_exceptInCalendar_WithSize:12];
    
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footerView *footer=[[[NSBundle mainBundle]loadNibNamed:@"footerView" owner:self options:nil]lastObject];
    float headerHeight;
    float cellHeight;
    if (IS_IPHONE_5)
    {
        headerHeight=99;
        cellHeight=44;
    }
    else if (IS_IPHONE_4)
    {
        headerHeight=70;
        cellHeight=39;
    }
    else if (IS_IPHONE_6)
    {
        headerHeight= 115;
        cellHeight=44;
    }
    else
    {
        headerHeight= 115;
        cellHeight=44;
    }
    
    footer.frame=CGRectMake(0, 0, MENU_WIDTH, SCREEN_HEIGHT-20-cellHeight*9-headerHeight);
    
    float btnWidth;
    float toBottom;
    float lineHeight;
    float lineToBottom;
    float syncIconToLeft;
    float syncIconToBottom;
    if (IS_IPHONE_5)
    {
        btnWidth=90;
        toBottom=1;
        lineHeight=20;
        lineToBottom=5;
        syncIconToLeft=14;
        syncIconToBottom=9;
    }
    else if (IS_IPHONE_4)
    {
        btnWidth=90;
        toBottom=1;
        lineHeight=20;
        lineToBottom=5;
        syncIconToLeft=14;
        syncIconToBottom=9;

    }
    else if (IS_IPHONE_6)
    {
        btnWidth=102;
        toBottom=8;
        lineHeight=20;
        lineToBottom=12;
        syncIconToLeft=15;
        syncIconToBottom=16;
    }
    else if (IS_IPHONE_6PLUS)
    {
        btnWidth=115;
        toBottom=8;
        lineHeight=20;
        lineToBottom=13;
        syncIconToLeft=15;
        syncIconToBottom=15;
    }
    
    footer.settingBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,footer.frame.size.height-toBottom-30 , btnWidth, 30)];
    [footer.settingBtn setImage:[UIImage imageNamed:[NSString customImageName:@"siderbar_setting"]] forState:UIControlStateNormal];
    [footer addSubview:footer.settingBtn];
    
    footer.searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(footer.frame.size.width-btnWidth, footer.frame.size.height-toBottom-30, btnWidth, 30)];
    [footer.searchBtn setImage:[UIImage imageNamed:[NSString customImageName:@"siderbar_search"]] forState:UIControlStateNormal];
    [footer addSubview:footer.searchBtn];
    
    footer.syncBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnWidth+1, footer.frame.size.height-toBottom-30, btnWidth, 30)];
    [footer.syncBtn setImage:[UIImage imageNamed:[NSString customImageName:@"siderbar_sync"]] forState:UIControlStateNormal];
    [footer addSubview:footer.syncBtn];
    [footer.syncBtn addTarget:self action:@selector(sync) forControlEvents:UIControlEventTouchUpInside];
    
    syncIcon=[[UIImageView alloc]initWithFrame:CGRectMake(btnWidth+1+syncIconToLeft, footer.frame.size.height-syncIconToBottom-16, 16, 16)];
    syncIcon.image=[UIImage imageNamed:@"siderbar_sync_icon"];
    [footer addSubview:syncIcon];
    
    UIView *leftLine=[[UIView alloc]initWithFrame:CGRectMake(btnWidth, footer.frame.size.height-lineHeight-lineToBottom, 1/SCREEN_SCALE, lineHeight)];
    leftLine.backgroundColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [footer addSubview:leftLine];
    
    UIView *rightLine=[[UIView alloc]initWithFrame:CGRectMake(footer.frame.size.width-btnWidth-1, footer.frame.size.height-lineHeight-lineToBottom, 1/SCREEN_SCALE, lineHeight)];
    rightLine.backgroundColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
    [footer addSubview:rightLine];
    
    
    [footer.settingBtn addTarget:self action:@selector(pushSettingView) forControlEvents:UIControlEventTouchUpInside];
    [footer.searchBtn addTarget:self action:@selector(pushSearchView) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

#pragma mark - 数据处理
-(void)getNetWorthData
{
    //初始化数据
    float expense=0;
    float income=0;
    float uncleared=0;
    float cleared=0;
    float netWorth=0;
    
    //获取transaction数据
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    request.entity=desc;
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *tmpArray=[appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *transactionArray=[NSMutableArray arrayWithArray:tmpArray];
    
    //获取account数据
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicateAccount =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicateAccount];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor2,nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *tmpAccounArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *accountArray=[NSMutableArray arrayWithArray:tmpAccounArray];
    
    //分析transaction数据
    for (Transaction *transaction in transactionArray)
    {
        

            if ([transaction.isClear boolValue])
            {
                if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
                {
                    income+=[transaction.amount floatValue];
                    cleared+=[transaction.amount floatValue];
                }
                else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
                {
                    expense-=[transaction.amount floatValue];
                    cleared-=[transaction.amount floatValue];
                }
            }
            else
            {
                if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
                {
                    uncleared+=[transaction.amount floatValue];
                }
                else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
                {
                    uncleared-=[transaction.amount floatValue];
                }
            }
            
    }
    
    float accountAmount=0;
    
    for (Accounts *accounts in accountArray)
    {
        accountAmount+=[accounts.amount floatValue];
    }
    netWorth=accountAmount+cleared+uncleared;
    
    header.networthLabel.text=[appDelegate.epnc formatterString:netWorth];
}
-(void)getBudgetLeft
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSDate *startDate;
    NSDate *endDate;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tmpBudgetString = [userDefault stringForKey:@"BudgetRepeatType"];
    if ([tmpBudgetString isEqualToString:@"Weekly"])
    {
        budgetRepeatType = @"Weekly";
    }
    else
        budgetRepeatType = @"Monthly";
    if([budgetRepeatType isEqualToString:@"Weekly"])
    {
        startDate = [appDelegate_iphone.epnc getStartDateWithDateType:1 fromDate:[NSDate date]];
        endDate = [appDelegate_iphone.epnc getEndDateDateType:1 withStartDate:startDate];
    }
    else
    {
        startDate = [appDelegate_iphone.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
        endDate = [appDelegate_iphone.epnc getEndDateDateType:2 withStartDate:startDate];
    }
    
    NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];
    
    
    double totalBudgetAmount = 0;
    double totalExpense = 0;
    double totalRollover = 0;
    
    double totalIncome = 0;
    BudgetCountClass *bcc;
    
    NSDictionary *subs;
    for (int i = 0; i<[allBudgetArray count];i++)
    {
        BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
        bcc = [[BudgetCountClass alloc] init];
        bcc.bt = budgetTemplate;
        bcc.btTotalExpense =0;
        bcc.btTotalIncome =0;
        BudgetItem *budgetTemplateCurrentItem =[[budgetTemplate.budgetItems allObjects] lastObject];
        
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",startDate,@"startDate",endDate,@"endDate", nil];
            
            
            //获取该budgetTemplate下 该段时间内的transaction,统计
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"] && [t.state isEqualToString:@"1"])
                {
                    bcc.btTotalExpense +=[t.amount doubleValue];
                    totalExpense +=[t.amount doubleValue];
                }
                else if([t.category.categoryType isEqualToString:@"INCOME"] && [t.state isEqualToString:@"1"]){
                    bcc.btTotalIncome +=[t.amount doubleValue];
                    totalIncome +=[t.amount doubleValue];
                }
                
            }
            
            //获取该budgetTemplate下 该段时间内的transfer,统计
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
            for (int j = 0;j<[tmpArray1 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:endDate]<=0 && [bttmp.state isEqualToString:@"1"])
                    bcc.btTotalExpense +=[bttmp.amount doubleValue];
                //totalExpense +=[bttmp.amount doubleValue];
                
            }
            
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
            for (int j = 0; j<[tmpArray2 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:endDate]<=0 && [bttmp.state isEqualToString:@"1"])
                    bcc.btTotalIncome +=[bttmp.amount doubleValue];
                //totalIncome +=[bttmp.amount doubleValue];
                
            }
            
            ////////////////////获取子类category的交易
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound)
            {
                
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",startDate,@"startDate",endDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                bcc.btTotalExpense +=[t.amount doubleValue];
                                totalExpense +=[t.amount doubleValue];
                            }
                            else if([t.category.categoryType isEqualToString:@"INCOME"])
                            {
                                bcc.btTotalIncome +=[t.amount doubleValue];
                                totalIncome +=[t.amount doubleValue];
                            }
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
        
        [budgetArray addObject:bcc];
        
    }
    
    
    double totalblance = totalBudgetAmount+totalRollover + totalIncome;
    
    if (totalblance>=totalExpense)
    {
        header.budgetLabel.text=NSLocalizedString(@"VC_Budget", nil);
        header.budgetleftLabel.text=[appDelegate_iphone.epnc formatterString: totalblance-totalExpense];
    }
    else
    {
        header.budgetLabel.text=NSLocalizedString(@"VC_Budget", nil);
        header.budgetleftLabel.text=[appDelegate_iphone.epnc formatterString:totalExpense-totalblance];
        
    }
    

}
#pragma mark - 响应方法
//更新header数据
-(void)reloadView
{
    [self getNetWorthData];
    [self getBudgetLeft];
}
#pragma mark - 响应事件
-(void)sync
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ParseDBManager sharedManager]dataSyncWithServer];
    });
}
-(void)startAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = NO;
        rotationAnimation.repeatCount = NSIntegerMax;
        
        [syncIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
-(void)syncAnimationStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [syncIcon.layer removeAllAnimations];
        
        NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        [center removeObserver:self];
    });    
}
-(void)changeAvatar
{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = (FSMediaType)0;
    mediaPicker.editMode = (FSEditMode)0;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];
}
-(void)pushSettingView
{
    SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)pushSearchView
{
    AccountSearchViewController *searchVC = [[AccountSearchViewController alloc]initWithNibName:@"AccountSearchViewController" bundle:nil];
    [self presentViewController:searchVC  animated:YES completion:nil];
}
#pragma mark - FSMediaPicker Delegate
-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [_avatar setImage:mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage forState:UIControlStateNormal];
    
    UIImage *avatarImage=mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage;
//    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    
    NSData *imageData=UIImageJPEGRepresentation(avatarImage, 0.5);
    [imageData writeToFile:imageFile atomically:YES];
    
    PFUser *user=[PFUser currentUser];
    PFFile *photo=[PFFile fileWithName:[NSString stringWithFormat:@"avatar.jpg"] data:imageData];
    user[@"avatar"]=photo;
    [user saveInBackground];
}
-(void)setAvatarImage:(UIImage *)image
{
    [_avatar setImage:image forState:UIControlStateNormal];
}
@end

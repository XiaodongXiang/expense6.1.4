//
//  iPad_GeneralViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-10-14.
//
//

#import "iPad_GeneralViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_AccountPickerViewController.h"
#import "iPad_OverViewViewController.h"
#import "ipad_BillsViewController.h"
#import "AppDelegate_iPad.h"
#import "ipad_TranscationCategorySelectViewController.H"
#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface iPad_GeneralViewController ()

@end

@implementation iPad_GeneralViewController
@synthesize accountLabelText,categoryLabelText,amountLabelText,weeksLabelText,notificationLabelText,accountLabel,categoryLabel,leftBtn,spentBtn,sunBtn,monBtn,notificationSwitch;
@synthesize myTableView,accountCell,categoryCell,amountCell,weeksCell,notificationCell;
@synthesize defaultAccount,defaultExpenseCategory,defaultIncomeCategory;

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPoint];
    [self initNavStyle];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setContex];
    [myTableView reloadData];
}

-(void)initPoint
{
    accountLabelText.text = NSLocalizedString(@"VC_Default Account", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Default Category", nil);
    amountLabelText.text = NSLocalizedString(@"VC_Budget", nil);
    weeksLabelText.text = NSLocalizedString(@"VC_Week Starts From", nil);
    notificationLabelText.text = NSLocalizedString(@"VC_Notification", nil);
    
    [leftBtn setTitle:NSLocalizedString(@"VC_Left", nil) forState:UIControlStateNormal];
    [leftBtn setTitle:NSLocalizedString(@"VC_Left", nil) forState:UIControlStateSelected];
    [spentBtn setTitle:NSLocalizedString(@"VC_Spent", nil) forState:UIControlStateNormal];
    [spentBtn setTitle:NSLocalizedString(@"VC_Spent", nil) forState:UIControlStateSelected];
    spentBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [spentBtn.titleLabel setMinimumScaleFactor:0];
    leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [leftBtn.titleLabel setMinimumScaleFactor:0];
    
    [sunBtn setTitle:NSLocalizedString(@"VC_Sunday", nil) forState:UIControlStateNormal];
    [sunBtn setTitle:NSLocalizedString(@"VC_Sunday", nil) forState:UIControlStateSelected];
    [monBtn setTitle:NSLocalizedString(@"VC_Monday", nil) forState:UIControlStateNormal];
    [monBtn setTitle:NSLocalizedString(@"VC_Monday", nil) forState:UIControlStateSelected];
    
    sunBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [sunBtn.titleLabel setMinimumScaleFactor:0];
    monBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [monBtn.titleLabel setMinimumScaleFactor:0];
    
    //将setting中的others19作为budget的偏好设置
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.settings.others19 isEqualToString:@"spent"])
    {
        spentBtn.selected = YES;
        leftBtn.selected = NO;
    }
    else
    {
        spentBtn.selected = NO;
        leftBtn.selected = YES;
    }
    
    if ([appDelegate.settings.others16 isEqualToString:@"2"])
    {
        monBtn.selected = YES;
        sunBtn.selected = NO;
    }
    else
    {
        monBtn.selected = NO;
        sunBtn.selected = YES;
    }
    [spentBtn addTarget:self action:@selector(budgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(budgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sunBtn addTarget:self action:@selector(weekDayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [monBtn addTarget:self action:@selector(weekDayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [notificationSwitch addTarget:self action:@selector(notificationSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];

    //默认是打开提醒
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"ReminderNotification"])
        notificationSwitch.on = YES;
    else
        notificationSwitch.on = NO;
    [self getDataStore];
    
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(0, 0, 80, 30);
    [backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
   	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_General", nil);
    self.navigationItem.titleView = titleLabel;
}

-(void)getDataStore
{
    //get default account
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];
    
    
    for (int i=0; i<[tmpAccountArray count]; i++)
    {
        Accounts *oneAccounts = [tmpAccountArray objectAtIndex:i];
        if ([oneAccounts.others isEqualToString:@"Default"])
        {
            defaultAccount = oneAccounts;
            break;
        }
    }
    if (!defaultAccount && [tmpAccountArray count]>0)
    {
        defaultAccount = [tmpAccountArray firstObject];
    }
    
    //get expense/income category
    NSString    *fetchExpense = @"fetchCategoryByExpenseType";
    NSString    *fetchIncome = @"fetchCategoryByIncomeType";
    
    NSDictionary *subs = [[NSDictionary alloc]init];
    
    NSFetchRequest *fetchRequestExpense = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchExpense substitutionVariables:subs];
    NSFetchRequest *fetchRequestIncome = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchIncome substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequestExpense setSortDescriptors:sortDescriptors];
    [fetchRequestIncome setSortDescriptors:sortDescriptors];
    
    NSArray *objectsExpense = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestExpense error:&error];
    NSArray *objectsIncome = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestIncome error:&error];
    
    NSMutableArray *tmpCategoryArrayExpense  = [[NSMutableArray alloc] initWithArray:objectsExpense];
    NSMutableArray *tmpCategoryArrayIncome  = [[NSMutableArray alloc] initWithArray:objectsIncome];
    
    
    //获取默认的category,如果不存在的话就设置第一个category的默认类别
    for (Category *tmpCategory in tmpCategoryArrayExpense)
    {
        if([tmpCategory.isDefault boolValue])
        {
            defaultExpenseCategory = tmpCategory;
            break;
        }
    }
    if (!defaultExpenseCategory && [tmpCategoryArrayExpense count]>0)
    {
        defaultExpenseCategory = [tmpCategoryArrayExpense firstObject];
        defaultExpenseCategory.isDefault = [NSNumber numberWithBool:YES];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryCategoryDataFromLocal:defaultExpenseCategory];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateCategoryFromLocal:defaultExpenseCategory];
        }
    }
    
    for (Category *tmpCategory in tmpCategoryArrayIncome)
    {
        if([tmpCategory.isDefault boolValue])
        {
            defaultIncomeCategory = tmpCategory;
            break;
        }
    }
    if (!defaultIncomeCategory && [tmpCategoryArrayIncome count]>0)
    {
        defaultIncomeCategory = [tmpCategoryArrayIncome firstObject];
        defaultIncomeCategory.isDefault = [NSNumber numberWithBool:YES];
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryCategoryDataFromLocal:defaultIncomeCategory];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateCategoryFromLocal:defaultExpenseCategory];
        }
    }
    
}

-(void)setContex
{
    if (defaultAccount)
    {
        accountLabel.text = defaultAccount.accName;
    }
    else
        accountLabel.text = NSLocalizedString(@"VC_None", nil);
    
    NSString *defaultExpenseString = defaultExpenseCategory?defaultExpenseCategory.categoryName:NSLocalizedString(@"VC_None", nil);
    NSString *defaultIncomeString = defaultIncomeCategory?defaultIncomeCategory.categoryName:NSLocalizedString(@"VC_None", nil);
    
    categoryLabel.text = [NSString stringWithFormat:@"%@, %@",defaultExpenseString,defaultIncomeString];
}


-(void)budgetBtnPressed:(UIButton *)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (sender.tag==1 && !leftBtn.selected) {
        leftBtn.selected = YES;
        spentBtn.selected = NO;
        appDelegate.settings.others19 = @"left";
        [appDelegate.managedObjectContext save:&error];

        [appDelegate.epnc setFlurryEvent_WithIdentify:@"10_BGT_LFT"];

        
    }
    else  if(sender.tag==2 && !spentBtn.selected){
        spentBtn.selected = YES;
        leftBtn.selected = NO;
        appDelegate.settings.others19 = @"spent";
        [appDelegate.managedObjectContext save:&error];

        [appDelegate.epnc setFlurryEvent_WithIdentify:@"10_BGT_SPD"];
    }
}

-(void)weekDayBtnPressed:(UIButton *)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    sunBtn.selected = NO;
    monBtn.selected = NO;
    //others16 用来标记星期的起始日
    if(sender.tag==0)
    {
        sunBtn.selected = YES;
        
        if (![appDelegate.settings.others16 isEqualToString:@"1"])
        {
            appDelegate.settings.others16 = @"1";
            [appDelegate.managedObjectContext save:&error];
            
            if (appDelegate_iPad.mainViewController.overViewController != nil)
            {
                [appDelegate_iPad.mainViewController.overViewController resetCalendarStyle];
            }
            if (appDelegate_iPad.mainViewController.iBillsViewController != nil) {
                [appDelegate_iPad.mainViewController.iBillsViewController resetCalendarStyle];
            }
            if (appDelegate_iPad.mainViewController.iBudgetViewController != nil)
            {
                [appDelegate_iPad.mainViewController.iBudgetViewController changeBudgetRepeatStyle];
            }
        }
    }
    else{
        monBtn.selected = YES;
        
        if (![appDelegate.settings.others16 isEqualToString:@"2"]) {
            appDelegate.settings.others16 = @"2";
            [appDelegate.managedObjectContext save:&error];
            if (appDelegate_iPad.mainViewController.overViewController != nil)
            {
                [appDelegate_iPad.mainViewController.overViewController resetCalendarStyle];
            }
            if (appDelegate_iPad.mainViewController.iBillsViewController != nil) {
                [appDelegate_iPad.mainViewController.iBillsViewController resetCalendarStyle];
            }
            if (appDelegate_iPad.mainViewController.iBudgetViewController != nil)
            {
                [appDelegate_iPad.mainViewController.iBudgetViewController changeBudgetRepeatStyle];
            }
            
        }
    }
}

-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)notificationSwitchValueChanged:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (notificationSwitch.on)
    {
        [userDefault setBool:YES forKey:@"ReminderNotification"];
        [userDefault synchronize];
    }
    else
    {
        [userDefault setBool:NO forKey:@"ReminderNotification"];
        [userDefault synchronize];
    }
}
#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 36.f;
    }
    else
        return 25.f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 4;
    else
        return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
            return accountCell;
        else if (indexPath.row==1)
            return categoryCell;
        else if (indexPath.row==2)
            return amountCell;
        else
            return weeksCell;
    }
    else
        return notificationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            ipad_AccountPickerViewController *accountPickerViewController = [[ipad_AccountPickerViewController alloc]initWithNibName:@"ipad_AccountPickerViewController" bundle:nil];
            accountPickerViewController.generalViewController = self;
            accountPickerViewController.transactionEditViewController = nil;
            accountPickerViewController.selectedAccount = defaultAccount;
            [self.navigationController pushViewController:accountPickerViewController animated:YES];
        }
        else if (indexPath.row==1)
        {
            ipad_TranscationCategorySelectViewController *iTransactionCategoryViewController =   [[ipad_TranscationCategorySelectViewController alloc]initWithNibName:@"ipad_TranscationCategorySelectViewController" bundle:nil];
            iTransactionCategoryViewController.payeeEditViewController = nil;
            iTransactionCategoryViewController.transactionEditViewController = nil;
            iTransactionCategoryViewController.genetalViewController = self;
            [self.navigationController pushViewController:iTransactionCategoryViewController animated:YES];
        }
    }
    else
    {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

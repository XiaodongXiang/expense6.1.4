//
//  GeneralViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-10-13.
//
//

#import "GeneralViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "OverViewWeekCalenderViewController.h"
#import "AccountPickerViewController.h"
#import "TransactionCategoryViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"
@interface GeneralViewController ()

@end

@implementation GeneralViewController
@synthesize accountLabelText,categoryLabelText,amountLabelText,weeksLabelText,notificationLabelText,accountLabel,categoryLabel,leftBtn,spentBtn,sunBtn,monBtn,notificationSwitch;
@synthesize myTableView,accountCell,categoryCell,amountCell,weeksCell,notificationCell;
@synthesize defaultAccount,defaultExpenseCategory,defaultIncomeCategory;

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPoint];
    [self initNavStyle];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.myTableView.separatorColor = RGBColor(226, 226, 226);

}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_General", nil);
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
    
    NSDictionary *subs =[[NSDictionary alloc]init];
    
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
    if (sender.tag == 1 && !leftBtn.selected) {
        leftBtn.selected = YES;
        spentBtn.selected = NO;
        appDelegate.settings.others19 = @"left";
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"10_BGT_LFT"];
    }
    else if (sender.tag==2 && !spentBtn.selected)
    {
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
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
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
            [appDelegate_iPhone.overViewController resetCalendarStyle];
            NSMutableArray *VCArray=appDelegate_iPhone.menuVC.navigationControllerArray;
            BillsViewController *tmpBillsViewController=[VCArray objectAtIndex:8];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"calendarFirstDayChange" object:@1];

            if (tmpBillsViewController != nil && [tmpBillsViewController isKindOfClass:[BillsViewController class]])
            {
                [tmpBillsViewController resetCalendarStyle];
            }
        }
    }
    else{
        monBtn.selected = YES;
        
        if (![appDelegate.settings.others16 isEqualToString:@"2"]) {
            appDelegate.settings.others16 = @"2";
            [appDelegate.managedObjectContext save:&error];
            [appDelegate_iPhone.overViewController resetCalendarStyle];
            NSMutableArray *VCArray=appDelegate_iPhone.menuVC.navigationControllerArray;
            BillsViewController *tmpBillsViewController=[VCArray objectAtIndex:8];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"calendarFirstDayChange" object:@2];

            if (tmpBillsViewController != nil && [tmpBillsViewController isKindOfClass:[BillsViewController class]])
            {
                [tmpBillsViewController resetCalendarStyle];
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
        return 3;
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
            AccountPickerViewController *accountPickerViewController = [[AccountPickerViewController alloc]initWithNibName:@"AccountPickerViewController" bundle:nil];
            accountPickerViewController.generalViewController = self;
            accountPickerViewController.transactionEditViewController = nil;
            accountPickerViewController.selectedAccount = defaultAccount;
            [self.navigationController pushViewController:accountPickerViewController animated:YES];
        }
        else if (indexPath.row==1)
        {
            TransactionCategoryViewController *transactionCategoryViewController = [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
            transactionCategoryViewController.generalViewController = self;
            [self.navigationController pushViewController:transactionCategoryViewController animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

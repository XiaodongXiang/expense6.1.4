//
//  ipad_BudgetSettingViewController.m
//  PocketExpense
//
//  Created by humingjing on 15/1/20.
//
//

#import "ipad_BudgetSettingViewController.h"
#import "ipad_BudgetListViewController.h"
#import "ipad_BudgetViewController.h"

#import "PokcetExpenseAppDelegate.h"
#import "EPNormalClass.h"
@import Firebase;
@interface ipad_BudgetSettingViewController ()<ipad_BudgetSettingViewDelegate>

@property(nonatomic, strong)ADEngineController* interstitial;

@end

@implementation ipad_BudgetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavStyle];
    [self initPoint];
    [FIRAnalytics setScreenName:@"budget_setting_view_ipad" screenClass:@"ipad_BudgetSettingViewController"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refleshUI];
}

-(void)refleshUI
{
    [self getDataSource];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue" size:17];
    UIFont *font2 = [appDelegate.epnc  getMoneyFont_exceptInCalendar_WithSize:17];
    
    NSString *budgetCount = [NSString stringWithFormat:@"%lu %@, ",(unsigned long)[budgetArray count],NSLocalizedString(@"VC_Item(s)", nil)];
    NSString *amount = [NSString stringWithFormat:@"%@",[appDelegate.epnc formatterString:totalBudgetAmount]];
    NSString *tmpCategoryString = [NSString stringWithFormat:@"%@%@",budgetCount,amount];
    
    NSRange budgetCountRange = NSMakeRange(0, [budgetCount length]);
    NSRange amountRange = NSMakeRange([budgetCount length], [amount length]);
    NSMutableAttributedString *categoryStringAttr = [[NSMutableAttributedString alloc]initWithString:tmpCategoryString];
    
    [categoryStringAttr addAttribute:NSFontAttributeName value:font1 range:budgetCountRange];
    [categoryStringAttr addAttribute:NSFontAttributeName value:font2 range:amountRange];
    _categoryLabel.attributedText = categoryStringAttr;
}

-(void)getDataSource
{
    [budgetArray removeAllObjects];
    NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];
    [budgetArray setArray:allBudgetArray];
    
    
    
    totalBudgetAmount = 0;
    for (int i = 0; i<[allBudgetArray count];i++)
    {
        BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
    }
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Budget", nil);
    self.navigationItem.titleView = titleLabel;
    
    //设置偏移量
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -11.f;
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItems = @[flexible,leftButton];

}

-(void)initPoint
{
    [_weeklyBtn setTitle:NSLocalizedString(@"VC_Weekly", nil) forState:UIControlStateNormal];
    [_monthlyBtn setTitle:NSLocalizedString(@"VC_Monthly", nil) forState:UIControlStateNormal];
    
    [_weeklyBtn addTarget:self action:@selector(budgetRepeatStyle:) forControlEvents:UIControlEventTouchUpInside];
    [_monthlyBtn addTarget:self action:@selector(budgetRepeatStyle:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"BudgetRepeatType"] isEqualToString:@"Weekly"])
    {
        _weeklyBtn.selected = YES;
        _monthlyBtn.selected = NO;
    }
    else
    {
        _weeklyBtn.selected = NO;
        _monthlyBtn.selected = YES;
    }
    
    budgetArray = [[NSMutableArray alloc]init];
    
}

#pragma mark Btn Action
-(void)budgetRepeatStyle:(UIButton *)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (sender==_weeklyBtn)
    {
        [userDefault setValue:@"Weekly" forKey:@"BudgetRepeatType"];
        [userDefault synchronize];
        
        if (!_weeklyBtn.selected)
        {
            _weeklyBtn.selected = YES;
            _monthlyBtn.selected = NO;
            
            [_budgetViewController changeBudgetRepeatStyle];
        }
    }
    else
    {
        [userDefault setValue:@"Monthly" forKey:@"BudgetRepeatType"];
        [userDefault synchronize];
        if (!_monthlyBtn.selected)
        {
            _monthlyBtn.selected = YES;
            _weeklyBtn.selected = NO;
            [_budgetViewController changeBudgetRepeatStyle];

        }
    }
}
#pragma mark TabelView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 36.f;
    }
    else
        return 25.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row==0)
    {
        return _categoryCell;
    }
    else
        return _repeatCell;
//    static NSString *CellIdentifier;
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    if (indexPath.section == 0 && indexPath.row==0)
//    {
//        CellIdentifier=@"categoryIdentifier";
//        _categoryCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (_categoryCell == nil)
//        {
//            _categoryCell=[[[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:self options:nil]lastObject];
//        }
//        cell=_categoryCell;
//    }
//    else
//    {
//        CellIdentifier=@"repeatIdentifier";
//        _repeatCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (_repeatCell == nil)
//        {
//            _repeatCell=[[[NSBundle mainBundle]loadNibNamed:@"RepeatCell" owner:self options:nil]lastObject];
//        }
//        cell=_repeatCell;
//    }
//    
//    
//    
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0)
    {
        _budgetListViewController = [[ipad_BudgetListViewController alloc]initWithNibName:@"ipad_BudgetListViewController" bundle:nil];
        _budgetListViewController.budgetSettingViewController = self;
        _budgetListViewController.xxdDelegate = self;
        [self.navigationController pushViewController:_budgetListViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark BtnAction
-(void)back:(UIButton *)sender
{
    [_budgetViewController reFlashTableViewData];
    [self.navigationController dismissViewControllerAnimated:NO completion:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)budgetSettingSave{
    [self.interstitial showInterstitialAdWithTarget:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //插页广告
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2204 - iPad - Interstitial - BudgetSave"];
        }
    }
    return self;
}

@end

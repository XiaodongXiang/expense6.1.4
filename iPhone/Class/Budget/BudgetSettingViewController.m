//
//  BudgetSettingViewController.m
//  PocketExpense
//
//  Created by humingjing on 15/1/19.
//
//

#import "BudgetSettingViewController.h"
#import "BudgetListViewController.h"

#import "PokcetExpenseAppDelegate.h"
#import "EPNormalClass.h"
#import "AppDelegate_iPhone.h"
#import "BudgetViewController.h"


@interface BudgetSettingViewController ()

@end

@implementation BudgetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refleshUI];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
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
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Budget", nil);
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
            [_budgetViewController refleshRecurringStyle];
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
            [_budgetViewController refleshRecurringStyle];

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row==0)
    {
        return _categoryCell;
    }
    else
        return _repeatCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0)
    {
        _budgetListViewController = [[BudgetListViewController alloc]initWithNibName:@"BudgetListViewController" bundle:nil];
        [self.navigationController pushViewController:_budgetListViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

//
//  ipad_BudgetIntroduceViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import "ipad_BudgetIntroduceViewController.h"
#import "ipad_TransacationSplitViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

@interface ipad_BudgetIntroduceViewController ()

@end

@implementation ipad_BudgetIntroduceViewController
@synthesize selectedCategoryBtn;
@synthesize reminderLabel;
@synthesize dismisswithnoAnimation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStype];
    
    [self initPoint];
}

-(void)initNavStype
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
	titleLabel.text = NSLocalizedString(@"VC_SetupBudget", nil);
	self.navigationItem.titleView = titleLabel;
    
    //设置偏移量
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -2.f;
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [cancelBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelBtn.titleLabel setMinimumScaleFactor:0];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[flexible,[[UIBarButtonItem alloc] initWithCustomView:cancelBtn]];

    
}

-(void)initPoint
{
    [selectedCategoryBtn setTitle:NSLocalizedString(@"VC_SelectCategory", nil) forState:UIControlStateNormal];
    [selectedCategoryBtn setTitleColor:[UIColor colorWithRed:69.f/255.f green:154.f/255.f blue:229.f/255.f alpha:1] forState:UIControlStateNormal];
    [selectedCategoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [selectedCategoryBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [selectedCategoryBtn.titleLabel setShadowColor:[UIColor clearColor]];
    reminderLabel.text = NSLocalizedString(@"VC_SelectBudgetNotes", nil);
    selectedCategoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [selectedCategoryBtn.titleLabel setMinimumScaleFactor:0];
    
    dismisswithnoAnimation = NO;
    [selectedCategoryBtn addTarget:self action:@selector(selectCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Btn Action
-(void)selectCategoryBtnPressed:(UIButton *)sender
{
    ipad_TransacationSplitViewController *transactionCategorySplitViewController=[[ipad_TransacationSplitViewController alloc]initWithNibName:@"ipad_TransacationSplitViewController" bundle:nil];
    transactionCategorySplitViewController.iBudgetIntroduceViewController = self;
    [self.navigationController pushViewController:transactionCategorySplitViewController animated:YES];
}

-(void)back:(UIButton *)sender
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    [appDelegate_iPad.mainViewController refleshData];

    if (dismisswithnoAnimation) {
        [self.navigationController dismissViewControllerAnimated:NO completion:NO];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

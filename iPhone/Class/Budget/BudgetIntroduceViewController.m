//
//  BudgetIntroduceViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import "BudgetIntroduceViewController.h"
#import "AppDelegate_iPhone.h"
#import "TransactionCategorySplitViewController.h"
#import "PokcetExpenseAppDelegate.h"

@interface BudgetIntroduceViewController ()

@end

@implementation BudgetIntroduceViewController
@synthesize dismisswithnoAnimation;
@synthesize selectedCategoryBtn;
@synthesize reminderLabel;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)initNavStype
{
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_SetupBudget", nil);
    
    //设置偏移量
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -2.f;
    
    PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [cancelBtn setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelBtn.titleLabel setMinimumScaleFactor:0];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

    [cancelBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];

}

-(void)initPoint
{
    [selectedCategoryBtn setTitle:NSLocalizedString(@"VC_SelectCategory", nil) forState:UIControlStateNormal];
    [selectedCategoryBtn setTitleColor:[UIColor colorWithRed:99/255.f green:203/255.f blue:255/255.f alpha:1] forState:UIControlStateNormal];
    selectedCategoryBtn.layer.cornerRadius=5;
    selectedCategoryBtn.layer.masksToBounds=YES;
    [selectedCategoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [selectedCategoryBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    selectedCategoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [selectedCategoryBtn.titleLabel setMinimumScaleFactor:0];
    [selectedCategoryBtn.titleLabel setShadowColor:[UIColor clearColor]];
    

    
    reminderLabel.text = NSLocalizedString(@"VC_SelectBudgetNotes", nil);
    dismisswithnoAnimation = NO;
    [selectedCategoryBtn addTarget:self action:@selector(selectCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Btn Action
-(void)selectCategoryBtnPressed:(UIButton *)sender
{
    TransactionCategorySplitViewController *transactionCategorySplitViewController=[[TransactionCategorySplitViewController alloc]initWithNibName:@"TransactionCategorySplitViewController" bundle:nil];
    transactionCategorySplitViewController.budgetIntroduceViewController = self;
    [self.navigationController pushViewController:transactionCategorySplitViewController animated:YES];
}

-(void)back:(UIButton *)sender
{
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

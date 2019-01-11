//
//  XDTabbarViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/9.
//

#import "XDTabbarViewController.h"
#import "XDOverViewViewController.h"
#import "AccountsViewController.h"
#import "XDBudgetMainViewController.h"
#import "XDBillMainViewController.h"
#import "XDAddTransactionViewController.h"
#import "XDTabbarView.h"
#import "XDChartMainViewController.h"
#import "AppDelegate_iPhone.h"
#import <Parse/Parse.h>

#import "XDUpgradeViewController.h"

#import "XDAppriater.h"



@import Firebase;
@interface XDTabbarViewController ()<XDAddTransactionViewDelegate>
@property(nonatomic, strong)XDOverViewViewController * overViewCalendarViewController;
@property(nonatomic, strong)XDBudgetMainViewController * budgetViewController;
@property(nonatomic, strong)XDBillMainViewController * billViewController;
@property(nonatomic, strong)TransactionEditViewController * transacitionViewController;
@property(nonatomic, strong)__block NSDate * date;
@property(nonatomic, strong)XDTabbarView * tabbarView;
@property(nonatomic, strong)XDChartMainViewController * chartViewController;
@property(nonatomic, strong)ADEngineController* interstitial;


@end

@implementation XDTabbarViewController

-(XDOverViewViewController *)overViewCalendarViewController{
    if (!_overViewCalendarViewController) {
        _overViewCalendarViewController = [[XDOverViewViewController alloc]init];
        _overViewCalendarViewController.tabbarVc = self;
        __weak __typeof__(self) weakSelf = self;
        _overViewCalendarViewController.dateBlock = ^(NSDate *selectedDate) {
            weakSelf.date = selectedDate;
        };
    }
    return _overViewCalendarViewController;
}

-(XDChartMainViewController *)chartViewController{
    if (!_chartViewController) {
        _chartViewController = [[XDChartMainViewController alloc]initWithNibName:@"XDChartMainViewController" bundle:nil];
    }
    return _chartViewController;
}

-(XDBudgetMainViewController *)budgetViewController{
    if (!_budgetViewController) {
        _budgetViewController = [[XDBudgetMainViewController alloc]initWithNibName:@"XDBudgetMainViewController" bundle:nil];
    }
    return _budgetViewController;
}

-(XDBillMainViewController *)billViewController{
    if (!_billViewController) {
        _billViewController = [[XDBillMainViewController alloc]initWithNibName:@"XDBillMainViewController" bundle:nil];
        
    }
    return _billViewController;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[XDAppriater shareAppirater] judgeShowRateView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarDismiss:) name:@"tabbarDismiss" object:nil];
    
    self.date = [NSDate initCurrentDate];
    [self setupChildControllers];
    if (IS_IPHONE_X) {
        self.tabbarView = [[XDTabbarView alloc]initWithFrame:CGRectMake(0, self.view.height - 83, SCREEN_WIDTH, 83)];
    }else{
        self.tabbarView = [[XDTabbarView alloc]initWithFrame:CGRectMake(0, self.view.height - 49, SCREEN_WIDTH, 83)];
    }
    [self.view bringSubviewToFront:self.tabbarView];
    [self.view addSubview:self.tabbarView];
    self.tabBar.hidden = YES;
    __weak __typeof__(self) weakSelf = self;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    
    self.tabbarView.block = ^(NSInteger index) {
        
        
        if (index == 2) {
            XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
            addVc.calSelectedDate = weakSelf.date;
            addVc.delegate = weakSelf;
//            NSLog(@"selectedDate = %@", weakSelf.date);
            [weakSelf presentViewController:addVc animated:YES completion:nil];
            
        }else{
            if (index == weakSelf.selectedIndex) {
                [weakSelf.overViewCalendarViewController scrollToToday];
            }
            weakSelf.selectedIndex = index;
            
        }
        
        if (index == 0) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_CALD"];
        }
        if (index == 1) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_RPT"];
        }
        if (index == 3) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_BGT"];
        }
        if (index == 4) {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_BIL"];
        }
    };
    
    
    if ([PFUser currentUser]) {
        
        [[XDDataManager shareManager] fixStateIsZeroBug];
        [[XDDataManager shareManager] deleteSomeUnUseTransaction];
        
        [[XDDataManager shareManager] uploadLocalTransaction];
    }
    
}



-(void)tabbarDismiss:(NSNotification*)notif{
    [UIView animateWithDuration:0.2 animations:^{
        if ([[notif object] boolValue]) {
            self.tabbarView.y =  self.view.height + 20;
        }else{
            if (IS_IPHONE_X) {
                self.tabbarView.y = self.view.height - 83;
            }else{
                self.tabbarView.y = self.view.height - 49;
            }
        }
    }];
}

-(void)setupChildControllers{
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:self.overViewCalendarViewController]];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:self.chartViewController]];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]]];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:self.budgetViewController]];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:self.billViewController]];
}
- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - XDAddTransactionViewDelegate
-(void)addTransactionCompletion{
    [self.overViewCalendarViewController reloadTableView];
    
    //插页广告
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        [self.interstitial showInterstitialAdWithTarget:self];
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1202 - iPhone - Interstitial - NewTransactionSave"];
    }
    return self;
}


@end

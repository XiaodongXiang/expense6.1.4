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
#import "XDChristmasPlanBPopViewController.h"
#import "XDChristmasPlanAPopViewController.h"
#import "XDPlanControlClass.h"
#import <Parse/Parse.h>

#import "XDUpgradeViewController.h"

#import "XDAppriater.h"

#import "XDChristmasLiteOneViewController.h"
#import "XDChristmasLitePlanAViewController.h"
#import "XDChristmasPlanAbViewController.h"
#import "XDChristmasPlanBbViewController.h"

#import "XDChristmasShareSuccessPlanBPopViewController.h"
#import "XDChristmasShareSuccessdPlanAPopViewController.h"


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

@property(nonatomic, strong)XDChristmasPlanAPopViewController* planA;
@property(nonatomic, strong)XDChristmasPlanBPopViewController* planB;


@property(nonatomic, strong)XDChristmasShareSuccessdPlanAPopViewController* popAVc;
@property(nonatomic, strong)XDChristmasShareSuccessPlanBPopViewController* popBVc;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccessful) name:@"purchaseSuccessful" object:nil];

}


-(void)purchaseSuccessful{
    
    NSString* christmasUserObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isChristmasEnter"];
    if (christmasUserObjectID.length > 0) {
        if ([XDPlanControlClass shareControlClass].planType == ChristmasPlanA) {
            self.popAVc = [[XDChristmasShareSuccessdPlanAPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessdPlanAPopViewController" bundle:nil];
            [self.view addSubview:self.popAVc.view];
            self.popAVc.view.frame  = CGRectMake(0, 0, ISPAD?375:SCREEN_WIDTH, ISPAD?667:SCREEN_HEIGHT);
            [self.popAVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popAVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            self.popAVc.contentImgView.image = [UIImage imageNamed:@"christmas_50%off"];
            [self.popAVc.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download"] forState:UIControlStateNormal];
            [self.popAVc.useItBtn setImage:[UIImage imageNamed:@"aChristmas_Download_press"] forState:UIControlStateHighlighted];
            
            [self.popAVc show];
        }else{
            self.popBVc = [[XDChristmasShareSuccessPlanBPopViewController alloc]initWithNibName:@"XDChristmasShareSuccessPlanBPopViewController" bundle:nil];
            [self.view addSubview:self.popBVc.view];
            self.popBVc.view.frame  = CGRectMake(0, 0, ISPAD?375:SCREEN_WIDTH, ISPAD?667:SCREEN_HEIGHT);
            [self.popBVc.cancelBtn addTarget:self action:@selector(vcCancelClick) forControlEvents:UIControlEventTouchUpInside];
            [self.popBVc.useItBtn addTarget:self action:@selector(vcUseItClick) forControlEvents:UIControlEventTouchUpInside];
            self.popBVc.contentImgView.image = [UIImage imageNamed:@"bChristmas_share_50%off"];
            
            [self.popBVc show];
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isChristmasEnter"];
    }
}

-(void)vcCancelClick{
    if ([XDPlanControlClass shareControlClass].planType == ChristmasPlanA) {
        [self.popAVc dismiss];
        
    }else{
        [self.popBVc dismiss];
        
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isChristmasEnter"];
    
}

-(void)vcUseItClick{
    if ([XDPlanControlClass shareControlClass].planType == ChristmasPlanA) {
        [self.popAVc dismiss];
        
    }else{
        [self.popBVc dismiss];
        
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isChristmasEnter"];
    
    
    NSString *urlStr = @"https://itunes.apple.com/app/apple-store/id563155321?pt=12390800&ct=ChristmasActivity-PKEP-HRKP&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

-(void)christmasPopViewGetNowClick{
    [self.planA dismiss];
//    XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
//    [self presentViewController:adsVc animated:YES completion:nil];
    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;

    if(subPlan == ChristmasSubPlana){
        
        XDChristmasLitePlanAViewController* christmas = [[XDChristmasLitePlanAViewController alloc]initWithNibName:@"XDChristmasLitePlanAViewController" bundle:nil];
        [self presentViewController:christmas animated:YES completion:nil];
        
    }else if (subPlan == ChristmasSubPlanb){
        
        XDChristmasPlanAbViewController* christmas = [[XDChristmasPlanAbViewController alloc]initWithNibName:@"XDChristmasPlanAbViewController" bundle:nil];
        [self presentViewController:christmas animated:YES completion:nil];
    }
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"CA_FU_OpenPopup" parameters:nil];
    }else if([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"CA_PU_OpenPopup" parameters:nil];
    }
}
-(void)dismissPopView{
    [self.planA dismiss];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"CA_FU_ClosePopup" parameters:nil];
    }else if([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"CA_PU_ClosePopup" parameters:nil];
    }
}

-(void)bchristmasPopViewGetNowClick{
    [self.planB dismiss];
    NSInteger subPlan = [XDPlanControlClass shareControlClass].planSubType;

    if(subPlan == ChristmasSubPlana){
        XDChristmasLiteOneViewController* christmas = [[XDChristmasLiteOneViewController alloc]initWithNibName:@"XDChristmasLiteOneViewController" bundle:nil];
        [self presentViewController:christmas animated:YES completion:nil];
        
    }else if(subPlan == ChristmasSubPlanb){
        XDChristmasPlanBbViewController* christmas = [[XDChristmasPlanBbViewController alloc]initWithNibName:@"XDChristmasPlanBbViewController" bundle:nil];
        [self presentViewController:christmas animated:YES completion:nil];
        
    }
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"CA_FU_OpenPopup" parameters:nil];
    }else if([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"CA_PU_OpenPopup" parameters:nil];
    }

    
}
-(void)bdismissPopView{
    [self.planB dismiss];
    
    if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
        [FIRAnalytics logEventWithName:@"CA_FU_ClosePopup" parameters:nil];
    }else if([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
        [FIRAnalytics logEventWithName:@"CA_PU_ClosePopup" parameters:nil];
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
    
    if ([[XDPlanControlClass shareControlClass] everyDayShowOnce]) {
        if ([XDPlanControlClass shareControlClass].planType == ChristmasPlanA) {
            
            self.planA = [[XDChristmasPlanAPopViewController alloc]initWithNibName:@"XDChristmasPlanAPopViewController" bundle:nil];
            self.planA.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.planA show];
            
            [self.planA.getNowBtn addTarget:self action:@selector(christmasPopViewGetNowClick) forControlEvents:UIControlEventTouchUpInside];
            [self.planA.cancelBtn addTarget:self action:@selector(dismissPopView) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.planA.view];
            
        }else{
            
            self.planB = [[XDChristmasPlanBPopViewController alloc]initWithNibName:@"XDChristmasPlanBPopViewController" bundle:nil];
            self.planB.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.planB show];
            
            [self.planB.openBtn addTarget:self action:@selector(bchristmasPopViewGetNowClick) forControlEvents:UIControlEventTouchUpInside];
            [self.planB.cancelBtn addTarget:self action:@selector(bdismissPopView) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: self.planB.view];
            
        }
        
        if ([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryHasReceive7Days) {
             [FIRAnalytics logEventWithName:@"CA_FU_ShowPopup" parameters:nil];
        }else if([XDPlanControlClass shareControlClass].planCategory == ChristmasPlanCategoryLifetime){
            [FIRAnalytics logEventWithName:@"CA_PU_ShowPopup" parameters:nil];
        }
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

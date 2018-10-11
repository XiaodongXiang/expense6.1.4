//
//  XDBillMainViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/30.
//

#import "XDBillMainViewController.h"
#import "XDAddBillViewController.h"
#import "XDBillPayViewController.h"
#import "XDBillCalendarViewController.h"
#import "SettingViewController.h"
#import "BillsViewController.h"
#import "XDAddPayViewController.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDBillMainViewController ()<XDAddBillViewDelegate,BillsViewDelegate,XDBillCalendarViewDelegate,ADEngineControllerBannerDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)XDBillCalendarViewController * calenVc;

@property(nonatomic, strong)BillsViewController * billVc;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)NSDate * selectedDate;

@property(nonatomic, strong)ADEngineController* adBanner;
@property(nonatomic, strong)UIView* adBannerView;
@property(nonatomic, strong)ADEngineController* interstitial;

@end

@implementation XDBillMainViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //插页广告
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1206 - iPhone - Interstitial - NewBillSave"];
        }
    }
    return self;
}


-(UIView *)adBannerView{
    if (!_adBannerView) {
        _adBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height - 50, SCREEN_WIDTH, 50)];
        _adBannerView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_adBannerView];
    }
    return _adBannerView;
}

-(BillsViewController *)billVc{
    if (!_billVc) {
        _billVc = [[BillsViewController alloc]initWithNibName:@"BillsViewController" bundle:nil];
        _billVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
        _billVc.delegate = self;
    }
    return _billVc;
}
//
-(XDBillCalendarViewController *)calenVc{
    if (!_calenVc) {
        _calenVc = [[XDBillCalendarViewController alloc]init];
        _calenVc.xxdDelegate = self;
        _calenVc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);

    }
    return _calenVc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self returnBillCompletion];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1106 - iPhone - Banner - Bills" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
      
        self.billVc.view.height = self.scrollView.height;
    }
}


#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        self.billVc.view.height = self.scrollView.height - 50;
        
    }else{
        self.adBannerView.hidden = YES;
        self.billVc.view.height = self.scrollView.height;

    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = self.titleLabel;
    self.title = NSLocalizedString(@"VC_Bills", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];

    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];
//    self.navigationItem.title = NSLocalizedString(@"VC_Bills", nil);

    if (IS_IPHONE_X) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT - 88 - 83)];
    }else{
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    [self.view addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingButtonPress) image:[UIImage imageNamed:@"setting_new"]];
    
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 93, 44)];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 44, 44);
    [btn1 setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"across"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(calendarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(49, 0, 44, 44);
    [btn2 setImage:[UIImage imageNamed:@"add_category"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:btn2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    
    [self.scrollView addSubview:self.billVc.view];
    [self.scrollView addSubview:self.calenVc.view];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnBillCompletion) name:@"refreshBillCal" object:nil];
    
    
    
}


-(void)calendarBtn:(UIButton*)btn{
    btn.selected = !btn.selected;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (!btn.selected) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.title = NSLocalizedString(@"VC_Bills", nil);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
        self.navigationItem.titleView = nil;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"12_BIL_LIST"];

    }else{
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [self.titleLabel setAttributedText:[self monthFormatterWithSeletedMonth:[NSDate date]]];
        self.navigationItem.titleView = self.titleLabel;
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"12_BIL_CALD"];

    }
}

-(void)addBtnClick{
    XDAddBillViewController* addVc = [[XDAddBillViewController alloc]initWithNibName:@"XDAddBillViewController" bundle:nil];
    addVc.delegate = self;
    addVc.selectedDate = self.selectedDate;
    [self presentViewController:addVc animated:YES completion:nil];
}

-(void)settingButtonPress{
    
    SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - XDBillCalendarViewDelegate
-(void)returnCurrentMonthDate:(NSDate *)date{
    [self.titleLabel setAttributedText:[self monthFormatterWithSeletedMonth:date]];
}
-(void)returnSelectBillFather:(BillFather *)billFather{
    XDBillPayViewController* vc = [[XDBillPayViewController alloc]initWithNibName:@"XDBillPayViewController" bundle:nil];
    vc.billFather = billFather;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];
    
}

-(void)returnSelectedDate:(NSDate *)date{
    self.selectedDate = date;
}

#pragma mark - XDAddBillViewDelegate
-(void)returnBillCompletion{
    [self.billVc resetData];
    [self.billVc refleshUI];
    
    [self.calenVc refreshCalendarAndBill];
    
}

-(void)newBillSave{
    //插页广告
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.isPurchased) {
        [self.interstitial showInterstitialAdWithTarget:self];
    }
}

#pragma mark - BillsViewDelegate
-(void)returnSelectedBill:(BillFather *)billFather{
    XDBillPayViewController* vc = [[XDBillPayViewController alloc]initWithNibName:@"XDBillPayViewController" bundle:nil];
    vc.billFather = billFather;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];

}

-(void)returnSelectedBillEdit:(BillFather *)billFather{
    
    XDAddBillViewController* addVc = [[XDAddBillViewController alloc]initWithNibName:@"XDAddBillViewController" bundle:nil];
    addVc.delegate = self;
    addVc.billFather = billFather;
    [self presentViewController:addVc animated:YES completion:nil];
}

-(void)returnSelectedEditBill:(BillFather *)billFather{
    
    XDAddBillViewController* addVc = [[XDAddBillViewController alloc]initWithNibName:@"XDAddBillViewController" bundle:nil];
    addVc.delegate = self;
    addVc.billFather = billFather;
    [self presentViewController:addVc animated:YES completion:nil];
}

-(NSAttributedString*)monthFormatterWithSeletedMonth:(NSDate*)date{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM"];
    NSString* string = [formatter stringFromDate:date];
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontHelveticaNeueMedium size:17] range:NSMakeRange(0, string.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:RGBColor(113, 163, 245) range:NSMakeRange(0, string.length)];
    
    
    
    [formatter setDateFormat:@"yyyy"];
    NSString* string1 = [formatter stringFromDate:date];
    
    NSMutableAttributedString* attString1 = [[NSMutableAttributedString alloc]initWithString:string1];
    
    [attString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontHelveticaNeueMedium size:17] range:NSMakeRange(0, string1.length)];
    [attString1 addAttribute:NSForegroundColorAttributeName value:RGBColor(200, 200, 200) range:NSMakeRange(0, string1.length)];
    [attString appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@" "]];
    [attString appendAttributedString:attString1];
    
    return attString ;
}


@end

//
//  XDIpad_ADSViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/8/29.
//

#import "XDIpad_ADSViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "XDInAppPurchaseManager.h"
#import <Appsee/Appsee.h>
#import <Parse/Parse.h>

@import Firebase;
@interface XDIpad_ADSViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *monthView;
@property (strong, nonatomic) IBOutlet UIView *yearView;
@property (strong, nonatomic) IBOutlet UIView *lifetimeView;


@property (weak, nonatomic) IBOutlet UILabel *monthPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *lifetimePriceLbl;
@property (strong, nonatomic) IBOutlet UITableViewCell *adCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *reportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *widgetCell;
@property (weak, nonatomic) IBOutlet UILabel *saleLbl;

@property (strong, nonatomic) IBOutlet UITableViewCell *syncCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *budgetCell;
@property (weak, nonatomic) IBOutlet UIImageView *monthBg;
@property (weak, nonatomic) IBOutlet UIImageView *yearBg;
@property (weak, nonatomic) IBOutlet UIImageView *lifetimeBg;
@property (weak, nonatomic) IBOutlet UILabel *monthTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *lifeTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearDetailLbl;
@property (weak, nonatomic) IBOutlet UILabel *lifetimeDetailLbl;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIButton *lifetimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreBtnHeight;

@end

@implementation XDIpad_ADSViewController
-(void)setIsChristmasEnter:(BOOL)isChristmasEnter{
    _isChristmasEnter = isChristmasEnter;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = 375/3;
    
    self.monthView.frame = CGRectMake(0, 0, 152, self.scrollView.height);
    self.yearView.frame = CGRectMake(width, 0, 152, self.scrollView.height);
    self.lifetimeView.frame = CGRectMake(width * 2, 0, 152, self.scrollView.height);
    
    self.monthView.centerX = 375 / 6;
    self.yearView.centerX = 375 / 2;
    self.lifetimeView.centerX = 375 / 6 * 5;
    [self.scrollView addSubview:self.monthView];
    [self.scrollView addSubview:self.yearView];
    [self.scrollView addSubview:self.lifetimeView];
    
//    [Appsee addEvent:@"Enter Shop"];
    [FIRAnalytics logEventWithName:@"enter_shop" parameters:nil];

    [self preVersionPrice];
    //添加观察通知，当获取到价格的时候就将价格显示出来
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(preVersionPrice) name:GET_PRO_VERSION_PRICE_ACTION object:nil];
    [self.restoreBtn setTitle:NSLocalizedString(@"VC_RestorePurchased", nil) forState:UIControlStateNormal];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.monthBtn.enabled = YES;
    self.yearBtn.enabled = YES;
    self.lifetimeBtn.enabled = YES;
    
    if (appDelegate.isPurchased) {
        self.restoreBtn.hidden = YES;
        self.restoreBtnHeight.constant = 0.01;
        Setting* setting = [[XDDataManager shareManager] getSetting];
        BOOL defaults2 = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;
        
        if (defaults2) {
            self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
            self.lifeTimeLbl.textColor = RGBColor(122, 163, 239);
            self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
            //            self.lifetimeBtn.enabled = NO;
            self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
            
            self.monthBg.image = [UIImage imageNamed:@"month-1"];
            self.yearBg.image = [UIImage imageNamed:@"month-1"];
            self.monthView.userInteractionEnabled = NO;
            self.yearView.userInteractionEnabled = NO;
            self.saleLbl.hidden = YES;
            
            self.lifetimeBtn.enabled = NO;
        }else{
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    self.monthBg.image = [UIImage imageNamed:@"yigoumai"];
                    self.monthPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.monthTimeLbl.textColor = RGBColor(122, 163, 239);
                    //            self.monthBtn.enabled = NO;
                    
                    self.yearBg.image = [UIImage imageNamed:@"year"];
                    
                    self.monthBtn.enabled = NO;
                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    self.yearBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.yearTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.yearPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.yearDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    //            self.yearBtn.enabled = NO;
                    self.monthBg.image = [UIImage imageNamed:@"month"];
                    
                    self.yearBtn.enabled = NO;
                }else{
                    self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.lifeTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
                    //            self.lifetimeBtn.enabled = NO;
                    self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    self.monthBg.image = [UIImage imageNamed:@"month-1"];
                    self.yearBg.image = [UIImage imageNamed:@"month-1"];
                    self.monthView.userInteractionEnabled = NO;
                    self.yearView.userInteractionEnabled = NO;
                    self.lifetimeBtn.enabled = NO;
                }
            }
        }
    }else{
        self.restoreBtnHeight.constant = 40;
        self.restoreBtn.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelClick:) name:@"purchaseSuccessful" object:nil];
    
    [FIRAnalytics setScreenName:@"purchase_view_ipad" screenClass:@"XDIpad_ADSViewController"];
}
- (IBAction)restoreBtnClick:(id)sender {
    [[XDInAppPurchaseManager shareManager] restoreUpgrade];
}

- (IBAction)cancelClick:(id)sender {

//    [Appsee addEvent:@"Leave Shop"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.xxdDelegate respondsToSelector:@selector(ipadUpgradeViewDismiss)]) {
        [self.xxdDelegate ipadUpgradeViewDismiss];
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [FIRAnalytics logEventWithName:@"leave_shop" parameters:nil];
    
}

//获取保存在本地的商品价格，显示
-(void)preVersionPrice
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *monthPrice = [userDefaults stringForKey:PURCHASE_PRICE_MONTH];
    NSString *yearPrice = [userDefaults stringForKey:PURCHASE_PRICE_YEAR];
    NSString *lifetimePrice = [userDefaults stringForKey:PURCHASE_PRICE_LIFETIME];
    double sale = [userDefaults doubleForKey:@"salePrice"];
    
    if ([userDefaults boolForKey:PURCHASE_PRICE_INTRODUCTORY_CAN_BUY]) {
        if ([userDefaults stringForKey:PURCHASE_PRICE_MONTH_INTRODUCTORY].length > 0) {
            monthPrice = [userDefaults stringForKey:PURCHASE_PRICE_MONTH_INTRODUCTORY];
        }
    }
    self.saleLbl.text = [NSString stringWithFormat:@"Save %d%%",(int)sale];
    if (monthPrice.length > 0) {
        self.monthPriceLbl.text = monthPrice;
    }
    
    if (yearPrice.length > 0) {
        self.yearPriceLbl.text = yearPrice;
    }
    
    if (lifetimePrice.length > 0) {
        self.lifetimePriceLbl.text = lifetimePrice;
    }
}
- (IBAction)monthBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [FIRAnalytics logEventWithName:@"attemp_to_buy_monthly" parameters:@{@"user_action":@"attemp_to_buy_monthly"}];

    if (self.isChristmasEnter) {
        [FIRAnalytics logEventWithName:@"christmas_attemp_to_buy_monthly" parameters:nil];
        if ([PFUser currentUser]) {
            [[NSUserDefaults standardUserDefaults] setObject:[PFUser currentUser].objectId forKey:@"isChristmasEnter"];
        }
    }
    
    [[XDInAppPurchaseManager shareManager]purchaseUpgrade:KInAppPurchaseProductIdMonth];
    
    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_month_subscribe"];
}
- (IBAction)yearBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [FIRAnalytics logEventWithName:@"attemp_to_buy_yearly" parameters:@{@"user_action":@"attemp_to_buy_yearly"}];
    if (self.isChristmasEnter) {
        [FIRAnalytics logEventWithName:@"christmas_attemp_to_buy_yearly" parameters:nil];
        if ([PFUser currentUser]) {
            [[NSUserDefaults standardUserDefaults] setObject:[PFUser currentUser].objectId forKey:@"isChristmasEnter"];
        }
    }
    [[XDInAppPurchaseManager shareManager]purchaseUpgrade:KInAppPurchaseProductIdYear];

    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_year_subscribe"];
}
- (IBAction)lifetimeBtnClick:(id)sender {
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [FIRAnalytics logEventWithName:@"attemp_to_buy_lifetime" parameters:@{@"user_action":@"attemp_to_buy_lifetime"}];
    if (self.isChristmasEnter) {
        [FIRAnalytics logEventWithName:@"christmas_attemp_to_buy_lifetime" parameters:nil];
        if ([PFUser currentUser]) {
            [[NSUserDefaults standardUserDefaults] setObject:[PFUser currentUser].objectId forKey:@"isChristmasEnter"];
        }
    }
    
    [[XDInAppPurchaseManager shareManager]purchaseUpgrade:kInAppPurchaseProductIdLifetime];
    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.adCell;
    }else if (indexPath.row == 1){
        return self.widgetCell;
    }else if (indexPath.row == 2){
        return self.reportCell;
    }else if (indexPath.row == 3){
        return self.syncCell;
    }else if (indexPath.row == 4){
        return self.accountCell;
    }else
        return self.budgetCell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 100)];
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, 375 - 30, 80)];
    NSString* string  = @"Your iTunes account will be charged as soon as you confirm the Premium purchase. Your subscription will auto renew unless cancelled at least 24 hours before the end of the current period. Manage your subscriptions in the iTunes Store after purchase. By upgrading to premium you accept our ";
    textView.editable = NO;
    NSDictionary *dictionary = @{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:10],NSForegroundColorAttributeName:RGBColor(200, 200, 200)};
    NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:string attributes:dictionary];
    
    NSDictionary *dictionary2 = @{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:10],NSForegroundColorAttributeName:RGBColor(200, 200, 200),NSUnderlineStyleAttributeName:@3};
    NSString* privacyStr = @"Privacy Policy";
    NSMutableAttributedString * privacymuStr =[[NSMutableAttributedString alloc]initWithString:privacyStr attributes:dictionary2];
    [privacymuStr addAttribute:NSLinkAttributeName value:@"https://www.iubenda.com/privacy-policy/7775087" range:[privacyStr rangeOfString:@"Privacy Policy"]];
    
    NSString* termStr = @"Terms of use";
    NSMutableAttributedString * termMuStr =[[NSMutableAttributedString alloc]initWithString:termStr attributes:dictionary2];
    [termMuStr addAttribute:NSLinkAttributeName value:@"https://www.iubenda.com/privacy-policy/7775087" range:[termStr rangeOfString:@"Terms of use"]];
    
    [attributeStr appendAttributedString:privacymuStr];
    [attributeStr appendAttributedString:[[NSAttributedString alloc]initWithString:@" and " attributes:dictionary]];
    [attributeStr appendAttributedString:termMuStr];

    
    textView.attributedText = attributeStr;
    
    [view addSubview:textView];
    return view;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}
@end

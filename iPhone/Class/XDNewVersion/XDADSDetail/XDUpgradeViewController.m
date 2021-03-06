//
//  XDUpgradeViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/8/28.
//

#import "XDUpgradeViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "XDTermsOfUseViewController.h"
#import "XDInAppPurchaseManager.h"
#import <Parse/Parse.h>

@import Firebase;
@interface XDUpgradeViewController ()<SKRequestDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *monthView;
@property (strong, nonatomic) IBOutlet UIView *yearView;
@property (strong, nonatomic) IBOutlet UIView *lifetimeView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
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
@property (weak, nonatomic) IBOutlet UILabel *monthTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *liteTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *monthBg;
@property (weak, nonatomic) IBOutlet UIImageView *yearBg;
@property (weak, nonatomic) IBOutlet UIImageView *lifetimeBg;
@property (weak, nonatomic) IBOutlet UILabel *yearDetailLbl;
@property (weak, nonatomic) IBOutlet UILabel *lifetimeDetailLbl;
@property (weak, nonatomic) IBOutlet UIButton *lifetimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (strong, nonatomic) IBOutlet UITableViewCell *lastCell;
@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreBtnH;
@property (weak, nonatomic) IBOutlet UILabel *premiumTitle;

@property (strong, nonatomic) IBOutlet UIView *upgradeNewView;
@property (weak, nonatomic) IBOutlet UILabel *upgradeTimeStyleLbl;
@property (weak, nonatomic) IBOutlet UILabel *upgradeNewEndTimeLbl;
@property (strong, nonatomic) IBOutlet UIView *lifetimeNewView;
//@property (weak, nonatomic) IBOutlet UIImageView *lifetimeNewProfileIcon;
@property (weak, nonatomic) IBOutlet UILabel *lifetimeNewEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewH;

@end

@implementation XDUpgradeViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [FIRAnalytics logEventWithName:@"leave_shop" parameters:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = SCREEN_WIDTH/3;
    
    [FIRAnalytics setScreenName:@"purchase_view_iphone" screenClass:@"XDUpgradeViewController"];

    self.monthView.frame = CGRectMake(0, 0, width, self.scrollview.height);
    self.yearView.frame = CGRectMake(width, 0, width, self.scrollview.height);
    self.lifetimeView.frame = CGRectMake(width * 2, 0, width, self.scrollview.height);

    self.upgradeNewView.frame = CGRectMake(0, -1, width+1, self.scrollview.height+1);
    self.lifetimeNewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    
    [FIRAnalytics logEventWithName:@"enter_shop" parameters:nil];

    
    self.monthView.centerX = SCREEN_WIDTH / 6;
    self.yearView.centerX = SCREEN_WIDTH / 2;
    self.lifetimeView.centerX = SCREEN_WIDTH / 6 * 5;
    [self.scrollview addSubview:self.monthView];
    [self.scrollview addSubview:self.yearView];
    [self.scrollview addSubview:self.lifetimeView];
    
    [self preVersionPrice];
    //添加观察通知，当获取到价格的时候就将价格显示出来
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(preVersionPrice) name:GET_PRO_VERSION_PRICE_ACTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingReloadData) name:@"refreshSettingUI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingReloadData) name:@"purchaseSuccessful" object:nil];

    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        
        Setting* setting = [[XDDataManager shareManager] getSetting];

        if ([setting.otherBool16 boolValue]) {
            return;
            
        }
//        
//        PFUser *user=[PFUser currentUser];
//        self.lifetimeNewEmail.text = user.email?:user.username;
//        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
//        NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
//        UIImage *image=[[UIImage alloc]initWithData:imageData];
//        if (imageData) {
//            self.lifetimeNewProfileIcon.image = image;
//        }
//        self.lifetimeNewProfileIcon.layer.cornerRadius = 20;
//        self.lifetimeNewProfileIcon.layer.masksToBounds = YES;
//        
        BOOL defaults2 = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;

        if (defaults2) {
            self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
            self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
            self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
            //            self.lifetimeBtn.enabled = NO;
            self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
            
            self.monthBg.image = [UIImage imageNamed:@"month-1"];
            self.yearBg.image = [UIImage imageNamed:@"month-1"];
            self.monthView.userInteractionEnabled = NO;
            self.yearView.userInteractionEnabled = NO;
            self.saleLbl.hidden = YES;
            
            self.monthTimeLbl.textColor = [UIColor whiteColor];
            self.monthPriceLbl.textColor = [UIColor whiteColor];
            self.yearTimeLbl.textColor = [UIColor whiteColor];
            self.yearPriceLbl.textColor = [UIColor whiteColor];
            
            self.premiumTitle.text = @"Lifetime Premium";
            
            self.lifetimeBtn.enabled = NO;
            self.lifetimeNewView.hidden = NO;

            [self.scrollview addSubview:self.lifetimeNewView];
            self.scrollViewH.constant = 111;
            self.lifetimeNewEmail.text = @"Lifetime";
            self.scrollview.clipsToBounds = YES;
        }else{
            
            self.scrollViewH.constant = 154;
            self.scrollview.clipsToBounds = NO;
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    self.lifetimeNewEmail.text = @"Monthly";
                    self.monthBg.image = [UIImage imageNamed:@"yigoumai"];
                    self.monthPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.monthTimeLbl.textColor = RGBColor(122, 163, 239);
                     self.yearBg.image = [UIImage imageNamed:@"year"];
                    self.premiumTitle.text = @"Monthly Premium";
                    self.monthBtn.enabled = NO;

                    self.upgradeNewView.hidden = NO;
                    [self.monthView addSubview:self.upgradeNewView];
                    self.upgradeTimeStyleLbl.text = @"Monthly Premium";
                    Setting* setting = [[XDDataManager shareManager] getSetting];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy.MM.dd"];
                    NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                    self.upgradeNewEndTimeLbl.text = [NSString stringWithFormat:@"%@",expiredString];
                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    
                    self.lifetimeNewEmail.text = @"Yearly";
                    self.yearBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.yearTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.yearPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.yearDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    self.monthBg.image = [UIImage imageNamed:@"month"];
                    self.premiumTitle.text = @"Yearly Premium";
                    self.yearBtn.enabled = NO;
                    
                    self.upgradeNewView.hidden = NO;
                    [self.yearView addSubview:self.upgradeNewView];
                    self.upgradeTimeStyleLbl.text = @"Yearly Premium";
                    
                    
                    Setting* setting = [[XDDataManager shareManager] getSetting];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy.MM.dd"];
                    NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                    self.upgradeNewEndTimeLbl.text = [NSString stringWithFormat:@"%@",expiredString];
                    
                }else if([proID isEqualToString:kInAppPurchaseProductIdLifetime]){
                    self.scrollview.clipsToBounds = YES;
                    self.lifetimeNewEmail.text = @"Lifetime";
                    self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    self.monthBg.image = [UIImage imageNamed:@"month-1"];
                    self.yearBg.image = [UIImage imageNamed:@"month-1"];
                    self.monthView.userInteractionEnabled = NO;
                    self.yearView.userInteractionEnabled = NO;
                    
                    self.monthTimeLbl.textColor = [UIColor whiteColor];
                    self.monthPriceLbl.textColor = [UIColor whiteColor];
                    self.yearTimeLbl.textColor = [UIColor whiteColor];
                    self.yearPriceLbl.textColor = [UIColor whiteColor];
                    self.yearDetailLbl.textColor = [UIColor whiteColor];

                    self.premiumTitle.text = @"Lifetime Premium";
                    self.lifetimeBtn.enabled = NO;
                    self.lifetimeNewView.hidden = NO;

                    [self.scrollview addSubview:self.lifetimeNewView];

                    self.scrollViewH.constant = 111;
                }
            }
        }
       
        
        self.restoreBtn.hidden = YES;
        self.restoreBtnH.constant = 0;
    }else{
        self.scrollViewH.constant = 154;

        self.restoreBtn.hidden = NO;
        self.restoreBtnH.constant = 40;
        self.premiumTitle.text = @"Upgrade to Premium";
        self.scrollview.clipsToBounds = NO;
        self.monthBtn.enabled = YES;
        self.yearBtn.enabled = YES;
        self.lifetimeBtn.enabled = YES;
        self.upgradeNewView.hidden = YES;
        self.lifetimeNewView.hidden = YES;
    }
}


- (IBAction)restoreBtnClick:(id)sender {
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [appDelegate.inAppPM restorePurchase];
    [[XDInAppPurchaseManager shareManager]restoreUpgrade];
}

-(void)settingReloadData{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self preVersionPrice];
    if (appDelegate.isPurchased) {
        
        Setting* setting = [[XDDataManager shareManager] getSetting];
        if ([setting.otherBool16 boolValue]) {
            return;
            
        }
//        PFUser *user=[PFUser currentUser];
//        self.lifetimeNewEmail.text = user.email?:user.username;
//        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
//        NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
//        UIImage *image=[[UIImage alloc]initWithData:imageData];
//        if (imageData) {
//            self.lifetimeNewProfileIcon.image = image;
//        }
       
        BOOL defaults2 = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;
        
        self.monthBtn.enabled = YES;
        self.yearBtn.enabled = YES;
        self.lifetimeBtn.enabled = YES;
        
        if (defaults2) {
            self.scrollViewH.constant = 111;
            self.lifetimeNewEmail.text = @"Lifetime";
            self.scrollview.clipsToBounds = YES;
            
            self.lifetimeNewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);

            self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
            self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
            self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
            //            self.lifetimeBtn.enabled = NO;
            self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
            
            self.monthTimeLbl.textColor = [UIColor whiteColor];
            self.monthPriceLbl.textColor = [UIColor whiteColor];
            self.yearTimeLbl.textColor = [UIColor whiteColor];
            self.yearPriceLbl.textColor = [UIColor whiteColor];
            
            self.monthBg.image = [UIImage imageNamed:@"month-1"];
            self.yearBg.image = [UIImage imageNamed:@"month-1"];
            self.monthView.userInteractionEnabled = NO;
            self.yearView.userInteractionEnabled = NO;
            self.saleLbl.hidden = YES;
            self.premiumTitle.text = @"Lifetime Premium";

            self.lifetimeBtn.enabled = NO;
            self.lifetimeNewView.hidden = NO;

            [self.scrollview addSubview:self.lifetimeNewView];
            
            NSAssert(1 != 2, @"123");
        }else{
            self.scrollViewH.constant = 154;
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    self.lifetimeNewEmail.text = @"Monthly";
                    self.scrollview.clipsToBounds = NO;
                    self.monthBg.image = [UIImage imageNamed:@"yigoumai"];
                    self.monthPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.monthTimeLbl.textColor = RGBColor(122, 163, 239);
                    //            self.monthBtn.enabled = NO;
                    self.yearBg.image = [UIImage imageNamed:@"year"];
                    self.premiumTitle.text = @"Monthly Premium";
                    
                    self.lifetimeDetailLbl.textColor = [UIColor whiteColor];
                    self.lifetimePriceLbl.textColor = [UIColor whiteColor];
                    self.liteTimeLbl.textColor = [UIColor whiteColor];
                    self.yearTimeLbl.textColor = [UIColor whiteColor];
                    self.yearPriceLbl.textColor = [UIColor whiteColor];
                    self.yearDetailLbl.textColor = [UIColor whiteColor];
                    self.monthBtn.enabled = NO;
                    

                    self.upgradeNewView.hidden = NO;
                    [self.monthView addSubview:self.upgradeNewView];
                    self.upgradeTimeStyleLbl.text = @"Monthly Premium";
                    Setting* setting = [[XDDataManager shareManager] getSetting];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy.MM.dd"];
                    NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                    self.upgradeNewEndTimeLbl.text = [NSString stringWithFormat:@"%@",expiredString];
                    
                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    
                    self.scrollview.clipsToBounds = NO;
                    self.lifetimeNewEmail.text = @"Yearly";
                    self.yearBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.yearTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.yearPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.yearDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    self.monthBg.image = [UIImage imageNamed:@"month"];
                    self.premiumTitle.text = @"Yearly Premium";
                    
                    
                    self.monthTimeLbl.textColor = [UIColor whiteColor];
                    self.monthPriceLbl.textColor = [UIColor whiteColor];
                    self.lifetimeDetailLbl.textColor = [UIColor whiteColor];
                    self.lifetimePriceLbl.textColor = [UIColor whiteColor];
                    self.liteTimeLbl.textColor = [UIColor whiteColor];
                    self.yearBtn.enabled = NO;
                    
                    self.upgradeNewView.hidden = NO;
                    [self.yearView addSubview:self.upgradeNewView];
                    self.upgradeTimeStyleLbl.text = @"Yearly Premium";
                    Setting* setting = [[XDDataManager shareManager] getSetting];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy.MM.dd"];
                    NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                    self.upgradeNewEndTimeLbl.text = [NSString stringWithFormat:@"%@",expiredString];
                    
                }else{
                    
                    self.scrollview.clipsToBounds = YES;
                    self.scrollViewH.constant = 111;
                    self.lifetimeNewEmail.text = @"Lifetime";
                    self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimeDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    self.monthBg.image = [UIImage imageNamed:@"month-1"];
                    self.yearBg.image = [UIImage imageNamed:@"month-1"];
                    self.monthView.userInteractionEnabled = NO;
                    self.yearView.userInteractionEnabled = NO;
                    
                    self.monthTimeLbl.textColor = [UIColor whiteColor];
                    self.monthPriceLbl.textColor = [UIColor whiteColor];
                    self.yearTimeLbl.textColor = [UIColor whiteColor];
                    self.yearPriceLbl.textColor = [UIColor whiteColor];
                    self.yearDetailLbl.textColor = [UIColor whiteColor];
                    self.premiumTitle.text = @"Lifetime Premium";
                    self.lifetimeBtn.enabled = NO;
                    self.lifetimeNewView.hidden = NO;

                    [self.scrollview addSubview:self.lifetimeNewView];
                }
            }
        }
        
        
        self.restoreBtn.hidden = YES;
        self.restoreBtnH.constant = 0;
        
    }else{
        self.restoreBtn.hidden = NO;
        self.restoreBtnH.constant = 40;
        self.premiumTitle.text = @"Upgrade to Premium";
        self.scrollViewH.constant = 154;

        self.scrollview.clipsToBounds = NO;
        self.monthBtn.enabled = YES;
        self.yearBtn.enabled = YES;
        self.lifetimeBtn.enabled = YES;
        self.lifetimeNewView.hidden = YES;

    }
    
    [self.view layoutSubviews];
}

//获取保存在本地的商品价格，显示
-(void)preVersionPrice
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *monthPrice = [userDefaults stringForKey:PURCHASE_PRICE_MONTH];
    NSString *yearPrice = [userDefaults stringForKey:PURCHASE_PRICE_YEAR];
    NSString *lifetimePrice = [userDefaults stringForKey:PURCHASE_PRICE_LIFETIME];
    
    double sale = [userDefaults doubleForKey:@"salePrice"];
    
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

- (IBAction)cancelClick:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.xxdDelegate respondsToSelector:@selector(XDUpgradeViewDismiss)]) {
        [self.xxdDelegate XDUpgradeViewDismiss];
    }
}

- (IBAction)monthBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [FIRAnalytics logEventWithName:@"attemp_to_buy_monthly" parameters:@{@"user_action":@"attemp_to_buy_monthly"}];
    
    [[XDInAppPurchaseManager shareManager] purchaseUpgrade:KInAppPurchaseProductIdMonth];
    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_month_subscribe"];
}

- (IBAction)yearBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
 
    [FIRAnalytics logEventWithName:@"attemp_to_buy_yearly" parameters:@{@"user_action":@"attemp_to_buy_yearly"}];
    
    [[XDInAppPurchaseManager shareManager] purchaseUpgrade:KInAppPurchaseProductIdYear];

    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_year_subscribe"];
}

- (IBAction)lifetimeClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    [FIRAnalytics logEventWithName:@"attemp_to_buy_lifetime" parameters:@{@"user_action":@"attemp_to_buy_lifetime"}];

    [[XDInAppPurchaseManager shareManager] purchaseUpgrade:kInAppPurchaseProductIdLifetime];

    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"22_SETAD_BUY"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 100;
    }
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
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
    }else if (indexPath.row == 5){
        return self.budgetCell;
    }else
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 80)];
        NSString* string  = @"Your iTunes account will be charged as soon as you confirm the Premium purchase. Your subscription will auto renew unless cancelled at least 24 hours before the end of the current period. Manage your subscriptions in the iTunes Store after purchase. By upgrading to premium you accept our ";
        textView.editable = NO;
        textView.delegate = self;
        NSDictionary *dictionary = @{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:10],NSForegroundColorAttributeName:RGBColor(200, 200, 200)};
        NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:string attributes:dictionary];
        
        NSDictionary *dictionary2 = @{NSFontAttributeName:[UIFont fontWithName:FontSFUITextRegular size:10],NSForegroundColorAttributeName:RGBColor(200, 200, 200),NSUnderlineStyleAttributeName:@3};
        NSString* privacyStr = @"Privacy Policy";
        NSMutableAttributedString * privacymuStr =[[NSMutableAttributedString alloc]initWithString:privacyStr attributes:dictionary2];
        [privacymuStr addAttribute:NSLinkAttributeName value:@"https://www.iubenda.com/privacy-policy/7775087" range:[privacyStr rangeOfString:@"Privacy Policy"]];
        
        NSString* termStr = @"Terms of use";
        NSMutableAttributedString * termMuStr =[[NSMutableAttributedString alloc]initWithString:termStr attributes:dictionary2];
        [termMuStr addAttribute:NSLinkAttributeName value:@"https://www.iubenda.com/Terms-of-ues/7775087" range:[termStr rangeOfString:@"Terms of use"]];
        
        [attributeStr appendAttributedString:privacymuStr];
        [attributeStr appendAttributedString:[[NSAttributedString alloc]initWithString:@" and " attributes:dictionary]];
        [attributeStr appendAttributedString:termMuStr];
        [attributeStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"." attributes:dictionary]];
        
        textView.attributedText = attributeStr;
        
        
        [view addSubview:textView];
        [self.lastCell.contentView addSubview:view];
        return self.lastCell;
    }
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL isEqual:[NSURL URLWithString:@"https://www.iubenda.com/Terms-of-ues/7775087"]]) {
        XDTermsOfUseViewController* vc = [[XDTermsOfUseViewController alloc]initWithNibName:@"XDTermsOfUseViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];

        return NO;
    }
    return YES;
}

@end

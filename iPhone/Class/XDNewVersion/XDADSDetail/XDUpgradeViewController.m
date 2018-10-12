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

@end

@implementation XDUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = SCREEN_WIDTH/3;
    
    self.monthView.frame = CGRectMake(0, 0, width, self.scrollview.height);
    self.yearView.frame = CGRectMake(width, 0, width, self.scrollview.height);
    self.lifetimeView.frame = CGRectMake(width * 2, 0, width, self.scrollview.height);

   
    
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

//    [self.tableview setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        Setting* setting = [[XDDataManager shareManager] getSetting];
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
            
        }else{
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    self.monthBg.image = [UIImage imageNamed:@"yigoumai"];
                    self.monthPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.monthTimeLbl.textColor = RGBColor(122, 163, 239);
                    //            self.monthBtn.enabled = NO;
                    
                    self.yearBg.image = [UIImage imageNamed:@"year"];
                    self.premiumTitle.text = @"Monthly Premium";

                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    self.yearBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.yearTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.yearPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.yearDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    //            self.yearBtn.enabled = NO;
                    self.monthBg.image = [UIImage imageNamed:@"month"];
                    self.premiumTitle.text = @"Yearly Premium";

                }else{
                    self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
                    //            self.lifetimeBtn.enabled = NO;
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
                    self.premiumTitle.text = @"Lifetime Premium";

                }
            }
        }
       
        
        self.restoreBtn.hidden = YES;
        self.restoreBtnH.constant = 0;
    }else{
        self.restoreBtn.hidden = NO;
        self.restoreBtnH.constant = 40;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccessful) name:@"purchaseSuccessful" object:nil];
  
}

-(void)purchaseSuccessful{
    [self settingReloadData];
}

- (IBAction)restoreBtnClick:(id)sender {
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [appDelegate.inAppPM restorePurchase];
    [[XDInAppPurchaseManager shareManager]restoreUpgrade];
}

-(void)settingReloadData{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased) {
        Setting* setting = [[XDDataManager shareManager] getSetting];
        BOOL defaults2 = [[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG] ;
        
        if (defaults2) {
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

        }else{
            NSString* proID = setting.purchasedProductID;
            if ([setting.purchasedIsSubscription boolValue]) {
                if ([proID isEqualToString:KInAppPurchaseProductIdMonth]) {
                    self.monthBg.image = [UIImage imageNamed:@"yigoumai"];
                    self.monthPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.monthTimeLbl.textColor = RGBColor(122, 163, 239);
                    //            self.monthBtn.enabled = NO;
                    self.yearBg.image = [UIImage imageNamed:@"year"];
                    self.premiumTitle.text = @"Monthly Premium";

                }else if ([proID isEqualToString:KInAppPurchaseProductIdYear]){
                    self.yearBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.yearTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.yearPriceLbl.textColor = RGBColor(122, 163, 239);
                    self.yearDetailLbl.textColor = [UIColor colorWithRed:122/255. green:163/255. blue:239/255. alpha:0.5];
                    self.saleLbl.hidden = YES;
                    //            self.yearBtn.enabled = NO;
                    self.monthBg.image = [UIImage imageNamed:@"month"];
                    self.premiumTitle.text = @"Yearly Premium";

                }else{
                    self.lifetimeBg.image = [UIImage imageNamed:@"yigoumai2"];
                    self.liteTimeLbl.textColor = RGBColor(122, 163, 239);
                    self.lifetimePriceLbl.textColor = RGBColor(122, 163, 239);
                    //            self.lifetimeBtn.enabled = NO;
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
                    self.premiumTitle.text = @"Lifetime Premium";

                }
            }
        }
        
        
        self.restoreBtn.hidden = YES;
        self.restoreBtnH.constant = 0;
        
    }else{
        self.restoreBtn.hidden = NO;
        self.restoreBtnH.constant = 40;
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
}

- (IBAction)monthBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//
//    if ([appDelegate.inAppPM canMakePurchases])
//    {
//        [appDelegate.inAppPM  purchaseUpgrade:KInAppPurchaseProductIdMonth];
//    }
//
    [[XDInAppPurchaseManager shareManager] purchaseUpgrade:KInAppPurchaseProductIdMonth];
    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_month_subscribe"];
}

- (IBAction)yearBtnClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
//    if ([appDelegate.inAppPM canMakePurchases])
//    {
//        [appDelegate.inAppPM  purchaseUpgrade:KInAppPurchaseProductIdYear];
//    }
    [[XDInAppPurchaseManager shareManager] purchaseUpgrade:KInAppPurchaseProductIdYear];

    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"Purchase_year_subscribe"];
}

- (IBAction)lifetimeClick:(id)sender {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
//    if ([appDelegate.inAppPM canMakePurchases])
//    {
//        [appDelegate.inAppPM  purchaseUpgrade:kInAppPurchaseProductIdLifetime];
//    }
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

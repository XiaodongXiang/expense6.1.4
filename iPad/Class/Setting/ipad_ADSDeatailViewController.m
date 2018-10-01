//
//  ipad_ADSDeatailViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-2.
//
//

#import "ipad_ADSDeatailViewController.h"
#import "AppDelegate_iPad.h"

#define GET_PRO_VERSION_PRICE_ACTION           @"Get_Pro_Version_Price_Action"
#define PURCHASE_PRICE                          @"PurchasePirce"

@interface ipad_ADSDeatailViewController ()

@end

@implementation ipad_ADSDeatailViewController
@synthesize pageNum,imageContainScrollView,imageView_expoerData,imageView_syncData,imageView_backup,pageControl,backBtn1,priceLabel;
@synthesize purchaseBtn,restoreBtn,isComeFromSetting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//重写方法，去掉背景
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.superview.backgroundColor = [UIColor clearColor];
    self.view.superview.layer.shadowColor = [[UIColor clearColor] CGColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.purchaseBtn  setTitle:NSLocalizedString(@"VC_Upgrade Now", nil) forState:UIControlStateNormal];
    [self.restoreBtn setTitle:NSLocalizedString(@"VC_RestorePurchased", nil) forState:UIControlStateNormal];
    
    self.imageContainScrollView.contentSize = CGSizeMake(imageContainScrollView.frame.size.width*2,0);
    self.imageContainScrollView.contentOffset = CGPointMake(imageContainScrollView.frame.size.width*pageNum, 0);
    self.pageControl.currentPage = pageNum;
    self.pageControl.numberOfPages = 2;
    
    [backBtn1 addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceLabel.transform = CGAffineTransformMakeRotation(90*M_PI_2/180);
    self.priceLabel.center = CGPointMake(self.priceLabel.frame.size.width/2+self.priceLabel.frame.origin.x+10, 80/2+self.priceLabel.frame.origin.y + 2);
    [self preVersionPrice:nil];
    //添加观察通知，当获取到价格的时候就将价格显示出来
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(preVersionPrice:) name:GET_PRO_VERSION_PRICE_ACTION object:nil];
    
    purchaseBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [purchaseBtn.titleLabel setMinimumScaleFactor:0];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (isComeFromSetting)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"22_SETAD_BUY"];
    }
    else
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"22_AD_BUY"];
    }
}

//获取保存在本地的商品价格，显示
-(void)preVersionPrice:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *purchasePrice = [userDefaults stringForKey:PURCHASE_PRICE];
    if ([purchasePrice length]>0)
    {
        self.priceLabel.text = purchasePrice;
    }
    else
        self.priceLabel.text = nil;
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    AppDelegate_iPad *appDelegate = [[UIApplication sharedApplication]delegate];
//    if (appDelegate.mainViewController.iSettingViewController!=nil)
//    {
//        [appDelegate.mainViewController.iSettingViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
//
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i=(scrollView.contentOffset.x+1)/imageContainScrollView.frame.size.width;
    pageControl.currentPage = i;
}

#pragma mark Btn Action
-(void)backBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(IBAction)updateBtnPressed:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id830063876?mt=8"]];
//}

-(IBAction)purchaseBtnPressed
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate.inAppPM canMakePurchases])
    {
        [appDelegate.inAppPM  purchaseProUpgrade];
    }
    [appDelegate.epnc setFlurryEvent_withUpgrade:YES];

}

-(IBAction)restoreBtnPressed
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.inAppPM  restorePurchase];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

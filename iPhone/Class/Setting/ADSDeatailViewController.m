//
//  ADSDeatailViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-7-2.
//
//

#import "ADSDeatailViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define GET_PRO_VERSION_PRICE_ACTION           @"Get_Pro_Version_Price_Action"
#define PURCHASE_PRICE                          @"PurchasePirce"




@interface ADSDeatailViewController ()

@end

@implementation ADSDeatailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self initPoint];
    
}

-(void)initPoint
{
    [self.purchaseBtn setTitle:NSLocalizedString(@"VC_Upgrade Now", nil) forState:UIControlStateNormal];
    [self.restoreBtn setTitle:NSLocalizedString(@"VC_RestorePurchased", nil) forState:UIControlStateNormal];
    [_backBtn1 addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self preVersionPrice:nil];
    //添加观察通知，当获取到价格的时候就将价格显示出来
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(preVersionPrice:) name:GET_PRO_VERSION_PRICE_ACTION object:nil];
    
    //更新产品信息
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.inAppPM.proUpgradeProduct == nil)
    {
        [appDelegate.inAppPM loadStore];
    }
    
    _purchaseBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_purchaseBtn.titleLabel setMinimumScaleFactor:0];
    
    if(_isComeFromSetting)
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"22_SETAD_BUY"];
    }
    else
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"22_AD_BUY"];
    }

    
    
    self.bgImage.alpha = 0;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, 600, _contentView.frame.size.width, _contentView.frame.size.height);

    if (IS_IPHONE_6PLUS)
    {
        _contentView.frame = CGRectMake(6, _contentView.frame.origin.y, 386, 546);
        _imageContainScrollView.frame = CGRectMake(_imageContainScrollView.frame.origin.x, 90, 366, _imageContainScrollView.frame.size.height);
        _priceImage.frame = CGRectMake(_contentView.frame.size.width-60-2, 20, 60, 60);
        _pageControl.frame = CGRectMake(6, _pageControl.frame.origin.y, _pageControl.frame.size.width-5, _pageControl.frame.size.height);
        _priceLabel.frame = CGRectMake(_contentView.frame.size.width-_priceLabel.frame.size.width, 29, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
        self.priceLabel.transform = CGAffineTransformMakeRotation(90*M_PI_2/180);
        self.priceLabel.center = self.priceLabel.center;

    }
    else if (IS_IPHONE_6)
    {
        _contentView.frame = CGRectMake(4, _contentView.frame.origin.y, 352, 495);
        _imageContainScrollView.frame = CGRectMake(_imageContainScrollView.frame.origin.x, 85, 332, _imageContainScrollView.frame.size.height);
        _priceImage.frame = CGRectMake(_contentView.frame.size.width-56, 20, 54, 54);
        _priceLabel.frame = CGRectMake(_priceLabel.frame.origin.x, 27, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
        _pageControl.frame = CGRectMake(6, _pageControl.frame.origin.y, _pageControl.frame.size.width-5, _pageControl.frame.size.height);
        self.priceLabel.transform = CGAffineTransformMakeRotation(90*M_PI_2/180);
        self.priceLabel.center = self.priceLabel.center;
 
    }
    else if (IS_IPHONE_5)
    {
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, 303, 442);
        _imageContainScrollView.frame = CGRectMake(_imageContainScrollView.frame.origin.x, 76, 283, _imageContainScrollView.frame.size.height);
        _priceImage.frame = CGRectMake(255, 20, 46, 46);
        self.priceLabel.transform = CGAffineTransformMakeRotation(90*M_PI_2/180);
        self.priceLabel.center = self.priceLabel.center;
        _priceLabel.frame = CGRectMake(_contentView.frame.size.width-_priceLabel.frame.size.width, 27, _priceLabel.frame.size.width, _priceLabel.frame.size.height);

    }
    else
    {
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, 303, 442);
        _imageContainScrollView.frame = CGRectMake(_imageContainScrollView.frame.origin.x, 76, 283, _imageContainScrollView.frame.size.height);
        _priceImage.frame = CGRectMake(255, 20, 46, 46);
        self.priceLabel.transform = CGAffineTransformMakeRotation(90*M_PI_2/180);
        self.priceLabel.center = self.priceLabel.center;
    }
    _contentBg.image = [UIImage imageNamed:[NSString customImageName:@"detail_bg_iphone.png"]];
    _page1_imageview.image = [UIImage imageNamed:[NSString customImageName:@"full_version_iphone3.png"]];
    _page2_imageview.image = [UIImage imageNamed:[NSString customImageName:@"full_version_iphone2.png"]];
    _priceImage.image = [UIImage imageNamed:[NSString customImageName:@"money_iphone.png"]];

    
    _page1_imageview.frame = CGRectMake(0, 0, _imageContainScrollView.frame.size.width, _imageContainScrollView.frame.size.height);
    _page2_imageview.frame = CGRectMake(_imageContainScrollView.frame.size.width, 0, _imageContainScrollView.frame.size.width, _imageContainScrollView.frame.size.height);
    
    self.imageContainScrollView.contentSize = CGSizeMake((_contentView.frame.size.width-20)*2, self.imageContainScrollView.frame.size.height);
    self.imageContainScrollView.contentOffset = CGPointMake((_contentView.frame.size.width-20)*_pageNum, 0);
    self.pageControl.currentPage = _pageNum;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self contentViewAppear];
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



-(void)contentViewAppear
{
    [UIView  animateWithDuration:0.25 animations:^{
        self.bgImage.alpha=0.7;
        if (IS_IPHONE_4)
        {
            _contentView.frame = CGRectMake(_contentView.frame.origin.x, 13, _contentView.frame.size.width, _contentView.frame.size.height);

        }
        else
        {
            _contentView.frame = CGRectMake(_contentView.frame.origin.x, 63, _contentView.frame.size.width, _contentView.frame.size.height);
        }
    }];
}

-(void)contentViewDisAppear
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgImage.alpha=0;
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, 600, _contentView.frame.size.width, _contentView.frame.size.height);
    } completion:^(BOOL finished)
    {
        [self.view removeFromSuperview];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i=(scrollView.contentOffset.x+1)/_imageContainScrollView.frame.size.width ;
    _pageControl.currentPage = i;
}



#pragma mark btn Action
-(void)backBtnPressed:(id)sender
{
    [self contentViewDisAppear];
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

//
//  AppDelegate_iPad.m
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "ApplicationDBVersion.h"
#import "GTMBase64.h"
#import "ZipArchive.h"
#import <sqlite3.h>

#import "OverViewWeekCalenderViewController.h"
#import <Dropbox/Dropbox.h>
#import "EPNormalClass.h"

#import "Payee.h"
#import "Category.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "Setting+CoreDataClass.h"

#import "DropboxObject.h"
#import "Flurry.h"

#import "PasscodeCheckViewController_iPhone.h"
#import <Crashlytics/Crashlytics.h>

#import "BudgetViewController.h"
#import "TransactionEditViewController.h"
#import "KalViewController_week.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#define OLDUSERDATA @"oldUserData"
#define FIRSTLAUNCHSINCEBACKUPOLDUSERDATA @"FirstLanchSinceBackupOldUserData"
#import "User.h"
#import "ParseDBManager.h"
#import "Accounts.h"

#import "menuViewController.h"
#import "SignViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "NSStringAdditions.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "XDTabbarViewController.h"

#import "XDSignInViewController.h"
#import "AccountSearchViewController.h"
#import "XDAddTransactionViewController.h"
#import "XDFirstPromptViewController.h"

#import "XDUpgradeViewController.h"
#import <objc/runtime.h>


@import Firebase;

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface AppDelegate_iPhone ()<PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UIAlertViewDelegate>
{
    UIApplicationShortcutItem* _shortItem;
}
@property(nonatomic, strong) ADEngineController* interstitial;

@end

@implementation AppDelegate_iPhone

#pragma mark Background handle data

//设置数据库中的 setting
-(void)afterpassword
{
	dayFormatter = [[NSDateFormatter alloc] init];
	[dayFormatter setDateFormat:@"dd"];
	backupList = [[NSMutableArray alloc] init];
	NSManagedObjectContext* context = self.managedObjectContext;
	NSError* errors = nil;
	//get unit from database's Setting
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Setting"
												  inManagedObjectContext:context];
	[request setEntity:entityDesc];
    
	NSArray *objects = [context executeFetchRequest:request error:&errors];
	NSMutableArray *mutableObjects = [[NSMutableArray alloc] initWithArray:objects];
	long count = [mutableObjects count];
    
	if(count == 0)
	{
		self.settings = [NSEntityDescription insertNewObjectForEntityForName:@"Setting"
													  inManagedObjectContext:context];
		settings.passcode = nil;
        settings.isBefore = [NSNumber numberWithBool:FALSE];
		settings.currency = @"$ - US Dollar";
		settings.weekstartday = @"Sunday";
        settings.expDRString =@"Month";
        
        settings.budgetNewStyle = [NSNumber numberWithBool:YES];
        settings.payeeCategory = [NSNumber numberWithBool:YES];
        settings.payeeName = [NSNumber numberWithBool:YES];
        settings.payeeMemo = [NSNumber numberWithBool:FALSE];
        settings.payeeTranAmount = [NSNumber numberWithBool:YES];
        settings.payeeTranClear = [NSNumber numberWithBool:FALSE];
        settings.payeeTranType = [NSNumber numberWithBool:YES];
        settings.budgetNewStyleCycle =@"Month";
        settings.syncAuto = @YES;
        //记录当前版本号
        settings.others20 = @"5.0";
        //设置当前的版本号
        
		ApplicationDBVersion *adbv = [NSEntityDescription insertNewObjectForEntityForName:@"ApplicationDBVersion"
																   inManagedObjectContext:context];
		adbv.versionNumber =@"1.0.2";

        
		if(![context save:&errors])
		{
			NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
		}
		[epnc setCurrenyStrBySettings];
        [epnc setDBVerString];
        
		[epdc initializeAccountType];
        [epdc initializeCategory];

 	}
	else
	{
 		self.settings = [mutableObjects objectAtIndex:0];
        if(self.settings.isBefore == nil)        settings.isBefore = [NSNumber numberWithBool:FALSE];
        if([self.settings.expDRString length] == 0)     settings.expDRString =@"Month";
        
        if(self.settings.budgetNewStyle == nil)        settings.budgetNewStyle = [NSNumber numberWithBool:FALSE];
        
        if(self.settings.payeeCategory== nil)        settings.payeeCategory = [NSNumber numberWithBool:YES];
        if(self.settings.payeeName == nil)        settings.payeeName = [NSNumber numberWithBool:YES];
        
        if(self.settings.payeeMemo == nil)        settings.payeeMemo = [NSNumber numberWithBool:FALSE];
        if(self.settings.payeeTranAmount == nil)        settings.payeeTranAmount = [NSNumber numberWithBool:YES];
        if(self.settings.payeeTranClear == nil)        settings.payeeTranClear = [NSNumber numberWithBool:FALSE];
        if(self.settings.payeeTranType == nil)        settings.payeeTranType = [NSNumber numberWithBool:YES];
//        if(self.settings.syncAuto == NO)     settings.syncAuto = @YES;
        
        if([self.settings.budgetNewStyleCycle length] == 0)     settings.budgetNewStyleCycle =@"Month";
        
        [epnc setCurrenyStrBySettings];
        [epnc setDBVerString];
        
		[epdc CheckCategoryErrorIcon];
		[epdc CheckAccountTypeErrorName];
		[epdc AddCategory_V100ToV101];
		[epdc autoGenCategoryDataRelationShip];
        [epdc CheckErrorCategoryBudgetRelation];
        [epdc CheckErrorBudget];
        

        [self.epdc checkCategorytoChangeNotsureCategory];

	}


    
 	
}


/*
-(void)checkCategorytoChangeNotsureCategory{
    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

	NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
	NSError *error=nil;
	NSArray*tmpCategoryArray= [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
	
    for (int i=0; i<[tmpCategoryArray count]; i++) {
        Category *oneCategory = [tmpCategoryArray objectAtIndex:i];
        if ([oneCategory.categoryName isEqualToString:@"Not Sure"]) {
            oneCategory.categoryName = @"Others";
//            [self.managedObjectContext save:&error];
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            return;
        }
    }
    
}
*/
#pragma mark Application lifecycle
//这一步跑完了之后才会继续跑数据模型那里
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse enableLocalDatastore];

    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"BI4p05Rax27kKCV7Q00o9wJnNgPTBbDHsHVRgCTM";
        configuration.clientKey =@"Y5pqvDEtUEJYtUgC53OIRbkSU0RE8SB4qfrSUl6e";
        configuration.server = @"http://pocketexpense-master-ios.us-east-1.elasticbeanstalk.com/parse";
        configuration.networkRetryAttempts = 1;
    }]];

     [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Fabric with:@[[Crashlytics class]]];
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    //适配比例
    if(ScreenHeight > 480)
    {
        self.autoSizeScaleX = ScreenWidth/320;
        self.autoSizeScaleY = ScreenHeight/568;
    }
    else
    {
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    _isNeedCalData = TRUE;
    accountArray = [[NSMutableArray alloc]init];
    epdc = [[EPDataBaseModifyClass alloc] init];
    epnc = [[EPNormalClass alloc] init];
    hasPWDView = FALSE;
    

    //设置数据库中默认的setting信息
    [self afterpassword];
    
    //免费版升级得时候，首先判断有没有expense1.0.0的数据库，有的话，就需要将数据库搬过来，然后删除老的数据库。
    [self.epdc getOldDataBaseInsertToNewDataBase_isBackup:NO];
    //设置版本的标识 4.5/5.3/5.4
    [self.epdc setFreeVersionBelongtoWhichVersionIdentification];
    
    [window makeKeyAndVisible];
   
    
    //others20是一个标识，标识5.0以前的版本，与之后的版本分割符（1）5.0以前需要设置account order,recurring type,category type,sync
    if (!([settings.others20 isEqualToString:@"4.5.1"] || [settings.others20 isEqualToString:@"5.0"]))
    {
        [self.epdc setAccountOrderIndex];
        [self.epdc setTransactionType];
    }
    
    //给所有的表格设置 state uuid dateTime
    if (![settings.others20 isEqualToString:@"5.0"])
    {
        [self.epdc changeTransactionRecurringType];
        //更改category的属性：EXPENSE,INCOME
        [self.epdc setCategoryTransactionType];
        [self.epdc setAllLocalTables_state_uuid_DateTime];
    }
    
    //因为5.2ipad版之前的版本添加transaction的时候，没有添加uuid,所以当用户是升级的时候，判断如果是5.2之前的版本就需要更新transaction,因为iphone版没有这个问题，所以不需要修改。当是5.2版本之前的就会提示是覆盖还是交互
    if (![settings.others18 isEqualToString:@"5.2"])
    {
        NSError *error = nil;
        [self.epdc setTransactionTable_UUID_5_2VersionOnly];
        settings.others18 = @"5.2";
        [self.managedObjectContext save:&error];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
        //如果设备上有版本号，就说明，这个版本是老的
        if (trackingVersion != nil)
        {
            //当对老数据解析完成以后，插入一个标记，以后打开的话，就提醒是覆盖还是交互
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA forKey:OLDUSERDATA];
        }
    }
    
    
    
    
    //如果是新用户的话，就创建一个default的账户
    if (![settings.others20 isEqualToString:@"5.0"]) {
        settings.others20 = @"5.0";
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        
    }
    else
    {
//        [self.epdc createDefaultAccount];
    }
    
    [self loadHMJIndicator];
    
    //设置自动同步关闭
    NSError *error;
    if (self.settings.syncAuto==nil)
    {
        self.settings.syncAuto=NO;
        [self.managedObjectContext save:&error];
        self.autoSyncOn=NO;
    }
    else
    {
        //        self.autoSyncOn=self.settings.syncAuto;
        NSNumber *syncAuto=self.settings.syncAuto;
        if ([syncAuto isEqualToNumber:[NSNumber numberWithBool:YES]])
        {
            self.autoSyncOn=YES;
        }
        else
        {
            self.autoSyncOn=NO;
        }
    }
    


    

    
    if ([PFUser currentUser])
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *userArray=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
        if (userArray.count)
        {
            
        }
        else
        {
            //创建user
            User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
            user.userObjectId=[[PFUser currentUser]objectId];
            [self.managedObjectContext save:&error];
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error2;

            //头像下载
            PFUser *serverUser=[PFUser currentUser];
            PFFile *avatarFile=serverUser[@"avatar"];
            NSData *avatarData=[avatarFile getData:&error2];
            
            if (error)
            {
                NSLog(@"头像下载错误 %@",error);
            }
            
            //写入本地
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
            [avatarData writeToFile:imageFile atomically:YES];
            
            
        });
        
//        UIImage *avatarImage=[UIImage imageWithData:avatarData];

        XDTabbarViewController* tabbarVc = [[XDTabbarViewController alloc]init];

//        _overViewController=[[OverViewWeekCalenderViewController alloc]init];
//        _navCtrl=[[UINavigationController alloc]initWithRootViewController:_overViewController];
//
//        _menuVC=[[menuViewController alloc]init];
//        _menuVC.navigationControllerArray=[NSMutableArray arrayWithObjects:_navCtrl,@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
//        _drawerVC=[[MMDrawerController alloc]initWithCenterViewController:_navCtrl leftDrawerViewController:_menuVC];
//
//        [_menuVC setAvatarImage:avatarImage];
//
//        //drawController设置
//        _drawerVC.showsShadow=NO;
//        _drawerVC.maximumLeftDrawerWidth=MENU_WIDTH;
//
//        [_drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        
        self.window.rootViewController=tabbarVc;
    }
    else
    {
        self.window.rootViewController=[[XDSignInViewController alloc]initWithNibName:@"XDSignInViewController" bundle:nil];
    }
    //数据修复，4.5.1交易的transfer,还有category
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]dataSyncWithServer];
            [[XDPurchasedManager shareManager] getPFSetting];

        }
    });
    //处理budget更新，自动插入transaction
    [self handleDate];
    
    //indicator
    dropbox = [[DropboxObject alloc]init];
    [self initCustomerTabarStyle];

    
    
    if ([PFUser currentUser]) {
        //touch ID
        LAContext *context=[LAContext new];
        context.localizedFallbackTitle=@"";
        if ([self.settings.passcodeStyle isEqualToString:@"touchid"])
        {
            _touchBack=[[touchIDView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.window addSubview:_touchBack];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passcodeAgain)];
            [_touchBack addGestureRecognizer:tap];
            [self.window bringSubviewToFront:_touchBack];
            NSError *error;
            BOOL *touchIDOpen=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
            if (touchIDOpen==NULL)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
                [_touchBack removeFromSuperview];
            }
            [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?@"Face ID":@"Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_touchBack removeFromSuperview];
                    });
                }else{
                    NSLog(@"error = %@ ,, code == %d",error,error.code);
                }
                if(error.code == LAErrorAuthenticationFailed){
                    NSLog(@"Authentication Failed");
                    
                    
                    
                }
            }];
        }
    }
    
    //密码
    _passCodeCheckView = [[PasscodeCheckViewController_iPhone alloc] initWithNibName:@"PasscodeCheckViewController_iPhone" bundle:nil];
    if([self.settings.passcodeStyle isEqualToString:@"number"])
    {
        _passCodeCheckView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,[[UIScreen mainScreen]bounds].size.height);
        [self.window addSubview:_passCodeCheckView.view];
        hasPWDView = TRUE;
    }
  

    
    app_reminderBill1Array =[[NSMutableArray alloc]init];
    app_reminderBill2Array = [[NSMutableArray alloc]init];
    app_reminderAllArray =[[NSMutableArray alloc]init];
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];

    //添加观察通知，当获取到价格的时候就将价格显示出来
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(preVersionPrice:) name:GET_PRO_VERSION_PRICE_ACTION object:nil];
    [notificationCenter addObserver:self selector:@selector(hideCustomTabView) name:@"ADMOB_ADS_HIDE" object:nil];
    [notificationCenter addObserver:self selector:@selector(showCustomTabView) name:@"ADMOB_ADS_SHOW" object:nil];
    
    //插页广告
    if ([PFUser currentUser]) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1201 - iPhone - Interstitial - Launch"];
            [self.interstitial nowShowInterstitialAdWithTarget:self.window.rootViewController];
        }
    }
    return YES;
}






///
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    NSString* appName = [[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"://"] firstObject];
    NSString* function = [[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"://"] lastObject];
    
    if ([function isEqualToString:@"addTransaction"])
    {
        
        if ([PFUser currentUser]) {
            UIViewController *viewControllers = self.window.rootViewController;
            if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
                XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
                addVc.calSelectedDate = [[NSDate date] initDate];
                if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[XDAddTransactionViewController class]]) {
                    [[self getCurrentVCFrom:viewControllers] presentViewController:addVc animated:YES completion:^{
                    }];
                }
            }
        }
    }else if ([function isEqualToString:@"purchased"]){
        UIViewController *viewControllers = self.window.rootViewController;
        if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
            XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
            if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[XDAddTransactionViewController class]]) {
                [[self getCurrentVCFrom:viewControllers] presentViewController:adsVc animated:YES completion:^{
                }];
            }
        }
        
    }
    return false;
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
    if ([PFUser currentUser]) {
        
        
        [[XDDataManager shareManager] fixStateIsZeroBug];
        
        [[XDDataManager shareManager] uploadLocalTransaction];
        
        
        //touch ID
        LAContext *context=[LAContext new];
        context.localizedFallbackTitle=@"";
        if ([self.settings.passcodeStyle isEqualToString:@"touchid"])
        {
            _touchBack=[[touchIDView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passcodeAgain)];
            [_touchBack addGestureRecognizer:tap];
            [self.window addSubview:_touchBack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSError *error;
                BOOL *touchIDOpen=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
                if (touchIDOpen==NULL)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
                    [_touchBack removeFromSuperview];
                    
                    //插页广告
                    if ([PFUser currentUser]) {
                        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
                        if (!appDelegate.isPurchased) {
                            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1201 - iPhone - Interstitial - Launch"];
                            [self.interstitial nowShowInterstitialAdWithTarget:[self getCurrentVC]];
                        }
                    }
                    
                }
                [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?@"Face ID":@"Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [_touchBack removeFromSuperview];
                            
                            //插页广告
                            if ([PFUser currentUser]) {
                                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
                                if (!appDelegate.isPurchased) {
                                    self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1201 - iPhone - Interstitial - Launch"];
                                    [self.interstitial nowShowInterstitialAdWithTarget:[self getCurrentVC]];
                                }
                            }
                            
                        });
                    }
                    if(error.code == LAErrorAuthenticationFailed){
                        NSLog(@"Authentication Failed");
                        
                    }
                    
                    
                }];
            });
        }else{
            //插页广告
            if ([PFUser currentUser]) {
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
                if (!appDelegate.isPurchased) {
                    self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1201 - iPhone - Interstitial - Launch"];
                    [self.interstitial nowShowInterstitialAdWithTarget:[self getCurrentVC]];
                }
            }
            
        }
    }
    
    [super applicationWillEnterForeground:application];
    
    [self.close_PopView removeFromSuperview];
    [self handleDate];
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
    

    if (_calendarBtn.selected)
    {
        if (!_overViewController.isShowMonthCalendar)
        {
            _overViewController.calViewController.view.hidden = YES;
        }
    }
    
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]dataSyncWithServer];
        [[XDPurchasedManager shareManager] getPFSetting];
        
        
    }
    
   
}



-(void)passcodeAgain{
    //touch ID
    LAContext *context=[LAContext new];
    context.localizedFallbackTitle=@"";
    
    NSError *error;
    BOOL *touchIDOpen=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
    if (touchIDOpen==NULL)
    {
//        [_touchBack removeFromSuperview];
    }
    [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?@"Face ID":@"Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockSuccess" object:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_touchBack removeFromSuperview];
            });
        }
        
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[ADEngineManage adEngineManage] downloadConfigByAppName:@"Pocket Expense"];

    
    [_touchBack removeFromSuperview];
    [self saveContext];
    _isNeedCalData = TRUE;
    
    [self hidePopView];
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
    


    if([self.settings.passcodeStyle isEqualToString:@"number"] > 0)
    {
        [self.passCodeCheckView.view removeFromSuperview];
        _passCodeCheckView.txtP1.background = [UIImage imageNamed:@"password1.png"];
        _passCodeCheckView.txtP2.background = [UIImage imageNamed:@"password1.png"];
        _passCodeCheckView.txtP3.background = [UIImage imageNamed:@"password1.png"];
        _passCodeCheckView.txtP4.background = [UIImage imageNamed:@"password1.png"];
		_passCodeCheckView.txtPasscode.text = @"";
		[_passCodeCheckView.txtPasscode becomeFirstResponder];
 		[self.window addSubview:_passCodeCheckView.view];
    }

    
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0){
    
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    
//    NSLog(@"applicationDidEnterBackgroundrootVC == %@   ---- %@",rootVC,[self getCurrentVC]);
    NSString *className = [NSString stringWithUTF8String:class_getName([rootVC class])];

    if ([className isEqualToString:@"CKSMSComposeController"]) {
        [rootVC dismissViewControllerAnimated:YES completion: nil];
    }
    
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

//- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
//{
//    UIViewController *currentVC;
//
//    if ([rootVC presentedViewController]) {
//        // 视图是被presented出来的
//
//        rootVC = [rootVC presentedViewController];
//    }
//
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        // 根视图为UITabBarController
//
//        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
//
//    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
//        // 根视图为UINavigationController
//
//        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
//
//    } else {
//        // 根视图为非导航类
//
//        currentVC = rootVC;
//    }
//
//    return currentVC;
//}


///////当输入 dropbox账户的时候成功的时候就会自动回到应用程序中去
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)urls sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [super application:application openURL:urls sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

-(void)deleteCutemFile
{
	NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* path=[paths objectAtIndex:0];
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
	
	NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	
	for (NSString *fname in array)
    {
		if([fname compare:@"Update.zip"]==NSOrderedSame)
		{
			[fileManager removeItemAtPath:fname error:nil];
		}
	}
	
}

#pragma Custom Action
-(void)initCustomerTabarStyle
{
    
    [_calendarBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_calendar.png"]] forState:UIControlStateNormal];
    [_calendarBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_calendar_sel.png"]] forState:UIControlStateSelected];
    [_calendarBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_calendar_sel.png"]] forState:UIControlStateHighlighted];
    
    [_accountBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_account.png"]] forState:UIControlStateNormal];
    [_accountBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_account_sel.png"]] forState:UIControlStateSelected];
    [_accountBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_account_sel.png"]] forState:UIControlStateHighlighted];
    
    [_addBtn setImage:[UIImage imageNamed:@"main_add.png"] forState:UIControlStateNormal];

    [_budgetBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_budget.png"]] forState:UIControlStateNormal];
    [_budgetBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_budget_sel.png"]] forState:UIControlStateSelected];
    [_budgetBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_budget_sel.png"]] forState:UIControlStateHighlighted];

    [_reportBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_charts.png"]] forState:UIControlStateNormal];
    [_reportBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_charts_sel.png"]] forState:UIControlStateSelected];
    [_reportBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_charts_sel.png"]] forState:UIControlStateHighlighted];

//    [_billBtn setImage:[UIImage imageNamed:[NSString customImageName:@"btn_bills_sel.png"]] forState:UIControlStateSelected];
    
    _calendarBtn.selected = YES;
    _accountBtn.selected = NO;
    _budgetBtn.selected = NO;
    _reportBtn.selected = NO;
    _addBtn.selected = NO;
//    _customerTabbarView.frame = CGRectMake(0, 0,_mainVC.tabBar.bounds.size.width,_mainVC.tabBar.bounds.size.height);
    _customerTabbarView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);

    _customerTabbarView.hidden =NO;
    [_mainVC.tabBar addSubview:_customerTabbarView];
    [_mainVC.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarImage1_1.png"]];
    _mainVC.tabBar.shadowImage = [UIImage imageNamed:@"transparent1_1.png"];
    
    
    [_calendarBtn addTarget:self action:@selector(customBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_accountBtn addTarget:self action:@selector(customBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_budgetBtn addTarget:self action:@selector(customBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_reportBtn addTarget:self action:@selector(customBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)customBtnAction:(UIButton *)sender
{
    if(_mainVC.selectedIndex ==[(sender) tag]) return;
    _calendarBtn.selected = FALSE;
    _accountBtn.selected = FALSE;
    _budgetBtn.selected = FALSE;
    _reportBtn.selected = FALSE;
//    _addBtn.selected = FALSE;
    
    [sender setSelected:YES];
    
    [self performSelector:@selector(setSelectedViewController:) withObject:sender afterDelay:0.1];
}

-(void)addBtnPressed:(id)seœœnder
{
    _transactionEditViewController = [[TransactionEditViewController alloc]initWithNibName:@"TransactionEditViewController" bundle:nil];
    _transactionEditViewController.typeoftodo = @"ADD";
    _transactionEditViewController.showMoreDetailsCell = NO;
    _transactionEditViewController.isFromHomePage = YES;
    
    _transactionEditViewController.transactionDate = _overViewController.kalViewController.selectedDate;
    UINavigationController *navigationViewController =[[UINavigationController alloc]initWithRootViewController:self.transactionEditViewController];
    [self.tabBarController.selectedViewController presentViewController:navigationViewController animated:YES completion:nil];
}



-(void)setSelectedViewController:(UIButton *)sender

{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy:MM:dd,H:mm:ss,S"];
//    NSDate *date = [NSDate date];
//    NSLog(@"点击按钮的时间：%@",[dateFormatter stringFromDate:date]);
    
    
    _mainVC.selectedIndex =[(sender) tag];
}

-(void)reflashUI
{
    if (_mainVC.selectedIndex==0)
    {
        [_overViewController reflashUI];
    }
    else if(_mainVC.selectedIndex==1)
        [_accountsController reflashUI];
    else if (_mainVC.selectedIndex==2)
        [_budgetController refleshUI];
    else
        [_expenseViewController refleshUI];
    
}
-(void)unlockApplication{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_shortItem) {
            if ([_shortItem.localizedTitle isEqualToString:@"Search"])
            {
                UIViewController *viewControllers = self.window.rootViewController;
                
                
                if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
                    AccountSearchViewController *searchVC = [[AccountSearchViewController alloc]initWithNibName:@"AccountSearchViewController" bundle:nil];
                    if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[AccountSearchViewController class]]) {
                        [[self getCurrentVCFrom:viewControllers] presentViewController:searchVC animated:YES completion:^{
                            _shortItem = nil;
                        }];
                    }
                }
            }
            else if ([_shortItem.localizedTitle isEqualToString:@"Add Transaction"])
            {
                UIViewController *viewControllers = self.window.rootViewController;
                if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
                    XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
                    addVc.calSelectedDate = [[NSDate date] initDate];
                    if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[XDAddTransactionViewController class]]) {
                        [[self getCurrentVCFrom:viewControllers] presentViewController:addVc animated:YES completion:^{
                            _shortItem = nil;
                        }];
                    }
                }
            }
        }
    });
}

//3D touch 回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    
    if ([self.settings.passcodeStyle isEqualToString:@"none"] || !self.settings.passcodeStyle) {
        if ([shortcutItem.localizedTitle isEqualToString:@"Search"])
        {
            UIViewController *viewControllers = self.window.rootViewController;
            
            
            if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
                AccountSearchViewController *searchVC = [[AccountSearchViewController alloc]initWithNibName:@"AccountSearchViewController" bundle:nil];
                if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[AccountSearchViewController class]]) {
                    [[self getCurrentVCFrom:viewControllers] presentViewController:searchVC animated:YES completion:^{
                    }];
                }
            }
        }
        else if ([shortcutItem.localizedTitle isEqualToString:@"Add Transaction"])
        {
            UIViewController *viewControllers = self.window.rootViewController;
            if ([viewControllers isKindOfClass:[XDTabbarViewController class]]) {
                XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
                addVc.calSelectedDate = [[NSDate date] initDate];
                if (![[self getCurrentVCFrom:viewControllers] isKindOfClass:[XDAddTransactionViewController class]]) {
                    [[self getCurrentVCFrom:viewControllers] presentViewController:addVc animated:YES completion:^{
                    }];
                }
            }
        }
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockApplication) name:@"unlockSuccess" object:nil];
        _shortItem = shortcutItem;
    }
   

}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}



#pragma mark Btn Action

//获取保存在本地的商品价格，显示
-(void)preVersionPrice:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *purchasePrice = [userDefaults stringForKey:PURCHASE_PRICE];
    if ([purchasePrice length]>0)
    {
        _priceLabel.text = purchasePrice;
    }
    else
        _priceLabel.text = nil;
}
-(void)hideCustomTabView
{
    _adsView.hidden = YES;
}
-(void)showCustomTabView
{
    _adsView.hidden = NO;
}

#pragma mark AlertView delegate
//-----确认restore的时候，会将先前压缩的文件解压放到doc目录下，并且会移除掉旧的splite数据文件，将新的文件移动到相应的位置，但是没有将sqlite文件解压缩？
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 0)
	{
		if(buttonIndex == 0)
			return;
		else
		{
			//获取文件管理器
			NSFileManager *fileManager = [NSFileManager defaultManager];
            //
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
			
			NSError * errors;
			NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/PocketExpenseBak.zip"];
			ZipArchive* zipFile = [[ZipArchive alloc] init];
			[zipFile UnzipOpenFile:path2];
			
			BOOL ret=[zipFile UnzipFileTo:documentsDirectory overWrite:YES];
			[zipFile UnzipCloseFile];
			[self deleteCutemFile];
            
            //若解压出来了
			if(ret)
			{
				NSString *path = [paths objectAtIndex:0];
				NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
				NSString * newPath = nil;
				for (NSString *fname in array)
				{
                    
					if([fname length]>=27)
					{
						if([[fname substringFromIndex:[fname length]-27] isEqualToString:@"PocketExpense1.0.0.sqlite.p"])
						{
							newPath = fname;
							break;
						}
					}
				}
                //获得新的数据库
				if(newPath!=nil)
				{
					newPath = [documentsDirectory stringByAppendingPathComponent:newPath];
					NSDateFormatter * format = [[NSDateFormatter alloc] init];
					[format setDateStyle:NSDateFormatterMediumStyle];
					[format setTimeStyle:NSDateFormatterShortStyle];
                   
                    //检测读取到的数据库是多少版本的
                    NSString *currentsql = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite.p"];

                    //读取老的数据库
                    sqlite3 *db;
                    NSString * database_path = [documentsDirectory stringByAppendingPathComponent:currentsql];
                    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
                    {
                        sqlite3_close(db);
                        NSLog(@"数据库打开失败");
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                    
                    
					if(1)
					{
                        NSString * sqlPath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite"];
						[fileManager removeItemAtPath:sqlPath error:&errors];
						NSString *NewToFilePath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite"];
                        NSString *currentsql = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite.p"];
						[fileManager moveItemAtPath:currentsql toPath:NewToFilePath error:&errors];
                        
                        
                        //添加-wal和-shm文件
                        //先移除掉之前的文件
                        NSString * sqlwalPath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite-wal"];
                        [fileManager removeItemAtPath:sqlwalPath error:&errors];
                        
                        NSString *newwalPath = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite-wal"];
                        NSString *currentwalzaPaht = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite-wal.p"];
                        [fileManager moveItemAtPath:currentwalzaPaht toPath:newwalPath error:&errors];
                        
                        NSString * sqlshmPath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite-shm"];
                        [fileManager removeItemAtPath:sqlshmPath error:&errors];
                        NSString *newshmPath = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite-shm"];
                        NSString *currentshmzaPaht = [documentsDirectory stringByAppendingString:@"PocketExpense1.0.0.sqlite-shm.p"];
                        [fileManager moveItemAtPath:currentshmzaPaht toPath:newshmPath error:&errors];
						
                        
                        
						UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Expense 5 data restore complete", nil)
																		  message:NSLocalizedString(@"VC_You must now quit Pocket Expense and re-launch for the new changes to take effect.", nil)
																		 delegate:self
																cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
																otherButtonTitles:nil];
						alertView.tag = 1;
						[alertView show];
						[fileManager removeItemAtPath:path2 error:&errors];
						[fileManager removeItemAtPath:newPath error:&errors];
						
						NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
						
						for (NSString *fname in array)
						{
							if([fname length]>6)
							{
								if([[fname substringFromIndex:[fname length]-6] isEqualToString:@".jpg.p"])
								{
									NSString * strName = [fname substringToIndex:[fname length]-2];
									[fileManager moveItemAtPath:fname toPath:strName error:&errors];
								}
							}
						}
						for (NSString *fname in array)
						{
							if([fname length]>2)
							{
								if([[fname substringFromIndex:[fname length]-2] isEqualToString:@".p"])
								{
									[fileManager removeItemAtPath:fname error:&errors];
								}
							}
						}
						
					}
					else
					{
						UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
																		 message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
																		delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
						[alert show];
                        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                        appDelegate.appAlertView = alert;
					}
				}
				else
				{
					UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
																	 message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
																	delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
					[alert show];
                    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                    appDelegate.appAlertView = alert;
				}
			}
			else
			{
				UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
																 message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
																delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
				[alert show];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.appAlertView = alert;
			}
		}
	}
	else if(alertView.tag == 1||alertView.tag == 10)
	{
		exit(1);
	}
    else if(alertView.tag == 100)
    {
    	if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
    }
    }
    else if(alertView.tag==1000)
    {
        if (buttonIndex==0)
        {
            [self afterDropbox];
//            [self showAds:nil];
        }
        if (buttonIndex==1)
        {
            [self.dropbox.drop_accountManager linkFromController:(UIViewController *)self.window.rootViewController];
            self.isSignUping=YES;
//            [self showAds:nil];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [super applicationWillResignActive:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [super applicationDidBecomeActive:application];
    [FBSDKAppEvents activateApp];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
    });
    
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext_ = self.managedObjectContext;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            // abort();
        }
    }
}


#pragma mark Handle Data
-(void)handleDate
{
    //检测有没有NoRecurring的数据.
    NSError *error = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"recurringType contains[c] %@",@"No Recurring"];
    [fetch setPredicate:predicate];
    NSArray *object = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    for (int i=0; i<[object count]; i++)
    {
        Transaction *oneTrans = [object objectAtIndex:i];
        oneTrans.recurringType = @"Never";
        oneTrans.dateTime_sync = [NSDate date];
    }
    [self.managedObjectContext save:&error];
    
    [epdc AutoFillBudgetData:FALSE];
    [epdc AutoFillTransactionData];
    if(![epnc.dbVersionStr isEqualToString:@"1.0.2"])
        [epdc autoReCountBudgetRollover_V101ToV102];
    
}







- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


#pragma mark - 登录注册事件实现


-(void)succededInSignUp
{
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    requestLocal.entity=descLocal;
    NSError *error;
    NSArray *userArray=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
    
    //如果有数据,且新版本数据,则删除所有数据
    if (userArray.count)
    {
        //以前有用户存在，旧的数据
        [self removeAllData];
        
        [self.epdc initializeAccountType];
        [self.epdc initializeCategory];
        [self.epdc createDefaultAccount];
        
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        user.purchaseType=[NSNumber numberWithInt:0];
        
        [self.managedObjectContext save:&error];
        
        PFObject *userServer=[PFUser currentUser];
        userServer[@"purchaseType"]=[NSNumber numberWithInt:0];
        [userServer saveInBackground];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[ParseDBManager sharedManager]dataSyncWithServer];
        });
        
    }
    else
    {
        //老用户
        
        //给某些没有uuid的用户加上uuid以及updatedTime
        [self addUUID];
        [self addUpdatedTime];
        
        
        //创建user
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        [self.managedObjectContext save:&error];
        
        [self.epdc createDefaultAccount];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[ParseDBManager sharedManager]dataSyncWithServer];
        });
    }
    
    XDTabbarViewController* tabbarVc = [[XDTabbarViewController alloc]init];
    self.window.rootViewController=tabbarVc;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

-(void)succededInLogIn
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    XDTabbarViewController* tabbarVc = [[XDTabbarViewController alloc]init];
    self.window.rootViewController=tabbarVc;
    
    XDFirstPromptViewController* view = [[XDFirstPromptViewController alloc]initWithNibName:@"XDFirstPromptViewController" bundle:nil];
    view.view.frame = CGRectMake(0, -60, SCREEN_WIDTH, 60);
    [tabbarVc.view addSubview:view.view];

    [UIView animateWithDuration:0.2 animations:^{
        if (IS_IPHONE_X) {
            view.view.y = 44;
        }else{
            view.view.y = 20;
        }
    }];
    
    
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    requestLocal.entity=descLocal;
    NSError *error;
    NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
    
    self.isSyncing = NO;
    if (!datas.count)
    {
        //没有用户

        //创建用户
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        [self.managedObjectContext save:&error];
        
        [[ParseDBManager sharedManager]dataSyncWithLogInServer];

    }
    else
    {
        //有用户使用过
        User *user=[datas objectAtIndex:0];
        NSString *lastUser=user.lastUser;
        if ([lastUser isEqualToString:[[PFUser currentUser]objectId]])
        {
            //同一个用户登录
            [[ParseDBManager sharedManager]dataSyncWithLogInServer];

        }
        else
        {
            //不同用户登录
            [self removeAllData];
            
            //创建一个新的用户以及初始化数据
            
            //创建user
            User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
            user.userObjectId=[[PFUser currentUser]objectId];
            [self.managedObjectContext save:&error];
            
            [self.epdc initializeAccountType];
            [self.epdc initializeCategory];
//            [self.epdc createDefaultAccount];
            
            [[ParseDBManager sharedManager]dataSyncWithLogInServer];

        }
    }
//    [[ADEngineManage adEngineManage] lockFunctionsShowAd];

    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError* error2;
        //头像下载
        PFUser *serverUser=[PFUser currentUser];
        PFFile *avatarFile=serverUser[@"avatar"];
        NSData *avatarData=[avatarFile getData:&error2];
        
        if (error)
        {
            NSLog(@"头像下载错误 %@",error2);
        }
        
        //写入本地
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
        [avatarData writeToFile:imageFile atomically:YES];
        
    });
    
//    UIImage *avatarImage=[UIImage imageWithData:avatarData];
    
   
    
//    _overViewController=[[OverViewWeekCalenderViewController alloc]init];
//    _navCtrl=[[UINavigationController alloc]initWithRootViewController:_overViewController];
//
//    _menuVC=[[menuViewController alloc]init];
//    _menuVC.navigationControllerArray=[NSMutableArray arrayWithObjects:_navCtrl,@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
//    _drawerVC=[[MMDrawerController alloc]initWithCenterViewController:_navCtrl leftDrawerViewController:_menuVC];
//
//    [_menuVC setAvatarImage:avatarImage];
//
//    //drawController设置
//    _drawerVC.showsShadow=NO;
//    _drawerVC.maximumLeftDrawerWidth=MENU_WIDTH;
//    [_drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//
        
    if (!self.isPurchased)
    {
//        [self showAds:nil];
    }
}


@end
@implementation UITabBarController (rotation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.tabBarController.selectedIndex == 0||appDelegate.tabBarController.selectedIndex == 3)
	{
		if (appDelegate.rotateFlag == YES)
		{
			if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
			{
				return YES;
			}
			else {
				return NO;
			}
		}
		else
		{
			return (interfaceOrientation == UIInterfaceOrientationPortrait);
			
		}
		
	}
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADMOB_ADS_HIDE"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADMOB_ADS_SHOW"
                                                  object:nil];
}

@end








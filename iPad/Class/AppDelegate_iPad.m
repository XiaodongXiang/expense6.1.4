//
//  AppDelegate_iPad.m
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
 
#import "AppDelegate_iPad.h"
#import "ApplicationDBVersion.h"
#import "GTMBase64.h"
#import <sqlite3.h>
#import "ZipArchive.h"
#import "Flurry.h"
#import "PasscodeCheckViewController_iPad.h"
#import <Crashlytics/Crashlytics.h>

#import "ipad_DateSelBillsViewController.h"
#import "LogInViewController_ipad.h"
#import <Parse/Parse.h>
#import "User.h"
#import <ParseUI/ParseUI.h>
#import "ParseDBManager.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import "XDAppriater.h"

#define OLDUSERDATA @"oldUserData"
#define FIRSTLAUNCHSINCEBACKUPOLDUSERDATA @"FirstLanchSinceBackupOldUserData"

@interface AppDelegate_iPad ()

@property(nonatomic, strong)ADEngineController* interstitial;


@end

@implementation AppDelegate_iPad
@synthesize mainViewController,passCodeCheckView;
//@synthesize  dateSelectedViewController;
#pragma mark -
#pragma mark Background handle data

-(void)afterpassword_IPAD
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
	unsigned long count = [mutableObjects count];
    
    //如果是第一次下载app的话，设置初试的设置
 	if(count == 0)
	{
		self.settings = [NSEntityDescription insertNewObjectForEntityForName:@"Setting"
													  inManagedObjectContext:context];
		settings.passcode = nil;
		settings.currency = @"$ - US Dollar";
		settings.weekstartday = @"Sunday";
        settings.isBefore = [NSNumber numberWithBool:FALSE];
        settings.budgetNewStyle = [NSNumber numberWithBool:YES];
        
        settings.payeeCategory = [NSNumber numberWithBool:YES];
        settings.payeeName = [NSNumber numberWithBool:YES];
        settings.payeeMemo = [NSNumber numberWithBool:FALSE];
        settings.payeeTranAmount = [NSNumber numberWithBool:YES];
        settings.payeeTranClear = [NSNumber numberWithBool:FALSE];
        settings.payeeTranType = [NSNumber numberWithBool:YES];
        

        settings.accDRstring =@"All Dates";
        settings.budgetNewStyleCycle =@"Month";
        settings.cateDRstring =@"Monthly";
        settings.sortType =@"DESC";
        
        settings.others20 = @"5.0";
        
 		ApplicationDBVersion *adbv = [NSEntityDescription insertNewObjectForEntityForName:@"ApplicationDBVersion" inManagedObjectContext:context];
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
        //如果用户设置了 setting的话，就需要将设置读取出来
        self.settings = [mutableObjects objectAtIndex:0];
        if(self.settings.isBefore == nil)
            settings.isBefore = [NSNumber numberWithBool:FALSE];

        if(self.settings.budgetNewStyle == nil)
            settings.budgetNewStyle = [NSNumber numberWithBool:FALSE];

        if(self.settings.payeeCategory== nil)
            settings.payeeCategory = [NSNumber numberWithBool:YES];
        if(self.settings.payeeName == nil)
            settings.payeeName = [NSNumber numberWithBool:YES];

        if(self.settings.payeeMemo == nil)
            settings.payeeMemo = [NSNumber numberWithBool:FALSE];
        if(self.settings.payeeTranAmount == nil)
            settings.payeeTranAmount = [NSNumber numberWithBool:YES];
        if(self.settings.payeeTranClear == nil)
            settings.payeeTranClear = [NSNumber numberWithBool:FALSE];
         if(self.settings.payeeTranType == nil)
             settings.payeeTranType = [NSNumber numberWithBool:YES];
  
        
        if([self.settings.budgetNewStyleCycle length] == 0)
            settings.budgetNewStyleCycle =@"Month";

       if([self.settings.accDRstring length] == 0)     settings.accDRstring =@"All Dates";
 
       if([self.settings.cateDRstring length] == 0)     settings.cateDRstring =@"Monthly";
       else  if(![self.settings.cateDRstring isEqualToString:@"Monthly"]&&
           ![self.settings.cateDRstring isEqualToString:@"Weekly"]&&
           ![self.settings.cateDRstring isEqualToString:@"Yearly"]&&
                ![self.settings.cateDRstring isEqualToString:@"Weekly"]&&
                ![self.settings.cateDRstring isEqualToString:@"Biweekly"]&&
                  ![self.settings.cateDRstring isEqualToString:@"All Dates"]&&
                    ![self.settings.cateDRstring isEqualToString:@"Custom"]
            )
        {
           self.settings.cateDRstring =@"Monthly";

        }
        
        if([self.settings.sortType length] == 0)     settings.sortType =@"DESC";

        [epnc setCurrenyStrBySettings];
        [epnc setDBVerString];

        //检测当前版本与以前版本是否由冲突
		[epdc CheckCategoryErrorIcon];
		[epdc CheckAccountTypeErrorName];
		[epdc AddCategory_V100ToV101];
		[epdc autoGenCategoryDataRelationShip];
        [epdc CheckErrorCategoryBudgetRelation];
        [epdc CheckErrorBudget];
 
        [epdc AutoFillBudgetData:TRUE];
        [epdc AutoFillTransactionData];
        
        
        //修改category
        //1.首先将notsure改成others
        if (![settings.others20 isEqualToString:@"5.0"]) {
            [self.epdc checkCategorytoChangeNotsureCategory];
            
        }
	}

 
}

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse enableLocalDatastore];
//
//    [Parse setApplicationId:@"BI4p05Rax27kKCV7Q00o9wJnNgPTBbDHsHVRgCTM"
//                  clientKey:@"Y5pqvDEtUEJYtUgC53OIRbkSU0RE8SB4qfrSUl6e"];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"BI4p05Rax27kKCV7Q00o9wJnNgPTBbDHsHVRgCTM";
        configuration.clientKey =@"Y5pqvDEtUEJYtUgC53OIRbkSU0RE8SB4qfrSUl6e";
        configuration.server = @"http://pocketexpense-master-ios.us-east-1.elasticbeanstalk.com/parse";
        configuration.networkRetryAttempts = 1;
    }]];
//    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
//        configuration.applicationId = @"rHZG3VUmXe3jOosA4Wcl2G1WxJBnI5nFK21g0nfH";
//        configuration.server = @"http://parseserver-d24mq-env.us-east-1.elasticbeanstalk.com/";
//    }]];
//    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
//        configuration.applicationId = @"rHZG3VUmXe3jOosA4Wcl2G1WxJBnI5nFK21g0nfH";
//        configuration.clientKey =@"is4CvTqFPEOVbZGxur0g08SfJ8sG02lDC72bADZo";
//        configuration.server = @"http://parseserver-d24mq-env.us-east-1.elasticbeanstalk.com/parse";
//    }]];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    // [Optional] Track statistics around application opens.

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [Crashlytics startWithAPIKey:@"5396d094a6603764683087a0e2248c3bf6260141"];
    [Fabric with:@[[Crashlytics class]]];
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    //打印app所在的位置
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *mainPath = [paths objectAtIndex:0];
//    NSLog(@"mainPath:%@",mainPath);

    
    mainViewController=[[ipad_MainViewController alloc]initWithNibName:@"ipad_MainViewController" bundle:nil];
    epdc = [[EPDataBaseModifyClass alloc]init];
    epnc = [[EPNormalClass alloc]init];
    [self afterpassword_IPAD];

//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [Flurry setVersion:version];
    
    [self.epdc getOldDataBaseInsertToNewDataBase_isBackup:NO];
    //设置版本的标识 4.5/5.3/5.4
    [self.epdc setFreeVersionBelongtoWhichVersionIdentification];
    
    NSError *error;
    if (self.settings.syncAuto==nil)
    {
        self.settings.syncAuto=NO;
        [self.managedObjectContext save:&error];
        NSLog(@"%@",error);
        self.autoSyncOn=NO;
    }
    else
    {
//        self.autoSyncOn=self.settings.syncAuto;
        if ([self.settings.syncAuto boolValue] != YES)
        {
            self.autoSyncOn=NO;
        }
        else
        {
            self.autoSyncOn=YES;
        }
    }
    
    if (![PFUser currentUser])
    {
        self.loginViewController=[[SignViewController_iPad alloc]init];
        [window setRootViewController:_loginViewController];
    }
    else
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
        
        
        
        [window setRootViewController:mainViewController];
    }

    
    [window makeKeyAndVisible];
    
    //判断是不是升级了type数据到recurring数据中,如果不是当前版本的数据，都需要转换数据,自5.0之后数据库就没变动了，所以不需要再添加其他判断了
    if (!([settings.others20 isEqualToString:@"4.5.1"] || [settings.others20 isEqualToString:@"5.0"])) {
        [self.epdc setAccountOrderIndex];
        [self.epdc setTransactionType];
    }
    
    //给4.5.1及其以前所有的表格设置 state uuid dateTime
    if (!([settings.others20 isEqualToString:@"5.0"])) {
        [self.epdc changeTransactionRecurringType];
        //更改category的属性：EXPENSE,INCOME
        [self.epdc setCategoryTransactionType];
        [self.epdc setAllLocalTables_state_uuid_DateTime];
    }
    
    //5.1之前的版本添加transaction的时候忘了添加uuid
    if (![settings.others18 isEqualToString:@"5.2"])
    {
        NSError *error = nil;
        [self.epdc setTransactionTable_UUID_5_2VersionOnly];
        settings.others18 = @"5.2";
        [self.managedObjectContext save:&error];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //获取当前设备上保存的版本号
        NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
        //如果设备上有版本号，就说明，这个版本是老的
        if (trackingVersion != nil)
        {
            //当对老数据解析完成以后，插入一个标记，以后打开的话，就提醒是覆盖还是交互
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA forKey:OLDUSERDATA];
        }
    }
    

    
    if (![settings.others20 isEqualToString:@"5.0"])
    {
        settings.others20 = @"5.0";
        [self.managedObjectContext save:&error];
    }
    else
    {
//        [self.epdc createDefaultAccount];
    }
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager] dataSyncWithServer];
            [[ParseDBManager sharedManager] getPFSetting];

        }
    });

    
    //处理budget更新，自动插入transaction
    [self handleDate];
    //indicator
    [self loadHMJIndicator];
    //dropbox必须在处理完了数据之后才可以同步
    dropbox = [[DropboxObject alloc]init];
    
    //touch ID
    
    LAContext *context=[LAContext new];
    context.localizedFallbackTitle=@"";
    BOOL *touchIDOpen=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
    if (touchIDOpen==NULL)
    {
        [_touchBack removeFromSuperview];
    }
    if ([self.settings.passcodeStyle isEqualToString:@"touchid"])
    {
        _touchBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passcodeAgain)];
        [_touchBack addGestureRecognizer:tap];
        
        _touchBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_touch"]];
        [self.window addSubview:_touchBack];
        [self.window bringSubviewToFront:_touchBack];
        [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?@"Face ID":@"Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_touchBack removeFromSuperview];
                });
            }
            else
            {
                NSLog(@"failed");
            }
        }];
    }

    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    if (![currentVersion isEqualToString:lastVersion]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[XDAppriater shareAppirater] setEmptyAppirater];
    }
    
    [[XDAppriater shareAppirater] judgeShowRateView];
  
    
    
    
    passCodeCheckView = [[PasscodeCheckViewController_iPad alloc] initWithNibName:@"PasscodeCheckViewController_iPad" bundle:nil];
    if([self.settings.passcodeStyle isEqualToString:@"number"])
    {
        [self.passCodeCheckView willRotateToInterfaceOrientation:self.mainViewController.interfaceOrientation duration:0.0];
        self.passCodeCheckView.view.frame = CGRectMake(0.0, 0.0, self.passCodeCheckView.view.frame.size.width, self.passCodeCheckView.view.frame.size.height);
        
        [self.window addSubview:passCodeCheckView.view];
        
    }
    
    app_reminderBill1Array =[[NSMutableArray alloc]init];
    app_reminderBill2Array = [[NSMutableArray alloc]init];
    app_reminderAllArray =[[NSMutableArray alloc]init];
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
    
    //插页广告
    if ([PFUser currentUser]) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2201 - iPad - Interstitial - Launch"];
            [self.interstitial nowShowInterstitialAdWithTarget:self.window.rootViewController];
        }
    }
    
  	return YES;
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
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_touchBack removeFromSuperview];
            });
        }
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    LAContext *context=[LAContext new];
    context.localizedFallbackTitle=@"";
    NSError *error;
    BOOL *touchIDOpen=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
    if (touchIDOpen==NULL)
    {
        [_touchBack removeFromSuperview];
    }
    if ([self.settings.passcodeStyle isEqualToString:@"touchid"])
    {
        _touchBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passcodeAgain)];
        [_touchBack addGestureRecognizer:tap];
        
        _touchBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_touch"]];
        [self.window addSubview:_touchBack];
        [self.window bringSubviewToFront:_touchBack];
        [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?@"Face ID":@"Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_touchBack removeFromSuperview];
                });
            }
            else
            {
                NSLog(@"failed");
                
            }
        }];
    }

  
    
	if(AddPopoverController !=nil) [AddPopoverController dismissPopoverAnimated:YES];
	if(AddSubPopoverController !=nil) [AddSubPopoverController dismissPopoverAnimated:YES];
	if(AddThirdPopoverController !=nil) [AddThirdPopoverController dismissPopoverAnimated:YES];
 	
    [epdc AutoFillBudgetData:TRUE];
    [epdc AutoFillTransactionData];
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
    [super applicationWillEnterForeground:application];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_touchBack removeFromSuperview];
    
    [[ADEngineManage adEngineManage] downloadConfigByAppName:@"Pocket Expense"];

	if(AddPopoverController !=nil)
	{
		NSManagedObjectContext *managedObjectContext_ = self.managedObjectContext;
		if (managedObjectContext_ != nil) {
			if ([managedObjectContext_ hasChanges]  ) {
				[managedObjectContext_ rollback];
			}
		}
	}
    [self getRecentlyTwoMonthesand50NeedtoReminderBills];

    [self hidePopView];
    
    if([self.settings.passcodeStyle isEqualToString:@"number"] > 0){
        [self.passCodeCheckView.view removeFromSuperview];
        passCodeCheckView.txtP1.background = [UIImage imageNamed:@"password1.png"];
        passCodeCheckView.txtP2.background = [UIImage imageNamed:@"password1.png"];
        passCodeCheckView.txtP3.background = [UIImage imageNamed:@"password1.png"];
        passCodeCheckView.txtP4.background = [UIImage imageNamed:@"password1.png"];
		passCodeCheckView.txtPasscode.text = @"";
		[passCodeCheckView.txtPasscode becomeFirstResponder];
        [self.passCodeCheckView willRotateToInterfaceOrientation:self.mainViewController.interfaceOrientation duration:0.0];
        self.passCodeCheckView.view.frame = CGRectMake(0.0, 0.0, self.passCodeCheckView.view.frame.size.width, self.passCodeCheckView.view.frame.size.height);
        [self.window addSubview:passCodeCheckView.view];
    }


}
- (void)applicationWillResignActive:(UIApplication *)application {
    [super applicationWillResignActive:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [super applicationDidBecomeActive:application];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        [self.interstitial showInterstitialAdWithTarget:self.window.rootViewController];
    }
    if (self.isSignUping==YES )
    {
        [self.transferAlertview show];
        self.isSignUping=NO;
    }
}

/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
//- (void)applicationWillTerminate:(UIApplication *)application {
//	[super applicationWillTerminate:application];
//    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
//
//}

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
			//NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath: [path stringByAppendingPathComponent:fname] error: &errors];//[[NSFileManager defaultManager] fileAttributesAtPath:[path stringByAppendingPathComponent:fname] traverseLink:NO];
			[fileManager removeItemAtPath:fname error:nil];
		}
	}
	
}


-(void)setAccountOrderIndex_iPad{
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //首先获取所有的Account
	NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest2 setEntity:entity2];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
	NSArray *sortDescriptors2 = [[NSArray alloc] initWithObjects:sortDescriptor2, nil];
	
	[fetchRequest2 setSortDescriptors:sortDescriptors2];
 	NSArray* objects2 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
 	NSMutableArray *tmpAccountArray2 = [[NSMutableArray alloc] initWithArray:objects2];

    
    BOOL hasBeenSequence = NO;
    for (int i=0; i<[tmpAccountArray2 count]; i++) {
        Accounts *oneAccount = [tmpAccountArray2 objectAtIndex:i];
        if (oneAccount.orderIndex==0 || oneAccount.orderIndex==nil) {
            continue;
        }
        else{
            hasBeenSequence = YES;
        }
    }
    if (!hasBeenSequence) {
        NSError *error = nil;
        for (int i=0; i<[tmpAccountArray2 count]; i++) {
            
            Accounts *oneAccount = [tmpAccountArray2 objectAtIndex:i];
            //如果写成int类型的数据输入会崩溃哦？？？？
            oneAccount.orderIndex = [NSNumber numberWithInteger:i];
            [appDelegate.managedObjectContext save:&error];
        }
    }
    
    
}
-(void)setTransactionType_iPad{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *allTransactionArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    for (int i=0; i<[allTransactionArray count]; i++) {
        Transaction *oneTransaction = [allTransactionArray objectAtIndex:i];
        if ([oneTransaction.type integerValue]>=0 && oneTransaction.recurringType==nil) {
            if ([oneTransaction.type intValue]==0) {
                oneTransaction.recurringType = @"Never";
            }
            else if ([oneTransaction.type intValue]==1){
                oneTransaction.recurringType = @"Daily";
            }
            else if ([oneTransaction.type intValue]==2){
                oneTransaction.recurringType = @"Weekly";
            }
            else if ([oneTransaction.type intValue]==3){
                oneTransaction.recurringType = @"Every 2 Weeks";
            }
            else if ([oneTransaction.type intValue]==4){
                oneTransaction.recurringType = @"Semimonthly";
            }
            else if ([oneTransaction.type intValue]==5){
                oneTransaction.recurringType = @"Monthly";
            }
            else if ([oneTransaction.type intValue]==6){
                oneTransaction.recurringType = @"Every 3 Months";
            }
            else if ([oneTransaction.type intValue]==7){
                oneTransaction.recurringType = @"Every 6 Months";
            }
            else if ([oneTransaction.type intValue]==8){
                oneTransaction.recurringType = @"Every Year";
            }
            [appDelegate.managedObjectContext save:&error];
        }
    }
}




///////当输入 dropbox账户的时候成功的时候就会自动回到应用程序中去
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)urls sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [super application:application openURL:urls sourceApplication:sourceApplication annotation:annotation];
    return YES;

}

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
                        
					}
				}
				else
				{
					UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Restore Cancelled", nil)
																	 message:NSLocalizedString(@"VC_The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure.", nil)
																	delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
					[alert show];
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
    if(alertView.tag == 100)
    {
    	if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
        }
    }
    else if (alertView.tag == 1000)
    {
        if (buttonIndex==0)
        {
            NSLog(@"被取消");
            [self afterDropbox];
        }
        if (buttonIndex==1)
        {
            self.isSignUping=YES;
            [self.dropbox.drop_accountManager linkFromController:(UIViewController *)self.window.rootViewController];
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



#pragma mark Memory management
//- (void)dismissKeyboardForFormSheet;
//{
//	UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectZero];
//	
//    UIViewController *myRootViewController = mainViewController; // for simple apps (INPUT: viewController is whatever your root controller is called.  Probably is a way to determine this progragrammatically)
//    UIViewController *uivc;
//    if (myRootViewController.navigationController != nil) { // for when there is a nav stack
//        uivc = myRootViewController.navigationController;
//    } else {
//        uivc = myRootViewController;
//    }
//	
//    if (uivc.modalViewController != nil){// for when there is something modal
//        uivc = uivc.modalViewController;
//    } 
//	
//    [uivc.view  addSubview:tempTextField];
//	
//    [tempTextField becomeFirstResponder];
//    [tempTextField resignFirstResponder];
//    [tempTextField removeFromSuperview];
//    [tempTextField release];
//	
//}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}

#pragma mark - 注册登录方法
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
        
        [[ParseDBManager sharedManager]dataSyncWithServer];
        
    }
    else
    {
        //老用户
        
        //给某些没有uuid的用户加上uuid以及updatedTime
        [self addUUID];
        [self addUpdatedTime];
        [self.epdc createDefaultAccount];

        
        //创建user
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        [self.managedObjectContext save:&error];
        
        [[ParseDBManager sharedManager]dataSyncWithServer];
        
    }

    self.window.rootViewController=mainViewController;
}
-(void)succededInLogIn
{
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    requestLocal.entity=descLocal;
    NSError *error;
    NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
    
    if (!datas.count)
    {
        //没有用户
        
        //创建用户
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        [self.managedObjectContext save:&error];
        
    }
    else
    {
        //有用户使用过
        User *user=[datas objectAtIndex:0];
        NSString *lastUser=user.lastUser;
        if ([lastUser isEqualToString:[[PFUser currentUser]objectId]])
        {
            //同一个用户登录
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
            
            //初始化数据
            [self.epdc initializeAccountType];
            [self.epdc initializeCategory];
//            [self.epdc createDefaultAccount];
            
        }
    }

    [[ParseDBManager sharedManager]dataSyncWithServer];
    self.window.rootViewController=mainViewController;
}



@end

@implementation UINavigationController (DelegateAutomaticDismissKeyboard)
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}
@end




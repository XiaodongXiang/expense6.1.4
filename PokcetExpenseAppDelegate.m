//
//  AppDelegate_Shared.m
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
 
#import "PokcetExpenseAppDelegate.h"
#import "ApplicationDBVersion.h"
#import "GTMBase64.h"
#import "BudgetTransfer.h"

#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "Transaction.h"
#import "BudgetTemplate.h"

#import "BillFather.h"
#import "ZipArchive.h"
#import "Flurry.h"
#import "Reachability.h"

#import <Parse/Parse.h>
#import "Payee.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "XDInAppPurchaseManager.h"


#import "User.h"
#import "ParseDBManager.h"
#import "Category.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define NEWUSEDATA  @"newUserData"
#define FIRSTLAUNCHSINCEBACKUPNEWDATA @"FirstLanchSinceBackupNewUserData"

#define PRODUCT_ID @"BTGS_001IAP"
#define LITE_UNLOCK_FLAG    @"isProUpgradePurchased"
//解锁通知
#define LITE_NOTIFICT_NAME          @"DoLite_lock_action"
#define GET_PRO_VERSION_PRICE_ACTION           @"Get_Pro_Version_Price_Action"
#define PURCHASE_PRICE                          @"PurchasePirce"

#import "ParseDBManager.h"

@implementation PokcetExpenseAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize settings;
@synthesize dayFormatter;
@synthesize backupList;

@synthesize AddPopoverController,AddSubPopoverController,AddThirdPopoverController;
@synthesize rotateFlag;
@synthesize pvt;
@synthesize url;
@synthesize isRestore,hasPWDView;
@synthesize epdc,epnc;


@synthesize dropbox;
@synthesize numberofReminderBill,app_reminderAllArray,app_reminderBill1Array,app_reminderBill2Array;

@synthesize appActionSheet,appAlertView,hmjIndicator;

@synthesize isPurchased,inAppPM;

#pragma mark -
#pragma mark DisposeData

//-------将免费版的数据转移到正式版中...
-(void)DisposeData:(id)sender
{
	if([@"/importDatabase" isEqualToString:[url path]]) 
	{
		
		NSString *query = [url query];
		NSData *importUrlData = [GTMBase64 webSafeDecodeString:query];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString * litePath  = [NSString stringWithFormat:@"%@/%@",documentsDirectory, @"PocketExpenseLite.sqlite"];
		NSString *curPath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[importUrlData writeToFile:litePath atomically:YES];
		NSError * error;
		[fileManager removeItemAtPath:curPath error:&error];
		[fileManager copyItemAtPath:litePath toPath:curPath error:NULL];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Pocket Expense data transfer success", nil)
															message:NSLocalizedString(@"VC_Thanks for using our Full Version! Please restart the Full Version to complete the transfer.", nil)
														   delegate:self 
												  cancelButtonTitle:nil
												  otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
		alertView.tag = 10;
		[alertView show];
		[fileManager removeItemAtPath:litePath error:&error];
		
	}
}


#pragma mark -
#pragma mark Application lifecycle

-(void)saveTranscationConfig
{
//	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"transacationConfig.plist"];
// 	
//	[plistDictionary writeToFile:storePath atomically: YES];
// 	
}

-(void)saveTranscationDRConfig
{
	//NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"transacationDRSelConfig.plist"];
 	
	//[tranDRplistDictionary writeToFile:storePath atomically: YES];
 	
}


#pragma mark Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    [[ADEngineManage adEngineManage] downloadConfigByAppName:@"Pocket Expense"];

    NSLog(@"NSHomeDirectory == %@",NSHomeDirectory());
    application.applicationIconBadgeNumber = 0;
    NSError *error = nil;

    //更新数据，4.5.1版本，transfer类型的transaction也可能由category
    NSFetchRequest *fetchBill = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSPredicate *pre2 = [NSPredicate predicateWithFormat:@"ep_recurringType == 'Only Once'"];
    [fetchBill setPredicate:pre2];
    NSArray *objects_bill = [[NSArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchBill error:&error]];
    
    for (int i=0; i<[objects_bill count]; i++)
    {
        EP_BillRule *oneBill = [objects_bill objectAtIndex:i];
        oneBill.ep_recurringType = @"Never";
        oneBill.dateTime = [NSDate date];
        [self.managedObjectContext save:&error];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:NEWUSEDATA] isEqualToString:FIRSTLAUNCHSINCEBACKUPNEWDATA]) {
        [self.epdc setLocalDataBaseSyncTimeToday_whenRestore];
        
        //备份完成后第一次打开应用
        
        //删除云端数据
        [self restoreDelete];
        
        NSString *resotreUUID=[EPNormalClass GetUUID];
        [userDefaults setValue:resotreUUID forKey:@"restoreUUID"];
        
        PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
        [query whereKey:@"User" equalTo:[PFUser currentUser]];
        NSArray *userSetting=[query findObjects:&error];
        
        if (userSetting.count)
        {
            PFObject *setting=[userSetting objectAtIndex:0];
            setting[@"restoreUUID"]=resotreUUID;
            [setting saveInBackground];
        }
        else
        {
            PFObject *object=[PFObject objectWithClassName:@"Setting"];
            object[@"User"]=[PFUser currentUser];
            object[@"restoreUUID"]=resotreUUID;
            [object saveInBackground];
        }
        
        [userDefaults removeObjectForKey:NEWUSEDATA];
        [userDefaults synchronize];
        
        //修改设备synctime，方便完全同步数据至云端
        NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
        NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        requestUser.entity=descUser;
        
        NSError *error;
        
        NSArray *arrayUser=[self.managedObjectContext executeFetchRequest:requestUser error:&error];
        
        User *user=[arrayUser objectAtIndex:0];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        [self.managedObjectContext save:&error];

    }

    self.isPurchased = NO;
    
//    inAppPM =  [[InAppPurchaseManager alloc]init];
//    inAppPM.delegate = self;
//    //免费版先获取商品信息
//    [inAppPM loadStore];
//    [inAppPM finishSomeUnfinishTransaction];
//    [inAppPM addTransactionObserver];
    
    [[XDInAppPurchaseManager shareManager] getProductInfo];
    [[XDInAppPurchaseManager shareManager] addTransactionObserver];
    
    //免费版，判断是否内购成功
    if (!self.isPurchased)
    {
        //内购流程1：免费版未购买的，初始化内购管理类，访问内购商品信息
        [self initLitePurchaseInformation];
    }
    
    [self setFlurry];
    [self budgetErrorCorrection];
    
    
    if (!self.settings.others16)
    {
        self.settings.others16 = @"1";
        [self.managedObjectContext save:&error];
    }
    
    //获取网络时间和本地时间差
    [NSDate internetServerDate:^(NSDate * internetDate) {
        
        if (internetDate) {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:internetDate];
            [[NSUserDefaults standardUserDefaults] setObject:@(interval) forKey:@"timeInterval"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    
    //默认是打开提醒
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault valueForKey:@"ReminderNotification"])
    {
        [userDefault setBool:YES forKey:@"ReminderNotification"];
        [userDefault synchronize];
    }
    
    [self.epnc setFlurryEvent_withUpgrade:NO];
    

    return YES;
}




//////-------------------------------------------------------------------------------------------------------

-(void)applicationWillEnterForeground:(UIApplication *)application
{

    
}


//添加
- (void)applicationWillTerminate:(UIApplication *)application {
    
 	return ;
}

//设置通知
- (void)applicationWillResignActive:(UIApplication *)application
{
    
//    NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = 1 and expenseAccount = nil and expenseAccount = nil"] sortDescriptors:nil];
//    for (Transaction* tran in array) {
//        tran.state = @"0";
//        tran.updatedTime = [NSDate date];
//        tran.dateTime_sync = [NSDate date];
//        
//        if ([PFUser currentUser])
//        {
//            [[ParseDBManager sharedManager]updateTransactionFromLocal:tran];
//        }
//    }
//    [[XDDataManager shareManager] saveContext];
    
    [self.window endEditing:YES];
    
    //设置setting中的notification
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"ReminderNotification"])
    {
        NSDate *now = [NSDate date];
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        //4.dateTime
        NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:now];
        [parts1 setHour:18];
        [parts1 setMinute:0];
        [parts1 setSecond:0];
        [parts1 setDay:(parts1.day + 1)];
        NSDate *daysLater_1 = [[NSCalendar currentCalendar] dateFromComponents:parts1];
        
        
        
        NSDateComponents*  parts2 = [[NSCalendar currentCalendar] components:flags fromDate:now];
        [parts2 setHour:18];
        [parts2 setMinute:0];
        [parts2 setSecond:0];
        [parts2 setDay:(parts2.day + 3)];
        NSDate *daysLater_3 = [[NSCalendar currentCalendar] dateFromComponents:parts2];
        
        NSDateComponents*  parts3 = [[NSCalendar currentCalendar] components:flags fromDate:now];
        [parts3 setHour:18];
        [parts3 setMinute:0];
        [parts3 setSecond:0];
        [parts3 setDay:(parts3.day + 7)];
        NSDate *daysLater_7 = [[NSCalendar currentCalendar] dateFromComponents:parts3];
        
        NSDateComponents*  parts4 = [[NSCalendar currentCalendar] components:flags fromDate:now];
        [parts4 setHour:18];
        [parts4 setMinute:0];
        [parts4 setSecond:0];
        [parts4 setDay:(parts4.day + 21)];
        NSDate *daysLater_21 = [[NSCalendar currentCalendar] dateFromComponents:parts4];
        
        
        UILocalNotification *notification_1 = [[UILocalNotification alloc]init];
        if (notification_1)
        {
            notification_1.repeatInterval = 0;
            notification_1.fireDate = daysLater_1;
            notification_1.timeZone = [NSTimeZone defaultTimeZone];
            notification_1.soundName = UILocalNotificationDefaultSoundName;
            notification_1.alertBody = @"How are you today? Any expenses or incomes?";
            NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"Expense 5" forKey:@"Expense 5"];
            notification_1.userInfo = infoDic;
            [application scheduleLocalNotification:notification_1];
        }
        
        UILocalNotification *notification_3 = [[UILocalNotification alloc]init];
        if (notification_3)
        {
            notification_3.repeatInterval = 0;
            notification_3.fireDate = daysLater_3;
            notification_3.timeZone = [NSTimeZone defaultTimeZone];
            notification_3.soundName = UILocalNotificationDefaultSoundName;
            notification_3.alertBody = @"Is it a beautiful day? Record spending or income and make tomorrow better.";
            NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"Expense 5" forKey:@"Expense 5"];
            notification_3.userInfo = infoDic;
            [application scheduleLocalNotification:notification_3];
        }
        
        UILocalNotification *notification_7 = [[UILocalNotification alloc]init];
        if (notification_7)
        {
            notification_7.repeatInterval = 0;
            notification_7.fireDate = daysLater_7;
            notification_7.timeZone = [NSTimeZone defaultTimeZone];
            notification_7.soundName = UILocalNotificationDefaultSoundName;
            notification_7.alertBody = @"How is it going these days? Pocket Expense is waiting for a record.";
            NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"Expense 5" forKey:@"Expense 5"];
            notification_7.userInfo = infoDic;
            [application scheduleLocalNotification:notification_7];
        }
        
        UILocalNotification *notification_21 = [[UILocalNotification alloc]init];
        if (notification_21)
        {
            notification_21.repeatInterval = 0;
            notification_21.fireDate = daysLater_21;
            notification_21.timeZone = [NSTimeZone defaultTimeZone];
            notification_21.soundName = UILocalNotificationDefaultSoundName;
            notification_21.alertBody = @"Does everything go well? Pocket Expense is worried about you.";
            NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"Expense 5" forKey:@"Expense 5"];
            notification_21.userInfo = infoDic;
            [application scheduleLocalNotification:notification_21];
        }

    }
    
    //设置bill通知
//    [self getRecentlyTwoMonthesand50NeedtoReminderBills];
}

//取消通知
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application cancelAllLocalNotifications];
    [FBSDKAppEvents activateApp];
}

-(void)setFlurry
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    long enterappCount = [userDefaults integerForKey:ENTERAPP_COUNT];
    enterappCount ++;
    [userDefaults  setInteger:enterappCount forKey:ENTERAPP_COUNT];
    
    //正式版
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [Flurry setAppVersion:version];

    if (self.isPurchased)
    {
        [Flurry startSession:@"VJB1UAT5LL1INY2R2CDG"];
    }
    //免费版
    else
    {
        [Flurry startSession:@"3HS8MB17815E655C4CSY"];

    }
}

-(void)initLitePurchaseInformation
{
    
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    Setting* setting = [[XDDataManager shareManager] getSetting];
    
    NSString* productID = setting.purchasedProductID;
    BOOL isPurchase = [setting.purchasedIsSubscription boolValue];
    //判断免费版是否被购买了
    if ([defaults2 valueForKey:LITE_UNLOCK_FLAG] || (productID.length > 0 && isPurchase))
    {
        self.isPurchased = YES;
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:YES];

    }
    else
    {
        self.isPurchased = NO;
        [[XDDataManager shareManager]openWidgetInSettingWithBool14:NO];

    }

}


//内购流程2:获取商品信息成功之后，把商品信息存储起来，发送通知让相关页面把价格显示出来
-(void)updateTheBarTitleWithPrice:(double)p withLocal:(NSLocale*)l productID:(NSString*)productID
{
    //保存商品的价格信息到本地，方便没网的时候获取
    NSNumberFormatter *numberFmt =[[NSNumberFormatter alloc] init];
    [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];

    [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFmt setLocale:l];
    [numberFmt setMaximumFractionDigits:2];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([productID isEqualToString:KInAppPurchaseProductIdMonth]) {
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_MONTH];
    }else if ([productID isEqualToString:KInAppPurchaseProductIdYear]){
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_YEAR];
    }else if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]){
        [userDefaults setValue:[numberFmt stringFromNumber:[NSNumber numberWithDouble:p]] forKey:PURCHASE_PRICE_LIFETIME];
    }
    [userDefaults synchronize];
    
    //发送通知，让ads detail页面金额改变.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:GET_PRO_VERSION_PRICE_ACTION object:nil];
}

//添加观察内购成功的通知
-(void)registUnLock_Notificat:(id)observer
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(pop_system_UnlockLite) name:LITE_NOTIFICT_NAME object:nil];
}

//当内购成功时，就发送通知，使得其他地方的功能解锁
-(void)popUnLock_Notificat
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LITE_NOTIFICT_NAME object:nil];
}
-(void)removeUnLock_Notificat:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:LITE_NOTIFICT_NAME object:nil];
}


//从其他应用打开本应用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)urls sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    

	if (urls!=nil)
	{
        //免费版将数据转移到正式版
        if([@"/importDatabase" isEqualToString:[urls path]])
		{
            if (self.dropbox.drop_account)
            {
                [self.dropbox linkDropBoxAccount:NO fromViewController:self];
                
            }
            
            NSString *query = [urls query];
            
            NSData *importUrlData = [GTMBase64 webSafeDecodeString:query];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *mainPath = [paths objectAtIndex:0];
            
            //将读到的数据填写到Checkbook.zip文件jia中
            [importUrlData writeToFile:[mainPath stringByAppendingPathComponent:@"Expense5.zip"] atomically:YES];
            
            ZipArchive *za = [[ZipArchive alloc] init];
            
            
            //解压之前压缩的文件
            if ([za UnzipOpenFile: [mainPath stringByAppendingPathComponent:@"Expense5.zip"]])
            {
                //temp path is /var/mobile/Applications/02CFB93E-8776-4DC3-9537-5B5871C66A2C/tempToZip/~
                
                //将数据重写写到该app的文件中
                BOOL ret = [za UnzipFileTo:mainPath overWrite: YES];
                
                if (ret)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Pocket Expense data transfer success", nil)
                                                                        message:NSLocalizedString(@"VC_Thanks for using our Full Version! Please restart the Full Version to complete the migration.", nil)
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
                    alertView.tag = 10;
                    [alertView show];
                }
            }
            
            NSFileManager * fil = [NSFileManager defaultManager];
            
            if ([fil fileExistsAtPath:[mainPath stringByAppendingPathComponent:@"Expense5.zip"]])
            {
                [fil removeItemAtPath:[mainPath stringByAppendingPathComponent:@"Expense5.zip"] error:nil];
            }
			else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_PocketExpense data transfer failed", nil)
																	message:NSLocalizedString(@"VC_Please restart the Lite Version to try again.", nil)
																   delegate:self
														  cancelButtonTitle:nil
														  otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
				alertView.tag = 10;
                
 				[alertView show];
				
			}
            

        }
        else if([[urls absoluteString] rangeOfString:@"facebook"].location!=NSNotFound)
        {
            return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:urls sourceApplication:sourceApplication annotation:annotation];
        }
        //dropbox点击允许之后，会请求打开dropbox
        else
        {
            [dropbox dropbox_handleOpenURL:urls];
//            DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:urls];
//            if (account) {
//                NSLog(@"App linked successfully!");
//                return YES;
//            }
            if(self.dropbox.drop_account)
                return YES;
            return NO;
        }
        return YES;
    }
    

    return YES;
}


-(void)budgetErrorCorrection
{
    //created by insert 4.5.1 data to 5.0
    NSFetchRequest *fetchBudgetTemplate = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSError *error = nil;
    NSMutableArray *budgetTemplateArray = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchBudgetTemplate error:&error]];
    
    for (int i=0; i<[budgetTemplateArray count]; i++)
    {
        BudgetTemplate *oneBudgetTemplate = [budgetTemplateArray objectAtIndex:i];
        if ([oneBudgetTemplate.cycleType length]==0)
        {
            oneBudgetTemplate.cycleType = @"No Cycle";
        }
    }
    [self.managedObjectContext save:&error];

    
    //判断这个budgetTemplate中有没有其他相同category的budget,有的话，删除最老的，保存最近的
    for (int i=0; i<[budgetTemplateArray count]; i++)
    {
        BudgetTemplate *oneBudgetTemplate = [budgetTemplateArray objectAtIndex:i];

        //获取这个budget相同category的budgetTemplate
        NSFetchRequest *fetchBudgetTemplate = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"category == %@",oneBudgetTemplate.category];
        [fetchBudgetTemplate setPredicate:pre];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:YES];
        NSArray *sorts = [[NSArray alloc]initWithObjects:sort, nil];
        [fetchBudgetTemplate setSortDescriptors:sorts];

        
        NSMutableArray *sameCategoryBudget =  [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchBudgetTemplate error:&error]];
        
        for (int m=0; m<[sameCategoryBudget count]; m++)
        {
            BudgetTemplate *onebudget = [sameCategoryBudget objectAtIndex:m];
            
            if (m==[sameCategoryBudget count]-1)
            {
                if(onebudget.category != nil)
                {
                    onebudget.category.budgetTemplate = onebudget;
                    if ([onebudget.budgetItems count]==0)
                    {
                        NSDate *startDate =[self.epnc getFirstSecByDate:onebudget.startDate];
                        
                        NSDate *tmpDate =[self.epnc getDate: startDate byCycleType:onebudget.cycleType];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                        NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
                        [dc1 setDay:-1];
                        NSDate *endDate =[self.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate options:0]];
                        [self.epdc insertBudgetItem:onebudget withStartDate:onebudget.startDate EndDate:endDate];

                    }
                }
                else
                    [self.epdc deleteBudgetRel_withoutSync:onebudget];
                
                
            }
            else
                [self.epdc deleteBudgetRel_withoutSync:onebudget];

        }
    }
    
    [self.managedObjectContext save:&error];

}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	//NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PokcetExpense" withExtension:@"momd"];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"PokcetExpense" ofType:@"momd"];
	NSURL *momURL = [NSURL fileURLWithPath:path];

    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];    
     return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
//    NSURL *oldStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]URLByAppendingPathComponent:@"Expense5.0.0.sqlite"];
//
//    NSURL *storeURL = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.btgs.pocketExpenseLite.coredata"] URLByAppendingPathComponent:@"Expense5.0.0.sqlite"];
//
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//
//    if (!([[NSUserDefaults standardUserDefaults] integerForKey:@"MoveCoredata"]>=1)) {
//        //未迁移
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MoveCoredata"];
//
//        NSPersistentStore   *sourceStore        = nil;
//        NSPersistentStore   *destinationStore   = nil;
//
//        NSError *error1 = nil;
//
//        // Add the source store
//        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:oldStoreURL options:nil error:&error1]){
//
//            NSError *error = nil;
//            NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//            dict[NSUnderlyingErrorKey] = error;
//            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
////            abort();
//
//        } else {
//            sourceStore = [persistentStoreCoordinator persistentStoreForURL:oldStoreURL];
//            if (sourceStore != nil){
//                // Perform the migration
//                destinationStore = [persistentStoreCoordinator migratePersistentStore:sourceStore toURL:storeURL options:nil withType:NSSQLiteStoreType error:&error1];
//                if (destinationStore == nil){
//                    // Handle the migration error
//
//                    NSError *error = nil;
//                    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//                    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//                    dict[NSUnderlyingErrorKey] = error;
//                    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//                    // Replace this with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
////                    abort();
//
//                } else {
//
//                    [[NSFileManager defaultManager] removeItemAtURL:oldStoreURL error:nil];
//
//                    // You can now remove the old data at oldStoreURL
//                    // Note that you should do this using the NSFileCoordinator/NSFilePresenter APIs, and you should remove the other files
//                    // described in QA1809 as well.
//                }
//            }
//        }
//
//    }else{
//        //已迁移
//
//        NSError *error = nil;
//        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//            // Report any error we got.
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//            dict[NSUnderlyingErrorKey] = error;
//            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
////            abort();
//        }
//    }
    
    bool needMigrate = false;
    bool needDeleteOld  = false;
    
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]URLByAppendingPathComponent:@"Expense5.0.0.sqlite"];
    NSURL *groupURL = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.btgs.pocketExpenseLite.coredata"] URLByAppendingPathComponent:@"Expense5.0.0.sqlite"];
    NSURL *targetURL =  nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        NSLog(@"old single app db exist.");
        targetURL = storeURL;
        needMigrate = true;
        needDeleteOld = true;
    }
    if ([fileManager fileExistsAtPath:[groupURL path]]) {
        needMigrate = false;
        targetURL = groupURL;
    }
    
    if (targetURL == nil)
        targetURL = groupURL;
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES), NSInferMappingModelAutomaticallyOption: @(YES)};
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSPersistentStore *store;
    store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:targetURL options:options error:&error];
    
    if (!store) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (needMigrate) {
        NSError *error = nil;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:persistentStoreCoordinator];
        [persistentStoreCoordinator migratePersistentStore:store toURL:groupURL options:options withType:NSSQLiteStoreType error:&error];
        if (error != nil) {
            NSLog(@"Error when migration to group url %@, %@", error, [error userInfo]);
            abort();
        } else {
            if (needDeleteOld) {
                [self deleteDocumentAtUrl:storeURL];
                NSURL *storeURL_shm = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Expense5.0.0.sqlite-shm"]];
                [self deleteDocumentAtUrl:storeURL_shm];
                NSURL *storeURL_wal = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Expense5.0.0.sqlite-wal"]];
                [self deleteDocumentAtUrl:storeURL_wal];
            }
        }
    }

    return persistentStoreCoordinator;

}

-(void) deleteDocumentAtUrl:(NSURL *)url {
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    [fileCoordinator coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting error:nil byAccessor:^(NSURL * _Nonnull newURL) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:&error];
        if (error) {
            NSLog(@"delete old database failed - %@,",error.localizedDescription);
        }
    }];
}

-(void)setScheduleBadge:(NSString*)value
{
 	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[value intValue]];
}

#pragma mark -
#pragma mark Application's Documents directory

//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[NSFileManager defaultManager]
//            containerURLForSecurityApplicationGroupIdentifier:@"group.com.btgs.pocketExpenseLite.coredata"];
//
//}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSString *)applicationGroupContainerDirectory{
    NSString *targetPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.btgs.pocketExpenseLite.coredata"].path;
    return targetPath;
}

#pragma mark Add Notification
-(void)getRecentlyTwoMonthesand50NeedtoReminderBills{
    
    numberofReminderBill=0;

    [app_reminderAllArray removeAllObjects];
    [app_reminderBill1Array removeAllObjects];
    [app_reminderBill2Array removeAllObjects];
    
    NSDate *startDate = [NSDate date];
    NSCalendar *cal =[NSCalendar currentCalendar];
    unsigned int  flags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [cal components:flags fromDate:startDate];
    dateComponent.year = dateComponent.year;
    dateComponent.month = dateComponent.month+2;
    dateComponent.day=dateComponent.day;
    dateComponent.hour =dateComponent.hour;
    dateComponent.minute = dateComponent.minute;
    dateComponent.second = dateComponent.second;
    NSDate *endDate = [cal dateFromComponents:dateComponent];
    NSDictionary *subs =  [[NSDictionary alloc]initWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    //获取BK_Bill中所有的bill
    NSError *error = nil;
    NSFetchRequest *fetch = [self.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBillRuleByReminder" substitutionVariables:subs];
    NSArray *bill1tempArray = [[NSArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetch error:&error]];
    [app_reminderBill1Array setArray:bill1tempArray];
    
    //获取BK_BillObject中 近两个月的Bill
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"searchBillItembyDateandReminder" substitutionVariables:subs];
    NSArray *objects = [[NSArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    [app_reminderBill2Array setArray:objects];
    
    [self useBill1CreateBillFather_Reminder];
    [self useBill2createRealAllArray_Reminder];
    [self sortWithTime_Reminder];
    [self addLocalNotification_Reminder];
}


-(void)useBill1CreateBillFather_Reminder{
    NSDate *startDate = [NSDate date];
    NSCalendar *cal =[NSCalendar currentCalendar];
    unsigned int  flags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [cal components:flags fromDate:startDate];
    dateComponent.year = dateComponent.year;
    dateComponent.month = dateComponent.month+2;
    dateComponent.day=dateComponent.day;
    dateComponent.hour =dateComponent.hour;
    dateComponent.minute = dateComponent.minute;
    dateComponent.second = dateComponent.second;
    NSDate *endDate = [cal dateFromComponents:dateComponent];
    
    
    for (int i=0; i<[app_reminderBill1Array count]; i++) {
        
        EP_BillRule *bill = [app_reminderBill1Array objectAtIndex:i];
        
        
        //先判断是够是循环，不是循环 1.是不是过期了 2.是不是付过了 3.有没有reminder并且reminder是不是过期了
        if ([bill.ep_recurringType isEqualToString:@"Never"]) {
            NSArray *paymentArray = [[NSArray alloc]initWithArray:[bill.billRuleHasTransaction allObjects]];
            double paymentAmount = 0.00;
            for (int n=0; n<[paymentArray count]; n++) {
                Transaction *onepayment = [paymentArray objectAtIndex:n];
                paymentAmount = paymentAmount +[onepayment.amount doubleValue];
            }
            
            //过期了
            if ([self.epnc dateCompare:bill.ep_billDueDate withDate:startDate]<0) {
                continue;
            }
            //付清了
            else if (paymentAmount >= [bill.ep_billAmount doubleValue]){
                continue;
            }
            else if ([bill.ep_reminderDate isEqualToString:@"None"] || bill.ep_reminderDate==nil){
                continue;
            }
            else{
                NSDate *reminderDate;
                NSCalendar *cal =[NSCalendar currentCalendar];
                unsigned int  flags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
                
                //判断提前几天提醒，这个提前几天的时间是不是比现在时间早，早的话就不加入通知中
                NSDateComponents *dateComponent = [cal components:flags fromDate:bill.ep_billDueDate];
                dateComponent.year = dateComponent.year;
                dateComponent.month=dateComponent.month;
                if ([bill.ep_reminderDate isEqualToString:@"On date of event"]) {
                    dateComponent.day = dateComponent.day;
                }
                else if ([bill.ep_reminderDate isEqualToString:@"1 day before"]){
                    dateComponent.day = dateComponent.day-1;
                }
                else if ([bill.ep_reminderDate isEqualToString:@"2 days before"]){
                    dateComponent.day = dateComponent.day-2;
                }
                else if([bill.ep_reminderDate isEqualToString:@"3 days before"]){
                    dateComponent.day = dateComponent.day-3;
                }
                else if ([bill.ep_reminderDate isEqualToString:@"1 week before"]){
                    dateComponent.day = dateComponent.day-7;
                }
                else if ([bill.ep_reminderDate isEqualToString:@"2 weeks before"]){
                    dateComponent.day = dateComponent.day-14;
                }
                NSDateComponents *dateComponent1 = [cal components:flags fromDate:bill.ep_reminderTime];
                dateComponent.hour = dateComponent1.hour;
                dateComponent.minute = dateComponent1.minute;
                dateComponent.second=0;
                reminderDate = [cal dateFromComponents:dateComponent];
                
                if ([self.epnc dateCompare:reminderDate withDate:startDate]<0) {
                    continue;
                }
                else{
                    BillFather *billFather = [[BillFather alloc]init];
                    [self.epdc editBillFather:billFather withBillRule:bill withDate:nil];
                    [app_reminderAllArray addObject:billFather];
                    
                }
            }
            continue;
            
        }
        //循环bill
        else{
            if ([self.epnc dateCompare:bill.ep_billDueDate withDate:endDate]>0) {
                continue;
            }
            else if ([self.epnc dateCompare:bill.ep_billDueDate withDate:startDate]<0){
                continue;
            }
            else if([bill.ep_reminderDate isEqualToString:@"None"]){
                continue;
            }
            else
            {
                NSDate *lastDate = bill.ep_billDueDate;
                
                NSDate *endDateorBillEndDate = [self.epnc dateCompare:endDate withDate:bill.ep_billEndDate]<0?endDate : bill.ep_billEndDate;
                if ([self.epnc dateCompare:lastDate withDate:endDateorBillEndDate]>0)
                {
                    return;
                }
                else{
                    //循环创建账单
                    while ([self.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
                    {
                        
                        BillFather *oneBillfather = [[BillFather alloc]init];
                        
                        [self.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                        
                        [app_reminderAllArray  addObject:oneBillfather];
                        //获取下一次循环的时间
                        lastDate= [self.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
                    }
                }
            }

        }
        
    }
}

-(void)useBill2createRealAllArray_Reminder{
    
    
    for (int i=0; i<[app_reminderBill2Array count]; i++) {
        EP_BillItem *billObject = [app_reminderBill2Array objectAtIndex:i];
        
        double paymentAmount = 0.00;
        NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[billObject.billItemHasTransaction allObjects]];
        
        for (int n=0; n<[paymentarray count]; n++) {
            Transaction *onepayment = [paymentarray objectAtIndex:n];
            paymentAmount = paymentAmount +[onepayment.amount doubleValue];
        }
        //bill is paid over
       if (paymentAmount>=[billObject.ep_billItemAmount doubleValue])
        {
            for (int j=0; j<[app_reminderAllArray count]; j++) {
                BillFather   *checkedBill = [app_reminderAllArray objectAtIndex:j];
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule  && [self.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                    [app_reminderAllArray removeObject:checkedBill];
                    break;
                }
            }
        }
        //bill is delete
        else if ([billObject.ep_billisDelete boolValue]){
            for (int j=0; j<[app_reminderAllArray count]; j++) {
                BillFather   *checkedBill = [app_reminderAllArray objectAtIndex:j];
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [self.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                    [app_reminderAllArray removeObject:checkedBill];
                }
            }
            
        }
        //如果没有被支付，那么就需要修改billtotalArray中的内容
        else{
            int j;
            for (j=0; j<[app_reminderAllArray count]; j++) {
                BillFather   *checkedBill = [app_reminderAllArray objectAtIndex:j];
                
                //获取两个账单的日期组件
                NSCalendar *cal = [NSCalendar currentCalendar];
                //日历组成单元标识
                unsigned int unitFlags1 = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
                //日历组成单元
                NSDateComponents *components1 = [cal components:unitFlags1 fromDate:billObject.ep_billItemDueDate ];
                //设置组成单元
                NSDateComponents *components2 = [cal components:unitFlags1 fromDate:checkedBill.bf_billDueDate];
                BOOL isSameDay = NO;
                if (components1.year==components2.year && components1.month==components2.month && components1.day==components2.day)
                    isSameDay = YES;
                
                //如果查找到相等的就替换
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule && isSameDay) {
                    
                    [self.epdc editBillFather:checkedBill withBillItem:billObject];
                }
            }
            //表示 这个bill2没存在billall中但是符合提醒的条件就加进去
            if (j>=[app_reminderAllArray count]) {
                BillFather   *oneBillFather =[[BillFather alloc]init];
                [self.epdc editBillFather:oneBillFather withBillItem:billObject];
                [app_reminderAllArray addObject:oneBillFather];
                
            }
        }
        
    }
    
}

-(void)sortWithTime_Reminder{
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [app_reminderAllArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [app_reminderAllArray setArray:ar];
    
}
-(void)addLocalNotification_Reminder{
    
    NSInteger num = 50>[app_reminderAllArray count]?[app_reminderAllArray count]:50;
    for (int i=0; i<num; i++)
    {
        BillFather *oneBillfather = [app_reminderAllArray objectAtIndex:i];
        
        NSDate *reminderDate;
        NSCalendar *cal =[NSCalendar currentCalendar];
        unsigned int  flags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        
        //判断提前几天提醒，这个提前几天的时间是不是比现在时间早，早的话就不加入通知中
        NSDateComponents *dateComponent = [cal components:flags fromDate:oneBillfather.bf_billDueDate];
        dateComponent.year = dateComponent.year;
        dateComponent.month=dateComponent.month;
        if ([oneBillfather.bf_billReminderDate isEqualToString:@"On date of event"]) {
            dateComponent.day = dateComponent.day;
        }
        else if ([oneBillfather.bf_billReminderDate isEqualToString:@"1 day before"]){
            dateComponent.day = dateComponent.day-1;
        }
        else if ([oneBillfather.bf_billReminderDate isEqualToString:@"2 days before"]){
            dateComponent.day = dateComponent.day-2;
        }
        else if([oneBillfather.bf_billReminderDate isEqualToString:@"3 days before"]){
            dateComponent.day = dateComponent.day-3;
        }
        else if ([oneBillfather.bf_billReminderDate isEqualToString:@"1 week before"]){
            dateComponent.day = dateComponent.day-7;
        }
        else if ([oneBillfather.bf_billReminderDate isEqualToString:@"2 weeks before"]){
            dateComponent.day = dateComponent.day-14;
        }
        NSDateComponents *dateComponent1 = [cal components:flags fromDate:oneBillfather.bf_billReminderTime];
        dateComponent.hour = dateComponent1.hour;
        dateComponent.minute = dateComponent1.minute;
        dateComponent.second=1;
        reminderDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponent];
        
        
        if ([self.epnc secondCompare:reminderDate withDate:[NSDate date]]>=0 ) {
            
            
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            if (noti)
            {
                noti.repeatInterval = 0;
                noti.fireDate = reminderDate;
                noti.timeZone = [NSTimeZone defaultTimeZone];
                noti.soundName = UILocalNotificationDefaultSoundName;
                NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MM dd, yyyy"];
                
                NSString *dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:oneBillfather.bf_billDueDate]];
                
                noti.alertBody = [NSString stringWithFormat:@"%@ on %@ need to paid.",oneBillfather.bf_billRule.ep_billName,dateString];
                NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"Expense 5" forKey:@"Expense 5"];
                noti.userInfo = infoDic;
                UIApplication *app = [UIApplication sharedApplication];
                [app scheduleLocalNotification:noti];
            }
        }
    }
}

-(void)loadHMJIndicator
{
    hmjIndicator = [[HMJActivityIndicator alloc]initWithFrame:CGRectMake((self.window.frame.size.width-100)/2, (self.window.frame.size.height-100)/2, 100, 100)];
    [self.window addSubview:self.hmjIndicator];
    self.hmjIndicator.hidden = YES;
    
    _hmjSyncIndicator = [[HMJSyncIndicatorView alloc]initWithFrame:CGRectMake((self.window.frame.size.width-100)/2,(self.window.frame.size.height-100)/2, 100, 100)];
    _hmjSyncIndicator.backgroundColor = [UIColor clearColor];
    [self.window addSubview:_hmjSyncIndicator];
    _hmjSyncIndicator.hidden = YES;
}




-(void)showIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hmjIndicator.hidden = NO;
        [self.window bringSubviewToFront:self.hmjIndicator];
        self.window.userInteractionEnabled = NO;
        [self.hmjIndicator.indicator startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideIndicator];
    });
}

-(void)hideIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hmjIndicator.hidden = YES;
        self.window.userInteractionEnabled = YES;
        [self.hmjIndicator.indicator stopAnimating];
    });
  
}

-(void)showSyncIndicator
{
    self.hmjSyncIndicator.hidden = NO;
    [self.window bringSubviewToFront:self.hmjSyncIndicator];
//    self.window.userInteractionEnabled = NO;
    [self.hmjSyncIndicator.indicator startAnimating];
    
    
    
    if (ISPAD)
    {
        if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
            return;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGFloat angle = 0.0;
        CGRect newFrame = CGRectMake((self.window.frame.size.width-100)/2,(self.window.frame.size.height-100)/2, 100, 100);
        CGSize statusBarSize = CGSizeZero;// [[UIApplication sharedApplication] statusBarFrame].size;
        
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                newFrame.size.height -= statusBarSize.height;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = - M_PI / 2.0f;
                
                newFrame.origin.x += statusBarSize.width;
                newFrame.size.width -= statusBarSize.width;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI / 2.0f;
                
                newFrame.size.width -= statusBarSize.width;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = 0.0;
                newFrame.origin.y += statusBarSize.height;
                newFrame.size.height -= statusBarSize.height;
                break;
        }
        self.hmjSyncIndicator.transform = CGAffineTransformMakeRotation(angle);
        self.hmjSyncIndicator.frame = newFrame;
        
    }
}

-(void)hideSyncIndicator
{
    self.hmjSyncIndicator.hidden = YES;
//    self.window.userInteractionEnabled = YES;
    [self.hmjSyncIndicator.indicator stopAnimating];
}


#pragma mark UIAlertView Method
-(void)hidePopView{
    if (self.appActionSheet != nil)
    {
        [self.appActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    }
    if (self.appAlertView != nil)
    {
        [self.appAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
}

#pragma mark GAD BANNER VIEW DELEGATE

- (BOOL)networkConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    BOOL isConnect = networkStatus != NotReachable;
    return isConnect;
}






#pragma mark Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark - 登录注册 可以调用的方法
-(void)addUUID
{
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
        switch (i) {
            case 0:
                for (int j=0; j<datas.count; j++)
                {
                    Accounts *account=[datas objectAtIndex:j];
                    if (account.uuid==nil)
                    {
                        account.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 1:
                for (int j; j<datas.count; j++)
                {
                    AccountType *accountType=[datas objectAtIndex:j];
                    if (accountType.uuid==nil)
                    {
                        accountType.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 2:
                for (int j; j<datas.count; j++)
                {
                    BudgetItem *budgetItem=[datas objectAtIndex:j];
                    if (budgetItem.uuid)
                    {
                        budgetItem.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 3:
                for (int j; j<datas.count; j++)
                {
                    BudgetTemplate *budgetTemplate=[datas objectAtIndex:j];
                    if (budgetTemplate.uuid==nil)
                    {
                        budgetTemplate.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 4:
                for (int j; j<datas.count; j++)
                {
                    BudgetTransfer *budgetTransfer=[datas objectAtIndex:j];
                    if (budgetTransfer.uuid==nil)
                    {
                        budgetTransfer.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 5:
                for (int j; j<datas.count; j++)
                {
                    Category *category=[datas objectAtIndex:j];
                    if (category.uuid==nil)
                    {
                        category.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 6:
                for (int j; j<datas.count; j++)
                {
                    EP_BillItem *billItem=[datas objectAtIndex:j];
                    if (billItem.uuid==nil)
                    {
                        billItem.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 7:
                for (int j; j<datas.count; j++)
                {
                    EP_BillRule *billRule=[datas objectAtIndex:j];
                    if (billRule.uuid==nil)
                    {
                        billRule.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 8:
                for (int j; j<datas.count; j++)
                {
                    Payee *payee=[datas objectAtIndex:j];
                    if (payee.uuid==nil)
                    {
                        payee.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            case 9:
                for (int j; j<datas.count; j++)
                {
                    Transaction *transaction=[datas objectAtIndex:j];
                    if (transaction.uuid==nil)
                    {
                        transaction.uuid=[EPNormalClass GetUUID];
                    }
                }
                break;
            default:
                break;
        }
    }
    
}
-(void)addUpdatedTime
{
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
        switch (i) {
            case 0:
                for (int j=0; j<datas.count; j++)
                {
                    Accounts *account=[datas objectAtIndex:j];
                    account.updatedTime=account.dateTime;
                }
                break;
            case 1:
                for (int j=0; j<datas.count; j++)
                {
                    AccountType *accountType=[datas objectAtIndex:j];
                    accountType.updatedTime=accountType.dateTime;
                }
                break;
            case 2:
                for (int j=0; j<datas.count; j++)
                {
                    BudgetItem *budgetItem=[datas objectAtIndex:j];
                    budgetItem.updatedTime=budgetItem.dateTime;
                }
                break;
            case 3:
                for (int j=0; j<datas.count; j++)
                {
                    BudgetTemplate *budgetTemplate=[datas objectAtIndex:j];
                    budgetTemplate.updatedTime=budgetTemplate.dateTime;
                }
                break;
            case 4:
                for (int j=0; j<datas.count; j++)
                {
                    BudgetTransfer *budgetTransfer=[datas objectAtIndex:j];
                    budgetTransfer.updatedTime=budgetTransfer.dateTime;
                }
                break;
            case 5:
                for (int j=0; j<datas.count; j++)
                {
                    Category *category=[datas objectAtIndex:j];
                    category.updatedTime=category.dateTime;
                }
                break;
            case 6:
                for (int j=0; j<datas.count; j++)
                {
                    EP_BillItem *billItem=[datas objectAtIndex:j];
                    billItem.updatedTime=billItem.dateTime;
                }
                break;
            case 7:
                for (int j=0; j<datas.count; j++)
                {
                    EP_BillRule *billRule=[datas objectAtIndex:j];
                    billRule.updatedTime=billRule.dateTime;
                }
                break;
            case 8:
                for (int j=0; j<datas.count; j++)
                {
                    Payee *payee=[datas objectAtIndex:j];
                    payee.updatedTime=payee.dateTime;
                }
                break;
            case 9:
                for (int j=0; j<datas.count; j++)
                {
                    Transaction *transaction=[datas objectAtIndex:j];
                    transaction.updatedTime=transaction.dateTime;
                }
                break;
            default:
                break;
        }
    }
    
}

-(BOOL)databaseHasData
{
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction",@"User"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
        
        if ([[dbName objectAtIndex:i] isEqualToString:@"Accounts"])
        {
            for (Accounts *account in datas)
            {
                if (![account.uuid isEqualToString:@"E0552410-9082-4B31-96D3-7A777F046AB4"])
                {
                    return YES;
                }
            }
        }
        else if ([[dbName objectAtIndex:i]isEqualToString:@"Category"])
        {
            for (Category *category in datas)
            {
                if (!category.isSystemRecord)
                {
                    return YES;
                }
            }
        }
        else if ([[dbName objectAtIndex:i]isEqualToString:@"AccountType"])
        {
            NSArray *array=@[@"EB77B173-7BE4-458E-B1DD-0309EBF3A12C",
                             @"3E3BEB88-153A-4ACB-AE15-3B2B7935D56E",
                             @"B10A95AC-6BA2-401A-9A67-AF667313872F",
                             @"A8D6FFD2-602B-4E23-AA86-44751A2234C6",
                             @"A54BB0EF-17DF-4BA5-BB1E-A24AC31DA138",
                             @"4C9ACC13-D22D-4A7F-ABB3-7A5A7C94EAA2",
                             @"F2243FC7-6E01-4CD8-8A03-6AE56E7B20E1",
                             @"9832B8FA-537C-4963-8CA9-19385E9732E5",
                             @"9C4251B9-5B57-4472-8B6E-BAF1A4D60650"];
            for (AccountType *accountType in datas)
            {
                if (![array containsObject:accountType.uuid])
                {
                    return YES;
                }
            }
        }
        else
        {
            if (datas.count)
            {
                return YES;
            }
        }
    }
    return NO;
}
-(void)removeAllData
{
    NSArray   *dbName=@[@"Accounts",@"AccountType",@"BillReports",@"BillRule",@"BudgetItem",@"BudgetReports",@"BudgetTemplate",@"BudgetTransfer",@"CashFlowReports",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction",@"TransactionReports",@"TransactionRule",@"User"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
        requestLocal.entity=descLocal;
        
        NSError *error;
        NSArray *datas=[self.managedObjectContext executeFetchRequest:requestLocal error:&error];
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                [self.managedObjectContext deleteObject:obj];
            }
            if (![self.managedObjectContext save:&error])
            {
                NSLog(@"error:%@",error);
            }
        }
    }
    
    Setting* setting = [[XDDataManager shareManager] getSetting];
    setting.purchasedProductID = nil;
    setting.purchasedStartDate = nil;
    setting.purchasedEndDate = nil;
    setting.dateTime = nil;
    setting.otherBool17 = nil;
    setting.purchasedIsSubscription = nil;
    setting.purchaseOriginalProductID = nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LITE_UNLOCK_FLAG];
    
    [[XDDataManager shareManager] saveContext];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //设置NSUserDefault
    [userDefaults setBool:NO forKey:@"Default Account"];
    //存储的时候要加这一句
    [userDefaults synchronize];
    
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
        }
    }
    
    
}
-(void)removeUserDefaultDate
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
-(void)afterDropbox
{
    if ([self databaseHasData])
    {
        //为每条数据加上uuid
        [self addUUID];
        [self addUpdatedTime];
        
    }
    else
    {
        //无数据
        [self.epdc initializeAccountType];
        [self.epdc initializeCategory];
        [self.epdc createDefaultAccount];
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    NSError *error;
    
    User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
    user.userObjectId=[[PFUser currentUser]objectId];
    
    if (self.isPurchased)
    {
        user.purchaseType=[NSNumber numberWithInt:0];
    }
    else
    {
        user.purchaseType=[NSNumber numberWithInt:2];
    }
    [self.managedObjectContext save:&error];
    
    PFObject *userServer=[PFUser currentUser];
    if (self.isPurchased)
    {
        userServer[@"purchaseType"]=[NSNumber numberWithInt:0];
    }
    else
    {
        userServer[@"purchaseType"]=[NSNumber numberWithInt:2];
    }
    [userServer saveInBackground];

    [[ParseDBManager sharedManager]dataSyncWithServer];
    
}


-(void)downloadEveryData:(PFQuery *)query with:(NSError **)error
{
    NSMutableArray *allObjects=[NSMutableArray array];
    
    __block NSInteger limit=1000;
    __block NSInteger skip=0;
    __block NSInteger count;
    [query setLimit:limit];
    [query setSkip:skip];
    do{
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [allObjects addObjectsFromArray:objects];
            skip+=limit;
            [query setSkip:skip];
            count=objects.count;
            
            for (PFObject *object in objects)
            {
                [object deleteEventually];
               
            }
            
        }];
    } while (count==limit);
}

-(void)restoreDelete
{
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction"];
    for (int i=0; i<dbName.count; i++)
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@",[PFUser currentUser]];
        PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
        NSError *error=nil;
        [self downloadEveryData:query with:&error];
//
//
//        for (PFObject *object in array)
//        {
//            NSError *deleteError=nil;
//            [object deleteEventually];
//            if (error)
//            {
//                NSLog(@" delete Error : %@",deleteError);
//            }
//        }
    }
}

-(void)afterRestore
{
    if (![self networkConnected])
    {
        return;
    }
    NSError *error;
    
    //初始化RestoreUUID字符串
    NSString *serverRestoreUUID=nil;
    NSString *localRestoreUUID=nil;
    
    PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    NSArray *array=[query findObjects:&error];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    localRestoreUUID=[userDefaults objectForKey:@"restoreUUID"];
    
    if (array.count)
    {

    }
    else
    {
        //云端尚未存储该用户的setting数据
        PFObject *setting=[PFObject objectWithClassName:@"Setting"];
        setting[@"restoreUUID"]=[EPNormalClass GetUUID];
        setting[@"User"]=[PFUser currentUser];
        [setting save:&error];
        serverRestoreUUID=setting[@"restoreUUID"];
    }
    if (localRestoreUUID==nil)
    {
        NSString *UUIDString=[EPNormalClass GetUUID];
        [userDefaults setValue:UUIDString forKey:@"restoreUUID"];
        [userDefaults synchronize];
    }
    
//    if (![serverRestoreUUID isEqualToString:localRestoreUUID])
//    {
//        [self removeAllData];
//        
//        [self.epdc initializeAccountType];
//        [self.epdc initializeCategory];
//        [self.epdc createDefaultAccount];
//        
//        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
//        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
//        user.userObjectId=[[PFUser currentUser]objectId];
//        [self.managedObjectContext save:&error];
//        
//        //将本机 restoreUUID 修改同云端同步
//        [userDefaults setObject:serverRestoreUUID forKey:@"restoreUUID"];
//        [userDefaults synchronize];
//        
//    }
    
}
-(void)restoreData
{
    if (![self networkConnected])
    {
        return;
    }
    
    NSError *error;
    
    PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    NSArray *array=[query findObjects:&error];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    PFObject *object=[array objectAtIndex:0];
    
    NSString *serverRestoreUUID=object[@"restoreUUID"];
    NSString *localRestoreUUID=[userDefaults objectForKey:@"restoreUUID"];
    
    if (![serverRestoreUUID isEqualToString:localRestoreUUID])
    {
        [self removeAllData];
        
        [self.epdc initializeAccountType];
        [self.epdc initializeCategory];
        [self.epdc createDefaultAccount];
        
        User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
        user.userObjectId=[[PFUser currentUser]objectId];
        [self.managedObjectContext save:&error];
        
        //将本机 restoreUUID 修改同云端同步
        [userDefaults setObject:serverRestoreUUID forKey:@"restoreUUID"];
        [userDefaults synchronize];

    }
    
    
}
@end



@implementation UIViewController (Custom)

@end



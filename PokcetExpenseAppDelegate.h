//
//  PokcetExpenseAppDelegate.h
//  PokcetExpense
//
//  Created by ZQ on 9/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Setting+CoreDataClass.h"
#import "Appirater.h"


#import "AccountType.h"
#import "Category.h"
#import "BudgetTemplate.h"
#import "BudgetItem.h"
#import "EPNormalClass.h"
#import "EPDataBaseModifyClass.h"

#import "DropboxObject.h"
#import "InAppPurchaseManager.h"
#import "HMJActivityIndicator.h"
#import "HMJSyncIndicatorView.h"
//广告
//#import <GoogleMobileAds/GoogleMobileAds.h>
//--------------定义一个弹出来的 pop 视图类型
typedef enum {
	nonePopup =0,
	dateRangePopup =1,
    accountListPopup =2,
    categoryPayeeTranList =3,
    categoryDateTranList =4,
    budgetListPopup=5,
    budgetTransactionListPopup=6,
    budgetTransferPopup_H=7,
    budgetTransferPopup_V=8,

    dateBillListPopup=9,
    reportControlPanel=10,
    
}PopupViewType;

//------------------定义该app iPad 与 iPhone的唯一标示符
#define MY_BANNER_UNITID_IPHONE  @"a14fe919bd516aa"
#define MY_BANNER_UNITID_IPAD  @"a14fe91a6e6a696"

//------------------定义一个总体的类，这是该项目的 最高层的类
//@interface PokcetExpenseAppDelegate : NSObject <UIApplicationDelegate,PurchaseManagerDelegate,GADInterstitialDelegate>
//无广告
@class Reachability;
@interface PokcetExpenseAppDelegate : NSObject <UIApplicationDelegate,PurchaseManagerDelegate,SKRequestDelegate>

{
    
    UIWindow                            *window;
    NSManagedObjectContext              *managedObjectContext;
    NSManagedObjectModel                *managedObjectModel;
    NSPersistentStoreCoordinator        *persistentStoreCoordinator;
    
    //1.时间处理类 2.数据库的操作，设置默认的Account type,category等
	EPNormalClass                       *epnc;
    EPDataBaseModifyClass               *epdc;
	Setting                             *settings;
    
    //提醒的交易的数目
    BOOL                                hasPWDView;
	NSDateFormatter						*dayFormatter;
	NSMutableArray						*backupList;
		

	BOOL                                rotateFlag;
	UIPopoverController                 *AddPopoverController;
	UIPopoverController                 *AddSubPopoverController;
 	UIPopoverController                 *AddThirdPopoverController;
	
    //密码确认界面
	PopupViewType                       pvt;
	NSURL                               *url;
	BOOL                                isRestore;
    
    DropboxObject *dropbox;
    
    //reminder
    NSInteger       numberofReminderBill;
    NSMutableArray *app_reminderBill1Array;
    NSMutableArray *app_reminderBill2Array;
    NSMutableArray *app_reminderAllArray;
    
    //内购
    BOOL isPurchased;
    InAppPurchaseManager *inAppPM;
    
    //广告
//    GADInterstitial *splashInterstitial;
    NSDate  *adsReadyDate;
    
    
}
//是否自动同步
@property(nonatomic,assign)BOOL autoSyncOn;
@property (nonatomic, assign) BOOL  isRestore ;
@property (nonatomic, assign) BOOL	 hasPWDView;
//是否正在同步
@property(nonatomic,assign)BOOL isSyncing;

//是否正在注册
@property (nonatomic,assign)BOOL isSignUping;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) IBOutlet UITabBarController* tabBarController;
@property (nonatomic, strong) EPNormalClass *epnc;
@property (nonatomic, strong) EPDataBaseModifyClass *epdc;

@property (nonatomic, strong) Setting									*settings;
@property (nonatomic, strong) NSDateFormatter							*dayFormatter;
@property (nonatomic, strong) NSMutableArray							*backupList;
//@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic) BOOL	  rotateFlag;
@property (nonatomic, strong) UIPopoverController *AddPopoverController;
@property (nonatomic, strong) UIPopoverController *AddSubPopoverController;
@property (nonatomic, strong) UIPopoverController *AddThirdPopoverController;
@property (nonatomic, assign) PopupViewType pvt;
@property (nonatomic, strong) NSURL									* url;

@property(nonatomic,strong)DropboxObject *dropbox;
@property(nonatomic,assign)NSInteger       numberofReminderBill;
@property(nonatomic,strong)NSMutableArray *app_reminderBill1Array;
@property(nonatomic,strong)NSMutableArray *app_reminderBill2Array;
@property(nonatomic,strong)NSMutableArray *app_reminderAllArray;

@property(nonatomic,strong)UIActionSheet *appActionSheet;
@property(nonatomic,strong)UIAlertView   *appAlertView;
@property(nonatomic,strong)HMJActivityIndicator *hmjIndicator;
@property(nonatomic,strong)HMJSyncIndicatorView *hmjSyncIndicator;


@property(nonatomic,assign)BOOL isPurchased;
@property(nonatomic,strong)InAppPurchaseManager *inAppPM;
@property(nonatomic,strong)NSDate *applicationLaunchDate;


//1.获取Document 2.更新app icon图标右上角的数字标志 3.设置app icon右上角的标志 4.
-(NSString *)applicationDocumentsDirectory;
//-(void)updateScheduleBadge;
-(void)setScheduleBadge:(NSString*)value;
-(void)saveTranscationDRConfig;
-(void)saveTranscationConfig;
-(void)getRecentlyTwoMonthesand50NeedtoReminderBills;
-(void)budgetErrorCorrection;


-(void)registUnLock_Notificat:(id)observer;
-(void)popUnLock_Notificat;
-(void)removeUnLock_Notificat:(id)observer;
-(void)setFlurry;

-(void)loadHMJIndicator;
-(void)showIndicator;
-(void)hideIndicator;
-(void)hidePopView;
-(void)showSyncIndicator;
-(void)hideSyncIndicator;

- (BOOL)networkConnected;

-(void)addUUID;
-(void)addUpdatedTime;
-(BOOL)databaseHasData;
-(void)removeAllData;
-(void)removeUserDefaultDate;
-(void)afterDropbox;
-(void)afterRestore;
-(void)restoreData;
-(void)restoreDelete;
@end

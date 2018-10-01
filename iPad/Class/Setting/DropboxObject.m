//
//  DropboxObject.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-16.
//
//

#import "DropboxObject.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"
#import "DropboxSyncTableDefine.h"

#import "AccountType.h"
#import "Accounts.h"
#import "Payee.h"
#import "Category.h"
#import "Transaction.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "BudgetTemplate.h"
#import "BudgetItem.h"
#import "BudgetTransfer.h"
#import "EPDataBaseModifyClass.h"

#import "OverViewWeekCalenderViewController.h"
#import "ipad_SyncViewController.h"
#import "User.h"
#import "HMJSyncIndicatorView.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define OLDUSERDATA @"oldUserData"
#define FIRSTLAUNCHSINCEBACKUPOLDUSERDATA @"FirstLanchSinceBackupOldUserData"
//dropbox nil data
#define DROPBOX_NIL_DATA                         @"*db%nil%data%unable%use*"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation DropboxObject
@synthesize drop_accountManager,drop_account,drop_dataStoreManager;
@synthesize isBegaintoReplaceorInteraction;


#pragma mark Get Method
-(DBAccount *)drop_account
{
    return  self.drop_account = [[DBAccountManager sharedManager]linkedAccount];
}

-(DBDatastore *)drop_dataStore
{
    if (!_drop_dataStore)
    {
        _drop_dataStore = [DBDatastore openDefaultStoreForAccount:self.drop_account error:nil];
    }
    return _drop_dataStore;
}

-(DBAccountManager *)drop_accountManager{
    return [DBAccountManager sharedManager];
}


#pragma mark init
-(id)init{
    self = [super init];
    if (self)
    {
        //1.链接账户管理器
        DBAccountManager *mgr = [[DBAccountManager alloc]initWithAppKey:@"6rdffw1lvpr4zuc" secret:@"gxqx0uiav4744o3"];
        [DBAccountManager setSharedManager:mgr];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.dropbox.com/"]];
        connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:NO];

        
        //2.添加account manager
        __weak DropboxObject *slf = self;//这样写为了避免增加指针
        
        _isNeedFlashAll = NO;
        [self setupDatastoreSync];
        
        [self.drop_accountManager  addObserver:self block:^(DBAccount *account) {
            //账户发生改变时响应事件
            [slf setupDatastoreSync];
        }];
    }
    return self;
}


-(void)refreshUI{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:syncNeedToReflashUI object:nil];
}


#pragma mark begain Sync
//2.sync 账户链接状态改变出发
/*
-(void)setupDatastoreSync{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if (self.drop_account)
    {
        [connection start];
        [appDelegate showSyncIndicator];
       

       
        __weak DropboxObject *slf = self;//这样写为了避免增加指针
        
        
        isBegaintoReplaceorInteraction = NO;
        BOOL localhsData = [slf detcetifLocalhasData];
        
        [self.drop_dataStore addObserver:self block:^{

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *oldUserData =  [userDefaults stringForKey:OLDUSERDATA];

            //本地的datastore需要先下载server中的变化，才能把datastore的状态改变
            if (slf.drop_dataStore.status & (DBDatastoreIncoming|DBDatastoreOutgoing))
            {
                //要删掉
//                DBError *dberror = nil;
//                [slf.drop_dataStore sync:&dberror];
                
                
                NSLog(@"处理服务器变化数据--开始");
                
                if ([oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA] && localhsData && !slf.isBegaintoReplaceorInteraction)
                {
                    DBError *dberror = nil;
                    [slf.drop_dataStore sync:&dberror];
                }
                else if (![oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA])
                {
                    [slf detectAllServerChangetoLocal];
                }
                
                NSLog(@"处理服务器变化数据--结束");


            }

            //下载成功的时候才开始比较,最先产生的状态是这个
            if (!(slf.drop_dataStore.status&DBDatastoreDownloading) && slf.isNeedFlashAll)
            {

                //要删掉
//                [slf deleteAllServerData];


                NSLog(@"dropbox下载完成--开始比较双方数据");
                [slf detcetAllServertoLocal_detcetDropboxishasData:NO];

                //hmj delete
//                if ([oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA] && localhsData && !slf.isBegaintoReplaceorInteraction)
//                {
//                    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Old data needs to be processed. Select 'replace' and data on this device will replace data on cloud server, select 'merge' and data will be merged with data on cloud server.", nil) delegate:slf cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VC_Replace", nil),NSLocalizedString(@"VC_Merge", nil), nil] ;
//                    appDelegate.appAlertView = alertView;
//                    alertView.tag = 100;
//                    [alertView show];
//                    slf.isBegaintoReplaceorInteraction = YES;
//                    slf.isNeedFlashAll = NO;
//                
//                    [appDelegate hideSyncIndicator];
//
//                    return ;
//                }
//                //如果不是老用户，就先比较全部
//                else if (![oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA])
//                {
//                    
//                    [slf detcetAllLocaltoServer];
//                    [slf detcetAllServertoLocal_detcetDropboxishasData:NO];
//                    slf.isNeedFlashAll = NO;
//                    
//                }
                
                [appDelegate hideSyncIndicator];
                
                NSLog(@"dropbox下载完成--结束比较双方数据");


            }

            
        }];
   
  
    }
    else
    {
        self.drop_dataStore = nil;
    }
}
*/

-(void)setupDatastoreSync{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if (self.drop_account)
    {
        [connection start];

        
        __weak DropboxObject *slf = self;//这样写为了避免增加指针
        
        isBegaintoReplaceorInteraction = NO;
        BOOL localhsData = [slf detcetifLocalhasData];
        
        [self.drop_dataStore addObserver:self block:^{
            if (self.drop_account == nil)
            {
                return ;
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *oldUserData =  [userDefaults stringForKey:OLDUSERDATA];
            
            //本地的datastore需要先下载server中的变化，才能把datastore的状态改变
            if (slf.drop_dataStore.status & (DBDatastoreIncoming|DBDatastoreOutgoing))
            {

                NSLog(@"处理服务器变化数据--开始");

                if ([oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA] && localhsData && !slf.isBegaintoReplaceorInteraction)
                {
                    DBError *dberror = nil;
                    [slf.drop_dataStore sync:&dberror];
                }
                else if (![oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA])
                {
                    [slf detectAllServerChangetoLocal];
                }
                
                NSLog(@"处理服务器变化数据--结束");
                return ;
            }
            
            //下载成功的时候才开始比较,最先产生的状态是这个
            if (!(slf.drop_dataStore.status&DBDatastoreDownloading) && slf.isNeedFlashAll)
            {
                [slf detcetAllLocaltoServer];
                [slf detcetAllServertoLocal_detcetDropboxishasData:NO];
                //parse同步
                //添加user数据
                [slf.syncIndicatorView.indicator stopAnimating];
                [slf.syncIndicatorView removeFromSuperview];
                [appDelegate addUpdatedTime];
                slf.isNeedFlashAll=NO;
            }
        }];
        
        
    }
    else
    {
        self.drop_dataStore = nil;
    }
}


//只有当是老数据的时候才能设置isBegaintoReplaceorInteraction
//-(void)setBegaintoReplaceorInteraction:(BOOL)tmpBegainReplace
//{
//    //判断是不是老用户
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *oldUserData =  [userDefaults stringForKey:OLDUSERDATA];
//    __weak DropboxObject *slf = self;//这样写为了避免增加指针
//
//    if ([oldUserData isEqualToString:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA]) {
//        slf.isBegaintoReplaceorInteraction = tmpBegainReplace;
//    }
//}

-(void)deleteAllServerData{
    DBError *dberror = nil;
    
    DBTable *accountTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
    DBTable *payeeTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
    DBTable *billItemTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
    DBTable *budgetTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
    DBTable *budgetItemTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
    DBTable *categoryTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];
    DBTable *accountType = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
    DBTable *transfer = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];
    
//    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"state", nil];

    NSArray *selectedStudentArray = [accountTable query:nil error:&dberror];
    NSArray *array1 = [payeeTable query:nil error:&dberror];
    NSArray *array2 = [transactionTable query:nil error:&dberror];
    NSArray *array3 = [billRuleTable query:nil error:&dberror];
    NSArray *array4 = [billItemTable query:nil error:&dberror];
    NSArray *array5 = [budgetTable query:nil error:&dberror];
    NSArray *array6 = [budgetItemTable query:nil error:&dberror];
    
    NSArray *array7 = [categoryTable query:nil error:&dberror];
    NSArray *array8 = [accountType query:nil error:&dberror];
    NSArray *array9 = [transfer query:nil error:&dberror];
    for (int i=0; i<[selectedStudentArray count]; i++) {
        DBRecord *oneRecord = [selectedStudentArray objectAtIndex:i];
        [oneRecord deleteRecord];
    }

    for (int i=0; i<[array1 count]; i++) {
        DBRecord *oneRecord = [array1 objectAtIndex:i];
        [oneRecord deleteRecord];

    }

    for (int i=0; i<[array2 count]; i++) {
        DBRecord *oneRecord = [array2 objectAtIndex:i];
        [oneRecord deleteRecord];

    }

    
    for (int i=0; i<[array3 count]; i++) {
        DBRecord *oneRecord = [array3 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array4 count]; i++) {
        DBRecord *oneRecord = [array4 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array5 count]; i++) {
        DBRecord *oneRecord = [array5 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array6 count]; i++) {
        DBRecord *oneRecord = [array6 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array7 count]; i++) {
        DBRecord *oneRecord = [array7 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array8 count]; i++) {
        DBRecord *oneRecord = [array8 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    for (int i=0; i<[array9 count]; i++) {
        DBRecord *oneRecord = [array9 objectAtIndex:i];
        [oneRecord deleteRecord];

    }
    
    
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSError *error = nil;
//    
//    NSMutableArray *alldata = [[NSMutableArray alloc]init];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
//    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    [alldata addObjectsFromArray:object];
//    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
//    NSArray *object1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest1 error:&error];
//    [alldata addObjectsFromArray:object1];
//    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
//    NSArray *object2 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
//    [alldata addObjectsFromArray:object2];
//    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
//    NSArray *object3 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest3 error:&error];
//    [alldata addObjectsFromArray:object3];
//    NSFetchRequest *fetchRequest4 = [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
//    NSArray *object4 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest4 error:&error];
//    [alldata addObjectsFromArray:object4];
//    NSFetchRequest *fetchRequest5 = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
//    NSArray *object5 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest5 error:&error];
//    [alldata addObjectsFromArray:object5];
//    NSFetchRequest *fetchRequest6 = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillItem"];
//    NSArray *object6= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest6 error:&error];
//    [alldata addObjectsFromArray:object6];
//    NSFetchRequest *fetchRequest7 = [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
//    NSArray *object7= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest7 error:&error];
//    [alldata addObjectsFromArray:object7];
//    NSFetchRequest *fetchRequest8 = [[NSFetchRequest alloc]initWithEntityName:@"Setting"];
//    NSArray *object8= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest8 error:&error];
//    [alldata addObjectsFromArray:object8];
//    for (id oneObject in alldata)
//    {
//        [appDelegate.managedObjectContext deleteObject:oneObject];
//    }

    
    
    NSLog(@"delete all!");
    //具有同步的作用
    [self.drop_dataStore sync:&dberror];
}
-(void)deleteAllServerData_changeStateis0{
    DBError *dberror = nil;
    DBTable *accountTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
    DBTable *payeeTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
    DBTable *billItemTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
    DBTable *budgetTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
    DBTable *budgetItemTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
    DBTable *categoryTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];
    DBTable *accountType = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
    DBTable *transfer = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];
    
    //    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"state", nil];
    
    NSArray *selectedStudentArray = [accountTable query:nil error:&dberror];
    NSArray *array1 = [payeeTable query:nil error:&dberror];
    NSArray *array2 = [transactionTable query:nil error:&dberror];
    NSArray *array3 = [billRuleTable query:nil error:&dberror];
    NSArray *array4 = [billItemTable query:nil error:&dberror];
    NSArray *array5 = [budgetTable query:nil error:&dberror];
    NSArray *array6 = [budgetItemTable query:nil error:&dberror];
    
    NSArray *array7 = [categoryTable query:nil error:&dberror];
    NSArray *array8 = [accountType query:nil error:&dberror];
    NSArray *array9 = [transfer query:nil error:&dberror];
    for (int i=0; i<[selectedStudentArray count]; i++)
    {
        DBRecord *oneRecord = [selectedStudentArray objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:ACCOUNT_STATE];
        [oneRecord setObject:[NSDate date] forKey:ACCOUNT_DATETIME_SYNC];
    }
    for (int i=0; i<[array1 count]; i++)
    {
        DBRecord *oneRecord = [array1 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:PAYEE_STATE];
        [oneRecord setObject:[NSDate date] forKey:PAYEE_DATETIME];
    }
    for (int i=0; i<[array2 count]; i++) {
        DBRecord *oneRecord = [array2 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:TRANSACTION_STATE];
        [oneRecord setObject:[NSDate date] forKey:TRANSACTION_DATETIME_SYNC];
    }
    
    for (int i=0; i<[array3 count]; i++) {
        DBRecord *oneRecord = [array3 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:BILLRULE_STATE];
        [oneRecord setObject:[NSDate date] forKey:BILLRULE_DATETIME];
    }
    for (int i=0; i<[array4 count]; i++) {
        DBRecord *oneRecord = [array4 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:BILLITEM_STATE];
        [oneRecord setObject:[NSDate date] forKey:BILLITEM_DATETIME];
    }
    for (int i=0; i<[array5 count]; i++) {
        DBRecord *oneRecord = [array5 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:BUDGETTEMPLATE_STATE];
        [oneRecord setObject:[NSDate date] forKey:BUDGETTEMPLATE_DATETIME];
    }
    for (int i=0; i<[array6 count]; i++) {
        DBRecord *oneRecord = [array6 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:BUDGETITEM_STATE];
        [oneRecord setObject:[NSDate date] forKey:BUDGETITEM_DATETIME];
    }
    for (int i=0; i<[array7 count]; i++) {
        DBRecord *oneRecord = [array7 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:CATEGORY_STATE];
        [oneRecord setObject:[NSDate date] forKey:CATEGORY_DATETIME];
    }
    for (int i=0; i<[array8 count]; i++) {
        DBRecord *oneRecord = [array8 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:ACCOUNTTYPE_STATE];
        [oneRecord setObject:[NSDate date] forKey:ACCOUNTTYPE_DATETIME];
    }
    for (int i=0; i<[array9 count]; i++) {
        DBRecord *oneRecord = [array9 objectAtIndex:i];
        [oneRecord setObject:@"0" forKey:BUDGETTRANSFER_STATE];
        [oneRecord setObject:[NSDate date] forKey:BUDGETTRANSFER_DATETIME_SYNC];
    }
    
    [self.drop_dataStore sync:&dberror];
    
}

#pragma mark Server -> Local,  Local -> Server
-(void)detectAllServerChangetoLocal
{

    DBError *dberror = nil;
     if (self.drop_account)
     {
         //这一句话是用来比较server中相比较本地变化了哪些数据嚒
         changed = [self.drop_dataStore sync:&dberror];
         
         if ([changed count]>0)
         {
             [self updateFromServertoLocal:changed];
         }
     }

}

-(void)setLocalDataSyncDatetime
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchAccountType = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    NSArray *accountArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccountType error:&error];
    for (int i=0; i<[accountArray count]; i++) {
        AccountType *oneAccount = [accountArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
    }
    
    NSFetchRequest *fetchAccounts = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *accountsArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccounts error:&error];
    for (int i=0; i<[accountsArray count]; i++) {
        Accounts *oneAccount = [accountsArray objectAtIndex:i];
        oneAccount.dateTime_sync = [NSDate date];
    }
    
    //会删掉budgetTemplate 和 budgetItem
    NSFetchRequest *fetchbudgetTem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *budgetTemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchbudgetTem error:&error];
    for (int i=0; i<[budgetTemArray count]; i++) {
        BudgetTemplate *oneAccount = [budgetTemArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
    }
    
    NSFetchRequest *fetchBillRule= [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSArray *billruleArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBillRule error:&error];
    for (int i=0; i<[billruleArray count]; i++) {
        EP_BillRule *oneBillRule = [billruleArray objectAtIndex:i];
        oneBillRule.dateTime = [NSDate date];
    }
    
    
    NSFetchRequest *fetchcategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSArray *categoryArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchcategory error:&error];
    for (int i=0; i<[categoryArray count]; i++) {
        Category *oneCate = [categoryArray objectAtIndex:i];
        oneCate.dateTime = [NSDate date];
    }
    
    NSFetchRequest *fetchpayee= [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSArray *payeeArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchpayee error:&error];
    for (int i=0; i<[payeeArray count]; i++) {
        Payee *onepayee = [payeeArray objectAtIndex:i];
        onepayee.dateTime = [NSDate date];
    }
    
    NSFetchRequest *fetchtransaction= [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *transactionArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchtransaction error:&error];
    for (int i=0; i<[transactionArray count]; i++) {
        Transaction *oneTrans = [transactionArray objectAtIndex:i];
        oneTrans.dateTime_sync = [NSDate date];
    }
    
    
    
    NSFetchRequest *fetchBudgetItem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *budgetItemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBudgetItem error:&error];
    for (int i=0; i<[budgetItemArray count]; i++) {
        BudgetItem *oneAccount = [budgetItemArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
    }
    
    NSFetchRequest *fetchSetting= [[NSFetchRequest alloc]initWithEntityName:@"Setting"];
    NSArray *settingArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchSetting error:&error];
    for (int i=0; i<[settingArray count]; i++) {
        Setting *oneAccount = [settingArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
    }
    
    [appDelegate_iPhone.managedObjectContext save:&error];
}
-(void)detcetAllLocaltoServer{

    if (self.drop_account != nil)
    {
        countMax = 0;
        [self update_AccountTypeTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_AccountTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_CategoryTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_PayeeTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        
        [self update_BudgetTemplateTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_BudgetItemTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_BudgetTransferTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        
        [self update_EP_BillRuleTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }

        [self update_EP_BillItemTable_FromLocaltoServer];
        if (countMax>=SYNC_MAX_COUNT)
        {
            [self detcetAllLocaltoServer];
            return;
        }
        
        //获取par Trans(Not Child Tran)
        [self update_TransactionTable_FromLocaltoServer_ParTrans:YES];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            [self.drop_dataStore sync:&dbError];
            [self detcetAllLocaltoServer];
            return;
        }
        
        [self update_TransactionTable_FromLocaltoServer_ParTrans:NO];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            [self.drop_dataStore sync:&dbError];
            [self detcetAllLocaltoServer];
            return;
        }
    }
    NSLog(@"比较本地数据--结束");

}

-(BOOL)detcetAllServertoLocal_detcetDropboxishasData:(BOOL)dropboxhasdata
{
    NSLog(@"比较server数据--开始");
//    [self.drop_dataStore sync:nil];
    //server -> local
    DBError *dberror = nil;
    
    DBTable *accountType = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
    DBTable *accountTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
    DBTable *categoryTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];

    DBTable *payeeTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];
    
    DBTable *budgetTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
    DBTable *budgetItemTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
    DBTable *transfer = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];

    DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
    DBTable *billItemTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];

    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    
    //accountType,account,category
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[accountType query:nil error:&dberror]] ;
    NSMutableArray *array2 = [[NSMutableArray alloc]initWithArray:[accountTable query:nil error:&dberror]];
    NSMutableArray *array3 = [[NSMutableArray alloc]initWithArray:[categoryTable query:nil error:&dberror]];

    //payee
    NSMutableArray *array4 = [[NSMutableArray alloc]initWithArray:[payeeTable query:nil error:&dberror]];
    
    //budgetTemplate,budgetItem,budgetTransfer
    NSMutableArray *array5 = [[NSMutableArray alloc]initWithArray:[budgetTable query:nil error:&dberror]];
    NSMutableArray *array6 = [[NSMutableArray alloc]initWithArray:[budgetItemTable query:nil error:&dberror]];
    NSMutableArray *array7 = [[NSMutableArray alloc]initWithArray:[transfer query:nil error:&dberror]];

    //billRule,billItem
    NSMutableArray *array8 = [[NSMutableArray alloc]initWithArray:[billRuleTable query:nil error:&dberror]];
    NSMutableArray *array9 = [[NSMutableArray alloc]initWithArray:[billItemTable query:nil error:&dberror]];
    
    NSMutableArray *array10 = [[NSMutableArray alloc]initWithArray:[transactionTable query:nil error:&dberror]];
    
    if (dropboxhasdata)
    {
        if ([array1 count]>0 || [array2 count]>0 || [array3 count]>0 || [array4 count]>0 || [array5 count]>0 || [array6 count]>0 || [array7 count]>0 || [array8 count]>0 || [array9 count]>0 || [array10 count]>0)
        {
            return YES;
        }
        return NO;
    }
    
    NSMutableArray *parTransactionArray = [[NSMutableArray alloc]init];
    NSMutableArray *childArray = [[NSMutableArray alloc]init];
    [parTransactionArray removeAllObjects];
    [childArray removeAllObjects];
    for (int i=0; i<[array10 count]; i++)
    {
        DBRecord *oneRecord = [array10 objectAtIndex:i];
    
        if ([oneRecord objectForKey:TRANSACTION_PARTRANSACTION]==nil || [self tolocal_check_data:oneRecord[TRANSACTION_PARTRANSACTION]]==nil)
        {
            [parTransactionArray addObject:oneRecord];
           
        }
        else
        {
             [childArray addObject:oneRecord];
        }
    }
    
    //accountType
    [self update_AccountTypeTable_FromServertoLocal:array1];
    [self update_AccountTable_FromServertoLocal:array2];
    [self update_CategoryTable_FromServertoLocal:array3];
    
    //payee
    [self update_PayeeTable_FromServertoLocal:array4];
    
    [self update_BudgetTemplateTable_FromServertoLocal:array5];
    [self update_BudgetItemTable_FromServertoLocal:array6];
    [self update_BudgetTransferTable_FromServertoLocal:array7];
    
    [self update_BillRuleTable_FromServertoLocal:array8];
    [self update_BudgetItemTable_FromServertoLocal:array9];
    
    [self update_TransactionTable_FromServertoLocal:parTransactionArray];
    [self update_TransactionTable_FromServertoLocal:childArray];
    NSLog(@"比较server数据--结束");

    return NO;
}

-(BOOL)detcetifLocalhasData
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchAccountType = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    NSArray *accountArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccountType error:&error];
    
    NSFetchRequest *fetchAccounts = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *accountsArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccounts error:&error];
    
    //会删掉budgetTemplate 和 budgetItem
    NSFetchRequest *fetchbudgetTem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *budgetTemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchbudgetTem error:&error];
    
    NSFetchRequest *fetchBillRule= [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSArray *billruleArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBillRule error:&error];
    
    
    NSFetchRequest *fetchcategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSArray *categoryArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchcategory error:&error];
    
    NSFetchRequest *fetchpayee= [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSArray *payeeArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchpayee error:&error];
    
    NSFetchRequest *fetchtransaction= [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *transactionArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchtransaction error:&error];
    
    
    NSFetchRequest *fetchBudgetItem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *budgetItemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBudgetItem error:&error];
    

    if ([accountArray count]>0 ||
        [accountsArray count]>0 ||
        [budgetTemArray count]>0 ||
        [billruleArray count]>0 ||
        [categoryArray count]>0 ||
        [payeeArray count]>0 ||
        [transactionArray count]>0 ||
        [budgetItemArray count]>0)
    {
        return YES;
    }
    return NO;

}

//只有被同步的时候才会提醒用户
-(void)updateFromServertoLocal:(NSDictionary *)changedDict{
    countMax = 0;
    needToReflesh = NO;
    
    NSMutableArray *changedAccountTypeArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_ACCOUNTTYPE_TABLE]allObjects]];
    [self update_AccountTypeTable_FromServertoLocal:changedAccountTypeArray];
    
    
    NSMutableArray *changedAccountarray = [[NSMutableArray alloc]initWithArray: [changedDict[DB_ACCOUNT_TABLE] allObjects]];
    [self update_AccountTable_FromServertoLocal:changedAccountarray];
    
    
    NSMutableArray *changedCategoryArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_CATEGORY_TABLE]allObjects]];
    [self update_CategoryTable_FromServertoLocal:changedCategoryArray];
    
    
    NSMutableArray *changedPayeeArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_PAYEE_TABLE]allObjects]];
    [self update_PayeeTable_FromServertoLocal:changedPayeeArray];
    
    
    
    NSMutableArray *changedBudgetTemplateArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_BUDGETTEMPLATE_TABLE]allObjects]];
    [self update_BudgetTemplateTable_FromServertoLocal:changedBudgetTemplateArray];
    
    NSMutableArray *changedBudgetItemArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_BUDGETITEM_TABLE]allObjects]];
    [self update_BudgetItemTable_FromServertoLocal:changedBudgetItemArray];
    
    
    
    NSMutableArray *changedBudgetTransferArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_BUDGETTRANSFER_TABLE]allObjects]];
    [self update_BudgetTransferTable_FromServertoLocal:changedBudgetTransferArray];
    

    
    NSMutableArray *changedBillArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_EP_BILLRULE_TABLE]allObjects]];
    [self update_BillRuleTable_FromServertoLocal:changedBillArray];
    
    
    NSMutableArray *changedBillItemArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_EP_BILLITEM_TABLE]allObjects]];
    [self update_BillItemTable_FromServertoLocal:changedBillItemArray];
     
    
    
    NSMutableArray *changedTransactionArray = [[NSMutableArray alloc]initWithArray:[changedDict[DB_TRANSACTION_TABLE]allObjects]];
    
    NSMutableArray *parTransactionArray = [[NSMutableArray alloc]init];
    NSMutableArray *childArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[changedTransactionArray count]; i++)
    {
        DBRecord *oneRecord = [changedTransactionArray objectAtIndex:i];
        if ([oneRecord objectForKey:TRANSACTION_PARTRANSACTION]==nil || [self tolocal_check_data:oneRecord[TRANSACTION_PARTRANSACTION]]==nil)
        {
            [parTransactionArray addObject:oneRecord];
        }
        else
        {
            [childArray addObject:oneRecord];
        }
    }
    
    [self update_TransactionTable_FromServertoLocal:parTransactionArray];
    [self update_TransactionTable_FromServertoLocal:childArray];
    
    
    if (isPad && needToReflesh)
    {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        if ([changedDict count]>0 )
        {
            [appDelegate_iPad.mainViewController  refleshUI];
            [appDelegate_iPad.epnc showSyncTip];
        }
    }
    else if(needToReflesh)
    {
        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
        if ([changedDict count]>0 )
        {
            [appDelegate_iPhone  reflashUI];
            [appDelegate_iPhone.epnc showSyncTip];
        }
    }
    
    
    
}



///////////////////
///////////////////AccountType table
#pragma mark AccountType Method
-(void)update_AccountTypeTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        NSDate  *serverDate = [oneRecord objectForKey:ACCOUNTTYPE_DATETIME];
        
        
        //如果这个record不完整的话，就直接删除
        if ([oneRecord objectForKey:ACCOUNTTYPE_UUID]==nil || [self tolocal_check_data:oneRecord[ACCOUNTTYPE_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            //获取local中唯一一个记录
            AccountType *oneAccountType = [self fetchLocal_accountType_withUUID:[oneRecord objectForKey:ACCOUNTTYPE_UUID] ifDontHaveCreate:NO];
            NSDate  *localDate = oneAccountType.dateTime;
            
            
            //state = 0 这里不能合并，因为state==0的时候，需要将本地的account关联的accountType更改
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"])
            {
                
                if (oneAccountType != nil)
                {
                    //server time > local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        
                        //修改accountType相关联的account
                        NSFetchRequest *fetchAccount = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
                        NSPredicate *predicate_Account =[NSPredicate predicateWithFormat:@"accountType.uuid contains[c] %@",[oneRecord objectForKey:ACCOUNTTYPE_UUID]];
                        [fetchAccount setPredicate:predicate_Account];
                        NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchAccount error:&error];
                        
                        //get others accountType
                        NSFetchRequest *defaultTypeRequest = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
                        NSPredicate *predicate_type =[NSPredicate predicateWithFormat:@"typeName contains[c] %@",@"Others"];
                        [defaultTypeRequest setPredicate:predicate_type];
                        NSArray *object_default = [appDelegate.managedObjectContext executeFetchRequest:defaultTypeRequest error:&error];
                        AccountType *defaultType = [self getLocalOnly_Data:object_default tableName:@"AccountType"];
                        
                        
                        for (int k=0; k<[object count]; k++) {
                            Accounts *oneAccount = [object objectAtIndex:k];
                            oneAccount.accountType = defaultType;
                            oneAccount.dateTime_sync = [NSDate date];
                            if (![appDelegate.managedObjectContext save:&error]) {
                                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                                
                            }
                            [self updateEveryAccountDataFromLocal:oneAccount];
                            [[ParseDBManager sharedManager]updateAccountFromLocal:oneAccount];
                        }
                        
                        [appDelegate.managedObjectContext deleteObject:oneAccountType];
                        if (![appDelegate.managedObjectContext save:&error]) {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        
                        needToReflesh = YES;
                        
                        
                    }
                    //server time > local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverAccountType:oneRecord fromLocalAccountType:oneAccountType];
                    }
                }
                
            }
            //state == 1
            else{
                //local 没有这个数据，直接增加
                if (oneAccountType == nil) {
                    [self saveLocalAccountType:nil FromServerAccount:oneRecord];
                }
                //local 有这个数据，对比时间，修改哪一个
                else
                {
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalAccountType:oneAccountType FromServerAccount:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverAccountType:oneRecord fromLocalAccountType:oneAccountType];
                    }
                    
                }
            }
        }
        
        
    }
}

-(void)update_AccountTypeTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        AccountType *oneAccountType = [object objectAtIndex:i];
        
        [self updateEveryAccountTypeDataFromLocal:oneAccountType];
        [[ParseDBManager sharedManager]updateAccountTypeFromLocal:oneAccountType];
        if (countMax++>SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
    }
    
}

//local->server，对于删除一个accountType,需要修改account的操作在外部执行
-(void)updateEveryAccountTypeDataFromLocal:(AccountType *)localAccountType {
    DBTable *accountTypeTable = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
    DBError *dbError = nil;
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localAccountType==nil)
    {
        return;
    }
    else if (localAccountType.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localAccountType];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localAccountType.uuid,ACCOUNTTYPE_UUID, nil];
    NSArray *selectedStudentArray = [accountTypeTable query:dictionary error:&dbError];
    
    
    if ([selectedStudentArray count]==0)
    {
        [self saveSeverAccountType:nil fromLocalAccountType:localAccountType];
    }
    else
    {
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_ACCOUNTTYPE_TABLE];
        
        NSDate  *serverDate = [oneRecord objectForKey:ACCOUNTTYPE_DATETIME];
        NSDate  *localDate = localAccountType.dateTime;
        
        //如果localTime早于server time，就修改localtime
        if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]<0){
            [self saveLocalAccountType:localAccountType FromServerAccount:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]>0) {
            [self saveSeverAccountType:oneRecord fromLocalAccountType:localAccountType];
        }
    }
}

-(void)saveSeverAccountType:(DBRecord *)record fromLocalAccountType:(AccountType *)accountType{
    DBTable *accountTypeTable = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    
    if (accountType==nil)
    {
        return;
    }
    if (accountType.uuid ==nil)
    {
        [appDelegate.managedObjectContext deleteObject:accountType];
        [appDelegate.managedObjectContext save:&error];
    }
    
    countMax ++;
    if (record == nil)
    {
        record = [accountTypeTable  insert:@{
                ACCOUNTTYPE_TYPENAME:accountType.typeName
                
                                            } ];
    }
    else
        [record setObject:accountType.typeName forKey:ACCOUNTTYPE_TYPENAME];
    
    
    if(accountType.iconName != nil)
        [record setObject:accountType.iconName forKey:ACCOUNTTYPE_ICONNAME];
    
    if (accountType.isDefault != nil)
        [record setObject:accountType.isDefault forKey:ACCOUNTTYPE_ISDEFAULT];
    
    if (accountType.dateTime != nil)
        [record setObject:accountType.dateTime forKey:ACCOUNTTYPE_DATETIME];
    
    if (accountType.state != nil)
        [record setObject:accountType.state forKey:ACCOUNTTYPE_STATE];
    
    if (accountType.uuid != nil)
        [record setObject:accountType.uuid forKey:ACCOUNTTYPE_UUID];
    
    
    if ([accountType.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:accountType];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
}

-(id)saveLocalAccountType:(AccountType *)accountType FromServerAccount:(DBRecord *)record{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;
    
    if (record==nil) {
        return nil;
    }
    if ([record objectForKey:ACCOUNTTYPE_UUID] ==nil) {
        [record deleteRecord];
        return nil;
    }

    if (accountType == nil) {
        accountType = [NSEntityDescription insertNewObjectForEntityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    accountType.typeName = [record objectForKey:ACCOUNTTYPE_TYPENAME];
    accountType.iconName = [record objectForKey:ACCOUNTTYPE_ICONNAME];
    accountType.isDefault = [record objectForKey:ACCOUNTTYPE_ISDEFAULT];
    
    accountType.dateTime = [record objectForKey:ACCOUNTTYPE_DATETIME];
    accountType.state = [record objectForKey:ACCOUNTTYPE_STATE];
    accountType.uuid = [record objectForKey:ACCOUNTTYPE_UUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;
    return accountType;
}



///////////////////
///////////////////Account table
#pragma mark Account Table Method
-(void)update_AccountTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication]delegate];
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        NSDate  *serverDate = [oneRecord objectForKey:ACCOUNT_DATETIME_SYNC];

        //如果这个record不完整的话，就直接删除
        if ([oneRecord objectForKey:ACCOUNT_UUID]==nil || [self tolocal_check_data:oneRecord[ACCOUNT_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else{
            Accounts *oneAccount = [self fetchLocal_account_withUUID:[oneRecord objectForKey:ACCOUNT_UUID] ifDontHaveCreate:NO];
            NSDate  *localDate = oneAccount.dateTime_sync;
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"]) {
                
                if (oneAccount != nil) {
                    //server time 迟于 local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [appDelegate.epdc deleteAccountRel:oneAccount];
                        needToReflesh = YES;
                    }
                    //server time 迟于 local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverAccount:oneRecord fromLocalAccount:oneAccount];
                    }
                }
            }
            //state == 1
            else{
                
                if (oneAccount ==nil) {
                    [self saveLocalAccount:nil FromServerAccount:oneRecord];
                }
                else
                {
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalAccount:oneAccount FromServerAccount:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        
                        [self saveSeverAccount:oneRecord fromLocalAccount:oneAccount];
                    }
                    
                }
            }
        }
        
        
    
    }
}

-(void)update_AccountTable_FromLocaltoServer{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        Accounts *oneAccount = [object objectAtIndex:i];
        

        [self updateEveryAccountDataFromLocal:oneAccount];
        
        [[ParseDBManager sharedManager]updateAccountFromLocal:oneAccount];
        
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
        
        
        
    }
    
    
}

//更新每一个本地account数据
-(void)updateEveryAccountDataFromLocal:(Accounts *)localAccount{
    DBError   *dberror = nil;
    NSError  *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localAccount==nil)
    {
        return;
    }
    else if (localAccount.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localAccount];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    DBTable *accountTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localAccount.uuid ,ACCOUNT_UUID, nil];
    NSArray *selectedStudentArray = [accountTable query:dictionary error:&dberror];
    
    //如果dropbox中没有这个本地中的account就 由本地向dropbox中添加数据
    if ([selectedStudentArray count]==0) {

        [self saveSeverAccount:nil fromLocalAccount:localAccount];
        
    }
    else{
        
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_ACCOUNT_TABLE];
        
        NSDate  *serverDate = [oneRecord objectForKey:ACCOUNT_DATETIME_SYNC];
        NSDate  *localDate = localAccount.dateTime_sync;
        
        if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]<0) {
            [self saveLocalAccount:localAccount FromServerAccount:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]>0){
            [self saveSeverAccount:oneRecord fromLocalAccount:localAccount];
        }
    }
}

-(void)saveSeverAccount:(DBRecord *)record fromLocalAccount:(Accounts *)account{
    DBTable *accountTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    NSError *error = nil;
    
    if (account == nil) {
        return;
    }
    
    if (account.uuid==nil) {
        [appDelegate.managedObjectContext deleteObject:account];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    countMax++;
    if (record==nil)
    {
        record = [accountTable  insert:@{
                                         ACCOUNT_NAME:account.accName
                                                      } ];
    }
    else
    {
        [record setObject:account.accName forKey:ACCOUNT_NAME];
    }
    
    if (account.amount != nil)
    {
        [record setObject:account.amount forKey:ACCOUNT_AMOUNT];
    }
    if (account.autoClear != nil)
    {
        [record setObject:account.autoClear forKey:ACCOUNT_AUTOCLEAR];
    }
    if (account.orderIndex!=nil)
    {
        [record setObject:account.orderIndex forKey:ACCOUNT_ORDERINDEX];
    }
    if (account.dateTime != nil)
    {
        [record setObject:account.dateTime forKey:ACCOUNT_DATETIME];
    }
    if (account.accountType.uuid!=nil)
    {
        [record setObject:account.accountType.uuid forKey:ACCOUNT_ACCOUNTTYPE];
    }
    if (account.uuid != nil)
    {
        [record setObject:account.uuid forKey:ACCOUNT_UUID];
    }
    if (account.dateTime_sync !=nil)
    {
        [record setObject:account.dateTime_sync forKey:ACCOUNT_DATETIME_SYNC];
    }
    if (account.state != nil)
    {
        [record setObject:account.state forKey:ACCOUNT_STATE];
    }
    
    if ([account.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:account];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
}

//由dropbox向本地更新数据
-(id)saveLocalAccount:(Accounts *)account FromServerAccount:(DBRecord *)record{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    //如果dropbox中的数据为nil或者uuid为nil，直接删除record,返回；
    if (record==nil) {
        return nil;
    }
    else if ([record objectForKey:ACCOUNT_UUID]==nil)
    {
        [record deleteRecord];
        return nil;
    }
    
    if (account == nil) {
        account = [NSEntityDescription insertNewObjectForEntityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    
    if ([[record objectForKey:ACCOUNT_NAME] length]>0)
    {
        account.accName = [record objectForKey:ACCOUNT_NAME];

    }
    if ([record objectForKey:ACCOUNT_AMOUNT] != nil)
    {
        account.amount = [record objectForKey:ACCOUNT_AMOUNT];

    }
    if ([record objectForKey:ACCOUNT_DATETIME]!= nil)
    {
        account.dateTime =[record objectForKey:ACCOUNT_DATETIME];
    }
    account.autoClear = [record objectForKey:ACCOUNT_AUTOCLEAR];
    
    if ([record objectForKey:ACCOUNT_ORDERINDEX] != nil)
    {
        account.orderIndex = [record objectForKey:ACCOUNT_ORDERINDEX];

    }
    
    //accountType 外键需要先判断这个外键是不是存在，存在的话获取这个外键，不存在的话，需要获取这个外键
    if ([[record objectForKey:ACCOUNT_ACCOUNTTYPE] length]>0) {
        AccountType *oneAccountType = [self fetchLocal_accountType_withUUID:[record objectForKey:ACCOUNT_ACCOUNTTYPE] ifDontHaveCreate:YES];
        
        if (oneAccountType != nil) {
            account.accountType = oneAccountType;
        }
    }
    
    
    account.state = [record objectForKey:ACCOUNT_STATE];
    account.uuid = [record objectForKey:ACCOUNT_UUID];
    account.dateTime_sync = [record objectForKey:ACCOUNT_DATETIME_SYNC];
    
    if (![appDelegate.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;

    return account;
}




///////////////////
///////////////////Payee Table
#pragma mark Payee Method
-(void)update_PayeeTable_FromServertoLocal:(NSMutableArray *)changedarray{
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        
        
        if ([oneRecord objectForKey:PAYEE_UUID]==nil || [self tolocal_check_data:oneRecord[PAYEE_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            Payee *onePayee = [self fetchLocal_payee_withUUID:[oneRecord objectForKey:PAYEE_UUID] ifDontHaveCreate:NO];
            
            NSDate  *serverDate = [oneRecord objectForKey:PAYEE_DATETIME];
            NSDate  *localDate = onePayee.dateTime;
            
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"])
            {
                
                NSError *error = nil;
                if (onePayee != nil)
                {
                    //server time < local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [appDelegate.managedObjectContext deleteObject:onePayee];
                        if (![appDelegate.managedObjectContext save:&error]) {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time > local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverPayee:oneRecord fromLocalPayee:onePayee];
                    }
                }
            }
            //state == 1
            else
            {
                //local 没有这个数据，直接增加
                if (onePayee == nil)
                {
                    [self saveLocalPayee:nil FromServerPayee:oneRecord];
                }
                //local 有这个数据，对比时间，修改哪一个
                else
                {
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalPayee:onePayee FromServerPayee:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverPayee:oneRecord fromLocalPayee:onePayee];
                    }
                    
                }
            }
        }
        
    }
}

-(void)update_PayeeTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        Payee *onePayee = [object objectAtIndex:i];
        [self updateEveryPayeeDataFromLocal:onePayee];
        [[ParseDBManager sharedManager]updatePayeeFromLocal:onePayee];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
        
    }
    
}

-(void)updateEveryPayeeDataFromLocal:(Payee *)localPayee{
    DBError   *dberror = nil;
    DBTable *payeeTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localPayee==nil)
    {
        return;
    }
    else if (localPayee.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localPayee];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localPayee.uuid ,PAYEE_UUID, nil];
    NSArray *selectedStudentArray = [payeeTable query:dictionary error:&dberror];
    
    
    //如果本地数据是删除，那么 sync ,delete
    if ([selectedStudentArray count]==0) {
        [self saveSeverPayee:nil fromLocalPayee:localPayee];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_PAYEE_TABLE];
        NSDate  *localDate = localPayee.dateTime;
        NSDate  *serverDate = [oneRecord objectForKey:PAYEE_DATETIME ];
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalPayee:localPayee FromServerPayee:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
            [self saveSeverPayee:oneRecord fromLocalPayee:localPayee];
        }
        
    }

    
}

-(void)saveSeverPayee:(DBRecord *)oneRecord fromLocalPayee:(Payee *)localPayee{
    DBTable *payeeTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    if (localPayee==nil) {
        return;
    }
    if (localPayee.uuid ==nil) {
        [appDelegate.managedObjectContext deleteObject:localPayee];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    
    countMax++;
    if (oneRecord==nil) {
        
        oneRecord = [payeeTable  insert:@{
                  PAYEE_NAME:localPayee.name
                  } ];
    }
    else{
        [oneRecord setObject:localPayee.name forKey:PAYEE_NAME ];
        
    }
    
    if ([localPayee.memo length]>0) {
        [oneRecord setObject:localPayee.memo forKey:PAYEE_MEMO];
    }
    if (localPayee.category.uuid !=nil)
         [oneRecord setObject:localPayee.category.uuid forKey:PAYEE_CATEGORY];
    if ([localPayee.tranType length]>0)
        [oneRecord setObject:localPayee.tranType forKey:PAYEE_TRANSTYPE];
    
    //uuid
    if (localPayee.dateTime != nil)
        [oneRecord setObject:localPayee.dateTime forKey:PAYEE_DATETIME];
    if ([localPayee.state length]>0)
        [oneRecord setObject:localPayee.state forKey:PAYEE_STATE];
    if (localPayee.uuid)
        [oneRecord setObject:localPayee.uuid forKey:PAYEE_UUID];
    
    if ([localPayee.state isEqualToString:@"0"]) {
        [appDelegate.managedObjectContext deleteObject:localPayee];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
    
    
}

-(id)saveLocalPayee:(Payee *)localPayee FromServerPayee:(DBRecord *)oneRecord{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error =nil;
    
    if (oneRecord==nil) {
        return nil;
    }
    if ([oneRecord objectForKey:PAYEE_UUID] ==nil) {
        [oneRecord deleteRecord];
        return nil;
    }
    
    if (localPayee == nil) {
        localPayee = [NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    
    localPayee.name = [oneRecord objectForKey:PAYEE_NAME];
    if ([[oneRecord objectForKey:PAYEE_MEMO] length]>0) {
        localPayee.memo = [oneRecord objectForKey:PAYEE_MEMO];
    }
    
    if ([[oneRecord objectForKey:PAYEE_TRANSTYPE]length]>0) {
        localPayee.tranType = [oneRecord objectForKey:PAYEE_TRANSTYPE];
    }
    
    //search local category
    if ([oneRecord objectForKey:PAYEE_CATEGORY] != nil) {
        NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:[oneRecord objectForKey:PAYEE_CATEGORY],@"UUID", nil];
        NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchCategoryWithUUID" substitutionVariables:sub];
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
        if ([objects count]>0) {
            localPayee.category = [objects objectAtIndex:0];
        }
    }
    
    
    localPayee.dateTime = [oneRecord objectForKey:PAYEE_DATETIME];
    localPayee.state = [oneRecord objectForKey:PAYEE_STATE];
    localPayee.uuid = [oneRecord objectForKey:PAYEE_UUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    needToReflesh = YES;
    return localPayee;

}


///////////////////
//////////////////
#pragma mark Category Table Method
-(void)update_CategoryTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        
        //如果这个record不完整的话，就直接删除
        if ([oneRecord objectForKey:CATEGORY_UUID]==nil || [self tolocal_check_data:oneRecord[CATEGORY_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            Category *oneCategory = [self fetchLocal_category_withUUID:[oneRecord objectForKey:CATEGORY_UUID] ifDontHaveCreate:NO];
            
            NSDate  *localDate = oneCategory.dateTime;
            NSDate  *serverDate = [oneRecord objectForKey:CATEGORY_DATETIME];
            
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"]) {
                if (oneCategory != nil) {
                    //server time < local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
                    {
                        [appDelegate.managedObjectContext deleteObject:oneCategory];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time > local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0)
                    {
                        [self saveSeverCategory:oneRecord fromLocalCategory:oneCategory];
//                        [oneRecord setObject:@"0" forKey:TRANSACTION_STATE];
                    }
                }
            }
            //state == 1
            else{
                //local 没有这个数据，直接增加
                if (oneCategory == nil) {
                    
                    Category *oneCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
                    [self saveLocalCategory:oneCategory  FromServerCategory:oneRecord];
                }
                //local 有这个数据，对比时间，修改哪一个
                else
                {
                    
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
                    {
                        [self saveLocalCategory:oneCategory FromServerCategory:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0)
                    {
                        [self saveSeverCategory:oneRecord fromLocalCategory:oneCategory];
                    }
                    
                }
            }
        }
    }
}

-(void)update_CategoryTable_FromLocaltoServer{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        Category *oneCategory = [object objectAtIndex:i];
        [self updateEveryCategoryDataFromLocal:oneCategory];
        [[ParseDBManager sharedManager]updateCategoryFromLocal:oneCategory];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;

        }
        
    }
    
}

-(void)updateEveryCategoryDataFromLocal:(Category *)localCategory{
    DBError   *dberror = nil;
    DBTable *categoryTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localCategory==nil)
    {
        return;
    }
    else if (localCategory.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localCategory];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localCategory.uuid ,CATEGORY_UUID, nil];
    NSArray *selectedStudentArray = [categoryTable query:dictionary error:&dberror];
    
    
    //如果本地数据是删除，那么 sync ,delete
    if ([selectedStudentArray count]==0) {
        [self saveSeverCategory:nil fromLocalCategory:localCategory];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_CATEGORY_TABLE];
        NSDate  *serverDate = [oneRecord objectForKey:CATEGORY_DATETIME];
        NSDate  *localDate = localCategory.dateTime;
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalCategory:localCategory FromServerCategory:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
            [self saveSeverCategory:oneRecord fromLocalCategory:localCategory];
        }
        
    }
}

-(void)saveSeverCategory:(DBRecord *)oneRecord fromLocalCategory:(Category *)localCategory{
    
    DBTable *categoryTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    if (localCategory==nil) {
        return;
    }
    if (localCategory.uuid ==nil)
    {
        [appDelegate.managedObjectContext deleteObject:localCategory];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    countMax ++;
    if ([localCategory.categoryName length]==0)
    {
        [oneRecord deleteRecord];
        return;
    }
    if (oneRecord==nil)
    {
        oneRecord= [categoryTable  insert:@{
                CATEGORY_CATEGORYNAME :localCategory.categoryName
                                            } ];
    }
    else
    {
        [oneRecord setObject:localCategory.categoryName forKey: CATEGORY_CATEGORYNAME];
    }
    
    if(localCategory.categoryType != nil)
        [oneRecord setObject:localCategory.categoryType forKey:CATEGORY_CATEGORYTYPE];
    
    if (localCategory.iconName != nil)
        [oneRecord setObject:localCategory.iconName forKey:CATEGORY_ICONNAME];
    
    if (localCategory.isDefault != nil)
        [oneRecord setObject:localCategory.isDefault forKey:CATEGORY_ISDEFAULT];
    
    if (localCategory.isSystemRecord != nil)
        [oneRecord setObject:localCategory.isSystemRecord forKey:CATEGORY_ISSYSTEMRECORD];
    
    
    if ([localCategory.recordIndex integerValue]>0)
    {
        [oneRecord setObject:localCategory.recordIndex forKey:CATEGORY_RECORDINDEX];
    }
    
    //uuid
    if (localCategory.dateTime != nil)
        [oneRecord setObject:localCategory.dateTime forKey:CATEGORY_DATETIME];
    
    if (localCategory.state != nil)
        [oneRecord setObject:localCategory.state forKey:CATEGORY_STATE];
    
    if (localCategory.uuid != nil)
        [oneRecord setObject:localCategory.uuid forKey:CATEGORY_UUID];

    if ([localCategory.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:localCategory];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
    
}

-(id)saveLocalCategory:(Category *)localCategory FromServerCategory:(DBRecord *)oneRecord{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error =nil;
    
    if (oneRecord==nil) {
        return nil;
    }
    if ([oneRecord objectForKey:CATEGORY_UUID] ==nil) {
        [oneRecord deleteRecord];
        return nil;
    }
    localCategory.categoryName = [oneRecord objectForKey:CATEGORY_CATEGORYNAME];
    localCategory.categoryType = [oneRecord objectForKey:CATEGORY_CATEGORYTYPE];
    localCategory.iconName = [oneRecord objectForKey:CATEGORY_ICONNAME];
    localCategory.isDefault = [oneRecord objectForKey:CATEGORY_ISDEFAULT];
    localCategory.isSystemRecord = [oneRecord objectForKey:CATEGORY_ISSYSTEMRECORD];
    
    if ([oneRecord objectForKey:CATEGORY_RECORDINDEX])
    {
        localCategory.recordIndex = [oneRecord objectForKey:CATEGORY_RECORDINDEX];
    }

    localCategory.dateTime = [oneRecord objectForKey:CATEGORY_DATETIME];
    localCategory.state = [oneRecord objectForKey:CATEGORY_STATE];
    localCategory.uuid = [oneRecord objectForKey:CATEGORY_UUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;
    return localCategory;
    
}


///////////////////
///////////////////Transaction table
#pragma mark Transaction Tabel Method
-(void)update_TransactionTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];

        if ([oneRecord objectForKey:TRANSACTION_UUID]==nil || [self tolocal_check_data:oneRecord[TRANSACTION_UUID]]==nil)
        {
            countMax ++;
            [oneRecord deleteRecord];
        }
        else
        {
            /*逻辑：
             有second uuid搜索second uuid
             {
                 1.搜到了获取唯一的trans记录，更改uuid,保存本地，判断server与本地时间先后进行操作
                 2.没搜到就去搜uuid
                 {
                     1.搜到，获取唯一的记录其他删掉，然后保存这个记录的second uuid。保存，再进行判断server和服务器端哪个时间后。
                     2.没搜到，如果服务器端表示这个数据是存在的，就创建。
                 }

             }
             无，搜uuid
             */
            
            
            
            NSString *tmpSecondUUID = [oneRecord objectForKey:TRANSACTION_TRANSACTIONSTRING];
            if ([tmpSecondUUID length]>0)
            {
                [self searchLocalTransactionWithSeconUUID_SerTrans:oneRecord];
            }
            else
                [self searchLocalTransaction_SerTransaction:oneRecord];
            
        }
        
        
//        if (countMax >= 700)
//        {
//            [self updateFromServertoLocal:changed];
//            return;
//        }
        
    }

}

//transaction:local->server
-(void)update_TransactionTable_FromLocaltoServer_ParTrans:(BOOL)isParentTran{
    
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest;
    if (isParentTran)
    {
        fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransaction_ParTrans" substitutionVariables:[[NSDictionary alloc]init]];
    }
    else
    {
        fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransaction_ChildTrans" substitutionVariables:[[NSDictionary alloc]init]];
    }
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        Transaction *oneTransaction = [object objectAtIndex:i];
        [self updateEveryTransactionDataFromLocal:oneTransaction];
        
        [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTransaction];
        
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
       
    }
    
}

-(void)updateEveryTransactionDataFromLocal:(Transaction *)localTransaction
{

    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localTransaction==nil)
    {
        return;
    }
    else if (localTransaction.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localTransaction];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    /*
     跟新本地transaction逻辑：
     有second uuid搜second uuid
     {
        1.搜到,获取服务器端唯一数据，其他直接删掉，然后保存本地uuid,再比较时间，进行操作
        2.没搜到，搜uuid
        {
            1.搜到，获取服务器端唯一数据，若server有second uuid保存,比较时间，进行操作
            2.没搜到，直接上传
        }
     }
     无，搜uuid
     */
    if ([localTransaction.transactionstring length]>0)
    {
        [self searchServerTransaction_WithSecondUUID:localTransaction.transactionstring localTrans:localTransaction];
    }
    else
    {
        [self searchServerTransaction_LocalTrans:localTransaction];
        
    }
}

//判断本地是不是有一个相同的secondUUID的transaction
-(void)searchLocalTransactionWithSeconUUID_SerTrans:(DBRecord *)oneRecord{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[oneRecord objectForKey:TRANSACTION_TRANSACTIONSTRING],@"SECONDUUID", nil];
    NSError *error = nil;
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchTransactionWithSecondUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    
    //搜second uuid
    if ([objects count]>0)
    {
        Transaction *loc_trans = [self getLocalOnly_Data:objects tableName:DB_TRANSACTION_TABLE];
        
        if (![loc_trans.uuid isEqualToString:[oneRecord objectForKey:TRANSACTION_UUID]])
        {
            loc_trans.uuid = [oneRecord objectForKey:TRANSACTION_UUID];
        }
        
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
        
        NSDate  *serverDate = (NSDate *)[oneRecord objectForKey:TRANSACTION_DATETIME_SYNC];
        NSDate  *localDate = loc_trans.dateTime_sync;
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverTransaction:oneRecord fromLocalTransaction:loc_trans];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
            [self saveLocalTransaction:loc_trans FromServerTransaction:oneRecord];
        }
    }
    else
    {
        [self searchLocalTransaction_SerTransaction:oneRecord];
    }
}

-(void)searchLocalTransaction_SerTransaction:(DBRecord *)oneRecord
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSError *error = nil;

    Transaction *oneTransaction = [self fetchLocal_transaction_withUUID:[oneRecord objectForKey:TRANSACTION_UUID] ifDontHaveCreate:NO];
    if(oneTransaction != nil)
    {
        NSDate  *serverDate = (NSDate *)[oneRecord objectForKey:TRANSACTION_DATETIME_SYNC];
        NSDate  *localDate = oneTransaction.dateTime_sync;
        //修改local
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
        {
             [self saveLocalTransaction:oneTransaction FromServerTransaction:oneRecord];
//            //判断有没有子transaction,有的话，就要删除
//            NSMutableArray *childTrans = [[NSMutableArray alloc]initWithArray:[oneTransaction.childTransactions allObjects]];
//            for (int m=0; m<[childTrans count]; m++)
//            {
//                Transaction *oneChildTrans = [childTrans objectAtIndex:m];
//                [appDelegate.managedObjectContext deleteObject:oneChildTrans];
//            }
//            [appDelegate.managedObjectContext save:&error];
//            
//            [appDelegate.managedObjectContext deleteObject:oneTransaction];
//            if (![appDelegate.managedObjectContext save:&error]) {
//                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
//                
//            }
            needToReflesh = YES;
        }
        //修改server，删除child record.
        else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0)
        {
            [self saveSeverTransaction:oneRecord fromLocalTransaction:oneTransaction];
        }
    }
    else
    {
        if ([[oneRecord objectForKey:TRANSACTION_STATE] isEqualToString:@"1"])
        {
            [self saveLocalTransaction:nil FromServerTransaction:oneRecord];
        }
        
    }

}

-(void)searchServerTransaction_WithSecondUUID:(NSString *)secondUUID localTrans:(Transaction *)locTrans{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBError *dberror = nil;
    NSError *error = nil;
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:secondUUID,TRANSACTION_TRANSACTIONSTRING, nil];
    NSArray *objects = [transactionTable query:sub error:&dberror];
    if ([objects count]>0)
    {
        //获取最迟的那一个记录
        DBRecord *oneRecord = [self getOnlyDataFromServer:objects tableName:DB_TRANSACTION_TABLE];
        
        locTrans.uuid = [oneRecord objectForKey:TRANSACTION_UUID];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
        
        NSDate *serverDate = (NSDate *)[oneRecord objectForKey:TRANSACTION_DATETIME_SYNC];
        NSDate  *localDate = locTrans.dateTime_sync;
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverTransaction:oneRecord fromLocalTransaction:locTrans];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalTransaction:locTrans FromServerTransaction:oneRecord];
        }
    }
    else
    {
        [self searchServerTransaction_LocalTrans:locTrans];
    }
}

-(void)searchServerTransaction_LocalTrans:(Transaction *)locTrans
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBError   *dberror = nil;
    NSError *error = nil;

    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:locTrans.uuid ,TRANSACTION_UUID, nil];
    NSArray *selectedStudentArray = [transactionTable query:dictionary error:&dberror];
    if ([selectedStudentArray count]>0)
    {
        
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_TRANSACTION_TABLE];
        
        NSString *tmpSecondUUID = [oneRecord objectForKey:TRANSACTION_TRANSACTIONSTRING];
        if(tmpSecondUUID != nil)
        {
            locTrans.transactionstring = tmpSecondUUID;
            [appDelegate.managedObjectContext save:&error];
        }
        NSDate  *localDate = locTrans.dateTime_sync;
        NSDate *serverDate = [oneRecord objectForKey:TRANSACTION_DATETIME_SYNC];
        
        if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]<0)
        {
            [self saveLocalTransaction:locTrans FromServerTransaction:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:localDate withDate:serverDate]>0)
        {
            [self saveSeverTransaction:oneRecord fromLocalTransaction:locTrans];
        }


    }
    else
    {
        [self saveSeverTransaction:nil fromLocalTransaction:locTrans];
    }
}

//server -> local
-(id)saveLocalTransaction:(Transaction *)localTrans FromServerTransaction:(DBRecord *)oneRecord {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (oneRecord==nil) {
        return nil;
    }
    //uuid
    if ([oneRecord objectForKey:TRANSACTION_UUID] ==nil) {
        [oneRecord deleteRecord];
        return nil;
    }
    
//    if (needCountMax)
//    {
//        countMax++;
//        NSLog(@"countMax:%d",countMax);
//
//    }
    //state
    if ([[oneRecord objectForKey:TRANSACTION_STATE] isEqualToString:@"0"]) {
        [appDelegate.managedObjectContext deleteObject:localTrans];
        return nil;
    }
    
    NSError *error =nil;
    if (localTrans == nil) {
        localTrans = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    //second uuid
    NSString *tmpSecondUUID = [oneRecord objectForKey:TRANSACTION_TRANSACTIONSTRING];
    if (tmpSecondUUID!=nil && [tmpSecondUUID length]>0)
    {
        localTrans.transactionstring = tmpSecondUUID;
    }
    localTrans.amount = [oneRecord objectForKey:TRANSACTION_AMOUNT];
    localTrans.dateTime = [oneRecord objectForKey:TRANSACTION_DATETIME];
    localTrans.type = [oneRecord objectForKey:TRANSACTION_TYPE];
    localTrans.recurringType = [oneRecord objectForKey:TRANSACTION_RECURRINGTYPE];
    localTrans.isClear = [oneRecord objectForKey:TRANSACTION_ISCLEAR];
    localTrans.notes = [oneRecord objectForKey:TRANSACTION_NOTES];
    
    //payee
    if ([oneRecord objectForKey:TRANSACTION_PAYEE]==nil) {
        localTrans.payee = nil;
    }
    else
    {
        NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:[oneRecord objectForKey:TRANSACTION_PAYEE],@"UUID", nil];
        NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchPayeeWithUUID" substitutionVariables:sub];
        NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
        if ([objects count]>0) {
            localTrans.payee = [objects lastObject];
        }
    }
    
    //incomeaccount
    if ([oneRecord objectForKey:TRANSACTION_INCOMEACCOUNT] != nil) {
        Accounts *account = [self fetchLocal_account_withUUID:[oneRecord objectForKey:TRANSACTION_INCOMEACCOUNT] ifDontHaveCreate:NO];
        if (account != nil) {
            localTrans.incomeAccount = account;
        }
    }
    
    //expnese account
    if ([oneRecord objectForKey:TRANSACTION_EXPENSEACCOUNT] != nil) {
        Accounts *account = [self fetchLocal_account_withUUID:[oneRecord objectForKey:TRANSACTION_EXPENSEACCOUNT] ifDontHaveCreate:NO];
        if (account != nil) {
            localTrans.expenseAccount = account;
        }
       
    }
    
    //category
    if ([oneRecord objectForKey:TRANSACTION_CATEGORY]!= nil) {
        Category *category = [self fetchLocal_category_withUUID:[oneRecord objectForKey:TRANSACTION_CATEGORY] ifDontHaveCreate:YES];
        if (category != nil) {
            localTrans.category = category;
        }
    }
    
    if ([oneRecord objectForKey:TRANSACTION_PAYEE] != nil) {
        Payee *payee = [self fetchLocal_payee_withUUID:[oneRecord objectForKey:TRANSACTION_PAYEE] ifDontHaveCreate:NO];
        if (payee != nil) {
            localTrans.payee = payee;
        }
    }
    
    
    //delete local child transaction
    for (int i=0; i<[[localTrans.childTransactions allObjects]count]; i++)
    {
        Transaction *oneChildTransaction = [[localTrans.childTransactions allObjects]objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneChildTransaction];
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    
    //par transaction
    if ([oneRecord objectForKey:TRANSACTION_PARTRANSACTION] != nil && [[oneRecord objectForKey:TRANSACTION_PARTRANSACTION] length]>0) {
        Transaction *tmpParTrans = [self  fetchLocal_transaction_withUUID:[oneRecord objectForKey:TRANSACTION_PARTRANSACTION] ifDontHaveCreate:YES];
        if (tmpParTrans != nil)
        {
            localTrans.parTransaction = tmpParTrans;
        }
    }
    
    
    //ep_billrule
    if ([[oneRecord objectForKey:TRANSACTION_BILLRULE] length]>0) {
        EP_BillRule *tmpBillRule = [self fetchLocal_billRule_withUUID:[oneRecord objectForKey:TRANSACTION_BILLRULE] ifDontHaveCreate:YES];
        if (tmpBillRule != nil) {
            localTrans.transactionHasBillRule = tmpBillRule;
        }
    }
    
    //billitem
    if ([[oneRecord objectForKey:TRANSACTION_BILLITEM] length]>0) {
        EP_BillItem *tmpBillItem = [self fetchLocal_billItem_withUUID:[oneRecord objectForKey:TRANSACTION_BILLITEM] ifDontHaveCreate:YES];
        if (tmpBillItem != nil) {
            localTrans.transactionHasBillItem = tmpBillItem;
        }
    }
    
    localTrans.dateTime_sync = [oneRecord objectForKey:TRANSACTION_DATETIME_SYNC];
    localTrans.state = [oneRecord objectForKey:TRANSACTION_STATE];
    localTrans.uuid = [oneRecord objectForKey:TRANSACTION_UUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;
    return localTrans;
}




-(void)saveSeverTransaction:(DBRecord *)oneRecord fromLocalTransaction:(Transaction *)localTransaction{
    
//    static long syncNum = 0;
//    syncNum ++;
//    NSLog(@"syncNum:%ld",syncNum);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (localTransaction==nil)
    {
        return;
    }
    if (localTransaction.uuid ==nil)
    {
        [appDelegate.managedObjectContext deleteObject:localTransaction];
        [appDelegate.managedObjectContext save:&error];
    }
    countMax++;
    NSLog(@"cout:%d",countMax);
    
    if (oneRecord==nil)
    {
        DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
        oneRecord = [transactionTable  insert:@{
                                                TRANSACTION_UUID:localTransaction.uuid} ];

    }
    else
    {
        if (fabs([localTransaction.amount doubleValue]) > 0)
        {
            [oneRecord setObject:localTransaction.amount forKey:TRANSACTION_AMOUNT ];
        }
    }
    
    //公共的部分
    if (localTransaction.dateTime != nil) {
        [oneRecord setObject:localTransaction.dateTime forKey:TRANSACTION_DATETIME];

    }
    if (localTransaction.recurringType != nil)
    {
        [oneRecord setObject:localTransaction.recurringType forKey:TRANSACTION_RECURRINGTYPE];

    }
    
    if (localTransaction.isClear != nil)
    {
        [oneRecord setObject:localTransaction.isClear forKey:TRANSACTION_ISCLEAR];
    }
    
    if ([localTransaction.transactionstring length]>0)
    {
        [oneRecord setObject:localTransaction.transactionstring forKey:TRANSACTION_TRANSACTIONSTRING];
        //这里在5.4.3之前，是有的，所以本地的数据该字段可能被清楚了，产生的错误数据就一直存在了。
//        localTransaction.transactionstring = nil;
    }
    if (localTransaction.payee != nil)
    {
        [oneRecord setObject:localTransaction.payee.uuid forKey:TRANSACTION_PAYEE];
    }
    if (localTransaction.notes != nil)
    {
        [oneRecord setObject:localTransaction.notes forKey:TRANSACTION_NOTES];
    }

    if (localTransaction.incomeAccount != nil)
    {
        [oneRecord setObject:localTransaction.incomeAccount.uuid forKey:TRANSACTION_INCOMEACCOUNT];
    }
    if (localTransaction.expenseAccount != nil)
    {
        [oneRecord setObject:localTransaction.expenseAccount.uuid forKey:TRANSACTION_EXPENSEACCOUNT];
    }
    if (localTransaction.category != nil)
    {
        [oneRecord setObject:localTransaction.category.uuid forKey:TRANSACTION_CATEGORY];
    }
    
    //搜索该交易子类transaction,有的话直接删除server端的，然后再重新设置server端的子类
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBError *dberror = nil;
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:localTransaction.uuid,TRANSACTION_PARTRANSACTION, nil];
    NSArray *objects = [transactionTable query:sub error:&dberror];
    for (int i=0; i<[objects count]; i++)
    {
        DBRecord *oneRecord = [objects objectAtIndex:i];
        [oneRecord deleteRecord];
    }

    
    //搜索该交易父transaction，重新设置父transaction的uuid
    [oneRecord removeObjectForKey:TRANSACTION_PARTRANSACTION];
    if (localTransaction.parTransaction != nil)
    {
        [oneRecord setObject:localTransaction.parTransaction.uuid forKey:TRANSACTION_PARTRANSACTION];
    }

    
    //bill rule
    if (localTransaction.transactionHasBillRule != nil)
    {
        [oneRecord setObject:localTransaction.transactionHasBillRule.uuid forKey:TRANSACTION_BILLRULE];
    }
    //bill item
    if (localTransaction.transactionHasBillItem != nil)
    {
        [oneRecord setObject:localTransaction.transactionHasBillItem.uuid forKey:TRANSACTION_BILLITEM];
    }
    
    //time sync
    if (localTransaction.dateTime_sync != nil)
        [oneRecord setObject:localTransaction.dateTime_sync forKey:TRANSACTION_DATETIME_SYNC];
    //state
    if (localTransaction.state != nil)
        [oneRecord setObject:localTransaction.state forKey:TRANSACTION_STATE];
    
    //amount
    if (fabs([localTransaction.amount doubleValue]) > 0)
    {
        [oneRecord setObject:localTransaction.amount forKey:TRANSACTION_AMOUNT ];
    }

   
    if ([localTransaction.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:localTransaction];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
    
    
    
    //多加
//    [self.drop_dataStore sync:&dberror];
    
}

//////////////
//////////////EP_BillRule table

#pragma mark EP_BillRule Method
-(void)update_BillRuleTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        
        if ([oneRecord objectForKey:BILLRULE_UUID]==nil || [self tolocal_check_data:oneRecord[BILLRULE_UUID]]==nil)
        {
            [oneRecord deleteRecord];
        }
        else
        {
            NSError *error = nil;
            
            EP_BillRule *oneBillRule = [self fetchLocal_billRule_withUUID:[oneRecord objectForKey:BILLRULE_UUID] ifDontHaveCreate:NO];
            
            NSDate  *serverDate = [oneRecord objectForKey:BILLRULE_DATETIME];
            NSDate  *localDate = oneBillRule.dateTime;
            
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"]) {
                
                
                if (oneBillRule != nil) {
                    //server time < local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [appDelegate.managedObjectContext deleteObject:oneBillRule];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time > local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBillRule:oneRecord fromLocalBillRule:oneBillRule];
                        [oneRecord setObject:@"0" forKey:TRANSACTION_STATE];
                    }
                }
            }
            //state == 1
            else{
                if (oneBillRule == nil) {
                    [self saveLocalBillRule:nil FromServerBillRule:oneRecord];
                }
                else
                {
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalBillRule:oneBillRule FromServerBillRule:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBillRule:oneRecord fromLocalBillRule:oneBillRule];
                    }
                    
                }
            }
        }

    }
}

-(void)update_EP_BillRuleTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        EP_BillRule *oneBillRule = [object objectAtIndex:i];
        [self updateEveryBillRuleDataFromLocal:oneBillRule];
        [[ParseDBManager sharedManager]updateBillRuleFromLocal:oneBillRule];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
    }
    
}


-(void)updateEveryBillRuleDataFromLocal:(EP_BillRule *)localBillRule{
    DBError   *dberror = nil;
    DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localBillRule==nil)
    {
        return;
    }
    else if (localBillRule.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBillRule];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localBillRule.uuid,BILLRULE_UUID, nil];
    NSArray *selectedStudentArray = [billRuleTable query:dictionary error:&dberror];
    
    
    //如果本地数据是删除，那么 sync ,delete
    if ([selectedStudentArray count]==0)
    {
        [self saveSeverBillRule:nil fromLocalBillRule:localBillRule];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_EP_BILLRULE_TABLE];
        
        NSDate  *serverDate = [oneRecord objectForKey:BILLRULE_DATETIME];
        NSDate  *localDate = localBillRule.dateTime;
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalBillRule:localBillRule FromServerBillRule:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
            [self saveSeverBillRule:oneRecord fromLocalBillRule:localBillRule];
        }
        
    }

}



-(id)saveLocalBillRule:(EP_BillRule *)localBillRule FromServerBillRule:(DBRecord *)oneRecord{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (oneRecord==nil) {
        return nil;
    }
    if ([oneRecord objectForKey:BILLRULE_UUID] ==nil) {
        [oneRecord deleteRecord];
        return nil;
    }
    
    if (localBillRule == nil) {
        localBillRule = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    NSError *error =nil;
    localBillRule.ep_billName = [oneRecord objectForKey:BILLRULE_EP_BILLNAME];
    localBillRule.ep_billAmount = [oneRecord objectForKey:BILLRULE_EP_BILLAMOUNT];
    localBillRule.ep_billDueDate = [oneRecord objectForKey:BILLRULE_EP_BILLDUEDATE];
    localBillRule.ep_billEndDate = [oneRecord objectForKey:BILLRULE_EP_BILLENDDATE];
    localBillRule.ep_billName = [oneRecord objectForKey:BILLRULE_EP_BILLNAME];
    localBillRule.ep_note = [oneRecord objectForKey:BILLRULE_EP_NOTE];
    localBillRule.ep_recurringType = [oneRecord objectForKey:BILLRULE_EP_RECURRINGTYPE];
    localBillRule.ep_reminderDate = [oneRecord objectForKey:BILLRULE_EP_REMINDERDATE];
    localBillRule.ep_reminderTime = [oneRecord objectForKey:BILLRULE_EP_REMINDERTIME];

    localBillRule.dateTime = [oneRecord objectForKey:BILLRULE_DATETIME];
    localBillRule.state = [oneRecord objectForKey:BILLRULE_STATE];
    localBillRule.uuid = [oneRecord objectForKey:BILLRULE_UUID];


    //category
    if ([oneRecord objectForKey:BILLRULE_BILLRULEHASCATEGORY] != nil) {
        localBillRule.billRuleHasCategory = [self fetchLocal_category_withUUID:[oneRecord objectForKey:BILLRULE_BILLRULEHASCATEGORY] ifDontHaveCreate:YES];
    }
    //payee
    if ([oneRecord objectForKey:BILLRULE_BILLRULEHASPAYEE] != nil) {
        localBillRule.billRuleHasPayee = [self fetchLocal_payee_withUUID:[oneRecord objectForKey:BILLRULE_BILLRULEHASPAYEE] ifDontHaveCreate:NO];
    }
    //transaction
//    if ([oneRecord objectForKey:BILLRULE_BILLRULEHASRTANSACTION] != nil) {
//        DBList *list = [oneRecord objectForKey:BILLRULE_BILLRULEHASRTANSACTION];
//        for (int i=0; i<[list count]; i++) {
//            NSString *oneUUID = [list objectAtIndex:i];
//            Transaction *oneTrans = [self fetchLocal_transaction_withUUID:oneUUID];
//            [localBillRule addBillRuleHasTransactionObject:oneTrans];
//        }
//    }
    
    //billitem
//    if ([oneRecord objectForKey:BILLRULE_BILLRULEHASBILLITEM] != nil) {
//        DBList *list =[oneRecord objectForKey:BILLRULE_BILLRULEHASBILLITEM];
//        for (int i=0; i<[list count]; i++) {
//            NSString *oneUUID = [list objectAtIndex:i];
//            EP_BillItem *oneBillItem = [self fetchLocal_billItem_withUUID:oneUUID];
//            if (oneBillItem != nil) {
//                [localBillRule addBillRuleHasBillItemObject:oneBillItem];
//            }
//        }
//    }
    localBillRule.dateTime = [oneRecord objectForKey:BILLRULE_DATETIME];
    localBillRule.state = [oneRecord objectForKey:BILLRULE_STATE];
    localBillRule.uuid = [oneRecord objectForKey:BILLRULE_UUID];

    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);

    }
   
    needToReflesh = YES;
    
    return localBillRule;
}

-(void)saveSeverBillRule:(DBRecord *)oneRecord fromLocalBillRule:(EP_BillRule *)localBillRule{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (localBillRule==nil)
    {
        return;
    }
    if (localBillRule.uuid ==nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBillRule];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    countMax++;
    if (oneRecord==nil)
    {
        DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
       oneRecord = [billRuleTable  insert:@{
                                                       BILLRULE_EP_BILLAMOUNT:localBillRule.ep_billAmount,
                                                       } ];
        
    }
    else
    {
        [oneRecord setObject:localBillRule.ep_billAmount forKey:BILLRULE_EP_BILLAMOUNT];
    }
   
    //add edit公共的部分
    if ([localBillRule.ep_billName length]>0)
        [oneRecord setObject:localBillRule.ep_billName forKey:BILLRULE_EP_BILLNAME];
    
    
    
    if (localBillRule.ep_billDueDate != nil)
        [oneRecord setObject:localBillRule.ep_billDueDate forKey:BILLRULE_EP_BILLDUEDATE];
    
    if (localBillRule.ep_billEndDate != nil)
        [oneRecord setObject:localBillRule.ep_billEndDate forKey:BILLRULE_EP_BILLENDDATE];
    
    if ([localBillRule.ep_billName length]>0)
        [oneRecord setObject:localBillRule.ep_billName forKey:BILLRULE_EP_BILLNAME];
    
    if (localBillRule.ep_recurringType.length > 0)
        [oneRecord setObject:localBillRule.ep_recurringType forKey:BILLRULE_EP_RECURRINGTYPE ];
    
    if ([localBillRule.ep_note length]>0)
        [oneRecord setObject:localBillRule.ep_note forKey:BILLRULE_EP_NOTE];

    
    if (localBillRule.ep_reminderDate != nil)
        [oneRecord setObject:localBillRule.ep_reminderDate forKey:BILLRULE_EP_REMINDERDATE];
    
    if (localBillRule.ep_reminderTime != nil)
        [oneRecord setObject:localBillRule.ep_reminderTime forKey:BILLRULE_EP_REMINDERTIME];
    
    //billcategory
    if (localBillRule.billRuleHasCategory != nil)
        [oneRecord setObject:localBillRule.billRuleHasCategory.uuid forKey:BILLRULE_BILLRULEHASCATEGORY];

    //bill payee
    if (localBillRule.billRuleHasPayee != nil)
        [oneRecord setObject:localBillRule.billRuleHasPayee.uuid forKey:BILLRULE_BILLRULEHASPAYEE];
    
    if (localBillRule.dateTime != nil)
        [oneRecord setObject:localBillRule.dateTime forKey:BILLRULE_DATETIME ];
    
    if (localBillRule.state != nil)
        [oneRecord setObject:localBillRule.state forKey:BILLRULE_STATE ];
    
    if (localBillRule.uuid != nil)
        [oneRecord setObject:localBillRule.uuid forKey:BILLRULE_UUID ];
    
    
    
    //这个这个更新是删除的话，就需要顺带删除自身
    if ([localBillRule.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:localBillRule];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
}


////////////////////
#pragma mark EP_BillItem
-(void)update_EP_BillItemTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillItem"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        EP_BillItem *oneBillItem = [object objectAtIndex:i];
        [self updateEveryBillItemDataFromLocal:oneBillItem];
        [[ParseDBManager sharedManager]updateBillItemFormLocal:oneBillItem];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
    }
    
}
-(void)update_BillItemTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        
        if ([oneRecord objectForKey:BILLITEM_UUID]==nil || [self tolocal_check_data:oneRecord[BILLITEM_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            EP_BillItem *oneBillItem = [self fetchLocal_billItem_withUUID:[oneRecord objectForKey:BILLITEM_UUID] ifDontHaveCreate:NO];
            NSDate  *serverDate = [oneRecord objectForKey:BILLITEM_DATETIME];
            NSDate  *localDate = oneBillItem.dateTime;
            
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"]) {
                
                
                if (oneRecord != nil) {
                    //server time < local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        
                        for(int k=0;k<[[oneBillItem.billItemHasTransaction allObjects]count];k++){
                            Transaction *oneTrans = [[oneBillItem.billItemHasTransaction allObjects]objectAtIndex:k];
                            [appDelegate.managedObjectContext deleteObject:oneTrans];
                        }
                        
                        [appDelegate.managedObjectContext deleteObject:oneBillItem];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time > local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBillItem:oneRecord fromLocalBillItem:oneBillItem];
                        [oneRecord setObject:@"0" forKey:TRANSACTION_STATE];
                    }
                }
                //如果没找到这个billitem的话，就判断是不是有第二uuid的billitem存在，存在的话，修改她的uuid
                else
                {
                    if ([[oneRecord objectForKey:BILLITEM_EP_BILLITEMSTRING1]length]>0) {
                        [self search_LocalBillItemWith_SecondUUID:[oneRecord objectForKey:BILLITEM_EP_BILLITEMSTRING1] serBillItem:oneRecord state:@"0"];
                    }
                }
            }
            //state == 1
            else{
                if (oneBillItem == nil) {
                    if ([[oneRecord objectForKey:BILLITEM_EP_BILLITEMSTRING1]length]>0) {
                        [self search_LocalBillItemWith_SecondUUID:[oneRecord objectForKey:BILLITEM_EP_BILLITEMSTRING1] serBillItem:oneRecord state:@"1"];
                    }
                    else
                        [self saveLocalBillItem:nil FromServerBillItem:oneRecord];
                }
                else
                {
                    
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalBillItem:oneBillItem FromServerBillItem:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBillItem:oneRecord fromLocalBillItem:oneBillItem];
                    }
                    
                }
            }
        }

    }
}

//这里的更新是在程序中处理完了其他的所有事情最终才会到这里来保存
-(void)updateEveryBillItemDataFromLocal:(EP_BillItem *)localBillItem{
    DBError   *dberror = nil;
    DBTable *billRuleTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localBillItem==nil)
    {
        return;
    }
    else if (localBillItem.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBillItem];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localBillItem.uuid,BILLITEM_UUID, nil];
    NSArray *selectedStudentArray = [billRuleTable query:dictionary error:&dberror];
    
    
    //如果本地数据是删除，那么 sync ,delete
    if ([selectedStudentArray count]==0)
    {
        if ([localBillItem.ep_billItemString1 length]>0) {
            [self search_ServerBillItem_WithSecondUUID:localBillItem.ep_billItemString1 localBillItem:localBillItem];
        }
        else
            [self saveSeverBillItem:nil fromLocalBillItem:localBillItem];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_EP_BILLITEM_TABLE];
        NSDate  *serverDate = [oneRecord objectForKey:BILLITEM_DATETIME];
        NSDate  *localDate = localBillItem.dateTime;
        
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalBillItem:localBillItem FromServerBillItem:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
            [self saveSeverBillItem:oneRecord fromLocalBillItem:localBillItem];
        }
    }
    
}

//保存billitem local-> server，需要对相应的transaction进行操作
-(void)saveSeverBillItem:(DBRecord *)oneRecord fromLocalBillItem:(EP_BillItem *)locBillItem{

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (locBillItem==nil) {
        return;
    }
    if (locBillItem.uuid ==nil)
    {
        [appDelegate.managedObjectContext deleteObject:locBillItem];
        [appDelegate.managedObjectContext save:&error];
    }
    
    countMax++;
    if (oneRecord==nil)
    {
        DBTable *billItemTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
        oneRecord = [billItemTable  insert:@{
                                             BILLITEM_EP_BILLITEMAMOUNT:locBillItem.ep_billItemAmount
                                             } ];
        
    }
    else
    {
        [oneRecord setObject:locBillItem.ep_billItemAmount forKey:BILLITEM_EP_BILLITEMAMOUNT];
    }
    
    //add edit公共的部分
    if ([locBillItem.ep_billItemName length]>0) {
        [oneRecord setObject:locBillItem.ep_billItemName forKey:BILLITEM_EP_BILLITEMNAME];
    }
    
    if (locBillItem.ep_billItemDueDateNew != nil) {
        [oneRecord setObject:locBillItem.ep_billItemDueDateNew forKey:BILLITEM_EP_BILLITEMDUEDATENEW];
    }
    
    if (locBillItem.ep_billItemDueDate != nil) {
        [oneRecord setObject:locBillItem.ep_billItemDueDate forKey:BILLITEM_EP_BILLITEMDUEDATE];
    }
    
    if (locBillItem.ep_billItemEndDate != nil) {
        [oneRecord setObject:locBillItem.ep_billItemEndDate forKey:BILLITEM_EP_BILLITEMENDDATE];
    }
    
    if ([locBillItem.ep_billItemName length]>0) {
        [oneRecord setObject:locBillItem.ep_billItemName forKey:BILLITEM_EP_BILLITEMNAME];
    }
    
    if (locBillItem.ep_billItemRecurringType.length > 0) {
        [oneRecord setObject:locBillItem.ep_billItemRecurringType forKey:BILLITEM_EP_BILLITEMRECURRING ];
    }
    
    if ([locBillItem.ep_billItemNote length]>0) {
        [oneRecord setObject:locBillItem.ep_billItemNote forKey:BILLITEM_EP_BILLITEMNOTE];
    }
    
    
    if (locBillItem.ep_billItemReminderDate != nil) {
        [oneRecord setObject:locBillItem.ep_billItemReminderDate forKey:BILLITEM_EP_BILLITEMREMINDERDATE];
    }
    if (locBillItem.ep_billItemReminderTime != nil) {
        [oneRecord setObject:locBillItem.ep_billItemReminderTime forKey:BILLITEM_EP_BILLITEMREMINDERTIME];
    }
    
    if ([locBillItem.ep_billItemString1 length]>0) {
        [oneRecord setObject:locBillItem.ep_billItemString1 forKey:BILLITEM_EP_BILLITEMSTRING1];
    }
    
    if ([locBillItem.ep_billisDelete boolValue]) {
        [oneRecord setObject:@"1" forKey:BILLITEM_EP_BILLISDELETE];
    }
    else
        [oneRecord setObject:@"0" forKey:BILLITEM_EP_BILLISDELETE];
    
    //ep_billRule
    if (locBillItem.billItemHasBillRule != nil) {
        [oneRecord setObject:locBillItem.billItemHasBillRule.uuid forKey:BILLITEMHASBILLRULE];

    }
    
    //category
    if (locBillItem.billItemHasCategory != nil) {
        [oneRecord setObject:locBillItem.billItemHasCategory.uuid forKey:BILLITEMHASCATEGORY];

    }
    
    //payee
    if (locBillItem.billItemHasPayee != nil) {
        [oneRecord setObject:locBillItem.billItemHasPayee.uuid forKey:BILLITEMHASPAYEE];
    }
    
    if (locBillItem.dateTime != nil)
        [oneRecord setObject:locBillItem.dateTime forKey:BILLITEM_DATETIME ];
    
    if (locBillItem.state != nil)
        [oneRecord setObject:locBillItem.state forKey:BILLITEM_STATE ];
    
    if (locBillItem.uuid != nil)
        [oneRecord setObject:locBillItem.uuid forKey:BILLITEM_UUID ];
    
    //当是删除一个billItem的时候，需要删除底下的trans,修改对应ep_BillRule中的billItem数组，以及删除当前的billItem
    if ([locBillItem.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:locBillItem];
    }

}

-(id)saveLocalBillItem:(EP_BillItem *)localBillItem  FromServerBillItem:(DBRecord *)oneRecord{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (oneRecord==nil) {
        return nil;
    }
    if ([oneRecord objectForKey:BILLITEM_UUID]==nil) {
        [oneRecord deleteRecord];
        return nil;
    }
    
    if (localBillItem == nil) {
        localBillItem = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
    }
    NSError *error =nil;
    localBillItem.ep_billItemName = [oneRecord objectForKey:BILLITEM_EP_BILLITEMNAME];
    localBillItem.ep_billItemAmount = [oneRecord objectForKey:BILLITEM_EP_BILLITEMAMOUNT];
    localBillItem.ep_billItemDueDate = [oneRecord objectForKey:BILLITEM_EP_BILLITEMDUEDATE];
    localBillItem.ep_billItemEndDate = [oneRecord objectForKey:BILLITEM_EP_BILLITEMENDDATE];
    localBillItem.ep_billItemDueDateNew = [oneRecord objectForKey:BILLITEM_EP_BILLITEMDUEDATENEW];
    localBillItem.ep_billItemNote = [oneRecord objectForKey:BILLITEM_EP_BILLITEMNOTE];
    localBillItem.ep_billItemRecurringType = [oneRecord objectForKey:BILLITEM_EP_BILLITEMRECURRING];
    localBillItem.ep_billItemReminderDate = [oneRecord objectForKey:BILLITEM_EP_BILLITEMREMINDERDATE];
    localBillItem.ep_billItemReminderTime = [oneRecord objectForKey:BILLITEM_EP_BILLITEMREMINDERTIME];
    if ([[oneRecord objectForKey:BILLITEM_EP_BILLISDELETE] isEqualToString:@"1"]) {
        localBillItem.ep_billisDelete = [NSNumber numberWithBool:YES];
    }
    else
        localBillItem.ep_billisDelete = [NSNumber numberWithBool:NO];
    
    //category
    if ([oneRecord objectForKey:BILLITEMHASCATEGORY] != nil) {
        localBillItem.billItemHasCategory = [self fetchLocal_category_withUUID:[oneRecord objectForKey:BILLITEMHASCATEGORY] ifDontHaveCreate:YES];
    }
    //payee
    if ([oneRecord objectForKey:BILLITEMHASPAYEE] != nil) {
        localBillItem.billItemHasPayee = [self fetchLocal_payee_withUUID:[oneRecord objectForKey:BILLITEMHASPAYEE] ifDontHaveCreate:NO];
    }
    //rule
    if ([oneRecord objectForKey:BILLITEMHASBILLRULE]!= nil) {
        EP_BillRule *oneBillRule = [self fetchLocal_billRule_withUUID:[oneRecord objectForKey:BILLITEMHASBILLRULE] ifDontHaveCreate:YES];
        if (oneBillRule != nil) {
            localBillItem.billItemHasBillRule = oneBillRule;
        }
        
    }
    //transaction if state is delete
    localBillItem.dateTime = [oneRecord objectForKey:BILLITEM_DATETIME];
    localBillItem.state = [oneRecord objectForKey:BILLITEM_STATE];
    localBillItem.uuid = [oneRecord objectForKey:BILLITEM_UUID];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
    }
   ;

    return localBillItem;
}

#pragma mark BudgetTemplate
//更新本地的budgetTemplate的时候，先判断server中有没有相同uuid的，有的话，正常操作，没有的话，判断有没有相同category的budgetTemplate，有的话，就判断local与server哪个迟，如果server中的比较迟的话，就将本地的budgetTemplate,budgetItem，budgetTransfer全删掉。如果local中的比较迟，就将server中的budgetTemplate信息删除，budgetItem与budgetTransfer先不管。
//更新server中的budgetTemplate时候，先判断local中有没有相同uuid的，有的话，正常操作，没有的没有的话判断有没有相同category的budgetTemplate，有的话，就判断local与server哪个迟，如果local中比较迟，就将server中的删除，同上
//budgetItem更新的时候，server->local判断本地有没有budgetTemplate，没有的话，这个server中的记录就不要了
//budgetTransfer更新的时候，判断local有没有budgetItem，没有，这个数据就不要了
-(void)update_BudgetTemplateTable_FromServertoLocal:(NSMutableArray *)changedarray
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        int amount = [oneRecord objectForKey:@"budgettemplate_amount"];
        if (amount==1500)
        {
            NSLog(@"found");
        }
        if ([oneRecord objectForKey:BUDGETTEMPLATE_UUID]==nil || [self tolocal_check_data:oneRecord[BUDGETTEMPLATE_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            //首先搜索有没有相同uuid的budgetTemplate记录,有的话就正常操作没有的话，就要判断有没有category相同了
            BudgetTemplate *oneBudget = [self fetchLocal_BudgetTemplate_withBudgetTemplateUUID:[oneRecord objectForKey:BUDGETTEMPLATE_UUID] ifDontHaveCreate:NO];
            NSDate  *serverDate = [oneRecord objectForKey:BUDGETTEMPLATE_DATETIME];
            NSDate  *localDate = oneBudget.dateTime;
            
            //如果有相同uuid的budgetTemplate就判断时间先后
            if (oneBudget != nil)
            {
                //server time < local time,修改local中的数据
                if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
                {
                    if ([[oneRecord objectForKey:BUDGETTEMPLATE_STATE] isEqualToString:@"0"])
                    {
                        [appDelegate.managedObjectContext deleteObject:oneBudget];
                        [appDelegate.managedObjectContext save:&error];
                        needToReflesh = YES;
                    }
                    else
                    {
                        [self saveLocalBudgetTemplate:oneBudget FromServerBudgetTemplate:oneRecord];
                    }
                    
                }
                //server time 早于 local time,修改server中的数据
                else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0)
                {
                    [self saveSeverBudgetTemplate:oneRecord fromLocalBudgetTemplate:oneBudget];

                }
                
            }
            //搜索本地有没有相同category的budgetTemplate
            else
            {
                oneBudget = [self fetchLocal_BudgetTemplate_withBudgetCategoryUUID:[oneRecord objectForKey:BUDGETTEMPLATE_CATEGORY]];
                NSDate  *localDate = oneBudget.dateTime;

                //搜索相同category的budgetTemplate,如果发现相同的，就要比较时间了，如果没发现相同的，就要创建一个新的记录了
                if (oneBudget != nil)
                {
                    //server time 迟于 local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [appDelegate.managedObjectContext deleteObject:oneBudget];
                        [appDelegate.managedObjectContext save:&error];
                        if ([[oneRecord objectForKey:BUDGETTEMPLATE_STATE]isEqualToString:@"1"]) {
                            [self saveLocalBudgetTemplate:nil FromServerBudgetTemplate:oneRecord];

                        }
                        needToReflesh = YES;
                    }
                    //如果local time迟于server time，就删除server中的时间
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [oneRecord deleteRecord];
                    }
                    
                    
                }
                else
                {
                    [self saveLocalBudgetTemplate:nil FromServerBudgetTemplate:oneRecord];
                }
                
            }
        }
    }


}
-(void)deleteLocal_BudgetTemplatewithOutSync:(BudgetTemplate *)oneBudgetTemplate
{
    NSArray *budgetItemArray = [[NSArray alloc]initWithArray:[oneBudgetTemplate.budgetItems allObjects]];
    PokcetExpenseAppDelegate *appDelegate  = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    for (int i=0; i<[budgetItemArray count]; i++)
    {
        //delete transfer
        BudgetItem *oneBudgetItem = [budgetItemArray objectAtIndex:i];
        NSArray *budgetTransferArray = [[NSArray alloc]initWithArray:[oneBudgetItem.fromTransfer allObjects]];
        for (int m=0; m<[budgetTransferArray count]; m++) {
            BudgetTransfer *oneBudgetTransfer = [budgetTransferArray objectAtIndex:m];
            [appDelegate.managedObjectContext deleteObject:oneBudgetTransfer];
        }
        
        NSArray *budgetToTransferArray = [[NSArray alloc]initWithArray:[oneBudgetItem.toTransfer allObjects]];
        for (int m=0; m<[budgetToTransferArray count]; m++) {
            BudgetTransfer *oneBudgetTransfer = [budgetToTransferArray objectAtIndex:m];
            [appDelegate.managedObjectContext deleteObject:oneBudgetTransfer];
        }
        
        [appDelegate.managedObjectContext deleteObject:oneBudgetItem];
    }
    
    [appDelegate.managedObjectContext deleteObject:oneBudgetTemplate];
    [appDelegate.managedObjectContext save:&error];
}

-(void)update_BudgetTemplateTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        BudgetTemplate *oneBudgetTemplate = [object objectAtIndex:i];
        [self updateEveryBudgetTemplateDataFromLocal:oneBudgetTemplate];
        [[ParseDBManager sharedManager]updateBudgetFromLocal:oneBudgetTemplate];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
        
    }
    
}


//这里5.1版本写错了，删除一个budget的时候，这个category就不能再添加budget了
-(id)updateEveryBudgetTemplateDataFromLocal:(BudgetTemplate *)localBudgetTemplate {
    DBTable *budgetTemplateTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
    DBError *dbError = nil;
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localBudgetTemplate==nil)
    {
        return nil;
    }
    else if (localBudgetTemplate.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBudgetTemplate];
        [appDelegate.managedObjectContext save:&error];
        return nil;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localBudgetTemplate.uuid,BUDGETTEMPLATE_UUID, nil];
    NSArray *selectedStudentArray = [budgetTemplateTable query:dictionary error:&dbError];
    NSDate  *localDate = localBudgetTemplate.dateTime;
    //如果搜索server中没有发现同样uuid的budget就需要搜索当前的category下是不是有budget,有的话，就要将uuid修改一下
    if ([selectedStudentArray count]==0)
    {
        
        //搜索server中，有没有对应相同category的uuid的budget,有的话，比较时间，如果这个budget时间早，就将这个budget及其底下所有的东西删除
        NSString *oneBudgetCategoryUUID =  localBudgetTemplate.category.uuid;
        if (oneBudgetCategoryUUID==nil)
        {
            return nil;
        }
         NSDictionary *dictionary_budget = [[NSDictionary alloc]initWithObjectsAndKeys:oneBudgetCategoryUUID,BUDGETTEMPLATE_CATEGORY, nil];
        NSArray *budgetArray = [budgetTemplateTable query:dictionary_budget error:&dbError];

        //如果server中有相同category的budgetTemplate就要比较时间了
        if ([budgetArray count]>0)
        {
           DBRecord *lastBudgetTemplate =  [self getOnlyDataFromServer:budgetArray tableName:DB_BUDGETTEMPLATE_TABLE];
            NSDate  *serverDate = [lastBudgetTemplate objectForKey:BUDGETTEMPLATE_DATETIME];
            
            //如果local中的早，就将local中所有budget相关的数据都删除
            if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
            {
                [self deleteLocal_BudgetTemplatewithOutSync:localBudgetTemplate];
                needToReflesh = YES;
                return nil;
            }
            //如果server中的早，就将server中所有该budget的信息删除，将当前的budeget同步到server，当另外一台设备打开的时候，就会比较本地的数据与服务器中的数据，发现自己晚了之后，就会将本地的删除了;对于budgetItem先不管，当下次打开这个应用的时候，判断本地的budgetitem有没有budgetTemplate，没有的话就删除;对于budgetTransfer,也先不管，没有budgetItem的话，就将budgetItem删除
            else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0)
            {
                
                [lastBudgetTemplate deleteRecord];
                [self saveSeverBudgetTemplate:nil fromLocalBudgetTemplate:localBudgetTemplate];
                return @"1";
            }

        }
        else
        {
            [self saveSeverBudgetTemplate:nil fromLocalBudgetTemplate:localBudgetTemplate];
            return @"1";

        }
    }
    else
    {
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_BUDGETTEMPLATE_TABLE];
        NSDate  *serverDate = [oneRecord objectForKey:BUDGETTEMPLATE_DATETIME];
        
        //如果localTime早于server time，就修改localtime
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
            [self saveLocalBudgetTemplate:localBudgetTemplate FromServerBudgetTemplate:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverBudgetTemplate:oneRecord fromLocalBudgetTemplate:localBudgetTemplate];
        }
        
        return @"1";
    }
    return @"1";
}

-(void)saveSeverBudgetTemplate:(DBRecord *)record fromLocalBudgetTemplate:(BudgetTemplate *)budgetTemplate{
    DBTable *budgetTemplateTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (budgetTemplate==nil) {
        return;
    }
    if (budgetTemplate.uuid ==nil) {
        [appDelegate.managedObjectContext deleteObject:budgetTemplate];
        [appDelegate.managedObjectContext save:&error];
    }
    
    countMax++;
    if (record == nil) {
        record = [budgetTemplateTable  insert:@{
                                             BUDGETTEMPLATE_AMOUNT:budgetTemplate.amount
                                             } ];
    }
    else{
        [record setObject:budgetTemplate.amount forKey:BUDGETTEMPLATE_AMOUNT];
    }
    if (budgetTemplate.cycleType != nil) {
        [record setObject:budgetTemplate.cycleType forKey:BUDGETTEMPLATE_CYCLETYPE];
    }
    
    if (budgetTemplate.isNew != nil) {
        [record setObject:budgetTemplate.isNew forKey:BUDGETTEMPLATE_ISNEW];
    }
    
    if (budgetTemplate.isRollover != nil) {
        [record setObject:budgetTemplate.isRollover forKey:BUDGETTEMPLATE_ISROLLOVER];
    }
    
    if (budgetTemplate.startDate != nil) {
        [record setObject:budgetTemplate.startDate forKey:BUDGETTEMPLATE_STARTDATE];
    }
    
    if (budgetTemplate.startDateHasChange != nil) {
        [record setObject:budgetTemplate.startDateHasChange forKey:BUDGETTEMPLATE_STARTDATEHASCHANGE];
    }
    
    if (budgetTemplate.category != nil) {
        [record setObject:budgetTemplate.category.uuid forKey:BUDGETTEMPLATE_CATEGORY];
    }

    if (budgetTemplate.dateTime != nil)
        [record setObject:budgetTemplate.dateTime forKey:BUDGETTEMPLATE_DATETIME];
    
    if (budgetTemplate.state != nil)
        [record setObject:budgetTemplate.state forKey:BUDGETTEMPLATE_STATE];
    
    if (budgetTemplate.uuid != nil)
        [record setObject:budgetTemplate.uuid forKey:BUDGETTEMPLATE_UUID];
    
    if ([budgetTemplate.state isEqualToString:@"0"]) {
        [appDelegate.managedObjectContext deleteObject:budgetTemplate];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
}

-(id)saveLocalBudgetTemplate:(BudgetTemplate *)budgetTemplate FromServerBudgetTemplate:(DBRecord *)record{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;
    if (record==nil) {
        return nil;
    }
    if ([record objectForKey:BUDGETTEMPLATE_UUID]==nil) {
        [record deleteRecord];
        return nil;
    }
    if (budgetTemplate == nil) {
        budgetTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTemplate" inManagedObjectContext:appDelegate.managedObjectContext];
    }

    budgetTemplate.amount = [record objectForKey:BUDGETTEMPLATE_AMOUNT];
    budgetTemplate.cycleType = [record objectForKey:BUDGETTEMPLATE_CYCLETYPE];
    budgetTemplate.isNew = [record objectForKey:BUDGETTEMPLATE_ISNEW];
    budgetTemplate.isRollover = [record objectForKey:BUDGETTEMPLATE_ISROLLOVER];
    budgetTemplate.startDate = [record objectForKey:BUDGETTEMPLATE_STARTDATE];
    budgetTemplate.startDateHasChange = [record objectForKey:BUDGETTEMPLATE_STARTDATEHASCHANGE];
    
    budgetTemplate.dateTime = [record objectForKey:BUDGETTEMPLATE_DATETIME];
    budgetTemplate.state = [record objectForKey:BUDGETTEMPLATE_STATE];
    budgetTemplate.uuid = [record objectForKey:BUDGETTEMPLATE_UUID];
    
    if ([record objectForKey:BUDGETTEMPLATE_CATEGORY] != nil) {
        Category *oneCategory = [self fetchLocal_category_withUUID:[record objectForKey:BUDGETTEMPLATE_CATEGORY] ifDontHaveCreate:YES];
        if (oneCategory != nil) {
            budgetTemplate.category = oneCategory;
            
        }
    }
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;
    return budgetTemplate;
}


#pragma mark BudgetItem
-(void)update_BudgetItemTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;

    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        if ([oneRecord objectForKey:BUDGETITEM_UUID]==nil || [self tolocal_check_data:oneRecord[BUDGETITEM_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            BudgetItem *oneBudget = [self fetchLocal_BudgetItem_withRecord:oneRecord ifDontHaveCreate:NO];
            
            NSDate  *serverDate = [oneRecord objectForKey:BUDGETTEMPLATE_DATETIME];
            NSDate  *localDate = oneBudget.dateTime;
            
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"])
            {
                
                if (oneBudget != nil)
                {
                    //server time 迟于 local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [appDelegate.managedObjectContext deleteObject:oneBudget];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time 迟于 local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBudgetItem:oneRecord fromLocalBudgetItem:oneBudget];
                    }
                }
                
                
            }
            //state == 1
            else{
                
                if (oneBudget==nil)
                {
                    [self saveLocalBudgetItem:nil FromServerBudgetItem:oneRecord];
                }
                else
                {
                    
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalBudgetItem:oneBudget FromServerBudgetItem:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        
                        [self saveSeverBudgetItem:oneRecord fromLocalBudgetItem:oneBudget];
                    }
                    
                }
            }
        }
    }
    
}

-(void)update_BudgetItemTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        BudgetItem *oneBudgetItem = [object objectAtIndex:i];
        [self updateEveryBudgetItemDataFromLocal:oneBudgetItem ];
        [[ParseDBManager sharedManager]updateBudgetItemLocal:oneBudgetItem];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
        
    }
    
}

-(void)updateEveryBudgetItemDataFromLocal:(BudgetItem *)localBudgetItem{
    DBTable *budgetItemTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
    DBError *dbError = nil;
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localBudgetItem==nil)
    {
        return;
    }
    else if (localBudgetItem.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBudgetItem];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localBudgetItem.uuid,BUDGETITEM_UUID, nil];
    NSArray *selectedStudentArray = [budgetItemTable query:dictionary error:&dbError];
    
    NSDate  *localDate = localBudgetItem.dateTime;
    
    if ([selectedStudentArray count]==0) {
        //检查budgetitem表格中是不是有相同budgetTemplate，有的话，就修改uuid
        NSString *budgetTemplateuuid = localBudgetItem.budgetTemplate.uuid;
        if (budgetTemplateuuid == nil) {
            return;
        }
        NSDictionary *dictionary_budgetitem = [[NSDictionary alloc]initWithObjectsAndKeys:budgetTemplateuuid,BUDGETITEM_BUDGETTEMPLATE, nil];
        NSArray *selectedStudentArray_budgetitem = [budgetItemTable query:dictionary_budgetitem error:&dbError];
        if ([selectedStudentArray count]>0) {
            DBRecord *oneBudgetItem = [self getOnlyDataFromServer:selectedStudentArray_budgetitem tableName:DB_BUDGETITEM_TABLE];
            localBudgetItem.uuid = [oneBudgetItem objectForKey:BUDGETITEM_UUID];
            [appDelegate.managedObjectContext save:&error];
            
            NSDate  *serverDate = [oneBudgetItem objectForKey:BUDGETITEM_DATETIME];
            
            
            //比较时间先后
            if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
                [self saveLocalBudgetItem:localBudgetItem FromServerBudgetItem:oneBudgetItem];
            }
            else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
                [self saveSeverBudgetItem:oneBudgetItem fromLocalBudgetItem:localBudgetItem];
            }
        }
        else
            [self saveSeverBudgetItem:nil fromLocalBudgetItem:localBudgetItem];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_BUDGETITEM_TABLE];
        NSDate  *serverDate = [oneRecord objectForKey:BUDGETITEM_DATETIME];
        
        //如果localTime早于server time，就修改localtime
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
            [self saveLocalBudgetItem:localBudgetItem FromServerBudgetItem:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverBudgetItem:oneRecord fromLocalBudgetItem:localBudgetItem];
        }
    }
}

-(void)saveSeverBudgetItem:(DBRecord *)record fromLocalBudgetItem:(BudgetItem *)budgetItem{
    DBTable *budgetItemTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    if (budgetItem==nil) {
        return;
    }
    if (budgetItem.uuid ==nil) {
        [appDelegate.managedObjectContext deleteObject:budgetItem];
        [appDelegate.managedObjectContext save:&error];
    }
    
    countMax++;
    if (record == nil) {
        record = [budgetItemTable  insert:@{
                                                BUDGETITEM_AMOUNT:budgetItem.amount
                                                } ];
    }
    else{
        [record setObject:budgetItem.amount forKey:BUDGETITEM_AMOUNT];
    }
    if (budgetItem.endDate != nil) {
        [record setObject:budgetItem.endDate forKey:BUDGETITEM_ENDDATE];
    }
    if (budgetItem.isCurrent != nil) {
        [record setObject:budgetItem.isCurrent forKey:BUDGETITEM_ISCURRENT];
    }
    if (budgetItem.isRollover!= nil) {
        [record setObject:budgetItem.isRollover forKey:BUDGETITEM_ISROLLOVER];
    }
    if (budgetItem.rolloverAmount!=nil) {
        [record setObject:budgetItem.rolloverAmount forKey:BUDGETITEM_ROLLOVERAMOUNT];
    }
    if (budgetItem.startDate!= nil) {
        [record setObject:budgetItem.startDate forKey:BUDGETITEM_STARTDATE];
    }

    if (budgetItem.dateTime != nil)
        [record setObject:budgetItem.dateTime forKey:BUDGETITEM_DATETIME];
    
    if (budgetItem.state != nil)
        [record setObject:budgetItem.state forKey:BUDGETITEM_STATE];
    
    if (budgetItem.uuid != nil)
        [record setObject:budgetItem.uuid forKey:BUDGETITEM_UUID];
    
    if (budgetItem.budgetTemplate != nil)
    {
        [record setObject:budgetItem.budgetTemplate.uuid forKey:BUDGETITEM_BUDGETTEMPLATE];
    }
    
    if ([budgetItem.state isEqualToString:@"0"])
    {
        [appDelegate.managedObjectContext deleteObject:budgetItem];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
}

-(id)saveLocalBudgetItem:(BudgetItem *)budgetItem FromServerBudgetItem:(DBRecord *)record{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;
    if (record==nil) {
        return nil;
    }
    if ([record objectForKey:BUDGETITEM_UUID]==nil) {
        [record deleteRecord];
        return nil;
    }
    BudgetTemplate *oneBudgetTemplate = [self fetchLocal_BudgetTemplate_withBudgetTemplateUUID:[record objectForKey:BUDGETITEM_BUDGETTEMPLATE] ifDontHaveCreate:NO];
    if (oneBudgetTemplate==nil) {
        return nil;
    }
    else
    {
        if (budgetItem == nil) {
            budgetItem = [NSEntityDescription insertNewObjectForEntityForName:@"BudgetItem" inManagedObjectContext:appDelegate.managedObjectContext];
//            [appDelegate.managedObjectContext save:&error];
        }
        
        budgetItem.amount = [record objectForKey:BUDGETITEM_AMOUNT];
        budgetItem.endDate = [record objectForKey:BUDGETITEM_ENDDATE];
        budgetItem.isCurrent = [record objectForKey:BUDGETITEM_ISCURRENT];
        budgetItem.isRollover = [record objectForKey:BUDGETTEMPLATE_ISROLLOVER];
        budgetItem.rolloverAmount = [record objectForKey:BUDGETITEM_ROLLOVERAMOUNT];
        budgetItem.startDate = [record objectForKey:BUDGETITEM_STARTDATE];
        
        budgetItem.dateTime = [record objectForKey:BUDGETITEM_DATETIME];
        budgetItem.state = [record objectForKey:BUDGETITEM_STATE];
        budgetItem.uuid = [record objectForKey:BUDGETITEM_UUID];
        
        budgetItem.budgetTemplate = oneBudgetTemplate;

        
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
        needToReflesh = YES;
        return budgetItem;
    }
    
}

//搜索本地billItem有没有同一secondUUID的billItem
-(void)search_LocalBillItemWith_SecondUUID:(NSString *)secondUUID serBillItem:(DBRecord *)oneRecord state:(NSString *)state{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:secondUUID,@"SECONDUUID", nil];
    NSError *error = nil;
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBillItemWithSecondUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    
    
    NSDate  *serverDate = [oneRecord objectForKey:BILLITEM_DATETIME];
    
    if ([state isEqualToString:@"0"]) {
        
        if ([objects count]>0)
        {
            EP_BillItem *loc_item = [objects lastObject];
    
            loc_item.uuid = [oneRecord objectForKey:BILLITEM_UUID];
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            
            NSDate  *localDate = loc_item.dateTime;
            if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
                [self saveSeverBillItem:oneRecord fromLocalBillItem:loc_item];
            }
            else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
                [self saveLocalBillItem:loc_item FromServerBillItem:oneRecord];
            }
        }
        //如果Server中state=0,并且在本地没找到就不需要操作了
        
    }
    else if ([state isEqualToString:@"1"]){
        //state == @"1"这里要多创建一次
        if ([objects count]==0) {
            EP_BillItem  *oneItem = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
            [self saveLocalBillItem:oneItem FromServerBillItem:oneRecord];
        }
        
        else
        {
            //修改server中的数据
            EP_BillItem *oneItem = [objects lastObject];
            oneItem.uuid = [oneRecord objectForKey:BILLITEM_UUID];
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            
            NSDate  *localDate = oneItem.dateTime;
            if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                [self saveLocalBillItem:oneItem FromServerBillItem:oneRecord];
            }
            
            else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                [self saveSeverBillItem:oneRecord fromLocalBillItem:oneItem];
            }
            
        }
    }
}

-(void)search_ServerBillItem_WithSecondUUID:(NSString *)secondUUID localBillItem:(EP_BillItem *)locBillItem{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    DBTable *billItemTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
    DBError *dberror = nil;
    NSError *error = nil;
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:secondUUID,BILLITEM_EP_BILLITEMSTRING1, nil];
    NSArray *objects = [billItemTable query:sub error:&dberror];
    
    if ([objects count]>0) {
        DBRecord *oneRecord = [objects lastObject];
        locBillItem.uuid = [oneRecord objectForKey:BILLITEM_UUID];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
        
        NSDate  *serverDate = [oneRecord objectForKey:BILLITEM_DATETIME];
        NSDate  *localDate = locBillItem.dateTime;
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverBillItem:oneRecord fromLocalBillItem:locBillItem];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
            [self saveLocalBillItem:locBillItem FromServerBillItem:oneRecord];
        }
    }
    else
    {
        [self saveSeverBillItem:nil fromLocalBillItem:locBillItem];
    }
    
}


#pragma mark BudgetTransfet Table
-(void)update_BudgetTransferTable_FromServertoLocal:(NSMutableArray *)changedarray{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;

    for (int i=0; i<[changedarray count]; i++) {
        DBRecord *oneRecord = [changedarray objectAtIndex:i];
        if ([oneRecord objectForKey:BUDGETTRANSFER_UUID]==nil || [self tolocal_check_data:oneRecord[BUDGETTRANSFER_UUID]]==nil) {
            [oneRecord deleteRecord];
        }
        else
        {
            NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:[oneRecord objectForKey:BUDGETTRANSFER_UUID] ,@"UUID", nil];
            NSFetchRequest *fetchstudent = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBudgetTransferWithUUID" substitutionVariables:sub];
            NSArray *object_BudgetTransafer = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchstudent error:&error]];
            
            BudgetTransfer *oneBudget = [self getLocalOnly_Data:object_BudgetTransafer tableName:@"BudgetTransfer"];
            
            
            NSDate  *serverDate = [oneRecord objectForKey:BUDGETTRANSFER_DATETIME_SYNC];
            NSDate  *localDate = oneBudget.dateTime_sync;
            //state = 0
            if ([[oneRecord objectForKey:@"state"] isEqualToString:@"0"]) {
                
                if (oneBudget!= nil) {
                    //server time 迟于 local time，删除local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0)
                    {
                        [appDelegate.managedObjectContext deleteObject:oneBudget];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                            
                        }
                        needToReflesh = YES;
                    }
                    //server time 迟于 local time,更新 server中的数据
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        [self saveSeverBudgetTransfer:oneRecord fromLocalBudgetTransfer:oneBudget];
                    }
                }
            }
            //state == 1
            else{
                
                if (oneBudget==nil) {
                    [self saveLocalBudgetTransfer:nil FromServerBudgetTransfer:oneRecord];
                }
                else
                {
                    //server time < local time,修改local中的数据
                    if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0) {
                        [self saveLocalBudgetTransfer:oneBudget FromServerBudgetTransfer:oneRecord];
                    }
                    
                    else if([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0){
                        
                        [self saveSeverBudgetTransfer:oneRecord fromLocalBudgetTransfer:oneBudget];
                    }
                    
                }
            }
        }
    }
    
}

-(void)update_BudgetTransferTable_FromLocaltoServer{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTransfer"];
    NSArray *object = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i=0; i<[object count]; i++)
    {
        BudgetTransfer *oneBudgetTransfer = [object objectAtIndex:i];
        [self updateEveryBudgetTransferDataFromLocal:oneBudgetTransfer ];
        [[ParseDBManager sharedManager]updateBudgetTransfer:oneBudgetTransfer];
        if (countMax>=SYNC_MAX_COUNT)
        {
//            DBError *error = nil;
//            [self.drop_dataStore sync:&error];
//            countMax = 0;
            return;
        }
        
    }
    
}

-(void)updateEveryBudgetTransferDataFromLocal:(BudgetTransfer *)localBudgetTransfer{
    DBTable *budgetTransferTable = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];
    DBError *dbError = nil;
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果本地数据是nil,或者本地数据的uuid是nil的就将这个本地数据删除
    if (localBudgetTransfer==nil)
    {
        return;
    }
    else if (localBudgetTransfer.uuid == nil)
    {
        [appDelegate.managedObjectContext deleteObject:localBudgetTransfer];
        [appDelegate.managedObjectContext save:&error];
        return;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:localBudgetTransfer.uuid,BUDGETTRANSFER_UUID, nil];
    NSArray *selectedStudentArray = [budgetTransferTable query:dictionary error:&dbError];
    
    
    if ([selectedStudentArray count]==0) {
        [self saveSeverBudgetTransfer:nil fromLocalBudgetTransfer:localBudgetTransfer];
    }
    else{
        DBRecord *oneRecord = [self getOnlyDataFromServer:selectedStudentArray tableName:DB_BUDGETTRANSFER_TABLE];
        NSDate  *serverDate = [oneRecord objectForKey:BUDGETTRANSFER_DATETIME_SYNC];
        NSDate  *localDate = localBudgetTransfer.dateTime_sync;
        
        //如果localTime早于server time，就修改localtime
        if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]>0){
            [self saveLocalBudgetTransfer:localBudgetTransfer FromServerBudgetTransfer:oneRecord];
        }
        else if ([appDelegate.epnc secondCompare:serverDate withDate:localDate]<0) {
            [self saveSeverBudgetTransfer:oneRecord fromLocalBudgetTransfer:localBudgetTransfer];
        }
    }
}



-(void)saveSeverBudgetTransfer:(DBRecord *)record fromLocalBudgetTransfer:(BudgetTransfer *)budgetTransfer{
    DBTable *budgetTransferTable = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    if (budgetTransfer==nil) {
        return;
    }
    if (budgetTransfer.uuid ==nil) {
        [appDelegate.managedObjectContext deleteObject:budgetTransfer];
        [appDelegate.managedObjectContext save:&error];
    }
    
    countMax++;
    if (record == nil) {
        record = [budgetTransferTable  insert:@{
                                            BUDGETTRANSFER_AMOUNT:budgetTransfer.amount
                                            } ];
    }
    else{
        [record setObject:budgetTransfer.amount forKey:BUDGETTRANSFER_AMOUNT];
    }
    if (budgetTransfer.dateTime != nil) {
        [record setObject:budgetTransfer.dateTime forKey:BUDGETTRANSFER_DATETIME];
    }
    
    if (budgetTransfer.dateTime_sync != nil)
        [record setObject:budgetTransfer.dateTime_sync forKey:BUDGETTRANSFER_DATETIME_SYNC];
    
    if (budgetTransfer.state != nil)
        [record setObject:budgetTransfer.state forKey:BUDGETTRANSFER_STATE];
    
    if (budgetTransfer.uuid != nil)
        [record setObject:budgetTransfer.uuid forKey:BUDGETTRANSFER_UUID];
    
    if (budgetTransfer.fromBudget != nil) {
        [record setObject:budgetTransfer.fromBudget.uuid forKey:BUDGETTRANSFER_FROMBUDGET];
    }
    if (budgetTransfer.toBudget != nil) {
        [record setObject:budgetTransfer.toBudget.uuid forKey:BUDGETTRANSFER_TOBUDGET];
    }
    
    if ([budgetTransfer.state isEqualToString:@"0"]) {
        [appDelegate.managedObjectContext deleteObject:budgetTransfer];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }     }
}

-(id)saveLocalBudgetTransfer:(BudgetTransfer *)budgetTransfer FromServerBudgetTransfer:(DBRecord *)record{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error =nil;
    if (record==nil) {
        return nil;
    }
    if ([record objectForKey:BUDGETTRANSFER_UUID] ==nil) {
        [record deleteRecord];
        return nil;
    }
    if (budgetTransfer == nil) {
        budgetTransfer = [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTransfer" inManagedObjectContext:appDelegate.managedObjectContext];
        [appDelegate.managedObjectContext save:&error];
    }
    budgetTransfer.amount = [record objectForKey:BUDGETTRANSFER_AMOUNT];
    budgetTransfer.dateTime = [record objectForKey:BUDGETTRANSFER_DATETIME];
    
    budgetTransfer.dateTime_sync = [record objectForKey:BUDGETTRANSFER_DATETIME_SYNC];
    budgetTransfer.state = [record objectForKey:BUDGETTRANSFER_STATE];
    budgetTransfer.uuid = [record objectForKey:BUDGETTRANSFER_UUID];
    
    if ([record objectForKey:BUDGETTRANSFER_FROMBUDGET] != nil) {
        //判断local有没有budgetitem有的话就保存，没有的话，就删除这次的budgetTransfer
        BudgetItem *oneBudgetItem = [self fetchLocal_BudgetItem_withUUID:[record objectForKey:BUDGETTRANSFER_FROMBUDGET] ifDontHaveCreate:NO];
        if (oneBudgetItem != nil) {
            budgetTransfer.fromBudget = oneBudgetItem;
        }
        else
        {
            [appDelegate.managedObjectContext deleteObject:budgetTransfer];
            [appDelegate.managedObjectContext save:&error];
            budgetTransfer = nil;

        }
    }
    if ([record objectForKey:BUDGETTRANSFER_TOBUDGET] != nil) {
        BudgetItem *oneBudgetItem = [self fetchLocal_BudgetItem_withUUID:[record objectForKey:BUDGETTRANSFER_TOBUDGET] ifDontHaveCreate:NO];
        if (oneBudgetItem != nil && budgetTransfer!=nil) {
            budgetTransfer.toBudget = oneBudgetItem;
        }
        else if(budgetTransfer != nil)
        {
            [appDelegate.managedObjectContext deleteObject:budgetTransfer];
        }
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    needToReflesh = YES;
    return budgetTransfer;
}



#pragma mark Fetch Local Record
-(id)fetchLocal_account_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //所有对应uuid的外键
    NSDictionary *sub_account = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetchstudent_account = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchAccountWithUUID" substitutionVariables:sub_account];
    NSError *error =nil;
    NSArray *object_account = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchstudent_account error:&error]];
    if ([object_account count]>0) {
        return [self getLocalOnly_Data:object_account tableName:@"Accounts"];
    }
    else
    {
        if (create) {
            DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_ACCOUNT_TABLE];
            if (oneRecord != nil) {
                return [self saveLocalAccount:nil FromServerAccount:oneRecord];
            }
            return nil;
        }
        else
            return nil;
    }
    
}

-(id)fetchLocal_accountType_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    NSDictionary *sub_accountType = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetchstudent_accountType = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchAccountTypeWithUUID" substitutionVariables:sub_accountType];
    NSError *error =nil;
    NSArray *object_accountType = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchstudent_accountType error:&error]];
    if ([object_accountType count]>0) {
        return [self getLocalOnly_Data:object_accountType tableName:LOCAL_ACCOUNTTYPE_TABLE];

    }
    else
    {
        if (create) {
            DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_ACCOUNTTYPE_TABLE];
            if (oneRecord != nil) {
                return [self saveLocalAccountType:nil FromServerAccount:oneRecord];
            }
            return nil;
        }
        else
            return nil;
    }
    
    
}


-(id)fetchLocal_category_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchCategoryWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"Category"];
    }
    else
    {
        if (create) {
            DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_CATEGORY_TABLE];
            if (oneRecord != nil) {
                return [self saveLocalCategory:nil FromServerCategory:oneRecord];
            }
            return nil;
        }
        else
            return nil;
    }
    

}

-(id)fetchLocal_billRule_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBillRuleWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"EP_BillRule"];

    }
    else
    {
        if (create) {
            DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_EP_BILLRULE_TABLE];
            if (oneRecord != nil) {
                return [self saveLocalBillRule:nil FromServerBillRule:oneRecord];
            }
            return nil;
        }
        else
            return nil;
    }
    
}

-(id)fetchLocal_billItem_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBillItemWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"EP_BillItem"];

    }
    else
    {
        if (create) {
            DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_EP_BILLITEM_TABLE];
            if (oneRecord != nil) {
                return [self saveLocalBillItem:nil FromServerBillItem:oneRecord];
            }
            return nil;
        }
        else
            return nil;
    }
}


-(DBRecord *)getOnlyServerCategory:(NSArray *)dataArray{
    DBRecord *ser_cat_return = nil;
    if ([dataArray count]==1) {
        ser_cat_return = [dataArray objectAtIndex:0];
    }
    else{
        ser_cat_return = [dataArray objectAtIndex:0];
        for (DBRecord *oneRecord in dataArray) {
            NSDate *date_sel = [ser_cat_return objectForKey:CATEGORY_DATETIME];
            NSDate *date1 = [oneRecord objectForKey:CATEGORY_DATETIME];
            
            if ([date_sel compare:date1] == NSOrderedAscending) {
                ser_cat_return = oneRecord;
            }
        }
        for (DBRecord *oneRecord in dataArray) {
            if (oneRecord != ser_cat_return) {
                [oneRecord deleteRecord];
            }
        }
    }
    return ser_cat_return;
}
-(id)fetchServer_Transaction_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    DBTable *transactionTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
    DBError *dberror = nil;
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,TRANSACTION_UUID, nil];
    NSArray *objects = [transactionTable query:sub error:&dberror];
    if ([objects count]>0) {
        return [objects lastObject];
    }
    else
        return nil;
}


-(id)fetchLocal_payee_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchPayeeWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"Payee"];

    }
    
    if (create) {
        DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_PAYEE_TABLE];
        if (oneRecord != nil) {
            return [self saveLocalPayee:nil FromServerPayee:oneRecord];
        }
    }
   
    return nil;
}

-(id)fetchLocal_transaction_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchTransactionWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0) {
        
        return [self getLocalOnly_Data:objects tableName:@"Transaction"];

    }
    else
        return nil;
    
}

//通过搜索budgetTemplateUUID 来获取相同uuid的budgettemplate,
-(id)fetchLocal_BudgetTemplate_withBudgetTemplateUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create
{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    //为什么在这之前做了判断，后期还要判断呢，为什么明明是5个值，最后还会再跑一遍这个程序呢？
    if (uuid==nil)
    {
        return nil;
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBudgetTemplateWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"BudgetTemplate"];
    }
    else if(create) {
        DBRecord *oneRecord = [self fetchServerwithUUID:uuid withTableName:DB_BUDGETTEMPLATE_TABLE];
        if (oneRecord != nil) {
            return [self saveLocalBudgetTemplate:nil FromServerBudgetTemplate:oneRecord];
        }
        return nil;
    }
    else
        return nil;

}


-(id)fetchLocal_BudgetTemplate_withBudgetItemRecord:(DBRecord *)oneRecord
{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSString *uuid = [oneRecord objectForKey:BUDGETTEMPLATE_UUID];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBudgetTemplateWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    
    
    if ([objects count]>0) {
        return [self getLocalOnly_Data:objects tableName:@"BudgetTemplate"];
    }
    //寻找本地具有相同budgetcategoryuuid的记录，有的话，替换server中的uuid
    else
    {
        NSString *budget_categoryuuid = [oneRecord objectForKey:BUDGETTEMPLATE_CATEGORY];
        if (budget_categoryuuid==nil) {
            return nil;
        }
        BudgetTemplate *oneBudgetTemplate = [self fetchLocal_BudgetTemplate_withBudgetCategoryUUID:budget_categoryuuid];
        if (oneBudgetTemplate != nil) {
            [oneRecord setObject:oneBudgetTemplate.category.uuid forKey:BUDGETTEMPLATE_CATEGORY];
            return oneBudgetTemplate;
        }
        else
            return nil;
    }
    
    
}

-(id)fetchLocal_BudgetTemplate_withBudgetCategoryUUID:(NSString *)uuid
{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:appDelegaet.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.uuid LIKE[c] %@", uuid];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSArray *fetchedObjects = [appDelegaet.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] == 0) {
        return nil;
    }
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return [self getLocalOnly_Data:objects tableName:DB_BUDGETTEMPLATE_TABLE];
}

-(id)fetchLocal_BudgetItem_withRecord:(DBRecord *)oneRecord ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet =(PokcetExpenseAppDelegate *) [[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[oneRecord objectForKey:BUDGETITEM_UUID],@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBudgetItemWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0) {
        return  [self getLocalOnly_Data:objects tableName:@"BudgetItem"];
    }
    
    if (create) {
        DBRecord *oneRecord = [self fetchServerwithUUID:[oneRecord objectForKey:BUDGETITEM_UUID] withTableName:DB_BUDGETITEM_TABLE];
        if (oneRecord != nil) {
            return [self saveLocalBudgetItem:nil FromServerBudgetItem:oneRecord];
        }
        return nil;
    }
    else
        return nil;
    
    
}
-(id)fetchLocal_BudgetItem_withUUID:(NSString *)uuid ifDontHaveCreate:(BOOL)create{
    PokcetExpenseAppDelegate *appDelegaet = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:uuid,@"UUID", nil];
    NSFetchRequest *fetch = [appDelegaet.managedObjectModel fetchRequestFromTemplateWithName:@"sync_fetchBudgetItemWithUUID" substitutionVariables:dic];
    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0) {
        return  [self getLocalOnly_Data:objects tableName:@"BudgetItem"];
    }
    
    if (create) {
        DBRecord *oneRecord = [self fetchServerwithUUID:[oneRecord objectForKey:BUDGETITEM_UUID] withTableName:DB_BUDGETITEM_TABLE];
        if (oneRecord != nil) {
            return [self saveLocalBudgetItem:nil FromServerBudgetItem:oneRecord];
        }
        return nil;
    }
    else
        return nil;
    
    
}


//-(id)fetchLocal_BudgetItem_withBudgetTemplateUUID:(NSString *)uuid
//{
//    PokcetExpenseAppDelegate *appDelegaet = [[UIApplication sharedApplication]delegate];
//    NSError *error = nil;
//    
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:appDelegaet.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    // Specify criteria for filtering which objects to fetch
////    BudgetItem 
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"budgetTemplate.uuid LIKE[c] %@", uuid];
//    [fetchRequest setPredicate:predicate];
//    // Specify how the fetched objects should be sorted
////    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
////                                                                   ascending:YES];
////    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//    
//    NSArray *fetchedObjects = [appDelegaet.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    if ([fetchedObjects count]== 0) {
//        return nil;
//    }
//    NSArray *objects = [appDelegaet.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    return [self getLocalOnly_Data:objects tableName:DB_BUDGETITEM_TABLE];
//}

-(id)fetchServerwithUUID:(NSString *)uuid withTableName:(NSString *)tableName{
    DBTable *serverTable;
    NSDictionary *sub;
    if ([tableName isEqualToString:DB_ACCOUNTTYPE_TABLE]) {
        serverTable = [self.drop_dataStore getTable:DB_ACCOUNTTYPE_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,ACCOUNTTYPE_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_ACCOUNT_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_ACCOUNT_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,ACCOUNT_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_CATEGORY_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_CATEGORY_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,CATEGORY_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_PAYEE_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_PAYEE_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,PAYEE_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_TRANSACTION_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_TRANSACTION_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,TRANSACTION_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_BUDGETTEMPLATE_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_BUDGETTEMPLATE_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,BUDGETTEMPLATE_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_BUDGETITEM_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_BUDGETITEM_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,BUDGETITEM_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_BUDGETTRANSFER_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_BUDGETTRANSFER_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,BUDGETTRANSFER_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_EP_BILLRULE_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_EP_BILLRULE_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,BILLRULE_UUID ,nil];
    }
    else if ([tableName isEqualToString:DB_EP_BILLITEM_TABLE]){
        serverTable = [self.drop_dataStore getTable:DB_EP_BILLITEM_TABLE];
        sub =  [[NSDictionary alloc]initWithObjectsAndKeys:uuid,BILLITEM_UUID ,nil];
    }
    
    
    DBError *error = nil;
    NSArray *objects = [serverTable query:sub error:&error];
    if ([objects count]>0) {
        return [self getOnlyServerCategory:objects];
//        return [objects lastObject];
        
    }
    else
        return nil;
}

#pragma mark Get Only Data From Server
-(DBRecord *)getOnlyDataFromServer:(NSArray *)dataArray tableName:(NSString *)table_Name
{
    DBRecord *serverRecord_return;
    if ([dataArray count] == 1)
    {
        serverRecord_return = [dataArray objectAtIndex:0];
    }
    else
    {
        NSString *one_date;
        if ([table_Name isEqualToString:DB_ACCOUNTTYPE_TABLE]) {
            one_date = ACCOUNTTYPE_DATETIME;
        }
        else if ([table_Name isEqualToString:DB_ACCOUNT_TABLE])
            one_date = ACCOUNT_DATETIME_SYNC;
        else if ([table_Name isEqualToString:DB_CATEGORY_TABLE])
            one_date = CATEGORY_DATETIME;
        else if ([table_Name isEqualToString:DB_PAYEE_TABLE])
            one_date = PAYEE_DATETIME;
        else if ([table_Name isEqualToString:DB_TRANSACTION_TABLE])
            one_date = TRANSACTION_DATETIME_SYNC;
        else if ([table_Name isEqualToString:DB_BUDGETTEMPLATE_TABLE])
            one_date = BUDGETTEMPLATE_DATETIME;
        else if ([table_Name isEqualToString:DB_BUDGETITEM_TABLE])
            one_date = BUDGETITEM_DATETIME;
        else if ([table_Name isEqualToString:DB_BUDGETTRANSFER_TABLE])
            one_date = BUDGETTRANSFER_DATETIME_SYNC;
        else if ([table_Name isEqualToString:DB_EP_BILLRULE_TABLE])
            one_date = BILLRULE_DATETIME;
        else if ([table_Name isEqualToString:DB_EP_BILLITEM_TABLE])
            one_date = BILLITEM_DATETIME;
        
        serverRecord_return = [dataArray objectAtIndex:0];
        for (DBRecord *oneRecord in dataArray) {
            NSDate *returnDate = serverRecord_return[one_date];
            NSDate *date2 = oneRecord[one_date];
            if ([returnDate compare:date2] == NSOrderedAscending)
            {
                serverRecord_return = oneRecord;
            }
        }
        
        for (DBRecord *oneRedord in dataArray)
        {
            if (![serverRecord_return isEqual:oneRedord])
            {
                [oneRedord deleteRecord];
            }
        }
    }
    
    return serverRecord_return;
}

-(id)getLocalOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name
{
    id returnID = nil;
    if ([dataArray count]==0)
    {
        return nil;
    }
    if ([dataArray count] == 1)
    {
        returnID = [dataArray objectAtIndex:0];
    }
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if ([table_name isEqualToString:LOCAL_ACCOUNTTYPE_TABLE])
        {
            
            if (returnID == nil)
            {
                AccountType  *oneData = [dataArray objectAtIndex:0];
                for (AccountType *sel_red in dataArray)
                {
                    if ([oneData.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        oneData = sel_red;
                    }
                }
                returnID = oneData;
            }
            
            AccountType *sel_data = (AccountType *)returnID;
            for (AccountType *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteAccountTypeRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_ACCOUNT_TABLE])
        {
            if (returnID == nil)
            {
                Accounts *sel_data = [dataArray objectAtIndex:0];
                for (Accounts *sel_red in dataArray)
                {
                    if ([sel_data.dateTime_sync compare:sel_red.dateTime_sync] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Accounts *sel_data = (Accounts *)returnID;
            for (Accounts *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteAccountRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_CATEGORY_TABLE])
        {
            if (returnID == nil)
            {
                Category *sel_data = [dataArray objectAtIndex:0];
                for (Category *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Category *sel_data = (Category *)returnID;
            for (Category *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteCategoryAndDeleteRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_PAYEE_TABLE])
        {
            if (returnID == nil)
            {
                Payee *sel_data = [dataArray objectAtIndex:0];
                for (Payee *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Payee *sel_data = (Payee *)returnID;
            for (Payee *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deletePayee_withoutSync:sel_red];
                }
            }
        }
        else if([table_name isEqualToString:LOCAL_TRANSACTION_TABLE])
        {
            if (returnID == nil)
            {
                Transaction *sel_data = [dataArray objectAtIndex:0];
                for (Transaction *sel_red in dataArray)
                {
                    if ([sel_data.dateTime_sync compare:sel_red.dateTime_sync] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Transaction *sel_data = (Transaction *)returnID;
            for (Transaction *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteTransactionRel_withOutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_BUDGETTEMPLATE_TABLE])
        {
            if (returnID == nil)
            {
                BudgetTemplate *sel_data = [dataArray objectAtIndex:0];
                for (BudgetTemplate *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            BudgetTemplate *sel_data = (BudgetTemplate *)returnID;
            for (BudgetTemplate *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteBudgetRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_BUDGETITEM_TABLE])
        {
            if (returnID == nil)
            {
                BudgetItem *sel_data = [dataArray objectAtIndex:0];
                for (BudgetItem *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            BudgetItem *sel_data = (BudgetItem *)returnID;
            for (BudgetItem *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteBudgetItemRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_BUDGETTRANSFER_TABLE])
        {
            if (returnID == nil)
            {
                BudgetTransfer *sel_data = [dataArray objectAtIndex:0];
                for (BudgetTransfer *sel_red in dataArray)
                {
                    if ([sel_data.dateTime_sync compare:sel_red.dateTime_sync] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            BudgetTransfer *sel_data = (BudgetTransfer *)returnID;
            for (BudgetTransfer *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteTransferRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_BILLRULE_TABLE])
        {
            if (returnID == nil)
            {
                EP_BillRule *sel_data = [dataArray objectAtIndex:0];
                for (EP_BillRule *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            EP_BillRule *sel_data = (EP_BillRule *)returnID;
            for (EP_BillRule *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteBillRuleRel_withoutSync:sel_red];
                }
            }
        }
        else if ([table_name isEqualToString:LOCAL_BILLITEM_TABLE])
        {
            if (returnID == nil)
            {
                EP_BillItem *sel_data = [dataArray objectAtIndex:0];
                for (EP_BillItem *sel_red in dataArray)
                {
                    if ([sel_data.dateTime compare:sel_red.dateTime] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            EP_BillItem *sel_data = (EP_BillItem *)returnID;
            for (EP_BillItem *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [appDelegate.epdc deleteBillItemRel_withoutSync:sel_red];
                }
            }
        }
    }
    
    return returnID;
}

//检测server数据是不是合理
-(id)tolocal_check_data:(id)data;
{
    if (data != nil && [data isKindOfClass:[NSString class]])
    {
        NSString *str = (NSString *)data;
        if ([str isEqualToString:DROPBOX_NIL_DATA])
        {
            return nil;
        }
    }
    
    return data;
}

#pragma mark Link Account
//1.链接dropbox账户
-(void)linkDropBoxAccount:(BOOL)needtodrop fromViewController:(id)syncViewController
{
    //关闭
    if (!needtodrop)
    {
        if ([self.drop_account isLinked])
        {
            [self.drop_account unlink];
            NSLog(@"Dropbox unlink!");

        }
        else
            NSLog(@"Dropbox already unlink!");

    }
    //打开
    else
    {
        if (![self.drop_account isLinked])
        {
            _isNeedFlashAll = YES;

            //打开dropbox客户端
            [self.drop_accountManager linkFromController:(UIViewController *)syncViewController];
            
            [self performSelector:@selector(changeStatusBar) withObject:nil afterDelay:0.5];
            NSLog(@"Dropbox link!");
        }
    }
}

-(void)changeStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
//从appdelegate中进入URL代理之后，打开URL
-(void)dropbox_handleOpenURL:(NSURL *)url
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if ([self.drop_accountManager handleOpenURL:url])
    {
        
        if ([self.drop_account isLinked])
        {
            NSLog(@"App linked successfully!");
            appDelegate.isSignUping=NO;
            _isNeedFlashAll = YES;
            
            //创建sync indicatorView
            _syncIndicatorView=[[HMJSyncIndicatorView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-100)/2, 100, 100)];
            [appDelegate.window addSubview:_syncIndicatorView];
        }
        else
        {
            NSLog(@"App linked fail!");
        }
        
        if (isPad)
        {
            AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            [appDelegate_iPad.mainViewController.iSettingViewController.iSyncViewController flashView2];
        }
        else
        {
            
        }
    }
    //取消dropbox页面
    if (self.drop_account==nil)
    {
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (alertView.tag == 100) {
        //替换，将本地的数据替换云端的数据
        if (buttonIndex==0)
        {
            
            
            [self deleteAllServerData_changeStateis0];//仅这一步是可以的
            [self setLocalDataSyncDatetime];//仅这一步也是可以的
            [self detcetAllLocaltoServer];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:OLDUSERDATA];
            [userDefaults synchronize];

        }
        //交互
        else
        {
            [self detcetAllLocaltoServer];
            [self detcetAllServertoLocal_detcetDropboxishasData:NO];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:OLDUSERDATA];
            [userDefaults synchronize];
        }
        
    }
}


- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate hideSyncIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync Failed"
                                                            message:@"Please check your network connection."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        alertView = nil;
    }
    NSLog(@"error-------------------------------------------%@",error);
}
-(void)dropUnlink
{
    [self.drop_account unlink];
    self.drop_dataStore=nil;
}
@end

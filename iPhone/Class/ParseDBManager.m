//
//  ParseDBManager.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/4/29.
//
//

#import "ParseDBManager.h"

#import "PokcetExpenseAppDelegate.h"

#import <Parse/Parse.h>

#import "User.h"

#import "OverViewWeekCalenderViewController.h"

#import "AppDelegate_iPhone.h"

#import "AppDelegate_iPad.h"

#import "UIApplication+NetworkActivity.h"
#define IS_FIRST_UPLOAD_SETTING     @"isFirstUploadSetting"

@implementation ParseDBManager

{
    //多线程coredata操作的第二个context
    NSManagedObjectContext *_childCtx;
}

//由于parse对下载数据数量的限制,该方法用于超过限制数据的下载
-(NSArray *)downloadEveryData:(PFQuery *)query with:(NSError **)error
{
    NSMutableArray *allObjects=[NSMutableArray array];
    
    NSInteger limit=1000;
    NSInteger skip=0;
    NSInteger count;
    [query setLimit:limit];
    [query setSkip:skip];
    do
    {
        NSArray *array=[query findObjects:error];
        
        [allObjects addObjectsFromArray:array];
        skip+=limit;
        [query setSkip:skip];
        count=array.count;
    } while (count==limit);
    return allObjects;
}

+(ParseDBManager *)sharedManager
{
    static ParseDBManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        manager=[[ParseDBManager alloc]init];
    });
    return manager;
}
#pragma mark - 数据 增删改 操作
-(void)updateTransactionFromLocal:(Transaction *)t
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    t.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    
    //设定更新时间
    PFQuery *query;
    NSPredicate *predicate;
    if (t.transactionstring != nil)
    {
        predicate=[NSPredicate predicateWithFormat:@"user=%@ and transactionstring=%@",[PFUser currentUser],t.transactionstring];
        query=[PFQuery queryWithClassName:@"Transaction" predicate:predicate];
    }
    else if(t.uuid != nil)
    {
        predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],t.uuid];
        query=[PFQuery queryWithClassName:@"Transaction" predicate:predicate];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
    {
        if (!error)
        {
            if (data.count)
            {
                //云端存在该数据
                PFObject *transaction=data[0];
                [self assignTransactionServer:transaction WithLocal:t];
                if ([t.state isEqualToString:@"0"])
                {
                    [appDelegate.managedObjectContext deleteObject:t];
                    [appDelegate.managedObjectContext save:&error];
                }
                [transaction saveInBackground];
            }
            else
            {
                //该数据为新创建数据
                PFObject *transaction=[PFObject objectWithClassName:@"Transaction"];
                [self assignTransactionServer:transaction WithLocal:t];
                //新创建的数据需要设置user
                transaction[@"user"]=[PFUser currentUser];
                if (t.photoData!=nil)
                {
                    NSData *imageData=UIImagePNGRepresentation(t.photoData);
                    PFFile *imageFile=[PFFile fileWithName:t.photoName data:imageData];
                    transaction[@"photoData"]=imageFile;
                }
                [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        t.isUpload = @"1";
                        [[XDDataManager shareManager] saveContext];
                    }
                }];
            }
        }
    }];
}

-(void)updatePayeeFromLocal:(Payee *)p
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    p.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],p.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"Payee" predicate:predicate];

    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *payee=data[0];
                 [self assignPayeeServer:payee WithLocal:p];
                 if ([p.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:p];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [payee saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *transaction=[PFObject objectWithClassName:@"Payee"];
                 [self assignPayeeServer:transaction WithLocal:p];
                 //新创建的数据需要设置user
                 transaction[@"user"]=[PFUser currentUser];
                 [transaction saveInBackground];
             }
         }
     }];
}
-(void)updateAccountFromLocal:(Accounts *)a
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    a.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],a.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"Accounts" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        if (data.count)
        {
            //云端存在该数据
            PFObject *account=data[0];
            [self assignAccountsServer:account withLocal:a];
            if ([a.state isEqualToString:@"0"])
            {
                [appDelegate.managedObjectContext deleteObject:a];
                if ([appDelegate.managedObjectContext save:&error])
                {
                    NSLog(@"error %@",error);
                }
            }
            [account saveInBackground];
            
        }
        else
        {
            //该数据为新创建数据
            PFObject *account=[PFObject objectWithClassName:@"Accounts"];
            [self assignAccountsServer:account withLocal:a];
            //新创建的数据需要设置user
            account[@"user"]=[PFUser currentUser];
            [account saveInBackground];
        }
    }];
    
  
}
-(void)updateAccountTypeFromLocal:(AccountType *)at
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    at.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],at.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"AccountType" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignAccountTypeServer:accountType WithLocal:at];
                 if ([at.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:at];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"AccountType"];
                 [self assignAccountTypeServer:accountType WithLocal:at];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateCategoryFromLocal:(Category *)c
{

    if ([c.isSystemRecord isEqualToNumber:[NSNumber numberWithBool:YES]])
    {
        return;
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    c.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],c.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"Category" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignCategoryServer:accountType WithLocal:c];
                 if ([c.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:c];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"Category"];
                 [self assignCategoryServer:accountType WithLocal:c];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateBillRuleFromLocal:(EP_BillRule *)br
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    br.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],br.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"EP_BillRule" predicate:predicate];

    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignBillRuleServer:accountType WithLocal:br];
                 if ([br.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:br];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"EP_BillRule"];
                 [self assignBillRuleServer:accountType WithLocal:br];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateBillItemFormLocal:(EP_BillItem *)bi
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    bi.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],bi.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"EP_BillItem" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignBillItemServer:accountType WithLocal:bi];
                 if ([bi.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:bi];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"EP_BillItem"];
                 [self assignBillItemServer:accountType WithLocal:bi];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateBudgetFromLocal:(BudgetTemplate *)bt
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    bt.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],bt.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetTemplate" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignBudgetTemplateServer:accountType WithLocal:bt];
                 if ([bt.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:bt];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"BudgetTemplate"];
                 [self assignBudgetTemplateServer:accountType WithLocal:bt];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateBudgetItemLocal:(BudgetItem *)bi
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    bi.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],bi.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetItem" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error)
     {
         if (!error)
         {
             if (data.count)
             {
                 //云端存在该数据
                 PFObject *accountType=data[0];
                 [self assignBudgetItemServer:accountType WithLocal:bi];
                 if ([bi.state isEqualToString:@"0"])
                 {
                     [appDelegate.managedObjectContext deleteObject:bi];
                     if ([appDelegate.managedObjectContext save:&error])
                     {
                         NSLog(@"error %@",error);
                     }
                 }
                 [accountType saveInBackground];
             }
             else
             {
                 //该数据为新创建数据
                 PFObject *accountType=[PFObject objectWithClassName:@"BudgetItem"];
                 [self assignBudgetItemServer:accountType WithLocal:bi];
                 //新创建的数据需要设置user
                 accountType[@"user"]=[PFUser currentUser];
                 [accountType saveInBackground];
             }
         }
     }];
}
-(void)updateBudgetTransfer:(BudgetTransfer *)bt
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    bt.updatedTime=[NSDate date];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
    if (!appDelegate.networkConnected)
    {
        return;
    }
    //设定更新时间
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],bt.uuid];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetTransfer" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable data, NSError * _Nullable error) {
        if (!error)
        {
            if (data.count)
            {
                //云端存在该数据
                PFObject *budgetTemplate=data[0];
                [self assignBudgetTransferServer:budgetTemplate WithLocal:bt];
                if ([bt.state isEqualToString:@"0"])
                {
                    [appDelegate.managedObjectContext deleteObject:bt];
                    if ([appDelegate.managedObjectContext save:&error])
                    {
                        NSLog(@"error %@",error);
                    }
                }
                [budgetTemplate saveInBackground];
                
            }
            else
            {
                //该数据为新创建数据
                PFObject *budgetTemplate=[PFObject objectWithClassName:@"BudgetTransfer"];
                [self assignBudgetTransferServer:budgetTemplate WithLocal:bt];
                //新创建的数据需要设置user
                budgetTemplate[@"user"]=[PFUser currentUser];
                [budgetTemplate saveInBackground];
            }
        }
    }];
    
}
#pragma mark - 对managedModel的设置方法
-(NSManagedObjectModel *)createManagerObjectModel
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"PokcetExpense" ofType:@"momd"];
    NSURL *url=[NSURL fileURLWithPath:path];
    
    NSManagedObjectModel *model=[[NSManagedObjectModel alloc]initWithContentsOfURL:url];
    return model;
}
-(void)configCoordinator:(NSPersistentStoreCoordinator *)coor
{
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Expense5.0.0.sqlite"];
    
    NSLog(@"%@",path);
    NSURL *url=[NSURL fileURLWithPath:path];
    
    [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    
}
- (NSPersistentStoreCoordinator *)createCoordinator:(NSManagedObjectModel *)model
{
    NSPersistentStoreCoordinator *coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    return coor;
    
}
#pragma mark - 数据同步
-(void)dataSyncWithSyncBtn:(void (^)(BOOL))completion{
    NSDate *time=[NSDate date];
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    //同步过程中禁止开启另一个同步
    if (appDelegate.isSyncing==YES)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion(YES);

        });
        return;
    }
    
    
    _childCtx=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    appDelegate.isSyncing=YES;
    
    _childCtx.persistentStoreCoordinator=appDelegate.persistentStoreCoordinator;
    [_childCtx performBlock:^{
        
        
        //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
        [query whereKey:@"User" equalTo:[PFUser currentUser]];
        NSArray *array=[query findObjects];
        if (array.count)
        {
            PFObject *object=[array objectAtIndex:0];
            NSString *serverRestoreID=object[@"restoreUUID"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString *localRestoreID=[userDefaults objectForKey:@"restoreUUID"];
            if (serverRestoreID != nil &&![serverRestoreID isEqualToString:localRestoreID])
            {
                [self restoreDataRemove];
                NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
                NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
                requestUser.entity=descUser;
                
                NSError *error;
                
                NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
                
                User *user=[arrayUser objectAtIndex:0];
                user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
                [_childCtx save:&error];
                
                [userDefaults setObject:serverRestoreID forKey:@"restoreUUID"];
                [userDefaults synchronize];
            }
        }
        
        
        //获取上次同步时间
        NSDate *lastSyncTime;
        
        NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
        NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
        requestUser.entity=descUser;
        
        NSError *error;
        
        NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
        
        User *user=[arrayUser objectAtIndex:0];
        lastSyncTime=user.syncTime;
        
        if ([self accountTypeSyncWithServerSince:lastSyncTime]
            &&[self accountsSyncWithServerSince:lastSyncTime]
            &&[self categorySyncWithServerSince:lastSyncTime]
            &&[self budgetTemplateSyncWithServerSince:lastSyncTime]
            &&[self budgetItemSyncWithServerSince:lastSyncTime]
            &&[self budgetTransferSyncWithServerSince:lastSyncTime]
            &&[self payeeSyncWithServerSince:lastSyncTime]
            &&[self billRuleSyncWithServerSince:lastSyncTime]
            &&[self billItemSyncWithServerSince:lastSyncTime]
            &&[self childTransactionSyncWithServerSince:lastSyncTime]
            &&[self parentTransactionSyncWithServerSince:lastSyncTime])
        {
            user.syncTime=time;
            [_childCtx save:&error];
        }
        
        NSLog(@"%@",user.syncTime);
        
        appDelegate.isSyncing=NO;
        
        if (completion) {
            completion(YES);
        }
        
        NSNotificationCenter *not=[NSNotificationCenter defaultCenter];
        [not removeObserver:self];
        //后台不间断同步
        if ([PFUser currentUser])
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

            });
        }
    }];
}


//-(void)dataSyncWithFirstLogInPrompt{
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
//
//
//    XDFirstPromptViewController* view = [[XDFirstPromptViewController alloc]initWithNibName:@"XDFirstPromptViewController" bundle:nil];
//    view.view.frame = CGRectMake(0, -60, SCREEN_WIDTH, 60);
//    [appDelegate_iPhone.window addSubview:view.view];
//
//    [UIView animateWithDuration:0.2 animations:^{
//        view.view.y = 20;
//    }];
//
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [UIView animateWithDuration:0.2 animations:^{
////            view.view.y = -50;
////        } completion:^(BOOL finished) {
////            [view.view removeFromSuperview];
////        }];
////    });
//
//    NSDate *time=[NSDate date];
//
//
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
//
//    //同步过程中禁止开启另一个同步
//    if (appDelegate.isSyncing==YES)
//    {
//        return;
//    }
//
//
//    _childCtx=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//
//    if (ISPAD)
//    {
//        [appDelegate_iPad.mainViewController syncAnimationStart];
//    }
//    else
//    {
//        //        [appDelegate_iPhone.menuVC startAnimation];
//    }
//
//
//    //
//
//
//    appDelegate.isSyncing=YES;
//
//    _childCtx.persistentStoreCoordinator=appDelegate.persistentStoreCoordinator;
//    [_childCtx performBlock:^{
//
//
//        //通知
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
//
//        PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
//        if ([PFUser currentUser]) {
//            [query whereKey:@"User" equalTo:[PFUser currentUser]];
//        }
//        NSArray *array=[query findObjects];
//        if (array.count)
//        {
//            PFObject *object=[array objectAtIndex:0];
//            NSString *serverRestoreID=object[@"restoreUUID"];
//            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//            NSString *localRestoreID=[userDefaults objectForKey:@"restoreUUID"];
//            if (serverRestoreID != nil &&![serverRestoreID isEqualToString:localRestoreID])
//            {
//                [self restoreDataRemove];
//                NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
//                NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
//                requestUser.entity=descUser;
//
//                NSError *error;
//
//                NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
//
//                User *user=[arrayUser objectAtIndex:0];
//                user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
//                [_childCtx save:&error];
//
//                [userDefaults setObject:serverRestoreID forKey:@"restoreUUID"];
//                [userDefaults synchronize];
//            }
//        }
//
//
//        //获取上次同步时间
//        NSDate *lastSyncTime;
//
//        NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
//        NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
//        requestUser.entity=descUser;
//
//        __block NSError *error;
//
//        NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
//
//        User *user=[arrayUser objectAtIndex:0];
//        lastSyncTime=user.syncTime;
//
//
//        if ([self accountTypeSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:1/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self accountsSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:2/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self categorySyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:3/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self budgetTemplateSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:4/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self budgetItemSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:5/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self budgetTransferSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:6/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self payeeSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:7/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self billRuleSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:8/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self billItemSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:9/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self childTransactionSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:10/11.f animated:YES];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//        if ([self parentTransactionSyncWithServerSince:lastSyncTime]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [view.progressView setProgress:11/11.f animated:YES];
//                [view compltionSync];
//            });
//        }else{
//            [view failSync];
//            return;
//        }
//
//        user.syncTime=time;
//        [_childCtx save:&error];
//
////        if ([self accountTypeSyncWithServerSince:lastSyncTime]
////            &&[self accountsSyncWithServerSince:lastSyncTime]
////            &&[self categorySyncWithServerSince:lastSyncTime]
////            &&[self budgetTemplateSyncWithServerSince:lastSyncTime]
////            &&[self budgetItemSyncWithServerSince:lastSyncTime]
////            &&[self budgetTransferSyncWithServerSince:lastSyncTime]
////            &&[self payeeSyncWithServerSince:lastSyncTime]
////            &&[self billRuleSyncWithServerSince:lastSyncTime]
////            &&[self billItemSyncWithServerSince:lastSyncTime]
////            &&[self childTransactionSyncWithServerSince:lastSyncTime]
////            &&[self parentTransactionSyncWithServerSince:lastSyncTime])
////        {
////            user.syncTime=time;
////            [_childCtx save:&error];
////        }
//
//        NSLog(@"%@",user.syncTime);
//
//        appDelegate.isSyncing=NO;
//
//
//
//        if (ISPAD)
//        {
//            [appDelegate_iPad.mainViewController syncAnimationStop];
//        }
//        else
//        {
//            //            [appDelegate_iPhone.menuVC syncAnimationStop];
//        }
//
//
//        NSNotificationCenter *not=[NSNotificationCenter defaultCenter];
//        [not removeObserver:self];
//        //后台不间断同步
//        if ([PFUser currentUser])
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (ISPAD)
//                {
//                    [appDelegate_iPad.mainViewController  refleshUI];
//                }
//                else
//                {
//                    //                    [appDelegate_iPhone reflashUI];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
//                }
//                if (appDelegate.autoSyncOn)
//                {
//                    [self performSelector:@selector(dataSyncWithServer) withObject:self afterDelay:30];
//                }
//            });
//        }
//    }];
//
//}

-(void)dataSyncWithLogInServer
{
    NSDate *time=[NSDate date];
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    //同步过程中禁止开启另一个同步
    if (appDelegate.isSyncing==YES)
    {
        return;
    }
    
    
    _childCtx=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    if (ISPAD)
    {
        [appDelegate_iPad.mainViewController syncAnimationStart];
    }
    else
    {
        //        [appDelegate_iPhone.menuVC startAnimation];
    }
    
    
    //
    
    
    appDelegate.isSyncing=YES;
    
    _childCtx.persistentStoreCoordinator=appDelegate.persistentStoreCoordinator;
    [_childCtx performBlock:^{
        
        
        //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
        if ([PFUser currentUser]) {
            [query whereKey:@"User" equalTo:[PFUser currentUser]];
        }
        NSArray *array=[query findObjects];
        if (array.count)
        {
            PFObject *object=[array objectAtIndex:0];
            NSString *serverRestoreID=object[@"restoreUUID"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString *localRestoreID=[userDefaults objectForKey:@"restoreUUID"];
            if (serverRestoreID != nil &&![serverRestoreID isEqualToString:localRestoreID])
            {
                [self restoreDataRemove];
                NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
                NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
                requestUser.entity=descUser;
                
                NSError *error;
                
                NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
                
                User *user=[arrayUser objectAtIndex:0];
                user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
                [_childCtx save:&error];
                
                [userDefaults setObject:serverRestoreID forKey:@"restoreUUID"];
                [userDefaults synchronize];
            }
        }
        
        
        //获取上次同步时间
        NSDate *lastSyncTime;
        
        NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
        NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
        requestUser.entity=descUser;
        
        NSError *error;
        
        NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
        
        User *user=[arrayUser objectAtIndex:0];
        lastSyncTime=user.syncTime;
        
        if ([self accountTypeSyncWithServerSince:lastSyncTime]
            &&[self accountsSyncWithServerSince:lastSyncTime]
            &&[self categorySyncWithServerSince:lastSyncTime]
            &&[self budgetTemplateSyncWithServerSince:lastSyncTime]
            &&[self budgetItemSyncWithServerSince:lastSyncTime]
            &&[self budgetTransferSyncWithServerSince:lastSyncTime]
            &&[self payeeSyncWithServerSince:lastSyncTime]
            &&[self billRuleSyncWithServerSince:lastSyncTime]
            &&[self billItemSyncWithServerSince:lastSyncTime]
            &&[self childTransactionSyncWithServerSince:lastSyncTime]
            &&[self parentTransactionSyncWithServerSince:lastSyncTime])
        {
            user.syncTime=time;
            [_childCtx save:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logInPromptCompleted" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logInPromptFailed" object:nil];
            });
        }
        
        NSLog(@"%@",user.syncTime);
        
        appDelegate.isSyncing=NO;
        
        
        NSNotificationCenter *not=[NSNotificationCenter defaultCenter];
        [not removeObserver:self];
//        //后台不间断同步
        if ([PFUser currentUser])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];

                if (appDelegate.autoSyncOn)
                {
                    [self performSelector:@selector(dataSyncWithServer) withObject:self afterDelay:30];
                }
            });
        }
    }];
    
  
}

-(void)dataSyncWithServer
{
    NSDate *time=[NSDate date];
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];

    //同步过程中禁止开启另一个同步
    if (appDelegate.isSyncing==YES)
    {
        return;
    }
    
    
    _childCtx=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];

    if (ISPAD)
    {
        [appDelegate_iPad.mainViewController syncAnimationStart];
    }
    else
    {
//        [appDelegate_iPhone.menuVC startAnimation];
    }

    
    //

    
    appDelegate.isSyncing=YES;
    
    _childCtx.persistentStoreCoordinator=appDelegate.persistentStoreCoordinator;
    [_childCtx performBlock:^{
        
        
        //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        PFQuery *query=[PFQuery queryWithClassName:@"Setting"];
        if ([PFUser currentUser]) {
            [query whereKey:@"User" equalTo:[PFUser currentUser]];
        }
        NSArray *array=[query findObjects];
        if (array.count)
        {
            PFObject *object=[array objectAtIndex:0];
            NSString *serverRestoreID=object[@"restoreUUID"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString *localRestoreID=[userDefaults objectForKey:@"restoreUUID"];
            if (serverRestoreID != nil &&![serverRestoreID isEqualToString:localRestoreID])
            {
                [self restoreDataRemove];
                NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
                NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
                requestUser.entity=descUser;
                
                NSError *error;
                
                NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
                
                User *user=[arrayUser objectAtIndex:0];
                user.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
                [_childCtx save:&error];
                
                [userDefaults setObject:serverRestoreID forKey:@"restoreUUID"];
                [userDefaults synchronize];
            }
        }
        
        
        //获取上次同步时间
        NSDate *lastSyncTime;
        
        NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
        NSEntityDescription *descUser=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_childCtx];
        requestUser.entity=descUser;
        
        NSError *error;
        
        NSArray *arrayUser=[_childCtx executeFetchRequest:requestUser error:&error];
        
        User *user=[arrayUser objectAtIndex:0];
        lastSyncTime=user.syncTime;
        
        if ([self accountTypeSyncWithServerSince:lastSyncTime]
            &&[self accountsSyncWithServerSince:lastSyncTime]
            &&[self categorySyncWithServerSince:lastSyncTime]
            &&[self budgetTemplateSyncWithServerSince:lastSyncTime]
            &&[self budgetItemSyncWithServerSince:lastSyncTime]
            &&[self budgetTransferSyncWithServerSince:lastSyncTime]
            &&[self payeeSyncWithServerSince:lastSyncTime]
            &&[self billRuleSyncWithServerSince:lastSyncTime]
            &&[self billItemSyncWithServerSince:lastSyncTime]
            &&[self childTransactionSyncWithServerSince:lastSyncTime]
            &&[self parentTransactionSyncWithServerSince:lastSyncTime])
        {
            user.syncTime=time;
            [_childCtx save:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
            });
            
        }
        
        NSLog(@"%@",user.syncTime);
        
        appDelegate.isSyncing=NO;
        
       
        
        if (ISPAD)
        {
            [appDelegate_iPad.mainViewController syncAnimationStop];
        }
        else
        {
//            [appDelegate_iPhone.menuVC syncAnimationStop];
        }
        
        
        NSNotificationCenter *not=[NSNotificationCenter defaultCenter];
        [not removeObserver:self];
        //后台不间断同步
        if ([PFUser currentUser])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ISPAD)
                {
                    [appDelegate_iPad.mainViewController  refleshUI];
                }
                else
                {
//                    [appDelegate_iPhone reflashUI];
                }
                if (appDelegate.autoSyncOn)
                {
                    [self performSelector:@selector(dataSyncWithServer) withObject:self afterDelay:30];
                }
            });
        }
    }];
}
#pragma mark - 分种类进行的数据同步
-(BOOL)parentTransactionSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"parentT");
    NSError *error;
    
    //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServerFather=[NSPredicate predicateWithFormat:@"user=%@ and updatedTime>=%@ and parTransaction=%@",[PFUser currentUser],lastSyncTime,nil];
    PFQuery *queryFather=[PFQuery queryWithClassName:@"Transaction" predicate:predicateServerFather];
    NSArray *arrayServerFather=[self downloadEveryData:queryFather with:&error];

//    由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
    requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];
    
    for (PFObject *objectServer in arrayServerFather)
    {
        //取到当前数据模型的ID
        NSString *uuid=objectServer[@"uuid"];
        //根据ID找到对应的本地数据
        NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
        NSEntityDescription *descObject=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_childCtx];
        requestObject.entity=descObject;
        
        NSPredicate *predicateObjecte;
        if (objectServer[@"transactionstring"]!=nil)
        {
            predicateObjecte=[NSPredicate predicateWithFormat:@"transactionstring == %@",objectServer[@"transactionstring"]];
        }
        else
        {
            predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
        }
        
        requestObject.predicate=predicateObjecte;
        NSError *errorObject=nil;
        NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
        if (arrayObject.count)
        {
            //本地含有对应的数据
            
            //从数组中取到对应的本地数据
            Transaction *transcation=[arrayObject objectAtIndex:0];
            //数据状态
            BOOL isDelLocal=![transcation.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
            
            //数据更新时间
            NSDate *dateLocal=transcation.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //删除本地信息
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [_childCtx deleteObject:transcation];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                        
                    {
                        [self assignTransactionServer:objectServer WithLocal:transcation];
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:transcation];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
                else
                {
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [self assignTransactionLocal:transcation WithServer:objectServer];
                        transcation.state=@"1";
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignTransactionServer:objectServer  WithLocal:transcation];
                        objectServer[@"state"]=@"0";
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:transcation];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                //本地数据存在,处于非删除状态
                if (isDelServer)
                {
                    //服务器数据处于删除状态
                    
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [_childCtx deleteObject:transcation];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        //采用本地数据,将服务器数据状态更新,且置为非删除状态
                        [self assignTransactionServer:objectServer WithLocal:transcation];
                        objectServer[@"state"]=@"1";
                        [objectServer save:&error];
                    }
                }
                else
                {
                    //服务器数据未被删除
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [self assignTransactionLocal:transcation WithServer:objectServer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignTransactionServer:objectServer WithLocal:transcation];
                        [objectServer save:&error];
                    }
                }
            }
        }
        else
        {
            //本地不含有对应数据
            //判断该数据在服务器中是否属于删除状态
            if ([objectServer[@"state"] integerValue])
            {
                //在本地创建该数据
                Transaction *transaction=[NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:_childCtx];
                
                [self assignTransactionLocal:transaction WithServer:objectServer];
                NSError *errorSync;
                [_childCtx save:&errorSync];
            }
            else
            {
                //该数据被删除不做处理
            }
        }
    }
    //对本地数据进行分析
    for (Transaction *transaction in arrayLocal)
    {
        //取到当前本地数据模型对应的ID
        NSString *uuid=transaction.uuid;
        PFQuery *query=[PFQuery queryWithClassName:@"Transaction"];
        if (uuid!=nil)
        {
            [query whereKey:@"uuid" equalTo:uuid];
        }
        else
        {
            return NO;
        }
        if (transaction.transactionstring != nil)
        {
            [query whereKey:@"transactionstring" equalTo:transaction.transactionstring];
        }
        else if(transaction.uuid != nil)
        {
            [query whereKey:@"uuid" equalTo:uuid];
        }
        NSArray *objectsServer=[query findObjects:&error];
        if (objectsServer.count)
        {
            PFObject *objectServer=objectsServer[0];
            //数据状态
            BOOL isDelLocal=![transaction.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
            
            //获取同步时间
            NSDate *dateLocal=transaction.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //服务器及本地数据都处于删除状态
                    
                    //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                }
                else
                {
                    //将本地更新时间同服务器更新时间对比,处理
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [self assignTransactionLocal:transaction WithServer:objectServer];
                        transaction.state=@"1";
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignTransactionServer:objectServer WithLocal:transaction];
                        objectServer[@"state"]=@"0";
                        NSError *error;
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:transaction];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                if (isDelServer)
                {
                    //服务器在上次更新后发生了数据变化（被删除）
                    //对服务器数据和本地数据的比对 已经处理过，故不作处理
                    
                }
                else
                {
                    if (dateServerInterval>=dateLocalInterval)
                    {
                        [self assignTransactionLocal:transaction WithServer:objectServer];
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignTransactionServer:objectServer WithLocal:transaction];
                        [objectServer save:&error];
                    }
                }
            }
            
        }
        else
        {
            //服务器中不含有本地ID对应的数据
            
            //判断对应的本地数据是否为删除状态
            if (![transaction.state integerValue])
            {
                //本地数据已被删除
                //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                PFObject *objectServer=[PFObject objectWithClassName:@"Transaction"];
                [self assignTransactionServer:objectServer WithLocal:transaction];
                objectServer[@"state"]=@"0";
                [objectServer save:&error];
                if (!error)
                {
                    [_childCtx deleteObject:transaction];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
            }
            else
            {
                //本地数据处于非删除状态
                //在服务器创建该数据,且置为非删除状态
                PFObject *objectServer=[PFObject objectWithClassName:@"Transaction"];
                [self assignTransactionServer:objectServer WithLocal:transaction];
                if([PFUser currentUser])
                {
                    objectServer[@"user"]=[PFUser currentUser];
                }
                else
                {
                    return NO;
                }
                objectServer[@"state"]=@"1";
                [objectServer save:&error];
            }
        }
    }
    
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)childTransactionSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"childT");
    NSError *error;
    //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServerChild=[NSPredicate predicateWithFormat:@"user=%@ and updatedTime>=%@ and parTransaction!=%@",[PFUser currentUser],lastSyncTime,nil];
    PFQuery *queryChild=[PFQuery queryWithClassName:@"Transaction" predicate:predicateServerChild];
    NSArray *arrayServerChild=[self downloadEveryData:queryChild with:&error];
    
        for (PFObject *objectServer in arrayServerChild)
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte;
            if (objectServer[@"transactionstring"]!=nil)
            {
                predicateObjecte=[NSPredicate predicateWithFormat:@"transactionstring == %@",objectServer[@"transactionstring"]];
            }
            else
            {
                predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            }
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                Transaction *transcation=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![transcation.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=transcation.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:transcation];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignTransactionServer:objectServer WithLocal:transcation];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:transcation];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }

                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignTransactionLocal:transcation WithServer:objectServer];
                            transcation.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignTransactionServer:objectServer  WithLocal:transcation];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:transcation];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:transcation];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignTransactionServer:objectServer WithLocal:transcation];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignTransactionLocal:transcation WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignTransactionServer:objectServer WithLocal:transcation];
                            [objectServer save:&error];
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    Transaction *transaction=[NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:_childCtx];
                    
                    [self assignTransactionLocal:transaction WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
        //对本地数据进行分析
//        for (Transaction *transaction in arrayLocal)
//        {
//            //取到当前本地数据模型对应的ID
//            NSString *uuid=transaction.uuid;
//            PFQuery *query=[PFQuery queryWithClassName:@"Transaction"];
//            [query whereKey:@"uuid" equalTo:uuid];
//            NSError *errorDownload;
//            NSArray *objectsServer=[query findObjects:&errorDownload];
//            if (downloadError)
//            {
//                
//            }
//            if (objectsServer.count)
//            {
//                PFObject *objectServer=objectsServer[0];
//                //数据状态
//                BOOL isDelLocal=![transaction.state integerValue];
//                BOOL isDelServer=![objectServer[@"state"] integerValue];
//                
//                //获取同步时间
//                NSDate *dateLocal=transaction.updatedTime;
//                NSDate *dateServer=objectServer[@"updatedTime"];
//                if (isDelLocal)
//                {
//                    if (isDelServer)
//                    {
//                        //服务器及本地数据都处于删除状态
//                        
//                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
//                    }
//                    else
//                    {
//                        //将本地更新时间同服务器更新时间对比,处理
//                        if ([dateServer compare:dateLocal]>=0)
//                        {
//                            [self assignTransactionLocal:transaction WithServer:objectServer];
//                            transaction.state=@"1";
//                            
//                            NSError *errorSync;
//                            [_childCtx save:&errorSync];
//                        }
//                        else
//                        {
//                            [self assignTransactionServer:objectServer WithLocal:transaction];
//                            objectServer[@"state"]=@"0";
//                            [objectServer saveInBackgroundWithBlock:^(BOOL succeded,NSError *uploadError)
//                            {
//                                if (!uploadError)
//                                {
//                                    [_childCtx deleteObject:transaction];
//                                    NSError *errorSync;
//                                    [_childCtx save:&errorSync];
//                                }
//                                else
//                                {
//                                    
//                                }
//                            }];
//                        }
//                    }
//                }
//                else
//                {
//                    if (isDelServer)
//                    {
//                        //服务器在上次更新后发生了数据变化（被删除）
//                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
//                    }
//                    else
//                    {
//                        if ([dateServer compare:dateLocal]>=0)
//                        {
//                            [self assignTransactionLocal:transaction WithServer:objectServer];
//                            
//                            NSError *errorSync;
//                            [_childCtx save:&errorSync];
//                        }
//                        else
//                        {
//                            [self assignTransactionServer:objectServer WithLocal:transaction];
//                            [objectServer saveInBackgroundWithBlock:^(BOOL succeded,NSError *uploadError)
//                            {
//                            }];
//                        }
//                    }
//                }
//                
//            }
//            else
//            {
//                //服务器中不含有本地ID对应的数据
//                
//                //判断对应的本地数据是否为删除状态
//                if (![transaction.state integerValue])
//                {
//                    //本地数据已被删除
//                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
//                    PFObject *objectServer=[PFObject objectWithClassName:@"Transaction"];
//                    [self assignTransactionServer:objectServer WithLocal:transaction];
//                    objectServer[@"state"]=@"0";
//                    
//                    [objectServer saveInBackgroundWithBlock:^(BOOL succeded,NSError *uploadError)
//                    {
//                        if (!uploadError)
//                        {
//                            [_childCtx deleteObject:transaction];
//                            NSError *errorSync;
//                            [_childCtx save:&errorSync];
//                        }
//                        else
//                        {
//                            
//                        }
//                    }];
//                }
//                else
//                {
//                    //本地数据处于非删除状态
//                    //在服务器创建该数据,且置为非删除状态
//                    PFObject *objectServer=[PFObject objectWithClassName:@"Transaction"];
//                    [self assignTransactionServer:objectServer WithLocal:transaction];
//                    objectServer[@"user"]=[PFUser currentUser];
//                    objectServer[@"state"]=@"1";
//                    
//                    [objectServer saveInBackgroundWithBlock:^(BOOL succeded,NSError *uploadError)
//                    {
//                    }];
//                }
//            }
//        }
}
-(BOOL)accountTypeSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"accounttype");
    NSError *error;
    //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
    PFQuery *query=[PFQuery queryWithClassName:@"AccountType" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
    
    //由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
    requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

    for (PFObject *objectServer in arrayServer)
    {
        NSString *serverUUID=objectServer[@"uuid"];
        if ([serverUUID isEqualToString:@"F2243FC7-6E01-4CD8-8A03-6AE56E7B20E1"] ||
            [serverUUID isEqualToString:@"9832B8FA-537C-4963-8CA9-19385E9732E5"] ||
            [serverUUID isEqualToString:@"9C4251B9-5B57-4472-8B6E-BAF1A4D60650"] ||
            [serverUUID isEqualToString:@"4C9ACC13-D22D-4A7F-ABB3-7A5A7C94EAA2"] ||
            [serverUUID isEqualToString:@"A54BB0EF-17DF-4BA5-BB1E-A24AC31DA138"] ||
            [serverUUID isEqualToString:@"A8D6FFD2-602B-4E23-AA86-44751A2234C6"] ||
            [serverUUID isEqualToString:@"B10A95AC-6BA2-401A-9A67-AF667313872F"] ||
            [serverUUID isEqualToString:@"3E3BEB88-153A-4ACB-AE15-3B2B7935D56E"] ||
            [serverUUID isEqualToString:@"EB77B173-7BE4-458E-B1DD-0309EBF3A12C"])
        {
            
        }
        else
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"AccountType"inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                AccountType *accountType=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![accountType.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=accountType.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:accountType];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignAccountTypeServer:objectServer WithLocal:accountType];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:accountType];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            
                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignAccountTypeLocal:accountType WithServer:objectServer];
                            accountType.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignAccountTypeServer:objectServer WithLocal:accountType];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:accountType];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:accountType];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignAccountTypeServer:objectServer WithLocal:accountType];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                            if (!error)
                            {
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignAccountTypeLocal:accountType WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignAccountTypeServer:objectServer WithLocal:accountType];
                            [objectServer save:&error];
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    AccountType *accountType=[NSEntityDescription insertNewObjectForEntityForName:@"AccountType" inManagedObjectContext:_childCtx];
                    
                    [self assignAccountTypeLocal:accountType WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
    }
        
        //对本地数据进行分析
        for (AccountType *accountType in arrayLocal)
        {
            NSString *localUUID=accountType.uuid;
            if ([localUUID isEqualToString:@"F2243FC7-6E01-4CD8-8A03-6AE56E7B20E1"] ||
                [localUUID isEqualToString:@"9832B8FA-537C-4963-8CA9-19385E9732E5"] ||
                [localUUID isEqualToString:@"9C4251B9-5B57-4472-8B6E-BAF1A4D60650"] ||
                [localUUID isEqualToString:@"4C9ACC13-D22D-4A7F-ABB3-7A5A7C94EAA2"] ||
                [localUUID isEqualToString:@"A54BB0EF-17DF-4BA5-BB1E-A24AC31DA138"] ||
                [localUUID isEqualToString:@"A8D6FFD2-602B-4E23-AA86-44751A2234C6"] ||
                [localUUID isEqualToString:@"B10A95AC-6BA2-401A-9A67-AF667313872F"] ||
                [localUUID isEqualToString:@"3E3BEB88-153A-4ACB-AE15-3B2B7935D56E"] ||
                [localUUID isEqualToString:@"EB77B173-7BE4-458E-B1DD-0309EBF3A12C"])
            {
                
            }
            else
            {
                //取到当前本地数据模型对应的ID
                NSString *uuid=accountType.uuid;
                NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],uuid];
                PFQuery *query=[PFQuery queryWithClassName:@"AccountType" predicate:predicateServer];
                NSArray *objectsServer=[query findObjects:&error];
                if (objectsServer.count)
                {
                    PFObject *objectServer=objectsServer[0];
                    //数据状态
                    BOOL isDelLocal=![accountType.state integerValue];
                    BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                
                
                    //获取同步时间
                    NSDate *dateLocal=accountType.updatedTime;
                    NSDate *dateServer=objectServer[@"updatedTime"];
                
                    u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                    u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                
                    if (isDelLocal)
                    {
                        if (isDelServer)
                        {
                            //服务器及本地数据都处于删除状态
                            
                            //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                        }
                        else
                        {
                            //将本地更新时间同服务器更新时间对比,处理
                            if (dateServerInterval >= dateLocalInterval)
                            {
                                [self assignAccountTypeLocal:accountType WithServer:objectServer];
                                accountType.state=@"1";
                            
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            else
                            {
                                [self assignAccountTypeServer:objectServer WithLocal:accountType];
                                objectServer[@"state"]=@"0";
                                [objectServer save:&error];
                                if (!error)
                                {
                                    [_childCtx deleteObject:accountType];
                                    NSError *errorSync;
                                    [_childCtx save:&errorSync];
                                }
                            }
                        }
                    }
                    else
                    {
                        //本地未被删除
                    
                        if (isDelServer)
                        {
                            //服务器在上次更新后发生了数据变化（被删除）
                            //对服务器数据和本地数据的比对 已经处理过，故不作处理
                            
                        }
                        else
                        {
                            if (dateServerInterval >= dateLocalInterval)
                            {
                                [self assignAccountTypeLocal:accountType WithServer:objectServer];
                            
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            else
                            {
                                [self assignAccountTypeServer:objectServer WithLocal:accountType];
                                [objectServer save:&error];
                                if (!error)
                                {
                                    NSError *errorSync;
                                    [_childCtx save:&errorSync];
                                }
                            }
                        }
                    }
                
                }
                else
                {
                    //服务器中不含有本地ID对应的数据
                
                    //判断对应的本地数据是否为删除状态
                    if (![accountType.state integerValue])
                    {
                        //本地数据已被删除
                        //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                        PFObject *objectServer=[PFObject objectWithClassName:@"AccountType"];
                        [self assignAccountTypeServer:objectServer WithLocal:accountType];
                        objectServer[@"state"]=@"0";
                        if([PFUser currentUser])
                        {
                            objectServer[@"user"]=[PFUser currentUser];
                        }
                        else
                        {
                            return NO;
                        }
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:accountType];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                    else
                    {
                    
                        //本地数据处于非删除状态
                        //在服务器创建该数据,且置为非删除状态
                        PFObject *objectServer=[PFObject objectWithClassName:@"AccountType"];
                        [self assignAccountTypeServer:objectServer WithLocal:accountType];
                        if([PFUser currentUser])
                        {
                            objectServer[@"user"]=[PFUser currentUser];
                        }
                        else
                        {
                            return NO;
                        }
                        objectServer[@"state"]=@"1";
                        [objectServer save:&error];
                    }
                }
            }
        }
        


    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


-(BOOL)budgetTemplateSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"budgetTemplate");
    NSError *error;
        //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedTime>=%@",[PFUser currentUser],lastSyncTime];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetTemplate" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
        //由上次sync时间获取之后发生更改的本地数据
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:_childCtx];
        requestLocal.entity=descLocal;
        NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
        requestLocal.predicate=predicateLocal;
        NSError *errorLocal;
        NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

        for (PFObject *objectServer in arrayServer)
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                BudgetTemplate *budgetTemplate=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![budgetTemplate.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=budgetTemplate.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [_childCtx deleteObject:budgetTemplate];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetTemplate];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            
                        }
                    }
                    else
                    {
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [self assignBudgetTemplateLocal:budgetTemplate WithServer:objectServer];
                            budgetTemplate.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetTemplate];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [_childCtx deleteObject:budgetTemplate];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [self assignBudgetTemplateLocal:budgetTemplate WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            [objectServer save:&error];
                            if (!error)
                            {
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    BudgetTemplate *budgetTemplate=[NSEntityDescription insertNewObjectForEntityForName:@"BudgetTemplate" inManagedObjectContext:_childCtx];
                    
                    [self assignBudgetTemplateLocal:budgetTemplate WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        
        //对本地数据进行分析
        for (BudgetTemplate *budgetTemplate in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=budgetTemplate.uuid;
            PFQuery *query=[PFQuery queryWithClassName:@"BudgetTemplate"];
            if (uuid!=nil)
            {
                [query whereKey:@"uuid" equalTo:uuid];
            }
            else
            {
                return NO;
            }
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![budgetTemplate.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=budgetTemplate.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [self assignBudgetTemplateLocal:budgetTemplate WithServer:objectServer];
                            budgetTemplate.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetTemplate];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                        
                    }
                    else
                    {
                        if (dateServerInterval>=dateLocalInterval)
                        {
                            [self assignBudgetTemplateLocal:budgetTemplate WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![budgetTemplate.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"BudgetTemplate"];
                    [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:budgetTemplate];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"BudgetTemplate"];
                    [self assignBudgetTemplateServer:objectServer WithLocal:budgetTemplate];
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    objectServer[@"state"]=@"1";
                    
                    [objectServer save:&error];
            }
        }
        
      
            
        }
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)accountsSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"accounts");
    NSError *error;
    //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
    PFQuery *query=[PFQuery queryWithClassName:@"Accounts" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
    //由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
        requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

    
    for (PFObject *objectServer in arrayServer)
    {
        //取到当前数据模型的ID
        NSString *uuid=objectServer[@"uuid"];
        //根据ID找到对应的本地数据
        NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
        NSEntityDescription *descObject=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:_childCtx];
        requestObject.entity=descObject;
        NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
        requestObject.predicate=predicateObjecte;
        NSError *errorObject=nil;
        NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
        if (arrayObject.count)
        {
            //本地含有对应的数据
                
            //从数组中取到对应的本地数据
            Accounts *accounts=[arrayObject objectAtIndex:0];
            //数据状态
            BOOL isDelLocal=![accounts.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
                
            //数据更新时间
            NSDate *dateLocal=accounts.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //删除本地信息
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:accounts];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                            
                    {
                        [self assignAccountsServer:objectServer withLocal:accounts];
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:accounts];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                            
                    }
                }
                else
                {
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignAccountLocal:accounts WithServer:objectServer];
                        accounts.state=@"1";
                            
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignAccountsServer:objectServer withLocal:accounts];
                        objectServer[@"state"]=@"0";
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:accounts];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                //本地数据存在,处于非删除状态
                if (isDelServer)
                {
                    //服务器数据处于删除状态
                        
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:accounts];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        //采用本地数据,将服务器数据状态更新,且置为非删除状态
                        [self assignAccountsServer:objectServer withLocal:accounts];
                        objectServer[@"state"]=@"1";
                        [objectServer save:&error];
                    }
                }
                else
                {
                    //服务器数据未被删除
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignAccountLocal:accounts WithServer:objectServer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignAccountsServer:objectServer withLocal:accounts];
                        [objectServer save:&error];
                        if (!error)
                        {
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
        }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    Accounts *accounts=[NSEntityDescription insertNewObjectForEntityForName:@"Accounts" inManagedObjectContext:_childCtx];
                    
                    [self assignAccountLocal:accounts WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        //对本地数据进行分析
        for (Accounts *accounts in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=accounts.uuid;
            NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],uuid];
            PFQuery *query=[PFQuery queryWithClassName:@"Accounts" predicate:predicateServer];
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![accounts.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=accounts.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignAccountLocal:accounts WithServer:objectServer];
                            accounts.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignAccountsServer:objectServer withLocal:accounts];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:accounts];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                    
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignAccountLocal:accounts WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignAccountsServer:objectServer withLocal:accounts];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![accounts.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"Accounts"];
                    [self assignAccountsServer:objectServer withLocal:accounts];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (&error)
                    {
                        [_childCtx deleteObject:accounts];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"Accounts"];
                    [self assignAccountsServer:objectServer withLocal:accounts];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)categorySyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"category");
    NSError *error;
        //由上次同步时间获取之后的云端数据
        NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@ and isSystemRecord!=%d",[PFUser currentUser],lastSyncTime,1];
        PFQuery *query=[PFQuery queryWithClassName:@"Category" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
        //由上次sync时间获取之后发生更改的本地数据
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
        requestLocal.entity=descLocal;
        NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@ and isSystemRecord!=%d",lastSyncTime,1];
        requestLocal.predicate=predicateLocal;
        NSError *errorLocal;
        NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];
    

    
        for (PFObject *objectServer in arrayServer)
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                Category *category=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![category.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=category.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:category];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignCategoryServer:objectServer WithLocal:category];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:category];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            
                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignCategoryLocal:category WithServer:objectServer];
                            category.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignCategoryServer:objectServer WithLocal:category];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:category];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:category];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignCategoryServer:objectServer WithLocal:category];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignCategoryLocal:category WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignCategoryServer:objectServer WithLocal:category];
                            [objectServer save:&error];
                            if (!error)
                            {
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    Category *category=[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:_childCtx];
                    
                    [self assignCategoryLocal:category WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        
        //对本地数据进行分析
        for (Category *category in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=category.uuid;
            NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and uuid=%@",[PFUser currentUser],uuid];
            PFQuery *query=[PFQuery queryWithClassName:@"Category" predicate:predicateServer];
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                //云端存在该数据
                
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![category.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=category.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignCategoryLocal:category WithServer:objectServer];
                            category.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignCategoryServer:objectServer WithLocal:category];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:category];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                        
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignCategoryLocal:category WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignCategoryLocal:category WithServer:objectServer];
                            [objectServer save:&error];
                            if (!error)
                            {
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![category.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"Category"];
                    [self assignCategoryServer:objectServer WithLocal:category];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:category];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"Category"];
                    [self assignCategoryServer:objectServer WithLocal:category];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
 
}
-(BOOL)payeeSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"payee");
    NSError *error;
        //由上次同步时间获取之后的云端数据
        NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
        PFQuery *query=[PFQuery queryWithClassName:@"Payee" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
        //由上次sync时间获取之后发生更改的本地数据
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:_childCtx];
        requestLocal.entity=descLocal;
        NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
        requestLocal.predicate=predicateLocal;
        NSError *errorLocal;
        NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

        for (PFObject *objectServer in arrayServer)
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                Payee *payee=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![payee.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=payee.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:payee];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignPayeeServer:objectServer WithLocal:payee];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:payee];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignPayeeLocal:payee WithServer:objectServer];
                            payee.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignPayeeServer:objectServer WithLocal:payee];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:payee];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:payee];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignPayeeServer:objectServer WithLocal:payee];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignPayeeLocal:payee WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignPayeeServer:objectServer WithLocal:payee];
                            [objectServer save:&error];
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    Payee *payee=[NSEntityDescription insertNewObjectForEntityForName:@"Payee" inManagedObjectContext:_childCtx];
                    
                    [self assignPayeeLocal:payee WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        
        //对本地数据进行分析
        for (Payee *payee in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=payee.uuid;
            PFQuery *query=[PFQuery queryWithClassName:@"Payee"];
            if (uuid!=nil)
            {
                [query whereKey:@"uuid" equalTo:uuid];
            }
            else
            {
                return NO;
            }
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![payee.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=payee.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignPayeeLocal:payee WithServer:objectServer];
                            payee.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignPayeeServer:objectServer WithLocal:payee];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:payee];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                       
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignPayeeLocal:payee WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignPayeeLocal:payee WithServer:objectServer];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![payee.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"Payee"];
                    [self assignPayeeServer:objectServer WithLocal:payee];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:payee];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"Payee"];
                    [self assignPayeeServer:objectServer WithLocal:payee];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)billRuleSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"billrule");
    NSError *error;
        //由上次同步时间获取之后的云端数据
        NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
        PFQuery *query=[PFQuery queryWithClassName:@"EP_BillRule" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];

    //由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
    requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

    for (PFObject *objectServer in arrayServer)
    {
        //取到当前数据模型的ID
        NSString *uuid=objectServer[@"uuid"];
        //根据ID找到对应的本地数据
        NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
        NSEntityDescription *descObject=[NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:_childCtx];
        requestObject.entity=descObject;
        NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
        requestObject.predicate=predicateObjecte;
        NSError *errorObject=nil;
        NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
        if (arrayObject.count)
        {
            //本地含有对应的数据
                
            //从数组中取到对应的本地数据
            EP_BillRule *billRule=[arrayObject objectAtIndex:0];
            //数据状态
            BOOL isDelLocal=![billRule.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
                
            //数据更新时间
            NSDate *dateLocal=billRule.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //删除本地信息
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:billRule];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                        
                    {
                        [self assignBillRuleServer:objectServer WithLocal:billRule];
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:billRule];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                            
                    }
                }
                else
                {
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBillRuleLocal:billRule WithServer:objectServer];
                        billRule.state=@"1";
                            
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBillRuleServer:objectServer WithLocal:billRule];
                        objectServer[@"state"]=@"0";
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:billRule];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                //本地数据存在,处于非删除状态
                if (isDelServer)
                {
                    //服务器数据处于删除状态
                        
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:billRule];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        //采用本地数据,将服务器数据状态更新,且置为非删除状态
                        [self assignBillRuleServer:objectServer WithLocal:billRule];
                        objectServer[@"state"]=@"1";
                        [objectServer save:&error];
                    }
                }
                else
                {
                    //服务器数据未被删除
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBillRuleLocal:billRule WithServer:objectServer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBillRuleServer:objectServer WithLocal:billRule];
                        [objectServer save:&error];
                    }
                }
            }
        }
        else
        {
            //本地不含有对应数据
            //判断该数据在服务器中是否属于删除状态
            if ([objectServer[@"state"] integerValue])
            {
                //在本地创建该数据
                EP_BillRule *billRule=[NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:_childCtx];
                    
                [self assignBillRuleLocal:billRule WithServer:objectServer];
                NSError *errorSync;
                [_childCtx save:&errorSync];
            }
            else
            {
                //该数据被删除不做处理
            }
        }
    }
        
        //对本地数据进行分析
        for (EP_BillRule *billRule in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=billRule.uuid;
            PFQuery *query=[PFQuery queryWithClassName:@"EP_BillRule"];
            if (uuid!=nil)
            {
                [query whereKey:@"uuid" equalTo:uuid];
            }
            else
            {
                return NO;
            }
            NSError *error;
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![billRule.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=billRule.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillRuleLocal:billRule WithServer:objectServer];
                            billRule.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillRuleServer:objectServer WithLocal:billRule];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:billRule];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                        
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillRuleLocal:billRule WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillRuleLocal:billRule WithServer:objectServer];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![billRule.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"EP_BillRule"];
                    [self assignBillRuleServer:objectServer WithLocal:billRule];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:billRule];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"EP_BillRule"];
                    [self assignBillRuleServer:objectServer WithLocal:billRule];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)billItemSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"billitem");

    NSError *error;
        //由上次同步时间获取之后的云端数据
        NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedTime>=%@",[PFUser currentUser],lastSyncTime];
        PFQuery *query=[PFQuery queryWithClassName:@"EP_BillItem" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
        //由上次sync时间获取之后发生更改的本地数据
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:_childCtx];
        requestLocal.entity=descLocal;
        NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
        requestLocal.predicate=predicateLocal;
        NSError *errorLocal;
        NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

        for (PFObject *objectServer in arrayServer)
        {
            //取到当前数据模型的ID
            NSString *uuid=objectServer[@"uuid"];
            //根据ID找到对应的本地数据
            NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
            NSEntityDescription *descObject=[NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:_childCtx];
            requestObject.entity=descObject;
            NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
            requestObject.predicate=predicateObjecte;
            NSError *errorObject=nil;
            NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
            if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                EP_BillItem *billItem=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![billItem.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=billItem.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:billItem];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignBillItemServer:objectServer WithLocal:billItem];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:billItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillItemLocal:billItem WithServer:objectServer];
                            billItem.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillItemServer:objectServer WithLocal:billItem];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:billItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:billItem];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignBillItemServer:objectServer WithLocal:billItem];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillItemLocal:billItem WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillItemServer:objectServer WithLocal:billItem];
                            [objectServer save:&error];
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    EP_BillItem *billItem=[NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:_childCtx];
                    
                    [self assignBillItemLocal:billItem WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        
        //对本地数据进行分析
        for (EP_BillItem *billItem in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=billItem.uuid;
            PFQuery *query=[PFQuery queryWithClassName:@"EP_BillItem"];
            if (uuid!=nil)
            {
                [query whereKey:@"uuid" equalTo:uuid];
            }
            else
            {
                return NO;
            }
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![billItem.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=billItem.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                        
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillItemLocal:billItem WithServer:objectServer];
                            billItem.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillItemServer:objectServer WithLocal:billItem];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:billItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                        
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBillItemLocal:billItem WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBillItemLocal:billItem WithServer:objectServer];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![billItem.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"EP_BillItem"];
                    [self assignBillItemServer:objectServer WithLocal:billItem];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:billItem];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"EP_BillItem"];
                    [self assignBillItemServer:objectServer WithLocal:billItem];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (error)
    {
        return NO;
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)budgetItemSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"budgetItem");
    NSError *error;
        //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetItem" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
    //由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
    requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];
    

    for (PFObject *objectServer in arrayServer)
    {
        //取到当前数据模型的ID
        NSString *uuid=objectServer[@"uuid"];
        //根据ID找到对应的本地数据
        NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
        NSEntityDescription *descObject=[NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:_childCtx];
        requestObject.entity=descObject;
        NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
        requestObject.predicate=predicateObjecte;
        NSError *errorObject=nil;
        NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
        if (arrayObject.count)
            {
                //本地含有对应的数据
                
                //从数组中取到对应的本地数据
                BudgetItem *budgetItem=[arrayObject objectAtIndex:0];
                //数据状态
                BOOL isDelLocal=![budgetItem.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //数据更新时间
                NSDate *dateLocal=budgetItem.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //删除本地信息
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:budgetItem];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                            
                        {
                            [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                            
                        }
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                            budgetItem.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    //本地数据存在,处于非删除状态
                    if (isDelServer)
                    {
                        //服务器数据处于删除状态
                        
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [_childCtx deleteObject:budgetItem];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            //采用本地数据,将服务器数据状态更新,且置为非删除状态
                            [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                            objectServer[@"state"]=@"1";
                            [objectServer save:&error];
                        }
                    }
                    else
                    {
                        //服务器数据未被删除
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                            [objectServer save:&error];
                        }
                    }
                }
            }
            else
            {
                //本地不含有对应数据
                //判断该数据在服务器中是否属于删除状态
                if ([objectServer[@"state"] integerValue])
                {
                    //在本地创建该数据
                    BudgetItem *budgetItem=[NSEntityDescription insertNewObjectForEntityForName:@"BudgetItem" inManagedObjectContext:_childCtx];
                    
                    [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
                else
                {
                    //该数据被删除不做处理
                }
            }
        }
        
        //对本地数据进行分析
        for (BudgetItem *budgetItem in arrayLocal)
        {
            //取到当前本地数据模型对应的ID
            NSString *uuid=budgetItem.uuid;
            PFQuery *query=[PFQuery queryWithClassName:@"BudgetItem"];
            if (uuid!=nil)
            {
                [query whereKey:@"uuid" equalTo:uuid];
            }
            else
            {
                return NO;
            }
            NSArray *objectsServer=[query findObjects:&error];
            if (objectsServer.count)
            {
                PFObject *objectServer=objectsServer[0];
                //数据状态
                BOOL isDelLocal=![budgetItem.state integerValue];
                BOOL isDelServer=![objectServer[@"state"] integerValue];
                
                //获取同步时间
                NSDate *dateLocal=budgetItem.updatedTime;
                NSDate *dateServer=objectServer[@"updatedTime"];
                u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
                u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
                if (isDelLocal)
                {
                    if (isDelServer)
                    {
                        //服务器及本地数据都处于删除状态
                        
                        //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                    }
                    else
                    {
                        //将本地更新时间同服务器更新时间对比,处理
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                            budgetItem.state=@"1";
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                            objectServer[@"state"]=@"0";
                            [objectServer save:&error];
                            if (!error)
                            {
                                [_childCtx deleteObject:budgetItem];
                                NSError *errorSync;
                                [_childCtx save:&errorSync];
                            }
                        }
                    }
                }
                else
                {
                    if (isDelServer)
                    {
                        //服务器在上次更新后发生了数据变化（被删除）
                        //对服务器数据和本地数据的比对 已经处理过，故不作处理
                        
                    }
                    else
                    {
                        if (dateServerInterval >= dateLocalInterval)
                        {
                            [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                            
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        else
                        {
                            [self assignBudgetItemLocal:budgetItem WithServer:objectServer];
                            [objectServer save:&error];
                        }
                    }
                }
                
            }
            else
            {
                //服务器中不含有本地ID对应的数据
                
                //判断对应的本地数据是否为删除状态
                if (![budgetItem.state integerValue])
                {
                    //本地数据已被删除
                    //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                    PFObject *objectServer=[PFObject objectWithClassName:@"BudgetItem"];
                    [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                    objectServer[@"state"]=@"0";
                    [objectServer save:&error];
                    if (!error)
                    {
                        [_childCtx deleteObject:budgetItem];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                }
                else
                {
                    //本地数据处于非删除状态
                    //在服务器创建该数据,且置为非删除状态
                    PFObject *objectServer=[PFObject objectWithClassName:@"BudgetItem"];
                    [self assignBudgetItemServer:objectServer WithLocal:budgetItem];
                    objectServer[@"state"]=@"1";
                    if([PFUser currentUser])
                    {
                        objectServer[@"user"]=[PFUser currentUser];
                    }
                    else
                    {
                        return NO;
                    }
                    [objectServer save:&error];
                }
            }
        }
        
        //判定同步是否成功
        //
    if (!error)
    {
        return YES;
        
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return NO;
    }
}
-(BOOL)budgetTransferSyncWithServerSince:(NSDate *)lastSyncTime
{
    NSLog(@"budgetTransfer");
    NSError *error;
    //由上次同步时间获取之后的云端数据
    NSPredicate *predicateServer=[NSPredicate predicateWithFormat:@"user=%@ and updatedAt>=%@",[PFUser currentUser],lastSyncTime];
    PFQuery *query=[PFQuery queryWithClassName:@"BudgetTransfer" predicate:predicateServer];
    NSArray *arrayServer=[self downloadEveryData:query with:&error];
    
    //由上次sync时间获取之后发生更改的本地数据
    NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
    NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"BudgetTransfer" inManagedObjectContext:_childCtx];
    requestLocal.entity=descLocal;
    NSPredicate *predicateLocal=[NSPredicate predicateWithFormat:@"updatedTime>=%@",lastSyncTime];
    requestLocal.predicate=predicateLocal;
    NSError *errorLocal;
    NSArray *arrayLocal=[_childCtx executeFetchRequest:requestLocal error:&errorLocal];

    for (PFObject *objectServer in arrayServer)
    {
        //取到当前数据模型的ID
        NSString *uuid=objectServer[@"uuid"];
        //根据ID找到对应的本地数据
        NSFetchRequest *requestObject=[[NSFetchRequest alloc]init];
        NSEntityDescription *descObject=[NSEntityDescription entityForName:@"BudgetTransfer" inManagedObjectContext:_childCtx];
        requestObject.entity=descObject;
        NSPredicate *predicateObjecte=[NSPredicate predicateWithFormat:@"uuid == %@",uuid];
        requestObject.predicate=predicateObjecte;
        NSError *errorObject=nil;
        NSArray *arrayObject=[_childCtx executeFetchRequest:requestObject error:&errorObject];
        if (arrayObject.count)
        {
            //本地含有对应的数据
            
            //从数组中取到对应的本地数据
            BudgetTransfer *budgetTransfer=[arrayObject objectAtIndex:0];
            //数据状态
            BOOL isDelLocal=![budgetTransfer.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
            
            //数据更新时间
            NSDate *dateLocal=budgetTransfer.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //删除本地信息
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:budgetTransfer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                        
                    {
                        [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:budgetTransfer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                        
                    }
                }
                else
                {
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                        budgetTransfer.state=@"1";
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                        objectServer[@"state"]=@"0";
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:budgetTransfer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                //本地数据存在,处于非删除状态
                if (isDelServer)
                {
                    //服务器数据处于删除状态
                    
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [_childCtx deleteObject:budgetTransfer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        //采用本地数据,将服务器数据状态更新,且置为非删除状态
                        [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                        objectServer[@"state"]=@"1";
                        [objectServer save:&error];
                    }
                }
                else
                {
                    //服务器数据未被删除
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                        [objectServer save:&error];
                    }
                }
            }
        }
        else
        {
            //本地不含有对应数据
            //判断该数据在服务器中是否属于删除状态
            if ([objectServer[@"state"] integerValue])
            {
                //在本地创建该数据
                BudgetTransfer *budgetTransfer=[NSEntityDescription insertNewObjectForEntityForName:@"BudgetTransfer" inManagedObjectContext:_childCtx];
                
                [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                NSError *errorSync;
                [_childCtx save:&errorSync];
            }
            else
            {
                //该数据被删除不做处理
            }
        }
    }
    
    //对本地数据进行分析
    for (BudgetTransfer *budgetTransfer in arrayLocal)
    {
        //取到当前本地数据模型对应的ID
        NSString *uuid=budgetTransfer.uuid;
        PFQuery *query=[PFQuery queryWithClassName:@"BudgetTransfer"];
        if (uuid!=nil)
        {
            [query whereKey:@"uuid" equalTo:uuid];
        }
        else
        {
            return NO;
        }
        NSArray *objectsServer=[query findObjects:&error];
        if (objectsServer.count)
        {
            PFObject *objectServer=objectsServer[0];
            //数据状态
            BOOL isDelLocal=![budgetTransfer.state integerValue];
            BOOL isDelServer=![objectServer[@"state"] integerValue];
            
            //获取同步时间
            NSDate *dateLocal=budgetTransfer.updatedTime;
            NSDate *dateServer=objectServer[@"updatedTime"];
            u_int64_t dateServerInterval=[dateServer timeIntervalSince1970];
            u_int64_t dateLocalInterval=[dateLocal timeIntervalSince1970];
            if (isDelLocal)
            {
                if (isDelServer)
                {
                    //服务器及本地数据都处于删除状态
                    
                    //服务器数据在设备离线后,也被删除,该操作在处理数据时已经被处理过,因而不做处理
                }
                else
                {
                    //将本地更新时间同服务器更新时间对比,处理
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                        budgetTransfer.state=@"1";
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                        objectServer[@"state"]=@"0";
                        [objectServer save:&error];
                        if (!error)
                        {
                            [_childCtx deleteObject:budgetTransfer];
                            NSError *errorSync;
                            [_childCtx save:&errorSync];
                        }
                    }
                }
            }
            else
            {
                if (isDelServer)
                {
                    //服务器在上次更新后发生了数据变化（被删除）
                    //对服务器数据和本地数据的比对 已经处理过，故不作处理
                    
                }
                else
                {
                    if (dateServerInterval >= dateLocalInterval)
                    {
                        [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                        
                        NSError *errorSync;
                        [_childCtx save:&errorSync];
                    }
                    else
                    {
                        [self assignBudgetTransfer:budgetTransfer WithServer:objectServer];
                        [objectServer save:&error];
                    }
                }
            }
            
        }
        else
        {
            //服务器中不含有本地ID对应的数据
            
            //判断对应的本地数据是否为删除状态
            if (![budgetTransfer.state integerValue])
            {
                //本地数据已被删除
                //在服务器创建该数据,将该数据置为删除状态.删除本地数据
                PFObject *objectServer=[PFObject objectWithClassName:@"BudgetItem"];
                [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                objectServer[@"state"]=@"0";
                [objectServer save:&error];
                if (!error)
                {
                    [_childCtx deleteObject:budgetTransfer];
                    NSError *errorSync;
                    [_childCtx save:&errorSync];
                }
            }
            else
            {
                //本地数据处于非删除状态
                //在服务器创建该数据,且置为非删除状态
                PFObject *objectServer=[PFObject objectWithClassName:@"BudgetItem"];
                [self assignBudgetTransferServer:objectServer WithLocal:budgetTransfer];
                objectServer[@"state"]=@"1";
                if([PFUser currentUser])
                {
                    objectServer[@"user"]=[PFUser currentUser];
                }
                else
                {
                    return NO;
                }
                [objectServer save:&error];
            }
        }
    }
    
    //判定同步是否成功
    //
    if (!error)
    {
        return YES;
        
    }
    else if (![PFUser currentUser])
    {
        return NO;
    }
    else
    {
        return NO;
    }
}

#pragma mark 多线程操作coredata方法
-(void)mocDidSaveNotification:(NSNotification *)notification
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *saveCtx=[notification object];
    if (saveCtx==appDelegate.managedObjectContext) {
        return;
    }
    if (appDelegate.managedObjectContext.persistentStoreCoordinator!=saveCtx.persistentStoreCoordinator) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });    
}

#pragma mark - local to server


-(void)assignTransactionServer:(PFObject *)objectServer WithLocal:(Transaction *)transcation
{
    if(transcation.amount!=nil)
    {
        objectServer[@"amount"]=transcation.amount;
    }
    if (transcation.dateTime!=nil)
    {
        objectServer[@"dateTime"]=transcation.dateTime;
    }
    if (transcation.dateTime_sync!=nil)
    {
        objectServer[@"dateTime_sync"]=transcation.dateTime_sync;
    }
    if (transcation.groupByDate!=nil)
    {
        objectServer[@"groupByDate"]=transcation.groupByDate;
    }
    if (transcation.isClear != nil)
    {
        objectServer[@"isClear"]=transcation.isClear;
    }

    if (transcation.notes!=nil)
    {
        objectServer[@"notes"]=transcation.notes;
    }else{
        [objectServer removeObjectForKey:@"notes"];
    }
    if (transcation.orderIndex!=nil)
    {
        objectServer[@"orderIndex"]=transcation.orderIndex;
    }
    if (transcation.others!=nil)
    {
        objectServer[@"others"]=transcation.others;
    }
    if (transcation.recurringType!=nil)
    {
        objectServer[@"recurringType"]=transcation.recurringType;
    }else{
        [objectServer removeObjectForKey:@"recurringType"];
    }
    if (transcation.state!=nil)
    {
        objectServer[@"state"]=transcation.state;
    }
    if (transcation.transactionBool!=nil)
    {
        objectServer[@"transactionBool"]=transcation.transactionBool;
    }
    if (transcation.transactionType!=nil)
    {
        objectServer[@"transactionType"]=transcation.transactionType;
    }
    if (transcation.transactionstring!=nil)
    {
        objectServer[@"transactionstring"]=transcation.transactionstring;
    }
    if (transcation.type!=nil)
    {
        objectServer[@"type"]=transcation.type;
    }
    if (transcation.uuid!=nil)
    {
        objectServer[@"uuid"]=transcation.uuid;
    }
    if (transcation.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=transcation.updatedTime;
    }

    //relations
    
    if (transcation.payee!=nil)
    {
        objectServer[@"payee"]=transcation.payee.uuid;
    }else{
        [objectServer removeObjectForKey:@"payee"];
    }

    if (transcation.category!=nil)
    {
        objectServer[@"category"]=transcation.category.uuid;
    }else{
        [objectServer removeObjectForKey:@"category"];
    }
    
    if (transcation.expenseAccount!=nil)
    {
        objectServer[@"expenseAccount"]=transcation.expenseAccount.uuid;
    }else{
        [objectServer removeObjectForKey:@"expenseAccount"];
    }
    if (transcation.incomeAccount!=nil)
    {
        objectServer[@"incomeAccount"]=transcation.incomeAccount.uuid;
    }else{
        [objectServer removeObjectForKey:@"incomeAccount"];
    }
    if (transcation.transactionHasBillItem!=nil)
    {
        objectServer[@"transactionHasBillItem"]=transcation.transactionHasBillItem.uuid;
    }else{
        [objectServer removeObjectForKey:@"transactionHasBillItem"];
    }
    if (transcation.transactionHasBillRule!=nil)
    {
        objectServer[@"transactionHasBillRule"]=transcation.transactionHasBillRule.uuid;
    }else{
        [objectServer removeObjectForKey:@"transactionHasBillRule"];
    }

    if(transcation.photoName!=nil)
    {
        objectServer[@"photoName"]=transcation.photoName;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
        NSString *documentsPath = [paths objectAtIndex:0];
        objectServer[@"photoName"]=transcation.photoName;
        NSData *photoData=[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", documentsPath, transcation.photoName]];
        if (photoData!=nil)
        {
            PFFile *photo=[PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",transcation.photoName] data:photoData];
            objectServer[@"photoData"]=photo;
        }
        else
        {
            
        }

    }else{
        [objectServer removeObjectForKey:@"photoName"];

    }
    
    //childTransaction的处理
    if (transcation.parTransaction!=nil)
    {
        objectServer[@"parTransaction"]=transcation.parTransaction.uuid;
    }else{
        [objectServer removeObjectForKey:@"parTransaction"];
    }

}


-(void)assignPayeeServer:(PFObject *)objectServer WithLocal:(Payee *)payee
{
    if (payee.dateTime!=nil)
    {
        objectServer[@"dateTime"]=payee.dateTime;
    }
    if (payee.memo!=nil)
    {
        objectServer[@"memo"]=payee.memo;
    }else{
        [objectServer removeObjectForKey:@"memo"];
    }
    if (payee.name!=nil)
    {
        objectServer[@"name"]=payee.name;
    }else{
        [objectServer removeObjectForKey:@"name"];
    }
    if (payee.orderIndex!=nil)
    {
        objectServer[@"orderIndex"]=payee.orderIndex;
    }
    if (payee.others!=nil)
    {
        objectServer[@"others"]=payee.others;
    }else{
        [objectServer removeObjectForKey:@"others"];
    }
    if (payee.phone!=nil)
    {
        objectServer[@"phone"]=payee.phone;
    }else{
        [objectServer removeObjectForKey:@"phone"];
    }
    if (payee.tranAmount!=nil)
    {
        objectServer[@"tranAmonut"]=payee.tranAmount;
    }
    if (payee.tranCleared!=nil)
    {
        objectServer[@"tranCleared"]=payee.tranCleared;
    }
    if (payee.tranMemo!=nil)
    {
        objectServer[@"tranMemo"]=payee.tranMemo;
    }
    if (payee.tranType!=nil)
    {
        objectServer[@"tranType"]=payee.tranType;
    }
    if (payee.uuid!=nil)
    {
        objectServer[@"uuid"]=payee.uuid;
    }
    if (payee.website!=nil)
    {
        objectServer[@"website"]=payee.website;
    }
    if (payee.state!=nil)
    {
        objectServer[@"state"]=payee.state;
    }
    if (payee.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=payee.updatedTime;
    }
    //
    if (payee.category!=nil)
    {
        objectServer[@"category"]=payee.category.uuid;
    }else{
        [objectServer removeObjectForKey:@"category"];
    }

}
-(void)assignAccountsServer:(PFObject *)objectServer withLocal:(Accounts *)account
{
    if (account.accName!=nil)
    {
        objectServer[@"accName"]=account.accName;
    }else{
        [objectServer removeObjectForKey:@"accName"];
    }
    if (account.amount!=nil)
    {
        objectServer[@"amount"]=account.amount;
    }
    if (account.autoClear!=nil)
    {
        objectServer[@"autoClear"]=account.autoClear;
    }
    if (account.checkNumber!=nil)
    {
        objectServer[@"checkNumber"]=account.checkNumber;
    }
    if (account.creditLimit!=nil)
    {
        objectServer[@"creditLimit"]=account.creditLimit;
    }
    if (account.dateTime!=nil)
    {
        objectServer[@"dateTime"]=account.dateTime;
    }
    if (account.dateTime_sync!=nil)
    {
        objectServer[@"dateTime_sync"]=account.dateTime_sync;
    }
    if (account.dueDate!=nil)
    {
        objectServer[@"dueDate"]=account.dueDate;
    }else{
        [objectServer removeObjectForKey:@"dueDate"];
    }
    if (account.iconName!=nil)
    {
        objectServer[@"iconName"]=account.iconName;
    }
    if (account.orderIndex!=nil)
    {
        objectServer[@"orderIndex"]=account.orderIndex;
    }
    if (account.others!=nil)
    {
        objectServer[@"others"]=account.others;
    }else{
        [objectServer removeObjectForKey:@"others"];
    }
    if (account.reconcile!=nil)
    {
        objectServer[@"reconcile"]=account.reconcile;
    }
    if (account.runningBalance!=nil)
    {
        objectServer[@"runningBalance"]=account.runningBalance;
    }
    if (account.state!=nil)
    {
        objectServer[@"state"]=account.state;
    }
    if (account.uuid!=nil)
    {
        objectServer[@"uuid"]=account.uuid;
    }

    if (account.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=account.updatedTime;
    }
    if (account.accountColor!=nil)
    {
        objectServer[@"accountColor"]=account.accountColor;
    }else{
        [objectServer removeObjectForKey:@"accountColor"];
    }
    //relation
    if (account.accountType!=nil)
    {
        objectServer[@"accountType"]=account.accountType.uuid;
    }else{
        [objectServer removeObjectForKey:@"accountType"];
    }
    
}
-(void)assignAccountTypeServer:(PFObject *)objectServer WithLocal:(AccountType *)accountType
{
    if (accountType.dateTime!=nil)
    {
        objectServer[@"dateTime"]=accountType.dateTime;
    }
    if (accountType.iconName!=nil)
    {
        objectServer[@"iconName"]=accountType.iconName;
    }
    if (accountType.isDefault!=nil)
    {
        objectServer[@"isDefault"]=accountType.isDefault;
    }else{
        [objectServer removeObjectForKey:@"isDefault"];
    }

    if (accountType.ordexIndex!=nil)
    {
        objectServer[@"orderIndex"]=accountType.ordexIndex;
    }
    if (accountType.others!=nil)
    {
        objectServer[@"others"]=accountType.others;
    }else{
        [objectServer removeObjectForKey:@"others"];
    }
    if (accountType.state!=nil)
    {
        objectServer[@"state"]=accountType.state;
    }
    if (accountType.typeName!=nil)
    {
        objectServer[@"typeName"]=accountType.typeName;
    }
    if (accountType.uuid!=nil)
    {
        objectServer[@"uuid"]=accountType.uuid;
    }
    if (accountType.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=accountType.updatedTime;
    }
}
-(void)assignCategoryServer:(PFObject *)objectServer WithLocal:(Category *)category
{
    if (category.categoryisExpense!=nil)
    {
        objectServer[@"categoryisExpense"]=category.categoryisExpense;
    }
    if (category.categoryisIncome!=nil)
    {
        objectServer[@"categoryisIncome"]=category.categoryisIncome;
    }
    if (category.categoryName!=nil)
    {
        objectServer[@"categoryName"]=category.categoryName;
    }else{
        [objectServer removeObjectForKey:@"categoryName"];
    }
    if (category.categoryString!=nil)
    {
        objectServer[@"categoryString"]=category.categoryString;
    }
    if (category.categoryType!=nil)
    {
        objectServer[@"categoryType"]=category.categoryType;
    }
    if (category.colorName!=nil)
    {
        objectServer[@"colorName"]=category.colorName;
    }
    if (category.dateTime!=nil)
    {
        objectServer[@"dateTime"]=category.dateTime;
    }
    if (category.hasBudget!=nil)
    {
        objectServer[@"hasBudget"]=category.hasBudget;
    }
    if (category.iconName!=nil)
    {
        objectServer[@"iconName"]=category.iconName;
    }
    if (category.isDefault!=nil)
    {
        objectServer[@"isDefault"]=category.isDefault;
    }else{
        [objectServer removeObjectForKey:@"isDefault"];
    }

    if (category.isSystemRecord!=nil)
    {
        objectServer[@"isSystemRecord"]=category.isSystemRecord;
    }
    if (category.others!=nil)
    {
        objectServer[@"others"]=category.others;
    }else{
        [objectServer removeObjectForKey:@"others"];
    }
    if (category.recordIndex!=nil)
    {
        objectServer[@"recordIndex"]=category.recordIndex;
    }
    if (category.state!=nil)
    {
        objectServer[@"state"]=category.state;
    }
    if (category.uuid!=nil)
    {
        objectServer[@"uuid"]=category.uuid;
    }
    if (category.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=category.updatedTime;
    }
 
}
-(void)assignBillRuleServer:(PFObject *)objectServer WithLocal:(EP_BillRule *)billRule
{
    if (billRule.dateTime!=nil)
    {
        objectServer[@"dateTime"]=billRule.dateTime;
    }
    if (billRule.ep_billAmount!=nil)
    {
        objectServer[@"ep_billAmount"]=billRule.ep_billAmount;
    }
    if (billRule.ep_billDueDate!=nil)
    {
        objectServer[@"ep_billDueDate"]=billRule.ep_billDueDate;
    }
    if (billRule.ep_billEndDate!=nil)
    {
        objectServer[@"ep_billEndDate"]=billRule.ep_billEndDate;
    }
    if (billRule.ep_billName!=nil)
    {
        objectServer[@"ep_billName"]=billRule.ep_billName;
    }
    if (billRule.ep_bool1!=nil)
    {
        objectServer[@"ep_bool1"]=billRule.ep_bool1;
    }
    if (billRule.ep_bool2!=nil)
    {
        objectServer[@"ep_bool2"]=billRule.ep_bool2;
    }
    if (billRule.ep_date1!=nil)
    {
        objectServer[@"ep_date1"]=billRule.ep_date1;
    }
    if (billRule.ep_date2!=nil)
    {
        objectServer[@"ep_date2"]=billRule.ep_date2;
    }
    if (billRule.ep_note!=nil)
    {
        objectServer[@"ep_note"]=billRule.ep_note;
    }else{
        [objectServer removeObjectForKey:@"ep_note"];
    }
    if (billRule.ep_recurringType!=nil)
    {
        objectServer[@"ep_recurringType"]=billRule.ep_recurringType;
    }else{
        [objectServer removeObjectForKey:@"ep_recurringType"];
    }
    if(billRule.ep_reminderDate!=nil)
    {
        objectServer[@"ep_reminderDate"]=billRule.ep_reminderDate;
    }else{
        [objectServer removeObjectForKey:@"ep_reminderDate"];
    }
    if (billRule.ep_reminderTime!=nil)
    {
        objectServer[@"ep_reminderTime"]=billRule.ep_reminderTime;
    }else{
        [objectServer removeObjectForKey:@"ep_reminderTime"];
    }
    if (billRule.ep_string1!=nil)
    {
        objectServer[@"ep_string1"]=billRule.ep_string1;
    }else{
        [objectServer removeObjectForKey:@"ep_string1"];
    }
    if (billRule.ep_string2!=nil)
    {
        objectServer[@"ep_string2"]=billRule.ep_string2;
    }else{
        [objectServer removeObjectForKey:@"ep_string2"];
    }
    if (billRule.state!=nil)
    {
        objectServer[@"state"]=billRule.state;
    }
    if (billRule.uuid!=nil)
    {
        objectServer[@"uuid"]=billRule.uuid;
    }
    if (billRule.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=billRule.updatedTime;
    }

    //relation
    if (billRule.billRuleHasCategory!=nil)
    {
        objectServer[@"billRuleHasCategory"]=billRule.billRuleHasCategory.uuid;
    }else{
        [objectServer removeObjectForKey:@"billRuleHasCategory"];
    }
    if (billRule.billRuleHasPayee!=nil)
    {
        objectServer[@"billRuleHasPayee"]=billRule.billRuleHasPayee.uuid;
    }else{
        [objectServer removeObjectForKey:@"billRuleHasPayee"];
    }
 
}
-(void)assignBillItemServer:(PFObject *)objectServer WithLocal:(EP_BillItem *)billItem
{
    if (billItem.dateTime!=nil)
    {
        objectServer[@"dateTime"]=billItem.dateTime;
    }
    if (billItem.ep_billisDelete!=nil)
    {
        objectServer[@"ep_billisDelete"]=billItem.ep_billisDelete;
    }else{
        [objectServer removeObjectForKey:@"ep_billisDelete"];
    }
    if (billItem.ep_billItemAmount!=nil)
    {
        objectServer[@"ep_billItemAmount"]=billItem.ep_billItemAmount;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemAmount"];
    }
    if (billItem.ep_billItemBool1!=nil)
    {
        objectServer[@"ep_billItemBool1"]=billItem.ep_billItemBool1;
    }
    if (billItem.ep_billItemBool2!=nil)
    {
        objectServer[@"ep_billItemBool2"]=billItem.ep_billItemBool2;
    }
    if (billItem.ep_billItemDate1!=nil)
    {
        objectServer[@"ep_billItemDate1"]=billItem.ep_billItemDate1;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemDate1"];
    }
    if (billItem.ep_billItemDate2!=nil)
    {
        objectServer[@"ep_billItemDate2"]=billItem.ep_billItemDate2;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemDate2"];
    }
    if (billItem.ep_billItemDueDate!=nil)
    {
        objectServer[@"ep_billItemDueDate"]=billItem.ep_billItemDueDate;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemDueDate"];
    }
    if (billItem.ep_billItemDueDateNew!=nil)
    {
        objectServer[@"ep_billItemDueDateNew"]=billItem.ep_billItemDueDateNew;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemDueDateNew"];
    }
    if (billItem.ep_billItemEndDate!=nil)
    {
        objectServer[@"ep_billItemEndDate"]=billItem.ep_billItemEndDate;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemEndDate"];
    }
    if (billItem.ep_billItemName!=nil)
    {
        objectServer[@"ep_billItemName"]=billItem.ep_billItemName;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemName"];
    }
    if(billItem.ep_billItemNote!=nil)
    {
        objectServer[@"ep_billItemNote"]=billItem.ep_billItemNote;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemNote"];
    }
    
    if (billItem.ep_billItemRecurringType!=nil)
    {
        objectServer[@"ep_billItemRecurringType"]=billItem.ep_billItemRecurringType;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemRecurringType"];
    }
    if (billItem.ep_billItemReminderDate!=nil)
    {
        objectServer[@"ep_billItemReminderDate"]=billItem.ep_billItemReminderDate;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemReminderDate"];
    }
    if (billItem.ep_billItemReminderTime!=nil)
    {
        objectServer[@"ep_billItemReminderTime"]=billItem.ep_billItemReminderTime;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemReminderTime"];
    }
    if (billItem.ep_billItemString1!=nil)
    {
        objectServer[@"ep_billItemString1"]=billItem.ep_billItemString1;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemString1"];
    }
    if (billItem.ep_billItemString2!=nil)
    {
        objectServer[@"ep_billItemString2"]=billItem.ep_billItemString2;
    }else{
        [objectServer removeObjectForKey:@"ep_billItemString2"];
    }
    if (billItem.state!=nil)
    {
        objectServer[@"state"]=billItem.state;
    }
    if (billItem.uuid!=nil)
    {
        objectServer[@"uuid"]=billItem.uuid;
    }
    if (billItem.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=billItem.updatedTime;
    }

    //relation
    if (billItem.billItemHasBillRule!=nil)
    {
        objectServer[@"billItemHasBillRule"]=billItem.billItemHasBillRule.uuid;
    }else{
        [objectServer removeObjectForKey:@"billItemHasBillRule"];
    }
    if (billItem.billItemHasCategory!=nil)
    {
        objectServer[@"billItemHasCategory"]=billItem.billItemHasCategory.uuid;
    }else{
        [objectServer removeObjectForKey:@"billItemHasCategory"];
    }
    if (billItem.billItemHasPayee!=nil)
    {
        objectServer[@"billItemHasPayee"]=billItem.billItemHasPayee.uuid;
    }else{
        [objectServer removeObjectForKey:@"billItemHasPayee"];
    }
 
}
-(void)assignBudgetTemplateServer:(PFObject *)objectServer WithLocal:(BudgetTemplate *)budgetTemplate
{
    if (budgetTemplate.amount!=nil) {
        objectServer[@"amount"]=budgetTemplate.amount;
    }
    if (budgetTemplate.cycleType!=nil) {
        objectServer[@"cycleType"]=budgetTemplate.cycleType;
    }
    if (budgetTemplate.dateTime!=nil) {
        objectServer[@"dateTime"]=budgetTemplate.dateTime;
    }

    if (budgetTemplate.isNew!=nil) {
        objectServer[@"isNew"]=budgetTemplate.isNew;
    }
    if (budgetTemplate.isRollover!=nil) {
        objectServer[@"isRollover"]=budgetTemplate.isRollover;
    }
    if (budgetTemplate.orderIndex!=nil) {
        objectServer[@"orderIndex"]=budgetTemplate.orderIndex;
    }
    if (budgetTemplate.startDate!=nil) {
        objectServer[@"startDate"]=budgetTemplate.startDate;
    }
    if (budgetTemplate.startDateHasChange!=nil) {
        objectServer[@"startDateHasChange"]=budgetTemplate.startDateHasChange;
    }
    if (budgetTemplate.state!=nil) {
        objectServer[@"state"]=budgetTemplate.state;
    }
    if (budgetTemplate.uuid!=nil) {
        objectServer[@"uuid"]=budgetTemplate.uuid;
    }

    if (budgetTemplate.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=budgetTemplate.updatedTime;
    }
    //relation
    if (budgetTemplate.category!=nil)
    {
        objectServer[@"category"]=budgetTemplate.category.uuid;
    }else{
        [objectServer removeObjectForKey:@"category"];
    }

}
-(void)assignBudgetItemServer:(PFObject *)objectServer WithLocal:(BudgetItem *)budgetItem
{
    if (budgetItem.amount!=nil)
    {
        objectServer[@"amount"]=budgetItem.amount;
    }
    if (budgetItem.dateTime!=nil)
    {
        objectServer[@"dateTime"]=budgetItem.dateTime;
    }
    if (budgetItem.endDate!=nil)
    {
        objectServer[@"endDate"]=budgetItem.endDate;
    }

    if (budgetItem.isCurrent!=nil)
    {
        objectServer[@"iscURRENT"]=budgetItem.isCurrent;
    }
    if (budgetItem.isRollover!=nil)
    {
        objectServer[@"isRollover"]=budgetItem.isRollover;
    }
    if (budgetItem.orderIndex!=nil)
    {
        objectServer[@"orderIndex"]=budgetItem.orderIndex;
    }
    if (budgetItem.startDate!=nil)
    {
        objectServer[@"startDate"]=budgetItem.startDate;
    }
    if (budgetItem.state!=nil)
    {
        objectServer[@"state"]=budgetItem.state;
    }
    if (budgetItem.rolloverAmount!=nil)
    {
        objectServer[@"rolloverAmount"]=budgetItem.rolloverAmount;
    }
    if (budgetItem.uuid!=nil)
    {
        objectServer[@"uuid"]=budgetItem.uuid;
    }
    if (budgetItem.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=budgetItem.updatedTime;
    }
    //relation
    if (budgetItem.budgetTemplate!=nil)
    {
        objectServer[@"budgetTemplate"]=budgetItem.budgetTemplate.uuid;
    }else{
        [objectServer removeObjectForKey:@"budgetTemplate"];
    }

}
-(void)assignBudgetTransferServer:(PFObject *)objectServer WithLocal:(BudgetTransfer *)budgetTransfer
{
    if (budgetTransfer.amount!=nil) {
        objectServer[@"amount"]=budgetTransfer.amount;
    }
    if (budgetTransfer.dateTime!=nil) {
        objectServer[@"dateTime"]=budgetTransfer.dateTime;
    }
    if (budgetTransfer.dateTime_sync!=nil) {
        objectServer[@"dateTime_sync"]=budgetTransfer.dateTime_sync;
    }

    if (budgetTransfer.state!=nil) {
        objectServer[@"state"]=budgetTransfer.state;
    }
    if (budgetTransfer.uuid!=nil) {
        objectServer[@"uuid"]=budgetTransfer.uuid;
    }
    if (budgetTransfer.updatedTime!=nil)
    {
        objectServer[@"updatedTime"]=budgetTransfer.updatedTime;
    }

    //relation
    if (budgetTransfer.toBudget!=nil)
    {
        objectServer[@"toBudget"]=budgetTransfer.toBudget.uuid;
    }else{
        [objectServer removeObjectForKey:@"toBudget"];
    }
    if (budgetTransfer.fromBudget!=nil)
    {
        objectServer[@"fromBudget"]=budgetTransfer.fromBudget.uuid;
    }else{
        [objectServer removeObjectForKey:@"fromBudget"];
    }

}
#pragma mark - Server to Local ASSIGN
-(void)assignTransactionLocal:(Transaction *)transaction WithServer:(PFObject *)objectServer
{
    transaction.amount=objectServer[@"amount"];
    transaction.dateTime=objectServer[@"dateTime"];
    transaction.dateTime_sync=objectServer[@"dateTime_Sync"];
    transaction.groupByDate=objectServer[@"groupByDate"];
    transaction.isClear=objectServer[@"isClear"];
    transaction.notes=objectServer[@"notes"];
    transaction.orderIndex=objectServer[@"orderIndex"];
    transaction.others=objectServer[@"others"];
    transaction.recurringType=objectServer[@"recurringType"];
    transaction.state=objectServer[@"state"];
    transaction.transactionBool=objectServer[@"transactionBool"];
    transaction.transactionstring=objectServer[@"transactionstring"];
    transaction.transactionType=objectServer[@"transactionType"];
    transaction.type=objectServer[@"type"];
    transaction.uuid=objectServer[@"uuid"];
    transaction.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"category"]!=nil)
    {
        if ([objectServer[@"category"] isEqualToString:@"4349B269-0856-436E-98E0-D5C5DE0B289D"]) {
            
            NSFetchRequest *request=[[NSFetchRequest alloc]init];
            NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
            request.entity=desc;
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"4349B269-0856-436E-98E0-D5C5DE0B289D"];
            request.predicate=predicate;
            NSError *error;
            NSArray *array=[_childCtx executeFetchRequest:request error:&error];
            if (array.count)
            {
                transaction.category=array[0];
            }else{
                
                NSFetchRequest *request=[[NSFetchRequest alloc]init];
                NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
                request.entity=desc;
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"FFA1E895-9680-478F-A2F1-13EBD90EC35E"];
                request.predicate=predicate;
                NSError *error;
                NSArray *array=[_childCtx executeFetchRequest:request error:&error];
                if (array.count)
                {
                    transaction.category=array[0];
                }else{
                    NSFetchRequest *request=[[NSFetchRequest alloc]init];
                    NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
                    request.entity=desc;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"CA6C55B4-2B95-4921-9AE4-74E76A253426"];
                    request.predicate=predicate;
                    NSError *error;
                    NSArray *array=[_childCtx executeFetchRequest:request error:&error];
                    if (array.count)
                    {
                        transaction.category=array[0];
                    }
                }
               
            }
            
        }else{
            NSFetchRequest *request=[[NSFetchRequest alloc]init];
            NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
            request.entity=desc;
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]];
            request.predicate=predicate;
            NSError *error;
            NSArray *array=[_childCtx executeFetchRequest:request error:&error];
            if (array.count)
            {
                transaction.category=array[0];
            }
        }
    }else{
        transaction.category = nil;
    }
    if (objectServer[@"expenseAccount"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"expenseAccount"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.expenseAccount=array[0];
        }
    }else{
        transaction.expenseAccount = nil;
    }
    if (objectServer[@"incomeAccount"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"incomeAccount"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.incomeAccount=array[0];
        }
    }else{
        transaction.incomeAccount=nil;
    }
    if (objectServer[@"parTransaction"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.parTransaction=array[0];
        }
    }else{
        transaction.parTransaction = nil;
    }
    if (objectServer[@"payee"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"payee"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.payee=array[0];
        }
    }else{
        transaction.payee=nil;
    }
    if (objectServer[@"transactionHasBillItem"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"transactionHasBillItem"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.transactionHasBillItem=array[0];
        }
    }else{
        transaction.transactionHasBillItem = nil;
    }
    
    if (objectServer[@"transactionHasBillRule"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"transactionHasBillRule"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.transactionHasBillRule=array[0];
        }
    }else{
        transaction.transactionHasBillRule=nil;
    }
    
    //childTransaction的处理
    if (objectServer[@"parTransaction"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            transaction.parTransaction=array[0];
        }
    }else{
        transaction.parTransaction=nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *documentsPath = [paths objectAtIndex:0];
    //图片的处理
    if(objectServer[@"photoName"]!=nil)
    {
        PFFile *photoFile=objectServer[@"photoData"];
        NSError *error;
        NSData *photoData=[photoFile getData:&error];
        if (error)
        {
            NSLog(@"图片下载错误 %@",error);
        }
        if (transaction.photoName!=nil)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg",documentsPath, transaction.photoName];
            [fileManager removeItemAtPath:oldImagepath error:&error];
        }
        transaction.photoName = objectServer[@"photoName"];
        [photoData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", documentsPath, objectServer[@"photoName"]] atomically:YES];
    }

}


-(void)assignAccountTypeLocal:(AccountType *)accountType WithServer:(PFObject *)objectServer
{
    accountType.dateTime=objectServer[@"dateTime"];
    accountType.iconName=objectServer[@"iconName"];
    accountType.isDefault=objectServer[@"isDefault"];
    accountType.ordexIndex=objectServer[@"orderIndex"];
    accountType.others=objectServer[@"others"];
    accountType.state=objectServer[@"state"];
    accountType.typeName=objectServer[@"typeName"];
    accountType.uuid=objectServer[@"uuid"];
    accountType.updatedTime=objectServer[@"updatedTime"];
}
-(void)assignBudgetTemplateLocal:(BudgetTemplate *)budgetTemplate WithServer:(PFObject *)objectServer
{
    budgetTemplate.amount=objectServer[@"amount"];
    budgetTemplate.cycleType=objectServer[@"cycleType"];
    budgetTemplate.dateTime=objectServer[@"dateTime"];
    budgetTemplate.isNew=objectServer[@"isNew"];
    budgetTemplate.isRollover=objectServer[@"isRollover"];
    budgetTemplate.orderIndex=objectServer[@"orderIndex"];
    budgetTemplate.startDate=objectServer[@"startDate"];
    budgetTemplate.startDateHasChange=objectServer[@"startDateHasChange"];
    budgetTemplate.uuid=objectServer[@"uuid"];
    budgetTemplate.updatedTime=objectServer[@"updatedTime"];
    budgetTemplate.state=objectServer[@"state"];
    if (objectServer[@"category"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            budgetTemplate.category=array[0];
        }
    }

}
-(void)assignAccountLocal:(Accounts *)account WithServer:(PFObject *)objectServer
{
    account.accName=objectServer[@"accName"];
    account.amount=objectServer[@"amount"];
    account.autoClear=objectServer[@"autoClear"];
    account.checkNumber=objectServer[@"checkNumber"];
    account.creditLimit=objectServer[@"creditLimit"];
    account.dateTime=objectServer[@"dateTime"];
    account.dateTime_sync=objectServer[@"dateTime_sync"];
    account.dueDate=objectServer[@"dueDate"];
    account.iconName=objectServer[@"objectServer"];
    account.orderIndex=objectServer[@"orderIndex"];
    account.others=objectServer[@"others"];
    account.reconcile=objectServer[@"reconcile"];
    account.runningBalance=objectServer[@"runningBalance"];
    account.state=objectServer[@"state"];
    account.uuid=objectServer[@"uuid"];
    account.accountColor=objectServer[@"accountColor"];
    account.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"accountType"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"accountType"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            account.accountType=array[0];
        }
    }
    
}
-(void)assignCategoryLocal:(Category *)category WithServer:(PFObject *)objectServer
{
    category.categoryisExpense=objectServer[@"categoryisExpense"];
    category.categoryisIncome=objectServer[@"categoryisIncome"];
    category.categoryName=objectServer[@"categoryName"];
    category.categoryString=objectServer[@"categoryString"];
    category.categoryType=objectServer[@"categoryType"];
    category.colorName=objectServer[@"colorName"];
    category.dateTime=objectServer[@"dateTime"];
    category.hasBudget=objectServer[@"hasBudget"];
    category.iconName=objectServer[@"iconName"];
    category.isDefault=objectServer[@"isDefault"];
    category.isSystemRecord=objectServer[@"isSystemRecord"];
    category.others=objectServer[@"others"];
    category.recordIndex=objectServer[@"recordIndex"];
    category.state=objectServer[@"state"];
    category.uuid=objectServer[@"uuid"];
    category.updatedTime=objectServer[@"updatedTime"];
//    if (objectServer[@"budgetTemplate"]!=nil)
//    {
//        NSFetchRequest *request=[[NSFetchRequest alloc]init];
//        NSEntityDescription *desc=[NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:_childCtx];
//        request.entity=desc;
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"budgetTemplate"]];
//        request.predicate=predicate;
//        NSError *error;
//        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
//        category.budgetTemplate=array[0];
//    }
}
-(void)assignPayeeLocal:(Payee *)payee WithServer:(PFObject *)objectServer
{
    payee.dateTime=objectServer[@"dateTime"];
    payee.memo=objectServer[@"memo"];
    payee.name=objectServer[@"name"];
    payee.orderIndex=objectServer[@"orderIndex"];
    payee.others=objectServer[@"others"];
    payee.phone=objectServer[@"phone"];
    payee.state=objectServer[@"state"];
    payee.tranAmount=objectServer[@"tranAmount"];
    payee.tranCleared=objectServer[@"tranCleared"];
    payee.tranMemo=objectServer[@"tranMemo"];
    payee.tranType=objectServer[@"tranType"];
    payee.uuid=objectServer[@"uuid"];
    payee.website=objectServer[@"website"];
    payee.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"category"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            payee.category=array[0];
        }
    }
}
-(void)assignBillRuleLocal:(EP_BillRule *)billRule WithServer:(PFObject *)objectServer
{
    billRule.dateTime=objectServer[@"dateTime"];
    billRule.ep_billAmount=objectServer[@"ep_billAmount"];
    billRule.ep_billDueDate=objectServer[@"ep_billDueDate"];
    billRule.ep_billEndDate=objectServer[@"ep_billEndDate"];
    billRule.ep_billName=objectServer[@"ep_billName"];
    billRule.ep_bool1=objectServer[@"ep_bool1"];
    billRule.ep_bool2=objectServer[@"ep_bool2"];
    billRule.ep_date1=objectServer[@"ep_date1"];
    billRule.ep_date2=objectServer[@"ep_date2"];
    billRule.ep_note=objectServer[@"ep_note"];
    billRule.ep_recurringType=objectServer[@"ep_recurringType"];
    billRule.ep_reminderDate=objectServer[@"ep_reminderDate"];
    billRule.ep_reminderTime=objectServer[@"ep_reminderTime"];
    billRule.ep_string1=objectServer[@"ep_string1"];
    billRule.ep_string2=objectServer[@"ep_string2"];
    billRule.state=objectServer[@"state"];
    billRule.uuid=objectServer[@"uuid"];
    billRule.updatedTime=objectServer[@"updatedTime"];
    //
    if (objectServer[@"billRuleHasCategory"]!=nil)
    {
        NSFetchRequest *requeset=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
        requeset.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasCategory"]];
        requeset.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:requeset error:&error];
        if (array.count)
        {
            billRule.billRuleHasCategory=array[0];
        }
    }
    if (objectServer[@"billRuleHasPayee"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasPayee"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            billRule.billRuleHasPayee=array[0];
        }
    }
}
-(void)assignBillItemLocal:(EP_BillItem *)billItem WithServer:(PFObject *)objectServer
{
    billItem.dateTime=objectServer[@"dateTime"];
    billItem.ep_billisDelete=objectServer[@"ep_billisDelete"];
    billItem.ep_billItemAmount=objectServer[@"ep_billItemAmount"];
    billItem.ep_billItemBool1=objectServer[@"ep_billItemBool1"];
    billItem.ep_billItemBool2=objectServer[@"ep_billItemBool2"];
    billItem.ep_billItemDate1=objectServer[@"ep_billItemDate1"];
    billItem.ep_billItemDate2=objectServer[@"ep_billItemDate2"];
    billItem.ep_billItemDueDate=objectServer[@"ep_billItemDueDate"];
    billItem.ep_billItemDueDateNew=objectServer[@"ep_billItemDueDateNew"];
    billItem.ep_billItemEndDate=objectServer[@"ep_billItemEndDate"];
    billItem.ep_billItemName=objectServer[@"ep_billItemName"];
    billItem.ep_billItemNote=objectServer[@"ep_billItemNote"];
    billItem.ep_billItemRecurringType=objectServer[@"ep_billItemRecurringType"];
    billItem.ep_billItemReminderDate=objectServer[@"ep_billItemReminderDate"];
    billItem.ep_billItemReminderTime=objectServer[@"ep_billItemReminderTime"];
    billItem.ep_billItemString1=objectServer[@"ep_billItemString1"];
    billItem.ep_billItemString2=objectServer[@"ep_billItemString2"];
    billItem.state=objectServer[@"state"];
    billItem.uuid=objectServer[@"uuid"];
    billItem.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"billItemHasBillRule"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasBillRule"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            billItem.billItemHasBillRule=array[0];
        }
    }
    if (objectServer[@"billItemHasCategory"])
    {
        NSFetchRequest *requeset=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_childCtx];
        requeset.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasCategory"]];
        requeset.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:requeset error:&error];
        if (array.count)
        {
            billItem.billItemHasCategory=array[0];
        }
    }
    if (objectServer[@"billItemHasPayee"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasPayee"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            billItem.billItemHasPayee=array[0];
        }
    }
}
-(void)assignBudgetItemLocal:(BudgetItem *)budgetItem WithServer:(PFObject *)objectServer
{
    budgetItem.amount=objectServer[@"amount"];
    budgetItem.dateTime=objectServer[@"dateTime"];
    budgetItem.endDate=objectServer[@"endDate"];
    budgetItem.isCurrent=objectServer[@"isCurrent"];
    budgetItem.isRollover=objectServer[@"isRollover"];
    budgetItem.orderIndex=objectServer[@"orderIndex"];
    budgetItem.rolloverAmount=objectServer[@"rolloverAmount"];
    budgetItem.startDate=objectServer[@"startDate"];
    budgetItem.state=objectServer[@"state"];
    budgetItem.uuid=objectServer[@"uuid"];
    budgetItem.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"budgetTemplate"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"budgetTemplate"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            budgetItem.budgetTemplate=array[0];
        }
    }
    
}
-(void)assignBudgetTransfer:(BudgetTransfer *)budgetTransfer WithServer:(PFObject *)objectServer
{
    budgetTransfer.amount=objectServer[@"amount"];
    budgetTransfer.dateTime=objectServer[@"dateTime"];
    budgetTransfer.dateTime_sync=objectServer[@"dateTimeSync"];
    budgetTransfer.state=objectServer[@"state"];
    budgetTransfer.uuid=objectServer[@"uuid"];
    budgetTransfer.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"fromBudget"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"fromBudget"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            budgetTransfer.fromBudget=array[0];
        }
    }
    if (objectServer[@"toBudget"]!=nil)
    {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:_childCtx];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"toBudget"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[_childCtx executeFetchRequest:request error:&error];
        if (array.count)
        {
            budgetTransfer.toBudget=array[0];
        }
    }
}
#pragma mark - 还原方法
//完全采用本地数据
-(void)localDataToServer
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSArray *dbName=@[@"Accounts",@"AccountType",@"BudgetItem",@"BudgetTemplate",@"BudgetTransfer",@"Category",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:appDelegate.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[appDelegate.managedObjectContext executeFetchRequest:requestLocal error:&error];
        NSString *uuid;
        switch (i) {
            case 0:
            {
                for (Accounts *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignAccountsServer:objectServer withLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 1:
            {
                for (AccountType *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignAccountTypeServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 2:
            {
                for (BudgetItem *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignBudgetItemServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 3:
            {
                for (BudgetTemplate *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignBudgetTemplateServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 4:
            {
                for (BudgetTransfer *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignBudgetTransferServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 5:
            {
                for (Category *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignCategoryServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 6:
            {
                for (EP_BillItem *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignBillItemServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 7:
            {
                EP_BillRule *object=[datas objectAtIndex:0];
                uuid=object.uuid;
                for (EP_BillRule *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignBillRuleServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 8:
            {
                for (Payee *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignPayeeServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            case 9:
            {

                for (Transaction *object in datas)
                {
                    uuid=object.uuid;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid=%@",uuid];
                    PFQuery *query=[PFQuery queryWithClassName:[dbName objectAtIndex:i] predicate:predicate];
                    PFObject *objectServer=[query getFirstObject];
                    [self assignTransactionServer:objectServer WithLocal:object];
                    [objectServer saveInBackground];
                }
            }
                break;
            default:
                break;
                
        }
    }
}
-(void)restoreDataRemove
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *dbName=@[@"Accounts",@"BillReports",@"BillRule",@"BudgetItem",@"BudgetReports",@"BudgetTemplate",@"BudgetTransfer",@"EP_BillItem",@"EP_BillRule",@"Payee",@"Transaction",@"TransactionRule"];
    for (int i=0; i<dbName.count; i++)
    {
        NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
        NSEntityDescription *descLocal=[NSEntityDescription entityForName:[dbName objectAtIndex:i] inManagedObjectContext:appDelegate.managedObjectContext];
        requestLocal.entity=descLocal;
        NSError *error;
        NSArray *datas=[appDelegate.managedObjectContext executeFetchRequest:requestLocal error:&error];
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                [appDelegate.managedObjectContext deleteObject:obj];
            }
            if (![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"error:%@",error);
            }
        }
    }
}

@end

//
//  XDDataManager.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/11.
//

#import "XDDataManager.h"
#import "PokcetExpenseAppDelegate.h"
#import "Transaction.h"
#import "Category.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "User.h"

@implementation XDDataManager

@synthesize backgroundContext = _backgroundContext;

-(NSManagedObjectModel*)managedObjectModel{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
    @synchronized(appDelegete.managedObjectModel) {
        return appDelegete.managedObjectModel;
    }
    return nil;
}

-(NSManagedObjectContext*)managedObjectContext{
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
    @synchronized(appDelegete.managedObjectContext){
        return appDelegete.managedObjectContext;
    }
    return nil;
}

+(XDDataManager *)shareManager{
    static XDDataManager* g_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shareManager = [[XDDataManager alloc]init];
    });
    return g_shareManager;
}

-(NSManagedObjectContext *)backgroundContext{
    if (!_backgroundContext) {
        _backgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];

        [_backgroundContext setPersistentStoreCoordinator:appDelegete.persistentStoreCoordinator];
    }
    return _backgroundContext;
}

-(void)openWidgetInSettingWithBool14:(BOOL)open{
    
    Setting* setting = [[self getObjectsFromTable:@"Setting"]lastObject];
    setting.otherBool14 = [NSNumber numberWithBool:open];
    [self saveContext];
}

-(Setting *)getSetting{
    return [[self getObjectsFromTable:@"Setting"]lastObject];
}

-(void)puchasedInfoInSetting:(NSDate*)startDate productID:(NSString*)productID originalProID:(NSString *)originalProID{
    NSDate* endDate;
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    if ([productID isEqualToString:KInAppPurchaseProductIdMonth]) {
        // 修改订阅测试时间
#ifdef DEBUG
        comp.minute += 5;
#else
        comp.month += 1;
#endif
//          comp.month += 1;
//        comp.minute += 5;
        endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
        
    }else if ([productID isEqualToString:KInAppPurchaseProductIdYear]){
        // 修改订阅测试时间
//        comp.year += 1;
#ifdef DEBUG
        comp.hour += 1;
#else
        comp.year += 1;
#endif
//         comp.day += 1;
//        comp.hour += 1;
        endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
        
    }else if ([productID isEqualToString:kInAppPurchaseProductIdLifetime]){
        comp.year += 100;
        endDate = [[NSCalendar currentCalendar] dateFromComponents:comp];

    }

    Setting* setting = [[self getObjectsFromTable:@"Setting"] lastObject];
    setting.purchasedProductID = productID;
    setting.purchasedStartDate = startDate;
    setting.purchasedEndDate = endDate;
    setting.purchasedUpdateTime = [NSDate date];
    setting.otherBool17 = @NO;
    setting.purchasedIsSubscription = @YES;
    setting.uuid = [PFUser currentUser].objectId;
    setting.purchaseOriginalProductID = originalProID;
    
    [self saveContext];
    
    [[XDPurchasedManager shareManager] savePFSetting];
}

-(void)removeSettingPurchase{
    Setting* setting = [[self getObjectsFromTable:@"Setting"] lastObject];
//    setting.purchasedProductID = nil;
//    setting.purchasedStartDate = nil;
//    setting.purchasedEndDate = nil;
    setting.dateTime = [NSDate GMTTime];
    setting.otherBool17 = @NO;
    setting.purchasedIsSubscription = @NO;

    [self saveContext];
    
    [[XDPurchasedManager shareManager] savePFSetting];
}



#pragma mark - insert
-(id)insertObjectToTable:(NSString*)tableName
{
    id object = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
    return object;
}

-(id)backgroundInsertObjectToTable:(NSString*)tableName{
    
    id object = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.backgroundContext];
    return object;
}

-(NSArray *)getObjectsFromTable:(NSString *)tableName
{

    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:tableName inManagedObjectContext:self. managedObjectContext];
    
    [request setEntity:entityDesc];
    NSError* error=nil;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
}

-(NSArray*)getTransactionDate:(NSDate* )date withAccount:(Accounts*)account{
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:[date startDate],@"startDate",[date endDate],@"endDate",nil];
    
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime_sync" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];

    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor,sortDescriptor2, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSMutableArray* objects1 = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
//    NSArray *objects1 = [[NSArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];

//    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

//    for (Transaction*transactions in muArr) {
//        if([transactions.category.categoryType isEqualToString:@"EXPENSE"]  || [transactions.childTransactions count]>0)
//        {
//        }
//        //Income
//        else if([transactions.category.categoryType isEqualToString:@"INCOME"])
//        {
//
//        } else
//        {
//            if(transactions.expenseAccount && transactions.incomeAccount == nil){
//
//                [muArr removeObject:transactions];
//
//                transactions.state = @"0";
//                transactions.updatedTime = transactions.dateTime_sync = [NSDate date];
//                [self saveContext];
//
//                [appDelegete.epdc deleteTransactionRel:transactions];
//
//            }
//        }
//    }
//    NSArray* objects1 = [NSArray arrayWithArray:muArr];
    
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [objects1 filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return objects1;
}

-(NSArray*)backgroundGetTransactionDate:(NSDate* )date withAccount:(Accounts*)account{
    
    NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:[date startDate],@"startDate",[date endDate],@"endDate",nil];
    
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsWithDate" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedTime" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor,sortDescriptor2, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error =nil;
    NSArray *objects1 = [[NSArray alloc]initWithArray:[self.backgroundContext executeFetchRequest:fetchRequest error:&error]];
    
   
    if (account) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"incomeAccount.uuid = %@ or expenseAccount.uuid = %@",account.uuid,account.uuid];
        NSArray* array = [objects1 filteredArrayUsingPredicate:pre];
        
        return array;
    }
    
    return objects1;
}

-(NSArray*)fetchParentExpenseCategory{
    NSError *error = nil;
    NSDictionary *subs = [[NSDictionary alloc]init];
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestFromTemplateWithName:@"fetchParentExpenseCategory" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    return objects;
}

-(NSArray *)getObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortArray && sortArray.count > 0) {
        [request setSortDescriptors:sortArray];
    }
    
    NSError* error=nil;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
}

-(NSArray *)backgroundGetObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.backgroundContext];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortArray && sortArray.count > 0) {
        [request setSortDescriptors:sortArray];
    }
    
    NSError* error=nil;
    NSArray* objects = [self.backgroundContext executeFetchRequest:request error:&error];
    
    return objects;
}


-(void)deleteTableObject:(id)object{
    [self.managedObjectContext deleteObject:object];
    NSError* error=nil;
    [self.managedObjectContext save:&error];
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [self.managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            // abort();
        }
    }
}



+(NSString *)moneyFormatter:(double)doubleContext{
    
    if (doubleContext == 0) {
        return @"0.00";
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *string = @"";
    if(doubleContext >= 0)
        string = [NSString stringWithFormat:@"%.2f",doubleContext];
    else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
    NSArray *tmp = [string componentsSeparatedByString:@"."];
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    [numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
    if([tmp count]<2)
    {
        string = tmpStr;
    }
    else
    {
        
        string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
    }
    
    
    NSString *typeOfDollar = appDelegate.settings.currency;
    NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        dollorStr = [NSString stringWithFormat:@"-%@",dollorStr];
    }
    
    string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
        string = [NSString stringWithFormat:@"%@",string];
    
    
    
    return string;
    
}


-(void)fixStateIsZeroBug{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:[NSDate date]];
    comp.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    comp.year = 2019;
    comp.month = 1;
    comp.day = 3;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
    if ([[PFUser currentUser].createdAt compare:date] == NSOrderedDescending) {
        return;
    }
    if (![PFUser currentUser]) {
        return;
    }
    
    [self allTransactionToLocal:date];
   
}

-(void)deleteSomeUnUseTransaction{
    
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:[NSDate date]];
    comp.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    comp.year = 2019;
    comp.month = 1;
    comp.day = 1;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comp];
    if ([[PFUser currentUser].createdAt compare:date] == NSOrderedAscending) {
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray* array = [self getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        NSMutableArray* unUseArr = [NSMutableArray array];
        
        if (array.count > 0) {
            for (Transaction* transcation in array) {
                if (transcation.expenseAccount == nil && transcation.incomeAccount == nil) {
                    [unUseArr addObject:transcation];
                }
            }
            
            if (unUseArr.count > 0) {
                for (Transaction* tran in unUseArr) {
                    [appDelegete.epdc deleteTransactionRel:tran];
                }
            }
        }
    }
}

-(void)allTransactionToLocal:(NSDate*)date{
    NSArray* array = [self getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"updatedTime <= %@",date] sortDescriptors:nil];
    
    if (array.count <= 0) {//说明数据没了,不严谨
        NSPredicate *predicateServerFather=[NSPredicate predicateWithFormat:@"user=%@ and state=%@ and parTransaction=%@",[PFUser currentUser],@"0",nil];
        PFQuery *queryFather=[PFQuery queryWithClassName:@"Transaction" predicate:predicateServerFather];
        [queryFather orderByDescending:@"updatedTime"];
        queryFather.limit = 100000;
        [queryFather findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            [self.backgroundContext performBlock:^{
                for (int i = 0; i < objects.count; i++) {
                    PFObject* object = objects[i];
                    Transaction* localTransation = [[self backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"uuid = %@",object[@"uuid"]] sortDescriptors:nil]lastObject];
                    if (!localTransation) {
                        Transaction* transaction = [self backgroundInsertObjectToTable:@"Transaction"];
                        [self assignTransactionLocal:transaction WithServer:object];
                        transaction.state = @"1";
                        transaction.isUpload = @"1";
                        
                        
                    }else{
                        localTransation.state = @"1";
                        localTransation.isUpload = @"1";
                    }
                    NSError *error;
                    [self.backgroundContext save:&error];
                    
                    
                    object[@"state"] = @"1";
                    [object saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
                        
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
                });
                
            }];
            
        }];
        
        NSPredicate *predicateServerchild=[NSPredicate predicateWithFormat:@"user=%@ and state=%@ and parTransaction!=%@",[PFUser currentUser],@"0",nil];
        PFQuery *querychild=[PFQuery queryWithClassName:@"Transaction" predicate:predicateServerchild];
        [querychild orderByDescending:@"updatedTime"];
        querychild.limit = 100000;
        [querychild findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            [self.backgroundContext performBlock:^{
                for (int i = 0; i < objects.count; i++) {
                    PFObject* object = objects[i];
                    Transaction* localTransation = [[self backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"uuid = %@",object[@"uuid"]] sortDescriptors:nil]lastObject];
                    if (!localTransation) {
                        Transaction* transaction = [self backgroundInsertObjectToTable:@"Transaction"];
                        [self assignTransactionLocal:transaction WithServer:object];
                        transaction.state = @"1";
                        transaction.isUpload = @"1";

                    }else{
                        localTransation.state = @"1";
                        localTransation.isUpload = @"1";
                    }
                    
                    
                    object[@"state"] = @"1";
                    [object saveEventually];
                }
                NSError *error;
                [self.backgroundContext save:&error];
                
            }];
            
        }];
    }
}

-(void)uploadLocalTransaction{
    if ([PFUser currentUser]) {
        [self.backgroundContext performBlock:^{
            NSArray* array = [self backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and (isUpload = %@)",@"1",[NSNull null]] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedTime" ascending:NO]]];
            
            for (Transaction* transaction in array) {
                
                PFQuery * query=[PFQuery queryWithClassName:@"Transaction"];
                [query whereKey:@"user" equalTo:[PFUser currentUser]];
                [query whereKey:@"uuid" equalTo:transaction.uuid];

                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    if (object) {
                        if ([object[@"state"] isEqualToString:@"0"]) {
                            object[@"state"] = @"1";
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (succeeded) {
                                    Transaction* subTran = [[self backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"uuid = %@",transaction.uuid] sortDescriptors:nil]lastObject];
                                    if (subTran) {
                                        subTran.isUpload = @"1";
                                    }
                                }
                            }];
                        }else if ([object[@"state"] isEqualToString:@"1"]) {
                            Transaction* subTran = [[self backgroundGetObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"uuid = %@",transaction.uuid] sortDescriptors:nil]lastObject];
                            if (subTran) {
                                subTran.isUpload = @"1";
                            }
                        }
                    }
                }];
                
                NSError *error;
                [self.backgroundContext save:&error];
                
            }
        }];
    }

}

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
            NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.backgroundContext];
            request.entity=desc;
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"4349B269-0856-436E-98E0-D5C5DE0B289D"];
            request.predicate=predicate;
            NSError *error;
            NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
            if (array.count)
            {
                transaction.category=array[0];
            }else{
                
                NSFetchRequest *request=[[NSFetchRequest alloc]init];
                NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.backgroundContext];
                request.entity=desc;
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"FFA1E895-9680-478F-A2F1-13EBD90EC35E"];
                request.predicate=predicate;
                NSError *error;
                NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
                if (array.count)
                {
                    transaction.category=array[0];
                }else{
                    NSFetchRequest *request=[[NSFetchRequest alloc]init];
                    NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.backgroundContext];
                    request.entity=desc;
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",@"CA6C55B4-2B95-4921-9AE4-74E76A253426"];
                    request.predicate=predicate;
                    NSError *error;
                    NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
                    if (array.count)
                    {
                        transaction.category=array[0];
                    }
                }
                
            }
            
        }else{
            NSFetchRequest *request=[[NSFetchRequest alloc]init];
            NSEntityDescription *desc=[NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.backgroundContext];
            request.entity=desc;
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]];
            request.predicate=predicate;
            NSError *error;
            NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"expenseAccount"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"incomeAccount"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Payee" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"payee"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"transactionHasBillItem"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"transactionHasBillRule"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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
        NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.backgroundContext];
        request.entity=desc;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]];
        request.predicate=predicate;
        NSError *error;
        NSArray *array=[self.backgroundContext executeFetchRequest:request error:&error];
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

-(void)fixSomeUserNotSync{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:[NSDate date]];
    comp.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    comp.year = 2019;
    comp.month = 1;
    comp.day = 1;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comp];

    if (![PFUser currentUser]) {
        return;
    }
    User* user = [[self getObjectsFromTable:@"User"]lastObject];
    
    NSLog(@"user sync =  %@",user.syncTime);
    PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([user.syncTime compare:date] == NSOrderedAscending && appDelegate.autoSyncOn) {
        
    }
}




@end

@implementation NSDate (customer)

-(NSDate *)startDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [calendar components:dayInfoUnits fromDate:self];
    
    NSDate* date = [calendar dateFromComponents:components];
    
    return date;
}

-(NSDate *)endDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calendar components:dayInfoUnits fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    NSDate* date = [calendar dateFromComponents:components];
//
//    NSDate* date = [self startDate];
//
//    [date dateByAddingTimeInterval:24*3600-1];
    
    return date;
}

@end

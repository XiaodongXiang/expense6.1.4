//
//  XDFirestoreClass.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/2/20.
//

#import "XDFirestoreClass.h"
#import "PokcetExpenseAppDelegate.h"

#define tableTransaction    @"Transaction"
#define tablePayee          @"Payee"
#define tableAccount        @"Accounts"
#define tableAccountType    @"AccountType"
#define tableCategory       @"Category"
#define tableBillRule       @"EP_BillRule"
#define tableBillItem       @"EP_BillItem"
#define tableBudgetTemplate @"BudgetTemplate"
#define tableBudgetTransfer @"BudgetTransfer"
#define tableBudgetItem     @"BudgetItem"

@import Firebase;

@interface XDFirestoreClass()
@property(nonatomic, strong)FIRFirestore* db;
@property(nonatomic, strong)FIRUser* user;

@property(nonatomic, strong)NSManagedObjectContext * backgroundContext;
@property(nonatomic, strong)NSManagedObjectContext * mainContext;


@end
@implementation XDFirestoreClass

- (NSManagedObjectContext *)mainContext{
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
        [_mainContext setPersistentStoreCoordinator:appDelegete.persistentStoreCoordinator];
    }
    return _mainContext;
}
- (NSManagedObjectContext *)backgroundContext{
    if (!_backgroundContext) {
        _backgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication] delegate];
        [_backgroundContext setPersistentStoreCoordinator:appDelegete.persistentStoreCoordinator];
    }
    return _backgroundContext;
}



-(id)backgroundInsertObjectToTable:(NSString*)tableName{
    id object = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.backgroundContext];
    return object;
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

+(XDFirestoreClass*)shareClass{
    static XDFirestoreClass* g_class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_class = [[XDFirestoreClass alloc]init];
    });
    
    return g_class;
}

- (FIRFirestore *)db{
    return [FIRFirestore firestore];
}

-(FIRUser *)user{
    return [FIRAuth auth].currentUser;
}

#pragma mark - item transfer to dic
-(NSMutableDictionary*)dicWithTransaction:(Transaction*)transaction{
    
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[transaction dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:transaction.payee.uuid forKey:@"payee"];
        [muDic setValue:transaction.category.uuid forKey:@"category"];
        [muDic setValue:transaction.expenseAccount.uuid forKey:@"expenseAccount"];
        [muDic setValue:transaction.incomeAccount.uuid forKey:@"incomeAccount"];
        [muDic setValue:transaction.transactionHasBillItem.uuid forKey:@"transactionHasBillItem"];
        [muDic setValue:transaction.transactionHasBillRule.uuid forKey:@"transactionHasBillRule"];
        [muDic setValue:transaction.parTransaction.uuid forKey:@"parTransaction"];
        [muDic removeObjectForKey:@"childTransactions"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        //照片暂时没存
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithPayee:(Payee*)payee{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[payee dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:payee.category.uuid forKey:@"category"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];

        return muDic;
    }
    
    return nil;
}

-(NSMutableDictionary*)dicWithAccount:(Accounts*)account{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[account dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:account.accountType.uuid forKey:@"accountType"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];

        return muDic;
    }
    
    return nil;
}


-(NSMutableDictionary*)dicWithAccountType:(AccountType*)accountType{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[accountType dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic removeObjectForKey:@"accounts"];
        return muDic;
    }
    return nil;
}


-(NSMutableDictionary*)dicWithCategory:(Category*)category{
    
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[category dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];

        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBillRule:(EP_BillRule*)billRule{
    
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[billRule dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:billRule.billRuleHasCategory.uuid forKey:@"billRuleHasCategory"];
        [muDic setValue:billRule.billRuleHasPayee.uuid forKey:@"billRuleHasPayee"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];

        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBillItem:(EP_BillItem*)billItem{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[billItem dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:billItem.billItemHasBillRule.uuid forKey:@"billItemHasBillRule"];
        [muDic setValue:billItem.billItemHasCategory.uuid forKey:@"billItemHasCategory"];
        [muDic setValue:billItem.billItemHasPayee.uuid forKey:@"billItemHasPayee"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetTemplate:(BudgetTemplate*)budgetTemplate{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetTemplate dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:budgetTemplate.category.uuid forKey:@"category"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetItem:(BudgetItem*)budgetItem{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetItem dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:budgetItem.budgetTemplate.uuid forKey:@"budgetTemplate"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetTransfer:(BudgetTransfer*)budgetTransfer{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetTransfer dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:budgetTransfer.toBudget.uuid forKey:@"toBudget"];
        [muDic setValue:budgetTransfer.fromBudget.uuid forKey:@"fromBudget"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        
        return muDic;
    }
    return nil;
}


#pragma mark - single add item
-(void)addTransactionToFirestore:(Transaction*)transaction{
    NSMutableDictionary* muDic = [self dicWithTransaction:transaction];
    if (muDic) {
        [[[self.db collectionWithPath:tableTransaction] documentWithPath:transaction.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}


-(void)addPayeeToFirestore:(Payee*)payee{
    NSMutableDictionary* muDic = [self dicWithPayee:payee];
    if (muDic) {
        [[[self.db collectionWithPath:tablePayee] documentWithPath:payee.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}


-(void)addAccountToFirestore:(Accounts*)account{
    NSMutableDictionary* muDic = [self dicWithAccount:account];
    if (muDic) {
        [[[self.db collectionWithPath:tableAccount] documentWithPath:account.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addAccountTypeToFirestore:(AccountType*)accountType{
    NSMutableDictionary* muDic = [accountType dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableAccountType] documentWithPath:accountType.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addCategoryToFirestore:(Category*)category{
    NSMutableDictionary* muDic = [category dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableCategory] documentWithPath:category.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addBillRuleToFirestore:(EP_BillRule*)billRule{
    NSMutableDictionary* muDic = [billRule dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableBillRule] documentWithPath:billRule.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addBillItemToFirestore:(EP_BillItem*)billItem{
    NSMutableDictionary* muDic = [billItem dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableBillItem] documentWithPath:billItem.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addBudgetTemplateToFirestore:(BudgetTemplate*)budgetTemplate{
    NSMutableDictionary* muDic = [budgetTemplate dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableBudgetTemplate] documentWithPath:budgetTemplate.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addBudgetItemToFirestore:(BudgetItem*)budgetItem{
    NSMutableDictionary* muDic = [budgetItem dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableBudgetItem] documentWithPath:budgetItem.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

-(void)addBudgetTransferToFirestore:(BudgetTransfer*)budgerTransfer{
    NSMutableDictionary* muDic = [budgerTransfer dicWithItem];
    if (muDic) {
        [[[self.db collectionWithPath:tableBudgetTransfer] documentWithPath:budgerTransfer.uuid] setData:muDic completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
            } else {
                NSLog(@"Document successfully written!");
            }
        }];
    }
}

#pragma mark - batch add items
-(void)batchAllDataToFirestore{
    NSArray* transactionArray = [[XDDataManager shareManager] getObjectsFromTable:tableTransaction];
    if (transactionArray.count > 0) {
        NSArray* array = [self separateArray:transactionArray];
        for (int i = 0; i < array.count; i++) {
            [self batchAddTransactionsToFirestore:array[i]];
        }
    }
    
    
    return;
    
    NSArray* accountTypeArr = [[XDDataManager shareManager]getObjectsFromTable:tableAccountType];
    if (accountTypeArr.count > 0) {
        NSArray* array = [self separateArray:accountTypeArr];
        for (int i = 0; i < array.count; i++) {
            [self batchAddAccountTypeToFirestore:array[i]];
        }
    }
    
    NSArray* accountArr = [[XDDataManager shareManager]getObjectsFromTable:tableAccount];
    if (accountArr.count > 0) {
        NSArray* array = [self separateArray:accountArr];
        for (int i = 0; i < array.count; i++) {
            [self batchAddAccountToFirestore:array[i]];
        }
    }
    
    NSArray* categoryArr = [[XDDataManager shareManager]getObjectsFromTable:tableCategory];
    if (categoryArr.count > 0) {
        NSArray* array = [self separateArray:categoryArr];
        for (int i = 0; i < array.count; i++) {
            [self batchCategoryToFirestore:array[i]];
        }
    }
    
    NSArray* budgetTempleArr = [[XDDataManager shareManager]getObjectsFromTable:tableBudgetTemplate];
    if (budgetTempleArr.count > 0) {
        NSArray* array = [self separateArray:budgetTempleArr];
        for (int i = 0; i < array.count; i++) {
            [self batchBudgetTemplateToFirestore:array[i]];
        }
    }
    
    NSArray* budgetItemArr = [[XDDataManager shareManager]getObjectsFromTable:tableBudgetItem];
    if (budgetItemArr.count > 0) {
        NSArray* array = [self separateArray:budgetItemArr];
        for (int i = 0; i < array.count; i++) {
            [self batchBudgetItemToFirestore:array[i]];
        }
    }
    
    NSArray* budgetTransferArr = [[XDDataManager shareManager]getObjectsFromTable:tableBudgetTransfer];
    if (budgetTransferArr.count > 0) {
        NSArray* array = [self separateArray:budgetTransferArr];
        for (int i = 0; i < array.count; i++) {
            [self batchBudgetTransferToFirestore:array[i]];
        }
    }
    
    NSArray* payeeArr = [[XDDataManager shareManager]getObjectsFromTable:tablePayee];
    if (payeeArr.count > 0) {
        NSArray* array = [self separateArray:payeeArr];
        for (int i = 0; i < array.count; i++) {
            [self batchAddPayeeToFirestore:array[i]];
        }
    }
    
    NSArray* billRuleArr = [[XDDataManager shareManager]getObjectsFromTable:tableBillRule];
    if (billRuleArr.count > 0) {
        NSArray* array = [self separateArray:billRuleArr];
        for (int i = 0; i < array.count; i++) {
            [self batchAddPayeeToFirestore:array[i]];
        }
    }
    
    NSArray* billItemArr = [[XDDataManager shareManager]getObjectsFromTable:tableBillItem];
    if (billItemArr.count > 0) {
        NSArray* array = [self separateArray:billItemArr];
        for (int i = 0; i < array.count; i++) {
            [self batchBillItemToFirestore:array[i]];
        }
    }
}

-(void)batchAddTransactionsToFirestore:(NSArray* )array{//每个事务或批量写入最多可以向 500 个文档写入数据
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i<array.count; i++) {
        Transaction* transaction = array[i];
        NSMutableDictionary* muDic = [self dicWithTransaction:transaction];
        FIRDocumentReference *nycRef =
        [[self.db collectionWithPath:tableTransaction] documentWithPath:transaction.uuid];
        [batch setData:muDic forDocument:nycRef];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchAddPayeeToFirestore:(NSArray* )array{//每个事务或批量写入最多可以向 500 个文档写入数据
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i<array.count; i++) {
        Payee* payee = array[i];
        NSMutableDictionary* muDic = [self dicWithPayee:payee];
        FIRDocumentReference *nycRef =
        [[self.db collectionWithPath:tablePayee] documentWithPath:payee.uuid];
        [batch setData:muDic forDocument:nycRef];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchAddAccountToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        Accounts* account = array[i];
        NSMutableDictionary* muDic = [self dicWithAccount:account];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableAccount] documentWithPath:account.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchAddAccountTypeToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        AccountType* accountType = array[i];
        NSMutableDictionary* muDic = [self dicWithAccountType:accountType];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableAccountType] documentWithPath:accountType.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchCategoryToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        Category* category = array[i];
        NSMutableDictionary* muDic = [self dicWithCategory:category];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableCategory] documentWithPath:category.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchBillRuleToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        EP_BillRule* billRule = array[i];
        NSMutableDictionary* muDic = [self dicWithBillRule:billRule];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableBillRule] documentWithPath:billRule.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchBillItemToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        EP_BillItem* billItem = array[i];
        NSMutableDictionary* muDic = [self dicWithBillItem:billItem];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableBillItem] documentWithPath:billItem.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchBudgetTemplateToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        BudgetTemplate* budgetTemplate = array[i];
        NSMutableDictionary* muDic = [self dicWithBudgetTemplate:budgetTemplate];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableBudgetTemplate] documentWithPath:budgetTemplate.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchBudgetItemToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        BudgetItem* budgetItem = array[i];
        NSMutableDictionary* muDic = [self dicWithBudgetItem:budgetItem];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableBudgetItem] documentWithPath:budgetItem.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

-(void)batchBudgetTransferToFirestore:(NSArray*)array{
    FIRWriteBatch *batch = [self.db batch];
    for (int i = 0; i < array.count; i++) {
        BudgetTransfer* budgetTransfer = array[i];
        NSMutableDictionary* muDic = [self dicWithBudgetTransfer:budgetTransfer];
        FIRDocumentReference* ref = [[self.db collectionWithPath:tableBudgetTransfer] documentWithPath:budgetTransfer.uuid];
        [batch setData:muDic forDocument:ref];
    }
    
    // Commit the batch
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing batch %@", error);
        } else {
            NSLog(@"Batch write succeeded.");
        }
    }];
}

#pragma mark - download data
-(void)downloadItemTable:(NSString*)tableName{
    [[[self.db collectionWithPath:tableName] queryWhereField:@"user_id" isEqualTo:self.user.uid]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 NSLog(@"%@ => %@", document.documentID, document.data);
             }
         }
     }];
}


#pragma mark - listen data

-(void)listenAllTable{
    if (!self.user) {
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableAccountType completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithAccountTypeDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableAccount completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithAccountDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableCategory completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithCategoryDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableBudgetTemplate completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalBudgetTemplateDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableBudgetItem completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalBudgetItemDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableBudgetTransfer completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalBudgetTransferDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tablePayee completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithPayeeDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableBillRule completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalBillRuleDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenItemTable:tableBillItem completion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalBillItemDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenParentTransaction:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithTransactionDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self listenChildTransacion:^(FIRQuerySnapshot *snapshot) {
            [self.backgroundContext performBlock:^{
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    [self optionalWithTransactionDic:diff.document.data type:diff.type];
                }
                [self.backgroundContext save:nil];
                [self.mainContext performBlock:^{
                    [self.mainContext save:nil];
                }];
            }];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"listen completion");
    });
    
}

-(void)listenParentTransaction:(void(^)(FIRQuerySnapshot* snapshot))completion{
    FIRCollectionReference* ref = [self.db collectionWithPath:tableTransaction];
    [[[ref queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isEqualTo:[NSNull null]] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            NSLog(@"Error fetching documents: %@", error);
            return;
        }
        if (completion) {
            completion(snapshot);
        }
    }];
}

-(void)listenChildTransacion:(void(^)(FIRQuerySnapshot* snapshot))completion{
    FIRCollectionReference* ref = [self.db collectionWithPath:tableTransaction];
    [[[ref queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isGreaterThan:@""] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            NSLog(@"Error fetching documents: %@", error);
            return;
        }
        if (completion) {
            completion(snapshot);
        }
    }];
}

-(void)listenItemTable:(NSString*)tableName completion:(void(^)(FIRQuerySnapshot* snapshot))completion{
    [[[self.db collectionWithPath:tableName] queryWhereField:@"user_id" isEqualTo:self.user.uid]
     addSnapshotListener:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (snapshot == nil) {
             NSLog(@"Error fetching documents: %@", error);
             return;
         }
         if (completion) {
             completion(snapshot);
         }
     }];
}

#pragma mark - item to local with optional
-(void)optionalWithTransactionDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        Transaction* transaction = [self backgroundInsertObjectToTable:tableTransaction];
        [self assignTransactionLocal:transaction WithDic:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        Transaction* transaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (transaction) {
            [self assignTransactionLocal:transaction WithDic:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        Transaction* transaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (transaction) {
            [self.backgroundContext deleteObject:transaction];
        }
    }
}

-(void)optionalWithCategoryDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        Category* category = [self backgroundInsertObjectToTable:tableCategory];
        [self assignCategoryLocal:category WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (category) {
            [self assignCategoryLocal:category WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (category) {
            [self.backgroundContext deleteObject:category];
        }
    }
}


-(void)optionalWithAccountDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        Accounts* account = [self backgroundInsertObjectToTable:tableAccount];
        [self assignAccountLocal:account WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        Accounts* account  = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self assignAccountLocal:account WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        Accounts* account  = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self.backgroundContext deleteObject:account];
        }
    }
}


-(void)optionalWithAccountTypeDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        AccountType* account = [self backgroundInsertObjectToTable:tableAccountType];
        [self assignAccountTypeLocal:account WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        AccountType* account  = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self assignAccountTypeLocal:account WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        AccountType* account  = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self.backgroundContext deleteObject:account];
        }
    }
}


-(void)optionalWithPayeeDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        Payee* payee = [self backgroundInsertObjectToTable:tablePayee];
        [self assignPayeeLocal:payee WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        Payee* payee  = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (payee) {
            [self assignPayeeLocal:payee WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        Payee* payee  = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (payee) {
            [self.backgroundContext deleteObject:payee];
        }
    }
}

-(void)optionalBillRuleDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        EP_BillRule* billRule = [self backgroundInsertObjectToTable:tableBillRule];
        [self assignBillRuleLocal:billRule WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        EP_BillRule* billRule  = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billRule) {
            [self assignBillRuleLocal:billRule WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        EP_BillRule* billRule  = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billRule) {
            [self.backgroundContext deleteObject:billRule];
        }
    }
}

-(void)optionalBillItemDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        EP_BillItem* billItem = [self backgroundInsertObjectToTable:tableBillItem];
        [self assignBillItemLocal:billItem WithServer:dic];
        
    }
    if (type == FIRDocumentChangeTypeModified) {
        EP_BillItem* billItem  = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billItem) {
            [self assignBillItemLocal:billItem WithServer:dic];
        }
    }
    if (type == FIRDocumentChangeTypeRemoved) {
        EP_BillItem* billItem  = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billItem) {
            [self.backgroundContext deleteObject:billItem];
        }
    }
}

-(void)optionalBudgetItemDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        BudgetItem* item = [self backgroundInsertObjectToTable:tableBudgetItem];
        [self assignBudgetItemLocal:item WithServer:dic];
    }
    
     if (type == FIRDocumentChangeTypeModified) {
         BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
         if (item) {
             [self assignBudgetItemLocal:item WithServer:dic];
         }
     }
    
    if (type == FIRDocumentChangeTypeRemoved) {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}

-(void)optionalBudgetTemplateDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        BudgetTemplate* item = [self backgroundInsertObjectToTable:tableBudgetTemplate];
        [self assignBudgetTemplateLocal:item WithServer:dic];
    }
    
    if (type == FIRDocumentChangeTypeModified) {
        BudgetTemplate* item = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self assignBudgetTemplateLocal:item WithServer:dic];
        }
    }
    
    if (type == FIRDocumentChangeTypeRemoved) {
        BudgetTemplate* item = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}

-(void)optionalBudgetTransferDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        BudgetTransfer* item = [self backgroundInsertObjectToTable:tableBudgetTransfer];
        [self assignBudgetTransfer:item WithServer:dic];
    }
    
    if (type == FIRDocumentChangeTypeModified) {
        BudgetTransfer* item = [[self backgroundGetObjectsFromTable:tableBudgetTransfer predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self assignBudgetTransfer:item WithServer:dic];
        }
    }
    
    if (type == FIRDocumentChangeTypeRemoved) {
        BudgetTransfer* item = [[self backgroundGetObjectsFromTable:tableBudgetTransfer predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}


#pragma mark - assign items

-(void)assignTransactionLocal:(Transaction *)transaction WithDic:(NSDictionary *)objectServer
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
    transaction.isUpload = @"1";
    if (objectServer[@"category"]!=nil) {
        if ([objectServer[@"category"] isEqualToString:@"4349B269-0856-436E-98E0-D5C5DE0B289D"]) {
            Category * category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",@"4349B269-0856-436E-98E0-D5C5DE0B289D"] sortDescriptors:nil]lastObject];
            if (category) {
                transaction.category = category;
            }else{
                Category* category1 = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",@"FFA1E895-9680-478F-A2F1-13EBD90EC35E"] sortDescriptors:nil]lastObject];
                if (category1) {
                    transaction.category = category1;
                }else{
                    Category* category2 = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",@"CA6C55B4-2B95-4921-9AE4-74E76A253426"] sortDescriptors:nil]lastObject];
                    if (category1) {
                        transaction.category = category2;
                    }
                }
            }
        }else{
            Category * category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]] sortDescriptors:nil]lastObject];
            if (category) {
                transaction.category = category;
            }
        }
    }else{
        transaction.category = nil;
    }
    
    if (objectServer[@"expenseAccount"]!=nil){
        Accounts* account = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"expenseAccount"]] sortDescriptors:nil]lastObject];
        if (account) {
            transaction.expenseAccount = account;
        }else{
            transaction.expenseAccount = nil;
        }
    }
    
    if (objectServer[@"incomeAccount"]!=nil){
        Accounts* account = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"incomeAccount"]] sortDescriptors:nil]lastObject];
        if (account) {
            transaction.incomeAccount = account;
        }else{
            transaction.incomeAccount = nil;
        }
    }
    
    if (objectServer[@"parTransaction"]!=nil){
        Transaction* parTransaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]] sortDescriptors:nil]lastObject];
        if (parTransaction) {
            transaction.parTransaction = parTransaction;
        }else{
            transaction.parTransaction = nil;
        }
    }
    
    if (objectServer[@"payee"]!=nil){
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"payee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            transaction.payee = payee;
        }else{
            transaction.payee = nil;
        }
    }
    
    if (objectServer[@"transactionHasBillItem"]!=nil){
        EP_BillItem* billItem = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"transactionHasBillItem"]] sortDescriptors:nil]lastObject];
        if (billItem) {
            transaction.transactionHasBillItem = billItem;
        }else{
            transaction.transactionHasBillItem = nil;
        }
    }
    
    if (objectServer[@"transactionHasBillRule"]!=nil){
        EP_BillRule* billRule = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"transactionHasBillRule"]] sortDescriptors:nil]lastObject];
        if (billRule) {
            transaction.transactionHasBillRule = billRule;
        }else{
            transaction.transactionHasBillRule = nil;
        }
    }
    
    //图片未作处理
}


-(void)assignAccountTypeLocal:(AccountType *)accountType WithServer:(NSDictionary *)objectServer
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

-(void)assignAccountLocal:(Accounts *)account WithServer:(NSDictionary *)objectServer
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
        AccountType* accountType = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"accountType"]] sortDescriptors:nil]lastObject];
        if (accountType) {
            account.accountType = accountType;
        }
    }
}

-(void)assignCategoryLocal:(Category *)category WithServer:(NSDictionary *)objectServer
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
    
}

-(void)assignPayeeLocal:(Payee *)payee WithServer:(NSDictionary *)objectServer
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
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]] sortDescriptors:nil]lastObject];
        if (category) {
            payee.category = category;
        }
    }
}

-(void)assignBillRuleLocal:(EP_BillRule *)billRule WithServer:(NSDictionary *)objectServer
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
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasCategory"]] sortDescriptors:nil]lastObject];
        if (category) {
            billRule.billRuleHasCategory = category;
        }
    }
    if (objectServer[@"billRuleHasPayee"]!=nil)
    {
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasPayee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            billRule.billRuleHasPayee = payee;
        }
    }
}

-(void)assignBillItemLocal:(EP_BillItem *)billItem WithServer:(NSDictionary *)objectServer
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
        EP_BillRule* billRule = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasBillRule"]] sortDescriptors:nil]lastObject];
        if (billRule)
        {
            billItem.billItemHasBillRule=billRule;
        }
    }
    if (objectServer[@"billItemHasCategory"])
    {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasCategory"]] sortDescriptors:nil]lastObject];
        if (category)
        {
            billItem.billItemHasCategory=category;
        }
    }
    if (objectServer[@"billItemHasPayee"]!=nil)
    {
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasPayee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            billItem.billItemHasPayee = payee;
        }
    }
}

-(void)assignBudgetItemLocal:(BudgetItem *)budgetItem WithServer:(NSDictionary *)objectServer
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
        BudgetTemplate* template = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"budgetTemplate"]] sortDescriptors:nil]lastObject];
        if (template)
        {
            budgetItem.budgetTemplate=template;
        }
    }
}

-(void)assignBudgetTransfer:(BudgetTransfer *)budgetTransfer WithServer:(NSDictionary *)objectServer
{
    budgetTransfer.amount=objectServer[@"amount"];
    budgetTransfer.dateTime=objectServer[@"dateTime"];
    budgetTransfer.dateTime_sync=objectServer[@"dateTimeSync"];
    budgetTransfer.state=objectServer[@"state"];
    budgetTransfer.uuid=objectServer[@"uuid"];
    budgetTransfer.updatedTime=objectServer[@"updatedTime"];
    if (objectServer[@"fromBudget"]!=nil)
    {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"fromBudget"]] sortDescriptors:nil]lastObject];
        if (item)
        {
            budgetTransfer.fromBudget = item;
        }
    }
    if (objectServer[@"toBudget"]!=nil)
    {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"toBudget"]] sortDescriptors:nil]lastObject];
        if (item) {
            budgetTransfer.toBudget = item;
        }
    }
}


-(void)assignBudgetTemplateLocal:(BudgetTemplate *)budgetTemplate WithServer:(NSDictionary *)objectServer
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
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]] sortDescriptors:nil]lastObject];
        if (category)
        {
            budgetTemplate.category=category;
        }
    }
}

#pragma mark - other

-(NSMutableArray*)separateArray:(NSArray*)array{
    NSInteger count = array.count / 500;
    NSInteger over = array.count % 500;
    
    NSMutableArray* muArr = [NSMutableArray array];
    for (int i = 0; i <= count; i++) {
        NSInteger last = array.count - i* 500;
        
        if (last == 0) {
            break;
        }
        NSArray* arr = [NSArray array];
        
        if (last >= 500) {
            arr = [array subarrayWithRange:NSMakeRange(i*500, 500)];
        }else{
            arr = [array subarrayWithRange:NSMakeRange(i*500, over)];
        }
        
        [muArr addObject:arr];
    }
    return muArr;
}
@end

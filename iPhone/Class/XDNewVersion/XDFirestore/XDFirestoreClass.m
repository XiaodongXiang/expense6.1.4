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
        if (transaction.payee) {
            [muDic setValue:transaction.payee.uuid forKey:@"payee"];
        }
        if (transaction.category) {
            [muDic setValue:transaction.category.uuid forKey:@"category"];
        }
        if (transaction.expenseAccount) {
            [muDic setValue:transaction.expenseAccount.uuid forKey:@"expenseAccount"];
        }
        if (transaction.incomeAccount) {
            [muDic setValue:transaction.incomeAccount.uuid forKey:@"incomeAccount"];
        }
        if (transaction.transactionHasBillItem) {
            [muDic setValue:transaction.transactionHasBillItem.uuid forKey:@"transactionHasBillItem"];
        }
        if (transaction.transactionHasBillRule) {
            [muDic setValue:transaction.transactionHasBillRule.uuid forKey:@"transactionHasBillRule"];
        }
        if (transaction.parTransaction) {
            [muDic setValue:transaction.parTransaction.uuid forKey:@"parTransaction"];
        }
        [muDic removeObjectForKey:@"childTransactions"];
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        //照片暂时没存
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithPayee:(Payee*)payee{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[payee dicWithItem]];
    if (muDic && self.user) {
        if (payee.category) {
            [muDic setValue:payee.category.uuid forKey:@"category"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"billItem"];
        [muDic removeObjectForKey:@"payeeHasBillItem"];
        [muDic removeObjectForKey:@"payeeHasBillRule"];
        [muDic removeObjectForKey:@"transaction"];

        return muDic;
    }
    
    return nil;
}

-(NSMutableDictionary*)dicWithAccount:(Accounts*)account{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[account dicWithItem]];
    if (muDic && self.user) {
        if (account.accountType) {
            [muDic setValue:account.accountType.uuid forKey:@"accountType"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic removeObjectForKey:@"expenseTransactions"];
        [muDic removeObjectForKey:@"fromBill"];
        [muDic removeObjectForKey:@"incomeTransactions"];
        [muDic removeObjectForKey:@"toBill"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];

        return muDic;
    }
    
    return nil;
}


-(NSMutableDictionary*)dicWithAccountType:(AccountType*)accountType{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[accountType dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic removeObjectForKey:@"accounts"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];

        return muDic;
    }
    return nil;
}


-(NSMutableDictionary*)dicWithCategory:(Category*)category{
    
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[category dicWithItem]];
    if (muDic && self.user) {
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"billItem"];
        [muDic removeObjectForKey:@"categoryHasBillItem"];
        [muDic removeObjectForKey:@"categoryHasBillRule"];
        [muDic removeObjectForKey:@"payee"];
        [muDic removeObjectForKey:@"transactions"];
        [muDic removeObjectForKey:@"budgetTemplate"];

        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBillRule:(EP_BillRule*)billRule{
    
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[billRule dicWithItem]];
    if (muDic && self.user) {
        if (billRule.billRuleHasCategory) {
            [muDic setValue:billRule.billRuleHasCategory.uuid forKey:@"billRuleHasCategory"];
        }
        if (billRule.billRuleHasPayee) {
            [muDic setValue:billRule.billRuleHasPayee.uuid forKey:@"billRuleHasPayee"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"billRuleHasBillItem"];
        [muDic removeObjectForKey:@"billRuleHasTransaction"];

        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBillItem:(EP_BillItem*)billItem{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[billItem dicWithItem]];
    if (muDic && self.user) {
        if (billItem.billItemHasBillRule) {
            [muDic setValue:billItem.billItemHasBillRule.uuid forKey:@"billItemHasBillRule"];
        }
        if (billItem.billItemHasCategory) {
            [muDic setValue:billItem.billItemHasCategory.uuid forKey:@"billItemHasCategory"];
        }
        if (billItem.billItemHasPayee) {
            [muDic setValue:billItem.billItemHasPayee.uuid forKey:@"billItemHasPayee"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"billItemHasTransaction"];
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetTemplate:(BudgetTemplate*)budgetTemplate{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetTemplate dicWithItem]];
    if (muDic && self.user) {
        if (budgetTemplate.category.uuid) {
            [muDic setValue:budgetTemplate.category.uuid forKey:@"category"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"budgetItems"];
        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetItem:(BudgetItem*)budgetItem{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetItem dicWithItem]];
    if (muDic && self.user) {
        if (budgetItem.budgetTemplate) {
            [muDic setValue:budgetItem.budgetTemplate.uuid forKey:@"budgetTemplate"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];
        [muDic removeObjectForKey:@"fromTransfer"];
        [muDic removeObjectForKey:@"toTransfer"];

        return muDic;
    }
    return nil;
}

-(NSMutableDictionary*)dicWithBudgetTransfer:(BudgetTransfer*)budgetTransfer{
    NSMutableDictionary* muDic = [NSMutableDictionary dictionaryWithDictionary:[budgetTransfer dicWithItem]];
    if (muDic && self.user) {
        if (budgetTransfer.toBudget) {
            [muDic setValue:budgetTransfer.toBudget.uuid forKey:@"toBudget"];
        }
        if (budgetTransfer.fromBudget) {
            [muDic setValue:budgetTransfer.fromBudget.uuid forKey:@"fromBudget"];
        }
        [muDic setValue:[FIRAuth auth].currentUser.uid forKey:@"user_id"];
        [muDic setValue:[FIRFieldValue fieldValueForServerTimestamp] forKey:@"updatedTime"];

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
    if (!self.user) {
        return;
    }
    NSArray* transactionArray = [[XDDataManager shareManager] getObjectsFromTable:tableTransaction];
    if (transactionArray.count > 0) {
        NSArray* array = [self separateArray:transactionArray];
        for (int i = 0; i < array.count; i++) {
            [self batchAddTransactionsToFirestore:array[i]];
        }
    }
    
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
            [self batchBillRuleToFirestore:array[i]];
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

-(void)downloadAllData{
    FIRFirestoreSettings *settings = [[FIRFirestoreSettings alloc] init];
    settings.persistenceEnabled = NO;
    self.db.settings = settings;
    
    if (!self.user) {
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    FIRDocumentChangeType* type = FIRDocumentChangeTypeAdded;
    
    NSMutableArray* accountTypeMuArr = [NSMutableArray array];
    NSMutableArray* accountMuArr = [NSMutableArray array];
    NSMutableArray* payeeMuArr = [NSMutableArray array];
    NSMutableArray* billRuleMuArr = [NSMutableArray array];
    NSMutableArray* billItemMuArr = [NSMutableArray array];
    NSMutableArray* budgetItemMuArr = [NSMutableArray array];
    NSMutableArray* budgetTransferMuArr = [NSMutableArray array];
    NSMutableArray* budgetTemplateMuArr = [NSMutableArray array];
    NSMutableArray* categoryMuArr = [NSMutableArray array];
    NSMutableArray* childTranMuArr = [NSMutableArray array];
    NSMutableArray* parTranMuArr = [NSMutableArray array];
    
    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableAccountType completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [accountTypeMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableAccount completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [accountMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableCategory completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [categoryMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);
        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableBudgetTemplate completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [budgetTemplateMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableBudgetItem completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [budgetItemMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableBudgetTransfer completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [budgetTransferMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];

    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tablePayee completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [payeeMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);
        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableBillRule completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [billRuleMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];

    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [self downloadItemTable:tableBillItem completion:^(FIRQuerySnapshot *snapshot,NSError * error) {
            if (!error) {
                [billItemMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);

        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{

        [[[[self.db collectionWithPath:tableTransaction] queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isEqualTo:[NSNull null]] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (!error) {
                [parTranMuArr addObjectsFromArray:snapshot.documents];
            }

            dispatch_group_leave(group);
        }];
    });

    dispatch_group_enter(group);
    dispatch_async(q, ^{
        [[[[self.db collectionWithPath:tableTransaction] queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isGreaterThan:@""] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (!error) {
                [childTranMuArr addObjectsFromArray:snapshot.documents];
            }
            dispatch_group_leave(group);
        }];
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self.backgroundContext performBlock:^{
            
                if (accountTypeMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in accountTypeMuArr) {
                        [self optionalWithAccountTypeDic:document.data type:type];
                    }
                }
            
                if (accountMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in accountMuArr) {
                        [self optionalWithAccountDic:document.data type:type];
                    }
                }
            
                if (categoryMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in categoryMuArr) {
                        [self optionalWithCategoryDic:document.data type:type];
                    }
                }
            
                if (budgetTemplateMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in budgetTemplateMuArr) {
                        [self optionalBudgetTemplateDic:document.data type:type];
                    }
                }
            
                if (budgetItemMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in budgetItemMuArr) {
                        [self optionalBudgetItemDic:document.data type:type];
                    }
                }
            
                if (budgetTransferMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in budgetTransferMuArr) {
                        [self optionalBudgetTransferDic:document.data type:type];
                    }
                }
            
                if (payeeMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in payeeMuArr) {
                        [self optionalWithPayeeDic:document.data type:type];
                    }
                }
            
                if (billRuleMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in billRuleMuArr) {
                        [self optionalBillRuleDic:document.data type:type];
                    }
                }
            
                if (billItemMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in billItemMuArr) {
                        [self optionalBillItemDic:document.data type:type];
                    }
                }
            
                if (parTranMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in parTranMuArr) {
                        [self optionalWithTransactionDic:document.data type:type];
                    }
                }
            
                if (childTranMuArr.count > 0) {
                    for (FIRDocumentSnapshot *document in childTranMuArr) {
                        [self optionalWithTransactionDic:document.data type:type];
                    }
                }
            
            [self.backgroundContext save:nil];
            [self.mainContext performBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
                [self.mainContext save:nil];
            }];
        }];
    });
}

-(void)downloadItemTable:(NSString*)tableName completion:(void(^)(FIRQuerySnapshot *snapshot , NSError * error))completion{
    [[[self.db collectionWithPath:tableName] queryWhereField:@"user_id" isEqualTo:self.user.uid]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
         } else {
             if (completion) {
                 completion(snapshot,error);
                 NSLog(@"download %@ success",tableName);
             }
         }
     }];
}


#pragma mark - listen data

-(void)listenAllTable{
        if (!self.user) {
            return;
        }
    
        [self listenItemTable:tableAccountType completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalWithAccountTypeDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableAccount completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    NSMutableArray* muArr = [NSMutableArray array];
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        NSString* accountTypeID = [diff.document.data[@"accountType"]isNull];
                        if (accountTypeID != nil){
                            AccountType* accountType = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",accountTypeID] sortDescriptors:nil]lastObject];
                            if (!accountType) {
                                [muArr addObject:diff.document.data];
                            }else{
                                [self optionalWithAccountDic:diff.document.data type:diff.type];
                            }
                        }
                    }
                    if (muArr.count > 0) {
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_queue_t q = dispatch_get_global_queue(0, 0);

                        for (NSDictionary* dic in muArr) {
                            dispatch_group_enter(group);
                            dispatch_async(q, ^{
                                FIRCollectionReference *ref = [self.db collectionWithPath:tableAccountType];
                                [ref queryWhereField:@"user_id" isEqualTo:self.user.uid];
                                [ref queryWhereField:@"uuid" isEqualTo:[dic[@"accountType"]isNull]];
                                [ref getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                                    if (!error) {
                                        for (FIRDocumentSnapshot *document in snapshot.documents) {
                                            [self optionalWithAccountTypeDic:document.data type:FIRDocumentChangeTypeAdded];
                                        }
                                    }
                                    dispatch_group_leave(group);
                                }];
                            });
                        }
                        
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            for (NSDictionary* dic in muArr) {
                                [self optionalWithAccountDic:dic type:FIRDocumentChangeTypeAdded];
                            }
                        });
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableCategory completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalWithCategoryDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableBudgetTemplate completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    NSMutableArray* muArr = [NSMutableArray array];
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        NSString* categoryID = [diff.document.data[@"category"]isNull];
                        if (categoryID) {
                            Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",categoryID] sortDescriptors:nil]lastObject];
                            if (category) {
                                [self optionalBudgetTemplateDic:diff.document.data type:diff.type];
                            }else{
                                [muArr addObject:diff.document.data];
                            }
                        }
                    }
                    
                    if (muArr.count > 0) {
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
                        
                        for (NSDictionary* dic in muArr) {
                            dispatch_group_enter(group);
                            dispatch_async(q, ^{
                                FIRCollectionReference *ref = [self.db collectionWithPath:tableCategory];
                                [ref queryWhereField:@"user_id" isEqualTo:self.user.uid];
                                [ref queryWhereField:@"uuid" isEqualTo:[dic[@"category"]isNull]];
                                [ref getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                                    if (!error) {
                                        for (FIRDocumentSnapshot *document in snapshot.documents) {
                                            [self optionalWithCategoryDic:document.data type:FIRDocumentChangeTypeAdded];
                                        }
                                    }
                                    dispatch_group_leave(group);
                                }];
                            });
                        }
                        
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            for (NSDictionary* dic in muArr) {
                                [self optionalBudgetTemplateDic:dic type:FIRDocumentChangeTypeAdded];
                            }
                        });
                    }
                    
                    

                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
        
        [self listenItemTable:tableBudgetItem completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    NSMutableArray* muArr = [NSMutableArray array];
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        NSString* budgetTempleID = [diff.document.data[@"budgetTemplate"] isNull];
                        if (budgetTempleID) {
                            BudgetTemplate* budgetTemplate = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",budgetTempleID] sortDescriptors:nil]lastObject];
                            if (budgetTemplate) {
                                [self optionalBudgetItemDic:diff.document.data type:diff.type];
                            }else{
                                [muArr addObject:diff.document.data];
                            }
                        }
                    }
                    if (muArr.count > 0) {
                        
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
                        
                        for (NSDictionary* dic in muArr) {
                            dispatch_group_enter(group);
                            dispatch_async(q, ^{
                                FIRCollectionReference *ref = [self.db collectionWithPath:tableBudgetTemplate];
                                [ref queryWhereField:@"user_id" isEqualTo:self.user.uid];
                                [ref queryWhereField:@"uuid" isEqualTo:[dic[@"budgetTemplate"]isNull]];
                                [ref getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                                    if (!error) {
                                        for (FIRDocumentSnapshot *document in snapshot.documents) {
                                            [self optionalBudgetTemplateDic:document.data type:FIRDocumentChangeTypeAdded];
                                        }
                                    }
                                    dispatch_group_leave(group);
                                }];
                            });
                        }
                        
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            for (NSDictionary* dic in muArr) {
                                [self optionalBudgetItemDic:dic type:FIRDocumentChangeTypeAdded];
                            }
                        });
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableBudgetTransfer completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    NSMutableSet* muArr = [NSMutableSet set];
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        NSString* fromBudget = [diff.document.data[@"fromBudget"]isNull];
                        NSString* toBudget = [diff.document.data[@"toBudget"]isNull];
                        BudgetItem* fromItem = nil;
                        BudgetItem* toItem = nil;
                        if (fromBudget) {
                            fromItem = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",fromBudget] sortDescriptors:nil]lastObject];
                            if (!fromItem) {
                                [muArr addObject:fromBudget];
                            }
                        }
                        if (toBudget) {
                            toItem = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",toBudget] sortDescriptors:nil]lastObject];
                            if (!toBudget) {
                                [muArr addObject:toBudget];
                            }
                        }
                        if (fromItem && toBudget) {
                            [self optionalBudgetTransferDic:diff.document.data type:diff.type];
                        }
                    }
                    
                    if (muArr.count > 0) {
                        
                        dispatch_group_t group = dispatch_group_create();
                        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
                        
                        for (NSString* uuid in muArr) {
                            dispatch_group_enter(group);
                            dispatch_async(q, ^{
                                FIRCollectionReference *ref = [self.db collectionWithPath:tableBudgetItem];
                                [ref queryWhereField:@"user_id" isEqualTo:self.user.uid];
                                [ref queryWhereField:@"uuid" isEqualTo:uuid];
                                [ref getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                                    if (!error) {
                                        for (FIRDocumentSnapshot *document in snapshot.documents) {
                                            [self optionalBudgetItemDic:document.data type:FIRDocumentChangeTypeAdded];
                                        }
                                    }
                                    dispatch_group_leave(group);
                                }];
                            });
                        }
                        
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            for (NSDictionary* dic in muArr) {
                                [self optionalBudgetTransferDic:dic type:FIRDocumentChangeTypeAdded];
                            }
                        });
                    }
                    
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tablePayee completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalWithPayeeDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableBillRule completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalBillRuleDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenItemTable:tableBillItem completion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalBillItemDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenChildTransacion:^(FIRQuerySnapshot *snapshot, NSError * _Nullable error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalWithTransactionDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
    
        [self listenParentTransaction:^(FIRQuerySnapshot *snapshot, NSError * _Nullable error) {
            if (!error) {
                [self.backgroundContext performBlock:^{
                    for (FIRDocumentChange *diff in snapshot.documentChanges) {
                        [self optionalWithTransactionDic:diff.document.data type:diff.type];
                    }
                    [self.backgroundContext save:nil];
                    [self.mainContext performBlock:^{
                        [self.mainContext save:nil];
                    }];
                }];
            }
        }];
}

-(void)listenParentTransaction:(void(^)(FIRQuerySnapshot* snapshot, NSError * _Nullable error))completion{
    FIRCollectionReference* ref = [self.db collectionWithPath:tableTransaction];
    [[[ref queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isEqualTo:[NSNull null]] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            NSLog(@"Error fetching documents: %@", error);
            return;
        }
        if (completion) {
            completion(snapshot,error);
        }
    }];
}

-(void)listenChildTransacion:(void(^)(FIRQuerySnapshot* snapshot, NSError * _Nullable error))completion{
    FIRCollectionReference* ref = [self.db collectionWithPath:tableTransaction];
    [[[ref queryWhereField:@"user_id" isEqualTo:self.user.uid] queryWhereField:@"parTransaction" isGreaterThan:@""] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            NSLog(@"Error fetching documents: %@", error);
            return;
        }
        if (completion) {
            completion(snapshot,error);
        }
    }];
}

-(void)listenItemTable:(NSString*)tableName completion:(void(^)(FIRQuerySnapshot* snapshot, NSError *error))completion{
    [[[self.db collectionWithPath:tableName] queryWhereField:@"user_id" isEqualTo:self.user.uid]
     addSnapshotListener:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (snapshot == nil) {
             NSLog(@"Error fetching documents: %@", error);
             return;
         }
         if (completion) {
             completion(snapshot,error);
         }
     }];
}

#pragma mark - item to local with optional
-(void)optionalWithTransactionDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        Transaction* isExist = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            Transaction* transaction = [self backgroundInsertObjectToTable:tableTransaction];
            [self assignTransactionLocal:transaction WithDic:dic];
        }else{
            [self assignTransactionLocal:isExist WithDic:dic];
        }
        
    }else if (type == FIRDocumentChangeTypeModified) {
        Transaction* transaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (transaction) {
            [self assignTransactionLocal:transaction WithDic:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        Transaction* transaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (transaction) {
            [self.backgroundContext deleteObject:transaction];
        }
    }
}

-(void)optionalWithCategoryDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        Category* isExist = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            Category* category = [self backgroundInsertObjectToTable:tableCategory];
            [self assignCategoryLocal:category WithServer:dic];
        }else{
            [self assignCategoryLocal:isExist WithServer:dic];
        }
        
    }else if (type == FIRDocumentChangeTypeModified) {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (category) {
            [self assignCategoryLocal:category WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (category) {
            [self.backgroundContext deleteObject:category];
        }
    }
}


-(void)optionalWithAccountDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        Accounts* isExist = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            Accounts* account = [self backgroundInsertObjectToTable:tableAccount];
            [self assignAccountLocal:account WithServer:dic];
        }else{
            [self assignAccountLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        Accounts* account  = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self assignAccountLocal:account WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        Accounts* account  = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self.backgroundContext deleteObject:account];
        }
    }
}


-(void)optionalWithAccountTypeDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        AccountType* isExist = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            AccountType* account = [self backgroundInsertObjectToTable:tableAccountType];
            [self assignAccountTypeLocal:account WithServer:dic];
        }else{
            [self assignAccountTypeLocal:isExist WithServer:dic];
        }
        
    }else if (type == FIRDocumentChangeTypeModified) {
        AccountType* account  = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self assignAccountTypeLocal:account WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        AccountType* account  = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (account) {
            [self.backgroundContext deleteObject:account];
        }
    }
}


-(void)optionalWithPayeeDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        Payee* isExist = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            Payee* payee = [self backgroundInsertObjectToTable:tablePayee];
            [self assignPayeeLocal:payee WithServer:dic];
        }else{
            [self assignPayeeLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        Payee* payee  = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (payee) {
            [self assignPayeeLocal:payee WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        Payee* payee  = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (payee) {
            [self.backgroundContext deleteObject:payee];
        }
    }
}

-(void)optionalBillRuleDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        EP_BillRule* isExist = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            EP_BillRule* billRule = [self backgroundInsertObjectToTable:tableBillRule];
            [self assignBillRuleLocal:billRule WithServer:dic];
        }else{
            [self assignBillRuleLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        EP_BillRule* billRule  = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billRule) {
            [self assignBillRuleLocal:billRule WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        EP_BillRule* billRule  = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billRule) {
            [self.backgroundContext deleteObject:billRule];
        }
    }
}

-(void)optionalBillItemDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        EP_BillItem* isExist = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            EP_BillItem* billItem = [self backgroundInsertObjectToTable:tableBillItem];
            [self assignBillItemLocal:billItem WithServer:dic];
        }else{
            [self assignBillItemLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        EP_BillItem* billItem  = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billItem) {
            [self assignBillItemLocal:billItem WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        EP_BillItem* billItem  = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (billItem) {
            [self.backgroundContext deleteObject:billItem];
        }
    }
}

-(void)optionalBudgetItemDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        BudgetItem* isExist = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            BudgetItem* item = [self backgroundInsertObjectToTable:tableBudgetItem];
            [self assignBudgetItemLocal:item WithServer:dic];
        }else{
            [self assignBudgetItemLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
         BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
         if (item) {
             [self assignBudgetItemLocal:item WithServer:dic];
         }
     }else if (type == FIRDocumentChangeTypeRemoved) {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}

-(void)optionalBudgetTemplateDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        BudgetTemplate* isExist = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            BudgetTemplate* item = [self backgroundInsertObjectToTable:tableBudgetTemplate];
            [self assignBudgetTemplateLocal:item WithServer:dic];
        }else{
            [self assignBudgetTemplateLocal:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        BudgetTemplate* item = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self assignBudgetTemplateLocal:item WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        BudgetTemplate* item = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}

-(void)optionalBudgetTransferDic:(NSDictionary*)dic type:(FIRDocumentChangeType)type{
    NSString* uuid = dic[@"uuid"];
    if (type == FIRDocumentChangeTypeAdded) {
        NSString* uuid = [dic[@"uuid"]isNull];
        BudgetTransfer* isExist = [[self backgroundGetObjectsFromTable:tableBudgetTransfer predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (!isExist) {
            BudgetTransfer* item = [self backgroundInsertObjectToTable:tableBudgetTransfer];
            [self assignBudgetTransfer:item WithServer:dic];
        }else{
            [self assignBudgetTransfer:isExist WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeModified) {
        BudgetTransfer* item = [[self backgroundGetObjectsFromTable:tableBudgetTransfer predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self assignBudgetTransfer:item WithServer:dic];
        }
    }else if (type == FIRDocumentChangeTypeRemoved) {
        BudgetTransfer* item = [[self backgroundGetObjectsFromTable:tableBudgetTransfer predicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid] sortDescriptors:nil]lastObject];
        if (item) {
            [self.backgroundContext deleteObject:item];
        }
    }
}


#pragma mark - assign items

-(void)assignTransactionLocal:(Transaction *)transaction WithDic:(NSDictionary *)objectServer
{
    transaction.amount=[objectServer[@"amount"]isNull];
    transaction.dateTime=[objectServer[@"dateTime"]isNull];
    transaction.dateTime_sync=[objectServer[@"dateTime_Sync"]isNull];
    transaction.groupByDate=[objectServer[@"groupByDate"] isNull];
    transaction.isClear=[objectServer[@"isClear"]isNull];
    transaction.notes=[objectServer[@"notes"]isNull];
    transaction.orderIndex=[objectServer[@"orderIndex"]isNull];
    transaction.others=[objectServer[@"others"]isNull];
    transaction.recurringType=[objectServer[@"recurringType"]isNull];
    transaction.state=[objectServer[@"state"]isNull];
    transaction.transactionBool=[objectServer[@"transactionBool"]isNull];
    transaction.transactionstring=[objectServer[@"transactionstring"]isNull];
    transaction.transactionType=[objectServer[@"transactionType"]isNull];
    transaction.type=[objectServer[@"type"]isNull];
    transaction.uuid=[objectServer[@"uuid"]isNull];
    transaction.updatedTime=[objectServer[@"updatedTime"]isNull];
    transaction.isUpload = @"1";
    if (objectServer[@"category"]!=nil && objectServer[@"category"]!=[NSNull null]) {
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
                    if (category2) {
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
    
    if (objectServer[@"expenseAccount"]!=nil && objectServer[@"expenseAccount"]!=[NSNull null]){
        Accounts* account = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"expenseAccount"]] sortDescriptors:nil]lastObject];
        if (account) {
            transaction.expenseAccount = account;
        }else{
            transaction.expenseAccount = nil;
        }
    }else{
        transaction.expenseAccount = nil;
    }
    
    if (objectServer[@"incomeAccount"]!=nil  && objectServer[@"incomeAccount"]!=[NSNull null]){
        Accounts* account = [[self backgroundGetObjectsFromTable:tableAccount predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"incomeAccount"]] sortDescriptors:nil]lastObject];
        if (account) {
            transaction.incomeAccount = account;
        }else{
            transaction.incomeAccount = nil;
        }
    }else{
        transaction.incomeAccount = nil;
    }
    
    if (objectServer[@"parTransaction"]!=nil && objectServer[@"parTransaction"]!=[NSNull null]){
        Transaction* parTransaction = [[self backgroundGetObjectsFromTable:tableTransaction predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"parTransaction"]] sortDescriptors:nil]lastObject];
        if (parTransaction) {
            transaction.parTransaction = parTransaction;
        }else{
            transaction.parTransaction = nil;
        }
    }else{
        transaction.parTransaction = nil;
    }
    
    if (objectServer[@"payee"]!=nil && objectServer[@"payee"]!=[NSNull null]){
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"payee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            transaction.payee = payee;
        }else{
            transaction.payee = nil;
        }
    }else{
        transaction.payee = nil;
    }
    
    if (objectServer[@"transactionHasBillItem"]!=nil && objectServer[@"transactionHasBillItem"]!=[NSNull null]){
        EP_BillItem* billItem = [[self backgroundGetObjectsFromTable:tableBillItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"transactionHasBillItem"]] sortDescriptors:nil]lastObject];
        if (billItem) {
            transaction.transactionHasBillItem = billItem;
        }else{
            transaction.transactionHasBillItem = nil;
        }
    }else{
        transaction.transactionHasBillItem = nil;
    }
    
    if (objectServer[@"transactionHasBillRule"]!=nil && objectServer[@"transactionHasBillRule"]!= [NSNull null]){
        EP_BillRule* billRule = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"transactionHasBillRule"]] sortDescriptors:nil]lastObject];
        if (billRule) {
            transaction.transactionHasBillRule = billRule;
        }else{
            transaction.transactionHasBillRule = nil;
        }
    }else{
        transaction.transactionHasBillRule = nil;
    }
    
    //图片未作处理
}


-(void)assignAccountTypeLocal:(AccountType *)accountType WithServer:(NSDictionary *)objectServer
{
    accountType.dateTime=[objectServer[@"dateTime"] isNull];
    accountType.iconName=[objectServer[@"iconName"]isNull];
    accountType.isDefault=[objectServer[@"isDefault"]isNull];
    accountType.ordexIndex=[objectServer[@"orderIndex"]isNull];
    accountType.others=[objectServer[@"others"]isNull];
    accountType.state=[objectServer[@"state"]isNull];
    accountType.typeName=[objectServer[@"typeName"]isNull];
    accountType.uuid=[objectServer[@"uuid"]isNull];
    accountType.updatedTime=[objectServer[@"updatedTime"]isNull];
}

-(void)assignAccountLocal:(Accounts *)account WithServer:(NSDictionary *)objectServer
{
    account.accName=[objectServer[@"accName"]isNull];
    account.amount=[objectServer[@"amount"]isNull];
    account.autoClear=[objectServer[@"autoClear"]isNull];
    account.checkNumber=[objectServer[@"checkNumber"]isNull];
    account.creditLimit=[objectServer[@"creditLimit"]isNull];
    account.dateTime=[objectServer[@"dateTime"]isNull];
    account.dateTime_sync=[objectServer[@"dateTime_sync"]isNull];
    account.dueDate=[objectServer[@"dueDate"]isNull];
    account.iconName=[objectServer[@"objectServer"]isNull];
    account.orderIndex=[objectServer[@"orderIndex"]isNull];
    account.others=[objectServer[@"others"]isNull];
    account.reconcile=[objectServer[@"reconcile"]isNull];
    account.runningBalance=[objectServer[@"runningBalance"]isNull];
    account.state=[objectServer[@"state"]isNull];
    account.uuid=[objectServer[@"uuid"]isNull];
    account.accountColor=[objectServer[@"accountColor"]isNull];
    account.updatedTime=[objectServer[@"updatedTime"]isNull];
    
    if (objectServer[@"accountType"] != nil && objectServer[@"accountType"] != [NSNull null])
    {
        AccountType* accountType = [[self backgroundGetObjectsFromTable:tableAccountType predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"accountType"]] sortDescriptors:nil]lastObject];
        if (accountType) {
            account.accountType = accountType;
        }
    }else{
        account.accountType = nil;
    }
}

-(void)assignCategoryLocal:(Category *)category WithServer:(NSDictionary *)objectServer
{
    category.categoryisExpense=[objectServer[@"categoryisExpense"]isNull];
    category.categoryisIncome=[objectServer[@"categoryisIncome"]isNull];
    category.categoryName=[objectServer[@"categoryName"]isNull];
    category.categoryString=[objectServer[@"categoryString"]isNull];
    category.categoryType=[objectServer[@"categoryType"]isNull];
    category.colorName=[objectServer[@"colorName"]isNull];
    category.dateTime=[objectServer[@"dateTime"]isNull];
    category.hasBudget=[objectServer[@"hasBudget"]isNull];
    category.iconName=[objectServer[@"iconName"]isNull];
    category.isDefault=[objectServer[@"isDefault"]isNull];
    category.isSystemRecord=[objectServer[@"isSystemRecord"]isNull];
    category.others=[objectServer[@"others"]isNull];
    category.recordIndex=[objectServer[@"recordIndex"]isNull];
    category.state=[objectServer[@"state"]isNull];
    category.uuid=[objectServer[@"uuid"]isNull];
    category.updatedTime=[objectServer[@"updatedTime"]isNull];
    
}

-(void)assignPayeeLocal:(Payee *)payee WithServer:(NSDictionary *)objectServer
{
    payee.dateTime=[objectServer[@"dateTime"]isNull];
    payee.memo=[objectServer[@"memo"]isNull];
    payee.name=[objectServer[@"name"]isNull];
    payee.orderIndex=[objectServer[@"orderIndex"]isNull];
    payee.others=[objectServer[@"others"]isNull];
    payee.phone=[objectServer[@"phone"]isNull];
    payee.state=[objectServer[@"state"]isNull];
    payee.tranAmount=[objectServer[@"tranAmount"]isNull];
    payee.tranCleared=[objectServer[@"tranCleared"]isNull];
    payee.tranMemo=[objectServer[@"tranMemo"]isNull];
    payee.tranType=[objectServer[@"tranType"]isNull];
    payee.uuid=[objectServer[@"uuid"]isNull];
    payee.website=[objectServer[@"website"]isNull];
    payee.updatedTime=[objectServer[@"updatedTime"]isNull];
    if (objectServer[@"category"]!=nil && objectServer[@"category"]!=[NSNull null])
    {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]] sortDescriptors:nil]lastObject];
        if (category) {
            payee.category = category;
        }else{
            payee.category = nil;
        }
    }else{
        payee.category = nil;
    }
}

-(void)assignBillRuleLocal:(EP_BillRule *)billRule WithServer:(NSDictionary *)objectServer
{
    billRule.dateTime=[objectServer[@"dateTime"]isNull];
    billRule.ep_billAmount=[objectServer[@"ep_billAmount"]isNull];
    billRule.ep_billDueDate=[objectServer[@"ep_billDueDate"]isNull];
    billRule.ep_billEndDate=[objectServer[@"ep_billEndDate"]isNull];
    billRule.ep_billName=[objectServer[@"ep_billName"]isNull];
    billRule.ep_bool1=[objectServer[@"ep_bool1"]isNull];
    billRule.ep_bool2=[objectServer[@"ep_bool2"]isNull];
    billRule.ep_date1=[objectServer[@"ep_date1"]isNull];
    billRule.ep_date2=[objectServer[@"ep_date2"]isNull];
    billRule.ep_note=[objectServer[@"ep_note"]isNull];
    billRule.ep_recurringType=[objectServer[@"ep_recurringType"]isNull];
    billRule.ep_reminderDate=[objectServer[@"ep_reminderDate"]isNull];
    billRule.ep_reminderTime=[objectServer[@"ep_reminderTime"]isNull];
    billRule.ep_string1=[objectServer[@"ep_string1"]isNull];
    billRule.ep_string2=[objectServer[@"ep_string2"]isNull];
    billRule.state=[objectServer[@"state"]isNull];
    billRule.uuid=[objectServer[@"uuid"]isNull];
    billRule.updatedTime=[objectServer[@"updatedTime"]isNull];
    //
    if (objectServer[@"billRuleHasCategory"]!=nil && objectServer[@"billRuleHasCategory"]!=[NSNull null])
    {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasCategory"]] sortDescriptors:nil]lastObject];
        if (category) {
            billRule.billRuleHasCategory = category;
        }else{
            billRule.billRuleHasCategory = nil;
        }
    }else{
        billRule.billRuleHasCategory = nil;
    }
    
    if (objectServer[@"billRuleHasPayee"]!=nil && objectServer[@"billRuleHasPayee"]!=[NSNull null])
    {
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"billRuleHasPayee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            billRule.billRuleHasPayee = payee;
        }else{
            billRule.billRuleHasPayee = nil;
        }
    }else{
        billRule.billRuleHasPayee = nil;
    }
}

-(void)assignBillItemLocal:(EP_BillItem *)billItem WithServer:(NSDictionary *)objectServer
{
    billItem.dateTime=[objectServer[@"dateTime"] isNull];
    billItem.ep_billisDelete=[objectServer[@"ep_billisDelete"]isNull];
    billItem.ep_billItemAmount=[objectServer[@"ep_billItemAmount"]isNull];
    billItem.ep_billItemBool1=[objectServer[@"ep_billItemBool1"]isNull];
    billItem.ep_billItemBool2=[objectServer[@"ep_billItemBool2"]isNull];
    billItem.ep_billItemDate1=[objectServer[@"ep_billItemDate1"]isNull];
    billItem.ep_billItemDate2=[objectServer[@"ep_billItemDate2"]isNull];
    billItem.ep_billItemDueDate=[objectServer[@"ep_billItemDueDate"]isNull];
    billItem.ep_billItemDueDateNew=[objectServer[@"ep_billItemDueDateNew"]isNull];
    billItem.ep_billItemEndDate=[objectServer[@"ep_billItemEndDate"]isNull];
    billItem.ep_billItemName=[objectServer[@"ep_billItemName"]isNull];
    billItem.ep_billItemNote=[objectServer[@"ep_billItemNote"]isNull];
    billItem.ep_billItemRecurringType=[objectServer[@"ep_billItemRecurringType"]isNull];
    billItem.ep_billItemReminderDate=[objectServer[@"ep_billItemReminderDate"]isNull];
    billItem.ep_billItemReminderTime=[objectServer[@"ep_billItemReminderTime"]isNull];
    billItem.ep_billItemString1=[objectServer[@"ep_billItemString1"]isNull];
    billItem.ep_billItemString2=[objectServer[@"ep_billItemString2"]isNull];
    billItem.state=[objectServer[@"state"]isNull];
    billItem.uuid=[objectServer[@"uuid"]isNull];
    billItem.updatedTime=[objectServer[@"updatedTime"]isNull];
    if (objectServer[@"billItemHasBillRule"]!=nil && objectServer[@"billItemHasBillRule"]!=[NSNull null])
    {
        EP_BillRule* billRule = [[self backgroundGetObjectsFromTable:tableBillRule predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasBillRule"]] sortDescriptors:nil]lastObject];
        if (billRule)
        {
            billItem.billItemHasBillRule=billRule;
        }else{
            billItem.billItemHasBillRule = nil;
        }
    }else{
        billItem.billItemHasBillRule = nil;
    }
    
    if (objectServer[@"billItemHasCategory"] != nil && objectServer[@"billItemHasCategory"] != [NSNull null])
    {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasCategory"]] sortDescriptors:nil]lastObject];
        if (category)
        {
            billItem.billItemHasCategory=category;
        }else{
            billItem.billItemHasCategory= nil;
        }
    }else{
        billItem.billItemHasCategory= nil;
    }
    
    if (objectServer[@"billItemHasPayee"]!=nil && objectServer[@"billItemHasPayee"]!=[NSNull null])
    {
        Payee* payee = [[self backgroundGetObjectsFromTable:tablePayee predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"billItemHasPayee"]] sortDescriptors:nil]lastObject];
        if (payee) {
            billItem.billItemHasPayee = payee;
        }else{
            billItem.billItemHasPayee = nil;
        }
    }else{
        billItem.billItemHasPayee = nil;
    }
}

-(void)assignBudgetItemLocal:(BudgetItem *)budgetItem WithServer:(NSDictionary *)objectServer
{
    budgetItem.amount=[objectServer[@"amount"]isNull];
    budgetItem.dateTime=[objectServer[@"dateTime"]isNull];
    budgetItem.endDate=[objectServer[@"endDate"]isNull];
    budgetItem.isCurrent=[objectServer[@"isCurrent"]isNull];
    budgetItem.isRollover=[objectServer[@"isRollover"]isNull];
    budgetItem.orderIndex=[objectServer[@"orderIndex"]isNull];
    budgetItem.rolloverAmount=[objectServer[@"rolloverAmount"]isNull];
    budgetItem.startDate=[objectServer[@"startDate"]isNull];
    budgetItem.state=[objectServer[@"state"]isNull];
    budgetItem.uuid=[objectServer[@"uuid"]isNull];
    budgetItem.updatedTime=[objectServer[@"updatedTime"]isNull];
    if (objectServer[@"budgetTemplate"]!=nil && objectServer[@"budgetTemplate"]!=[NSNull null])
    {
        BudgetTemplate* template = [[self backgroundGetObjectsFromTable:tableBudgetTemplate predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"budgetTemplate"]] sortDescriptors:nil]lastObject];
        if (template)
        {
            budgetItem.budgetTemplate=template;
        }else{
            budgetItem.budgetTemplate=nil;
        }
    }else{
        budgetItem.budgetTemplate=nil;
    }
}

-(void)assignBudgetTransfer:(BudgetTransfer *)budgetTransfer WithServer:(NSDictionary *)objectServer
{
    budgetTransfer.amount=[objectServer[@"amount"]isNull];
    budgetTransfer.dateTime=[objectServer[@"dateTime"]isNull];
    budgetTransfer.dateTime_sync=[objectServer[@"dateTimeSync"]isNull];
    budgetTransfer.state=[objectServer[@"state"]isNull];
    budgetTransfer.uuid=[objectServer[@"uuid"]isNull];
    budgetTransfer.updatedTime=[objectServer[@"updatedTime"]isNull];
    if (objectServer[@"fromBudget"]!=nil && objectServer[@"fromBudget"]!=[NSNull null])
    {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"fromBudget"]] sortDescriptors:nil]lastObject];
        if (item)
        {
            budgetTransfer.fromBudget = item;
        }else{
            budgetTransfer.fromBudget = nil;
        }
    }else{
        budgetTransfer.fromBudget = nil;
    }
    if (objectServer[@"toBudget"]!=nil && objectServer[@"toBudget"]!=[NSNull null])
    {
        BudgetItem* item = [[self backgroundGetObjectsFromTable:tableBudgetItem predicate:[NSPredicate predicateWithFormat:@"uuid = %@",objectServer[@"toBudget"]] sortDescriptors:nil]lastObject];
        if (item) {
            budgetTransfer.toBudget = item;
        }else{
            budgetTransfer.toBudget = nil;
        }
    }else{
        budgetTransfer.toBudget = nil;
    }
}


-(void)assignBudgetTemplateLocal:(BudgetTemplate *)budgetTemplate WithServer:(NSDictionary *)objectServer
{
    budgetTemplate.amount=[objectServer[@"amount"]isNull];
    budgetTemplate.cycleType=[objectServer[@"cycleType"]isNull];
        budgetTemplate.dateTime=[objectServer[@"dateTime"]isNull];
    budgetTemplate.isNew=[objectServer[@"isNew"]isNull];
    budgetTemplate.isRollover=[objectServer[@"isRollover"]isNull];
    budgetTemplate.orderIndex=[objectServer[@"orderIndex"]isNull];
    budgetTemplate.startDate=[objectServer[@"startDate"]isNull];
    budgetTemplate.startDateHasChange=[objectServer[@"startDateHasChange"]isNull];
    budgetTemplate.uuid=[objectServer[@"uuid"]isNull];
    budgetTemplate.updatedTime=[objectServer[@"updatedTime"]isNull];
    budgetTemplate.state=[objectServer[@"state"]isNull];
    if (objectServer[@"category"]!=nil && objectServer[@"category"]!=[NSNull null])
    {
        Category* category = [[self backgroundGetObjectsFromTable:tableCategory predicate:[NSPredicate predicateWithFormat:@"uuid == %@",objectServer[@"category"]] sortDescriptors:nil]lastObject];
        if (category)
        {
            budgetTemplate.category=category;
        }else{
            budgetTemplate.category=nil;
        }
    }else{
        budgetTemplate.category=nil;
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

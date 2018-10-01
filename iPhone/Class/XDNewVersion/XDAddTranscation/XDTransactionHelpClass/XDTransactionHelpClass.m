//
//  XDTransactionHelpClass.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import "XDTransactionHelpClass.h"
#import "PokcetExpenseAppDelegate.h"

@implementation XDTransactionHelpClass

+(NSArray *)getTransactionAccounts{
    NSError *error =nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    return objects;
}

+(NSArray *)getCategroysWithTranscationType:(TransactionType)type{
    if (type ==TranscationTransfer) {
        return nil;
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSError *error = nil;
    NSDictionary *subs = [[NSDictionary alloc]init];
    NSString *fetchName = @"";
    if(type == TransactionExpense){
        fetchName = @"fetchCategoryByExpenseType";
    }else if(type == TransactionIncome){
        fetchName = @"fetchCategoryByIncomeType";
    }
    
    
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
//    NSSortDescriptor* secondSort = [[NSSortDescriptor alloc] initWithKey:@"recordIndex" ascending:NO];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray* muArr = [NSMutableArray array];
    for (int i = 0; i < (objects.count / 16) + 1; i++) {
        NSInteger integer = objects.count - i * 16;
        if (integer >= 16) {
            [muArr addObject:[objects subarrayWithRange:NSMakeRange(i*16, 16)]];
        }else{
            [muArr addObject:[objects subarrayWithRange:NSMakeRange(i*16, integer)]];
        }
    }
    return muArr;
}

+(NSArray *)getPayeeWithTransactionType:(TransactionType)type{
    if (type == TransactionExpense) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSError * error=nil;
        NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"category.categoryType = %@ && state contains[c] %@", @"EXPENSE",@"1"];
        [fetchRequest setPredicate:predicate];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; // genehrate a description that describe which field you want to sort by
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
//        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"state = %@ and tranType = %@",@"1",@"expense"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"orderIndex" ascending:NO]]];
        
        return objects;
    }else if(type == TransactionIncome){
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSError * error=nil;
        NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Payee" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"category.categoryType = %@ && state contains[c] %@", @"INCOME",@"1"];
        [fetchRequest setPredicate:predicate];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; // genehrate a description that describe which field you want to sort by
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"state = %@ and tranType = %@",@"1",@"income"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"orderIndex" ascending:NO]]];
        
        return objects;
    }else{
//        NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"state = %@ and tranType = %@",@"1",@"transfer"] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"orderIndex" ascending:NO]]];
        
        return [NSArray array];

    }
}
@end

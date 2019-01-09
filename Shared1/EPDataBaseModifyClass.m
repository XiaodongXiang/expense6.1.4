//
//  EPDataBaseModifyClass.m
//  PocketExpense
//
//  Created by MV on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EPDataBaseModifyClass.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"

#import "BudgetTemplate.h"
#import "BudgetTransfer.h"
#import "AccountType.h"
#import "Category.h"
#import "Payee.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "BillRule.h"
#import "ApplicationDBVersion.h"
#import "EPNormalClass.h"

#import "DropboxSyncTableDefine.h"
#import "BillFather.h"
#import "iPad_OverViewViewController.h"

#import "ParseDBManager.h"
#import <Parse/Parse.h>

#define DEFAULTACCOUNT @"Default Account"


//修改免费版添加的
#import "ZipArchive.h"
#import <sqlite3.h>

#import "PokcetExpenseAppDelegate.h"
#import "Payee.h"

#define OLDUSERDATA @"oldUserData"
#define FIRSTLAUNCHSINCEBACKUPOLDUSERDATA @"FirstLanchSinceBackupOldUserData"

#import <Parse/Parse.h>
#import "ParseDBManager.h"


@implementation EPDataBaseModifyClass
#pragma mark - init Class
- (id)init{
    if (self = [super init])
	{
    }
    return self;
}
#pragma mark - init DataBase
//-----------初始化Acount的Type
-(void)initializeAccountType
{
    NSArray *accountTypeIdArray = [[NSArray alloc]initWithObjects:
                                   @"F2243FC7-6E01-4CD8-8A03-6AE56E7B20E1",
                                   @"9832B8FA-537C-4963-8CA9-19385E9732E5",
                                   @"9C4251B9-5B57-4472-8B6E-BAF1A4D60650",
                                   @"4C9ACC13-D22D-4A7F-ABB3-7A5A7C94EAA2",
                                   @"A54BB0EF-17DF-4BA5-BB1E-A24AC31DA138",
                                   @"A8D6FFD2-602B-4E23-AA86-44751A2234C6",
                                   @"B10A95AC-6BA2-401A-9A67-AF667313872F",
                                   @"3E3BEB88-153A-4ACB-AE15-3B2B7935D56E",
                                   @"EB77B173-7BE4-458E-B1DD-0309EBF3A12C", nil];
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Account type
    NSMutableArray *accountTypeNameArray =  [NSMutableArray arrayWithObjects:
                                              @"Asset",@"Cash", @"Checking", @"Credit Card",@"Debit Card",@"Investing/Retirement",@"Loan",@"Savings",@"Others",nil] ;
    NSMutableArray *accountTypeIconArray =  [NSMutableArray arrayWithObjects:
                                              @"asset.png",@"cash.png", @"checking.png", @"credit-card.png",@"Debt.png",@"investing.png",@"loan.png",@"Saving.png",@"icon_other.png",nil] ;
    
    for (int i=0; i<[accountTypeNameArray count]; i++)
    {
        AccountType *newAccountType = [NSEntityDescription insertNewObjectForEntityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
        newAccountType.typeName = [accountTypeNameArray objectAtIndex:i];
        newAccountType.iconName = [accountTypeIconArray objectAtIndex:i];
        if ([newAccountType.typeName isEqualToString:@"Others"]) {
            newAccountType.isDefault = [NSNumber numberWithBool:YES];
        }
        else
            newAccountType.isDefault = [NSNumber numberWithBool:NO];
        
        //增加 date state uuid
        newAccountType.dateTime = [NSDate date];
        newAccountType.state = @"1";
        newAccountType.uuid = [accountTypeIdArray objectAtIndex:i];
        
        newAccountType.updatedTime=[NSDate date];
        
        NSError *errors=nil;
        if(![appDelegate.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        }

    }
 
    
}

//-----------初始化Category
-(void)initializeCategory
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Catagories
    NSMutableArray *categoryNameArray = [NSMutableArray arrayWithObjects:
                                          @"Auto",
                                          @"Auto: Gas",
                                          @"Auto: Registration",
                                          @"Auto: Service",
                                          @"Bank Charge",
                                          @"Bonus",
                                          @"Cash",
                                          @"Charity",
                                          @"Childcare",
                                          @"Clothing",
                                          
                                          @"Credit Card Payment",
                                          @"Eating Out",
                                          @"Education",
                                          @"Entertainment",
                                          @"Gifts",
                                          @"Groceries",
                                          @"Health & Fitness",
                                          @"Home Repair",
                                          @"Household",
                                          @"Insurance",
                                          
                                          @"Interest Exp",
                                          @"Loan",
                                          @"Medical",
                                          @"Misc",
                                          @"Mortgage Payment",
                                          @"Pets",
                                          @"Others",
                                          @"Others",
                                          
                                          @"Rent",
                                          @"Salary",
                                          @"Savings Deposit",
                                          @"Tax",
                                          @"Tax: Fed",
                                          @"Tax: Medicare",
                                          @"Tax: Other",
                                          @"Tax: Property",
                                          @"Tax: SDI",
                                          @"Tax: Soc Sec",
                                          @"Tax: State",
                                          
                                          @"Travel",
                                          @"Utilities",
                                          @"Utilities: Cable TV",
                                          @"Utilities: Garbage & Recycling",
                                          @"Utilities: Gas& Electric",
                                          @"Utilities: Internet",
                                          @"Utilities: Telephone",
                                          @"Utilities: Water",
                                          @"Transport",
                                          @"Tax Refund",
                                          nil] ;
    
    NSMutableArray *categoryTypeArray = [NSMutableArray arrayWithObjects:
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"INCOME",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"INCOME",
                                          
                                          @"EXPENSE",
                                          @"INCOME",
                                          @"INCOME",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"EXPENSE",
                                          @"INCOME",
                                          nil] ;
    
    NSMutableArray *categoryIconArray = [NSMutableArray arrayWithObjects:
                                          @"auto.png",@"auto_gas.png",@"auto_resiger.png",@"auto_service.png",@"bank_charge.png",@"bonus.png",@"category_cash.png",@"charity.png",
                                          @"childcare.png",@"clothing.png",@"credit_card-payment.png",@"dinning.png",@"education.png",@"entertainment.png",@"gifts.png",@"groceries.png",
                                          @"health_fitness.png",@"homerepair.png",@"house_hold.png",@"insurance.png",@"icon_Salary2.png",@"category_loan.png",@"medical.png",@"misc.png",@"mortgage.png",
                                          @"my_pets.png",@"uncategorized.png",@"uncategorized_income.png",@"rent.png",@"salary.png",@"savings-deposit.png",@"tax-fed.png",@"tax-fed.png",@"medicare.png",
                                          @"tax-other.png",@"tax-property.png",@"SDI.png",@"soc-sec.png",@"tax-state.png",@"airplane.png",@"utilities.png",@"cable-TV.png",
                                          @"Garbage-&-Recycling.png",@"utility_gas.png",@"interent.png",@"telephone.png",@"water.png",@"travel.png",@"icon_tax2.png",
                                          nil] ;
    
    NSMutableArray *uuidArray = [[NSMutableArray alloc]initWithObjects:
                                 @"0F6FD33B-E575-448D-9DFC-FBDD46BB244F",
                                 @"33F11CA3-50C8-491D-823A-66F8DA2632D9",
                                 @"5760538F-A7CF-4EEC-873C-03EF9A7D6FE0",
                                 @"1D1C1F8D-4CE7-4467-AA1C-8C99DFFE64F8",
                                 @"EBBE58EC-32F7-49FB-8C26-5E49572D0355",
                                 @"65E255EE-B01C-498A-8A6D-980787DBB16B",
                                 @"CBB79C68-B40A-4FBC-A89D-714EEF0C610C",
                                 @"E1A3532A-77E6-4E72-A16F-3E9A7C36E81E",
                                 @"79AA0903-0A7A-4923-A92D-5EA59F71A43C",
                                 @"F6C83821-FCEF-492C-B4EE-940C80457546",
                                 
                                 @"03D897A0-DD0F-4F4D-A72A-03DA70348BFE",
                                 @"CA6C55B4-2B95-4921-9AE4-74E76A253426",
                                 @"B7AD59FE-13C4-4476-8DE0-D8CC94F7A20D",
                                 @"9344BA4C-7B9E-40D5-8A05-9FECD60C63AB",
                                 @"A515223D-318F-420F-B366-CE207EC2D512",
                                 @"41FC8F1F-CBEF-48F9-B5CC-BB47956D79B7",
                                 @"8997A036-74B9-4140-BF62-0ABC349C0E08",
                                 @"1DF5FB17-EAA2-4890-81CD-15DFCCDEB1A2",
                                 @"283C5A28-D76A-4EF5-9713-31FB37B6D963",
                                 @"87F4F37D-1373-4404-ADFD-6AB23823853E",
                                 
                                 @"D4AB78F5-32CE-434F-9A1D-F25FE681E71A",
//
                                 @"1E32DE55-5EA4-4519-A3F2-AB21861F9B03",
                                 @"C8A54F8C-F440-4FE8-9526-B650928F02D4",
                                 @"7960FFF8-874B-4CD7-B0DF-02A8D7CA7756",
                                 @"45643F47-6105-4E21-BD54-9C1E74105D71",
//                                 ,
                                 @"0206FC4C-9291-40F6-9242-16A673588515",
                                 @"E15F57E7-E976-449D-831F-BCD4631C73C5",
                                 @"6CFF80C6-6080-4263-80D9-E0ED8DC4E606",
                                 
                                 @"CD0F4454-38FA-40C3-8651-CAAD7238773E",
                                 @"553E1F3C-2121-43FA-B6EF-9673C9C79F1B",
                                 @"3944081E-93F6-4541-965E-F3077FD9695E",
                                 @"5C7368FA-1E98-4777-8E0E-9D470283AE8C",
                                 @"0D997AF9-3C18-45A4-AB44-C005D10CC12D",
                                 @"8DF4ACB4-B4E9-4AD1-8B6E-C670CF0E1B50",
                                 @"1E85D7CF-2263-4F01-839B-510CED8D5147",
                                 @"E1FB0951-9A62-4801-954C-99B0C87B1BDE",
                                 @"88D34AA2-A3F0-4A2B-8C47-B6BB26A043FB",
                                 @"779F4166-A755-4D91-AB87-B3328BC32B9E",
                                 
                                 @"0B171B72-1C7A-4C2F-A7AC-A4FA50B385BB",
                                 @"8002FBE6-DE5A-4C60-937E-4904204FB17C",
                                 @"9482F32A-6EFF-42CF-90B8-1C5F18C9E851",
                                 @"DA648D8C-C1C2-4824-8D06-6CA1D0C534E7",
                                 @"FA8FD9FE-B71A-40C9-A648-99F002EDC005",
                                 @"8AED613B-DC33-4A1D-9284-48EAB43744A5",
                                 @"04CDA8B1-E0E8-4B39-8143-BE47DC963EE9",
                                 @"9810BE73-F5A8-49BC-85DE-5C1E5E8F8333",
                                 @"1FD9D0CA-D3DF-4640-A541-58FA1C5338E1",
                                 @"E3EB044D-F2BA-4239-8DA5-4C84D4F87616",
                                 @"38B27F70-2C9F-4705-AF3B-929BD2711D21",nil];
    //插入默认的category
    for (int j=0; j<[categoryNameArray count]; j++)
    {
        Category  *categories = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:appDelegate.managedObjectContext];
        categories.categoryName = [categoryNameArray objectAtIndex:j];
        categories.categoryType = [categoryTypeArray objectAtIndex:j];
        
        categories.iconName = [categoryIconArray objectAtIndex:j];
        categories.isSystemRecord = [NSNumber numberWithBool:TRUE];
        
        if([categories.categoryName compare:@"Others"] == NSOrderedSame)
        {
            categories.isDefault = [NSNumber numberWithBool:YES];//表示这个catogory是否是默认的Not sure的catogory
            
        }
        else {
            categories.isDefault = [NSNumber numberWithBool:FALSE];
            
        }
        
        categories.dateTime = [NSDate date];
        categories.state = @"1";
        categories.uuid = [uuidArray objectAtIndex:j];
        categories.updatedTime=[NSDate date];
        
        NSError *errors=nil;
        if(![appDelegate.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        }
    }
    
    
    //获取category数组
    NSString *fetchName = @"";
 	fetchName = @"fetchCategoryByIncomeType";
	
    
	
    
}
#pragma mark - check history error data and auto fix
//------------检查是否有catogory 图标的错误，这是为了修复以往的错误
-(void)CheckCategoryErrorIcon
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSDictionary *subs= [[NSDictionary alloc]init];
	
	NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchErrorRecord_Cash" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSError *error=nil;
	NSArray* objects1= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects1];

	
	if([tmpArray count]==1)
	{
		Category *c = [tmpArray lastObject];
		c.iconName = @"category_cash.png";
	}
	
	
	if (  ![appDelegate.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	
	fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchErrorRecord_Loan" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
	sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects2= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:objects2];

	if([tmpArray1 count]==1)
	{
		Category *c = [tmpArray1 lastObject];
		c.iconName = @"category_loan.png";
	}
	
	
	if (  ![appDelegate.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	
}

-(void)CheckAccountTypeErrorName
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSDictionary *subs= [[NSDictionary alloc]init];
	
	NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchErrorRecord_Name" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES ]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSError *error=nil;
	NSArray* objects1= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects1];

	
	if([tmpArray count]==1)
	{
		AccountType *at = [tmpArray lastObject];
		at.typeName = @"Debit Card";
	}
	
	
	if (  ![appDelegate.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	
}

-(void)AddCategory_V100ToV101
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSManagedObjectContext* context = appDelegate.managedObjectContext;
	NSError* errors = nil;
	//get unit from database's Setting
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ApplicationDBVersion"
												  inManagedObjectContext:context];
	[request setEntity:entityDesc];
	NSArray *objects = [context executeFetchRequest:request error:&errors];
	NSMutableArray *mutableObjects = [[NSMutableArray alloc] initWithArray:objects];
	unsigned long count = [mutableObjects count];
	if(count != 1)
	{
		return;
	}
	ApplicationDBVersion *adbv  = [mutableObjects lastObject];
	if([adbv.versionNumber isEqualToString:@"1.0.1"] || [adbv.versionNumber isEqualToString:@"1.0.2"])
	{
        
		return ;
	}
	adbv.versionNumber =@"1.0.1";
	
	Category  *categories = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
														  inManagedObjectContext:context];
	categories.categoryName = @"House Hold";
	categories.iconName = @"house_hold.png";
	categories.isSystemRecord = [NSNumber numberWithBool:TRUE];
	categories.isDefault = [NSNumber numberWithBool:FALSE];
    
	Category  *categories1 = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                           inManagedObjectContext:context];
	categories1.categoryName = @"Utilities: Gas& Electric";
	categories1.iconName = @"utility_gas.png";
	categories1.isSystemRecord = [NSNumber numberWithBool:TRUE];
	categories1.isDefault = [NSNumber numberWithBool:FALSE];
	
	if (![context save:&errors])
	{
		NSLog(@"Unresolved error %@,%@",errors,[errors userInfo]);
	}
	
}

-(void)CheckErrorCategoryBudgetRelation
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs= [[NSDictionary alloc]init];
	
	NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchErrorRecord_Category" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSError *error=nil;

	
//    for (int i= 0; i<[tmpArray count]; i++) {
//        Category *c =[tmpArray objectAtIndex:i];
//    }
 	
	if (  ![appDelegate.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	
    
    
}

-(void)CheckErrorBudget
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs= [[NSDictionary alloc]init];
	
	NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchErrorRecord_Budget" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES ]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSError *error=nil;
	NSArray* objects1= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects1];

	
    for (int i= 0; i<[tmpArray count]; i++) {
        BudgetTemplate *b =[tmpArray objectAtIndex:i];
        if(b.category == nil)
            [appDelegate.managedObjectContext deleteObject:b];
        
    }
 	
	if (  ![appDelegate.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
	
    
    
}

-(void)autoGenCategoryDataRelationShip
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSDictionary *subs= [[NSDictionary alloc]init];
	
	NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoy" substitutionVariables:subs];		// Edit the entity name as appropriate.
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSError *error=nil;
	NSArray* objects1= [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:objects1];
	
	NSMutableArray *addCategoryArray = [[NSMutableArray alloc] init];
	NSString *lastParName =nil;
	for (int i=0; i<[categoryArray count]; i++) {
		Category *c = [categoryArray objectAtIndex:i];
		NSArray * seprateSrray = [c.categoryName componentsSeparatedByString:@":"];
		NSString *parName = [seprateSrray objectAtIndex:0];
		
		if(![ parName isEqualToString: lastParName])
		{
			NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
			
			NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];		// Edit the entity name as appropriate.
			
			// Edit the sort key as appropriate.
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; // generate a description that describe which field you want to sort by
			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
			
			[fetchRequest setSortDescriptors:sortDescriptors];
			NSError *error=nil;
			NSInteger count = [appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:&error];
			
		
			if(count  ==0)
			{
				BOOL isFound = FALSE;
                
				for (int j=0; j<[addCategoryArray count]; j++)
				{
					if([ parName isEqualToString: [addCategoryArray objectAtIndex:j]])
					{
						isFound = TRUE;
						break;
					}
				}
				
				if(!isFound)
				{
					[addCategoryArray addObject:parName];
				}
			}
		}
		if(lastParName==nil) lastParName = [parName copy];
	}
  	
	for (int i=0; i<[addCategoryArray count]; i++) {
		Category  *categories = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
															  inManagedObjectContext:appDelegate.managedObjectContext];
		categories.categoryName = [addCategoryArray objectAtIndex:i];
		if([categories.categoryName isEqualToString:@"Tax"]||[categories.categoryName isEqualToString:@"Utilities"])
		{
			categories.isSystemRecord = [NSNumber numberWithBool:TRUE];
            
		}
		else {
			categories.isSystemRecord = [NSNumber numberWithBool:FALSE];
            
		}
		
		if([categories.categoryName isEqualToString:@"Tax"])
		{
			categories.iconName = @"tax-fed.png";
            
		}
		else if([categories.categoryName isEqualToString:@"Utilities"])
		{
			categories.iconName = @"utilities.png";
			
		}
		else {
			categories.iconName = @"uncategorized.png";
            
		}
        
 		categories.isDefault = [NSNumber numberWithBool:FALSE];
		if (![appDelegate.managedObjectContext save:&error])
		{
			NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
		}
	}
}

-(void)autoReCountBudgetRollover_V101ToV102
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSManagedObjectContext* context = appDelegate.managedObjectContext;
	NSError* errors = nil;
	//get unit from database's Setting
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ApplicationDBVersion"
												  inManagedObjectContext:context];
	[request setEntity:entityDesc];
	NSArray *objects = [context executeFetchRequest:request error:&errors];
	NSMutableArray *mutableObjects = [[NSMutableArray alloc] initWithArray:objects];
	unsigned long count = [mutableObjects count];
	if(count != 1)
	{
		return;
	}
	ApplicationDBVersion *adbv  = [mutableObjects lastObject];
	if([adbv.versionNumber isEqualToString:@"1.0.2"])
	{
        
		return ;
	}
	adbv.versionNumber =@"1.0.2";
	if (![context save:&errors])
	{
		NSLog(@"Unresolved error %@,%@",errors,[errors userInfo]);
	}
    
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objectsTmp = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&errors];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objectsTmp];

    for (int i =0; i<[allBudgetArray count]; i++) {
        BudgetTemplate *b = [allBudgetArray objectAtIndex:i];
        [self ReCountBudgetRollover:b ];
    }
    [appDelegate.epnc setDBVerString];
	if (![context save:&errors])
	{
		NSLog(@"Unresolved error %@,%@",errors,[errors userInfo]);
	}
    
}


#pragma mark Recount Budget Rollover
//预算是否持续到下个月
-(void)ReCountBudgetRollover:(BudgetTemplate *)b
{
    if(b==nil || ![b.isRollover boolValue] || [b.budgetItems count]==0) return ;
    
    
    //获取这个时间段的所有budgetItem
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error=nil;
    NSMutableArray *tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[b.budgetItems allObjects]];
    NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    
    NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
    
    [tmpArrayItem sortUsingDescriptors:sorts];

    
    
    double lastRellover=0.0;
    
    
    for (int i=0; i<[tmpArrayItem count];i++)
    {
		double oneExpense=0;
		double oneIncome=0;
		
        BudgetItem *tmpbi = [tmpArrayItem objectAtIndex:i];
        
		NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:b.category,@"iCategory",tmpbi.startDate,@"startDate",tmpbi.endDate,@"endDate", nil];
		NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
		NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
		[fetchRequest setSortDescriptors:sortDescriptors];
		NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
		
		for (int j=0; j<[tmpArray count]; j++)
		{
			Transaction *tmpLog = (Transaction *)[tmpArray objectAtIndex:j];
			if([tmpLog.category.categoryType isEqualToString:@"EXPENSE"])
			{
				oneExpense += [tmpLog.amount doubleValue];
				
			}
			else if([tmpLog.category.categoryType isEqualToString:@"INCOME"])
				oneIncome += [tmpLog.amount doubleValue];
		}
		
		
		NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[tmpbi.fromTransfer allObjects]];
		
		for (int j = 0;j<[tmpArray1 count];j++) {
			BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
 			oneExpense +=[bttmp.amount doubleValue];
			
		}
		
		NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[tmpbi.toTransfer allObjects]];
		
		for (int j = 0; j<[tmpArray2 count];j++) {
			BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
 			oneIncome +=[bttmp.amount doubleValue];
			
		}
        ////////////////////get All child category
        NSString *searchForMe = @":";
        NSRange range = [b.category.categoryName rangeOfString : searchForMe];
        
        if (range.location == NSNotFound) {
            
            NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",b.category.categoryName];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",b.category.categoryType,@"CATEGORYTYPE",nil];
            NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchChildCategory setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];            
            NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
            
            for(int k=0 ;k<[tmpChildCategoryArray count];k++)
            {
                Category *tmpCate = [tmpChildCategoryArray objectAtIndex:k];
                if(tmpCate !=b.category)
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",tmpbi.startDate,@"startDate",tmpbi.endDate,@"endDate", nil];
                    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                    [fetchRequest setSortDescriptors:sortDescriptors];
                    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                    
                    for (int l = 0;l<[tmpArray count];l++) {
                        Transaction *t = [tmpArray objectAtIndex:l];
                        if([t.category.categoryType isEqualToString:@"EXPENSE"])
                        {
                            oneExpense +=[t.amount doubleValue];
                        }
                        else if([t.category.categoryType isEqualToString:@"INCOME"]){
                            oneIncome +=[t.amount doubleValue];
                        }
                        
                    }
                    
                    
                    
                }
            }
            
        }
        
        
        tmpbi.rolloverAmount =[NSNumber  numberWithDouble:lastRellover ];
        
        lastRellover =    [tmpbi.rolloverAmount doubleValue]+[tmpbi.amount doubleValue] +oneIncome-oneExpense ;
    }
}

#pragma mark Clear Budget Rollover

-(void)ClearBudget:(BudgetTemplate *)b
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[b.budgetItems allObjects]];
    
    for (int i=0; i<[budgetItemArray count]; i++)
    {
        BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
        
        NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
        for (int j=0; j<[fromTransferArray count]; j++)
        {
            BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
            [fromT.toBudget removeFromTransferObject:fromT];
            [context deleteObject:fromT];
            
        }
        
        NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
        for (int j=0; j<[toTransferArray count]; j++)
        {
            BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
            [toT.fromBudget removeToTransferObject:toT];
            [context deleteObject:toT];
            
        }
        
        [context deleteObject:object];
    }
    
    
    
    NSError *error;
    if (![context save:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    
}
#pragma mark - Fill budget data when enter app
-(void)insertBudgetItem:(BudgetTemplate *)b withStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate
{
    
    BudgetItem *newBudget = [NSEntityDescription insertNewObjectForEntityForName:@"BudgetItem" inManagedObjectContext:b.managedObjectContext];
    newBudget.amount = b.amount;
    newBudget.isRollover = b.isRollover;
    
    newBudget.startDate = startDate;
    newBudget.endDate =endDate;
    
    newBudget.dateTime = [NSDate date];
    newBudget.state = @"1";
    newBudget.uuid = [EPNormalClass GetUUID];
    newBudget.budgetTemplate = b;
    [b addBudgetItemsObject:newBudget];
    NSError *errors=nil;
    if (![b.managedObjectContext save:&errors])
    {
        NSLog(@"Unresolved error %@, %@", errors, [errors userInfo]);
        // abort();
    }
    
    //sync
//    if (appDelegate_iPad.dropbox.drop_account.linked) {
//        [appDelegate_iPad.dropbox updateEveryBudgetItemDataFromLocal:newBudget];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetItemLocal:newBudget];
    }
    
}


-(void)autoGenCycleBudgetItem:(BudgetTemplate *)b withEndDate:(NSDate *)cycleEndDate  isIpad:(BOOL)isIpad
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    unsigned long	count =[appDelegate.epnc getCountOfInsert:b.startDate repeatEnd:cycleEndDate typeOfRecurring:b.cycleType]+1;
    if(isIpad)
    {
        count++;
    }
    
    if (count!=0) {
        
        NSDate *startDate = [appDelegate.epnc getFirstSecByDate:b.startDate];
        NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:b.cycleType];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
        [dc1 setDay:-1];
        
        NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
        
        [self insertBudgetItem:b withStartDate:startDate EndDate:endDate];
        
        
        
        NSDate * lastBudgetDate=b.startDate;
        
        
 		for (int k=0 ; k<count; k++)
		{
			NSDate *tmpDate=  [appDelegate.epnc getDate:lastBudgetDate byCycleType:b.cycleType];
            
			NSDate *startDate = [appDelegate.epnc getFirstSecByDate:tmpDate];
			
			NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:b.cycleType];
 			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
			NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
			[dc1 setDay:-1];
			
			NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
            
           	
            [self insertBudgetItem:b  withStartDate: startDate EndDate: endDate];
			
			lastBudgetDate = startDate;
 		}
        [appDelegate.epdc ReCountBudgetRollover:b];
        
    }
    
}

- (void) autoInsertBudgets:(BudgetTemplate *)repeatBudget
{
	if([repeatBudget.cycleType isEqualToString:@"No Cycle"]||repeatBudget.cycleType==nil) return;
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:[repeatBudget.budgetItems allObjects]];
	NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
	
	[tmpArray sortUsingDescriptors:sorts];

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	unsigned long	count = [appDelegate.epnc getCountOfInsert:repeatBudget.startDate repeatEnd:[NSDate date] typeOfRecurring:repeatBudget.cycleType];
	NSDate *lastBudgetDate;
	NSError *error;
	if([tmpArray count]>0)
	{
		if (count==0) {
			return;
		}
		BudgetItem *tmpbi = [tmpArray lastObject];
		
		if([appDelegate.epnc dateCompare:tmpbi.startDate withDate:[NSDate date]]>=0) return ;
		
		tmpbi.isCurrent = [NSNumber numberWithBool:FALSE];
		if (![tmpbi.managedObjectContext save:&error])
		{
 			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			// abort();
		}
        lastBudgetDate=tmpbi.startDate;
        
        
 		for (int k=0 ; k<count; k++)
		{
			NSDate *tmpDate=  [appDelegate.epnc getDate:lastBudgetDate byCycleType:repeatBudget.cycleType];
            
			NSDate *startDate = [appDelegate.epnc getFirstSecByDate:tmpDate];
			
			NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:repeatBudget.cycleType];
 			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
			NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
			[dc1 setDay:-1];
			
			NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
            
           	
            [self insertBudgetItem:repeatBudget  withStartDate: startDate EndDate: endDate];
			
			lastBudgetDate = startDate;
 		}
        [appDelegate.epdc ReCountBudgetRollover:repeatBudget];
        
        //不好翻译 去掉了
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:[NSString stringWithFormat:@"New cycle of budget \"%@\" started.",repeatBudget.category.categoryName]
//														   delegate:self cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//        [alertView release];
        
		
	}
	else if([tmpArray count] == 0 &&[appDelegate.epnc dateCompare:repeatBudget.startDate withDate:[NSDate date]] ==0){
        
        
        NSDate *startDate = [appDelegate.epnc getFirstSecByDate:[NSDate date]];
        NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:repeatBudget.cycleType];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
        [dc1 setDay:-1];
        
        NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
  		
        [self insertBudgetItem:repeatBudget  withStartDate: startDate EndDate: endDate];
        [appDelegate.epdc ReCountBudgetRollover:repeatBudget];
        
        //不好翻译，去掉了
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:[NSString stringWithFormat:@"New cycle of budget \"%@\" started.",repeatBudget.category.categoryName]
//														   delegate:self cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//        [alertView release];
        
	}
}

- (void) autoInsertBudgets_ipad:(BudgetTemplate *)repeatBudget
{
	if([repeatBudget.cycleType isEqualToString:@"No Cycle"]||repeatBudget.cycleType==nil) return;
 	NSError *error;
    
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:[repeatBudget.budgetItems allObjects]];
	NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
	
	[tmpArray sortUsingDescriptors:sorts];

	
	if([tmpArray count]==0)
	{
		return;
	}
	
	BudgetItem *tmpbi = [tmpArray lastObject];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([appDelegate.epnc dateCompare:tmpbi.startDate withDate:[NSDate date]]>=0) return ;
    
	if([appDelegate.epnc dateCompare:[NSDate date] withDate:tmpbi.startDate ]>=0&&[appDelegate.epnc dateCompare:[NSDate date] withDate:tmpbi.endDate ]<=0)
	{
		tmpbi.isCurrent = [NSNumber numberWithBool:FALSE];
		if (![tmpbi.managedObjectContext save:&error])
		{
 			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			// abort();
		}
 		
 		
		NSDate *tmpDate=  [appDelegate.epnc getDate:tmpbi.startDate  byCycleType:repeatBudget.cycleType];
		
        NSDate *startDate = [appDelegate.epnc getFirstSecByDate:tmpDate];
		
        NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:repeatBudget.cycleType];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
        [dc1 setDay:-1];
        
        NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
	 	
 		[self insertBudgetItem:repeatBudget  withStartDate: startDate EndDate: endDate];
        [appDelegate.epdc ReCountBudgetRollover:repeatBudget];
        
        //不好翻译，去掉了
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//															message:[NSString stringWithFormat:@"New cycle of budget %@ started.",repeatBudget.category.categoryName]
//														   delegate:self cancelButtonTitle:@"OK"
//												  otherButtonTitles:nil];
//		[alertView show];
//        [alertView release];
        
		return;
		
	}
    
	unsigned long	count = [appDelegate.epnc getCountOfInsert:repeatBudget.startDate repeatEnd:[NSDate date] typeOfRecurring:repeatBudget.cycleType]+1;
	if (count==0) {
		return;
	}
	
	NSDate * lastBudgetDate=tmpbi.startDate;
    
	tmpbi.isCurrent = [NSNumber numberWithBool:FALSE];
	if (![tmpbi.managedObjectContext save:&error])
	{
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
	}
    
    for (int k=0 ; k<count; k++)
    {
        NSDate *tmpDate=  [appDelegate.epnc getDate:lastBudgetDate byCycleType:repeatBudget.cycleType];
        NSDate *startDate = [appDelegate.epnc getFirstSecByDate:tmpDate];
        NSDate *tmpDate2 =[appDelegate.epnc getDate: startDate byCycleType:repeatBudget.cycleType];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
        [dc1 setDay:-1];
        
        NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate2 options:0]];
        
        [self insertBudgetItem:repeatBudget  withStartDate: startDate EndDate: endDate];
        
        lastBudgetDate =  startDate;
    }
    
	[appDelegate.epdc ReCountBudgetRollover:repeatBudget];
    
    //不好翻译，去掉了
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//														message:[NSString stringWithFormat:@"New cycle of budget \"%@\" started.",repeatBudget.category.categoryName]
//													   delegate:self cancelButtonTitle:@"OK"
//											  otherButtonTitles:nil];
//	[alertView show];
//	
//    [alertView release];
    
	
}

-(void)AutoFillBudgetData:(BOOL)isIpad;
{
    NSError *error =nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetTemplate" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray * budgetArray =[[NSMutableArray alloc] initWithArray:objects];
    
    for (int i=0 ; i<[budgetArray count]; i++)
    {
        if(!isIpad)
            [self autoInsertBudgets:[budgetArray objectAtIndex:i]];
        else
            [self autoInsertBudgets_ipad:[budgetArray objectAtIndex:i]];
        
    }
 
    
}

#pragma mark - Fill Transaction data when enter app
- (void) autoInsertTransaction:(Transaction *)repeatTransactionRule
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if([repeatTransactionRule.recurringType isEqualToString:@"Never"]) return;
	if(repeatTransactionRule.dateTime!=nil)
	{
		if([appDelegate.epnc dateCompare:repeatTransactionRule.dateTime withDate:[NSDate date]]>=0)
		{
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:repeatTransactionRule];
            }
   			return;
		}
    }
	NSString *recurringType = repeatTransactionRule.recurringType;
	
    if([appDelegate.epnc dateCompare:repeatTransactionRule.dateTime withDate:[NSDate date]]==0&&
       [appDelegate.settings.isBefore boolValue])
    {
        NSDate *nextDate =[appDelegate.epnc getDate:repeatTransactionRule.dateTime byCycleType:repeatTransactionRule.recurringType];
        [appDelegate.epnc addNotification:nextDate withAmount:[repeatTransactionRule.amount doubleValue] withCategoryName:repeatTransactionRule.category.categoryName];
        return;
        
    }
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //4.dateTime
    NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [parts1 setHour:23];
    [parts1 setMinute:59];
    [parts1 setSecond:59];
    NSDate *todayLastSecond = [[NSCalendar currentCalendar] dateFromComponents:parts1];
    
    
	unsigned long	cycleCount = [appDelegate.epnc getCountOfInsert:repeatTransactionRule.dateTime repeatEnd:todayLastSecond typeOfRecurring:repeatTransactionRule.recurringType];
    NSDate *lastTranscationDate;
    if (![repeatTransactionRule.recurringType isEqualToString:@"Semimonthly"])
    {
        cycleCount=cycleCount+1;
        lastTranscationDate=repeatTransactionRule.dateTime;
        
    }
    else {
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) fromDate:repeatTransactionRule.dateTime];
        unsigned long dayIndex = [components day];
        if(dayIndex ==15||dayIndex ==1)
        {
            lastTranscationDate=repeatTransactionRule.dateTime;
        }
        else
        {
            if(dayIndex<15)
            {
                [components setDay:15];
            }
            else if(dayIndex>15)
            {
                [components setMonth:[components month]+1];
                [components setDay:1];
            }
            lastTranscationDate = [gregorian dateFromComponents:components];
            
        }
        
        
    }
    
	NSError *error;
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
	for (int k=0 ; k<cycleCount; k++)
	{
		if(k==cycleCount-1)
		{
			repeatTransactionRule.dateTime  =  lastTranscationDate;
            
            repeatTransactionRule.dateTime_sync = [NSDate date];
            
            
            NSDate *nextDate =[appDelegate.epnc getDate:lastTranscationDate byCycleType:recurringType];
            if( [appDelegate.settings.isBefore boolValue]&&[appDelegate.epnc dateCompare:nextDate withDate:[NSDate date]]==1)
            {
                [appDelegate.epnc addNotification:nextDate withAmount:[repeatTransactionRule.amount doubleValue] withCategoryName:repeatTransactionRule.category.categoryName];
                
            }
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            //sync
//            if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:repeatTransactionRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:repeatTransactionRule];
            }
        }
		else
        {
			NSDate *tmpDate=  lastTranscationDate;
			
			Transaction *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
            
			newTransaction.dateTime = tmpDate;
 			newTransaction.amount = repeatTransactionRule.amount;
			newTransaction.notes = repeatTransactionRule.notes;
// 			newTransaction.transactionType = repeatTransactionRule.transactionType;
			newTransaction.recurringType = @"Never";
			newTransaction.isClear = [NSNumber numberWithBool:[repeatTransactionRule.isClear boolValue]];
			newTransaction.incomeAccount = repeatTransactionRule.incomeAccount;
			newTransaction.expenseAccount = repeatTransactionRule.expenseAccount;
			newTransaction.payee = repeatTransactionRule.payee;
            newTransaction.transactionType = repeatTransactionRule.transactionType;
            //设置同步的第二标识符
            newTransaction.transactionstring =  [appDelegate_iPhone.epnc  getSecondUUID_withNoCycleTrans:tmpDate CycleTrans:repeatTransactionRule];
            newTransaction.dateTime_sync = [NSDate date];
            newTransaction.state = @"1";
            newTransaction.uuid =[EPNormalClass GetUUID];
            
 			lastTranscationDate =[appDelegate.epnc getDate:lastTranscationDate byCycleType:recurringType];
			
			[repeatTransactionRule.category addTransactionsObject:newTransaction];
            repeatTransactionRule.dateTime  =  lastTranscationDate;
            
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }             //sync
//            if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:newTransaction];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:newTransaction];
            }
		}
		if (![appDelegate.managedObjectContext save:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			// abort();
		}
 	}
}

-(void)AutoFillTransactionData
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"getAllRuleTransactions"] copy];
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray * transactionRuleArray =[[NSMutableArray alloc] initWithArray:objects];
    
    for (int i=0 ; i<[transactionRuleArray count]; i++)
    {
        [self autoInsertTransaction:[transactionRuleArray objectAtIndex:i]];
    }

}


#pragma mark - Check Transaction Number
//---------判断 transaction的数目是不是超过了20个，还可不可以增加transaction
-(BOOL)canBeAddTranscation
{
    
#ifndef RECLIMIT
    return TRUE;
#endif
	NSInteger countNum;
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
 	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
	// Edit the sort key as appropriate.
 	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	countNum = [objects count];

	if(countNum>=20) return FALSE;
	
	return TRUE;
 	
}

#pragma mark - Delete RelatonShip Data Sync
//AccountType
-(void)deleteAccountTypeRel:(AccountType *)accountType{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    [self changeRelatedAccountTypesAccounts_to_defaultAccountType_and_Sync:accountType];
    
    //save local account :state dateTime
    accountType.state = @"0";
    accountType.dateTime = [NSDate date];
    [appDelegate_iPhone.managedObjectContext save:&error];
    
    //sync server accountType,delete local accountType
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryAccountTypeDataFromLocal:accountType];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateAccountTypeFromLocal:accountType];
    }
}
-(void)changeRelatedAccountTypesAccounts_to_defaultAccountType_and_Sync:(AccountType *)oneAccountType{
    NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取accountType
	NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity_account = [NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest_account setEntity:entity_account];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest_account setPredicate:predicate];
	NSSortDescriptor *sortDescriptor_account = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES];
	NSArray *sortDescriptors_account = [[NSArray alloc] initWithObjects:sortDescriptor_account, nil];
	[fetchRequest_account setSortDescriptors:sortDescriptors_account];
    
 	NSArray* accountTypeList = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error];

    
    //获取默认的accountType
    AccountType *tmpdefaultAccountType;
    BOOL isFound=FALSE;
    
    for (int i=0; i<[accountTypeList  count]; i++) {
        AccountType *at = [accountTypeList objectAtIndex:i];
        if([at.typeName isEqualToString:@"Others"])
        {
            isFound= TRUE;
            tmpdefaultAccountType = at;
            break;
        }
    }
    if(!isFound &&[accountTypeList count ]>0)
        tmpdefaultAccountType = [accountTypeList objectAtIndex:0];
    
    //设置相关的account的accountType为Others(local)
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:oneAccountType,@"AccountType", nil];
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetch_AccountByAccountType" substitutionVariables:sub];
    NSArray *objects = [[NSArray alloc]initWithArray: [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    for (int i=0; i<[objects count]; i++) {
        Accounts *oneAccount = [objects objectAtIndex:i];
        oneAccount.accountType = tmpdefaultAccountType;
        oneAccount.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:oneAccount];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateAccountFromLocal:oneAccount];
        }
    }
    
    
}

//Account
-(void)deleteAccountRel:(Accounts * )a;
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
//    NSMutableSet* muset = [NSMutableSet set];
//    [muset addObjectsFromArray:[a.expenseTransactions allObjects]];
//    [muset addObjectsFromArray:[a.incomeTransactions allObjects]];
    
//    NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@ and expenseAccount = nil and expenseAccount = nil",@"1"] sortDescriptors:nil];
    
    NSMutableArray *tmptransactionArray = [[NSMutableArray alloc] initWithArray:[a.expenseTransactions allObjects]];
    [tmptransactionArray addObjectsFromArray:[a.incomeTransactions allObjects]];
//    [tmptransactionArray addObjectsFromArray:array];
    
    
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES];
    NSArray *ar = [tmptransactionArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [tmptransactionArray setArray:ar];
    
    //transaction
    for (int i=0; i<[tmptransactionArray count]; i++) {
       
//        NSLog(@"在第：%d 个transaction",i);
//        if (i==23)
//        {
//            NSLog(@"mm");
//        }
        
        Transaction *oneTransaction = [tmptransactionArray objectAtIndex:i];
        if (oneTransaction.uuid == nil || [oneTransaction.uuid length]<=0)
        {
            [appDelegate.managedObjectContext deleteObject:oneTransaction];
            [appDelegate.managedObjectContext save:&error];
        }
        else
        {
            oneTransaction.dateTime_sync = oneTransaction.updatedTime = [NSDate date];
            oneTransaction.state = @"0";
            [appDelegate.managedObjectContext save:&error];
//            if (appDelegate.dropbox.drop_account.linked)
//                [appDelegate.dropbox updateEveryTransactionDataFromLocal:oneTransaction];
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTransaction];
            }

        }
    }


    //account
    a.dateTime_sync = [NSDate date];
    a.state = @"0";
    [appDelegate.managedObjectContext save:&error];
//    if (appDelegate.dropbox.drop_account.linked) {
//        [appDelegate.dropbox updateEveryAccountDataFromLocal:a];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateAccountFromLocal:a];
    }
}

//------------删除某个category相关联的数据
-(void)deleteCategoryAndDeleteRel:(Category * )c;
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    //transaction
	NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[c.transactions allObjects]];
	
	for (int i=0; i<[tmpTransactionArray count]; i++)
	{
		Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
        deleteLog.dateTime_sync = [NSDate date];
        deleteLog.state = @"0";
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:deleteLog];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:deleteLog];
        }
	}
    
    
	//budget
	BudgetTemplate *tmpBudget = c.budgetTemplate;
	if(tmpBudget!=nil)
	{
		NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[tmpBudget.budgetItems allObjects]];
		for (int i=0; i<[budgetItemArray count]; i++)
        {
            BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
            
            NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
            for (int j=0; j<[fromTransferArray count]; j++)
            {
                BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
                fromT.dateTime_sync = [NSDate date];
                fromT.state = @"0";
                [appDelegate.managedObjectContext save:&error];
//                if (appDelegate.dropbox.drop_account.linked)
//                {
//                    [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
//
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBudgetTransfer:fromT];
                }
            }
            
            NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
            for (int j=0; j<[toTransferArray count]; j++)
            {
                BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                toT.dateTime_sync = [NSDate date];
                toT.state = @"0";
                [appDelegate.managedObjectContext save:&error];
//                if (appDelegate.dropbox.drop_account.linked)
//                {
//                    [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:toT];
//                    
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBudgetTransfer:toT];
                }
            }
            
            object.dateTime = [NSDate date];
            object.state = @"0";
            [appDelegate.managedObjectContext save:&error];
            
//            if (appDelegate.dropbox.drop_account.linked)
//            {
//                [appDelegate.dropbox updateEveryBudgetItemDataFromLocal:object];
//                
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBudgetItemLocal:object];
            }
        }
        
        tmpBudget.dateTime = [NSDate date];
        tmpBudget.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryBudgetTemplateDataFromLocal:tmpBudget];
//
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetFromLocal:tmpBudget];
        }
	}
    
    //payee
    NSMutableArray *payeeArray = [[NSMutableArray alloc]initWithArray:[c.payee allObjects]];
    for (long int i=0; i<[payeeArray count]; i++) {
        Payee *onePayee = [payeeArray objectAtIndex:i];
        onePayee.dateTime = [NSDate date];
        onePayee.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryPayeeDataFromLocal:onePayee];
//
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updatePayeeFromLocal:onePayee];
        }
    }
    
    //新添加删除bill
    NSMutableArray *billArray = [[NSMutableArray alloc] initWithArray:[c.categoryHasBillRule allObjects]];
    for (int i=0; i<[billArray count]; i++)
    {
        EP_BillRule *deleteLog = (EP_BillRule *)[billArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:deleteLog];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:deleteLog];
        }
    }
    
    NSMutableArray *billItemArray = [[NSMutableArray alloc] initWithArray:[c.categoryHasBillRule allObjects]];
    for (int i=0; i<[billItemArray count]; i++)
    {
        EP_BillItem *deleteLog = (EP_BillItem *)[billItemArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteLog];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteLog];
        }
    }
    
    //category
    c.state = @"0";
    c.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
//    if (appDelegate.dropbox.drop_account.linked)
//    {
//        [appDelegate.dropbox updateEveryCategoryDataFromLocal:c];
//    }

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateCategoryFromLocal:c];
    }
    
}

//Transaction
-(void)deleteTransactionRel:(Transaction *)t;
{
    
//    NSLog(@"t == %@",t);
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;

    //如果要删除的交易有父交易的话
    if (t.parTransaction != nil)
    {
        
    }
    //获取transaction的所有子transaction将其删除
    if ([[t.childTransactions allObjects] count]>0)
    {
        NSMutableArray *childArray = [[NSMutableArray alloc] initWithArray:[t.childTransactions allObjects]];
        
        for (int i=0; i<[childArray count];i++)
        {
            Transaction *ct = [childArray objectAtIndex:i];
            [self deleteChildTransactionRel:ct];
        }
        
    }

    t.dateTime_sync = t.updatedTime = [NSDate date];
    t.state = @"0";
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:t];
    }
    

}

-(void)deleteChildTransactionRel:(Transaction *)t;
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    if ([[t.childTransactions allObjects] count]>0) {
        NSMutableArray *childArray = [[NSMutableArray alloc] initWithArray:[t.childTransactions allObjects]];
        for (int i=0; i<[childArray count];i++) {
            Transaction *ct = [childArray objectAtIndex:i];
            [self deleteTransactionRel:ct];
        }
        
    }
    t.dateTime_sync = [NSDate date];
    t.state = @"0";
    [appDelegate_iPhone.managedObjectContext save:&error];
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:t];
    }
}


//删除payee会导致交易也删除，5.1版本删除payee不会删除transaction
-(void)deletePayee_sync:(Payee *)onePayee{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSMutableArray *transArray = [[NSMutableArray alloc]initWithArray:[onePayee.transaction allObjects]];
    for (long int i=0; i<[transArray count]; i++)
    {
        Transaction *oneTrans = [transArray objectAtIndex:i];
        oneTrans.payee = nil;
        oneTrans.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked) {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:oneTrans];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTrans];
        }
    }
    
    onePayee.state = @"0";
    onePayee.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
//    if (appDelegate.dropbox.drop_account.linked) {
//        [appDelegate.dropbox updateEveryPayeeDataFromLocal:onePayee];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updatePayeeFromLocal:onePayee];
    }
}

//------------删除某个预算相关联的数据，这个budget会被state==0保存起来
-(void)deleteBudgetRel:(BudgetTemplate * )b;
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [b managedObjectContext];
    NSError *error;
    
    NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[b.budgetItems allObjects]];
    if(budgetItemArray.count > 0)
    {
        for (int i=0; i<[budgetItemArray count]; i++)
        {
            BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
            
            //删除budgettransafer
            NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
            for (int j=0; j<[fromTransferArray count]; j++)
            {
                BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
                
                fromT.dateTime_sync = [NSDate date];
                fromT.state = @"0";
                if (![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
                
//                if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                    [appDelegate_iPhone.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBudgetTransfer:fromT];
                }
            }
            
            NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
            for (int j=0; j<[toTransferArray count]; j++)
            {
                BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                toT.dateTime_sync = [NSDate date];
                toT.state = @"0";
                if (![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
//                if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                    [appDelegate_iPhone.dropbox updateEveryBudgetTransferDataFromLocal:toT];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBudgetTransfer:toT];
                }
                
            }
            
            
            //删除budgetItem
            object.state = @"0";
            object.dateTime = [NSDate date];
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                [appDelegate_iPhone.dropbox updateEveryBudgetItemDataFromLocal:object];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBudgetItemLocal:object];
            }
        }
    }
    
    
    
    
    b.state = @"0";
    
    
    b.dateTime = [NSDate date];
    [appDelegate_iPhone.managedObjectContext save:&error];
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetTemplateDataFromLocal:b];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetFromLocal:b];
    }
}

//Budget Transfer
-(void)deleteTransferRel:(BudgetTransfer *)t;
{
    NSError *error;
    NSManagedObjectContext *context = [t managedObjectContext];
    BudgetTemplate *tmpTobt;
    BudgetTemplate *tmpFromobt;
    
    //1.budgetTransfer state=@"0"，delete
    t.state = @"0";
    t.dateTime_sync = [NSDate date];
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    
    [t.fromBudget removeFromTransferObject:t ];
    [t.toBudget removeToTransferObject:t];
    tmpTobt =t.toBudget.budgetTemplate;
    tmpFromobt = t.fromBudget.budgetTemplate;
    

    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }       
    
    [self ReCountBudgetRollover:tmpTobt];
    [self ReCountBudgetRollover:tmpFromobt];
    
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetTransferDataFromLocal:t];
//        
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetTransfer:t];
    }
}

//delete billrule and billitem
-(void)deleteBillRuleRel:(EP_BillRule *)billRule{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSMutableArray *billItemArray = [[NSMutableArray alloc]initWithArray:[billRule.billRuleHasBillItem allObjects]];
    for (int i=0; i<[billItemArray count]; i++) {
        EP_BillItem *oneBillItem = [billItemArray objectAtIndex:i];
        oneBillItem.state = @"0";
        oneBillItem.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];
//        if (appDelegate_iPhone.dropbox.drop_account.linked) {
//            [appDelegate_iPhone.dropbox updateEveryBillItemDataFromLocal:oneBillItem];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:oneBillItem];
        }
    }
    
    billRule.state = @"0";
    billRule.dateTime = [NSDate date];
    [appDelegate_iPhone.managedObjectContext save:&error];
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBillRuleDataFromLocal:billRule];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBillRuleFromLocal:billRule];
    }
}





#pragma mark Delete Local Data Without Sync
-(void)deleteAccountTypeRel_withoutSync:(AccountType *)accountType{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    [self changeRelatedAccountTypesAccounts_to_defaultAccountType_and_Sync:accountType];
    [appDelegate.managedObjectContext deleteObject:accountType];
    [appDelegate.managedObjectContext save:&error];
}

-(void)deleteAccountRel_withoutSync:(Accounts * )a
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [a managedObjectContext];
    NSError *error;
    
    NSMutableArray *tmptransactionArray = [[NSMutableArray alloc] initWithArray:[a.expenseTransactions allObjects]];
    [tmptransactionArray addObjectsFromArray:[a.incomeTransactions allObjects]];
    
    //save local transaction
    for (int i=0; i<[tmptransactionArray count]; i++) {
        Transaction *oneTransaction = [tmptransactionArray objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneTransaction];
    }
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    [appDelegate.managedObjectContext deleteObject:a ];
    [appDelegate.managedObjectContext save:&error];
    
}

-(void)deleteTransactionRel_withOutSync:(Transaction *)t
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;

    //获取transaction的所有子transaction将其删除
    if ([[t.childTransactions allObjects] count]>0)
    {
        NSMutableArray *childArray = [[NSMutableArray alloc] initWithArray:[t.childTransactions allObjects]];
        
        for (int i=0; i<[childArray count];i++)
        {
            Transaction *ct = [childArray objectAtIndex:i];
            [self deleteChildTransactionRel_withoutSync:ct];
        }
        
    }
    [appDelegate.managedObjectContext deleteObject:t];
    [appDelegate.managedObjectContext save:&error];
}

-(void)deleteChildTransactionRel_withoutSync:(Transaction *)t
{
    NSError *error;
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([[t.childTransactions allObjects] count]>0) {
        NSMutableArray *childArray = [[NSMutableArray alloc] initWithArray:[t.childTransactions allObjects]];
        for (int i=0; i<[childArray count];i++) {
            Transaction *ct = [childArray objectAtIndex:i];
            [self deleteTransactionRel_withOutSync:ct];
            
        }
        
    }
    [appDelegate_iPhone.managedObjectContext deleteObject:t];
    [appDelegate_iPhone.managedObjectContext save:&error];
}
-(void)deleteCategoryAndDeleteRel_withoutSync:(Category * )c
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
	NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[c.transactions allObjects]];
	
    //删除transaction
	for (int i=0; i<[tmpTransactionArray count]; i++)
	{
		Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
        [self deleteTransactionRel_withOutSync:deleteLog];
	}
	
    //删除budgettemplate,budgetItem,budgetTransfer
    BudgetTemplate *tmpBudget = c.budgetTemplate;
	if(tmpBudget!=nil)
	{
		NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[tmpBudget.budgetItems allObjects]];
		if(budgetItemArray.count > 0)
		{
			for (int i=0; i<[budgetItemArray count]; i++)
			{
				BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
				
				NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
				for (int j=0; j<[fromTransferArray count]; j++)
				{
					BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
					[c.managedObjectContext deleteObject:fromT];
					
				}
				
				NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
				for (int j=0; j<[toTransferArray count]; j++)
				{
					BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
					[c.managedObjectContext deleteObject:toT];
					
				}
				
				[c.managedObjectContext deleteObject:object];
			}
		}
		[c.managedObjectContext deleteObject:tmpBudget];
	}
    
	
	
	//删除EP_BillRule,EP_BillItem
    NSError *error = nil;
    NSMutableArray *billRuleArray =[[NSMutableArray alloc]initWithArray:[c.categoryHasBillRule allObjects]];
    for (long int i=0; i<[billRuleArray count]; i++) {
        EP_BillRule *oneBillRule = [billRuleArray objectAtIndex:i];
        NSMutableArray *billRule_billItemArray = [[NSMutableArray alloc]initWithArray:[oneBillRule.billRuleHasBillItem allObjects]];
        for (long int m=0; m<[billRule_billItemArray count]; m++) {
            EP_BillItem *oneBillItem = [billRule_billItemArray objectAtIndex:m];
            [appDelegate_iPhone.managedObjectContext deleteObject:oneBillItem];
            [appDelegate_iPhone.managedObjectContext save:&error];
        }
        
        [appDelegate_iPhone.managedObjectContext deleteObject:oneBillRule];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    NSMutableArray *billItemArray  = [[NSMutableArray alloc]initWithArray:[c.categoryHasBillItem allObjects]];
    for (long int i=0; i<[billItemArray count]; i++) {
        EP_BillItem *oneBillItem = [billItemArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneBillItem];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    
    
	//删除payee
    NSMutableArray *payeeArray = [[NSMutableArray alloc]initWithArray:[c.payee allObjects]];
    for (long int i=0; i<[payeeArray count]; i++) {
        Payee *onePayee = [payeeArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:onePayee];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
	
	
    
    [c.managedObjectContext deleteObject:c];
    [appDelegate_iPhone.managedObjectContext save:&error];
    
}

-(void)deletePayee_withoutSync:(Payee *)onePayee{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    [appDelegate.managedObjectContext deleteObject:onePayee];
    [appDelegate.managedObjectContext save:&error];
    
}

-(void)deleteBudgetRel_withoutSync:(BudgetTemplate * )b
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [b managedObjectContext];
    NSError *error;
    
    NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[b.budgetItems allObjects]];
    if(budgetItemArray.count > 0)
    {
        for (int i=0; i<[budgetItemArray count]; i++)
        {
            BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
            //删除budgettransafer
            NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
            for (int j=0; j<[fromTransferArray count]; j++)
            {
                BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
                
                [appDelegate_iPhone.managedObjectContext deleteObject:fromT];
                [appDelegate_iPhone.managedObjectContext save:&error];
            }
            
            NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
            for (int j=0; j<[toTransferArray count]; j++)
            {
                BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                [appDelegate_iPhone.managedObjectContext deleteObject:toT];
                [appDelegate_iPhone.managedObjectContext save:&error];
            }
            
            
            //删除budgetItem
            [appDelegate_iPhone.managedObjectContext deleteObject:object];
            [appDelegate_iPhone.managedObjectContext save:&error];
        }
    }

//    b.category.dateTime = [NSDate date];
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryCategoryDataFromLocal:b.category];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateCategoryFromLocal:b.category];
    }
    
    [appDelegate_iPhone.managedObjectContext deleteObject:b];
    [appDelegate_iPhone.managedObjectContext save:&error];
}

-(void)deleteBudgetItemRel_withoutSync:(BudgetItem *)budgetItem
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    //删除budgettransafer
    NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[budgetItem.fromTransfer allObjects]];
    for (int j=0; j<[fromTransferArray count]; j++)
    {
        BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
        
        [appDelegate_iPhone.managedObjectContext deleteObject:fromT];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[budgetItem.toTransfer allObjects]];
    for (int j=0; j<[toTransferArray count]; j++)
    {
        BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
        [appDelegate_iPhone.managedObjectContext deleteObject:toT];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    //删除budgetItem
    [appDelegate_iPhone.managedObjectContext deleteObject:budgetItem];
    [appDelegate_iPhone.managedObjectContext save:&error];
}

-(void)deleteBudgetItemRel:(BudgetItem *)budgetItem
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error;
    //删除budgettransafer
    NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[budgetItem.fromTransfer allObjects]];
    for (int j=0; j<[fromTransferArray count]; j++)
    {
        BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
        
        fromT.state = @"0";
        fromT.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetTransfer:fromT];
        }
    }
    
    NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[budgetItem.toTransfer allObjects]];
    for (int j=0; j<[toTransferArray count]; j++)
    {
        BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
        toT.state = @"0";
        toT.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:toT];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetTransfer:toT];
        }
    }
    //删除budgetItem
    budgetItem.dateTime = [NSDate date];
    budgetItem.state = @"0";
    [appDelegate.managedObjectContext save:&error];
//    if (appDelegate.dropbox.drop_account)
//    {
//        [appDelegate.dropbox updateEveryBudgetItemDataFromLocal:budgetItem];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetItemLocal:budgetItem];
    }
}


-(void)deleteTransferRel_withoutSync:(BudgetTransfer *)t
{
    NSError *error;
    NSManagedObjectContext *context = [t managedObjectContext];
    BudgetTemplate *tmpTobt;
    BudgetTemplate *tmpFromobt;
    
    [context deleteObject:t];
    
    [t.fromBudget removeFromTransferObject:t ];
    [t.toBudget removeToTransferObject:t];
    tmpTobt =t.toBudget.budgetTemplate;
    tmpFromobt = t.fromBudget.budgetTemplate;
    
    [context deleteObject:t];
    // Save the context.
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    [self ReCountBudgetRollover:tmpTobt];
    [self ReCountBudgetRollover:tmpFromobt];
}

-(void)deleteBillRuleRel_withoutSync:(EP_BillRule *)billRule{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSMutableArray *billItemArray = [[NSMutableArray alloc]initWithArray:[billRule.billRuleHasBillItem allObjects]];
    for (int i=0; i<[billItemArray count]; i++) {
        EP_BillItem *oneBillItem = [billItemArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneBillItem];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    NSMutableArray *transactionArray = [[NSMutableArray alloc]initWithArray:[billRule.billRuleHasTransaction allObjects]];
    for (int i=0; i<[transactionArray count]; i++) {
        Transaction *oneTrans = [transactionArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneTrans];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    [appDelegate_iPhone.managedObjectContext deleteObject:billRule];
    [appDelegate_iPhone.managedObjectContext save:&error];
}


-(void)deleteBillItemRel_withoutSync:(EP_BillItem *)billItem{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSMutableArray *transactionArray = [[NSMutableArray alloc]initWithArray:[billItem.billItemHasTransaction allObjects]];
    for (int i=0; i<[transactionArray count]; i++) {
        Transaction  *oneTrans = [transactionArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneTrans];
        [appDelegate_iPhone.managedObjectContext save:&error];
    }
    
    [appDelegate_iPhone.managedObjectContext deleteObject:billItem];
    [appDelegate_iPhone.managedObjectContext save:&error];
}


#pragma mark Save Action

-(void)saveTransaction:(Transaction *)trans
{
    if (trans.expenseAccount != nil) {
        trans.expenseAccount.dateTime_sync = [NSDate date];
        trans.expenseAccount.state = @"1";
    }
    
    if (trans.incomeAccount != nil) {
        trans.incomeAccount.dateTime_sync = [NSDate date];
        trans.incomeAccount.state = @"1";
    }
    
    if (trans.category != nil) {
        trans.category.dateTime = [NSDate date];
        trans.category.state = @"1";
        
    }
    
    if (trans.payee != nil) {
        trans.payee.dateTime = [NSDate date];
        trans.payee.state = @"1";
    }
    
    if (trans.transactionHasBillItem != nil) {
        trans.transactionHasBillItem.dateTime = [NSDate date];
        trans.transactionHasBillItem.state = @"1";
    }
    
    if (trans.transactionHasBillRule != nil) {
        trans.transactionHasBillRule.dateTime = [NSDate date];
        trans.transactionHasBillRule.state = @"1";
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    
//    if (appDelegate.dropbox.drop_account.linked)
//    {
//        if (trans.expenseAccount != nil) {
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:trans.expenseAccount];
//        }
//        
//        if (trans.incomeAccount != nil) {
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:trans.incomeAccount];
//        }
//        
//        if (trans.payee != nil) {
//            [appDelegate.dropbox updateEveryPayeeDataFromLocal:trans.payee];
//        }
//
//        if (trans.category != nil) {
//            [appDelegate.dropbox updateEveryCategoryDataFromLocal:trans.category];
//        }
//        
//        if (trans.transactionHasBillItem != nil) {
//            [appDelegate.dropbox updateEveryBillItemDataFromLocal:trans.transactionHasBillItem];
//        }
//        
//        if (trans.transactionHasBillRule != nil) {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:trans.transactionHasBillRule];
//        }
//    }
    if ([PFUser currentUser])
    {
        if (trans.expenseAccount!=nil)
        {
            [[ParseDBManager sharedManager]updateAccountFromLocal:trans.expenseAccount];
        }
        if (trans.incomeAccount!=nil)
        {
            [[ParseDBManager sharedManager]updateAccountFromLocal:trans.incomeAccount];
        }
        if (trans.payee!=nil)
        {
            [[ParseDBManager sharedManager]updatePayeeFromLocal:trans.payee];
        }
        if (trans.category!=nil)
        {
            [[ParseDBManager sharedManager]updateCategoryFromLocal:trans.category];
        }
        if (trans.transactionHasBillItem!=nil)
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:trans.transactionHasBillItem];
            
        }
        if (trans.transactionHasBillRule!=nil)
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:trans.transactionHasBillRule];
        }
    }
}
-(void)saveBillItem:(EP_BillItem *)billItems{
    if (billItems.billItemHasBillRule != nil) {
        billItems.billItemHasBillRule.dateTime = [NSDate date];
        billItems.billItemHasBillRule.state = @"1";
    }
    
    if (billItems.billItemHasCategory != nil) {
        billItems.billItemHasCategory.state = @"1";
        billItems.billItemHasCategory.dateTime = [NSDate date];
    }
    
    if (billItems.billItemHasPayee != nil) {
        billItems.billItemHasPayee.dateTime = [NSDate date];
        billItems.billItemHasPayee.state = @"1";
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    
//    if (appDelegate.dropbox.drop_account.linked) {
//        if (billItems.billItemHasPayee != nil) {
//            [appDelegate.dropbox updateEveryPayeeDataFromLocal:billItems.billItemHasPayee];
//        }
//        
//        if (billItems.billItemHasCategory != nil) {
//            [appDelegate.dropbox updateEveryCategoryDataFromLocal:billItems.billItemHasCategory];
//        }
//        
//        if (billItems.billItemHasBillRule != nil) {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billItems.billItemHasBillRule];
//        }
//    }
    if ([PFUser currentUser])
    {
        if (billItems.billItemHasPayee!=nil)
        {
            [[ParseDBManager sharedManager]updatePayeeFromLocal:billItems.billItemHasPayee];
        }
        if (billItems.billItemHasCategory!=nil)
        {
            [[ParseDBManager sharedManager]updateCategoryFromLocal:billItems.billItemHasCategory];
        }
        if (billItems.billItemHasBillRule!=nil)
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:billItems.billItemHasBillRule];
        }
    }
}

//备份的时候，之前存在的数据直接删除就行了，
-(void)deleteAllTableDataBase_exceptSeetingTable:(BOOL)deleteSetting{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchAccountType = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    NSArray *accountArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccountType error:&error];
    for (int i=0; i<[accountArray count]; i++) {
        AccountType *oneAccount = [accountArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneAccount];
    }
    
    NSFetchRequest *fetchAccounts = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *accountsArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccounts error:&error];
    for (int i=0; i<[accountsArray count]; i++) {
        Accounts *oneAccount = [accountsArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneAccount];
    }
    
    //会删掉budgetTemplate 和 budgetItem
    NSFetchRequest *fetchbudgetTem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *budgetTemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchbudgetTem error:&error];
    for (int i=0; i<[budgetTemArray count]; i++) {
        BudgetTemplate *oneAccount = [budgetTemArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneAccount];
    }
    
    NSFetchRequest *fetchBillRule= [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSArray *billruleArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBillRule error:&error];
    for (int i=0; i<[billruleArray count]; i++) {
        EP_BillRule *oneBillRule = [billruleArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneBillRule];
    }
    
    
    NSFetchRequest *fetchcategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSArray *categoryArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchcategory error:&error];
    for (int i=0; i<[categoryArray count]; i++) {
        Category *oneCate = [categoryArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneCate];
    }
    
    NSFetchRequest *fetchpayee= [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSArray *payeeArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchpayee error:&error];
    for (int i=0; i<[payeeArray count]; i++) {
        Payee *onepayee = [payeeArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:onepayee];
    }
    
    NSFetchRequest *fetchtransaction= [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *transactionArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchtransaction error:&error];
    for (int i=0; i<[transactionArray count]; i++) {
        Transaction *oneTrans = [transactionArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneTrans];
    }
    
    
    
    NSFetchRequest *fetchBudgetItem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *budgetItemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBudgetItem error:&error];
    for (int i=0; i<[budgetItemArray count]; i++) {
        BudgetItem *oneAccount = [budgetItemArray objectAtIndex:i];
        [appDelegate_iPhone.managedObjectContext deleteObject:oneAccount];
    }
    
    if (deleteSetting) {
        NSFetchRequest *fetchSetting= [[NSFetchRequest alloc]initWithEntityName:@"Setting"];
        NSArray *settingArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchSetting error:&error];
        for (int i=0; i<[settingArray count]; i++) {
            Setting *oneAccount = [settingArray objectAtIndex:i];
            [appDelegate_iPhone.managedObjectContext deleteObject:oneAccount];
        }
    }
    
    [appDelegate_iPhone.managedObjectContext save:&error];
}


-(void)saveBudgetTemplateandtheBudgetItem:(BudgetTemplate *)budgetTemplate withAmount:(double)budgetAmount
{
    //（1）设置budgetTemplate的state=1与时间（2）设置budgetItem
    NSError *errors = nil;
    budgetTemplate.cycleType =@"No Cycle";
    budgetTemplate.startDate = [NSDate date];
    
   	budgetTemplate.isRollover =[NSNumber numberWithBool:FALSE];
  	budgetTemplate.amount = [NSNumber numberWithDouble:budgetAmount];
    
    budgetTemplate.dateTime = [NSDate date];
    budgetTemplate.state = @"1";
    if (![budgetTemplate.managedObjectContext save:&errors]) {
        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        
    }
    
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetTemplateDataFromLocal:budgetTemplate];
//    }

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetFromLocal:budgetTemplate];
    }
    //这里不太合理，并不一定是最后一个budget
    NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[budgetTemplate.budgetItems allObjects]];
    BudgetItem *newBudget = [budgetItemArray lastObject];
    newBudget.amount = budgetTemplate.amount;
    newBudget.dateTime = [NSDate date];
    newBudget.state = @"1";
    if (![budgetTemplate.managedObjectContext save:&errors]) {
        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        
    }
    
//    if (appDelegate_iPhone.dropbox.drop_account.linked) {
//        [appDelegate_iPhone.dropbox updateEveryBudgetItemDataFromLocal:newBudget];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetItemLocal:newBudget];
    }

}

-(void)checkifBudgetTemplateHasManyBudgetItem:(BudgetTemplate *)oneBudgetTemplate
{
//    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[oneBudgetTemplate.budgetItems allObjects]];
//    if ([budgetItemArray count]==0)
//    {
//        ;
//    }
//    else if ([budgetItemArray count]==1)
//    {
//        ;
//    }
//    else
//    {
//        //将获取到的圆环数据按照percent排序
//        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
//        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
//        [budgetItemArray sortUsingDescriptors:sorts];
//        [sort release];
//        [sorts release];
//        
//        for (int i=1; i<[budgetItemArray count]; i++)
//        {
//            BudgetItem *oneBudgetItem = [budgetItemArray objectAtIndex:i];
//            self deleteBudgetItemRel_withoutSync:<#(BudgetItem *)#>
//        }
//
//    }

}

#pragma mark Edit BillFather
-(void)editBillFather:(BillFather *)tmpBillFather withBillRule:(EP_BillRule *)tmpBillRule withDate:(NSDate *)tmpDate
{
    tmpBillFather.bf_billName = tmpBillRule.ep_billName;
    tmpBillFather.bf_billAmount = [tmpBillRule.ep_billAmount doubleValue];
    if (tmpDate != nil) {
        tmpBillFather.bf_billDueDate = tmpDate;
    }
    else
        tmpBillFather.bf_billDueDate = tmpBillRule.ep_billDueDate;
    tmpBillFather.bf_billEndDate = tmpBillRule.ep_billEndDate;
    tmpBillFather.bf_billNote = tmpBillRule.ep_note;
    tmpBillFather.bf_billRecurringType = tmpBillRule.ep_recurringType;
    tmpBillFather.bf_billReminderDate = tmpBillRule.ep_reminderDate;
    tmpBillFather.bf_billReminderTime = tmpBillRule.ep_reminderTime;
    
    tmpBillFather.bf_billRule = tmpBillRule;
    tmpBillFather.bf_billItem = nil;
    tmpBillFather.bf_payee = tmpBillRule.billRuleHasPayee;
    tmpBillFather.bf_category = tmpBillRule.billRuleHasCategory;
}

-(void)editBillFather:(BillFather *)tmpBillFather withBillItem:(EP_BillItem *)tmpBillItem
{
    tmpBillFather.bf_billName = tmpBillItem.ep_billItemName;
    tmpBillFather.bf_billAmount = [tmpBillItem.ep_billItemAmount doubleValue];
    if(tmpBillItem.ep_billItemDueDateNew!=nil){
        tmpBillFather.bf_billDueDate = tmpBillItem.ep_billItemDueDateNew;
    }
    tmpBillFather.bf_billEndDate = tmpBillItem.ep_billItemEndDate;
    tmpBillFather.bf_billRecurringType = tmpBillItem.ep_billItemRecurringType;
    tmpBillFather.bf_billReminderDate = tmpBillItem.ep_billItemReminderDate ;
    tmpBillFather.bf_billReminderTime = tmpBillItem.ep_billItemReminderTime;
    tmpBillFather.bf_billNote = tmpBillItem.ep_billItemNote;
    
    tmpBillFather.bf_billRule = tmpBillItem.billItemHasBillRule;
    tmpBillFather.bf_payee = tmpBillItem.billItemHasPayee;
    tmpBillFather.bf_category = tmpBillItem.billItemHasCategory;
    tmpBillFather.bf_billItem = tmpBillItem;
}

#pragma mark Get All Local Data Array
//-----------获取所有的本地表格的数据
-(NSArray *)getDataArray_TableName:(NSString *)m_tableName searchSubPre:(NSDictionary *)m_diction
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    
    NSEntityDescription *dataEntity = [[appDelegate.managedObjectModel entitiesByName] valueForKey:m_tableName];
    [fetchRequest setEntity:dataEntity];
    
    if (m_diction != nil)
    {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"uuid == $uuid"];
        NSPredicate *predicate = [predicate1 predicateWithSubstitutionVariables:m_diction];
        
        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allresults = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allresults;
}


//将category中的not sure改称others
-(void)checkCategorytoChangeNotsureCategory{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	
	NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
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
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
            return;
        }
    }
    
}


-(void)setAccountOrderIndex{
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //首先获取所有的Account
	NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest2 setEntity:entity2];
//	NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
//    [fetchRequest2 setPredicate:predicate];
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
	NSArray *sortDescriptors2 = [[NSArray alloc] initWithObjects:sortDescriptor2, nil];
	
	[fetchRequest2 setSortDescriptors:sortDescriptors2];
 	NSArray* objects2 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
 	NSMutableArray *tmpAccountArray2 = [[NSMutableArray alloc] initWithArray:objects2];

    
    BOOL hasBeenSequence = NO;
    for (int i=0; i<[tmpAccountArray2 count]; i++) {
        Accounts *oneAccount = [tmpAccountArray2 objectAtIndex:i];
        if ([oneAccount.orderIndex integerValue]==0 || oneAccount.orderIndex==nil) {
            continue;
        }
        else{
            hasBeenSequence = YES;
        }
    }
    //判断是不是被排序过了 ，如果被排序过了 就不排序了
    if (!hasBeenSequence) {
        NSError *error = nil;
        for (int i=0; i<[tmpAccountArray2 count]; i++) {
            
            Accounts *oneAccount = [tmpAccountArray2 objectAtIndex:i];
            //如果写成int类型的数据输入会崩溃哦？？？？
            
            oneAccount.orderIndex = [NSNumber numberWithInteger:i];
            //            [appDelegate.managedObjectContext save:&error];
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
        }
    }
    
}
-(void)setTransactionType{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
//    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
//    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *allTransactionArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    //获得所有的trans 再重新写数据
    for (int i=0; i<[allTransactionArray count]; i++) {
        Transaction *oneTransaction = [allTransactionArray objectAtIndex:i];
        
        if ([oneTransaction.type integerValue] >=0 && oneTransaction.recurringType == nil) {
            if ([oneTransaction.type integerValue]==0) {
                oneTransaction.recurringType = @"Never";
            }
            else if ([oneTransaction.type integerValue]==1){
                oneTransaction.recurringType = @"Daily";
            }
            else if ([oneTransaction.type integerValue]==2){
                oneTransaction.recurringType = @"Weekly";
            }
            else if ([oneTransaction.type integerValue]==3){
                oneTransaction.recurringType = @"Every 2 Weeks";
            }
            else if ([oneTransaction.type integerValue]==4){
                oneTransaction.recurringType = @"Semimonthly";
            }
            else if ([oneTransaction.type integerValue]==5){
                oneTransaction.recurringType = @"Monthly";
            }
            else if ([oneTransaction.type integerValue]==6){
                oneTransaction.recurringType = @"Every 3 Months";
            }
            else if ([oneTransaction.type integerValue]==7){
                oneTransaction.recurringType = @"Every 6 Months";
            }
            else if ([oneTransaction.type integerValue]==8){
                oneTransaction.recurringType = @"Every Year";
            }
            else if ([oneTransaction.recurringType isEqualToString:@"No Recurring"])
            {
                oneTransaction.recurringType = @"Never";
            }
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
        }
    }
}
-(void)setCategoryTransactionType{
    
    NSError *error = nil;
    
    PokcetExpenseAppDelegate *appDelegate_iPhone =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSMutableArray *unDefaultCategoryArray = [[NSMutableArray alloc]init];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"categoryName" ascending:YES];
    //这里不需要加入state==1的判断
    NSArray *sorts = [[NSArray alloc]initWithObjects:sort, nil];
    [fetch setSortDescriptors:sorts];
    
    NSArray *tmpArray = [[NSArray alloc]initWithArray:[appDelegate_iPhone.managedObjectContext executeFetchRequest:fetch error:&error]];
    [unDefaultCategoryArray setArray:tmpArray];
    
    for (int i=0; i<[unDefaultCategoryArray count]; i++) {
        Category *tmpOneCategory = [unDefaultCategoryArray objectAtIndex:i];
        if ([tmpOneCategory.categoryName isEqualToString:@"Not Sure"]) {
            tmpOneCategory.categoryName = @"Others";
        }
        
        NSArray *categoryTransArray = [[NSArray alloc]initWithArray:[tmpOneCategory.transactions allObjects]];
        BOOL hasExpenseTrans = NO;
        BOOL hasIncomeTrans = NO;
        //判断是不是既有expense,又有income,这里是判断transactionType,勿修改！！！
        for (int m=0; m<[categoryTransArray count]; m++) {
            Transaction *tmpOneTrans = [categoryTransArray objectAtIndex:m];
            
            if ([tmpOneTrans.transactionType isEqualToString:@"expense"]) {
                hasExpenseTrans= YES;
            }
            else if ([tmpOneTrans.transactionType isEqualToString:@"income"])
                hasIncomeTrans = YES;
        }
        
        //针对三种情况进行修改category
        if (hasExpenseTrans && !hasIncomeTrans) {
            tmpOneCategory.categoryType = @"EXPENSE";
        }
        else if (!hasExpenseTrans && hasIncomeTrans){
            tmpOneCategory.categoryType = @"INCOME";
        }
        else if(hasIncomeTrans && hasExpenseTrans) {
            //新建一个category,管理对应的income类型的transaction
            tmpOneCategory.categoryType = @"EXPENSE";
            
            Category *tmpNewCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
            tmpNewCategory.categoryType = @"INCOME";
            tmpNewCategory.isDefault = [NSNumber numberWithBool:NO];
            tmpNewCategory.isSystemRecord = tmpOneCategory.isSystemRecord;
            tmpNewCategory.categoryName = tmpOneCategory.categoryName;
            tmpNewCategory.iconName = tmpOneCategory.iconName;
            tmpNewCategory.others = tmpOneCategory.others;
            [appDelegate_iPhone.managedObjectContext save:&error];
            
            for (int k=0; k<[categoryTransArray count]; k++) {
                
                Transaction *tmpOneTrans = [categoryTransArray objectAtIndex:k];
                
                if ([tmpOneTrans.transactionType isEqualToString:@"income"]){
                    [tmpNewCategory addTransactionsObject:tmpOneTrans];
                    [tmpOneCategory removeTransactionsObject:tmpOneTrans];
                }
            }
            
            if ([tmpNewCategory.categoryName isEqualToString:@"House Hold"]) {
                tmpNewCategory.categoryName = @"Household";
            }
            
        }
        else if(!hasIncomeTrans && !hasIncomeTrans && [tmpOneCategory.categoryType length]==0)
        {
            tmpOneCategory.categoryType = @"EXPENSE";
            
        }
        if (![appDelegate_iPhone.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
        
        if ([tmpOneCategory.categoryName isEqualToString:@"House Hold"]) {
            tmpOneCategory.categoryName = @"Household";
            if (![appDelegate_iPhone.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
        }
    }
    
    
    [unDefaultCategoryArray removeAllObjects];
    
    
    
    NSArray *tmpArray2 = [[NSArray alloc]initWithArray:[appDelegate_iPhone.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    [unDefaultCategoryArray setArray:tmpArray2];

    
    BOOL hasOtherIncomeCategory = NO;
    for (int i=0; i<[unDefaultCategoryArray count]; i++) {
        Category *tmpOneCategory = [unDefaultCategoryArray objectAtIndex:i];
        if ([tmpOneCategory.categoryType isEqualToString:@"INCOME"] && [tmpOneCategory.categoryName isEqualToString:@"Others"]) {
            hasOtherIncomeCategory = YES;
            tmpOneCategory.isDefault = [NSNumber numberWithInt:YES];
            [appDelegate_iPhone.managedObjectContext save:&error];
            break;
        }
    }
    
    if (!hasOtherIncomeCategory) {
        Category *tmpNewCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:appDelegate_iPhone.managedObjectContext];
        tmpNewCategory.categoryType = @"INCOME";
        tmpNewCategory.isDefault = [NSNumber numberWithBool:YES];
        tmpNewCategory.isSystemRecord = [NSNumber numberWithBool:YES];
        tmpNewCategory.categoryName = @"Others";
        //设置其他others的categoryName
        tmpNewCategory.iconName = @"uncategorized_income.png";
    }
    
    
    
//    NSString *fetchName = @"";
// 	fetchName = @"fetchCategoryByIncomeType";
//	
//	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:  nil];
//	NSFetchRequest *fetchRequest111 = [appDelegate_iPhone.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
//    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
//	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
//	[fetchRequest111 setSortDescriptors:sortDescriptors];
//	NSArray *objects = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchRequest111 error:&error];
//	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
// 	[sortDescriptor release];
//	[sortDescriptors release];
}

-(void)changeTransactionRecurringType
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"recurringType contains[c] %@",@"Never"];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    for (long int i=0; i<[objects count]; i++) {
        Transaction *trans = [objects objectAtIndex:i];
        trans.recurringType = @"Never";
        [appDelegate.managedObjectContext save:&error];
    }
}

#pragma mark Set Table UUID
-(void)setAllLocalTables_state_uuid_DateTime{
    
    NSError *error = nil;
    
    [self setAccountTypeTable_state_uuid_dateTime];
    
    [self setCategoryTable_state_uuid_DateTime];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //payee
    NSFetchRequest *fetchRequest_payee = [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    
    NSArray *object_payee = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_payee error:&error]];
    for ( int i=0; i<[object_payee count]; i++) {
        Payee *oneAccountType = [object_payee objectAtIndex:i];
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }

    
    
    //account
    NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *object_account = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error]];
    for ( int i=0; i<[object_account count]; i++) {
        Accounts *oneAccount = [object_account objectAtIndex:i];
        oneAccount.uuid = [EPNormalClass GetUUID];
        oneAccount.state = @"1";
        oneAccount.dateTime_sync = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];

    
    
    
    
    //budget template
    NSFetchRequest *fetchRequest_budgetTemplate = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *object_budgetTemplate = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_budgetTemplate error:&error]];
    for ( int i=0; i<[object_budgetTemplate count]; i++) {
        BudgetTemplate *oneAccountType = [object_budgetTemplate objectAtIndex:i];
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];

    
    
    //budget item
    NSFetchRequest *fetchRequest_budgetItem = [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *object_budgetItem = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_budgetItem error:&error]];
    for ( int i=0; i<[object_budgetItem count]; i++) {
        BudgetItem *oneAccountType = [object_budgetItem objectAtIndex:i];
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];
 
    
    
    //budgettransfer
    NSFetchRequest *fetchRequest_budgetTransfer = [[NSFetchRequest alloc]initWithEntityName:@"BudgetTransfer"];
    NSArray *object_budgetTransfer = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_budgetTransfer error:&error]];
    for ( int i=0; i<[object_budgetTransfer count]; i++) {
        BudgetTransfer *oneAccountType = [object_budgetTransfer objectAtIndex:i];
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime_sync = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];

    
    
    //transaction
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFetchRequest *fetchRequest_transaction = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *object_transaction = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_transaction error:&error]];
    for ( int i=0; i<[object_transaction count]; i++) {
        Transaction *oneAccountType = [object_transaction objectAtIndex:i];
        
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime_sync = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];


     //billrule
     NSFetchRequest *fetchRequest_billRule = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
     NSArray *object_billRule = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_billRule error:&error]];
     for ( int i=0; i<[object_billRule count]; i++) {
     EP_BillRule *oneAccountType = [object_billRule objectAtIndex:i];
     oneAccountType.uuid = [EPNormalClass GetUUID];
     oneAccountType.state = @"1";
     oneAccountType.dateTime = [NSDate date];
     }
     [appDelegate.managedObjectContext save:&error];
     
     
     //bill item
     NSFetchRequest *fetchRequest_billItem = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillItem"];
     NSArray *object_billItem = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_billItem error:&error]];
     for ( int i=0; i<[object_billItem count]; i++) {
     EP_BillItem *oneAccountType = [object_billItem objectAtIndex:i];
     oneAccountType.uuid = [EPNormalClass GetUUID];
     oneAccountType.state = @"1";
     oneAccountType.dateTime = [NSDate date];
     }
     [appDelegate.managedObjectContext save:&error];

    
    //setting
    NSFetchRequest *fetchRequest_setting = [[NSFetchRequest alloc]initWithEntityName:@"Setting"];
    NSArray *object_Setting = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_setting error:&error]];
    for ( int i=0; i<[object_Setting count]; i++) {
        Setting *oneAccountType = [object_Setting objectAtIndex:i];
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    [appDelegate.managedObjectContext save:&error];

    
    
}

-(void)setTransactionTable_UUID_5_2VersionOnly
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSFetchRequest *fetchRequest_transaction = [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *object_transaction = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_transaction error:&error]];
    for ( int i=0; i<[object_transaction count]; i++) {
        Transaction *oneAccountType = [object_transaction objectAtIndex:i];
        
        oneAccountType.uuid = [EPNormalClass GetUUID];
        oneAccountType.transactionstring = @"";
    }
    [appDelegate.managedObjectContext save:&error];

}

-(void)setAccountTypeTable_state_uuid_dateTime{
    PokcetExpenseAppDelegate *appDelegate =(PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSError *error = nil;
    //accountType
    NSFetchRequest *fetchRequest_accountType = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    
    NSArray *object_accountType = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_accountType error:&error]];
    for ( int i=0; i<[object_accountType count]; i++) {
        AccountType *oneAccountType = [object_accountType objectAtIndex:i];
        
        if ([oneAccountType.typeName isEqualToString:@"Asset"]) {
            oneAccountType.uuid =@"F2243FC7-6E01-4CD8-8A03-6AE56E7B20E1";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
        }
        else if ([oneAccountType.typeName isEqualToString:@"Cash"]) {
            oneAccountType.uuid =@"9832B8FA-537C-4963-8CA9-19385E9732E5";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Checking"]) {
            oneAccountType.uuid =@"9C4251B9-5B57-4472-8B6E-BAF1A4D60650";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Credit Card"]) {
            oneAccountType.uuid =@"4C9ACC13-D22D-4A7F-ABB3-7A5A7C94EAA2";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Debit Card"]) {
            oneAccountType.uuid =@"A54BB0EF-17DF-4BA5-BB1E-A24AC31DA138";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Investing/Retirement"]) {
            oneAccountType.uuid =@"A8D6FFD2-602B-4E23-AA86-44751A2234C6";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Loan"]) {
            oneAccountType.uuid =@"B10A95AC-6BA2-401A-9A67-AF667313872F";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if ([oneAccountType.typeName isEqualToString:@"Savings"]) {
            oneAccountType.uuid =@"3E3BEB88-153A-4ACB-AE15-3B2B7935D56E";
            oneAccountType.isDefault = [NSNumber numberWithBool:NO];
            
        }
        else if([oneAccountType.typeName isEqualToString:@"Others"]){
            oneAccountType.uuid = @"EB77B173-7BE4-458E-B1DD-0309EBF3A12C";
            oneAccountType.isDefault = [NSNumber numberWithBool:YES];
            oneAccountType.iconName = @"icon_other.png";
            
        }
        else{
            oneAccountType.uuid = [EPNormalClass GetUUID];
        }
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
    
    NSFetchRequest *fetchRequest_accountType2 = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    
    NSArray *object_accountType2 = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_accountType2 error:&error]];
    BOOL isFoundOthers = NO;
    for (int i=0; i<[object_accountType2 count]; i++) {
        AccountType *oneAccountType = [object_accountType2 objectAtIndex:i];
        if ([oneAccountType.typeName isEqualToString:@"Others"]) {
            isFoundOthers = YES;
            break;
        }
    }
    if (!isFoundOthers) {
        AccountType *newAccountType = [NSEntityDescription insertNewObjectForEntityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
        newAccountType.typeName = @"Others";
        newAccountType.iconName = @"icon_other.png";
        
        newAccountType.uuid = @"EB77B173-7BE4-458E-B1DD-0309EBF3A12C";
        newAccountType.isDefault = [NSNumber numberWithBool:YES];
        
        newAccountType.dateTime = [NSDate date];
        newAccountType.state = @"1";
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }

    
}

-(void)setCategoryTable_state_uuid_DateTime{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    //category
    NSFetchRequest *fetchRequest_category = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    
    NSArray *object_category = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest_category error:&error]];
    for ( int i=0; i<[object_category count]; i++) {
        Category *oneAccountType = [object_category objectAtIndex:i];
        
        if ([oneAccountType.categoryName isEqualToString:@"Auto"]) {
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"0F6FD33B-E575-448D-9DFC-FBDD46BB244F";
            }
            else if ([oneAccountType.categoryType isEqualToString:@"INCOME"])
                oneAccountType.uuid = @"3864D569-22C0-45DF-B40A-CE4E81BC7DA0";
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Auto: Gas"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"33F11CA3-50C8-491D-823A-66F8DA2632D9";
            }
            else{
                oneAccountType.uuid = @"6E4247A5-0611-46F0-9B4E-11E4504B19D1";
            }
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Auto: Registration"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"5760538F-A7CF-4EEC-873C-03EF9A7D6FE0";
                
            }
            else{
                oneAccountType.uuid = @"2E6CEC85-C505-4220-A483-258A8DC083AA";
            }
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Auto: Service"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"1D1C1F8D-4CE7-4467-AA1C-8C99DFFE64F8";
                
            }
            else{
                oneAccountType.uuid = @"5B04191C-4C14-4245-BC67-1E8B13C159A7";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Bank Charge"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"EBBE58EC-32F7-49FB-8C26-5E49572D0355";
                
            }
            else{
                oneAccountType.uuid = @"104A47CE-E495-468A-A7CC-2479DCE94126";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Bonus"]){
            //系统自带
            if ([oneAccountType.categoryType isEqualToString:@"INCOME"]) {
                oneAccountType.uuid = @"65E255EE-B01C-498A-8A6D-980787DBB16B";
                
            }
            else{
                oneAccountType.uuid = @"93AE1F4F-4AD9-49C3-B02A-67FD850F1E20";
            }
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Cash"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"CBB79C68-B40A-4FBC-A89D-714EEF0C610C";
                
            }
            else{
                oneAccountType.uuid = @"F7685826-B2BB-4DC0-852D-6993301E8B08";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Charity"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"E1A3532A-77E6-4E72-A16F-3E9A7C36E81E";
                
            }
            else{
                oneAccountType.uuid = @"C2ECCA80-21A7-4C26-86D8-FE74AB09950C";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Childcare"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"79AA0903-0A7A-4923-A92D-5EA59F71A43C";
                
            }
            else{
                oneAccountType.uuid = @"94BD91CB-AA55-4B77-A8E4-FFB512EAADD9";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Clothing"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"F6C83821-FCEF-492C-B4EE-940C80457546";
                
            }
            else{
                oneAccountType.uuid = @"F30E53E7-2132-4249-91B2-2188494DB51C";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Credit Card Payment"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"03D897A0-DD0F-4F4D-A72A-03DA70348BFE";
                
            }
            else{
                oneAccountType.uuid = @"0C9657DF-804A-4BCB-957E-CB05228F264A";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Dining"])
        {
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"4349B269-0856-436E-98E0-D5C5DE0B289D";
            }
            else
                oneAccountType.uuid = @"041B324C-7CF6-4814-B0BE-C1FDF86EA1CE";

        }
        
        else if ([oneAccountType.categoryName isEqualToString:@"Eating Out"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"CA6C55B4-2B95-4921-9AE4-74E76A253426";
            }
            else{
                oneAccountType.uuid = @"6E7A142E-5D98-408C-A216-E6FC63F29163";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Education"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"B7AD59FE-13C4-4476-8DE0-D8CC94F7A20D";
                
            }
            else{
                oneAccountType.uuid = @"EB0EFA8E-6B44-4D55-9781-86D71DDE575C";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Entertainment"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"9344BA4C-7B9E-40D5-8A05-9FECD60C63AB";
                
            }
            else{
                oneAccountType.uuid = @"1C80164D-2AC2-480E-80A8-022E0A51D3B2";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Gifts"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"A515223D-318F-420F-B366-CE207EC2D512";
                
            }
            else{
                oneAccountType.uuid = @"9F6FA33D-ED53-4CF7-8D00-C6828AB56188";
            }
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Groceries"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"41FC8F1F-CBEF-48F9-B5CC-BB47956D79B7";
                
            }
            else{
                oneAccountType.uuid = @"747A8032-AD78-4A2F-AE14-EB79ECF8A152";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Health & Fitness"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"8997A036-74B9-4140-BF62-0ABC349C0E08";
                
            }
            else{
                oneAccountType.uuid = @"18080B3C-AD03-4F2E-A756-5F194D30D5E6";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Home Repair"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"1DF5FB17-EAA2-4890-81CD-15DFCCDEB1A2";
                
            }
            else{
                oneAccountType.uuid = @"93251F60-6556-4652-8CEC-9889EDC40141";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Household"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"283C5A28-D76A-4EF5-9713-31FB37B6D963";
                
            }
            else{
                oneAccountType.uuid = @"634E998F-6821-4881-BB4E-BD9C9F4D2AAE";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Insurance"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"87F4F37D-1373-4404-ADFD-6AB23823853E";
                
            }
            else{
                oneAccountType.uuid = @"5B797C0B-2F3F-43F6-A563-D227DFFF1B64";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Interest Exp"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"D4AB78F5-32CE-434F-9A1D-F25FE681E71A";
                
            }
            else{
                oneAccountType.uuid = @"E8014CB3-0A4C-4897-B823-4AB986446AE0";
            }
        }
        //        else if ([oneAccountType.categoryName isEqualToString:@"IRA Contrib"]){
        //            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
        //                oneAccountType.uuid = @"E3EB044D-F2BA-4239-8DA5-4C84D4F87616";
        //
        //            }
        //            else{
        //                oneAccountType.uuid = @"9F06CDB8-07AE-42AE-A2C6-E078D53064C8";
        //            }
        //        }
        else if ([oneAccountType.categoryName isEqualToString:@"Loan"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"1E32DE55-5EA4-4519-A3F2-AB21861F9B03";
                
            }
            else{
                oneAccountType.uuid = @"51658A9C-FAA8-4E42-AE62-FA1A7FCE8C1F";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Medical"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"C8A54F8C-F440-4FE8-9526-B650928F02D4";
                
            }
            else{
                oneAccountType.uuid = @"DB8B1A4A-266E-48DC-85B1-9DD2999559CA";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Misc"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"7960FFF8-874B-4CD7-B0DF-02A8D7CA7756";
                
            }
            else{
                oneAccountType.uuid = @"26B1FEAC-06E6-4367-A37A-731DFFE9A7B3";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Mortgage Payment"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"45643F47-6105-4E21-BD54-9C1E74105D71";
                
            }
            else{
                oneAccountType.uuid = @"13299630-AF8C-414E-9DC1-879C8757ECB2";
            }
        }
        //        else if ([oneAccountType.categoryName isEqualToString:@"Kids"]){
        //            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
        //                oneAccountType.uuid = @"38B27F70-2C9F-4705-AF3B-929BD2711D21";
        //
        //            }
        //            else{
        //                oneAccountType.uuid = @"1F0163BB-E7AB-43D8-9CE8-965978D615BB";
        //            }
        //        }
        else if ([oneAccountType.categoryName isEqualToString:@"Pets"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"0206FC4C-9291-40F6-9242-16A673588515";
                
            }
            else{
                oneAccountType.uuid = @"0798D720-5D3A-43A1-B404-2BC763FF5104";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Others"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"E15F57E7-E976-449D-831F-BCD4631C73C5";
            }
            else{
                oneAccountType.uuid = @"6CFF80C6-6080-4263-80D9-E0ED8DC4E606";
            }
            
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Rent"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"CD0F4454-38FA-40C3-8651-CAAD7238773E";
                
            }
            else{
                oneAccountType.uuid = @"974EC2F8-68F6-48AC-8EA9-B5B2A2144965";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Salary"]){
            //系统自带
            if ([oneAccountType.categoryType isEqualToString:@"INCOME"]) {
                oneAccountType.uuid = @"553E1F3C-2121-43FA-B6EF-9673C9C79F1B";
                
            }
            else{
                oneAccountType.uuid = @"D4D60BE8-98BF-45EC-B196-CD683FDAFB93";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Savings Deposit"]){
            //系统自带
            if ([oneAccountType.categoryType isEqualToString:@"INCOME"]) {
                oneAccountType.uuid = @"3944081E-93F6-4541-965E-F3077FD9695E";
                
            }
            else{
                oneAccountType.uuid = @"C9D8331B-75A2-423E-9C41-D66A146DAD4F";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"5C7368FA-1E98-4777-8E0E-9D470283AE8C";
                
            }
            else{
                oneAccountType.uuid = @"A0FDDBED-2389-489C-8FAA-F21DCC623C48";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: Fed"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"0D997AF9-3C18-45A4-AB44-C005D10CC12D";
                
            }
            else{
                oneAccountType.uuid = @"33A8397D-6716-4C26-BB85-555AE25B606F";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: Medicare"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"8DF4ACB4-B4E9-4AD1-8B6E-C670CF0E1B50";
                
            }
            else{
                oneAccountType.uuid = @"E4953460-C7FF-42C3-B25D-30B08FB2B8D8";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: Other"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"1E85D7CF-2263-4F01-839B-510CED8D5147";
                
            }
            else{
                oneAccountType.uuid = @"753CDC00-B327-4D57-B749-A95F3DD42209";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: Property"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"E1FB0951-9A62-4801-954C-99B0C87B1BDE";
                
            }
            else{
                oneAccountType.uuid = @"5BDB9B8A-3B31-49A9-91EB-C63A6BB6F72E";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: SDI"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"88D34AA2-A3F0-4A2B-8C47-B6BB26A043FB";
                
            }
            else{
                oneAccountType.uuid = @"1C91225F-BE00-4272-85F3-4EB43DDC4EB8";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: Soc Sec"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"779F4166-A755-4D91-AB87-B3328BC32B9E";
                
            }
            else{
                oneAccountType.uuid = @"8F6A6DA2-5359-4EFC-90F0-7B2150453D30";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax: State"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"0B171B72-1C7A-4C2F-A7AC-A4FA50B385BB";
                
            }
            else{
                oneAccountType.uuid = @"91D89B9E-10DA-4D9A-B95C-7B9DECC049EC";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Travel"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"8002FBE6-DE5A-4C60-937E-4904204FB17C";
                
            }
            else{
                oneAccountType.uuid = @"1E5DB5D1-8C28-4476-9274-F1824191E177";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"9482F32A-6EFF-42CF-90B8-1C5F18C9E851";
                
            }
            else{
                oneAccountType.uuid = @"AC715026-0A1F-416C-9349-D3CF23D6084F";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Cable TV"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"DA648D8C-C1C2-4824-8D06-6CA1D0C534E7";
                
            }
            else{
                oneAccountType.uuid = @"E1B816AF-1F5D-453C-BA7D-639F55862750";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Garbage & Recycling"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"FA8FD9FE-B71A-40C9-A648-99F002EDC005";
                
            }
            else{
                oneAccountType.uuid = @"4F4D0A38-D610-434A-97B9-64771BA575E5";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Gas& Electric"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"8AED613B-DC33-4A1D-9284-48EAB43744A5";
                
            }
            else{
                oneAccountType.uuid = @"503C5728-B6FB-4458-808C-46701646D7A8";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Internet"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"04CDA8B1-E0E8-4B39-8143-BE47DC963EE9";
                
            }
            else{
                oneAccountType.uuid = @"94CE0242-A11A-4A99-865E-EA4ADA0CA086";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Telephone"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"9810BE73-F5A8-49BC-85DE-5C1E5E8F8333";
                
            }
            else{
                oneAccountType.uuid = @"C0242C3B-9944-454F-86BC-F4F5D9B0163C";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Utilities: Water"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"1FD9D0CA-D3DF-4640-A541-58FA1C5338E1";
                
            }
            else{
                oneAccountType.uuid = @"913BA2AC-EB0C-4F7C-87F9-863EFAEEAFB4";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Transport"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"E3EB044D-F2BA-4239-8DA5-4C84D4F87616";
                
            }
            else{
                oneAccountType.uuid = @"8D9A1859-1D0B-43E1-A42E-545BDF7EE5C2";
            }
        }
        else if ([oneAccountType.categoryName isEqualToString:@"Tax Refund"]){
            if ([oneAccountType.categoryType isEqualToString:@"EXPENSE"]) {
                oneAccountType.uuid = @"042C41E2-B189-4DC1-A463-C040E543DF17";
                
            }
            else{
                oneAccountType.uuid = @"38B27F70-2C9F-4705-AF3B-929BD2711D21";
            }
        }
        //之前只判断了这几个，是因为初步的定性是 免费版可以backup现在是免费版收费版都可以，所以现在有问题了，其他的category也要处理
        else{
            oneAccountType.uuid = [EPNormalClass GetUUID];
        }
        
        [EPNormalClass GetUUID];
        
        
        oneAccountType.state = @"1";
        oneAccountType.dateTime = [NSDate date];
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }

}


//新应用初次登录的时候，创建一个默认的账户
-(void)createDefaultAccount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:DEFAULTACCOUNT])
    {
        return;
    }
    else
    {
        NSError *error =nil;
        
        NSArray* defaultArr = [[XDDataManager shareManager]getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
        if (defaultArr.count > 0) {
            return;
        }
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeName" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        AccountType *defaultAccountType = nil;
        BOOL hasFoundDefaultAccount = NO;
        for (int i=0; i<[objects count]; i++) {
            AccountType *oneAccountType = [objects objectAtIndex:i];
            if ([oneAccountType.typeName isEqualToString:@"Others"]) {
                defaultAccountType = oneAccountType;
                hasFoundDefaultAccount = YES;
                break;
            }
        }
        
        if (!hasFoundDefaultAccount && [objects count]>0) {
            defaultAccountType = [objects objectAtIndex:0];
        }
        

        
        
        //create default account
        Accounts *accounts= [NSEntityDescription insertNewObjectForEntityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
        
        
        //1.name
        accounts.accName = @"Default Account";
        //2.amount
        accounts.amount = [NSNumber numberWithDouble:0.00];
        //3.accountType
        accounts.accountType = defaultAccountType;
        //4.dateTime
        accounts.dateTime = [NSDate date];
        //5.autoClear
        accounts.autoClear = [NSNumber numberWithBool:YES];
        
        //6.orderIndex
        accounts.orderIndex =[NSNumber numberWithLong:0];
        
        //7.uuiv Guin 固定的uuid这样同步的时候 不同的设备上面只会有一个了
        accounts.uuid =  @"E0552410-9082-4B31-96D3-7A777F046AB4";
        
        //8.dateTime_sync
        accounts.dateTime_sync = [NSDate date];
        
        accounts.others = @"Default";
        //9.state
        accounts.state = @"1";
        
        accounts.updatedTime=[NSDate date];
        
        if(![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        }
        
        //sync
        
//        if ([appDelegate .dropbox drop_account] != nil)
//        {
//            [appDelegate.dropbox updateEveryAccountDataFromLocal:accounts];
//        }
        [userDefaults setBool:YES forKey:DEFAULTACCOUNT];
        //存储的时候要加这一句
        [userDefaults synchronize];
        
        [[ParseDBManager sharedManager]updateAccountFromLocal:accounts];
    }
    
}

-(void)getOldDataBaseInsertToNewDataBase_isBackup:(BOOL)isBackup{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error= nil;
    sqlite3 *oldDatabase = nil;
	sqlite3 *curDatabase = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //if is back up,change the file name and Image Data
    if (isBackup)
    {
        //获取老的三个文件
        NSString *newsqlPath = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite"];
        NSString *currentaqlitaPaht = [documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite.p"];
        [fileManager moveItemAtPath:currentaqlitaPaht toPath:newsqlPath error:&error];
        
        NSString *newwalPath = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-wal"];
        NSString *currentwalzaPaht = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-wal.p"];
        [fileManager moveItemAtPath:currentwalzaPaht toPath:newwalPath error:&error];
        
        NSString *newshmPath = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-shm"];
        NSString *currentshmzaPaht = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-shm.p"];
        [fileManager moveItemAtPath:currentshmzaPaht toPath:newshmPath error:&error];
        
        //增加图片
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
        
        for (NSString *fname in array)
        {
            if([fname length]>6)
            {
                if([[fname substringFromIndex:[fname length]-6] isEqualToString:@".jpg.p"])
                {
                    NSString * strName = [fname substringToIndex:[fname length]-2];
                    [fileManager moveItemAtPath:fname toPath:strName error:&error];
                }
            }
        }
        for (NSString *fname in array)
        {
            if([fname length]>2)
            {
                if([[fname substringFromIndex:[fname length]-2] isEqualToString:@".p"])
                {
                    [fileManager removeItemAtPath:fname error:&error];
                }
            }
        }

    }
    
    //获取老的三个文件
    NSString *newwalPath = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-wal"];
    
    NSString *newshmPath = [documentsDirectory stringByAppendingString:@"/PocketExpense1.0.0.sqlite-shm"];
    NSString *oldPath2=[documentsDirectory stringByAppendingPathComponent:@"PocketExpense1.0.0.sqlite"];
    
    NSString *curPath=[documentsDirectory stringByAppendingPathComponent:@"Expense5.0.0.sqlite"];
    long long result = -1;
    sqlite3_stmt* statement = nil;
    
    
    //如果存在老用户的话，就先把本地的数据给删掉
    if([fileManager fileExistsAtPath:oldPath2])
	{
        
        [appDelegate_iPhone.epdc deleteAllTableDataBase_exceptSeetingTable:YES];
        
		result =  sqlite3_open([oldPath2 UTF8String], &oldDatabase);
		result =  sqlite3_open([curPath UTF8String], &curDatabase);
        
        
        //////Setting
        BOOL budgetModelisNew = NO;//1的时候表示是简单模式
        NSString *versionNumber = nil;
        long periodNum_setting = 0;
        //收费版因为是一个新应用，所以backup过来的数据只有是4.5.1之前的才会跑这一段，那么不保存原先的others19是可以的 setting
		const char* sqlPeriod="SELECT Z_PK,Z_ENT,Z_OPT,ZCURRENCY,ZPASSCODE,ZBUDGETNEWSTYLE,ZOTHERS20 FROM ZSETTING";
        
        
        if(sqlite3_prepare_v2(oldDatabase, sqlPeriod, -1, &statement, NULL)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                const unsigned char *zcurrency = sqlite3_column_text(statement, 3);
                const unsigned char *zpasscode = sqlite3_column_text(statement, 4);
                const BOOL zbusgetisnew = sqlite3_column_int(statement, 5);
                const unsigned char *zothers20 = sqlite3_column_text(statement, 6);
                
                budgetModelisNew = zbusgetisnew;
                if (zothers20 != nil) {
                    versionNumber =  [NSString stringWithCString:(const char *)zothers20 encoding:NSUTF8StringEncoding];
                }
                
				const char* insert_sql = "INSERT INTO ZSETTING (Z_PK,Z_ENT,Z_OPT,ZCURRENCY,ZPASSCODE,ZBUDGETNEWSTYLE,ZOTHERS20) VALUES (?,?,?,?,?,?,?)";
                
				sqlite3_stmt *insert_statement=nil;
                
				result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
				result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 4, (char *)zcurrency         , -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 5, (char *)zpasscode         , -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_int(insert_statement, 6, (BOOL)zbusgetisnew);
				result = sqlite3_bind_text(insert_statement, 7, (char *)zothers20         , -1,SQLITE_TRANSIENT);
				
				result=sqlite3_step(insert_statement);
				result=sqlite3_finalize(insert_statement);
                
				periodNum_setting = sqlite3_last_insert_rowid(curDatabase);
			}
		}
		if(periodNum_setting!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=15";
            
			sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_setting);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);
        
        
        
        //////AccountType执行读取操作
        long periodNum_accountType = 0;
        const char* sqlPeriod_accounttype="SELECT Z_PK,Z_ENT,Z_OPT,ZISDEFAULT,ZICONNAME,ZTYPENAME FROM ZACCOUNTTYPE";
        if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_accounttype, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                //定义获取属性的指针，第二个参数是需要获取的列数据在result列表中的顺序
                const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                const BOOL zisdefault = sqlite3_column_int(statement, 3);
                const unsigned char *ziconname = sqlite3_column_text(statement, 4);
                const unsigned char *ztypename = sqlite3_column_text(statement, 5);
                
                //定义插入语句描述
                const char* insert_sql = "INSERT INTO ZACCOUNTTYPE (Z_PK,Z_ENT,Z_OPT,ZISDEFAULT,ZICONNAME,ZTYPENAME) VALUES (?,?,?,?,?,?)";
                
                //声明一个插入语句指针
                sqlite3_stmt *insert_statement=nil;
                
                //执行插入语句 sqlite3_prepare_v2执行成功返回0
                result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_int(insert_statement, 4, (BOOL)zisdefault);
                result = sqlite3_bind_text(insert_statement, 5, (char *)ziconname         , -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 6, (char*)ztypename, -1,SQLITE_TRANSIENT);
                
                //上面的操作完成了，可以通过step来获取下一次的数据
                result=sqlite3_step(insert_statement);
                result=sqlite3_finalize(insert_statement);
                
                //记录Z_PRIMARYKEY里面table的最大键值
                periodNum_accountType = sqlite3_last_insert_rowid(curDatabase);
            }
        }
		if(periodNum_accountType!=0)
		{
            //获取当前数据库对应AccountType表格的那条记录
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=2";
            
            //插入priodNum
			sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_accountType);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);
        
        
        /////////Account
        long periodNum_account = 0;
		const char* sqlPeriod_account=nil;
        //4.5.1的时候没有orderindex
        if (![versionNumber isEqualToString:@"4.5.1"]) {
            sqlPeriod_account="SELECT Z_PK,Z_ENT,Z_OPT,ZAUTOCLEAR,ZACCOUNTTYPE,ZAMOUNT,ZACCNAME,ZDATETIME FROM ZACCOUNTS";
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_account, -1, &statement, NULL)==SQLITE_OK)
            {
                
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const unsigned int zautoclear = sqlite3_column_int(statement, 3);
                    const unsigned char *zaccounttype = sqlite3_column_text(statement, 4);
                    const double zamount = sqlite3_column_double(statement, 5);
                    const unsigned char *zaccountname = sqlite3_column_text(statement, 6);
                    const unsigned char *zdatetime = sqlite3_column_text(statement, 7);
                    
                    const char* insert_sql = "INSERT INTO ZACCOUNTS (Z_PK,Z_ENT,Z_OPT,ZAUTOCLEAR,ZACCOUNTTYPE,ZAMOUNT,ZACCNAME,ZDATETIME) VALUES (?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_int(insert_statement, 4, (BOOL)zautoclear);
                    result = sqlite3_bind_text(insert_statement, 5, (char *)zaccounttype         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement, 6, (double)zamount);
                    result = sqlite3_bind_text(insert_statement, 7, (char *)zaccountname         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 8, (char *)zdatetime, -1, SQLITE_TRANSIENT);
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_account = sqlite3_last_insert_rowid(curDatabase);
                }
            }
        }
        else{
            sqlPeriod_account="SELECT Z_PK,Z_ENT,Z_OPT,ZAUTOCLEAR,ZORDERINDEX,ZACCOUNTTYPE,ZAMOUNT,ZACCNAME,ZDATETIME FROM ZACCOUNTS";
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_account, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const unsigned int zautoclear = sqlite3_column_int(statement, 3);
                    const unsigned int zorderindex = sqlite3_column_int(statement, 4);
                    const unsigned char *zaccounttype = sqlite3_column_text(statement, 5);
                    const double zamount = sqlite3_column_double(statement, 6);
                    const unsigned char *zaccountname = sqlite3_column_text(statement, 7);
                    const unsigned char *zdatetime = sqlite3_column_text(statement, 8);
                    
                    const char* insert_sql = "INSERT INTO ZACCOUNTS (Z_PK,Z_ENT,Z_OPT,ZAUTOCLEAR,ZORDERINDEX,ZACCOUNTTYPE,ZAMOUNT,ZACCNAME,ZDATETIME) VALUES (?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_int(insert_statement, 4, (BOOL)zautoclear);
                    result = sqlite3_bind_int(insert_statement, 5, (BOOL)zorderindex);
                    result = sqlite3_bind_text(insert_statement, 6, (char *)zaccounttype         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement, 7, (double)zamount);
                    result = sqlite3_bind_text(insert_statement, 8, (char *)zaccountname         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 9, (char *)zdatetime         , -1,SQLITE_TRANSIENT);
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_account = sqlite3_last_insert_rowid(curDatabase);
                }
            }
        }
		if(periodNum_account!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=1";
            
			sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_account);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);
        
        
        /////////查询category
        const char* sqlPeriod_category="SELECT Z_PK,Z_ENT,Z_OPT,ZHASBUDGET,ZISDEFAULT,ZISSYSTEMRECORD,ZCATEGORYNAME,ZCATEGORYTYPE,ZICONNAME,ZBUDGETTEMPLATE FROM ZCATEGORY";
        long periodNum_category = 0;
        if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_category, -1, &statement, NULL)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                const BOOL zhasbudget = sqlite3_column_int(statement, 3);
                const BOOL zisdefault = sqlite3_column_int(statement, 4);
                const BOOL  zisSystemRecord = sqlite3_column_int(statement, 5);
                const unsigned char *zcategoryName = sqlite3_column_text(statement, 6);
                const unsigned char *zcategorytype = sqlite3_column_text(statement, 7);
                const unsigned char *ziconname = sqlite3_column_text(statement, 8);
                const unsigned char *zbudgetTemplate = sqlite3_column_text(statement, 9);
                
				const char* insert_sql = "INSERT INTO ZCATEGORY (Z_PK,Z_ENT,Z_OPT,ZHASBUDGET,ZISDEFAULT,ZISSYSTEMRECORD,ZCATEGORYNAME,ZCATEGORYTYPE,ZICONNAME,ZBUDGETTEMPLATE) VALUES (?,?,?,?,?,?,?,?,?,?)";
                
				sqlite3_stmt *insert_statement=nil;
                
				result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
				result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_int(insert_statement, 4, (BOOL)zhasbudget);
                result = sqlite3_bind_int(insert_statement, 5, (BOOL)zisdefault);
                result = sqlite3_bind_int(insert_statement, 6, (BOOL)zisSystemRecord);
				result = sqlite3_bind_text(insert_statement,7, (char *)zcategoryName         , -1,SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement,8, (char*)zcategorytype, -1,SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement, 9, (char*)ziconname, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 10, (char*)zbudgetTemplate, -1,SQLITE_TRANSIENT);
                
                
				result=sqlite3_step(insert_statement);
				result=sqlite3_finalize(insert_statement);
                
				periodNum_category = sqlite3_last_insert_rowid(curDatabase);
			}
		}
		if(periodNum_category!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=11";
            sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_category);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);
        
        
        
        //        //////payee
        const char* sqlPeriod_payee="SELECT Z_PK,Z_ENT,Z_OPT,ZCATEGORY,ZMEMO,ZNAME FROM ZPAYEE";
        long periodNum_payee = 0;
        if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_payee, -1, &statement, NULL)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                const unsigned char *zcategory = sqlite3_column_text(statement, 3);
                const unsigned char *zmemo = sqlite3_column_text(statement, 4);
                const unsigned char *zname = sqlite3_column_text(statement, 5);
                
				const char* insert_sql = "INSERT INTO ZPAYEE (Z_PK,Z_ENT,Z_OPT,ZCATEGORY,ZMEMO,ZNAME) VALUES (?,?,?,?,?,?)";
                
				sqlite3_stmt *insert_statement=nil;
                
				result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
				result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement,4, (char *)zcategory         , -1,SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement,5, (char*)zmemo, -1,SQLITE_TRANSIENT);
				result = sqlite3_bind_text(insert_statement, 6, (char*)zname, -1,SQLITE_TRANSIENT);
                
				result=sqlite3_step(insert_statement);
				result=sqlite3_finalize(insert_statement);
                
				periodNum_payee = sqlite3_last_insert_rowid(curDatabase);
			}
		}
		if(periodNum_payee!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=14";
            sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_payee);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);
        
        
        //////－－－－－－－－添加bill(在免费版中有的)
        long periodNum_bill = 0;
        char *sqlPeriod_bill = nil;
        sqlPeriod_bill = "SELECT Z_PK,Z_ENT,Z_OPT,ZHASPAID,ZISRULE,ZCATEGORY,ZCHILDBILLRULE,ZFROMACCOUNT,ZPARENTBILLRULE,ZPAYEES,ZTOACCOUNT,ZAMOUNTDUE,ZAMOUNTPAID,ZENDDATE,ZPAIDDATE,ZRECORDDATE,ZSTARTDATE,ZBILLTYPE,ZCYCLE,ZNAME,ZNOTES,ZREMIND,ZSTATUS FROM ZBILLRULE";
        NSLog(@"sqlite3_prepare_v2(oldDatabase, sqlPeriod_bill, -1, &statement, NULL):%d",sqlite3_prepare_v2(oldDatabase, sqlPeriod_bill, -1, &statement, NULL));
        
        if (sqlite3_prepare_v2(oldDatabase, sqlPeriod_bill, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                const BOOL zhaspaid = sqlite3_column_int(statement, 3);
                const BOOL zisrule = sqlite3_column_int(statement, 4);
                const unsigned char *zcategory = sqlite3_column_text(statement, 5);
                const unsigned char *zchildbillrule = sqlite3_column_text(statement, 6);
                const unsigned char *zfromaccount = sqlite3_column_text(statement, 7);
                const unsigned char *zparentbillrule = sqlite3_column_text(statement, 8);
                const unsigned char *zpayee = sqlite3_column_text(statement, 9);
                const unsigned char *ztoaccount = sqlite3_column_text(statement, 10);
                const double zamountdue = sqlite3_column_double(statement, 11);
                const double zamountpaid = sqlite3_column_double(statement, 12);
                const unsigned char *zenddate = sqlite3_column_text(statement, 13);
                const unsigned char *zpaiddate = sqlite3_column_text(statement, 14);
                const unsigned char *zrecorddate = sqlite3_column_text(statement, 15);
                const unsigned char *zstartdate = sqlite3_column_text(statement, 16);
                const unsigned char *zbilltype = sqlite3_column_text(statement, 17);
                const unsigned char *zcycle = sqlite3_column_text(statement, 18);
                const unsigned char *zname = sqlite3_column_text(statement, 19);
                const unsigned char *znote = sqlite3_column_text(statement, 20);
                const unsigned char *zremind = sqlite3_column_text(statement, 21);
                const unsigned char *zstatus = sqlite3_column_text(statement, 22);
                

                const char* insert_sql = "INSERT INTO ZBILLRULE (Z_PK,Z_ENT,Z_OPT,ZHASPAID,ZISRULE,ZCATEGORY,ZCHILDBILLRULE,ZFROMACCOUNT,ZPARENTBILLRULE,ZPAYEES,ZTOACCOUNT,ZAMOUNTDUE,ZAMOUNTPAID,ZENDDATE,ZPAIDDATE,ZRECORDDATE,ZSTARTDATE,ZBILLTYPE,ZCYCLE,ZNAME,ZNOTES,ZREMIND,ZSTATUS) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                sqlite3_stmt *insert_statement=nil;
                
                result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                
                result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                result = sqlite3_bind_int(insert_statement, 4, zhaspaid);
                result = sqlite3_bind_int(insert_statement, 5, zisrule);
                result = sqlite3_bind_text(insert_statement,6, (char*)zcategory, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement,7, (char*)zchildbillrule, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement,8, (char*)zfromaccount, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement,9, (char*)zparentbillrule, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement,10, (char*)zpayee, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement,11, (char*)ztoaccount, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_double(insert_statement,12, (double)zamountdue);
                result = sqlite3_bind_double(insert_statement,13, (double)zamountpaid);

                result = sqlite3_bind_text(insert_statement, 14, (char*)zenddate, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 15, (char*)zpaiddate, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 16, (char*)zrecorddate, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 17, (char*)zstartdate, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 18, (char*)zbilltype, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 19, (char*)zcycle, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 20, (char*)zname, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 21, (char*)znote, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 22, (char*)zremind, -1,SQLITE_TRANSIENT);
                result = sqlite3_bind_text(insert_statement, 23, (char*)zstatus, -1,SQLITE_TRANSIENT);
                
                result=sqlite3_step(insert_statement);
                result=sqlite3_finalize(insert_statement);
                
                periodNum_bill = sqlite3_last_insert_rowid(curDatabase);
            }
        }
        if(periodNum_bill!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=5";
            sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_bill);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);

        
        //////transaction
        long periodNum_transaction = 0;
        char*  sqlPeriod_transaction = nil;
        if (![versionNumber isEqualToString:@"4.5.1"]) {
            sqlPeriod_transaction="SELECT Z_PK,Z_ENT,Z_OPT,ZISCLEAR,ZTYPE,ZCATEGORY,ZEXPENSEACCOUNT,ZINCOMEACCOUNT,ZPARTRANSACTION,ZPAYEE,ZAMOUNT,ZDATETIME,ZNOTES,ZPHOTONAME,ZTRANSACTIONTYPE ZBILLITEM FROM ZTRANSACTION";
            
            //4.5.1之前的
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_transaction, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const BOOL zisclear = sqlite3_column_int(statement, 3);
                    const unsigned char *ztype = sqlite3_column_text(statement, 4);
                    const unsigned char *zcategory = sqlite3_column_text(statement, 5);
                    const unsigned char *zexpenseaccount = sqlite3_column_text(statement, 6);
                    const unsigned char *zincomeaccount = sqlite3_column_text(statement, 7);
                    const unsigned char *zpartransaction = sqlite3_column_text(statement, 8);
                    const unsigned char *zpayee = sqlite3_column_text(statement, 9);
                    const double zamount = sqlite3_column_double(statement, 10);
                    const unsigned char *zdatetime = sqlite3_column_text(statement, 11);
                    const unsigned char *znote = sqlite3_column_text(statement, 12);
                    const unsigned char *zphotoname = sqlite3_column_text(statement, 13);
                    const unsigned char *ztransactiontype = sqlite3_column_text(statement,14);
                    const unsigned char *zbillitem  = sqlite3_column_text(statement, 15);
                    
                    const char* insert_sql = "INSERT INTO ZTRANSACTION (Z_PK,Z_ENT,Z_OPT,ZISCLEAR,ZTYPE,ZCATEGORY,ZEXPENSEACCOUNT,ZINCOMEACCOUNT,ZPARTRANSACTION,ZPAYEE,ZAMOUNT,ZDATETIME,ZNOTES,ZPHOTONAME,ZTRANSACTIONTYPE,ZBILLITEM) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_int(insert_statement, 4, zisclear);
                    result = sqlite3_bind_text(insert_statement,5, (char *)ztype         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,6, (char*)zcategory, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,7, (char*)zexpenseaccount, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,8, (char*)zincomeaccount, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,9, (char*)zpartransaction, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,10, (char*)zpayee, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement,11, (double)zamount);
                    result = sqlite3_bind_text(insert_statement,12, (char*)zdatetime, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,13, (char*)znote, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 14, (char*)zphotoname, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 15, (char*)ztransactiontype, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 16, (char*)zbillitem, -1,SQLITE_TRANSIENT);
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_transaction = sqlite3_last_insert_rowid(curDatabase);
                }
            }
        }
        else{
            sqlPeriod_transaction="SELECT Z_PK,Z_ENT,Z_OPT,ZISCLEAR,ZRECURRINGTYPE,ZCATEGORY,ZEXPENSEACCOUNT,ZINCOMEACCOUNT,ZPARTRANSACTION,ZPAYEE,ZAMOUNT,ZDATETIME,ZNOTES,ZPHOTONAME,ZTRANSACTIONTYPE,ZBILLITEM FROM ZTRANSACTION";
            //4.5.1之前的
            int result = sqlite3_prepare_v2(oldDatabase, sqlPeriod_transaction, -1, &statement, NULL);
            if(result==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const BOOL zisclear = sqlite3_column_int(statement, 3);
                    const unsigned char *zrecurringtype = sqlite3_column_text(statement, 4);
                    const unsigned char *zcategory = sqlite3_column_text(statement, 5);
                    const unsigned char *zexpenseaccount = sqlite3_column_text(statement, 6);
                    const unsigned char *zincomeaccount = sqlite3_column_text(statement, 7);
                    const unsigned char *zpartransaction = sqlite3_column_text(statement, 8);
                    const unsigned char *zpayee = sqlite3_column_text(statement, 9);
                    const double zamount = sqlite3_column_double(statement, 10);
                    const unsigned char *zdatetime = sqlite3_column_text(statement, 11);
                    const unsigned char *znote = sqlite3_column_text(statement, 12);
                    const unsigned char *zphotoname = sqlite3_column_text(statement, 13);
                    const unsigned char *ztransactiontype = sqlite3_column_text(statement,14);
                    const unsigned char *zbillitem  = sqlite3_column_text(statement, 15);

                    
                    const char* insert_sql = "INSERT INTO ZTRANSACTION (Z_PK,Z_ENT,Z_OPT,ZISCLEAR,ZRECURRINGTYPE,ZCATEGORY,ZEXPENSEACCOUNT,ZINCOMEACCOUNT,ZPARTRANSACTION,ZPAYEE,ZAMOUNT,ZDATETIME,ZNOTES,ZPHOTONAME,ZTRANSACTIONTYPE,ZBILLITEM) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_int(insert_statement, 4, zisclear);
                    result = sqlite3_bind_text(insert_statement,5, (char *)zrecurringtype         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,6, (char*)zcategory, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,7, (char*)zexpenseaccount, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,8, (char*)zincomeaccount, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,9, (char*)zpartransaction, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,10, (char*)zpayee, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement,11, (double)zamount);
                    result = sqlite3_bind_text(insert_statement,12, (char*)zdatetime, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,13, (char*)znote, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 14, (char*)zphotoname, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 15, (char*)ztransactiontype, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 16, (char*)zbillitem, -1,SQLITE_TRANSIENT);

                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_transaction = sqlite3_last_insert_rowid(curDatabase);
                }
            }
        }
		if(periodNum_transaction!=0)
		{
            const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=16";
            sqlite3_stmt *insert_statement=nil;
			result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
			result = sqlite3_bind_int(insert_statement,1,(int)periodNum_transaction);
			result = sqlite3_step(insert_statement);
			result = sqlite3_finalize(insert_statement);
		}
		result=sqlite3_finalize(statement);

        
        //////budgetTemplate
        long periodNum_budgetTemplate = 0;
        if (budgetModelisNew) {
            
            char*  sqlPeriod_budgetTemplate="SELECT Z_PK,Z_ENT,Z_OPT,ZCATEGORY,ZAMOUNT,ZSTARTDATE,ZISNEW,ZCYCLETYPE FROM ZBUDGETTEMPLATE";
            
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_budgetTemplate, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const unsigned char *zcategory = sqlite3_column_text(statement, 3);
                    const double zamount = sqlite3_column_double(statement, 4);
                    const unsigned char *zstartdate = sqlite3_column_text(statement,5);
                    const unsigned char *zisnew = sqlite3_column_text(statement, 6);
                    const unsigned char *zcycleType = sqlite3_column_text(statement, 7);
                    
                    const char* insert_sql = "INSERT INTO ZBUDGETTEMPLATE (Z_PK,Z_ENT,Z_OPT,ZCATEGORY,ZAMOUNT,ZSTARTDATE,ZISNEW,ZCYCLETYPE) VALUES (?,?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,4, (char *)zcategory         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement,5, (double)zamount);
                    result = sqlite3_bind_text(insert_statement,6, (char*)zstartdate, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 7, (char*)zisnew, -1, SQLITE_TRANSIENT );
                    result = sqlite3_bind_text(insert_statement, 8, (char*)zcycleType, -1, SQLITE_TRANSIENT );
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_budgetTemplate = sqlite3_last_insert_rowid(curDatabase);
                }
            }
            
            if(periodNum_budgetTemplate!=0)
            {
                const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=8";
                sqlite3_stmt *insert_statement=nil;
                result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
                result = sqlite3_bind_int(insert_statement,1,(int)periodNum_budgetTemplate);
                result = sqlite3_step(insert_statement);
                result = sqlite3_finalize(insert_statement);
            }
            result=sqlite3_finalize(statement);
        }
        
        
        /////budgetitem
        long periodNum_budgetItem = 0;
        if (budgetModelisNew) {
            
            char*  sqlPeriod_budgetitem="SELECT Z_PK,Z_ENT,Z_OPT,ZBUDGETTEMPLATE,ZAMOUNT,ZSTARTDATE,ZENDDATE FROM ZBUDGETITEM";
            
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_budgetitem, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const unsigned char *zbudgettemplate = sqlite3_column_text(statement, 3);
                    const double zamount = sqlite3_column_double(statement, 4);
                    const unsigned char *zstartdate = sqlite3_column_text(statement,5);
                    const unsigned char *zenddate = sqlite3_column_text(statement, 6);
                    
                    const char* insert_sql = "INSERT INTO ZBUDGETITEM (Z_PK,Z_ENT,Z_OPT,ZBUDGETTEMPLATE,ZAMOUNT,ZSTARTDATE,ZENDDATE) VALUES (?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,4, (char *)zbudgettemplate         , -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement,5, (double)zamount);
                    result = sqlite3_bind_text(insert_statement,6, (char*)zstartdate, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement,6, (char*)zenddate, -1,SQLITE_TRANSIENT);
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_budgetItem = sqlite3_last_insert_rowid(curDatabase);
                }
            }
            
            if(periodNum_budgetItem!=0)
            {
                const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=6";
                sqlite3_stmt *insert_statement=nil;
                result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
                result = sqlite3_bind_int(insert_statement,1,(int)periodNum_budgetItem);
                result = sqlite3_step(insert_statement);
                result = sqlite3_finalize(insert_statement);
            }
            result=sqlite3_finalize(statement);
        }
        
        //Budget Transfer
        long periodNum_budgetTransfer = 0;
        if (budgetModelisNew) {
            
            char*  sqlPeriod_budgetTransfer="SELECT Z_PK,Z_ENT,Z_OPT,ZAMOUNT,ZDATETIME,ZFROMBUDGET,ZTOBUDGET FROM ZBUDGETTRANSFER";
            
            if(sqlite3_prepare_v2(oldDatabase, sqlPeriod_budgetTransfer, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    const unsigned char* z_pk = sqlite3_column_text(statement, 0);
                    const double zamount = sqlite3_column_double(statement, 3);
                    const unsigned char *zstartdate = sqlite3_column_text(statement,4);
                    const unsigned char *zfrombudget = sqlite3_column_text(statement, 5);
                    const unsigned char *ztobudget = sqlite3_column_text(statement, 6);
                    
                    const char* insert_sql = "INSERT INTO ZBUDGETTRANSFER (Z_PK,Z_ENT,Z_OPT,ZAMOUNT,ZDATETIME,ZFROMBUDGET,ZTOBUDGET) VALUES (?,?,?,?,?,?,?)";
                    
                    sqlite3_stmt *insert_statement=nil;
                    result=sqlite3_prepare_v2(curDatabase, insert_sql, -1, &insert_statement, NULL);
                    
                    result  =sqlite3_bind_text(insert_statement, 1, (char *)z_pk,-1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 2, "2" , -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 3, "1", -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_double(insert_statement,4, (double)zamount);
                    result = sqlite3_bind_text(insert_statement,5, (char*)zstartdate, -1,SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 6, (char *)zfrombudget, -1, SQLITE_TRANSIENT);
                    result = sqlite3_bind_text(insert_statement, 7, (char *)ztobudget, -1, SQLITE_TRANSIENT);
                    
                    result=sqlite3_step(insert_statement);
                    result=sqlite3_finalize(insert_statement);
                    
                    periodNum_budgetTransfer = sqlite3_last_insert_rowid(curDatabase);
                }
            }
            
            if(periodNum_budgetTransfer!=0)
            {
                const char* sqlUpdateFeed = "UPDATE Z_PRIMARYKEY SET Z_MAX=? WHERE Z_ENT=6";
                sqlite3_stmt *insert_statement=nil;
                result = sqlite3_prepare_v2(curDatabase, sqlUpdateFeed, -1, &insert_statement, NULL);
                result = sqlite3_bind_int(insert_statement,1,(int)periodNum_budgetTransfer);
                result = sqlite3_step(insert_statement);
                result = sqlite3_finalize(insert_statement);
            }
            result=sqlite3_finalize(statement);
        }
        
        
        //关闭数据库
		sqlite3_close(oldDatabase);
		sqlite3_close(curDatabase);
        
        
        //当对老数据解析完成以后，插入一个标记，以后打开的话，就提醒是覆盖还是交互
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:FIRSTLAUNCHSINCEBACKUPOLDUSERDATA forKey:OLDUSERDATA];
        //如果不立即更新的话，可能会导致这个值不会立即存进去
        [userDefaults synchronize];
        
        //关闭数据库之后移除旧的数据库
        [fileManager removeItemAtPath:oldPath2 error:&error];
        [fileManager removeItemAtPath:newwalPath error:&error];
        [fileManager removeItemAtPath:newshmPath error:&error];
        
        if (isBackup)
        {
            NSString *currentBank = [documentsDirectory stringByAppendingString:@"/PocketExpenseBak.zip"];
            [fileManager removeItemAtPath:currentBank error:&error];

        }
        
        [self getBillDataFormOldEntitytoNewEntity];

        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Setting"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
        [request setEntity:entityDesc];
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        NSMutableArray *mutableObjects = [[NSMutableArray alloc] initWithArray:objects];
        long count = [mutableObjects count];
        if (count >0)
        {
            appDelegate.settings = [mutableObjects objectAtIndex:0];
        }
    }
    
}

-(void)getBillDataFormOldEntitytoNewEntity
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchBill = [[NSFetchRequest alloc]initWithEntityName:@"BillRule"];
    //搜索条件是 expense，非循环
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"billType contains[c] %@",@"expense"];

    [fetchBill setPredicate:predicate];
    
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchBill error:&error]];
    for (int i=0; i<[objects count]; i++)
    {
        BillRule *oneBillRule = [objects objectAtIndex:i];
        if (![oneBillRule.cycle isEqualToString:@"Only Once"]) {
            continue;
        }
        EP_BillRule *newBillRule = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
        newBillRule.ep_billName = oneBillRule.name;
        newBillRule.ep_billAmount = oneBillRule.amountDue;
        newBillRule.billRuleHasPayee = oneBillRule.payees;
        newBillRule.billRuleHasCategory = oneBillRule.category;
        newBillRule.ep_billDueDate = oneBillRule.startDate;
        newBillRule.ep_billEndDate = oneBillRule.endDate;
        newBillRule.ep_recurringType = @"Never";
        newBillRule.ep_reminderDate = oneBillRule.remind;
        newBillRule.ep_reminderTime = [appDelegate.epnc  getFirstSecByDate:[NSDate date]];
        newBillRule.ep_note = oneBillRule.notes;
        newBillRule.uuid = [EPNormalClass GetUUID];
        newBillRule.dateTime = [NSDate date];
        newBillRule.state = @"1";
        
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:newBillRule];
//        }
        
        NSMutableArray *billTransactionArray =  [[NSMutableArray alloc]initWithArray:[oneBillRule.transaction allObjects]];
        for (int m=0; m<[billTransactionArray count]; m++)
        {
            Transaction *oneTransaction = [billTransactionArray objectAtIndex:m];
            oneTransaction.transactionHasBillRule = newBillRule;
            oneTransaction.dateTime_sync = [NSDate date];
            [appDelegate.managedObjectContext save:&error];
//            if (appDelegate.dropbox.drop_account)
//            {
//                [appDelegate.dropbox updateEveryTransactionDataFromLocal:oneTransaction];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTransaction];
            }
        }
    }
}
-(void)setFreeVersionBelongtoWhichVersionIdentification
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取当前设备上保存的版本号
    NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
    //如果设备上有版本号，就说明这个是老版本。（1）如果这个数据库中others17为空，那么肯定是4.5的老版本，如果不为空，说明这是5.3之后的老版本,对于5.3及其之后的版本，都已经设置过others17了，所以不用设置了
    if (trackingVersion != nil)
    {
        if ([appDelegate.settings.others17 length]==0) {
            appDelegate.settings.others17 = @"4.5";
        }
    }
    //用户新下载一个app,要给这个app设置版本标识，是5.3/5.4
    else
    {
        if ([version isEqualToString:@"5.3"])
        {
            appDelegate.settings.others17 = @"5.3";
        }
        else
        {
            appDelegate.settings.others17 = @"5.4";
        }
    }
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    
}

-(void)setLocalDataBaseSyncTimeToday_whenRestore
{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *fetchAccountType = [[NSFetchRequest alloc]initWithEntityName:@"AccountType"];
    NSArray *accountArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccountType error:&error];
    for (int i=0; i<[accountArray count]; i++) {
        AccountType *oneAccount = [accountArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    NSFetchRequest *fetchAccounts = [[NSFetchRequest alloc]initWithEntityName:@"Accounts"];
    NSArray *accountsArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchAccounts error:&error];
    for (int i=0; i<[accountsArray count]; i++) {
        Accounts *oneAccount = [accountsArray objectAtIndex:i];
        oneAccount.dateTime_sync = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    //会删掉budgetTemplate 和 budgetItem
    NSFetchRequest *fetchbudgetTem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetTemplate"];
    NSArray *budgetTemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchbudgetTem error:&error];
    for (int i=0; i<[budgetTemArray count]; i++) {
        BudgetTemplate *oneAccount = [budgetTemArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    NSFetchRequest *fetchBillRule= [[NSFetchRequest alloc]initWithEntityName:@"EP_BillRule"];
    NSArray *billruleArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBillRule error:&error];
    for (int i=0; i<[billruleArray count]; i++) {
        EP_BillRule *oneBillRule = [billruleArray objectAtIndex:i];
        oneBillRule.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    
    NSFetchRequest *fetchcategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSArray *categoryArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchcategory error:&error];
    for (int i=0; i<[categoryArray count]; i++) {
        Category *oneCate = [categoryArray objectAtIndex:i];
        oneCate.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    NSFetchRequest *fetchpayee= [[NSFetchRequest alloc]initWithEntityName:@"Payee"];
    NSArray *payeeArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchpayee error:&error];
    for (int i=0; i<[payeeArray count]; i++) {
        Payee *onepayee = [payeeArray objectAtIndex:i];
        onepayee.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    NSFetchRequest *fetchtransaction= [[NSFetchRequest alloc]initWithEntityName:@"Transaction"];
    NSArray *transactionArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchtransaction error:&error];
    for (int i=0; i<[transactionArray count]; i++) {
        Transaction *oneTrans = [transactionArray objectAtIndex:i];
        oneTrans.dateTime_sync = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    
    
    NSFetchRequest *fetchBudgetItem= [[NSFetchRequest alloc]initWithEntityName:@"BudgetItem"];
    NSArray *budgetItemArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchBudgetItem error:&error];
    for (int i=0; i<[budgetItemArray count]; i++) {
        BudgetItem *oneAccount = [budgetItemArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }

    
    NSFetchRequest *fetchSetting= [[NSFetchRequest alloc]initWithEntityName:@"Setting"];
    NSArray *settingArray = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetchSetting error:&error];
    for (int i=0; i<[settingArray count]; i++) {
        Setting *oneAccount = [settingArray objectAtIndex:i];
        oneAccount.dateTime = [NSDate date];
        [appDelegate_iPhone.managedObjectContext save:&error];

    }
    

}

#pragma mark getSelected Month and Before NetWorth
-(double)getSelectedMonthNetWorth:(NSDate *)date isMonthViewControllerBalance:(BOOL)isMonthViewControllerBalance
{
    
    //get account array
	NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSFetchRequest *fetchRequest_account = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity_account = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest_account setEntity:entity_account];
    NSPredicate * predicate_account =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest_account setPredicate:predicate_account];
    
    NSSortDescriptor *sortDescriptor_account = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray *sortDescriptors_account = [[NSArray alloc] initWithObjects:sortDescriptor_account, nil];
    
    [fetchRequest_account setSortDescriptors:sortDescriptors_account];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest_account error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];

    
	double totalBalance =0;
    
    for (int i=0; i<[tmpAccountArray count]; i++)
    {
        double oneIncome = 0;
        Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
        
        if (!isMonthViewControllerBalance)
        {
            oneIncome = [tmpAccount.amount doubleValue];
            totalBalance+=[tmpAccount.amount doubleValue];
        }
        else if ([appDelegate.epnc dateCompare:date withDate:tmpAccount.dateTime]>=0)
        {
            oneIncome = [tmpAccount.amount doubleValue];
            totalBalance+=[tmpAccount.amount doubleValue];
        }
        
    }
    
    
   	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:date,@"endDate", [NSNull null],@"EMPTY",nil];
    
 	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscationsBeforeDate" substitutionVariables:subs];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *objects1 = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];

    
    
    double totalSpend = 0;
	double totalIncome =0;
    double netWorth = 0;
	for (int i=0; i<[objects1 count]; i++)
	{
 		Transaction *oneTransaction =[objects1 objectAtIndex:i];
        if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
            totalSpend += [oneTransaction.amount doubleValue];
        }
        else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
            totalIncome += [oneTransaction.amount doubleValue];
        }
        else if ([[oneTransaction.childTransactions allObjects]count]>0){
            totalSpend += [oneTransaction.amount doubleValue];
        }
    }
    netWorth = totalIncome - totalSpend + totalBalance;
    return netWorth;
}


//删除单个没有子类category
-(void)deleteCategoryAndRelation:(Category*) category
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    
    NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[category.transactions allObjects]];
    
    //trans
    for (int i=0; i<[tmpTransactionArray count]; i++)
    {
        Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
        deleteLog.state = @"0";
        deleteLog.dateTime_sync = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }
    }
//    if (appDelegate.dropbox.drop_account.linked)
//    {
//        for (int i=0; i<[tmpTransactionArray count]; i++)
//        {
//            Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:deleteLog];
//        }
//    }
    if ([PFUser currentUser])
    {
        for (int i=0; i<tmpTransactionArray.count; i++)
        {
            Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
            [[ParseDBManager sharedManager]updateTransactionFromLocal:deleteLog];
        }
    }
    
    //bill
    NSMutableArray *billArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billArray count]; i++)
    {
        EP_BillRule *deleteLog = (EP_BillRule *)[billArray objectAtIndex:i];
        deleteLog.dateTime = [NSDate date];
        deleteLog.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
        
        //add
//        if (appDelegate.dropbox.drop_account.linked){
//            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:deleteLog];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:deleteLog];
        }
        //delete
        //        [appDelegate.managedObjectContext deleteObject:deleteLog];
    }
    [appDelegate.managedObjectContext save:&error];
    //billitem
    NSMutableArray *billItemArray = [[NSMutableArray alloc] initWithArray:[category.categoryHasBillRule allObjects]];
    for (int i=0; i<[billItemArray count]; i++)
    {
        EP_BillItem *deleteLog = (EP_BillItem *)[billItemArray objectAtIndex:i];
        deleteLog.dateTime = [NSDate date];
        deleteLog.state = @"0";
        [appDelegate.managedObjectContext save:&error];
        
        //add
//        if (appDelegate.dropbox.drop_account.linked){
//            [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteLog];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteLog];
        }
        //delete
        //        [appDelegate.managedObjectContext deleteObject:deleteLog];
    }
    [appDelegate.managedObjectContext save:&error];
    
    //budgetTemplate budget
    BudgetTemplate *tmpBudget = category.budgetTemplate;
    if(tmpBudget!=nil)
    {
        NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[tmpBudget.budgetItems allObjects]];
        if(budgetItemArray.count > 0)
        {
            for (int i=0; i<[budgetItemArray count]; i++)
            {
                BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
                
                NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
                for (int j=0; j<[fromTransferArray count]; j++)
                {
                    BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
                    //add
                    fromT.dateTime_sync = [NSDate date];
                    fromT.state = @"0";
                    [appDelegate.managedObjectContext save:&error];
                    
//                    if (appDelegate.dropbox.drop_account.linked){
//                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:fromT];
//                    }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateBudgetTransfer:fromT];
                    }
                    //delete
                    //					[fromT.toBudget removeFromTransferObject:fromT];
                    //					[appDelegate.managedObjectContext deleteObject:fromT];
                    
                }
                
                NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
                for (int j=0; j<[toTransferArray count]; j++)
                {
                    BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
                    
                    //add
                    toT.dateTime_sync = [NSDate date];
                    toT.state = @"0";
                    [appDelegate.managedObjectContext save:&error];
//                    if (appDelegate.dropbox.drop_account.linked)
//                    {
//                        [appDelegate.dropbox updateEveryBudgetTransferDataFromLocal:toT];
//                    }
                    if ([PFUser currentUser])
                    {
                        [[ParseDBManager sharedManager]updateBudgetTransfer:toT];
                    }
                    //delete
                    //					[toT.fromBudget removeToTransferObject:toT];
                    //					[appDelegate.managedObjectContext deleteObject:toT];
                    
                }
                
                //add
                object.dateTime = [NSDate date];
                object.state = @"0";
                [appDelegate.managedObjectContext save:&error];
//                if (appDelegate.dropbox.drop_account.linked)
//                {
//                    [appDelegate.dropbox updateEveryBudgetItemDataFromLocal:object];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBudgetItemLocal:object];
                }
                //delete
                //				[appDelegate.managedObjectContext deleteObject:object];
            }
        }
        
        //add
        tmpBudget.dateTime = [NSDate date];
        tmpBudget.state = @"0";
        [appDelegate.managedObjectContext save:&error];
//        if (appDelegate.dropbox.drop_account.linked)
//        {
//            [appDelegate.dropbox updateEveryBudgetTemplateDataFromLocal:tmpBudget];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetFromLocal:tmpBudget];
        }
        //delete
        //		[appDelegate.managedObjectContext deleteObject:tmpBudget];
    }
    
    category.others = @"";
    
    category.state = @"0";
    category.dateTime = [NSDate date];
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        
    }
//    if (appDelegate.dropbox.drop_account.linked)
//    {
//        [appDelegate.dropbox updateEveryCategoryDataFromLocal:category];
//        [appDelegate.managedObjectContext deleteObject:category];
//        if (![appDelegate.managedObjectContext save:&error]) {
//            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
//            
//        }
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateCategoryFromLocal:category];
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            
        }

    }
    
}

-(void)duplicateTransaction:(Transaction *)selectedTrans withDate:(NSDate *)duplicateDate
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *errors;
    Transaction *oneTrans = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
    //配置新的  Transaction
    oneTrans.dateTime = duplicateDate;
    oneTrans.amount = selectedTrans.amount;
    oneTrans.photoName = selectedTrans.photoName;
    oneTrans.notes = selectedTrans.notes;
    //        oneTrans.transactionType = selectedTrans.transactionType;
    oneTrans.expenseAccount = selectedTrans.expenseAccount;
    oneTrans.incomeAccount = selectedTrans.incomeAccount;
    oneTrans.payee = selectedTrans.payee;
    oneTrans.isClear = selectedTrans.isClear;
    oneTrans.recurringType = selectedTrans.recurringType;
    oneTrans.category = selectedTrans.category;
    oneTrans.dateTime_sync = [NSDate date];
    oneTrans.state = @"1";
    oneTrans.uuid = [EPNormalClass GetUUID];
    oneTrans.updatedTime = selectedTrans.updatedTime;
    oneTrans.transactionType = selectedTrans.transactionType;
    [appDelegate.managedObjectContext save:&errors];

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTrans];
    }
    
    //如果是多category循环，就需要添加子category
    if ([selectedTrans.childTransactions count]>0)
    {
        for (int i=0; i<[selectedTrans.childTransactions count]; i++)
        {
            Transaction *oneSelectedChildTransaction = [[selectedTrans.childTransactions allObjects]objectAtIndex:i];
            
            Transaction *childTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
            /*--------配置 childTransaction的所有信息-----*/
            childTransaction.dateTime = duplicateDate;
            childTransaction.amount = oneSelectedChildTransaction.amount;
            //在添加子category的时候，将note也保存进来
            childTransaction.notes=oneSelectedChildTransaction.notes;
            childTransaction.category = oneSelectedChildTransaction.category;
            
            //                childTransaction.transactionType = oneSelectedChildTransaction.transactionType;
            childTransaction.incomeAccount =oneSelectedChildTransaction.incomeAccount;
            childTransaction.expenseAccount = oneSelectedChildTransaction.expenseAccount;
            
            childTransaction.isClear = [NSNumber numberWithBool:YES];
            childTransaction.recurringType = @"Never";
            childTransaction.state = @"1";
            childTransaction.dateTime_sync = [NSDate date];
            childTransaction.uuid = [EPNormalClass GetUUID];
            //给这个子category做标记
            if(oneSelectedChildTransaction.category!=nil)
                childTransaction.category.others = @"HASUSE";
            childTransaction.payee =oneSelectedChildTransaction.payee;
            if(oneSelectedChildTransaction.category!=nil)
            {
                //给当前的这个category下增加一个交易，添加关系而已
                [oneSelectedChildTransaction.category addTransactionsObject:childTransaction];
            }
            //给当前这个 transaction 添加 childtransaction关系
            [oneTrans addChildTransactionsObject:childTransaction];
            if (![appDelegate.managedObjectContext save:&errors])
            {
                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                
            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:childTransaction];
            }
        }
        
        
    }

    
    [appDelegate.epdc autoInsertTransaction:oneTrans];
    
    if (![appDelegate.managedObjectContext save:&errors])
    {
        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        
    }

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:oneTrans];
    }
    

}

@end

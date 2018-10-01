//
//  PersonalnfoViewController.m
//  PocketExpense
//
//  Created by 刘晨 on 16/2/1.
//
//

#import "PersonalnfoViewController.h"
#import <Parse/Parse.h>
#import "FSMediaPicker.h"
#import "PokcetExpenseAppDelegate.h"
#import "BudgetCountClass.h"
#import "AppDelegate_iPad.h"

@interface PersonalnfoViewController ()<FSMediaPickerDelegate>

@end

@implementation PersonalnfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPoint];
    
    [self getNetWorthData];
    [self getBudgetLeft];
}
-(void)initPoint
{
    //头像设置
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
    UIImage *image=[[UIImage alloc]initWithData:imageData];
    if (imageData==nil)
    {
        image=[UIImage imageNamed:@"siderbar_user"];
    }
    [_avatarBtn setImage:image forState:UIControlStateNormal];
    [_avatarBtn addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
    //
    _emailLabel.text=[PFUser currentUser].username;
    _netWorthLeftLabel.text=NSLocalizedString(@"VC_NetWorth", nil);
    _budgetLeftLabel.text=NSLocalizedString(@"VC_Budget", nil);
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, 56, 187, EXPENSE_SCALE)];
    line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [self.view addSubview:line];
    
    
    
}
-(void)changeAvatar
{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = (FSMediaType)0;
    mediaPicker.editMode = (FSEditMode)0;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];
}
#pragma mark - 获取数据
-(void)getNetWorthData
{
    //初始化数据
    float expense=0;
    float income=0;
    float uncleared=0;
    float cleared=0;
    float netWorth=0;
    
    //获取transaction数据
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *desc=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    request.entity=desc;
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *tmpArray=[appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *transactionArray=[NSMutableArray arrayWithArray:tmpArray];
    
    //获取account数据
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicateAccount =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicateAccount];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor2,nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *tmpAccounArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *accountArray=[NSMutableArray arrayWithArray:tmpAccounArray];
    
    //分析transaction数据
    for (Transaction *transaction in transactionArray)
    {
        
        
        if ([transaction.isClear boolValue])
        {
            if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
            {
                income+=[transaction.amount floatValue];
                cleared+=[transaction.amount floatValue];
            }
            else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
            {
                expense-=[transaction.amount floatValue];
                cleared-=[transaction.amount floatValue];
            }
        }
        else
        {
            if (transaction.incomeAccount && transaction.expenseAccount == nil && transaction.childTransactions.count == 0)
            {
                uncleared+=[transaction.amount floatValue];
            }
            else if(transaction.incomeAccount ==nil && transaction.expenseAccount && transaction.childTransactions.count == 0)
            {
                uncleared-=[transaction.amount floatValue];
            }
        }
        
    }
    
    float accountAmount=0;
    
    for (Accounts *accounts in accountArray)
    {
        accountAmount+=[accounts.amount floatValue];
    }
    netWorth=accountAmount+cleared+uncleared;
    _netWorthRightLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13];
    _netWorthRightLabel.text=[appDelegate.epnc formatterString:netWorth];
    if (netWorth < 0)
    {
        _netWorthRightLabel.textColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    }
}
-(void)getBudgetLeft
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSDate *startDate;
    NSDate *endDate;
    
    startDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate date]];
    endDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:startDate];
    
    NSError *error =nil;
    
    //获取所有的budget
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestTemplateForName:@"fetchNewStyleBudget" ] copy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];
    
    
    double totalBudgetAmount = 0;
    double totalExpense = 0;
    double totalRollover = 0;
    
    double totalIncome = 0;
    BudgetCountClass *bcc;
    
    NSDictionary *subs;
    for (int i = 0; i<[allBudgetArray count];i++)
    {
        BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        totalBudgetAmount +=[budgetTemplate.amount doubleValue];
        bcc = [[BudgetCountClass alloc] init];
        bcc.bt = budgetTemplate;
        bcc.btTotalExpense =0;
        bcc.btTotalIncome =0;
        BudgetItem *budgetTemplateCurrentItem =[[budgetTemplate.budgetItems allObjects] lastObject];
        
        if( budgetTemplate.category!=nil)
        {
            subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",startDate,@"startDate",endDate,@"endDate", nil];
            
            
            //获取该budgetTemplate下 该段时间内的transaction,统计
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            for (int j = 0;j<[tmpArray count];j++)
            {
                Transaction *t = [tmpArray objectAtIndex:j];
                if([t.category.categoryType isEqualToString:@"EXPENSE"] && [t.state isEqualToString:@"1"])
                {
                    bcc.btTotalExpense +=[t.amount doubleValue];
                    totalExpense +=[t.amount doubleValue];
                }
                else if([t.category.categoryType isEqualToString:@"INCOME"] && [t.state isEqualToString:@"1"]){
                    bcc.btTotalIncome +=[t.amount doubleValue];
                    totalIncome +=[t.amount doubleValue];
                }
                
            }
            
            //获取该budgetTemplate下 该段时间内的transfer,统计
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.fromTransfer allObjects]];
            for (int j = 0;j<[tmpArray1 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray1 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:endDate]<=0 && [bttmp.state isEqualToString:@"1"])
                    bcc.btTotalExpense +=[bttmp.amount doubleValue];
                //totalExpense +=[bttmp.amount doubleValue];
                
            }
            
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithArray:[budgetTemplateCurrentItem.toTransfer allObjects]];
            for (int j = 0; j<[tmpArray2 count];j++)
            {
                BudgetTransfer *bttmp = [tmpArray2 objectAtIndex:j];
                if([appDelegate.epnc dateCompare:bttmp.dateTime withDate:startDate]>=0 &&
                   [appDelegate.epnc dateCompare:bttmp.dateTime withDate:endDate]<=0 && [bttmp.state isEqualToString:@"1"])
                    bcc.btTotalIncome +=[bttmp.amount doubleValue];
                //totalIncome +=[bttmp.amount doubleValue];
                
            }
            
            ////////////////////获取子类category的交易
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            
            if (range.location == NSNotFound)
            {
                
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",startDate,@"startDate",endDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                bcc.btTotalExpense +=[t.amount doubleValue];
                                totalExpense +=[t.amount doubleValue];
                            }
                            else if([t.category.categoryType isEqualToString:@"INCOME"])
                            {
                                bcc.btTotalIncome +=[t.amount doubleValue];
                                totalIncome +=[t.amount doubleValue];
                            }
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
        
        
    }
    
    
    double totalblance = totalBudgetAmount+totalRollover + totalIncome;
    
    _budgetRightLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13];

    if (totalblance>totalExpense)
    {
        _budgetRightLabel.text=[appDelegate.epnc formatterString:totalblance-totalExpense];
    }
    else
    {
        _budgetRightLabel.text=[appDelegate.epnc formatterString:totalExpense-totalblance];
    }
}


#pragma mark - FSMediaPicker
-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    AppDelegate_iPad *appdelegate=(AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appdelegate.mainViewController.avatatInfoVC.popoverContentSize=CGSizeMake(217, 113);
    [_avatarBtn setImage:mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage forState:UIControlStateNormal];
    
    UIImage *avatarImage=mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage;
    //    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    
    NSData *imageData=UIImageJPEGRepresentation(avatarImage, 0.5);
    [imageData writeToFile:imageFile atomically:YES];
    
    PFUser *user=[PFUser currentUser];
    PFFile *photo=[PFFile fileWithName:[NSString stringWithFormat:@"avatar.jpg"] data:imageData];
    user[@"avatar"]=photo;
    [user saveInBackground];
}
-(void)setAvatarImage:(UIImage *)image
{
    [_avatarBtn setImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ipad_SearchViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-8-26.
//
//

#import "ipad_SearchViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_SearchCell.h"
#import "Transaction.h"
#import "Payee.h"
#import "Category.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "AppDelegate_iPad.h"

@interface ipad_SearchViewController ()

@end

@implementation ipad_SearchViewController
@synthesize myTableView,searchView,seachIcon,searchField;;
@synthesize transactionArray,firstToBeHere;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPoint];
    [self initNavStyle];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [searchField becomeFirstResponder];
}

-(void)initNavStyle
{
    self.navigationItem.titleView = searchView;
}

-(void)initPoint
{
    transactionArray = [[NSMutableArray alloc]init];
    outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString *searchText = [NSString stringWithFormat:@"%@, %@, %@",NSLocalizedString(@"VC_Payee", nil),NSLocalizedString(@"VC_Amount", nil),NSLocalizedString(@"VC_Memo", nil)];
    searchField.placeholder = searchText;
}

-(IBAction)textFieldTextChanged:(UITextField *)textField
{
    if (!firstToBeHere) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"01_PAG_SRC"];
        firstToBeHere = YES;
        
    }
    [self seachTransaction];
    [myTableView reloadData];

}

-(void)seachTransaction
{
    [transactionArray removeAllObjects];
	NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    //搜索所有不是childTrans的transaction,使用过滤的时候
    NSDictionary *sub = [[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"getAllTranscations" substitutionVariables:sub];;
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"(payee.name contains[c] %@ || amount contains[c] %@ || notes contains[c] %@) && state contains[c] %@ && parTransaction==nil ",searchField.text,searchField.text,searchField.text,@"1"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];

    [transactionArray setArray:tmpAccountArray];


}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [transactionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ipad_SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell==nil)
    {
        cell = [[ipad_SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [self configCell:cell atIndexPath:indexPath];
    return cell;

}

-(void)configCell:(ipad_SearchCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Transaction *transcation = [transactionArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //name,amount,category
 	if([transcation.category.categoryType isEqualToString:@"INCOME"])
	{
        //name
        if (transcation.payee != nil) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        cell.spentLabel.text =[appDelegete.epnc formatterStringWithOutPositive:[transcation.amount  doubleValue]];
        cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
        [cell.spentLabel setTextColor:[UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1.0]];
        
 	}
	else if([transcation.category.categoryType isEqualToString:@"EXPENSE"]||[transcation.childTransactions count]>0)
	{
        //name
        if (transcation.payee != nil) {
            cell.nameLabel.text = transcation.payee.name;
        }
        else if ([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
            cell.nameLabel.text = @"-";
        if ([transcation.childTransactions count]>0) {
            cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind.png"];
            NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[transcation.childTransactions allObjects]];
            double childTotalAmount = 0;
            for (int child=0; child <[childArray count]; child++) {
                Transaction *oneChild = [childArray objectAtIndex:child];
                if ([oneChild.state isEqualToString:@"1"]) {
                    childTotalAmount += [oneChild.amount doubleValue];
                }
            }
            cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:(0-childTotalAmount)];
            
        }
        else
        {
            cell.categoryIcon.image = [UIImage imageNamed:transcation.category.iconName];
            
            cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
        }
        
        [cell.spentLabel setTextColor:[UIColor colorWithRed:243.0/255 green:61.0/255 blue:36.0/255 alpha:1]];
 	}
    else
 	{
        cell.spentLabel.text =  [appDelegete.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
        [cell.spentLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
        
        cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
		cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",transcation.expenseAccount.accName,transcation.incomeAccount.accName ];
        
	}
    
    //time
    NSString* time = [outputFormatter stringFromDate:transcation.dateTime];
	cell.timeLabel.text = time;

}


//点击交易的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate1.mainViewController presentaTransactionViewController:[transactionArray objectAtIndex:indexPath.row]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

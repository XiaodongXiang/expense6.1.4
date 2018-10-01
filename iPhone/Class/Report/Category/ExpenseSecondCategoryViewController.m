//
//  ExpenseSecondCategoryViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import "ExpenseSecondCategoryViewController.h"
#import "AppDelegate_iPhone.h"
#import "PokcetExpenseAppDelegate.h"
#import "DateRangeViewController.h"
#import "TransactionEditViewController.h"

#import "ReportTransactionCell.h"
#import "Payee.h"


@interface ExpenseSecondCategoryViewController ()

@end

@implementation ExpenseSecondCategoryViewController
@synthesize trantableview,startDate,endDate,dateType,piViewDateArray,isExpenseType,c,cc,categoryArray;
@synthesize transactionEditViewController;
@synthesize dateFormatter;

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
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initMemoryDefine];
    
    [self initNavBarStyle];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)resetData{
    [self setTopLabelTest];

    //获得所有的category，判断这个category是不是存在，不存在的话，就点不开，直接返回根页面
    [self getAllCategory];
    thisCategoryisBeenDelete = YES;
    for (int i=0; i<[categoryArray count]; i++) {
        Category *oneCategory = [categoryArray objectAtIndex:i];
        if (oneCategory==self.c) {
            thisCategoryisBeenDelete = NO;
            break;
        }
    }
    if (thisCategoryisBeenDelete) {
        return;
    }
    else{
        
        //最初的程序
        [self getDateSouce];
        [trantableview reloadData];
        
    }
}

-(void)refleshUI{
    [self resetData];
}

#pragma mark custom API
/*======================初始化需要的指针==============================*/
#pragma mark custom API
-(void)initMemoryDefine
{
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setLocale:[NSLocale currentLocale]];


    categoryArray = [[NSMutableArray alloc]init];
    
	piViewDateArray = [[NSMutableArray alloc] init];
    cc = [[TranscationCategoryCount alloc] init];
    
}

-(void)initNavBarStyle
{

    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = c.categoryName;
    
    
//    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    

    
}

#pragma mark View Will Appear Method
-(void)setTopLabelTest{
}

-(void)getAllCategory{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    NSError *error = nil;
	NSDictionary *subs = [[NSDictionary alloc]init];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"ipad_fetchAllCategory" substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];
    
    [categoryArray setArray:tmpCategoryArray];

}

- (void) getDateSouce
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
	[piViewDateArray removeAllObjects];
	double totalAmount = 0.0;
	int    colorName=0;
	NSError *error =nil;
	PiChartViewItem *tmpPiChartViewItem=nil;
    NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc]init];
    
    NSDictionary *subs;
    //1.获取该 category下 改时间段内的 transaction,如果父类category有交易需要添加到category数组中
    subs = [NSDictionary dictionaryWithObjectsAndKeys:c,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
    NSFetchRequest *fetchRequestpar = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
    NSSortDescriptor *sortDescriptorpar = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSMutableArray   *sortDescriptorspar = [[NSMutableArray alloc] initWithObjects:&sortDescriptorpar count:1];
    [fetchRequestpar setSortDescriptors:sortDescriptorspar];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestpar error:&error];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];

    //计算income / expense 交易的amount,以及添加exoense/income 数组
    double categoryTotalSpend = 0;
    if ([tmpArray count]>0) {
        tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:c.categoryName==nil? @"Not Sure":c.categoryName color:[UIColor clearColor]  data:categoryTotalSpend];
        tmpPiChartViewItem.category = c;
    }
    for (int j = 0;j<[tmpArray count];j++)
    {
        Transaction *t = [tmpArray objectAtIndex:j];
        
        totalAmount+=[t.amount doubleValue];
        categoryTotalSpend +=[t.amount doubleValue];
        [cc.transcationArray addObject:t];
        [tmpPiChartViewItem.transactionArray addObject:t];

    }
    
    //设置父类的category
    if([tmpArray count]>0)
    {
        tmpPiChartViewItem.cData = categoryTotalSpend;
        [tmpPiViewDateArray addObject:tmpPiChartViewItem];
        colorName++;
    }

    
    
    //2.获取该父category底下所有的子category
    NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",c.categoryName];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",c.categoryType,@"CATEGORYTYPE",nil];
    NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchChildCategory setSortDescriptors:sortDescriptors];
    NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
    NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];

    
    
    for(int j=0 ;j<[tmpChildCategoryArray count];j++)
    {
        Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
        //子category的消费总金额
        double subcategoryTotalSpend =0;
        
        
        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
        NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithArray:objects];
  
        //如果有符合选定交易类型的trans，就新增一个PiChartViewItem类型。用来表示是哪一个子category类，以及其下有哪些transaction
        
        if ([tmpArray1 count]>0) {
            tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:tmpCate.categoryName==nil? @"Not Sure":tmpCate.categoryName color:[UIColor clearColor]  data:subcategoryTotalSpend];
            tmpPiChartViewItem.category = tmpCate;
            colorName++;
            
        }
        
        //计算每一个子category的trans总金额
        for (int j = 0;j<[tmpArray1 count];j++)
        {
            Transaction *t = [tmpArray1 objectAtIndex:j];
            totalAmount+=[t.amount doubleValue];
            subcategoryTotalSpend +=[t.amount doubleValue];
            [tmpPiChartViewItem.transactionArray addObject:t];
        }
        
        
        if ([tmpArray1 count]>0)
        {
            tmpPiChartViewItem.cData = subcategoryTotalSpend;
            if (tmpPiChartViewItem) {
                [tmpPiViewDateArray addObject:tmpPiChartViewItem];

            }
        }
        
        
        
    }
    

    
  	
    //按金额大小分组
   	NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"cData" ascending:NO];
	NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
 	[tmpPiViewDateArray sortUsingDescriptors:sorts];
 	

 	PiChartViewItem *tmpPiItem;
	[piViewDateArray removeAllObjects];
    
    
	for (int i = 0; i<[tmpPiViewDateArray count];i++)
	{
		tmpPiItem =[tmpPiViewDateArray objectAtIndex:i];
        [piViewDateArray addObject:tmpPiItem];
        
	}

    
    double totolAmountTmp = 0;
     totolAmountTmp= totalAmount;
    
    
    
  	if(totolAmountTmp == 0)
	{
		for (int i = 0; i<[piViewDateArray count];i++)
		{
            if(colorName == 10)
			{
				colorName = 0;
			}
            
			tmpPiItem =[piViewDateArray objectAtIndex:i];
			tmpPiItem.cPercent = 1.0/[piViewDateArray count];
            tmpPiItem.cColor =(isExpenseType)? [appDelegate.epnc getExpColor:colorName]:[appDelegate.epnc getIncColor:colorName];
            tmpPiItem.cImage = (isExpenseType)?[appDelegate.epnc getExpImage:colorName]:[appDelegate.epnc getIncImage:colorName];
            colorName ++;
            
 		}
	}
	else
	{
		for (int i = 0; i<[piViewDateArray count];i++)
		{
            if(colorName == 10)
			{
				colorName = 0;
			}
            
			tmpPiItem =[piViewDateArray objectAtIndex:i];
			tmpPiItem.cPercent = tmpPiItem.cData/totolAmountTmp;
            tmpPiItem.cColor =(isExpenseType)? [appDelegate.epnc getExpColor:colorName]:[appDelegate.epnc getIncColor:colorName];
            tmpPiItem.cImage = (isExpenseType)?[appDelegate.epnc getExpImage:colorName]:[appDelegate.epnc getIncImage:colorName];
            colorName ++;
            
  		}
	}
 	[trantableview reloadData];
}

#pragma mark Btn Action
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rangeBtnPressed:(UIButton *)sender{
    DateRangeViewController *dateRangeViewController = [[DateRangeViewController alloc]initWithNibName:@"DateRangeViewController" bundle:nil];
    dateRangeViewController.expenseViewController = nil;
    dateRangeViewController.expenseCategoryViewController = nil;
    dateRangeViewController.expenseSecondCategoryViewController = self;
    dateRangeViewController.cashDetailViewController = nil;

    [self.navigationController pushViewController:dateRangeViewController animated:YES];

}



#pragma mark TableView Delegate
- (void)configureReportCategoryCell:(ReportTransactionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    PiChartViewItem *tmpPiItem= [piViewDateArray objectAtIndex:indexPath.section];
    
    Transaction *oneTransaction = [tmpPiItem.transactionArray objectAtIndex:indexPath.row];
    //Name
    if (oneTransaction.payee != nil && [oneTransaction.payee.name length]>0) {
        cell.nameLabel.text = oneTransaction.payee.name;

    }
    else if ([oneTransaction.notes length]>0)
        cell.nameLabel.text = oneTransaction.notes;
    else
        cell.nameLabel.text = @"-";

    //date
    cell.timeLabel.text = [dateFormatter stringFromDate:oneTransaction.dateTime];

    //amount
    if ([oneTransaction.category.categoryType isEqualToString:@"EXPENSE"] ||[oneTransaction.childTransactions count]>0) {
        [cell.amountLabel setTextColor:[UIColor colorWithRed:243.0/255 green:61.0/255 blue:36.0/255 alpha:1]];
        if (oneTransaction.payee!=nil)
        {
            cell.nameLabel.text = oneTransaction.payee.name;
        }
        else
        {
            cell.nameLabel.text = @"-";
        }
        cell.amountLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue] ];
        
        
    }
    else if ([oneTransaction.category.categoryType isEqualToString:@"INCOME"]){
        [cell.amountLabel setTextColor:[UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1.0]];
        if (oneTransaction.payee!=nil)
        {
            cell.nameLabel.text = oneTransaction.payee.name;
        }
        else
        {
            cell.nameLabel.text = @"-";
        }        cell.amountLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue] ];
        
        
    }
    else{
        [cell.amountLabel setTextColor:[UIColor colorWithRed:172.0/255 green:173.0/255 blue:178.0/255 alpha:1.0]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ > %@",oneTransaction.expenseAccount.accName,oneTransaction.incomeAccount.accName ];
        cell.amountLabel.text = [appDelegate.epnc formatterString:[oneTransaction.amount doubleValue] ];
    }
    
    if (indexPath.row == [((PiChartViewItem *)[piViewDateArray objectAtIndex:indexPath.section]).transactionArray count]-1 )
    {
        cell.line.frame = CGRectMake(0, cell.line.frame.origin.y, SCREEN_WIDTH, cell.line.frame.size.height);
    }
    else
    {
        cell.line.frame = CGRectMake(15, cell.line.frame.origin.y, SCREEN_WIDTH, cell.line.frame.size.height);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [piViewDateArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((PiChartViewItem *)[piViewDateArray objectAtIndex:section]).transactionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    headerView.backgroundColor = [UIColor colorWithRed:234.f/255.f green:234.f/255.f blue:234.f/255.f alpha:1];
    
    PiChartViewItem *onePiCharView = [piViewDateArray objectAtIndex:section];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //category
 	UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 120, 20)];
	[stringLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
 	[stringLabel setTextColor:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1]];
	[stringLabel setBackgroundColor:[UIColor clearColor]];
	stringLabel.textAlignment = NSTextAlignmentLeft;
    stringLabel.text = onePiCharView.category.categoryName;
    [headerView addSubview:stringLabel];

    //percent
    UILabel *perLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-30, 2, 60, 20)];
	[perLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
 	[perLabel setTextColor:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1]];
	[perLabel setBackgroundColor:[UIColor clearColor]];
	perLabel.textAlignment = NSTextAlignmentCenter;
    perLabel.text = [[NSString stringWithFormat: @"%.2f",onePiCharView.cPercent*100] stringByAppendingString:@"%"];
    [headerView addSubview:perLabel];

    //amount
    UILabel *stringLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+50, 2, SCREEN_WIDTH*0.5-65, 20)];
    [stringLabel1 setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
 	[stringLabel1 setTextColor:[UIColor colorWithRed:166/255.f green:166/255.f blue:166/255.f alpha:1]];
	[stringLabel1 setBackgroundColor:[UIColor clearColor]];
	stringLabel1.textAlignment = NSTextAlignmentRight;
    stringLabel1.text =[appDelegate.epnc formatterString:onePiCharView.cData];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
    line.backgroundColor = [UIColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1];
    [headerView addSubview:line];
    
    [headerView addSubview:stringLabel1];
    

    
	return headerView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReportTransactionCell *cell = (ReportTransactionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ReportTransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [self configureReportCategoryCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PiChartViewItem *oneItem = [piViewDateArray objectAtIndex:indexPath.section];

    Transaction *oneTrans =[oneItem.transactionArray objectAtIndex:indexPath.row];
    if (oneTrans.parTransaction != nil) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a part of a transaction split, and it can not be edited alone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        appDelegate.appAlertView = alertView;
        [alertView show];
   
        return;
        
    }
    self.transactionEditViewController = [[TransactionEditViewController alloc]initWithNibName:@"TransactionEditViewController" bundle:nil];
    self.transactionEditViewController.transaction = [oneItem.transactionArray objectAtIndex:indexPath.row];
    self.transactionEditViewController.typeoftodo = @"EDIT";
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:self.transactionEditViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

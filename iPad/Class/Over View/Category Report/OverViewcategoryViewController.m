//
//  OverViewcategoryViewController.m
//  PocketExpense
//
//  Created by appxy_dev on 14-4-23.
//
//

#import "OverViewcategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ReportCategoryTableViewCell.h"
#import "ChildCategoryCount.h"
#import "TranscationCategoryCount.h"

@interface OverViewcategoryViewController ()

@end

@implementation OverViewcategoryViewController
@synthesize piCahrView,myTableView,startDate,endDate,expenseOrIncomeBtn,transactionArray,piViewDateArray,categoryArrayList,fetchedResultsController,noRecordView;

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
}


-(void)initPoint
{
    noRecordView.text = NSLocalizedString(@"VC_ipadNoRecords", nil);
    [expenseOrIncomeBtn setTitle:NSLocalizedString(@"VC_EXPENSE", nil) forState:UIControlStateNormal];
    
    [piCahrView allocArray];
    piCahrView.canBetouch = FALSE;
    
    transactionArray = [[NSMutableArray alloc] init];
	piViewDateArray = [[NSMutableArray alloc] init];
    categoryArrayList = [[NSMutableArray alloc] init];
    
    expenseOrIncomeBtn.selected = NO;
    [expenseOrIncomeBtn addTarget:self action:@selector(expenseOrIncomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    expenseOrIncomeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [expenseOrIncomeBtn.titleLabel setMinimumScaleFactor:0];

}

//------1.获取需要的数据
- (void)getDateSouce_category{
    NSError *error =nil;
    ////////////////////////Category Report
	[piViewDateArray removeAllObjects];
    [categoryArrayList removeAllObjects];
	double totalSpent = 0.0;//总共的花费
	double totalIncome = 0.0;//总共的收入
    int totalTranIncCount = 0;//总共的收入交易个数
    int totalTranExpCount = 0;//总共的花费交易个数
	int colorName=0;
    
    //获取选中时间段的交易数组
	if (![self getfetchedResultsController])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		// abort();
	}
    
    
	PiChartViewItem *tmpPiChartViewItem;
	double categoryTotalSpend;
	NSMutableArray *tmpPiViewDateArray = [[NSMutableArray alloc] init];
    
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    

    
 	for (int i=0;i<[[fetchedResultsController sections] count];i++)
	{
		TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:i];
		cc.categoryName = [sectionInfo name];
        
 		NSString *searchForMe = @":";
		NSRange range = [cc.categoryName rangeOfString : searchForMe];
        //1.如果这是一个二级category底下的transaction,那么就需要查找到父层的category,以及父层category下的所有交易
		if (range.location != NSNotFound){
			NSArray * seprateSrray = [cc.categoryName componentsSeparatedByString:@":"];
			NSString *parName = [seprateSrray objectAtIndex:0];
            NSString *childName = [seprateSrray objectAtIndex:1];
            
            //获取父类的category
			NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
			NSFetchRequest *fetchRequest=	[appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
			[fetchRequest setSortDescriptors:sortDescriptors];
			NSArray *objects1 = [appDelegete.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            //获取父类category的数组
 			NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
		
            
			if([tmpParCategoryArray count]>0){
                //获取到父层的category
				Category *pc =  [tmpParCategoryArray lastObject];
				BOOL isFound = FALSE;
				
                //这一段不会跑吧？？？？？
				for (int j=0; j<[categoryArrayList count]; j++) {
					TranscationCategoryCount *cc = [categoryArrayList objectAtIndex:j];
                    
                    
					if([pc.categoryName isEqualToString:cc.categoryName]){
                        [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
                        if(cc.c == nil&&[cc.transcationArray count]>0){
                            cc.c = [((Transaction *)[cc.transcationArray lastObject]) category];
                        }
                        
                        NSSortDescriptor *sort =[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
                        [cc.transcationArray sortUsingDescriptors:sorts];
                        
                    
                        
						isFound = TRUE;
                        double amount =0.0;
                        for (int j=0; j<[[sectionInfo objects]  count];j++)
                        {
                            Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                            if ([entry.category.categoryType isEqualToString:@"EXPENSE"]&&!expenseOrIncomeBtn.selected )
                            {
                                amount += [entry.amount doubleValue];
                                
                            }
                            else if ([entry.category.categoryType isEqualToString:@"INCOME"]&&!expenseOrIncomeBtn.selected   )
                            {
                                amount += [entry.amount doubleValue];
                                
                            }
                        }
                        if(amount >0)
                        {
                            ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                            ccc.fullName = [sectionInfo name] ;
                            ccc.categoryName = childName;
                            ccc.amount = amount;
                            [cc.childCateArray addObject:ccc];
                        }
                        
                        
                        
						break;
					}
				}
				
                //1.1如果没发现父层category的话 就需要创建一个父层
				if(!isFound)
				{
                    TranscationCategoryCount *cc = [[TranscationCategoryCount alloc] init];
					cc.categoryName = pc.categoryName ;
                    [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
 					[categoryArrayList addObject:cc];
                    if(cc.c == nil&&[cc.transcationArray count]>0)
                    {
                        cc.c = [((Transaction *)[cc.transcationArray lastObject]) category];
                    }
                    
                    double amount =0.0;
                    
                    for (int j=0; j<[[sectionInfo objects]  count];j++)
                    {
                        Transaction *entry = (Transaction *)[[sectionInfo objects]  objectAtIndex:j];
                        if ([entry.category.categoryType isEqualToString:@"EXPENSE"]&& !expenseOrIncomeBtn.selected )
                        {
                            amount += [entry.amount doubleValue];
                            
                        }
                        else if ([entry.category.categoryType isEqualToString:@"INCOME"]&&expenseOrIncomeBtn.selected)
                        {
                            amount += [entry.amount doubleValue];
                            
                        }
                    }
                    if(amount >0)
                    {
                        ChildCategoryCount *ccc = [[ChildCategoryCount alloc] init];
                        ccc.fullName = [sectionInfo name] ;
                        ccc.categoryName = childName;
                        ccc.amount = amount;
                        [cc.childCateArray addObject:ccc];
                    }
				}
 			}
 		}
        
        //2。如果查找到的tranaction,不是一个category的子category具有的tranactin，那么就直接赋值
		else
        {
            [cc.transcationArray addObjectsFromArray:[sectionInfo objects]];
            if(cc.c == nil&&[cc.transcationArray count]>0)
            {
                cc.c = [((Transaction *)[cc.transcationArray lastObject]) category];
            }
            [categoryArrayList addObject:cc];
            
		}
	}
    
    
    //计算总的金额 以及 创建piViewDateArray
 	for (int i=0;i<[categoryArrayList count];i++)
	{
        TranscationCategoryCount *cc = [categoryArrayList objectAtIndex:i];
		categoryTotalSpend =0;
 		if([cc.transcationArray count] > 0)
		{
            for (int j=0; j<[cc.transcationArray  count];j++)
			{
				Transaction *entry = (Transaction *)[cc.transcationArray  objectAtIndex:j];
				if ([entry.category.categoryType isEqualToString:@"EXPENSE"] )
				{
					totalSpent += [entry.amount doubleValue];
                    if(!expenseOrIncomeBtn.selected)
                        categoryTotalSpend +=[entry.amount doubleValue];
					
                    totalTranExpCount ++;
 				}
				else if ([entry.category.categoryType isEqualToString:@"INCOME"]   )
				{
					totalIncome += [entry.amount doubleValue];
                    if(expenseOrIncomeBtn.selected)
                        categoryTotalSpend +=[entry.amount doubleValue];
                    totalTranIncCount ++;
                    
				}
            }
			
			if(categoryTotalSpend>0  )
			{
                //创建圆环需要的数据
				tmpPiChartViewItem = [[PiChartViewItem alloc] initWithName:cc.categoryName==nil? @"Not Sure":cc.categoryName color:[UIColor clearColor] data:categoryTotalSpend];
                tmpPiChartViewItem.indexOfMemArr =i;
				[tmpPiViewDateArray addObject:tmpPiChartViewItem];
                
			}
 		}
	}
    
    //将获取到的圆环数据按照percent排序
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
    if(!expenseOrIncomeBtn.selected)
    {
        totolAmountTmp= totalSpent;
    }
    else totolAmountTmp = totalIncome;
    
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
            tmpPiItem.cColor =(!expenseOrIncomeBtn.selected)? [appDelegete.epnc getExpColor:colorName]:[appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = (!expenseOrIncomeBtn.selected)?[appDelegete.epnc getExpImage:colorName]:[appDelegete.epnc getIncImage:colorName];
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
            tmpPiItem.cColor =(!expenseOrIncomeBtn.selected)? [appDelegete.epnc getExpColor:colorName]:[appDelegete.epnc getIncColor:colorName];
            tmpPiItem.cImage = (!expenseOrIncomeBtn.selected)?[appDelegete.epnc getExpImage:colorName]:[appDelegete.epnc getIncImage:colorName];
            
            colorName ++;
            
  		}
	}
    
    piCahrView.whiteCycleR=35;
    [piCahrView setCateData:piViewDateArray ];
	[piCahrView setNeedsDisplay];
    
    [myTableView reloadData];
    
    if ([piViewDateArray count]>0) {
        noRecordView.hidden = YES;
    }
    else
    {
        noRecordView.hidden = NO;
    }
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [piViewDateArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier=@"CEll";
    ReportCategoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==Nil) {
        cell=[[ReportCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureReportCategoryCell:cell atIndexPath:indexPath withTableView:tableView ];
    return cell;
    
}
- (void)configureReportCategoryCell:(ReportCategoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tb{
    // Configure the cell
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    PiChartViewItem *tmpPiItem = [piViewDateArray objectAtIndex:indexPath.row];
    
    cell.colorImage.image=tmpPiItem.cImage;
    
    cell.percentLabel.text = [[NSString stringWithFormat: @"%.2f",tmpPiItem.cPercent*100] stringByAppendingString:@"%"];
    cell.nameLabel.text = tmpPiItem.cName;
    
    
    if(!expenseOrIncomeBtn.selected)
    {
        cell.spentLabel.text = [appDelegate.epnc formatterString: 0-tmpPiItem.cData];
        
        [cell.spentLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
        
    }
    else
    {
        [cell.spentLabel setTextColor:[UIColor colorWithRed:66.0/255.0 green:194.0/255.0 blue:135.0/255.0 alpha:1.f]];
        cell.spentLabel.text = [appDelegate.epnc formatterString: tmpPiItem.cData];
        
    }
    
    
}

- (NSFetchedResultsController *)getfetchedResultsController{
	PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
  	NSDictionary *subs = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"startDate",self.endDate,@"endDate", nil];
    
 	NSFetchRequest *fetchRequest = [appDelegete.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionByDate" substitutionVariables:subs];
    
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.categoryName != %@ and dateTime >= %@ and dateTime <= %@",nil,self.startDate,self.endDate];
    fetchRequest.predicate = predicate;
    
    NSFetchedResultsController* fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																					 managedObjectContext:appDelegete.managedObjectContext
																					   sectionNameKeyPath:@"category.categoryName"
																								cacheName:@"Root"];
	self.fetchedResultsController = fetchedResults;
    NSError *error;
    [fetchedResults performFetch:&error];

	return fetchedResultsController;
}

#pragma mark Btn Action
-(void)expenseOrIncomeBtnPressed:(UIButton *)sender{
    expenseOrIncomeBtn.selected = !expenseOrIncomeBtn.selected;
    
    [self getDateSouce_category];
}


@end

//
//  iPad_BillCategoryViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-16.
//
//

#import "iPad_BillCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_BillEditViewController.h"
#import "ipad_CategoryEditViewController.h"

#import "CategoryCount.h"
#import "ipad_CategoryCell.h"

@interface iPad_BillCategoryViewController ()

@end

@implementation iPad_BillCategoryViewController
@synthesize categoryTableView,categoryArray,category,iBillEditViewController,deleteIndex;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getDataSouce];
}

-(void)refleshUI{
    [self getDataSouce];
}

-(void)initPoint{
    categoryArray = [[NSMutableArray alloc]init];
    deleteIndex = -1;
}

-(void)initNavStyle{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];

    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_SelectCategory", nil);
    
    self.navigationItem.titleView = 	titleLabel;
	
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(0, 0, 30, 30);
	[backBtn setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    
}

-(void)getDataSouce{
    [categoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *fetchName = @"fetchCategoryByExpenseType";
    
    NSError *error = nil;
    NSDictionary *subs = [NSDictionary dictionary];
	NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];

    
	for (int i =0; i<[tmpCategoryArray count];i++)
    {
		Category *c = [tmpCategoryArray objectAtIndex:i];
		CategoryCount *cc = [[CategoryCount alloc] init];
		cc.categoryItem = c ;
        cc.pcType = noneType;
		
        cc.cateName = c.categoryName;
        
 		NSString *searchForMe = @":";
		NSRange range = [c.categoryName rangeOfString : searchForMe];
		
		if (range.location != NSNotFound)
        {
			NSArray * seprateSrray = [c.categoryName componentsSeparatedByString:@":"];
			NSString *parName = [seprateSrray objectAtIndex:0];
			
			NSDictionary *subs= [NSDictionary dictionaryWithObjectsAndKeys:parName,@"cName",  nil];
			
            //找到父类的category
			NSFetchRequest *fetchRequest=	[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchCategoryByName" substitutionVariables:subs];
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
			[fetchRequest setSortDescriptors:sortDescriptors];
            
			NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
			
 			NSMutableArray *tmpParCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
			
	
            
            //如果当前这个category有父类的category
			if([tmpParCategoryArray count]>0)
			{
				Category *pc =  [tmpParCategoryArray lastObject];
				BOOL isFound = FALSE;
				
                //查询数组中有没有这个父类，有的话，就将找到的这个category设为父类
				for (int j=0; j<[categoryArray count]; j++)
				{
					CategoryCount *tmpCC = [categoryArray objectAtIndex:j];
					
					if(pc == tmpCC.categoryItem)
					{
                        tmpCC.pcType = parentWithChild;
                        
						isFound = TRUE;
						break;
					}
				}
				
                //如果没找到父类。那么就创建一个父类
				if(!isFound)
				{
					CategoryCount *tmpCC = [[CategoryCount alloc] init];
					tmpCC.categoryItem = pc ;
                    tmpCC.pcType = parentWithChild;
                    tmpCC.cateName = pc.categoryName;
					tmpCC.cellHeight = 44.0;
					[categoryArray addObject:tmpCC];
				}
				
			}
            //将当前判断的category设为子类
            cc.pcType = childOnly;
            cc.cateName = [NSString stringWithFormat:@"-%@",[seprateSrray objectAtIndex:1]];
            
			cc.cellHeight = 38.0;
		}
		else
        {
            cc.pcType = parentNoChild;
			cc.cellHeight = 44.0;
		}
        
 		[categoryArray addObject:cc];
	}
	
    
    [categoryTableView reloadData];
}

#pragma mark Btn Action
-(void)cancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"CellPar";
	static NSString *CellIdentifierChild = @"CellChild";
	
 	ipad_CategoryCell *cellPar = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	ipad_CategoryCell *cellChild = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierChild];
	
	if (cellPar == nil)
	{
		cellPar = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPar] ;
		cellPar.selectionStyle = UITableViewCellSelectionStyleDefault;
 		cellPar.bgImageView.frame = CGRectMake(0, 0, 320,44.0);
		cellPar.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
        
 		cellPar.subShadowImageView.hidden = YES;
        
        
        cellPar.editingAccessoryType = UITableViewCellAccessoryDetailButton;
	}
    
	if (cellChild == nil)
	{
		cellChild = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierChild] ;
		cellChild.selectionStyle = UITableViewCellSelectionStyleDefault;
 		cellChild.bgImageView.frame = CGRectMake(0, 0, 320,38);
		cellChild.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
  		cellChild.subShadowImageView.hidden = YES;
        cellChild.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        
	}
    
	CategoryCount *cc = (CategoryCount *)[categoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;
    
	if(cc.cellHeight == 38.0)
	{
        cellChild.headImageView.frame = CGRectMake(49, 8, 28, 28);
        cellChild.nameLabel.frame = CGRectMake(83, 0, 150, 44);
        
        cellChild.headImageView.image = [UIImage imageNamed:categories.iconName];
		NSInteger tmpIndex =indexPath.row-1;
 		
		if(tmpIndex>=0&&tmpIndex<[categoryArray count])
		{
			CategoryCount *tmpcc =[categoryArray objectAtIndex:tmpIndex];
            
			if(tmpcc.pcType == parentWithChild )
			{
                //父级
                
				cellChild.subShadowImageView.hidden = NO;
			}
			else
            {
				cellChild.subShadowImageView.hidden = YES;
			}
            
		}
		else
        {
			cellChild.subShadowImageView.hidden = YES;
			
		}
        
        
        
		if(![categories.isSystemRecord boolValue])
		{
			cellChild.accessoryType = UITableViewCellAccessoryDetailButton;
			cellChild.editingAccessoryType = UITableViewCellAccessoryDetailButton;
		}
		else {
			cellChild.accessoryType = UITableViewCellAccessoryNone;
            cellChild.editingAccessoryType = UITableViewCellAccessoryNone;
            
		}
		
        cellChild.nameLabel.text = cc.cateName;
        
        //给选中的cell做标记
        if (cc.categoryItem == self.iBillEditViewController.categories) {
            cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (indexPath.row == [categoryArray count]-1) {
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
            
        }
        else{
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
        }
		return cellChild;
	}
	
	cellPar.subShadowImageView.hidden = YES;
	if(![categories.isSystemRecord boolValue])
	{
		cellPar.accessoryType = UITableViewCellAccessoryDetailButton;
        cellPar.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        
	}
	else {
		cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
        
	}
	
	cellPar.nameLabel.text = categories.categoryName;
	cellPar.headImageView.image = [UIImage imageNamed:categories.iconName];
	
    
    if (categoryTableView.editing) {
        cellPar.thisCellisEdit = YES;
        cellChild.thisCellisEdit = YES;
        
    }
    else{
        cellPar.thisCellisEdit = NO;
        cellChild.thisCellisEdit = NO;
    }
    
    //给选中的category做标记
    if (cc.categoryItem == self.iBillEditViewController.categories) {
        cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (indexPath.row == [categoryArray count]-1) {
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
    }
    else{
        cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
    }
	return cellPar;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *currentType=nil;
    if(self.iBillEditViewController!=nil)
    {
        currentType=self.iBillEditViewController.categories;
        
    }
    
    //去掉之前的√
	if (currentType)
    {
 		NSInteger rowIndex = [categoryArray indexOfObject:currentType];
		UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
		checkedCell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// Set the checkmark accessory for the selected row.
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    if(self.iBillEditViewController!=nil)
    {
        self.iBillEditViewController.categories= [(CategoryCount *)[categoryArray objectAtIndex:indexPath.row] categoryItem];
    }
    
 	// Deselect the row.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	CategoryCount *cc = (CategoryCount *)[categoryArray objectAtIndex:indexPath.row];
	Category *tmpCategory = cc.categoryItem;
    
 	if([tmpCategory.isSystemRecord boolValue])
        return;
    ipad_CategoryEditViewController *editController =[[ipad_CategoryEditViewController alloc] initWithNibName:@"ipad_CategoryEditViewController" bundle:nil];
    
	editController.categories = tmpCategory;
	editController.editModule = @"EDIT";
	[self.navigationController pushViewController:editController animated:YES];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	CategoryCount *cc = (CategoryCount *)[categoryArray objectAtIndex:indexPath.row];
//	Category *tmpCategory = cc.categoryItem;
//    
//    NSString *msg;
//    
//    if(cc.pcType == parentWithChild)
//    {
//        msg=       [NSString stringWithFormat:@"Delete %@ will cause to also delete all its transactions, sub-categories ,related bills and budgets.",tmpCategory.categoryName];
//        
//    }
//    else
//    {
//        msg=       [NSString stringWithFormat:@"Delete %@ will cause to also delete all its transactions, related bills and budgets.",tmpCategory.categoryName];
//        
//    }
//	
//	if(editingStyle == UITableViewCellEditingStyleDelete)
//	{
//		UIActionSheet *actionSheet= [[UIActionSheet alloc]
//									 initWithTitle:msg
//									 delegate:self
//									 cancelButtonTitle:@"Cancel"
//									 destructiveButtonTitle:@"Remove"
//									 otherButtonTitles:nil,
//									 nil];
//		[actionSheet showInView:self.view];
//		[actionSheet release];
//		deleteIndex = indexPath.row;
//	}
//}

#pragma mark UIActionSheet DeleteCategory
-(void)deleteCategoryAndRelation:(Category*) oneCategory
{
 	
    //	PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //
    //	NSMutableArray *tmpTransactionArray = [[NSMutableArray alloc] initWithArray:[oneCategory.transactions allObjects]];
    //
    //	for (int i=0; i<[tmpTransactionArray count]; i++)
    //	{
    //		Transaction *deleteLog = (Transaction *)[tmpTransactionArray objectAtIndex:i];
    //		[appDelegate.managedObjectContext deleteObject:deleteLog];
    //	}
    //	[tmpTransactionArray release];
    //
    //	if(oneCategory.budgetTemplate!=nil)
    //        [appDelegate.managedObjectContext deleteObject:oneCategory.budgetTemplate];
    //
    //
    //
    //	NSMutableArray *billArray = [[NSMutableArray alloc] initWithArray:[oneCategory.billItem allObjects]];
    //	for (int i=0; i<[billArray count]; i++)
    //	{
    //		BillRule *deleteLog = (BillRule *)[billArray objectAtIndex:i];
    //		[appDelegate.managedObjectContext deleteObject:deleteLog];
    //	}
    //	[billArray release];
    //
    //
    //	BudgetTemplate *tmpBudget = oneCategory.budgetTemplate;
    //	if(tmpBudget!=nil)
    //	{
    //		NSMutableArray *budgetItemArray = [[NSMutableArray alloc] initWithArray:[tmpBudget.budgetItems allObjects]];
    //		if(budgetItemArray.count > 0)
    //		{
    //			for (int i=0; i<[budgetItemArray count]; i++)
    //			{
    //				BudgetItem *object = (BudgetItem *)[budgetItemArray objectAtIndex:i];
    //
    //				NSMutableArray *fromTransferArray = [[NSMutableArray alloc] initWithArray:[object.fromTransfer allObjects]];
    //				for (int j=0; j<[fromTransferArray count]; j++)
    //				{
    //					BudgetTransfer  *fromT = (BudgetTransfer *)[fromTransferArray objectAtIndex:j];
    //					[fromT.toBudget removeFromTransferObject:fromT];
    //					[appDelegate.managedObjectContext deleteObject:fromT];
    //
    //				}
    //				[fromTransferArray release];
    //
    //				NSMutableArray *toTransferArray = [[NSMutableArray alloc] initWithArray:[object.toTransfer allObjects]];
    //				for (int j=0; j<[toTransferArray count]; j++)
    //				{
    //					BudgetTransfer  *toT = (BudgetTransfer *)[toTransferArray objectAtIndex:j];
    //					[toT.fromBudget removeToTransferObject:toT];
    //					[appDelegate.managedObjectContext deleteObject:toT];
    //
    //				}
    //				[toTransferArray release];
    //
    //				[appDelegate.managedObjectContext deleteObject:object];
    //			}
    //		}
    //		[budgetItemArray release];
    //		[appDelegate.managedObjectContext deleteObject:tmpBudget];
    //	}
    //
    //	oneCategory.hasBudget = [NSNumber numberWithBool:FALSE];
    //
    //	oneCategory.others = @"";
	
}

//获取下一个parentCategory
-(NSInteger)getNextParentCategoryIndexFromDeleteIndex
{
    
 	for (long i=deleteIndex+1; i<[categoryArray count];i ++) {
		
		CategoryCount *cc =[categoryArray objectAtIndex:i];
		
		if(cc.pcType == parentWithChild || cc.pcType == parentNoChild)
		{
			return i;
		}
	}
	
	return deleteIndex;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

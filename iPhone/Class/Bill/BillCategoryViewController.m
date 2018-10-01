//
//  BillCategoryViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-6.
//
//

#import "BillCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "BillEditViewController.h"
#import "CategoryCell.h"
#import "CategoryEditViewController.h"

#import "CategoryCount.h"

@interface BillCategoryViewController ()

@end

@implementation BillCategoryViewController
@synthesize categoryTableView,categoryArray,category,billEditViewController,deleteIndex;

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
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}

-(void)refleshUI{
    [self getDataSouce];
}

-(void)initPoint{
    categoryArray = [[NSMutableArray alloc]init];
    deleteIndex = -1;
}

-(void)initNavStyle{
    [self.navigationController.navigationBar doSetNavigationBar];

    self.navigationItem.title = NSLocalizedString(@"VC_SelectCategory", nil);
}

-(void)getDataSouce{
    [categoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *fetchName = @"fetchCategoryByExpenseType";
 
    NSError *error = nil;
	NSDictionary *subs = [[NSDictionary alloc]init];
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPar = @"categoryCell";
    CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
    }

    
	CategoryCount *cc = (CategoryCount *)[categoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.categoryItem;
    
	if(cc.cellHeight == 38.0)
	{
        cell.iconX.constant = 49;
        cell.nameX.constant = 83;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
 		
        if(![categories.isSystemRecord boolValue])
        {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
		
        cell.nameLabel.text = cc.cateName;
        
        //给选中的cell做标记
        if (cc.categoryItem == self.billEditViewController.categories) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (indexPath.row == [categoryArray count]-1)
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 83;
		return cell;
	}
    else
    {
        cell.iconX.constant = 10;
        cell.nameX.constant = 46;
        if(![categories.isSystemRecord boolValue])
        {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.nameLabel.text = categories.categoryName;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
        
        
        if (categoryTableView.editing)
        {
            cell.thisCellisEdit = YES;
            cell.thisCellisEdit = YES;
        }
        else
        {
            cell.thisCellisEdit = NO;
            cell.thisCellisEdit = NO;
        }
        
        //给选中的category做标记
        if (cc.categoryItem == self.billEditViewController.categories)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        if (indexPath.row == [categoryArray count]-1)
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 46;
        return cell;
    }
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *currentType=nil;
    if(self.billEditViewController!=nil)
    {
        currentType=self.billEditViewController.categories;
        
    }
    
    //去掉之前的√
	if (currentType != nil)
    {
 		NSInteger rowIndex = [categoryArray indexOfObject:currentType];
		UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
		checkedCell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// Set the checkmark accessory for the selected row.
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    if(self.billEditViewController!=nil)
    {
        self.billEditViewController.categories= [(CategoryCount *)[categoryArray objectAtIndex:indexPath.row] categoryItem];
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
    CategoryEditViewController *editController =[[CategoryEditViewController alloc] initWithNibName:@"CategoryEditViewController" bundle:nil];
    
	editController.categories = tmpCategory;
	editController.editModule = @"EDIT";
//	[self.navigationController pushViewController:editController animated:YES];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:editController];
    [self.navigationController presentViewController:navi animated:YES completion:NO];
}




#pragma mark UIActionSheet DeleteCategory
-(void)deleteCategoryAndRelation:(Category*) oneCategory
{
 	

	
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


//删除有交易的category
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	if(buttonIndex == 1)
//        return;
//    
//    
//    //获取要删除的category
//	CategoryCount *cc = (CategoryCount *)[tcvc_allCategoryArray objectAtIndex:deleteIndex];
//    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    if (self.tcvc_transactionEditViewController != nil) {
//        if (cc.categoryItem==self.tcvc_transactionEditViewController.categories) {
//            self.tcvc_transactionEditViewController.categories = nil;
//        }
//        
//    }
//    //如果这个category是parentCategory
// 	if(cc.pcType == parentWithChild)
//	{
//        
//        //之前的categoryArray是获取所有category,包括childCategory,因为他们和parentCategory平级
//        //获取下一个ParentCategory的Index
//		NSInteger endOfCycle =[self getNextParentCategoryIndexFromDeleteIndex];
//		if(endOfCycle == deleteIndex)
//		{
//			endOfCycle =[tcvc_allCategoryArray count];
//		}
//		
//        //删掉这个 parentCategory旗下的所有子category
//		for (int i=deleteIndex; i<endOfCycle;i ++)
//		{
//			CategoryCount *cc1 =[tcvc_allCategoryArray objectAtIndex:i];
// 			
//			[self deleteCategoryAndRelation:cc1.categoryItem];
//            [appDelegate.managedObjectContext deleteObject:cc1.categoryItem];
//            
//		}
//		
//	}
//	else
//	{
//		[self deleteCategoryAndRelation:cc.categoryItem];
//        [appDelegate.managedObjectContext deleteObject:cc.categoryItem];
//	}
//    NSError *error=nil;
//   	if(![appDelegate.managedObjectContext save:&error])
//	{
//		NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
//	}
//    [self getDataSouce];
//    [self.tcvc_categoryTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

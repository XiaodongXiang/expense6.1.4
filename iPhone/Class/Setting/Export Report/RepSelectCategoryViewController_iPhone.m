//
//  RepSelectCategoryViewController_iPhone.m
//  PocketExpense
//
//  Created by MV on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepSelectCategoryViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "CategorySelect.h"


@implementation RepSelectCategoryViewController_iPhone
@synthesize iTranReportViewController;
@synthesize selectType;
@synthesize isSelectAll;
#pragma mark - Customer API
-(void)initNavBarStyle
{
    
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = @"Select categories";


    isSelectAll = TRUE;
    if([selectType isEqualToString:@"BILLCATEGORY"])
    {
        ;
        
    }
    else
    {
        for (int i=0; i<[iTranReportViewController.tranCategorySelectArray count]; i++) {
            CategorySelect *categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:i];
            if(!categoruSelect.isSelect)
            {
                isSelectAll = FALSE;
                break;
            }
        }
        
    }
    

}


#pragma mark - View lifecycle
- (void)viewDidLoad {
	
	[super viewDidLoad];
    [self initNavBarStyle];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_320_460.png"]];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
     if([selectType isEqualToString:@"BILLCATEGORY"])
    {
//    	NSInteger count=0;
//        if([iBillReportViewController.billCategorySelectArray count]==1) count =1;
//        else if([iBillReportViewController.billCategorySelectArray count]>1) count =[iBillReportViewController.billCategorySelectArray count]+1;
//        return count;
        
    }
	NSInteger count=0;
    if([iTranReportViewController.tranCategorySelectArray count]==1) count =1;
    else if([iTranReportViewController.tranCategorySelectArray count]>1) count =[iTranReportViewController.tranCategorySelectArray count]+1;
	return count;

}

//--------在IOS7中 cell的背景颜色会被默认成白色，用这个代理来去掉白色背景
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString *tCellIdentifier = @"selectCategoryCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tCellIdentifier];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_b2_320_44.png"]];
        cell.backgroundView = bgImageView;
        [cell.textLabel setTextColor:[UIColor colorWithRed:54.0/255 green:55.0/255 blue:60.0/255 alpha:1]];

	}
	
	if([selectType isEqualToString:@"BILLCATEGORY"])
	{
//        if(isSelectAll)
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            if(indexPath.row ==0&&[iBillReportViewController.billCategorySelectArray count]>1)
//            {
//                cell.textLabel.text = @"All";
//            }
//            else
//            {
//                CategorySelect *categoruSelect ;
//                if([iBillReportViewController.billCategorySelectArray count] ==1)
//                {
//                    categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:0];
//                    
//                }
//                else
//                {
//                    categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:indexPath.row-1];
//                    
//                }
//                cell.textLabel.text = categoruSelect.category.categoryName;
//                
//            }
//        }
//        else
//        {
//            if(indexPath.row ==0&&[iBillReportViewController.billCategorySelectArray count]>1)
//            {
//                cell.textLabel.text = @"All";
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            else
//            {
//                CategorySelect *categoruSelect ;
//                if([iBillReportViewController.billCategorySelectArray count] ==1)
//                {
//                    categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:0];
//                    
//                }
//                else
//                {
//                    categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:indexPath.row-1];
//                    
//                }
//                cell.textLabel.text = categoruSelect.category.categoryName;
//                if(categoruSelect.isSelect )
//                {
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    
//                }
//                else {
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    
//                }
//                
//            }
//            
//        }
        
        
	}
	else {
        if(isSelectAll)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if(indexPath.row ==0&&[iTranReportViewController.tranCategorySelectArray count]>1)
            {
                cell.textLabel.text = @"All";
            }
            else
            {
                CategorySelect *categoruSelect ;
                if([iTranReportViewController.tranCategorySelectArray count] ==1)
                {
                    categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:0];
                    
                }
                else
                {
                    categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:indexPath.row-1];
                    
                }
                
                cell.textLabel.text = categoruSelect.category.categoryName;
                
            }
        }
        else
        {
            if(indexPath.row ==0&&[iTranReportViewController.tranCategorySelectArray count]>1)
            {
                cell.textLabel.text = @"All";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                CategorySelect *categoruSelect ;
                if([iTranReportViewController.tranCategorySelectArray count] ==1)
                {
                    categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:0];
                    
                }
                else
                {
                    categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:indexPath.row-1];
                    
                }
                cell.textLabel.text = categoruSelect.category.categoryName;
                if(categoruSelect.isSelect )
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                
            }
            
        }
 	}
    
    return cell;
}	

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	
	return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
 	if([selectType isEqualToString:@"BILLCATEGORY"])
	{
        
//        if(indexPath.row ==0&&[iBillReportViewController.billCategorySelectArray count]>1)
//        {
//            isSelectAll = !isSelectAll;
//            for (int i=0; i<[iBillReportViewController.billCategorySelectArray count]; i++) {
//                CategorySelect *categoruSelect	 = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:i ];
//                categoruSelect.isSelect = isSelectAll;
//                UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
//                
//                if(isSelectAll)
//                {
//                    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    
//                }
//                else
//                {
//                    selectCell.accessoryType = UITableViewCellAccessoryNone;
//                    
//                }
//            }
//            UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            
//            if(isSelectAll)
//            {
//                firstCell.accessoryType = UITableViewCellAccessoryCheckmark;
//                
//            }
//            else
//            {
//                firstCell.accessoryType = UITableViewCellAccessoryNone;
//                
//            }
//        }
//        else
//        {
//            CategorySelect *categoruSelect ;
//            if([iBillReportViewController.billCategorySelectArray count] ==1)
//            {
//                categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:0];
//                
//            }
//            else
//            {
//                categoruSelect = (CategorySelect *)[iBillReportViewController.billCategorySelectArray objectAtIndex:indexPath.row-1];
//                
//            }
//            
//            UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
//            {
//                if(categoruSelect.isSelect )
//                {
//                    selectCell.accessoryType = UITableViewCellAccessoryNone;
//                    if(isSelectAll)
//                    {
//                        UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//                        firstCell.accessoryType = UITableViewCellAccessoryNone;
//                        isSelectAll = FALSE;
//                        
//                    }
//                }
//                else {
//                    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    
//                }
//                
//                categoruSelect.isSelect = !categoruSelect.isSelect;
//                
//            }
//            
//        }
        
		
	
    }
	else {
        if(indexPath.row ==0&&[iTranReportViewController.tranCategorySelectArray count]>1)
        {
            isSelectAll = !isSelectAll;
            for (int i=0; i<[iTranReportViewController.tranCategorySelectArray count]; i++) {
                CategorySelect *categoruSelect	 = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:i ];
                categoruSelect.isSelect = isSelectAll;
                UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                
                if(isSelectAll)
                {
                    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }
                else
                {
                    selectCell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
            }
            UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            if(isSelectAll)
            {
                firstCell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }
            else
            {
                firstCell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        else
        {
            CategorySelect *categoruSelect ;
            if([iTranReportViewController.tranCategorySelectArray count] ==1)
            {
                categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:0];
                
            }
            else
            {
                categoruSelect = (CategorySelect *)[iTranReportViewController.tranCategorySelectArray objectAtIndex:indexPath.row-1];
                
            }
            
            UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
            {
                if(categoruSelect.isSelect )
                {
                    selectCell.accessoryType = UITableViewCellAccessoryNone;
                    if(isSelectAll)
                    {
                        UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        firstCell.accessoryType = UITableViewCellAccessoryNone;
                        isSelectAll = FALSE;
                        
                    }
                }
                else {
                    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }
                
                categoruSelect.isSelect = !categoruSelect.isSelect;
                
            }
            
        }
        
	}
}

#pragma mark navigationItem event
- (void) back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];   
}


#pragma mark View release
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end

//
//  BudgetDetailViewController.m
//  Expense 5
//
//  Created by BHI_James on 4/23/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "BudgetDetailViewController.h"
#import "BudgetTemplate.h"
#import "BudgetTransfer.h"
#import "Transaction.h"
#import "Accounts.h"
#import "Payee.h"
#import "BudgetDetailClassType.h"
#import "PokcetExpenseAppDelegate.h"
#import "TransactionRule.h"
#import "TransactionEditViewController.h"
#import "BudgetDetailViewControllerCell.h"

#import "AppDelegate_iPhone.h"
#import "TransferViewController_NS.h"
#import "budgetBar.h"

@implementation BudgetDetailViewController

#pragma mark View life
- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initMemoryDefine];
    [self initNarBarStyle];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

	[self getDataSouce];
    [self setControlStyle];
	if([_dataSouceList count] == 0)
	{
		_noRecordView.hidden = NO;
	}
	else {
		_noRecordView.hidden = YES;
        
	}
	[self.mytableView reloadData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}


#pragma mark View DidLoad Method
-(void)initMemoryDefine
{
    _lineH.constant = EXPENSE_SCALE;
    [_bvc_transferBtn setTitle:NSLocalizedString(@"VC_Transfer", nil) forState:UIControlStateNormal];
    _noRecordLabelText.text = NSLocalizedString(@"VC_BudgetDetailNotes", nil);
   
    
    
    _outputFormatter = [[NSDateFormatter alloc] init];
	_outputFormatter.dateStyle = NSDateFormatterMediumStyle;
    _outputFormatter.timeStyle = NSDateFormatterNoStyle;
    [_outputFormatter setLocale:[NSLocale currentLocale]];

	_dataSouceList = [[NSMutableArray alloc] init];
    

    
    
    [_bvc_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_bvc_transferBtn addTarget:self action:@selector(transferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initNarBarStyle
{
    ;
}

-(void)setControlStyle
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
	_bdvc_categoryLabel.text = _budgetTemplate.category.categoryName;
    
    double totalExpense = 0;
    double totalIncome = 0;
    for (int i=0; i<[_dataSouceList count]; i++) {
        BudgetDetailClassType *oneBudgetDetailClassType = [_dataSouceList objectAtIndex:i];
        if (oneBudgetDetailClassType.transaction != nil) {
            if ([oneBudgetDetailClassType.transaction.category.categoryType isEqualToString:@"EXPENSE"]) {
                totalExpense += [oneBudgetDetailClassType.transaction.amount doubleValue];
            }
            else if ([oneBudgetDetailClassType.transaction.category.categoryType isEqualToString:@"INCOME"])
                totalIncome += [oneBudgetDetailClassType.transaction.amount doubleValue];
            
        }
        else if (oneBudgetDetailClassType.dct == DetailClassTypeFromTransfer){
            totalExpense += [oneBudgetDetailClassType.budgetTransfer.amount doubleValue];
        }
        else if (oneBudgetDetailClassType.dct == DetailClassTypeToTransfer){
            totalIncome += [oneBudgetDetailClassType.budgetTransfer.amount doubleValue];
        }
        
    }
    
    
    double budgetTotalAmount = [_budgetItem.amount doubleValue]+totalIncome;
    
    //set text
    //设置金额的显示text
    NSString *spentString;
    if (totalExpense<100000)//100k-1
    {
        spentString =[NSString stringWithFormat:@"%@ ",[appDelegate.epnc formatterStringWithOutPositive:totalExpense]];
//        spentString = [appDelegate.epnc formatterStringWithOutCurrency:totalExpense];

    }
    else if (totalExpense<100000000)//100k --- 100m-1
    {
        spentString =[NSString stringWithFormat:@"%.0f k", totalExpense/1000];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];
    }
    else if(totalExpense < 100000000000)//100m -- 100b-1
    {
        spentString =[NSString stringWithFormat:@"%.0f m", totalExpense/1000000.0];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];

    }
    else{
        spentString =[NSString stringWithFormat:@"%.0f b", totalExpense/1000000000.0];
        spentString = [NSString stringWithFormat:@"%@%@ ",appDelegate.epnc.currenyStr,spentString];

    }

    
    NSString *totalString;
    if (budgetTotalAmount<100000)//100k-1
    {
        totalString =[NSString stringWithFormat:@"/ %@",[appDelegate.epnc formatterStringWithOutPositive:budgetTotalAmount]];
//        totalString = [appDelegate.epnc formatterStringWithOutCurrency:budgetTotalAmount];

    }
    else if (budgetTotalAmount<100000000)//100k --- 100m-1
    {
        totalString =[NSString stringWithFormat:@"%.0f k", budgetTotalAmount/1000.0];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];

    }
    else if(budgetTotalAmount < 100000000000)//100m -- 100b-1
    {
        totalString =[NSString stringWithFormat:@"%.0f m", budgetTotalAmount/1000000];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];

    }
    else
    {
        totalString =[NSString stringWithFormat:@"%.0f m", budgetTotalAmount/1000000000];
        totalString = [NSString stringWithFormat:@"/ %@%@",appDelegate.epnc.currenyStr,totalString];

    }
    
    //设置字体的颜色
    NSUInteger spStrLength=[spentString length];
    NSUInteger tbStrLength=[totalString length];
    
    NSRange spStrRange=NSMakeRange(0, spStrLength);
    NSRange tbRange=NSMakeRange(spStrLength, tbStrLength);
    
    NSString *allCompentsStr=[NSString stringWithFormat:@"%@%@",spentString,totalString];
    //spent
    NSMutableAttributedString *acAttributeStr=[[NSMutableAttributedString alloc]initWithString:allCompentsStr];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (totalExpense == 0) {
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[appDelegate_iPhone.epnc getAmountGrayColor] range:spStrRange];
    }
    else if (totalExpense <= budgetTotalAmount) {
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.f/255.f green:193.f/255.f blue:250.f/255.f alpha:1] range:spStrRange];
    }
    else
        [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[appDelegate.epnc getAmountRedColor] range:spStrRange];
    
    [acAttributeStr addAttribute:NSFontAttributeName value:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13] range:spStrRange];
    
    //设置后半截文字的颜色
    [acAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1] range:tbRange ];
    [acAttributeStr addAttribute:NSFontAttributeName value:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13] range:tbRange];
    
    
    self.headerBudgetAmountLabel.attributedText =acAttributeStr;
//    [headerBudgetAmountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:13]];
    
    
    self.lineHeight.constant=1/SCREEN_SCALE;
    
    //设置图片颜色，收入与支出
    //判断总共的金额，如果金额为0
    UIView *backBar=[[UIView alloc]initWithFrame:CGRectMake(35, 52, SCREEN_WIDTH-35-15, 5)];
    if (totalExpense<=budgetTotalAmount)
    {
        backBar.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        UIView *frontBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backBar.frame.size.width*totalExpense/budgetTotalAmount, 5)];
        frontBar.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [backBar addSubview:frontBar];
        
        CALayer *layer=frontBar.layer;
        [layer setCornerRadius:2.5f];
    }
    else
    {
        backBar.backgroundColor=[UIColor colorWithRed:255/255.0 green:115/255.0 blue:100/255.0 alpha:1];
        UIView *frontBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backBar.frame.size.width*budgetTotalAmount/totalExpense, 5)];
        frontBar.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        [backBar addSubview:frontBar];
        
        CALayer *layer=frontBar.layer;
        [layer setCornerRadius:2.5f];
    }
    
    CALayer *layer1=backBar.layer;
    [layer1 setCornerRadius:2.5f];
    
    
    
    [self.headContainView addSubview:backBar];
    
}

#pragma mark get data souce
- (void)getDataSouce
{
	[_dataSouceList removeAllObjects];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if(_budgetItem!=nil)
	{
		BudgetDetailClassType *bdct;
        
		NSDictionary *subs;
		
		double totalExpense=0;
		double totalIncome=0;
		
		subs = [NSDictionary dictionaryWithObjectsAndKeys:_budgetItem.budgetTemplate.category,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
        
        //搜索这段时间内该category的trans
		NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
		NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; 
		[fetchRequest setSortDescriptors:sortDescriptors];

		NSError *error =nil;
		
		NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
		for (int i = 0; i<[tmpArray count];i++)
        {
			Transaction *t = [tmpArray objectAtIndex:i];
            if([t.category.categoryType isEqualToString:@"EXPENSE"])
			{
				totalExpense +=[t.amount doubleValue];
			}
			else if([t.category.categoryType isEqualToString:@"INCOME"]){
				totalIncome +=[t.amount doubleValue];
			}
            //这里要新增加判断是 split的时候么
            else{
                totalExpense +=[t.amount doubleValue];
            }
			
			bdct = [[BudgetDetailClassType alloc] init];
			bdct.date = t.dateTime;
			bdct.dct = DetailClassTypeTranction;
			bdct.transaction = t;
            //保存所有的budgetDetail信息的数组
			[_dataSouceList addObject:bdct];
		}
		
		[tmpArray setArray:[_budgetItem.fromTransfer allObjects]];
		for (int i = 0; i<[tmpArray count];i++)
        {
			BudgetTransfer *bt = [tmpArray objectAtIndex:i];
            if ([appDelegate.epnc dateCompare:bt.dateTime withDate:self.startDate]>=0 && [appDelegate.epnc dateCompare:self.endDate withDate:bt.dateTime]>=0)
            {
                //5.0之后增加
                if ([bt.state isEqualToString:@"1"]) {
                    totalExpense +=[bt.amount doubleValue];
                    
                    bdct = [[BudgetDetailClassType alloc] init];
                    bdct.date = bt.dateTime ;
                    bdct.dct = DetailClassTypeFromTransfer;
                    bdct.budgetTransfer = bt;
                    [_dataSouceList addObject:bdct];
                }
            }
            
            
            
			
		}
		
		[tmpArray setArray:[_budgetItem.toTransfer allObjects]];
		for (int i = 0; i<[tmpArray count];i++)
        {
			BudgetTransfer *bt = [tmpArray objectAtIndex:i];
            if ([appDelegate.epnc dateCompare:bt.dateTime withDate:self.startDate]>=0 && [appDelegate.epnc dateCompare:self.endDate withDate:bt.dateTime]>=0)
            {
                if ([bt.state isEqualToString:@"1"]) {
                    totalIncome +=[bt.amount doubleValue];
                    
                    bdct = [[BudgetDetailClassType alloc] init];
                    bdct.date = bt.dateTime ;
                    bdct.dct = DetailClassTypeToTransfer;
                    bdct.budgetTransfer = bt;
                    [_dataSouceList addObject:bdct];
                }
            }
            
            
            
			
			//[bdct release];
		}
        ////////////////////get All child category，获取childCategory底下的trans
        NSString *searchForMe = @":";
		NSRange range = [_budgetItem.budgetTemplate.category.categoryName rangeOfString : searchForMe];
		
        //如果budget设置的category不是子category的时候
		if (range.location == NSNotFound) {
            
            NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",_budgetItem.budgetTemplate.category.categoryName];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",_budgetItem.budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
            NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ]; 			NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchChildCategory setSortDescriptors:sortDescriptors];
            NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
            NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
	
            for(int j=0 ;j<[tmpChildCategoryArray count];j++)
            {
                Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                 if(tmpCate !=_budgetItem.budgetTemplate.category)
                {
                    subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",self.startDate,@"startDate",self.endDate,@"endDate", nil];
                    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; 
                    [fetchRequest setSortDescriptors:sortDescriptors];
         
                    NSError *error =nil;
                    
                    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    NSMutableArray *tmpArraysub = [[NSMutableArray alloc] initWithArray:objects];
                    for (int i = 0; i<[tmpArraysub count];i++) {
                        Transaction *t = [tmpArraysub objectAtIndex:i];
                        bdct = [[BudgetDetailClassType alloc] init];
                        bdct.date = t.dateTime;
                        bdct.dct = DetailClassTypeTranction;
                        bdct.transaction = t;
                        [_dataSouceList addObject:bdct];
                    }
                    
                }
            }
            
        }
        
		NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];;
		
		NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
		
		[_dataSouceList sortUsingDescriptors:sorts];

	}
    
    
    //get all budget
    NSError *error =nil;
    //获取所有的budget template数组
    NSDictionary *subs1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"EMPTY", nil];
    
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchNewStyleBudget" substitutionVariables:subs1] copy];
 	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];

    if ([allBudgetArray count]>1) {
        _bvc_transferBtn.enabled = YES;
    }
    else
        _bvc_transferBtn.enabled = NO;
    
}



#pragma mark alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
	 	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];		
 		
	}
}

#pragma mark nav bar button action

-(void)transferBtnPressed:(UIButton *)sender
{
    
    
    _transferViewController = [[TransferViewController_NS alloc]initWithNibName:@"TransferViewController_NS" bundle:nil];

    _transferViewController.fromBudget = self.budgetTemplate;

    _transferViewController.typeOftodo = @"ADD";

    _transferViewController.startDate = self.startDate;

    _transferViewController.endDate = self.endDate;

    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:_transferViewController];

    [self.navigationController presentViewController:navi animated:YES completion:nil];

}

- (void) back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark  button action

- (IBAction) historyBtnPressed:(id)sender
{
//	BudgetHistoryViewController *historyController =[[BudgetHistoryViewController alloc] initWithNibName:@"BudgetHistoryViewController" bundle:nil];
//	historyController.budgetTemplate = self.budgetTemplate;
//  	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:historyController];
//	     [self presentViewController:navigationController animated:YES completion:nil];
//
//	[navigationController release];
//	[historyController release];
}

#pragma mark tableView Method
- (void)configureTransactionCell:(BudgetDetailViewControllerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BudgetDetailClassType *bdct = (BudgetDetailClassType *)[_dataSouceList objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    Transaction *transcation =bdct.transaction;
    
    //category spent
    if(bdct.dct == DetailClassTypeTranction)
	{
        //payee
        if(transcation.payee !=nil&&[transcation.payee.name length]>0)
        {
            cell.nameLabel.text = transcation.payee.name;
            
        }
        else if([transcation.notes length]>0)
            cell.nameLabel.text = transcation.notes;
        else
        {
            cell.nameLabel.text = @"-";
            
        }
        
        //category spent
 		if([transcation.category.categoryType isEqualToString:@"INCOME"])
            
        {
            if(transcation.category != nil)
            {
                cell.categoryLabel.text = transcation.category.categoryName;
            }
            else 
            {
                cell.categoryLabel.text = @"Not Sure";
            }
            cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transcation.amount  doubleValue]];
            
            [cell.spentLabel setTextColor:[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1]];
        }
        else 
        {
            if(transcation.category != nil)
            {
                cell.categoryLabel.text = transcation.category.categoryName;
            }
            else 
            {
                cell.categoryLabel.text = @"Not Sure";
            }
            
            [cell.spentLabel setTextColor:[UIColor colorWithRed:255/255.0 green:93/255.0 blue:103/255.0 alpha:1]];
            cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:0-[transcation.amount  doubleValue]];
        }
           
        
        //time
        NSString* time = [_outputFormatter stringFromDate:transcation.dateTime];
        cell.timeLabel.text = time;
    }
	else  
	{
        cell.nameLabel.text = @"-";
        cell.timeLabel.text = [_outputFormatter stringFromDate:bdct.date];

		if(bdct.dct == DetailClassTypeFromTransfer)
		{
            
			cell.categoryLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER To", nil),bdct.budgetTransfer.toBudget.budgetTemplate.category.categoryName];
             
		}
		else if(bdct.dct == DetailClassTypeToTransfer)
		{
            
			
			cell.categoryLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER From", nil),bdct.budgetTransfer.fromBudget.budgetTemplate.category.categoryName];
 		}
         
 		cell.spentLabel.text = [appDelegate.epnc formatterStringWithOutPositive:[bdct.budgetTransfer.amount doubleValue]];

        
        [cell.spentLabel setTextColor:[appDelegate.epnc getAmountGrayColor]];
        
    }
    if (bdct.dct != DetailClassTypeFromTransfer && bdct.dct != DetailClassTypeToTransfer)
    {
        [cell.categoryLabel removeFromSuperview];
        cell.nameToTop.constant=17;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [self.dataSouceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"budgetDetail";
    BudgetDetailViewControllerCell *cell = (BudgetDetailViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BudgetDetailViewControllerCell" owner:nil options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [self configureTransactionCell:cell atIndexPath:indexPath];
  	return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	BudgetDetailClassType *bdct = (BudgetDetailClassType *)[_dataSouceList objectAtIndex:indexPath.row];
	if(bdct.dct == DetailClassTypeTranction)
	{
        if (bdct.transaction.parTransaction != nil)
        {
            AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a part of a transaction split, and it can not be edited alone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
            appDelegate_iPhone.appAlertView = alertView;
            [alertView show];
            return;

        }
		TransactionEditViewController *editController =[[TransactionEditViewController alloc] initWithNibName:@"TransactionEditViewController" bundle:nil];
		editController.transaction = bdct.transaction;
        editController.typeoftodo = @"EDIT";
        
		if([bdct.transaction.category.categoryType isEqualToString:@"EXPENSE"])
		{
			editController.accounts = bdct.transaction.expenseAccount;

		}
		else if([bdct.transaction.category.categoryType isEqualToString:@"INCOME"])
		{
			editController.accounts = bdct.transaction.incomeAccount;

		}
        UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:editController];
        [self presentViewController:navigationViewController animated:YES completion:nil];

	}
	else  
	{
         TransferViewController_NS*transferView = [[TransferViewController_NS alloc] initWithNibName:@"TransferViewController_NS" bundle:nil];
		 transferView.budgetTransfer = bdct.budgetTransfer;
		 transferView.typeOftodo = @"EDIT";
        transferView.startDate = self.startDate;
        transferView.endDate = self.endDate;
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:transferView];
        [self.navigationController presentViewController:navi animated:YES completion:nil];

        

	}
    
    
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
 		PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
 
		BudgetDetailClassType *bdct = (BudgetDetailClassType *)[_dataSouceList objectAtIndex:indexPath.row];
        

        if(bdct.dct == DetailClassTypeTranction)
		{
 
             [appDelegate.epdc deleteTransactionRel:bdct.transaction];
		}
		else  
		{
            [appDelegate.epdc deleteTransferRel:bdct.budgetTransfer];

		 
		}
		
        [self.dataSouceList removeObjectAtIndex:indexPath.row];
		
//		if(dataSouceList.count >0)
//			[self.mytableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        
		[self getDataSouce];
        [self setControlStyle];
        [_mytableView reloadData];
        
		if([_dataSouceList count] == 0)
		{
			_noRecordView.hidden = NO;
		}
		else {
			_noRecordView.hidden = YES;
			
		}
		
	}   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	if(_mytableView.editing == FALSE)
	{
 		style = UITableViewCellEditingStyleDelete;
	}
	return style;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 53;
}


#pragma mark view life cycle



#pragma mark view release and dealloc

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload 
//{
//}



@end

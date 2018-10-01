//
//  NewGroupViewController.m
//
//  Created by BHI_James on 4/15/10.
//  Copyright 2010 BHI. All rights reserved.
//

#import "AccountTypeEditViewController.h"
#import "AccountType.h"
#import "ColorLabelView.h"
#import "PokcetExpenseAppDelegate.h"

#import "AppDelegate_iPhone.h"
#import "DropboxSyncTableDefine.h"

#import "EPNormalClass.h"
#import "AccountTypeViewController.h"
#import "AccountEditViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation AccountTypeEditViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initPoint];
    [self initNavStyle];
    [self initContex];
 	self.nameText.delegate = self;
 	[self.nameText becomeFirstResponder];
}



-(void)initPoint{
    _nameLabelText.text = NSLocalizedString(@"VC_Name", nil);
    _iconLabelText.text = NSLocalizedString(@"VC_Icon", nil);
    
    _iconNameArray =  [NSMutableArray arrayWithObjects:
                       @"asset.png",@"cash.png",
                       @"checking.png",@"credit-card.png",@"Debt.png",@"investing.png",@"loan.png",@"Saving.png",@"icon_other.png",
                       nil];
    
    self.nameLineHigh.constant = EXPENSE_SCALE;
    self.iconLineHigh.constant = EXPENSE_SCALE;

}
-(void)initNavStyle{
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    
    
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -2.f;
    
    if ([self.editModule isEqualToString:@"EDIT"])
	{
		self.navigationItem.title = NSLocalizedString(@"VC_EditType", nil);
		
 		self.navigationItem.rightBarButtonItem.enabled = TRUE;
        if( [_accountType.iconName isEqualToString: @"01.png"]||
           [_accountType.iconName isEqualToString: @"02.png"]||
           [_accountType.iconName isEqualToString: @"03.png"]||
           [_accountType.iconName isEqualToString: @"04.png"]||
           [_accountType.iconName isEqualToString: @"05.png"]||
           [_accountType.iconName isEqualToString: @"06.png"]
           )
        {
            self.iconView.image = [UIImage imageNamed:@"asset.png"];
            _selectIndex = 0;
            
        }
        else
        {
            self.iconView.image = [UIImage imageNamed:_accountType.iconName];
            _selectIndex = [_iconNameArray indexOfObject:_accountType.iconName];
        }
 	}
	else
	{

		self.navigationItem.title = NSLocalizedString(@"VC_NewType", nil);
		
 		self.navigationItem.rightBarButtonItem.enabled = FALSE;
 		self.iconView.image = [UIImage imageNamed:@"asset.png"];
		_selectIndex = 0;
        
		UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customerButton.frame = CGRectMake(0, 0,90,30);
        [customerButton setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
        [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        [customerButton setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        
        [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
		
		self.navigationItem.leftBarButtonItems = @[flexible2,leftButton];
        
	}
	self.nameText.text = _accountType.typeName;
  	
 	UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customerButton.frame = CGRectMake(0, 0, 90,30);
    [customerButton setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [customerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    customerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [customerButton.titleLabel setMinimumScaleFactor:0];
    [customerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    
    [customerButton setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [customerButton setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

	[customerButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	
	self.navigationItem.rightBarButtonItems = @[flexible2,rightButton];

}

-(void)initContex{
    
    NSInteger with = 50;
    NSInteger num = 6;
    NSInteger startPX = (SCREEN_WIDTH - with*num)*0.5;
	NSInteger startPY = 100.f;
	NSInteger line =0;
    NSInteger count =0;
    for (int i=0; i<[_iconNameArray count]; i++){
  		count = i- i/6*6;
		line =i/6;
	 	UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tmpBtn.frame =CGRectMake(startPX+count*50.f,startPY+ line *50.0, 50.0, 50.0);
		tmpBtn.tag =i;
		[tmpBtn setImage:[UIImage imageNamed:[_iconNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        tmpBtn.backgroundColor  = [UIColor clearColor];
 		[tmpBtn addTarget:self action:@selector(atvc_selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:tmpBtn];
 	}
    
}

-(CGSize )contentSizeForViewInPopover
{
	return CGSizeMake(320, 416);
}

- (void) cancel:(id)sender
{

	if([self.editModule isEqualToString:@"IPAD_ADD"]||[self.editModule isEqualToString:@"IPAD_EDIT"])
	{
		PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.AddSubPopoverController dismissPopoverAnimated:YES];
		
		return;	}
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

 }

- (void) save:(id)sender
{
    NSError *error =nil;
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
	
	NSMutableArray	*accountTypeList =	[[NSMutableArray alloc] initWithArray:objects];

    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    //检测目前正在编辑的accountType是不是被删除了，被删除了保存的时候就直接跳出当前这个页面
    if (self.accountType != nil)
    {
        BOOL hasFound = NO;
        for (int i=0; i<[accountTypeList count]; i++)
        {
            AccountType *oneAccountType = [accountTypeList objectAtIndex:i];
            if (oneAccountType == self.accountType)
            {
                hasFound = YES;
                break;
            }
        }
        if (!hasFound)
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
	if([_nameText.text length] == 0)
	{
 		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:[NSString stringWithFormat:NSLocalizedString(@"VC_Type name is needed.", nil)]
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
											  otherButtonTitles:nil];
		[alert show];
        appDelegate_iPhone.appAlertView = alert;
		return;
	}	
	
	for (AccountType *tmpType in accountTypeList)
	{
		if([tmpType.typeName isEqualToString:self.nameText.text])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"VC_The type was exist.", nil)
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
												  otherButtonTitles:nil];
			[alert show];
            appDelegate_iPhone.appAlertView = alert;
			return;
		}
	}
 
	if(_accountType == nil)
  	{		
		_accountType = [NSEntityDescription insertNewObjectForEntityForName:@"AccountType" inManagedObjectContext:appDelegate.managedObjectContext];
		_accountType.isDefault = [NSNumber numberWithBool:FALSE];
        _accountType.uuid = [EPNormalClass GetUUID];
	}
	_accountType.typeName = self.nameText.text;
	_accountType.iconName = [_iconNameArray objectAtIndex:_selectIndex];
    
    _accountType.dateTime = [NSDate date];
    _accountType.state = @"1";
    
   	if(![appDelegate.managedObjectContext save:&error])
	{
		NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
	}
	
 	//sync
//    if ([appDelegate.dropbox drop_account] != nil) {
//        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//        [appDelegate_iPhone.dropbox updateEveryAccountTypeDataFromLocal:self.accountType];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateAccountTypeFromLocal:self.accountType];
    }


	if([_editModule isEqualToString:@"EDIT"] )
		[[self navigationController] popViewControllerAnimated:YES];
	else
    {
        if (_iAccountTypeViewController != nil)
        {
            _iAccountTypeViewController.accEditView.accountType = _accountType;
            _iAccountTypeViewController.accEditView.typeLabel.text = _accountType.typeName;

        }
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];

    }

}

#pragma mark Btn Action
-(void)atvc_selectBtnAction:(UIButton *)sender{
    _selectIndex = sender.tag;
    _iconView.image = [UIImage imageNamed:[_iconNameArray objectAtIndex:sender.tag]];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_selectIndex = row;
  	self.iconView.image = [UIImage imageNamed:[_iconNameArray objectAtIndex:row]];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	
 
	return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
	{
		return _nameCell;
	}
	else
	{
		if(indexPath.row == 1)
		{
			return _iconCell;
		}
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.row == 0)
	{
		[self.nameText becomeFirstResponder];
	 }
	else
	{
		if(indexPath.row == 1)
		{
			[self.nameText resignFirstResponder];
	 	}
        [_mytableView reloadData];
	}
}	

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewDidUnload {
//}



@end

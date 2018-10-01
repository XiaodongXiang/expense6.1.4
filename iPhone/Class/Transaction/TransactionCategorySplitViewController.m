//
//  TransactionCategorySplitViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-9.
//
//

#import "TransactionCategorySplitViewController.h"
#import "TransactionCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"

#import "CategorySplitCell.h"
#import "CategorySelect.h"
#import "BudgetViewController.h"
#import "BudgetCountClass.h"

#import "BudgetListViewController.h"
#import "BudgetIntroduceViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface TransactionCategorySplitViewController ()

@end

@implementation TransactionCategorySplitViewController
@synthesize tcsvc_transactionEditViewController,tcsvc_TextField,tcsvc_tableView,categoryArray,budgetIntroduceViewController;
@synthesize budgetListViewController;
@synthesize selectedCategoryArray;
@synthesize selected_editCategory_fromBudgetListViewArray;
@synthesize nextBtn,nextBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStyle];
    [self initPoint];
    [self getDataSource];
    
    self.tcsvc_tableView.separatorColor = RGBColor(226, 226, 226);

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [tcsvc_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self back:nil];
}

-(void)refleshUI{
    NSLog(@"这个界面不reflesh");
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];


    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -12.f;

    
    if (self.budgetIntroduceViewController != nil)
    {
        nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [nextBtn setTitle:NSLocalizedString(@"VC_Next", nil) forState:UIControlStateNormal];
        [nextBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [nextBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        nextBar =[[UIBarButtonItem alloc] initWithCustomView:nextBtn];
        //需要设置nextbar才有用
        nextBar.enabled = NO;
        self.navigationItem.rightBarButtonItems = @[flexible2,nextBar];


    }
    else if (self.tcsvc_transactionEditViewController != nil)
    {
        UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [saveBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [saveBtn setTitle:NSLocalizedString(@"VC_Next", nil) forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        nextBar =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
        self.navigationItem.rightBarButtonItems = @[flexible2,nextBar];
;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel  setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"VC_SelectCategories", nil);

    self.navigationItem.titleView = 	titleLabel;
 
}

-(void)initPoint{
    selectedCategoryArray = [[NSMutableArray alloc]init];
    categoryArray =[[NSMutableArray alloc]init];
    selected_editCategory_fromBudgetListViewArray = [[NSMutableArray alloc]init];
}

-(void)getDataSource
{
    if (self.tcsvc_transactionEditViewController != nil) {
        [categoryArray setArray:self.tcsvc_transactionEditViewController.tranExpCategorySelectArray];
    }
    else{
        [selected_editCategory_fromBudgetListViewArray setArray:self.budgetListViewController.budgetEditArray];
        [self getAllExpenseParCategoryDatasourceAndSetCategoryArray];
    }
}

-(void)getAllExpenseParCategoryDatasourceAndSetCategoryArray{
    
    [categoryArray removeAllObjects];
    
    //获取所有category
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSDictionary *subs = [[NSDictionary alloc]init];
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchParentExpenseCategory" substitutionVariables:subs];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *tmpCategoryArray  = [[NSMutableArray alloc] initWithArray:objects];

    
    [categoryArray removeAllObjects];
    
    for (int i=0; i<[tmpCategoryArray count]; i++)
    {
        Category *oneCategory = [tmpCategoryArray objectAtIndex:i];
        CategorySelect *newCategorySelecte =  [[CategorySelect alloc]init];

        CategorySelect *foundOneCategorySelect = nil;
        for (int k=0; k<[selected_editCategory_fromBudgetListViewArray count]; k++)
        {
            CategorySelect *secondCategorySelect = [selected_editCategory_fromBudgetListViewArray objectAtIndex:k];
            if (oneCategory == secondCategorySelect.category)
            {
                foundOneCategorySelect = secondCategorySelect;
                break;
            }
        }
        
        newCategorySelecte.category = oneCategory;
        if (foundOneCategorySelect != nil)
        {
            newCategorySelecte.isSelect = YES;
            newCategorySelecte.amount = foundOneCategorySelect.amount;
        }
        else
        {
            newCategorySelecte.isSelect = NO;
            newCategorySelecte.amount = 0;
        }
        [categoryArray addObject:newCategorySelecte];
    }

    
    [tcsvc_tableView reloadData];
}
#pragma mark Btn Action
-(void)back:(id)sender{
    if (self.tcsvc_transactionEditViewController != nil)
    {
        return;
    }
    else if (self.budgetIntroduceViewController !=nil)
    {
        return;
    }
    else if (self.budgetListViewController != nil)
    {
        NSMutableArray *splitCategoryArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[categoryArray count]; i++) {
            CategorySelect *tmpCategory = [categoryArray objectAtIndex:i];
            if (tmpCategory.isSelect) {
                [splitCategoryArray addObject:tmpCategory];
            }
        }
        
        //转到list页面
        [self.budgetListViewController.budgetEditArray setArray:splitCategoryArray];
        return;
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


//save 只有在编辑transaction的时候 才会发生
-(void)save:(id)sender{
    [tcsvc_TextField resignFirstResponder];
    
    //编辑transaction的时候
    if (self.tcsvc_transactionEditViewController != nil) {
        for (int i=0; i<[categoryArray count]; i++) {
            CategorySelect *tmpCategory = [categoryArray objectAtIndex:i];
            if (tmpCategory.isSelect && tmpCategory.amount<=0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.appAlertView = alertView;
                return;
                
            }
        }
        
        //1.修改 transactionEditViewController中的tranExpCategorySelectArray
        [tcsvc_transactionEditViewController.tranExpCategorySelectArray removeAllObjects];
        [tcsvc_transactionEditViewController.tranExpCategorySelectArray setArray:categoryArray];
        
        //2.修改 transactionEditViewController中的tranCategorySelectedArray
        NSMutableArray *splitCategoryArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[categoryArray count]; i++) {
            CategorySelect *tmpCategory = [categoryArray objectAtIndex:i];
            if (tmpCategory.isSelect && tmpCategory.amount>0) {
                [splitCategoryArray addObject:tmpCategory];
            }
        }
        [tcsvc_transactionEditViewController.tranCategorySelectedArray removeAllObjects];
        [tcsvc_transactionEditViewController.tranCategorySelectedArray setArray:splitCategoryArray];
        
        [self.navigationController popToViewController:self.tcsvc_transactionEditViewController animated:YES];


    }
    //由introduce界面进来，选择category然后转到list界面
    else if(self.budgetIntroduceViewController != nil) {
        [selectedCategoryArray removeAllObjects];
        for (int i=0; i<[categoryArray count]; i++) {
            CategorySelect *tmpCategory = [categoryArray objectAtIndex:i];
            if (tmpCategory.isSelect) {
                [selectedCategoryArray addObject:tmpCategory];
            }
        }
        
        //转到list页面
        self.budgetListViewController = [[BudgetListViewController alloc]initWithNibName:@"BudgetListViewController" bundle:nil];
        budgetListViewController.transactionCategorySplitViewController = self;
        budgetListViewController.transactionSpliteViewToBudgetListView = YES;
        [self.navigationController pushViewController:budgetListViewController animated:YES];
    }
}

-(void)saveBudgetTemplate{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *errors;
    
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSMutableArray *selectCategoryArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[categoryArray count]; i++) {
        CategorySelect *oneCategorySelect = [categoryArray objectAtIndex:i];
        if (oneCategorySelect.isSelect) {
            [selectCategoryArray addObject:oneCategorySelect];
        }
    }
    
    for (int i=0; i<[selectCategoryArray count]; i++) {
        CategorySelect *categoruSelect = (CategorySelect *)[selectCategoryArray objectAtIndex:i];
        if(categoruSelect.amount >0)
        {
            //创建新的budgetTemplate
            BudgetTemplate  *budgetTemplate= [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTemplate" inManagedObjectContext:appDelegate.managedObjectContext];
            budgetTemplate.cycleType =@"No Cycle";
            budgetTemplate.startDate = [NSDate date];
            
            budgetTemplate.isRollover =[NSNumber numberWithBool:FALSE];
            budgetTemplate.category =  categoruSelect.category;
            budgetTemplate.amount = [NSNumber numberWithDouble:categoruSelect.amount];
            budgetTemplate.isNew = [NSNumber numberWithBool:YES];
            
            //category sync
//            categoruSelect.category.dateTime = [NSDate date];
//            if (![appDelegate.managedObjectContext save:&errors]) {
//                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
//                
//            }            if (appDelegate_iPhone.dropbox.drop_account.linked){
//                [appDelegate_iPhone.dropbox updateEveryCategoryDataFromLocal:categoruSelect.category];
//            }
            
            NSDate *startDate =[appDelegate.epnc getFirstSecByDate:budgetTemplate.startDate];
			
			NSDate *tmpDate =[appDelegate.epnc getDate: startDate byCycleType:budgetTemplate.cycleType];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            [dc1 setDay:-1];
            
            NSDate *endDate =[appDelegate.epnc getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate options:0]];
            budgetTemplate.dateTime = [NSDate date];
            budgetTemplate.state = @"1";
            budgetTemplate.uuid = [EPNormalClass GetUUID];
            if (![appDelegate.managedObjectContext save:&errors]) {
                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                
            }
            //sync
//            if (appDelegate_iPhone.dropbox.drop_account.linked) {
//                [appDelegate_iPhone.dropbox  updateEveryBudgetTemplateDataFromLocal:budgetTemplate];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBudgetFromLocal:budgetTemplate];
            }
            [appDelegate.epdc insertBudgetItem:budgetTemplate withStartDate:startDate EndDate:endDate];
        }
    }
    

}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 	NSInteger count=0;
    if(self.tcsvc_transactionEditViewController !=nil&&[self.tcsvc_transactionEditViewController.tranExpCategorySelectArray count]>0)
    {
        count =[categoryArray count];
        
    }
    else{
        count = [categoryArray count];
    }
   
 	return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    PokcetExpenseAppDelegate *appDeleagte = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
	static NSString *tCellIdentifier = @"budgetSelectCategory";
    CategorySplitCell *cell = (CategorySplitCell *)[tableView dequeueReusableCellWithIdentifier:tCellIdentifier];

    
    if(cell == nil)
    {
        cell = [[CategorySplitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    
    cell.amountTextField.delegate = self;
    
    cell.amountTextField.tag = indexPath.row;
    
    if (self.tcsvc_transactionEditViewController != nil)
    {
        CategorySelect *categoruSelect=nil;
        if([categoryArray count]>0)
        {
            categoruSelect  = (CategorySelect *)[categoryArray objectAtIndex:indexPath.row];
        }
        
        cell.categoryIconImage.image = [UIImage imageNamed:categoruSelect.category.iconName];
        cell.categoryNameLabel.text  = categoruSelect.category.categoryName;
        
        if(categoruSelect.isSelect)
        {
            cell.amountTextField.text = [appDeleagte.epnc formatterString:categoruSelect.amount];
            cell.amountTextField.hidden = NO;
            [cell.categoryNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [cell.amountTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];


        }
        else {
            cell.amountTextField.text = @"";
            cell.amountTextField.hidden = YES;
            [cell.categoryNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [cell.amountTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];

        }

    }
    //是budget的时候
    else{
        CategorySelect *categoruSelect=nil;
        if([categoryArray count]>0)
        {
            categoruSelect  = (CategorySelect *)[categoryArray objectAtIndex:indexPath.row];
        }
        
        cell.categoryIconImage.image = [UIImage imageNamed:categoruSelect.category.iconName];
        cell.categoryNameLabel.text  = categoruSelect.category.categoryName;
        cell.amountTextField.hidden = YES;
        
        if (categoruSelect.isSelect)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    if (indexPath.row== [categoryArray count]-1)
    {
        cell.line.frame = CGRectMake(0, cell.line.frame.origin.y, cell.line.frame.size.width, cell.line.frame.size.height);
    }
    else
    {
        if (indexPath.row==0) {
            cell.line.frame = CGRectMake(46, cell.line.frame.origin.y, SCREEN_WIDTH, cell.line.frame.size.height);
        }
        else
        {
            cell.line.frame = CGRectMake(46, cell.line.frame.origin.y, SCREEN_WIDTH, cell.line.frame.size.height);
        }

        

    }
    
    if (indexPath.row == [categoryArray count]-1 && [categoryArray count]==1)
    {

        cell.line.frame = CGRectMake(0, cell.line.frame.origin.y, cell.line.frame.size.width, cell.line.frame.size.height);
    }
    cell.tintColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	
	return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.budgetIntroduceViewController != nil || self.budgetListViewController != nil )
    {
        return 50;
    }
    else{
        return 0.1;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (self.budgetListViewController != nil || self.budgetIntroduceViewController != nil) {
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 35)];
        textLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        textLabel.text = NSLocalizedString(@"VC_SELECTCATEGORIESFORMONITOR", nil);
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        textLabel.adjustsFontSizeToFitWidth = YES;
        [textLabel setMinimumScaleFactor:0];
        [headview addSubview:textLabel];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 50-EXPENSE_SCALE, SCREEN_WIDTH, EXPENSE_SCALE)];
        line.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [headview addSubview:line];
        
        
        return headview;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    CategorySelect *categoruSelect=nil ;
    
    //获取 TransactionEdit中的tranExpCategorySelectArray中，哪个category被选中了
    if([categoryArray count]>0)
    {
        categoruSelect = (CategorySelect *)[categoryArray objectAtIndex:indexPath.row];
        
    }
    
    //标记被选中的cell(也就是category)哪些被选中了
    CategorySplitCell *selectCell = (CategorySplitCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(categoruSelect.isSelect)
    {
        categoruSelect.isSelect = NO;
        categoruSelect.amount = 0;
        
        if (self.tcsvc_transactionEditViewController != nil)
        {
            selectCell.amountTextField.text = [appDelegate_iPhone.epnc formatterString:0.00];
            selectCell.amountTextField.hidden =YES;
            
            //设置细体
            [selectCell.amountTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [selectCell.categoryNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        }
        else
        {
            selectCell.accessoryType = UITableViewCellAccessoryNone;

        }
    }
    else {
        categoruSelect.isSelect = YES;
        categoruSelect.amount = 0;
        
        if (self.tcsvc_transactionEditViewController != nil)
        {
            [selectCell.amountTextField setTextColor:[UIColor blackColor]];
            selectCell.amountTextField.text = [appDelegate_iPhone.epnc formatterString:categoruSelect.amount];
            
            //设置粗体字
            [selectCell.amountTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [selectCell.categoryNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            
            selectCell.amountTextField.hidden = NO;
        }
        else
            selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (self.budgetIntroduceViewController != nil) {
        NSMutableArray *splitCategoryArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[categoryArray count]; i++) {
            CategorySelect *tmpCategory = [categoryArray objectAtIndex:i];
            if (tmpCategory.isSelect) {
                [splitCategoryArray addObject:tmpCategory];
            }
        }
        if ([splitCategoryArray count]>0) {
            nextBar.enabled = YES;
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            nextBar.enabled= NO;
            [nextBtn setTitleColor:[appDelegate_iPhone.epnc getAmountGrayColor] forState:UIControlStateNormal];
        }
    }

    
    if (tcsvc_TextField != nil) {
        [tcsvc_TextField resignFirstResponder];
    }
    tcsvc_TextField = selectCell.amountTextField;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [tcsvc_TextField resignFirstResponder];
}
#pragma mark TextView Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tcsvc_TextField = textField;
    
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]<8) {
        hight = tcsvc_tableView.frame.size.height-textField.superview.superview.superview.frame.origin.y-textField.frame.size.height;
    }
    else
        hight =tcsvc_tableView.frame.size.height-textField.superview.superview.frame.origin.y-textField.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh = 216-hight+35;
        NSLog(@"keyBoardHigh:%f",keyBoardHigh);
        [tcsvc_tableView setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.tcsvc_transactionEditViewController != nil) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSString *tmpAmountString = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
        textField.text =[appDelegate.epnc formatterString:[textField.text doubleValue]];
        
        if ([categoryArray count]>0) {
            CategorySelect *categoruSelect = (CategorySelect *)[categoryArray objectAtIndex:textField.tag];
            categoruSelect.amount = [tmpAmountString doubleValue];
        }
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(textField == tcsvc_TextField)
	{
        if (self.tcsvc_transactionEditViewController != nil) {
            NSString *valueStr;
            if([string length]>0)
            {
                if([tcsvc_TextField.text length]>12)
                    return NO;
                else
                {
                    NSArray *tmp = [string componentsSeparatedByString:@"."];
                    if([tmp count] >=2)
                    {
                        return NO;
                    }
                    string = [string stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@""];
                    if([string  isEqualToString: @""])
                        return NO;
                    valueStr = [NSString stringWithFormat:@"%.1f",[tcsvc_TextField.text doubleValue]*10];
                }
            }
            else
            {
                valueStr = [NSString stringWithFormat:@"%.3f",[tcsvc_TextField.text doubleValue]/10];
            }
            tcsvc_TextField.text = valueStr;
        }
		
	}
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

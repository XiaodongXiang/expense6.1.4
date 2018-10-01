//
//  BudgetListViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-4-2.
//
//

#import "BudgetListViewController.h"
#import "BudgetListTableViewCell.h"
#import "CategorySelect.h"
#import "AppDelegate_iPhone.h"
#import "BudgetCountClass.h"
#import "TransactionCategorySplitViewController.h"
#import "BudgetViewController.h"
#import "BudgetIntroduceViewController.h"

#import "BudgetItem.h"
#import "BudgetTemplate.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface BudgetListViewController ()

@end

@implementation BudgetListViewController

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
    
    [self initNavStype];
    [self initPoint];
    [self getDataSource];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_myTableView reloadData];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
}


-(void)initNavStype
{
    [self.navigationController.navigationBar doSetNavigationBar];
	self.navigationItem.title = NSLocalizedString(@"VC_BudgetList", nil);

    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;

    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/203.0 alpha:1] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn]];
}

-(void)initPoint
{
//    transactionSpliteViewToBudgetListView = NO;
    
    _budgetEditArray = [[NSMutableArray alloc]init];
    _budgetExistArray = [[NSMutableArray alloc]init];
    
    if ([_budgetExistArray count]>0) {
        addBudgetBtn.hidden = NO;
    }
    else
        addBudgetBtn.hidden = YES;
    
    [addBudgetBtn  addTarget:self action:@selector(selectCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)getDataSource{
    [self getBudgetExistArray];
    [self getBudgetEditArray];
}

//获取已经存在的budget
-(void)getBudgetExistArray
{
 	[_budgetExistArray removeAllObjects];
    
	NSError *error =nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取所有的budget template数组
    NSDictionary *subs1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"EMPTY", nil];
    NSFetchRequest *fetchRequest = [[appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchNewStyleBudget" substitutionVariables:subs1] copy];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *allBudgetArray  = [[NSMutableArray alloc] initWithArray:objects];

	
	BudgetCountClass *bcc;
    
	for (int i = 0; i<[allBudgetArray count];i++)
    {
        //budgetTemplate是表名：获取一个budget
		BudgetTemplate *budgetTemplate = [allBudgetArray objectAtIndex:i];
        //获取底下的budgetItems，这是什么
		NSMutableArray *tmpArrayItem  =[[NSMutableArray alloc] initWithArray:[budgetTemplate.budgetItems allObjects]];
		NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
		
		NSArray *sorts = [[NSArray alloc] initWithObjects:&sort count:1];
		
        //将budgetItem按照起始时间排序，统计每个budget模板在当前时间的最后余额
		[tmpArrayItem sortUsingDescriptors:sorts];

        
        if([tmpArrayItem count]>0)
        {
//            BudgetItem *budgetTemplateCurrentItem = nil;
            for (int i=0; i<[tmpArrayItem count];i++)
            {
                //如果budgetIterm在设定的时间范围内，就将budget的计数+1
                BudgetItem *tmpBi = [tmpArrayItem objectAtIndex:i];
                if([appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.startDate ]>=0&&[appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.endDate ]<=0)
                {
//                    budgetTemplateCurrentItem = tmpBi;
                    break;
                }
            }
            //重新创建一个 对象，用来存储 budget的信息
            bcc = [[BudgetCountClass alloc] init];
            bcc.bt = budgetTemplate;
            [_budgetExistArray addObject:bcc];
        }
        
	}
}

-(void)getBudgetEditArray
{
    if (self.transactionCategorySplitViewController != nil) {
        [_budgetEditArray setArray:self.transactionCategorySplitViewController.selectedCategoryArray];
    }
    else
    {
        [_budgetEditArray removeAllObjects];
        for (int i=0; i<[_budgetExistArray count]; i++) {
            BudgetCountClass *oneBudgetCount = [_budgetExistArray objectAtIndex:i];
            
            CategorySelect *newCategorySelec =  [[CategorySelect alloc]init];
            newCategorySelec.category = oneBudgetCount.bt.category;
            newCategorySelec.amount = [((BudgetItem *)[[oneBudgetCount.bt.budgetItems allObjects]lastObject]).amount doubleValue];
            [_budgetEditArray addObject:newCategorySelec];
        }
    }
}


#pragma mark Btn Action
-(void)back:(UIButton *)sender
{
    if (self.transactionCategorySplitViewController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_budgetSettingViewController != nil)
        [self.navigationController popViewControllerAnimated:YES];
}


-(void)save:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_ADJ"];
    
    [tcsvc_TextField resignFirstResponder];
    for (int i=0; i<[_budgetEditArray count]; i++) {
        CategorySelect *tmpCategory = [_budgetEditArray objectAtIndex:i];
        if (tmpCategory.amount<=0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            appDelegate.appAlertView = alertView;
            return;
        }
    }

    //对比以前的cateogy是不是有减少了
    for (int i=0; i<[_budgetExistArray count]; i++) {
        BudgetCountClass *oneBudgetCount = [_budgetExistArray objectAtIndex:i];
        BudgetTemplate *oneBudgetTemplate = oneBudgetCount.bt;
        BOOL hasFound = NO;
        for (int k=0 ; k<[_budgetEditArray count]; k++) {
            CategorySelect *secondCategorySelect = [_budgetEditArray objectAtIndex:k];
            Category *secondCategory = secondCategorySelect.category;
            
            if (oneBudgetTemplate.category == secondCategory) {
                hasFound = YES;
                break;
            }
        }
        if (!hasFound) {
            [appDelegate.epdc deleteBudgetRel:oneBudgetTemplate];
        }
    }
     [self saveBudgetTemplate];
    
    if (self.transactionCategorySplitViewController != nil && _transactionSpliteViewToBudgetListView) {
        self.transactionCategorySplitViewController.budgetIntroduceViewController.dismisswithnoAnimation = YES;
        [self.transactionCategorySplitViewController.budgetIntroduceViewController back:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}



-(void)saveBudgetTemplate{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *errors;
    
    
    for (int i=0; i<[_budgetEditArray count]; i++) {
        CategorySelect *categoruSelect = (CategorySelect *)[_budgetEditArray objectAtIndex:i];
        Category *oneCategory = categoruSelect.category;
        //如果这个category已经有budget了，就重新设置原先的budgetTemplate,budgetItem
        if (oneCategory.budgetTemplate != nil)
        {
            [appDelegate.epdc saveBudgetTemplateandtheBudgetItem:oneCategory.budgetTemplate withAmount:categoruSelect.amount];
        }
        else
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
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
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
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox  updateEveryBudgetTemplateDataFromLocal:budgetTemplate];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBudgetFromLocal:budgetTemplate];
            }
            [appDelegate.epdc insertBudgetItem:budgetTemplate withStartDate:startDate EndDate:endDate];
            
//            if (someThingifisNil != nil) {
////                
//            }
           
        }
    }
}

-(void)selectedCategoryBtnPressed:(UIButton *)sender
{
    self.transactionCategorySplitViewController = [[TransactionCategorySplitViewController alloc]initWithNibName:@"TransactionCategorySplitViewController" bundle:nil];
    _transactionCategorySplitViewController.budgetListViewController = self;
    [self.navigationController pushViewController:_transactionCategorySplitViewController animated:YES];
}

#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50.f;
    }
    else
        return 25.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *budgetNumberLabel = [[UILabel  alloc]initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH-30, 50)];
    budgetNumberLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
    [budgetNumberLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    budgetNumberLabel.adjustsFontSizeToFitWidth = YES;
    [budgetNumberLabel setMinimumScaleFactor:0];
    [headerView addSubview:budgetNumberLabel];
    budgetNumberLabel.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)[_budgetEditArray count],NSLocalizedString(@"VC_ITEMS", nil)];
    
    if (budgetNumberLabel == nil) {
        budgetAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, SCREEN_WIDTH-110-15, 50)];
        budgetAmountLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        budgetAmountLabel.textAlignment = NSTextAlignmentRight;
        [budgetAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:16]];
        [headerView addSubview:budgetAmountLabel];
    }
    
    double allBudgetAmount = 0.00;
    for (int i=0; i<[_budgetEditArray count]; i++) {
        CategorySelect *oneCategorySele = [_budgetEditArray objectAtIndex:i];
        allBudgetAmount += oneCategorySele.amount;
    }
    budgetAmountLabel.text = [appDelegate_iphone.epnc formatterString:allBudgetAmount];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!_transactionSpliteViewToBudgetListView) {
        UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        footView.backgroundColor = [UIColor clearColor];
        UIButton *selectedCategoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 40)];
        selectedCategoryBtn.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        selectedCategoryBtn.layer.cornerRadius=5;
        selectedCategoryBtn.layer.masksToBounds=YES;

        [selectedCategoryBtn setTitle:NSLocalizedString(@"VC_SelectCategory", nil) forState:UIControlStateNormal];
        [selectedCategoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectedCategoryBtn addTarget:self action:@selector(selectedCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:selectedCategoryBtn];
        return footView;

    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_budgetEditArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"budgetListCell";
    BudgetListTableViewCell *cell = (BudgetListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BudgetListTableViewCell" owner:nil options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textAmountText.delegate = self;
    cell.textAmountText.tag = indexPath.row;
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(BudgetListTableViewCell *)cell atIndexPath:(NSIndexPath *)path
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    CategorySelect *oneCateSelec = [_budgetEditArray objectAtIndex:path.row];
    Category *oneCate = oneCateSelec.category;
    cell.categoryIcon.image = [UIImage imageNamed:oneCate.iconName];
    cell.categoryLabel.text = oneCate.categoryName;
    cell.textAmountText.text = [appDelegate_iPhone.epnc formatterString:oneCateSelec.amount];
    
    if ([_budgetEditArray count]==1)
    {
        cell.line1.hidden = NO;
        cell.line2.hidden = NO;
        cell.line2X.constant = 0;
    }
    else
    {
        if (path.row==0)
        {
            cell.line1.hidden = NO;
            cell.line2.hidden = NO;
            cell.line2X.constant = 46;
        }
        else if (path.row == [_budgetEditArray count]-1)
        {
            cell.line1.hidden = YES;
            cell.line2.hidden = NO;
            cell.line2X.constant = 0;
        }
        else
        {
            cell.line1.hidden = YES;
            cell.line2.hidden = NO;
            cell.line2X.constant = 46;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetListTableViewCell *selectedCell = (BudgetListTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    [selectedCell.textAmountText becomeFirstResponder];
    tcsvc_TextField = selectedCell.textAmountText;
}

//删除东西的时候，直接在编辑的editarray 中删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tcsvc_TextField resignFirstResponder];
    PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    CategorySelect *oneCategorySele = (CategorySelect *)[_budgetEditArray objectAtIndex: indexPath.row];
    
    //将budget从编辑的这个数组中删除，如果存在以前的数据库中就要删除
    if (oneCategorySele.category.budgetTemplate != nil) {
        [appDelegete.epdc deleteBudgetRel:oneCategorySele.category.budgetTemplate] ;
    }
    else
        ;
    [_budgetEditArray removeObject:oneCategorySele];
    
//    [self getDataSource];
    [_myTableView reloadData];
        
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [tcsvc_TextField resignFirstResponder];
}

#pragma mark TextView Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    tcsvc_TextField = textField;
    
    tcsvc_TextField.text = @"";
    
    
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]<8) {
        hight = _myTableView.frame.size.height-textField.superview.superview.superview.frame.origin.y-textField.frame.size.height;
    }
    else
        hight =_myTableView.frame.size.height-textField.superview.superview.frame.origin.y-textField.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh = 216-hight+35;
        [_myTableView setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *tmpAmountString = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    textField.text =[appDelegate.epnc formatterString:[textField.text doubleValue]];
    
    if ([_budgetEditArray count]>0) {
        CategorySelect *categoruSelect = (CategorySelect *)[_budgetEditArray objectAtIndex:textField.tag];
        categoruSelect.amount = [tmpAmountString doubleValue];
    }
    
    [self calculateAmountTextLabel];
}


//这里金额没有接着更改而是重新写是因为没有去掉金额的符号
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(textField == tcsvc_TextField)
	{
        
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
    
    [self calculateAmountTextLabel];
	return YES;
}

-(void)calculateAmountTextLabel
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    double allBudgetAmount = 0.00;
    for (int i=0; i<[_budgetEditArray count]; i++) {
        CategorySelect *oneCategorySele = [_budgetEditArray objectAtIndex:i];
        allBudgetAmount += oneCategorySele.amount;
    }
    budgetAmountLabel.text = [appDelegate_iphone.epnc formatterString:allBudgetAmount];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

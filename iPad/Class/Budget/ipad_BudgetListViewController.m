//
//  ipad_BudgetListViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-21.
//
//

#import "ipad_BudgetListViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_TransacationSplitViewController.h"
#import "ipad_BudgetViewController.h"
#import "ipad_BudgetIntroduceViewController.h"

#import "BudgetCountClass.h"
#import "CategorySelect.h"

#import "ipad_BudgetListTableViewCell.h"
#import "AppDelegate_iPad.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@interface ipad_BudgetListViewController ()

@end

@implementation ipad_BudgetListViewController
@synthesize myTableView,addBudgetBtn,budgetExistArray,budgetEditArray;
@synthesize iTransactionCategorySplitViewController;
@synthesize tcsvc_TextField,budgetAmountLabel;
@synthesize transactionSpliteViewToBudgetListView;


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
    [myTableView reloadData];
    
}


-(void)initNavStype
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	titleLabel.text = NSLocalizedString(@"VC_BudgetList", nil);
	self.navigationItem.titleView = titleLabel;
    
    //设置偏移量
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -2.f;
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -6.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 90, 30);
	[backBtn1 setTitle:NSLocalizedString(@"VC_Cancel", nil) forState:UIControlStateNormal];
    [backBtn1.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    backBtn1.titleLabel.adjustsFontSizeToFitWidth = YES;
    [backBtn1.titleLabel setMinimumScaleFactor:0];
    [backBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn1 setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [backBtn1 setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [doneBtn.titleLabel setMinimumScaleFactor:0];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn]];
    
}

-(void)initPoint
{
    //    transactionSpliteViewToBudgetListView = NO;
    
    budgetEditArray = [[NSMutableArray alloc]init];
    budgetExistArray = [[NSMutableArray alloc]init];
    
    if ([budgetExistArray count]>0) {
        addBudgetBtn.hidden = NO;
    }
    else
        addBudgetBtn.hidden = YES;
    
    [addBudgetBtn  addTarget:self action:@selector(selectCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

//首先获取
-(void)getDataSource{
    [self getBudgetExistArray];
    [self getBudgetEditArray];
}

//获取BudgetTemplate表格下面state==1的budgetTemplate,然后获取这个budgetTemplate底下的budgetItem，该段时间内有budgetItem就新建一个budget数组
-(void)getBudgetExistArray
{
 	[budgetExistArray removeAllObjects];
    
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
//            for (int i=0; i<[tmpArrayItem count];i++)
//            {
//                //如果budgetIterm在设定的时间范围内，就将budget的计数+1
//                BudgetItem *tmpBi = [tmpArrayItem objectAtIndex:i];
//                if([appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.startDate ]>=0&&[appDelegate.epnc dateCompare:[NSDate date] withDate:tmpBi.endDate ]<=0)
//                {
//                    budgetTemplateCurrentItem = tmpBi;
//                    break;
//                }
//            }
            //重新创建一个 对象，用来存储 budget的信息
            bcc = [[BudgetCountClass alloc] init];
            bcc.bt = budgetTemplate;
            [budgetExistArray addObject:bcc];
        }

        
	}
    
}

-(void)getBudgetEditArray
{
    if (self.iTransactionCategorySplitViewController != nil) {
        [budgetEditArray setArray:self.iTransactionCategorySplitViewController.selectedCategoryArray];
    }
    else
    {
        [budgetEditArray removeAllObjects];
        for (int i=0; i<[budgetExistArray count]; i++) {
            BudgetCountClass *oneBudgetCount = [budgetExistArray objectAtIndex:i];
            
            CategorySelect *newCategorySelec =  [[CategorySelect alloc]init];
            newCategorySelec.category = oneBudgetCount.bt.category;
            newCategorySelec.amount = [((BudgetItem *)[[oneBudgetCount.bt.budgetItems allObjects]lastObject]).amount doubleValue];
            //增加一个判别条件，当删除已经存在的budget的时候，不保存是不会真正的删除的
//            newCategorySelec.isSelect = YES;
            [budgetEditArray addObject:newCategorySelec];
        }
    }
}


#pragma mark Btn Action
-(void)back:(UIButton *)sender
{
    if(_budgetSettingViewController != nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.iTransactionCategorySplitViewController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


-(void)save:(id)sender{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_ADJ"];
    
    [tcsvc_TextField resignFirstResponder];
    for (int i=0; i<[budgetEditArray count]; i++) {
        CategorySelect *tmpCategory = [budgetEditArray objectAtIndex:i];
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
    for (int i=0; i<[budgetExistArray count]; i++)
    {
        BudgetCountClass *oneBudgetCount = [budgetExistArray objectAtIndex:i];
        BudgetTemplate *oneBudgetTemplate = oneBudgetCount.bt;
        BOOL hasFound = NO;
        for (int k=0 ; k<[budgetEditArray count]; k++)
        {
            CategorySelect *secondCategorySelect = [budgetEditArray objectAtIndex:k];
            Category *secondCategory = secondCategorySelect.category;
            
            if (oneBudgetTemplate.category == secondCategory)
            {
                hasFound = YES;
                break;
            }
        }
        if (!hasFound)
        {
//            [appDelegate.epdc deleteBudgetRel:oneBudgetTemplate];
        }
    }
    
    [self saveBudgetTemplate];
    
    
    if (self.iTransactionCategorySplitViewController != nil && transactionSpliteViewToBudgetListView) {
        self.iTransactionCategorySplitViewController.iBudgetIntroduceViewController.dismisswithnoAnimation = YES;
        [self.iTransactionCategorySplitViewController.iBudgetIntroduceViewController back:nil];
    }
    else
    {
//        [appDelegate_iPad.mainViewController refleshData];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([self.xxdDelegate respondsToSelector:@selector(budgetSettingSave)]) {
        [self.xxdDelegate budgetSettingSave];
    }
}

-(void)saveBudgetTemplate{
    
    PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *errors;
    
    PokcetExpenseAppDelegate *appDelegate_iPhone =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    for (int i=0; i<[budgetEditArray count]; i++) {
        CategorySelect *categoruSelect = (CategorySelect *)[budgetEditArray objectAtIndex:i];
        Category *oneCategory = categoruSelect.category;
        //如果这个category已经有budget了，就重新设置budgettemplate，和budgetitem
        if (oneCategory.budgetTemplate != nil)
        {
            [appDelegate_iPhone.epdc saveBudgetTemplateandtheBudgetItem:oneCategory.budgetTemplate withAmount:categoruSelect.amount];
        }
        else
        {
            //创建新的budgetTemplate
            BudgetTemplate  *budgetTemplate= [NSEntityDescription insertNewObjectForEntityForName:@"BudgetTemplate" inManagedObjectContext:appDelegate.managedObjectContext];
            budgetTemplate.cycleType =@"No Cycle";
            budgetTemplate.startDate = [NSDate date];
            
            budgetTemplate.isRollover =[NSNumber numberWithBool:NO];
            budgetTemplate.category =  categoruSelect.category;
            budgetTemplate.amount = [NSNumber numberWithDouble:categoruSelect.amount];
            budgetTemplate.isNew = [NSNumber numberWithBool:YES];
            
            //首先同步category
//            categoruSelect.category.dateTime = [NSDate date];
//            if (![appDelegate.managedObjectContext save:&errors]) {
//                NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
//                
//            }
//            if (appDelegate_iPhone.dropbox.drop_account.linked){
//                [appDelegate_iPhone.dropbox updateEveryCategoryDataFromLocal:categoruSelect.category];
//            }
            
            //然后同步budgetTemplate
            NSDate *startDate =[appDelegate.epnc getFirstSecByDate:budgetTemplate.startDate];
			
			NSDate *tmpDate =[appDelegate.epnc getDate: startDate byCycleType:budgetTemplate.cycleType];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents* dc1 = [[NSDateComponents alloc] init];
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

-(void)selectedCategoryBtnPressed:(UIButton *)sender
{
    self.iTransactionCategorySplitViewController = [[ipad_TransacationSplitViewController alloc]initWithNibName:@"ipad_TransacationSplitViewController" bundle:nil];
    iTransactionCategorySplitViewController.iBudgetListViewController = self;
    [self.navigationController pushViewController:iTransactionCategorySplitViewController animated:YES];
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
    PokcetExpenseAppDelegate *appDelegate_iphone =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *budgetNumberLabel = [[UILabel  alloc]initWithFrame:CGRectMake(15, 7, 85, 50)];
    budgetNumberLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
    [budgetNumberLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    budgetNumberLabel.adjustsFontSizeToFitWidth = YES;
    [budgetNumberLabel setMinimumScaleFactor:0];
    [headerView addSubview:budgetNumberLabel];
    budgetNumberLabel.text = [NSString stringWithFormat:@"%ld %@",(unsigned long)[budgetEditArray count],NSLocalizedString(@"VC_ITEMS", nil)];
    
    if (budgetNumberLabel == nil) {
        budgetAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 195, 50)];
        budgetAmountLabel.textColor = [appDelegate_iphone.epnc getAmountGrayColor];
        budgetAmountLabel.textAlignment = NSTextAlignmentRight;
        [budgetAmountLabel setFont:[appDelegate_iphone.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:16]];
        [headerView addSubview:budgetAmountLabel];
    }
    
    double allBudgetAmount = 0.00;
    for (int i=0; i<[budgetEditArray count]; i++) {
        CategorySelect *oneCategorySele = [budgetEditArray objectAtIndex:i];
        allBudgetAmount += oneCategorySele.amount;
    }
    budgetAmountLabel.text = [appDelegate_iphone.epnc formatterString:allBudgetAmount];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!transactionSpliteViewToBudgetListView) {
        UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 60)];
        footView.backgroundColor = [UIColor clearColor];
        UIButton *selectedCategoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(175, 15, 190, 40)];
        selectedCategoryBtn.backgroundColor=[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1];
        selectedCategoryBtn.layer.cornerRadius=5;
        selectedCategoryBtn.layer.masksToBounds=YES;
        [selectedCategoryBtn setTitle:NSLocalizedString(@"VC_SelectCategory", nil) forState:UIControlStateNormal];
        [selectedCategoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectedCategoryBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        selectedCategoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [selectedCategoryBtn.titleLabel setMinimumScaleFactor:0];
        [selectedCategoryBtn addTarget:self action:@selector(selectedCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:selectedCategoryBtn];
        return footView;
        
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [budgetEditArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ipad_BudgetListTableViewCell *cell = (ipad_BudgetListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[ipad_BudgetListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textAmountText.delegate = self;
        
    }
    cell.textAmountText.tag = indexPath.row;
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(ipad_BudgetListTableViewCell *)cell atIndexPath:(NSIndexPath *)path
{
    PokcetExpenseAppDelegate *appDelegate_iPhone =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    CategorySelect *oneCateSelec = [budgetEditArray objectAtIndex:path.row];
    Category *oneCate = oneCateSelec.category;
    cell.categoryIcon.image = [UIImage imageNamed:oneCate.iconName];
    cell.categoryLabel.text = oneCate.categoryName;
    cell.textAmountText.text = [appDelegate_iPhone.epnc formatterString:oneCateSelec.amount];
    
    if ([budgetEditArray count]==1)
    {
        cell.bgImageView.image = [UIImage imageNamed:@"setting_cell_j4_480_45.png"];
    }
    else
    {
        if (path.row==0)
        {
            cell.bgImageView.image = [UIImage imageNamed:@"setting_cell_j1_480_44.png"];
        }
        else if (path.row == [budgetEditArray count]-1)
            cell.bgImageView.image = [UIImage imageNamed:@"setting_cell_j3_480_45.png"];
        else
            cell.bgImageView.image = [UIImage imageNamed:@"setting_cell_j2_480_44.png"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ipad_BudgetListTableViewCell *selectedCell = (ipad_BudgetListTableViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
    [selectedCell.textAmountText becomeFirstResponder];
    tcsvc_TextField = selectedCell.textAmountText;
}

//删除东西的时候，直接在编辑的editarray 中删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tcsvc_TextField resignFirstResponder];

    PokcetExpenseAppDelegate *appDelegete =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    CategorySelect *oneCategorySele = (CategorySelect *)[budgetEditArray objectAtIndex: indexPath.row];
    
    //将budget从编辑的这个数组中删除，如果存在以前的数据库中就要删除
    if (oneCategorySele.category.budgetTemplate != nil) {
        [appDelegete.epdc deleteBudgetRel:oneCategorySele.category.budgetTemplate] ;
    }
    else
        ;
    [budgetEditArray removeObject:oneCategorySele];
    
    
    //    [self getDataSource];
    [myTableView reloadData];
    
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
    
    //    //获取currency的简写
    //    NSString *typeOfDollar = appDelegate_iphone.settings.currency;
    //	NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    //	NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    //    tcsvc_TextField.text = [tcsvc_TextField.text substringFromIndex:[dollorStr length]];
    
    float hight ;
    //因为IOS6 和 IOS7 textfield存放的位置不一样
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] <8) {
        hight = myTableView.frame.size.height-textField.superview.superview.superview.frame.origin.y-textField.frame.size.height;
    }
    else
        hight =myTableView.frame.size.height-textField.superview.superview.frame.origin.y-textField.frame.size.height;
    
    if (hight < 216)
    {
        double keyBoardHigh = 216-hight+35;
//        NSLog(@"keyBoardHigh:%f",keyBoardHigh);
        [myTableView setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    PokcetExpenseAppDelegate *appDelegate =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *tmpAmountString = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    textField.text =[appDelegate.epnc formatterString:[textField.text doubleValue]];
    
    if ([budgetEditArray count]>0) {
        CategorySelect *categoruSelect = (CategorySelect *)[budgetEditArray objectAtIndex:textField.tag];
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
    PokcetExpenseAppDelegate *appDelegate_iphone =  (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    double allBudgetAmount = 0.00;
    for (int i=0; i<[budgetEditArray count]; i++) {
        CategorySelect *oneCategorySele = [budgetEditArray objectAtIndex:i];
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

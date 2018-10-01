//
//  ExportSelectedCategoryViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-17.
//
//

#import "ExportSelectedCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "Category.h"
#import "CategorySelect.h"
#import "CategoryCell.h"
#import "AppDelegate_iPhone.h"

#import "EmailViewController.h"
#import "RepTransactionFilterViewController.h"

@interface ExportSelectedCategoryViewController ()

@end

@implementation ExportSelectedCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Lift Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNarBarStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getCategoryArray];
    
    [_categoryTableView reloadData];
}

#pragma mark view did load method
-(void)initNarBarStyle
{
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255.f green:244.f/255.f blue:244.f/255.f alpha:1];
    [self.navigationController.navigationBar doSetNavigationBar];
    
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -12.f;

    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setTitleColor:[UIColor colorWithRed:99/255.0 green:207/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(setExportViewControllerCategoryArray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBar =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,doneBar];

    
	self.navigationItem.titleView = _expenseorIncomeView;
}

-(void)initPoint
{
    _lineH.constant = EXPENSE_SCALE;
    
    _selectAllLabelText.text = NSLocalizedString(@"VC_Select All", nil);
    [_expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [_incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    
    _expenseCategoryArray = [[NSMutableArray alloc]init];
    _incomeCategoryArray = [[NSMutableArray alloc]init];
    
    _expenseBtn.selected = YES;
    _incomeBtn.selected = NO;
    [_expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedAllBtn addTarget:self action:@selector(selectedAllBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getCategoryArray{
    [_expenseCategoryArray removeAllObjects];
    [_incomeCategoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString    *fetchExpense = @"fetchCategoryByExpenseType";
    NSString    *fetchIncome = @"fetchCategoryByIncomeType";
    
    NSError *error = nil;
    NSDictionary *subs =[[NSDictionary alloc]init];
    
    NSFetchRequest *fetchRequestExpense = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchExpense substitutionVariables:subs];
    NSFetchRequest *fetchRequestIncome = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchIncome substitutionVariables:subs];
    //以名字顺序排列好，顺序排列，所以 父类在其子类的前面
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequestExpense setSortDescriptors:sortDescriptors];
    [fetchRequestIncome setSortDescriptors:sortDescriptors];
    
    NSArray *objectsExpense = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestExpense error:&error];
    NSArray *objectsIncome = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestIncome error:&error];
    
    NSMutableArray *tmpCategoryArrayExpense  = [[NSMutableArray alloc] initWithArray:objectsExpense];
    NSMutableArray *tmpCategoryArrayIncome  = [[NSMutableArray alloc] initWithArray:objectsIncome];
    
    for (int i =0; i<[tmpCategoryArrayExpense count];i++)
    {
        Category *c = [tmpCategoryArrayExpense objectAtIndex:i];
        CategorySelect *cc = [[CategorySelect alloc] init];
        cc.category = c ;
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
                for (int j=0; j<[_expenseCategoryArray count]; j++)
                {
                    CategorySelect *tmpCC = [_expenseCategoryArray objectAtIndex:j];
                    
                    if(pc == tmpCC.category)
                    {
                        tmpCC.pcType = parentWithChild;
                        
                        isFound = TRUE;
                        break;
                    }
                }
                
                //如果没找到父类。那么就创建一个父类
                if(!isFound)
                {
                    CategorySelect *tmpCC = [[CategorySelect alloc] init];
                    tmpCC.category = pc ;
                    tmpCC.pcType = parentWithChild;
                    tmpCC.cateName = pc.categoryName;
                    [_expenseCategoryArray addObject:tmpCC];
                }
                
            }
            //将当前判断的category设为子类
            cc.pcType = childOnly;
            cc.cateName = [NSString stringWithFormat:@"-%@",[seprateSrray objectAtIndex:1]];
            
        }
        else
        {
            cc.pcType = parentNoChild;
        }
        
        [_expenseCategoryArray addObject:cc];
    }
    
    
    for (int i =0; i<[tmpCategoryArrayIncome count];i++)
    {
        Category *c = [tmpCategoryArrayIncome objectAtIndex:i];
        CategorySelect *cc = [[CategorySelect alloc] init];
        cc.category = c ;
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
                for (int j=0; j<[_incomeCategoryArray count]; j++)
                {
                    CategorySelect *tmpCC = [_incomeCategoryArray objectAtIndex:j];
                    
                    if(pc == tmpCC.category)
                    {
                        tmpCC.pcType = parentWithChild;
                        
                        isFound = TRUE;
                        break;
                    }
                }
                
                //如果没找到父类。那么就创建一个父类
                if(!isFound)
                {
                    CategorySelect *tmpCC = [[CategorySelect alloc] init];
                    tmpCC.category = pc ;
                    tmpCC.pcType = parentWithChild;
                    tmpCC.cateName = pc.categoryName;
                    [_incomeCategoryArray addObject:tmpCC];
                }
                
            }
            //将当前判断的category设为子类
            cc.pcType = childOnly;
            cc.cateName = [NSString stringWithFormat:@"-%@",[seprateSrray objectAtIndex:1]];
            
        }
        else
        {
            cc.pcType = parentNoChild;
        }
        
        [_incomeCategoryArray addObject:cc];
    }
	
    //设置哪些category被选中了
    NSMutableArray *emailArray = [[NSMutableArray alloc]init];
    if (self.emailViewController != nil)
    {
        [emailArray setArray:self.emailViewController.categoryArray];
    }
    else if(self.transactionPDFViewController != nil)
        [emailArray setArray:self.transactionPDFViewController.tranCategorySelectArray];
    for (int i=0; i<[_expenseCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [_expenseCategoryArray objectAtIndex:i];
        oneCategorySele.isSelect = NO;
    }
    for (int i=0; i<[_incomeCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [_incomeCategoryArray objectAtIndex:i];
        oneCategorySele.isSelect = NO;
    }
    
    
    for (int i=0; i<[emailArray count]; i++) {
        Category *oneCategory = [emailArray objectAtIndex:i];
        NSUInteger index = [tmpCategoryArrayExpense indexOfObject:oneCategory];
        
        if (index<=[_expenseCategoryArray count]) {
            CategorySelect *oneCategorySelected = [_expenseCategoryArray objectAtIndex:index];
            oneCategorySelected.isSelect = YES;
        }
        else
        {
            NSUInteger indexIncome = [tmpCategoryArrayIncome indexOfObject:oneCategory];
            if (indexIncome < [_incomeCategoryArray count])
            {
                CategorySelect *oneCategorySelected = [_incomeCategoryArray objectAtIndex:indexIncome];
                oneCategorySelected.isSelect = YES;
            }
            
        }
    }
    [_categoryTableView reloadData];
    
    [self setContexShow];


}

-(void)setContexShow{
    _selectedItemCount = 0;
    BOOL isSelectedAll = YES;
    
    for (int i=0; i<[_expenseCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [_expenseCategoryArray objectAtIndex:i];
        if (oneCategorySele.isSelect) {
            _selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    for (int i=0; i<[_incomeCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [_incomeCategoryArray objectAtIndex:i];
        if (oneCategorySele.isSelect) {
            _selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    
    
    if (isSelectedAll) {
        _selectedAllBtn.selected = YES;
    }
    else
        _selectedAllBtn.selected = NO;
    
    _selecedCategoryAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)_selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];

    
}
#pragma mark Btn Action
-(void)back:(id)sender{
//    [self setExportViewControllerCategoryArray];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setExportViewControllerCategoryArray{
    
    //先判断有没有选中category，然后才能把前面页面的array删除
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *selectedArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[_expenseCategoryArray count]; i++) {
        CategorySelect *oneCategory = [_expenseCategoryArray objectAtIndex:i];
        if (oneCategory.isSelect) {
            [selectedArray addObject:oneCategory.category];
        }
    }
    for (int i=0; i<[_incomeCategoryArray count]; i++) {
        CategorySelect *oneCategory = [_incomeCategoryArray objectAtIndex:i];
        if (oneCategory.isSelect) {
            [selectedArray addObject:oneCategory.category];
        }
    }
    
    if ([selectedArray count]==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Please select at least one category.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
        [alertView show];
        appDelegate_iPhone.appAlertView = alertView;
        return;
    }
    
    
    if (self.emailViewController != nil)
    {
        [self.emailViewController.categoryArray removeAllObjects];
        
    }
    else if(self.transactionPDFViewController != nil)
        [self.transactionPDFViewController.tranCategorySelectArray removeAllObjects];
    
    
    if (self.emailViewController != nil)
    {
        [self.emailViewController.categoryArray setArray:selectedArray];
    }
    else if(self.transactionPDFViewController != nil)
        [self.transactionPDFViewController.tranCategorySelectArray setArray:selectedArray];
    
    if (self.emailViewController != nil)
    {
        if(_selectedItemCount < ([_expenseCategoryArray count]+[_incomeCategoryArray count]))
            self.emailViewController.lblCategory.text = NSLocalizedString(@"VC_Mutiple Categories", nil);
        else
            self.emailViewController.lblCategory.text = NSLocalizedString(@"VC_All", nil);
    }
    else if (self.transactionPDFViewController != nil)
    {
        if(_selectedItemCount < ([_expenseCategoryArray count]+[_incomeCategoryArray count]))
            self.transactionPDFViewController.lblCategory.text = NSLocalizedString(@"VC_Mutiple Categories", nil);
        else
            self.transactionPDFViewController.lblCategory.text = NSLocalizedString(@"VC_All", nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)expenseBtnPressed:(id)sender{
    _incomeBtn.selected = NO;
    _expenseBtn.selected = YES;
    
    [_categoryTableView reloadData];
}

-(void)incomeBtnPressed:(id)sender{
    _incomeBtn.selected = YES;
    _expenseBtn.selected = NO;
    
    [_categoryTableView reloadData];
}

-(void)selectedAllBtnPressed:(id)sender{
    if (!_selectedAllBtn.selected) {
        for (int i=0; i<[_expenseCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [_expenseCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = YES;
        }
        for (int i=0; i<[_incomeCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [_incomeCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = YES;
        }
        _selectedItemCount = [_expenseCategoryArray count] + [_incomeCategoryArray count];
    }
    else if (_selectedAllBtn.selected){
        for (int i=0; i<[_expenseCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [_expenseCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = NO;
        }
        for (int i=0; i<[_incomeCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [_incomeCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = NO;
        }
        _selectedItemCount = 0;
    }
    [_categoryTableView reloadData];
    _selectedAllBtn.selected = !_selectedAllBtn.selected;
}
#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_expenseBtn.selected)
    {
        return [_expenseCategoryArray count];
    }
    else
        return [_incomeCategoryArray count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"CategoryCell";
	
 	CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	
	if (cell == nil)
	{
		cell = [[[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:nil options:nil]lastObject];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
	}
    
    CategorySelect *cc ;
    if (_expenseBtn.selected)
    {
        cc = (CategorySelect *)[_expenseCategoryArray objectAtIndex:indexPath.row];
    }
    else
        cc = (CategorySelect *)[_incomeCategoryArray objectAtIndex:indexPath.row];
    Category *categories = cc.category;
	
	if(cc.pcType == childOnly)
	{
        cell.iconX.constant = 49;
        cell.nameX.constant = 83;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
        cell.nameLabel.text = cc.cateName;

        //不管是不是系统的,都只显示选中以及未选中
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
		
        
        //给选中的cell做标记
        if (cc.isSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        if (_expenseBtn.selected && (indexPath.row == [_expenseCategoryArray count]-1))
            cell.lineX.constant = 0;
        else if (_incomeBtn.selected && (indexPath.row == [_incomeCategoryArray count]-1))
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 103;
	}
    else
    {
        cell.iconX.constant = 10;
        cell.nameX.constant = 46;
        cell.nameLabel.text = categories.categoryName;
        cell.headImageView.image = [UIImage imageNamed:categories.iconName];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        

        
        
        //给选中的category做标记
        if (cc.isSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (_expenseBtn.selected && (indexPath.row == [_expenseCategoryArray count]-1))
            cell.lineX.constant = 0;
        else if (_incomeBtn.selected && (indexPath.row == [_incomeCategoryArray count]-1))
            cell.lineX.constant = 0;
        else
            cell.lineX.constant = 59;

    }

    
	return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//标记被选中的cell(也就是category)哪些被选中了
    CategorySelect *selectCategory;
    if (_expenseBtn.selected)
    {
        selectCategory= [_expenseCategoryArray objectAtIndex:indexPath.row];
    }
    else
        selectCategory= [_incomeCategoryArray objectAtIndex:indexPath.row];
    
    CategoryCell *selectedCell = (CategoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(selectCategory.isSelect)
    {
        selectCategory.isSelect = NO;
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        _selectedItemCount --;
    }
    else {
        selectCategory.isSelect = YES;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedItemCount ++;
    }
    _selecedCategoryAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)_selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
    if (_selectedItemCount == ([_expenseCategoryArray count]+[_incomeCategoryArray count])) {
        _selectedAllBtn.selected = YES;
    }
    else
        _selectedAllBtn.selected = NO;
    
    [tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

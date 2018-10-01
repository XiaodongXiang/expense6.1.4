//
//  ipad_ExportSelectedCategoryViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import "ipad_ExportSelectedCategoryViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_EmailViewController.h"
#import "ipad_RepTransactionFilterViewController.h"

#import "CategorySelect.h"

#import "ipad_CategoryCell.h"

@interface ipad_ExportSelectedCategoryViewController ()

@end

@implementation ipad_ExportSelectedCategoryViewController
@synthesize categoryTableView,selecedCategoryAmountLabel,selectedAllBtn,expenseorIncomeView,expenseBtn,incomeBtn,expenseCategoryArray,incomeCategoryArray,selectedItemCount;
@synthesize iEmailViewController,iTransactionPDFViewController;
@synthesize selectAllLabelText;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getCategoryArray];
}

#pragma mark view did load method
-(void)initNarBarStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn1.frame = CGRectMake(0, 0, 30, 30);
	[backBtn1 setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn1];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(setExportViewControllerCategoryArray) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBar =[[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,doneBar];

    
	self.navigationItem.titleView = expenseorIncomeView;
}

-(void)initPoint{
    
    selectAllLabelText.text = NSLocalizedString(@"VC_Select All", nil);
    [expenseBtn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
    [incomeBtn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
    expenseCategoryArray = [[NSMutableArray alloc]init];
    incomeCategoryArray = [[NSMutableArray alloc]init];
    
    expenseBtn.selected = YES;
    incomeBtn.selected = NO;
    [expenseBtn addTarget:self action:@selector(expenseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [incomeBtn addTarget:self action:@selector(incomeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectedAllBtn addTarget:self action:@selector(selectedAllBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getCategoryArray{
    [expenseCategoryArray removeAllObjects];
    [incomeCategoryArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString    *fetchExpense = @"fetchCategoryByExpenseType";
    NSString    *fetchIncome = @"fetchCategoryByIncomeType";
    
    NSError *error = nil;
    NSDictionary *subs = [[NSDictionary alloc]init];
    
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
                for (int j=0; j<[expenseCategoryArray count]; j++)
                {
                    CategorySelect *tmpCC = [expenseCategoryArray objectAtIndex:j];
                    
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
                    [expenseCategoryArray addObject:tmpCC];
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
        
        [expenseCategoryArray addObject:cc];
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
                for (int j=0; j<[incomeCategoryArray count]; j++)
                {
                    CategorySelect *tmpCC = [incomeCategoryArray objectAtIndex:j];
                    
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
                    [incomeCategoryArray addObject:tmpCC];
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
        
        [incomeCategoryArray addObject:cc];
    }
    
    //设置哪些category被选中了
    NSMutableArray *emailArray = [[NSMutableArray alloc]init];
    if (self.iEmailViewController != nil)
    {
        [emailArray setArray:self.iEmailViewController.categoryArray];
    }
    else if(self.iTransactionPDFViewController != nil)
        [emailArray setArray:self.iTransactionPDFViewController.tranCategorySelectArray];
    for (int i=0; i<[expenseCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [expenseCategoryArray objectAtIndex:i];
        oneCategorySele.isSelect = NO;
    }
    for (int i=0; i<[incomeCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [incomeCategoryArray objectAtIndex:i];
        oneCategorySele.isSelect = NO;
    }
    
    
    for (int i=0; i<[emailArray count]; i++) {
        Category *oneCategory = [emailArray objectAtIndex:i];
        NSUInteger index = [tmpCategoryArrayExpense indexOfObject:oneCategory];
        
        if (index<=[expenseCategoryArray count]) {
            CategorySelect *oneCategorySelected = [expenseCategoryArray objectAtIndex:index];
            oneCategorySelected.isSelect = YES;
        }
        else
        {
            NSUInteger indexIncome = [tmpCategoryArrayIncome indexOfObject:oneCategory];
            if (indexIncome < [incomeCategoryArray count])
            {
                CategorySelect *oneCategorySelected = [incomeCategoryArray objectAtIndex:indexIncome];
                oneCategorySelected.isSelect = YES;
            }
            
        }
    }
    [categoryTableView reloadData];
    
    [self setContexShow];
    
}

-(void)setContexShow{
    selectedItemCount = 0;
    BOOL isSelectedAll = YES;
    
    for (int i=0; i<[expenseCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [expenseCategoryArray objectAtIndex:i];
        if (oneCategorySele.isSelect) {
            selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    for (int i=0; i<[incomeCategoryArray count]; i++) {
        CategorySelect *oneCategorySele = [incomeCategoryArray objectAtIndex:i];
        if (oneCategorySele.isSelect) {
            selectedItemCount ++;
        }
        else{
            isSelectedAll = NO;
        }
    }
    
    
    if (isSelectedAll) {
        selectedAllBtn.selected = YES;
    }
    else
        selectedAllBtn.selected = NO;
    
    selecedCategoryAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
}
#pragma mark Btn Action
-(void)back:(id)sender{
//    [self setExportViewControllerCategoryArray];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setExportViewControllerCategoryArray{
    
    //先判断有没有选中category，然后才能把前面页面的array删除
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *selectedArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[expenseCategoryArray count]; i++) {
        CategorySelect *oneCategory = [expenseCategoryArray objectAtIndex:i];
        if (oneCategory.isSelect) {
            [selectedArray addObject:oneCategory.category];
        }
    }
    for (int i=0; i<[incomeCategoryArray count]; i++) {
        CategorySelect *oneCategory = [incomeCategoryArray objectAtIndex:i];
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

    
    if (self.iEmailViewController != nil)
    {
        [self.iEmailViewController.categoryArray removeAllObjects];
        
    }
    else if(self.iTransactionPDFViewController != nil)
        [self.iTransactionPDFViewController.tranCategorySelectArray removeAllObjects];
    
    
    if (self.iEmailViewController != nil)
    {
        [self.iEmailViewController.categoryArray setArray:selectedArray];
    }
    else if(self.iTransactionPDFViewController != nil)
        [self.iTransactionPDFViewController.tranCategorySelectArray setArray:selectedArray];
    
    if (self.iEmailViewController != nil)
    {
        if(selectedItemCount < ([expenseCategoryArray count]+[incomeCategoryArray count]))
            self.iEmailViewController.lblCategory.text = NSLocalizedString(@"VC_Mutiple Categories", nil);
        else
            self.iEmailViewController.lblCategory.text = NSLocalizedString(@"VC_All", nil);
    }
    else if (self.iTransactionPDFViewController != nil)
    {
        if(selectedItemCount < ([expenseCategoryArray count]+[incomeCategoryArray count]))
            self.iTransactionPDFViewController.lblCategory.text = NSLocalizedString(@"VC_Mutiple Categories", nil);
        else
            self.iTransactionPDFViewController.lblCategory.text = NSLocalizedString(@"VC_All", nil);
    }
    [self.navigationController popViewControllerAnimated:YES];


}

-(void)expenseBtnPressed:(id)sender{
    incomeBtn.selected = NO;
    expenseBtn.selected = YES;
    
//    [self getCategoryArray];
    [categoryTableView reloadData];
}

-(void)incomeBtnPressed:(id)sender{
    incomeBtn.selected = YES;
    expenseBtn.selected = NO;
    
//    [self getCategoryArray];
    [categoryTableView reloadData];

}

-(void)selectedAllBtnPressed:(id)sender{
    if (!selectedAllBtn.selected) {
        for (int i=0; i<[expenseCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [expenseCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = YES;
        }
        for (int i=0; i<[incomeCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [incomeCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = YES;
        }
        selectedItemCount = [expenseCategoryArray count] + [incomeCategoryArray count];
    }
    else if (selectedAllBtn.selected){
        for (int i=0; i<[expenseCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [expenseCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = NO;
        }
        for (int i=0; i<[incomeCategoryArray count]; i++) {
            CategorySelect *oneCategorySele = [incomeCategoryArray objectAtIndex:i];
            oneCategorySele.isSelect = NO;
        }
        selectedItemCount = 0;
    }
    [categoryTableView reloadData];
    selectedAllBtn.selected = !selectedAllBtn.selected;
}
#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (expenseBtn.selected)
    {
        return [expenseCategoryArray count];
    }
    else
        return [incomeCategoryArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *CellIdentifierPar = @"CellPar";
	static NSString *CellIdentifierChild = @"CellChild";
	
 	ipad_CategoryCell *cellPar = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPar];
	ipad_CategoryCell *cellChild = (ipad_CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierChild];
	
	if (cellPar == nil)
	{
		cellPar = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPar];
		cellPar.selectionStyle = UITableViewCellSelectionStyleNone;
 		cellPar.bgImageView.frame = CGRectMake(0, 0, tableView.frame.size.width,44.0);
		cellPar.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory1_320_44.png"];
 		cellPar.subShadowImageView.hidden = YES;
        cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
	}
    
	if (cellChild == nil)
	{
		cellChild = [[ipad_CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierChild];
		cellChild.selectionStyle = UITableViewCellSelectionStyleNone;
 		cellChild.bgImageView.frame = CGRectMake(0, 0, tableView.frame.size.width,38);
		cellChild.bgImageView.image =[UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
  		cellChild.subShadowImageView.hidden = YES;
		cellChild.nameLabel.frame =CGRectMake(70.0, 0.0, 200.0, 38.0);
        cellPar.accessoryType = UITableViewCellAccessoryNone;
        cellChild.editingAccessoryType = UITableViewCellAccessoryNone;
        
	}
    
    CategorySelect *cc ;
    if (expenseBtn.selected)
    {
        cc = (CategorySelect *)[expenseCategoryArray objectAtIndex:indexPath.row];
    }
    else
        cc = (CategorySelect *)[incomeCategoryArray objectAtIndex:indexPath.row];
	Category *categories = cc.category;
	
	if(cc.pcType == childOnly)
	{
        cellChild.headImageView.frame = CGRectMake(49, 7, 28, 28);
        cellChild.nameLabel.frame = CGRectMake(83, 0, 150, 44);
        cellChild.headImageView.image = [UIImage imageNamed:categories.iconName];
        
		NSInteger tmpIndex =indexPath.row-1;
 		
        if (expenseBtn.selected)
        {
            if(tmpIndex>=0&&tmpIndex<[expenseCategoryArray count])
            {
                CategorySelect *tmpcc =[expenseCategoryArray objectAtIndex:tmpIndex];
                if(tmpcc.pcType == parentWithChild )
                {
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
        }
        else
        {
            if(tmpIndex>=0&&tmpIndex<[incomeCategoryArray count])
            {
                CategorySelect *tmpcc =[incomeCategoryArray objectAtIndex:tmpIndex];
                if(tmpcc.pcType == parentWithChild )
                {
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
        }
		
        
        
        
//		if(![categories.isSystemRecord boolValue])
//		{
//			cellChild.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//			cellChild.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//		}
//		else {
//			cellChild.accessoryType = UITableViewCellAccessoryNone;
//            cellChild.editingAccessoryType = UITableViewCellAccessoryNone;
//            
//		}
        cellChild.accessoryType = UITableViewCellAccessoryNone;
        cellChild.editingAccessoryType = UITableViewCellAccessoryNone;
		
        cellChild.nameLabel.text = cc.cateName;
        
        //给选中的cell做标记
        if (cc.isSelect) {
            cellChild.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        
        if (expenseBtn.selected && (indexPath.row == [expenseCategoryArray count]-1)) {
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        }
        else if (incomeBtn.selected && (indexPath.row == [incomeCategoryArray count]-1))
        {
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        }
        else{
            cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_caregory2_320_44.png"];
        }
		return cellChild;
	}
	
	cellPar.subShadowImageView.hidden = YES;
//	if(![categories.isSystemRecord boolValue])
//	{
//		cellPar.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//        cellPar.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//        
//	}
//	else {
//		cellPar.accessoryType = UITableViewCellAccessoryNone;
//        cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
//        
//	}
    cellPar.accessoryType = UITableViewCellAccessoryNone;
    cellPar.editingAccessoryType = UITableViewCellAccessoryNone;
	
	cellPar.nameLabel.text = categories.categoryName;
	cellPar.headImageView.image = [UIImage imageNamed:categories.iconName];
	
    
    //给选中的category做标记
    if (cc.isSelect) {
        cellPar.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (expenseBtn.selected && (indexPath.row == [expenseCategoryArray count]-1)) {
        cellPar.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
        cellChild.bgImageView.image = [UIImage imageNamed:@"ipad_cell_j2_320_44.png"];
    }
    else if (incomeBtn.selected && (indexPath.row == [incomeCategoryArray count]-1))
    {
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
	//标记被选中的cell(也就是category)哪些被选中了
    CategorySelect *selectCategory;
    if (expenseBtn.selected)
    {
        selectCategory= [expenseCategoryArray objectAtIndex:indexPath.row];
    }
    else
        selectCategory= [incomeCategoryArray objectAtIndex:indexPath.row];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(selectCategory.isSelect)
    {
        selectCategory.isSelect = NO;
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedItemCount --;
    }
    else {
        selectCategory.isSelect = YES;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedItemCount ++;
    }
    selecedCategoryAmountLabel.text = [NSString stringWithFormat:@"%ld %@",(long)selectedItemCount,NSLocalizedString(@"VC_Item(s)", nil)];
    if (selectedItemCount == ([expenseCategoryArray count]+[incomeCategoryArray count])) {
        selectedAllBtn.selected = YES;
    }
    else
        selectedAllBtn.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

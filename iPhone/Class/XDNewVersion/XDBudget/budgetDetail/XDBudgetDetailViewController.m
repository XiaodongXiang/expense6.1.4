//
//  XDBudgetDetailViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/22.
//

#import "XDBudgetDetailViewController.h"
#import "XDCustomTransactionTableViewCell.h"
#import "Transaction.h"
#import "Payee.h"
#import "Setting+CoreDataClass.h"
#import "BudgetTemplate.h"
#import "XDAddTransactionViewController.h"
#import "XDBudgetTransferViewController.h"
#import "Category.h"
#import "BudgetItem.h"
#import "BudgetTransfer.h"
#import "BudgetDetailClassType.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDBudgetDetailViewController ()<XDBudgetTransferViewDelegate,UIGestureRecognizerDelegate,XDAddTransactionViewDelegate>
{
    double _expenseAmout;
    double _allAmount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray * dataMuArray;
@property (weak, nonatomic) IBOutlet UILabel *residueAmountL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopLeading;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeading;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property(nonatomic, strong)UILabel* infoLabel;

@end

@implementation XDBudgetDetailViewController
@synthesize date,type;

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 33, SCREEN_WIDTH - 50, 22)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:12];
        _infoLabel.textColor = [UIColor whiteColor];
    }
    return _infoLabel;
}

-(void)setBudgetTemple:(BudgetTemplate *)budgetTemple{
    _budgetTemple = budgetTemple;
    
    _expenseAmout = 0;
    _allAmount = [budgetTemple.amount doubleValue];
    
    [self getBudgetDataSoure:date type:type];
    [self.tableView reloadData];
    
 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self drawLine];

//    self.allAmountL.text = [NSString stringWithFormat:@"%@",[XDDataManager moneyFormatter:_allAmount]];
//    self.expenseAmountL.text = [XDDataManager moneyFormatter:_expenseAmout];
    

    if (_allAmount-_expenseAmout>=0) {
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ left",[XDDataManager moneyFormatter:_allAmount-_expenseAmout]];
        self.residueAmountL.textColor = RGBColor(85, 85, 85);
    }else{
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ over",[XDDataManager moneyFormatter:fabs(_allAmount-_expenseAmout)]];
        self.residueAmountL.textColor = RGBColor(240, 106, 68);
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.height = SCREEN_HEIGHT - 134;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnClick) title:NSLocalizedString(@"VC_Transfer", nil) font:[UIFont fontWithName:FontSFUITextRegular size:17] titleColor:RGBColor(113, 163, 245) highlightedColor:RGBColor(113, 163, 245) titleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.title = _budgetTemple.category.categoryName;
    self.categoryLbl.text = _budgetTemple.category.categoryName;
    
    if (IS_IPHONE_X) {
        self.topViewLeading.constant = 88;
        self.tableTopLeading.constant = 158;
    }
    self.tableView.separatorColor = RGBColor(226 , 226 , 226);
    self.view.clipsToBounds = YES;
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)drawLine{
  
    CAShapeLayer* layer = [CAShapeLayer layer];
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 33, SCREEN_WIDTH - 30, 22) cornerRadius:11];
    layer.fillColor = RGBColor(215, 215, 215).CGColor;
    layer.path = path.CGPath;
    [self.topView.layer addSublayer:layer];
    
    float amount = [_budgetTemple.amount doubleValue];
    CGFloat width = 0;
    if (amount < 0) {
       width = SCREEN_WIDTH - 30;
    }else{
       width = _expenseAmout/amount * (SCREEN_WIDTH - 30);
    }
  
    if (width > SCREEN_WIDTH - 30) {
        width = SCREEN_WIDTH - 30;
    }
    
    CAShapeLayer* layer1 = [CAShapeLayer layer];
    UIBezierPath* path1 = [UIBezierPath bezierPathWithRect:CGRectMake(15, 33, width, 22)];
    if (_allAmount-_expenseAmout>=0){
        layer1.fillColor = RGBColor(113, 163, 245).CGColor;
    }else{
        layer1.fillColor = RGBColor(240, 106, 68).CGColor;
    }
    layer1.path = path1.CGPath;
    [self.topView.layer addSublayer:layer1];
    
    CAShapeLayer* layer3 = [CAShapeLayer layer];
    UIBezierPath* path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(26, 33)];
    [path3 addLineToPoint:CGPointMake(15, 33)];
    [path3 addLineToPoint:CGPointMake(15, 55)];
    [path3 addLineToPoint:CGPointMake(26, 55)];
    [path3 addArcWithCenter:CGPointMake(26, 44) radius:11 startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:YES];
    [path3 closePath];
    layer3.path = path3.CGPath;
    layer3.fillColor = [UIColor whiteColor].CGColor;
    [self.topView.layer addSublayer:layer3];

    CAShapeLayer* layer2 = [CAShapeLayer layer];
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(SCREEN_WIDTH-26, 33)];
    [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-15, 33)];
    [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-15, 55)];
    [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH-26, 55)];
    [path2 addArcWithCenter:CGPointMake(SCREEN_WIDTH-26, 44) radius:11 startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:NO];
    [path2 closePath];
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor whiteColor].CGColor;
    [self.topView.layer addSublayer:layer2];

    
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@ of %@",[XDDataManager moneyFormatter:_expenseAmout],[XDDataManager moneyFormatter:_allAmount]];
    [self.topView addSubview:self.infoLabel];
}

-(void)rightBtnClick{
    XDBudgetTransferViewController* vc = [[XDBudgetTransferViewController alloc]initWithNibName:@"XDBudgetTransferViewController" bundle:nil];
    vc.residurAmount = [_budgetTemple.amount doubleValue] - _expenseAmout;
    vc.budgetTemple = _budgetTemple;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - addtransaction delegate
-(void)addTransactionCompletion{
    
    _expenseAmout = 0;
    _allAmount = [_budgetTemple.amount doubleValue];
    
    [self getBudgetDataSoure:date type:type];
    [self.tableView reloadData];
    
//    self.allAmountL.text = [NSString stringWithFormat:@"%@",[XDDataManager moneyFormatter:_allAmount]];
//    self.expenseAmountL.text = [XDDataManager moneyFormatter:_expenseAmout];
    if (_allAmount-_expenseAmout>=0) {
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ left",[XDDataManager moneyFormatter:_allAmount-_expenseAmout]];
        self.residueAmountL.textColor = RGBColor(85, 85, 85);
        
    }else{
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ over",[XDDataManager moneyFormatter:fabs(_allAmount-_expenseAmout)]];
        self.residueAmountL.textColor = RGBColor(240, 106, 68);
        
    }
    [self drawLine];
}

#pragma mark - XDBudgetTransferViewDelegate
-(void)returnBudgetTransfer:(BudgetDetailClassType *)budgetClassType{
    if ([self.dataMuArray containsObject:budgetClassType]) {
        
        _expenseAmout = 0;
        _allAmount = [_budgetTemple.amount doubleValue];
        [self getBudgetDataSoure:date type:type];

        [self.tableView reloadData];
    }else{
        
        if (budgetClassType.dct == DetailClassTypeFromTransfer) {
            _allAmount -= [budgetClassType.budgetTransfer.amount doubleValue];
        }else if (budgetClassType.dct == DetailClassTypeToTransfer){
            _allAmount += [budgetClassType.budgetTransfer.amount doubleValue];
        }
        
        [self.dataMuArray addObject:budgetClassType];
        [self.tableView reloadData];
    }
    
//    self.allAmountL.text = [NSString stringWithFormat:@"%@",[XDDataManager moneyFormatter:_allAmount]];
//    self.expenseAmountL.text = [XDDataManager moneyFormatter:_expenseAmout];
    if (_allAmount-_expenseAmout>=0) {
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ left",[XDDataManager moneyFormatter:_allAmount-_expenseAmout]];
        self.residueAmountL.textColor = RGBColor(85, 85, 85);
        
    }else{
        self.residueAmountL.text = [NSString stringWithFormat:@"%@ over",[XDDataManager moneyFormatter:fabs(_allAmount-_expenseAmout)]];
        self.residueAmountL.textColor = RGBColor(240, 106, 68);
        
    }

}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDCustomTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCustomTransactionTableViewCell" owner:self options:nil]lastObject];
    }
    BudgetDetailClassType* type = self.dataMuArray[indexPath.row];
    if (type.dct == DetailClassTypeTranction) {
        Transaction* tran = type.transaction;
        cell.amountL.textColor =  RGBColor(240, 106, 68);
        cell.nameL.text = tran.payee.name?:@"-";
        cell.amountL.text = [XDDataManager moneyFormatter:[tran.amount doubleValue]];
        cell.dateL.text = [self returnInitDate:tran.dateTime];
    }else if(type.dct == DetailClassTypeFromTransfer){
        
        BudgetTransfer* transfer = type.budgetTransfer;
        cell.nameL.textColor = cell.amountL.textColor = [UIColor lightGrayColor];
        cell.nameL.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER To", nil),transfer.toBudget.budgetTemplate.category.categoryName];
        cell.amountL.text = [XDDataManager moneyFormatter:[transfer.amount doubleValue]];
        cell.dateL.text = [self returnInitDate:transfer.dateTime];
    }else{
        BudgetTransfer* transfer = type.budgetTransfer;
        cell.nameL.textColor = cell.amountL.textColor = [UIColor lightGrayColor];
        cell.nameL.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VC_XFER From", nil),transfer.fromBudget.budgetTemplate.category.categoryName];
        cell.amountL.text = [XDDataManager moneyFormatter:[transfer.amount doubleValue]];
        cell.dateL.text = [self returnInitDate:transfer.dateTime];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
     BudgetDetailClassType* type = self.dataMuArray[indexPath.row];
    if (type.dct == DetailClassTypeTranction) {
        addVc.editTransaction = type.transaction;
        addVc.delegate = self;
        [self presentViewController:addVc animated:YES completion:nil];

    }else{
        
        XDBudgetTransferViewController* vc = [[XDBudgetTransferViewController alloc]initWithNibName:@"XDBudgetTransferViewController" bundle:nil];
        vc.residurAmount = [_budgetTemple.amount doubleValue] - _expenseAmout + [type.budgetTransfer.amount doubleValue];
        vc.budgetTemple = _budgetTemple;
        vc.classType = type;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];

    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BudgetDetailClassType* type = self.dataMuArray[indexPath.row];
        if(type.dct == DetailClassTypeTranction)
        {
            [appDelegate.epdc deleteTransactionRel:type.transaction];
        }
        else
        {
            [appDelegate.epdc deleteTransferRel:type.budgetTransfer];
        }
        
        [self.dataMuArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTransfer" object:nil];
    
        [self addTransactionCompletion];
        [self drawLine];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - other


-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}

-(NSArray*)getCurrentDateBudget:(NSDate*)date type:(NSInteger)index array:(NSArray*)array{
    if (!date || array.count == 0) {
        return nil;
    }
    NSDate* startCurrentDate = [self getStartDateWithDateType:index fromDate:date];
    NSDate* endCurrentDate = [self getEndDateDateType:index withStartDate:startCurrentDate];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"dateTime >= %@ and dateTime <= %@",startCurrentDate,endCurrentDate];
    NSArray* arr = [array filteredArrayUsingPredicate:predicate];

    return arr;
}

-(void)getBudgetDataSoure:(NSDate*)date type:(NSInteger)index{
    
    if (!date) {
        return ;
    }
    NSDate* startCurrentDate = [self getStartDateWithDateType:index fromDate:date];
    NSDate* endCurrentDate = [self getEndDateDateType:index withStartDate:startCurrentDate];
    
    self.dataMuArray = [NSMutableArray array];
    
    NSError* error = nil;
    
    if (_budgetTemple.category) {
        NSDictionary *  subs = [NSDictionary dictionaryWithObjectsAndKeys:_budgetTemple.category,@"iCategory",startCurrentDate,@"startDate",endCurrentDate,@"endDate", nil];
        //获取该budgetTemplate下 该段时间内的transaction,统计
        NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSArray* array = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (Transaction* tran in array) {
            _expenseAmout += [tran.amount doubleValue];
            
            BudgetDetailClassType* class = [[BudgetDetailClassType alloc]init];
            class.transaction = tran;
            class.date = tran.dateTime;
            class.dct = DetailClassTypeTranction;
            
            [self.dataMuArray addObject:class];
        }
    }
    BudgetItem* item = [[_budgetTemple.budgetItems allObjects]lastObject];
    
    NSArray* fromTrans = [self getCurrentDateBudget:date type:index array:[item.fromTransfer allObjects]] ;
    for (BudgetTransfer * transfer in fromTrans) {
        
        _allAmount -= [transfer.amount doubleValue];
        
        BudgetDetailClassType* class = [[BudgetDetailClassType alloc]init];
        class.budgetTransfer = transfer;
        class.date = transfer.dateTime;
        class.dct = DetailClassTypeFromTransfer;
        
        [self.dataMuArray addObject:class];
    }
    
    NSArray* toTrans = [self getCurrentDateBudget:date type:index array:[item.toTransfer allObjects]];
   
    for (BudgetTransfer * transfer in toTrans) {
        _allAmount += [transfer.amount doubleValue];

        
        BudgetDetailClassType* class = [[BudgetDetailClassType alloc]init];
        class.budgetTransfer = transfer;
        class.date = transfer.dateTime;
        class.dct = DetailClassTypeToTransfer;
        
        [self.dataMuArray addObject:class];
    }
    
    ////////////////////获取子类category的交易
    
    NSString *searchForMe = @":";
    NSRange range = [_budgetTemple.category.categoryName rangeOfString : searchForMe];
    if (range.location == NSNotFound)
    {
        
        NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",_budgetTemple.category.categoryName];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",_budgetTemple.category.categoryType,@"CATEGORYTYPE",nil];
        NSFetchRequest *fetchChildCategory = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchChildCategory setSortDescriptors:sortDescriptors];
        NSArray *objects1 = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
        NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
        
        for(int j=0 ;j<[tmpChildCategoryArray count];j++)
        {
            Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
            if(tmpCate !=_budgetTemple.category)
            {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",startCurrentDate,@"startDate",endCurrentDate,@"endDate", nil];
                NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchRequest setSortDescriptors:sortDescriptors];
                NSArray *objects = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                
                for (Transaction* tran in tmpArray) {
                    if ([tran.state isEqualToString:@"1"]) {
                        
                        _expenseAmout += [tran.amount doubleValue];

                        BudgetDetailClassType* class = [[BudgetDetailClassType alloc]init];
                        class.transaction = tran;
                        class.date = tran.dateTime;
                        class.dct = DetailClassTypeTranction;
                        
                        [self.dataMuArray addObject:class];
                    }
                }
            }
        }
    }
}


- (NSDate *) getStartDateWithDateType:(NSInteger)dateType fromDate:(NSDate *)startDate//dateType 0-day 1-week 2-month 3-year
{
    NSString *start = @"Sunday";
    
    NSDate *nowTime;
    if (startDate == nil) {
        nowTime = [NSDate date];
    }
    else
        nowTime = startDate;
    
    int firstWeekDay = 1;
    Setting* setting = [[[XDDataManager shareManager]getObjectsFromTable:@"Setting"]lastObject];
    if ([setting.others16 isEqualToString:@"2"])
    {
        firstWeekDay = 2;
        start = @"Monday";
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setFirstWeekday:firstWeekDay];
    
    
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:nowTime];
    if(dateType==0)
    {
        [components setDay:0];
    }
    //获取改星期的起始时间
    else if(dateType == 1)
    {
        NSDateComponents *components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|NSWeekdayCalendarUnit ) fromDate:nowTime];
        
        components.day = components.day - components.weekday+firstWeekDay;
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        NSDate *startDate = [cal dateFromComponents:components];
        return startDate;
    }
    else if (dateType == 2)
    {
        NSDateFormatter *dayFormatter1 = [[NSDateFormatter alloc] init];
        [dayFormatter1 setDateFormat:@"dd"];
        int days = [[dayFormatter1 stringFromDate:nowTime] intValue];
        [components setDay:-days+1];
    }
    else
    {
        NSDateFormatter *monthFormatter1 = [[NSDateFormatter alloc] init];
        [monthFormatter1 setDateFormat:@"MM"];
        int months = [[monthFormatter1 stringFromDate:nowTime] intValue];
        NSDateFormatter *dayFormatter1 = [[NSDateFormatter alloc] init];
        [dayFormatter1 setDateFormat:@"dd"];
        int days = [[dayFormatter1 stringFromDate:nowTime] intValue];
        [components setMonth:-months+1];
        [components setDay:-days+1];
        
    }
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    return [cal dateByAddingComponents:components toDate:nowTime options:0];
}

- (NSDate *) getEndDateDateType:(NSInteger)dateType withStartDate:(NSDate *)startDate //dateType 0-day 1-week 2-month 3-year
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *component = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:startDate];
    if (dateType == 0)
    {
        [component setDay:0];
    }
    if(dateType==1)
    {
        [component setDay:6];
    }
    else if(dateType==2)
    {
        [component setMonth:1];
        [component setDay:-1];
    }
    else if(dateType==3)
    {
        [component setYear:1];
        [component setDay:-1];
    }
    [component setHour:23];
    [component setMinute:59];
    [component setSecond:59];
    return [cal dateByAddingComponents:component toDate:startDate options:0];
}

@end

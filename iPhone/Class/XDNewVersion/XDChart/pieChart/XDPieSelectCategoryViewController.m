//
//  XDPieSelectCategoryViewController.m
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/16.
//

#import "XDPieSelectCategoryViewController.h"
#import "XDChartDataClass.h"
#import "XDPieChartModel.h"
#import "Transaction.h"
#import "Payee.h"
#import "XDAddTransactionViewController.h"
#import "XDCustomTransactionTableViewCell.h"
#import "PokcetExpenseAppDelegate.h"
@interface XDPieSelectCategoryViewController ()<XDAddTransactionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray* dataArray;
@property(nonatomic, strong)NSMutableArray* amountMuArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading;
@property(nonatomic, assign)double allAmount;
@end

@implementation XDPieSelectCategoryViewController

@synthesize startDate,endDate,type,account;
-(void)setModel:(XDPieChartModel *)model{
    _model = model;
   
    [self initData];
}

-(void)initData{
    self.allAmount = 0;
    self.amountMuArr = [NSMutableArray array];
    NSMutableArray* muArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    if (type == DateSelectedCustom) {
        muArr = [NSMutableArray arrayWithArray:[XDChartDataClass pieCategoryWithDate:startDate endDate:endDate dateType:type category:_model.category account:account]];
    }else{
        muArr = [NSMutableArray arrayWithArray:[XDChartDataClass pieCategoryWithDate:startDate endDate:nil dateType:type category:_model.category account:account]];
    }
    NSArray* cateArr = [[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName CONTAINS[c] %@",_model.category.categoryName] sortDescriptors:nil];
    
    for (int i = 0; i < cateArr.count; i++) {
        Category* cate = cateArr[i];
        NSMutableArray* muArray = [NSMutableArray arrayWithArray:[muArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category = %@",cate]]];
        if (muArray.count > 0) {
            double singleAmount = 0;
            [self.dataArray addObject:muArray];
            for (Transaction* tran in muArray) {
                self.allAmount += [tran.amount doubleValue];
                singleAmount += [tran.amount doubleValue];
            }
            [self.amountMuArr addObject:@(singleAmount)];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (IS_IPHONE_X) {
        self.topLeading.constant = 88;
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.title = _model.category.categoryName;
    
    self.tableView.separatorColor = RGBColor(226 , 226 , 226);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor = RGBColor(246, 246, 246);
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH/3, 15)];
    label.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    label.textColor = RGBColor(154, 154, 154);
    Transaction* tran = [self.dataArray[section]firstObject];
    label.text = tran.category.categoryName;
    [view addSubview:label];
    
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, 15)];
    label1.centerX = SCREEN_WIDTH/2;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    label1.textColor = RGBColor(154, 154, 154);
    label1.text = [NSString stringWithFormat:@"%.2f%%",[self.amountMuArr[section] doubleValue]/self.allAmount*100];
    [view addSubview:label1];
    
    UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 - 15, 10, SCREEN_WIDTH/3, 15)];
    label2.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = RGBColor(154, 154, 154);
    label2.text = [NSString stringWithFormat:@"%@",[self formatterString:[self.amountMuArr[section] doubleValue]]];
    [view addSubview:label2];
    
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDCustomTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCustomTransactionTableViewCell" owner:self options:nil]lastObject];
    }
    Transaction* tran = self.dataArray[indexPath.section][indexPath.row];
    //    cell.imageView.image = [UIImage imageNamed:tran.category.iconName];
    cell.nameL.text = tran.payee.name?:@"-";
    cell.amountL.text = [XDDataManager moneyFormatter:[tran.amount doubleValue]];
    cell.dateL.text = [self returnInitDate:tran.dateTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Transaction* transition = self.dataArray[indexPath.section][indexPath.row];
        
        PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegete.epdc deleteTransactionRel:transition];
        
        [self initData];
        [self.tableView reloadData];

//        [self.dataArray[indexPath.section] removeObject:transition];
//
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView beginUpdates];
//        [self.tableView endUpdates];
////
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUI" object:nil];
        });
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
    addVc.editTransaction = self.dataArray[indexPath.section][indexPath.row];
    addVc.delegate = self;
    [self presentViewController:addVc animated:YES completion:nil];
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    return dateStr;
    
}

-(void)addTransactionCompletion{
    
    self.allAmount = 0;
    self.amountMuArr = [NSMutableArray array];
    NSMutableArray* muArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    if (type == DateSelectedCustom) {
        muArr = [NSMutableArray arrayWithArray:[XDChartDataClass pieCategoryWithDate:startDate endDate:endDate dateType:type category:_model.category account:account]];
    }else{
        muArr = [NSMutableArray arrayWithArray:[XDChartDataClass pieCategoryWithDate:startDate endDate:nil dateType:type category:_model.category account:account]];
    }
    NSArray* cateArr = [[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName CONTAINS[c] %@",_model.category.categoryName] sortDescriptors:nil];
    
    for (int i = 0; i < cateArr.count; i++) {
        Category* cate = cateArr[i];
        NSArray* array = [muArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category = %@",cate]];
        if (array.count > 0) {
            double singleAmount = 0;
            [self.dataArray addObject:array];
            for (Transaction* tran in array) {
                self.allAmount += [tran.amount doubleValue];
                singleAmount += [tran.amount doubleValue];
            }
            [self.amountMuArr addObject:@(singleAmount)];
        }
    }
    
    [self.tableView reloadData];
}

//-------给金额double类型转换成 NSString类型
- (NSString *)formatterString:(double)doubleContext
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *string = @"";
    if(doubleContext >= 0)
        string = [NSString stringWithFormat:@"%.2f",doubleContext];
    else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
    NSArray *tmp = [string componentsSeparatedByString:@"."];
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    [numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
    if([tmp count]<2)
    {
        string = tmpStr;
    }
    else
    {
        
        string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
    }
    
    
    NSString *typeOfDollar = appDelegate.settings.currency;
    NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        dollorStr = [NSString stringWithFormat:@"-%@",dollorStr];
    }
    
    string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
        string = [NSString stringWithFormat:@"%@",string];
    
    
    
    return string;
    
}
@end

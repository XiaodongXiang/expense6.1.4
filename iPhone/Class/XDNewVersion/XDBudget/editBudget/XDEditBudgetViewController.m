//
//  XDEditBudgetViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import "XDEditBudgetViewController.h"
#import "XDBudgetSelectTableViewController.h"
#import "XDCategorySplitTableViewCell.h"
#import "CategorySelect.h"
#import "Category.h"
#import "BudgetTemplate.h"
#import "Setting+CoreDataClass.h"
#import "EPNormalClass.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"
#import "BudgetCountClass.h"
#import "PokcetExpenseAppDelegate.h"
@import Firebase;
@interface XDEditBudgetViewController ()<XDBudgetSelectTableViewDelegate,XDCategorySplitCellDelegate>
{
    UIButton* _weekBtn;
    UIButton* _monthBtn;
    
    Setting* setting;
    
    NSMutableArray * _budgetMuArr;
    NSMutableArray * _oldMuArr;
    
    CGRect  _cellRect;
    
    UIImageView* _slideImageView;

}
@property (weak, nonatomic) IBOutlet UILabel *repeatLbl;
@property (weak, nonatomic) IBOutlet UILabel *tableHeadTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *repeatBackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *generalAmountLbl;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *selectCateBtn;

@property(nonatomic, strong)NSMutableArray * dataMuArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeading;

@property(nonatomic, strong)ADEngineController* interstitial;

@end

@implementation XDEditBudgetViewController
@synthesize type;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];
    
    if (type == Weekly) {
        _slideImageView.frame = CGRectMake(-3, -2, 87, 44);
        _weekBtn.selected = YES;
        _monthBtn.selected = NO;
    }else{
        _slideImageView.frame = CGRectMake(84, -2, 87, 44);
        _weekBtn.selected = NO;
        _monthBtn.selected = YES;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];

    if (IS_IPHONE_X) {
        self.topLeading1.constant = self.topLeading2.constant = 98;
        self.topLeading3.constant = 145;
        
        self.bottomLeading.constant = 34;
    }
    [FIRAnalytics setScreenName:@"budget_create_view_iphone" screenClass:@"XDEditBudgetViewController"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.repeatLbl.text = NSLocalizedString(@"VC_Repeat", nil);
    
    setting = [[[XDDataManager shareManager]getObjectsFromTable:@"Setting"]lastObject];
    [self initNavStype];
    [self setupRepeatBtn];

    self.dataMuArr = [NSMutableArray array];
    
    _budgetMuArr = [NSMutableArray arrayWithArray:[[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"isNew = 1 and state = %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES]]]];
    _oldMuArr = _budgetMuArr;
    
    for (BudgetTemplate* bt in _budgetMuArr) {
        CategorySelect* cs = [[CategorySelect alloc]init];
        cs.category = bt.category;
        cs.amount = [bt.amount doubleValue];
        cs.memo = @"";
        cs.isSelect = NO;
        [self.dataMuArr addObject:cs];
    }
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorColor = RGBColor(226, 226, 226);
    
    [self.selectCateBtn setTitle:NSLocalizedString(@"VC_SelectCategory", nil) forState:UIControlStateNormal];
}

-(void)keyboardWillChangeFrame:(NSNotification*)noti{
    NSValue *value = [[noti userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
//    NSLog(@"rect == %@",NSStringFromCGRect([value CGRectValue]));
    CGRect rect = [value CGRectValue];
    
    if (rect.origin.y == SCREEN_HEIGHT) {
        self.tableView.transform  = CGAffineTransformIdentity;
    }else{
        if ((_cellRect.origin.y + 57) < rect.origin.y) {
            return;
        }
        self.tableView.transform  = CGAffineTransformMakeTranslation(0, -( _cellRect.origin.y + _cellRect.size.height - value.CGRectValue.origin.y + 57));

    }
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavStype
{
    self.navigationItem.title = NSLocalizedString(@"VC_BudgetList", nil);
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -2.f;
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    [doneBtn setTitle:NSLocalizedString(@"VC_Save", nil) forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn setTitleColor:RGBColor(113, 163, 245) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[flexible2,[[UIBarButtonItem alloc] initWithCustomView:doneBtn]];
}

-(void)save{
    [self.view endEditing:YES];
    for (int i = 0; i < self.dataMuArr.count; i++) {
        CategorySelect* cs = self.dataMuArr[i];
        if (cs.amount == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"09_BGT_ADJ"];

    
    NSMutableArray* editMuArr = [NSMutableArray array];

    for (int i = 0; i < _budgetMuArr.count; i++) {
        BudgetTemplate* temp = _budgetMuArr[i];
        BOOL hasFound = NO;
        for (int i = 0; i < self.dataMuArr.count; i++) {
            CategorySelect* cs = self.dataMuArr[i];
            if ([temp.category.categoryName isEqualToString:cs.category.categoryName]) {
                hasFound = YES;
                break;
            }
        }
        if (!hasFound) {
            temp.state = @"0";
            temp.updatedTime = [NSDate date];
            
            BudgetItem * item = [[temp.budgetItems allObjects]lastObject];
            item.updatedTime = [NSDate date];
            item.state = @"0";
            
            for (BudgetTransfer* transfer in [item.fromTransfer allObjects]) {
                transfer.dateTime_sync = [NSDate date];
                transfer.state = @"0";
                
                if ([PFUser currentUser]){
                    [[ParseDBManager sharedManager]updateBudgetTransfer:transfer];
                }
            }
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager] updateBudgetFromLocal:temp];
                [[ParseDBManager sharedManager] updateBudgetItemLocal:item];
            }
        }
    
    }
    [[XDDataManager shareManager]saveContext];

    
    for (int i = 0; i < self.dataMuArr.count; i++) {
        CategorySelect* cs = self.dataMuArr[i];
        
        BudgetTemplate* bt = [[[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"category.categoryName = %@ and state = %@",cs.category.categoryName,@"1"] sortDescriptors:nil]lastObject];
        if (bt) {
            bt.updatedTime = [NSDate date];
            bt.amount = [NSNumber numberWithDouble:cs.amount];
            
            BudgetItem * item = [[bt.budgetItems allObjects]lastObject];
            item.updatedTime = [NSDate date];
            item.amount = @(cs.amount);
            item.state = @"1";
            
            [editMuArr addObject:bt];
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager] updateBudgetFromLocal:bt];
                [[ParseDBManager sharedManager] updateBudgetItemLocal:item];
            }
        }else{
            BudgetTemplate* temple = [[XDDataManager shareManager]insertObjectToTable:@"BudgetTemplate"];
            temple.cycleType = @"No Cycle";
            temple.startDate = [NSDate date];
            temple.isRollover = @(NO);
            temple.category = cs.category;
            temple.amount = @(cs.amount);
            temple.isNew = @(YES);
            temple.dateTime = [NSDate date];
            temple.state = @"1";
            temple.uuid = [EPNormalClass GetUUID];
            temple.updatedTime = [NSDate date];
            
            NSDate *startDate =[self getFirstSecByDate:temple.startDate];
            NSDate *tmpDate =[self getDate: startDate byCycleType:temple.cycleType];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
            [dc1 setDay:-1];
    
            NSDate *endDate =[self getLastSecByDate:[gregorian dateByAddingComponents:dc1 toDate:tmpDate options:0]];
    
    
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager] updateBudgetFromLocal:temple];
            }
    
            [self insertBudgetItem:temple withStartDate:startDate EndDate:endDate];
    
            [editMuArr addObject:temple];
    
        }
        [[XDDataManager shareManager]saveContext];
  
    }
    
    if (_weekBtn.selected == YES) {
        if ([self.delegate respondsToSelector:@selector(returnEditBudget:DateType:)]) {
            [self.delegate returnEditBudget:editMuArr DateType:Weekly];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"budgetRepeatBtn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        if ([self.delegate respondsToSelector:@selector(returnEditBudget:DateType:)]) {
            [self.delegate returnEditBudget:editMuArr DateType:Monthly];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"budgetRepeatBtn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //插页广告
    if ([PFUser currentUser]) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.isPurchased) {
            [self.interstitial showInterstitialAdWithTarget:self.navigationController];
        }
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //插页广告
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1204 - iPhone - Interstitial - BudgetSave"];
        }
    }
    return self;
}


-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setupRepeatBtn{
    

    
    self.repeatBackView.layer.cornerRadius = 16;
    self.repeatBackView.layer.masksToBounds = YES;
    self.repeatBackView.clipsToBounds = NO;

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _slideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button"]];
    _slideImageView.frame = CGRectMake(-3, -2, 87, 44);
    [self.repeatBackView addSubview:_slideImageView];
    
    self.repeatBackView.backgroundColor = RGBColor(230, 230, 230);
    _weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weekBtn.layer.cornerRadius = 16;
    _weekBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    [_weekBtn setTitle:NSLocalizedString(@"VC_Weekly", nil) forState:UIControlStateNormal];
    _weekBtn.frame = CGRectMake(0, 0, self.repeatBackView.width / 2, self.repeatBackView.height);
    _weekBtn.tag = 1;
    [self.repeatBackView addSubview:_weekBtn];
    
    _monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _monthBtn.layer.cornerRadius = 16;
    _monthBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    [_monthBtn setTitle:NSLocalizedString(@"VC_Monthly", nil) forState:UIControlStateNormal];
    _monthBtn.frame = CGRectMake(self.repeatBackView.width / 2+3, 0, self.repeatBackView.width / 2, self.repeatBackView.height);
    _monthBtn.tag = 2;
    [self.repeatBackView addSubview:_monthBtn];
    
    [_weekBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_monthBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)repeatBtnClick:(UIButton*)btn{
    [UIView animateWithDuration:0.2 animations:^{
        if (btn == _weekBtn) {
            _weekBtn.selected = YES;
            _monthBtn.selected = NO;
            _slideImageView.x = -3;
            
        }else{
            
            _weekBtn.selected = NO;
            _monthBtn.selected = YES;
            _slideImageView.x = 84;
        }
    }];
}

- (IBAction)selectCategoryBtnClick:(id)sender {
    XDBudgetSelectTableViewController* vc = [[XDBudgetSelectTableViewController alloc]init];
    vc.selectDelegate = self;
    vc.selectMuArr = self.dataMuArr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XDBudgetSelectTableViewDelegate
-(void)returnSelectCategoryArray:(NSMutableArray *)array{
    
    self.dataMuArr = [NSMutableArray array];

    for (Category* ca in array) {
        CategorySelect* cs = [[CategorySelect alloc]init];
        cs.category = ca;
        cs.amount = 0.0;
        cs.memo = @"";
        cs.isSelect = NO;
        
        
        for (BudgetTemplate* bt in _oldMuArr) {
            if (bt.category == ca) {
                cs.amount = [bt.amount doubleValue];

            }
            
        }
        [self.dataMuArr addObject:cs];

    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Table view data source
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategorySelect* cs = self.dataMuArr[indexPath.row];
    
    BudgetTemplate* temple = [[[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"state = %@ and category = %@",@"1",cs.category] sortDescriptors:nil]lastObject];
    if (temple) {
        temple.state = @"0";
        temple.updatedTime = [NSDate date];
        
        for (BudgetItem* item in [temple.budgetItems allObjects]) {
            item.state = @"0";
            item.updatedTime = [NSDate date];
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBudgetItemLocal:item];
            }
        }
        
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBudgetFromLocal:temple];
        }
        
        [[XDDataManager shareManager] saveContext];
    }
    
    [_budgetMuArr removeObject:temple];
    // 删除模型
    [self.dataMuArr removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableHeadTitleLbl.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)self.dataMuArr.count,NSLocalizedString(@"VC_Item(s)", nil)];

    return self.dataMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellID = @"cellID";
    XDCategorySplitTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCategorySplitTableViewCell" owner:self options:nil]lastObject];
    }
    CategorySelect* cs = self.dataMuArr[indexPath.row];
    cell.categorySelect =cs;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.row == 0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = RGBColor(226, 226, 226);
        [cell.contentView addSubview:view];
    }
    return cell;
}





#pragma mark - XDCategorySplitCellDelegate
-(void)returnSplitAmount:(XDCategorySplitTableViewCell *)cell{
    
    double amout = 0;

    for (CategorySelect*cs in self.dataMuArr) {
        amout += cs.amount;
    }

    self.generalAmountLbl.text = [NSString stringWithFormat:@"%@ %.2f",[[setting.currency componentsSeparatedByString:@"-"]firstObject],amout];
}


-(void)returnCellFrame:(XDCategorySplitTableViewCell *)cell{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    _cellRect = rectInSuperview;
}

#pragma mark - other
-(NSDate *)getFirstSecByDate:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents*  parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return  [[NSCalendar currentCalendar] dateFromComponents:parts];
    
}

//------------获取一天的最后一秒
-(NSDate *)getLastSecByDate:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents*  parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return  [[NSCalendar currentCalendar] dateFromComponents:parts];
    
}

#pragma mark get date by cycle
-(NSDate *)getDate:(NSDate *)startDate byCycleType:(NSString *)cycleType
{
    NSDate* dt = nil;
    // NSDateFormatter *dayFormatter = [[[NSDateFormatter alloc] init] autorelease];
    // [dayFormatter setDateFormat:@"dd"];
    
    if([cycleType isEqualToString:@"Semimonthly"]||[cycleType isEqualToString:@"Half Month"])
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit ) fromDate:startDate];
        long dayIndex = [components day];
        if(dayIndex <15)
        {
            [components setDay:15];
        }
        else
        {
            [components setMonth:[components month]+1];
            [components setDay:1];
            
        }
        dt = [gregorian dateFromComponents:components];
    }
    else if([cycleType isEqualToString:@"No Cycle"])
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
        [dc1 setYear: 99];
        dt = [gregorian dateByAddingComponents:dc1 toDate:startDate options:0];
        
    }
    
    else
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dc1 = [[NSDateComponents alloc] init];
        
        
        if([cycleType isEqualToString:@"Daily"])
        {
            [dc1 setDay: 1];
        }
        else if([cycleType isEqualToString:@"Weekly"]||[cycleType isEqualToString:@"Week"])
        {
            [dc1 setDay: 7];
        }
        else if([cycleType isEqualToString:@"Every 2 Weeks"]||[cycleType isEqualToString:@"2 Weeks"]||[cycleType isEqualToString:@"Two Weeks"])
        {
            [dc1 setDay: 14];
            //[dc1 setWeek:2];
        }
        else if([cycleType isEqualToString:@"Every 4 Weeks"])
        {
            [dc1 setDay: 28];
        }
        else if([cycleType isEqualToString:@"Monthly"]||[cycleType isEqualToString:@"Month"])
        {
            [dc1 setMonth:1];
        }
        else if([cycleType isEqualToString:@"Every 2 Months"])
        {
            [dc1 setMonth:2];
        }
        else if([cycleType isEqualToString:@"Every 3 Months"]||[cycleType isEqualToString:@"Tire Months"]||[cycleType isEqualToString:@"3 Months"]||[cycleType isEqualToString:@"Quarter"])
        {
            [dc1 setMonth:3];
        }
        else if([cycleType isEqualToString:@"Every 6 Months"])
        {
            [dc1 setMonth:6];
        }
        else if([cycleType isEqualToString:@"Every Year"]||[cycleType isEqualToString:@"Year"])
        {
            [dc1 setYear:1];
        }
        dt = [gregorian dateByAddingComponents:dc1 toDate:startDate options:0];
        
    }
    return dt;
}

#pragma mark - Fill budget data when enter app
-(void)insertBudgetItem:(BudgetTemplate *)b withStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate
{
    
    BudgetItem *newBudget = [[XDDataManager shareManager] insertObjectToTable:@"BudgetItem"];
    newBudget.amount = b.amount;
    newBudget.isRollover = b.isRollover;
    
    newBudget.startDate = startDate;
    newBudget.endDate =endDate;
    
    newBudget.dateTime = [NSDate date];
    newBudget.state = @"1";
    newBudget.uuid = [EPNormalClass GetUUID];
    newBudget.budgetTemplate = b;
    newBudget.updatedTime = [NSDate date];
    [b addBudgetItemsObject:newBudget];
    [[XDDataManager shareManager] saveContext];
    

    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateBudgetItemLocal:newBudget];
    }
    
}



@end

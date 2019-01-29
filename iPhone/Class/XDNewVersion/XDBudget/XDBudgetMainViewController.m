//
//  XDBudgetMainViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/15.
//

#import "XDBudgetMainViewController.h"
#import "XDDateSelectedView.h"
#import "XDBudgetTableView.h"
#import "XDEditBudgetViewController.h"
#import "BudgetTemplate.h"
#import "BudgetCountClass.h"
#import "Setting+CoreDataClass.h"
#import "Transaction.h"
#import "Category.h"
#import "BudgetItem.h"
#import "BudgetTransfer.h"
#import "XDBudgetDetailViewController.h"
#import "SettingViewController.h"
#import "PokcetExpenseAppDelegate.h"
@import Firebase;
@interface XDBudgetMainViewController ()<UIScrollViewDelegate,XDEditBudgetViewDelegate,XDBudgetTableViewDelegate,ADEngineControllerBannerDelegate>
{
    __block NSInteger _index;
    
    XDBudgetTableView* _currentBudgetTableView;
    XDBudgetTableView* _lastBudgetTableView;
    XDBudgetTableView* _nextBudgetTableView;
    
    NSArray* _dateArray;
    
    NSArray* _dataArray;
    
    BudgetType _budgetType;
    
    NSDate* _currentDate;
    NSDate* _lastDate;
    NSDate* _nextDate;
    
}
@property(nonatomic, strong)XDDateSelectedView * dateSelectedView;
@property(nonatomic, strong)UIScrollView * scrollView;


@property(nonatomic, strong)ADEngineController* adBanner;
@property(nonatomic, strong)UIView* adBannerView;

@end

@implementation XDBudgetMainViewController

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        if (IS_IPHONE_X) {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateSelectedView.frame)+1, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 83)];
        }else{
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateSelectedView.frame)+1, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 49)];
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIView *)adBannerView{
    if (!_adBannerView) {
        
        if (IS_IPHONE_X) {
            _adBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 133, SCREEN_WIDTH, 50)];

        }else{
            _adBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 99, SCREEN_WIDTH, 50)];
        }
        _adBannerView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:_adBannerView];
        [self.view addSubview:_adBannerView];
    }
    
    return _adBannerView;
}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1105 - iPhone - Banner - Budget" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
       
        
        if (IS_IPHONE_X) {
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 83;
        }else{
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 49;
        }
    }
}

#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        
        if (IS_IPHONE_X) {
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 83 - 50;
        }else{
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 49 - 50;
        }
        
    }else{
        self.adBannerView.hidden = YES;
        
        if (IS_IPHONE_X) {
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 83;
        }else{
            self.scrollView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.dateSelectedView.frame) - 49;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@NO];
//    [self getMonthDataSource];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"VC_Budget", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(editClick) image:[UIImage imageNamed:@"edit"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingButtonPress) image:[UIImage imageNamed:@"setting_new"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"TransactionViewRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"addTransfer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"refreshUI" object:nil];

    if (IS_IPHONE_X) {
        self.dateSelectedView = [[XDDateSelectedView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 24)];
    }else{
        self.dateSelectedView = [[XDDateSelectedView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 24)];
    }
    NSInteger repeatIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"budgetRepeatBtn"] integerValue];

    
    __weak __typeof__(self) weakSelf = self;
    _dateArray = [XDDateSelectedModel returnDateSelectedWithType:(repeatIndex == 1)?DateSelectedWeek:DateSelectedMonth completion:^(NSInteger index) {
        [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
        _index = index;
    }];
    
  
    self.dateSelectedView.type = (repeatIndex == 1)?DateSelectedWeek:DateSelectedMonth;
    self.dateSelectedView.dateArr = _dateArray;
    
    [self.view addSubview:self.dateSelectedView];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _dateArray.count, 0);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _index, 0)];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self setupBudgetTableView];

    if (repeatIndex == 1) {
        [self getWeeklyDataSource];
    }else{
        [self getMonthDataSource];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calendarFirstDayChange) name:@"calendarFirstDayChange" object:nil];
    
    [FIRAnalytics setScreenName:@"budget_main_view_iphone" screenClass:@"XDBudgetMainViewController"];

}

-(void)calendarFirstDayChange{
    if (_budgetType == Weekly) {
        _dateArray = [XDDateSelectedModel returnDateSelectedWithType:DateSelectedWeek completion:^(NSInteger index) {
         
        }];
        
        self.dateSelectedView.dateArr = _dateArray;
        [self getWeeklyDataSource];
    }
}

-(void)reloadTableView{
    
    if (_budgetType == Weekly) {
        [self getWeeklyDataSource];
    }else{
        [self getMonthDataSource];
    }
}

-(void)settingButtonPress{
    
    SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)getMonthDataSource{
    _budgetType = Monthly;
    
    _lastDate = _nextDate = nil;

    _currentDate = _dateArray[_index];
    if (_index >= 1) {
        _lastDate = _dateArray[_index - 1];
    }
    if (_index <= _dateArray.count-2) {
        _nextDate = _dateArray[_index + 1];
    }
    
    
    if (_budgetType == Monthly) {
        
        _dataArray = [[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"isNew = 1 and state = %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES]]];
        
        _currentBudgetTableView.budgetArray = [self getBudgetDataSoure:_currentDate type:2];
        _lastBudgetTableView.budgetArray = [self getBudgetDataSoure:_lastDate type:2];
        _nextBudgetTableView.budgetArray = [self getBudgetDataSoure:_nextDate type:2];
        
    }
}

-(void)getWeeklyDataSource{
    _budgetType = Weekly;
    
    _lastDate = _nextDate = nil;
    
    _currentDate = _dateArray[_index][0];
    if (_index >= 1) {
         _lastDate = _dateArray[_index - 1][0];
    }
    if ((int)_index <= (int)_dateArray.count-2) {
        _nextDate = _dateArray[_index + 1][0];
    }
    if (_budgetType == Weekly) {
        
        _dataArray = [[XDDataManager shareManager]getObjectsFromTable:@"BudgetTemplate" predicate:[NSPredicate predicateWithFormat:@"isNew = 1 and state = %@",@"1"] sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"category.categoryName" ascending:YES]]];
        
        
        _currentBudgetTableView.budgetArray = [self getBudgetDataSoure:_currentDate type:1];
        _lastBudgetTableView.budgetArray = [self getBudgetDataSoure:_lastDate type:1];
        _nextBudgetTableView.budgetArray = [self getBudgetDataSoure:_nextDate type:1];
        
    }
    

}

-(NSMutableArray*)getBudgetDataSoure:(NSDate*)date type:(NSInteger)index{
    
    if (!date) {
        return nil;
    }
    NSMutableArray* muArr = [NSMutableArray array];
    NSDate* startCurrentDate = [self getStartDateWithDateType:index fromDate:date];
    NSDate* endCurrentDate = [self getEndDateDateType:index withStartDate:startCurrentDate];
    
    
    NSError* error = nil;
    for (int i = 0; i < _dataArray.count; i++) {
        BudgetTemplate *budgetTemplate = [_dataArray objectAtIndex:i];
        BudgetCountClass* budgetCountClass = [[BudgetCountClass alloc]init];
        budgetCountClass.bt = budgetTemplate;
        double amount = [budgetTemplate.amount doubleValue];
        if (budgetTemplate.category) {
            NSDictionary *  subs = [NSDictionary dictionaryWithObjectsAndKeys:budgetTemplate.category,@"iCategory",startCurrentDate,@"startDate",endCurrentDate,@"endDate", nil];
            //获取该budgetTemplate下 该段时间内的transaction,统计
            NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs] ;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
            double totalExpense = 0;
            
            for (int i = 0; i < tmpArray.count; i++) {
                Transaction* transaction = tmpArray[i];
                totalExpense += [transaction.amount doubleValue];
            }
            
            BudgetItem* item = [[budgetTemplate.budgetItems allObjects]lastObject];

            NSArray* fromTrans = [self getCurrentDateBudget:date type:index array:[item.fromTransfer allObjects]] ;
            for (BudgetTransfer * transfer in fromTrans) {
                amount -= [transfer.amount doubleValue];

            }
            
            NSArray* toTrans = [self getCurrentDateBudget:date type:index array:[item.toTransfer allObjects]];
            
            for (BudgetTransfer * transfer in toTrans) {
                amount += [transfer.amount doubleValue];

            }
            
            
            ////////////////////获取子类category的交易
            NSString *searchForMe = @":";
            NSRange range = [budgetTemplate.category.categoryName rangeOfString : searchForMe];
            if (range.location == NSNotFound)
            {
                
                NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",budgetTemplate.category.categoryName];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",budgetTemplate.category.categoryType,@"CATEGORYTYPE",nil];
                NSFetchRequest *fetchChildCategory = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
                NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                [fetchChildCategory setSortDescriptors:sortDescriptors];
                NSArray *objects1 = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
                NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
                
                for(int j=0 ;j<[tmpChildCategoryArray count];j++)
                {
                    Category *tmpCate = [tmpChildCategoryArray objectAtIndex:j];
                    if(tmpCate !=budgetTemplate.category)
                    {
                        subs = [NSDictionary dictionaryWithObjectsAndKeys:tmpCate,@"iCategory",startCurrentDate,@"startDate",endCurrentDate,@"endDate", nil];
                        NSFetchRequest *fetchRequest = [[XDDataManager shareManager].managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:subs];
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
                        NSMutableArray   *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
                        [fetchRequest setSortDescriptors:sortDescriptors];
                        NSArray *objects = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:objects];
                        
                        for (int k = 0;k<[tmpArray count];k++)
                        {
                            Transaction *t = [tmpArray objectAtIndex:k];
                            if([t.category.categoryType isEqualToString:@"EXPENSE"])
                            {
                                totalExpense +=[t.amount doubleValue];
//                                amount += [t.amount doubleValue];
                            }
//                            else if([t.category.categoryType isEqualToString:@"INCOME"])
//                            {
//                                amount -=[t.amount doubleValue];
//                            }
                            
                            
                        }
                        
                    }
                }
                
                
            }
            
            
            budgetCountClass.btTotalExpense = totalExpense;
            
            budgetCountClass.btTotalRellover = amount;
            
            
        }
        [muArr addObject:budgetCountClass];
    }
    return muArr;
    
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

-(void)editClick{
    XDEditBudgetViewController* vc = [[XDEditBudgetViewController alloc]
                                      initWithNibName:@"XDEditBudgetViewController" bundle:nil];
    vc.delegate  = self;
    vc.type = _budgetType;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupBudgetTableView{
    _currentBudgetTableView = [[XDBudgetTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * _index, 0, SCREEN_WIDTH, self.scrollView.height)];
    _lastBudgetTableView = [[XDBudgetTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * (_index - 1), 0, SCREEN_WIDTH, self.scrollView.height)];
    _nextBudgetTableView = [[XDBudgetTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * (_index+1), 0, SCREEN_WIDTH, self.scrollView.height)];
    
    _currentBudgetTableView.budgetDelegate = self;
    _lastBudgetTableView.budgetDelegate = self;
    _nextBudgetTableView.budgetDelegate = self;
    
    [self.scrollView addSubview:_currentBudgetTableView];
    [self.scrollView addSubview:_lastBudgetTableView];
    [self.scrollView addSubview:_nextBudgetTableView];
}

#pragma mark - XDBudgetTableViewDelegate
-(void)returnSelectedBudget:(BudgetTemplate *)budgetTemple transactionArray:(NSArray *)array{
    XDBudgetDetailViewController* vc = [[XDBudgetDetailViewController alloc]initWithNibName:@"XDBudgetDetailViewController" bundle:nil];
    vc.type = _budgetType;
    if (_budgetType == Weekly) {
        vc.date = _dateArray[_index][0];
    }else{
        vc.date = _dateArray[_index];
    }
    vc.budgetTemple = budgetTemple;

    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];

}

-(void)createBudgetBtnClick{
    [self editClick];
}

#pragma mark - scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger integer = (int)round(scrollView.contentOffset.x/SCREEN_WIDTH);
//
//    _currentDate = _dateArray[integer];
//
//    NSLog(@"%@ -- %@",[self getStartDateWithDateType:_budgetType fromDate:_currentDate],[self getEndDateDateType:_budgetType withStartDate:[self getStartDateWithDateType:_budgetType fromDate:_currentDate]]);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x/3;
    
    [self.dateSelectedView.scrollView setContentOffset:CGPointMake(x, 0) animated:NO];

    NSInteger integer = (int)round(scrollView.contentOffset.x/SCREEN_WIDTH);
    
    if (integer != _index) {
        if (integer > _index) {


            if (integer >= _dateArray.count - 1) {
                return;
            }
            _lastBudgetTableView.x = SCREEN_WIDTH * (integer + 1);

            if (_budgetType == Weekly) {
                _lastDate = _dateArray[integer + 1][0];
            }else{
                _lastDate = _dateArray[integer + 1];
            }
            _lastBudgetTableView.budgetArray = [self getBudgetDataSoure:_lastDate type:_budgetType];
            
            XDBudgetTableView* temple = _lastBudgetTableView;
            _lastBudgetTableView = _currentBudgetTableView;
            _currentBudgetTableView = _nextBudgetTableView;
            _nextBudgetTableView = temple;
            
            
        }else if (integer < _index){

            if (integer <= 0) {
                return;
            }
            _nextBudgetTableView.x = SCREEN_WIDTH * (integer - 1);

            if (_budgetType == Weekly) {
                _nextDate = _dateArray[integer - 1][0];
            }else{
                _nextDate = _dateArray[integer - 1];
            }
            _nextBudgetTableView.budgetArray = [self getBudgetDataSoure:_nextDate type:_budgetType];
            
            XDBudgetTableView* temple = _nextBudgetTableView;
            _nextBudgetTableView = _currentBudgetTableView;
            _currentBudgetTableView = _lastBudgetTableView;
            _lastBudgetTableView = temple;
            
        }
        _index = integer;

    }
}

#pragma mark - XDEditBudgetViewDelegate
-(void)returnEditBudget:(NSArray *)budgetArray DateType:(BudgetType)type{
    _budgetType = type;
    
    __block NSInteger count = 0;
    __weak __typeof__(self) weakSelf = self;
    if (_budgetType == Weekly) {
        _dateArray = [XDDateSelectedModel returnDateSelectedWithType:DateSelectedWeek completion:^(NSInteger index) {
            [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
            count = index;
        }];
    }else{
        _dateArray = [XDDateSelectedModel returnDateSelectedWithType:DateSelectedMonth completion:^(NSInteger index) {
            [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
            count = index;
        }];
    }
    
    
    self.dateSelectedView.type = (_budgetType == Weekly?DateSelectedWeek:DateSelectedMonth);
    self.dateSelectedView.dateArr = _dateArray;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_dateArray.count, 0);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * count, 0)];
    
    _currentBudgetTableView.x = SCREEN_WIDTH * count;
    _lastBudgetTableView.x = SCREEN_WIDTH * (count - 1);
    _nextBudgetTableView.x = SCREEN_WIDTH * (count + 1);

    _index = count;

    if (_budgetType == Weekly) {
        [self getWeeklyDataSource];
    }else{
        [self getMonthDataSource];
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

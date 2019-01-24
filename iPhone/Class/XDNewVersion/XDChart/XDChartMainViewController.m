//
//  XDChartMainViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/13.
//

#import "XDChartMainViewController.h"
#import "ChartTitleBtn.h"
#import "XDTitleAccountTableView.h"
#import "XDDateSelectedView.h"
#import "Accounts.h"
#import "XDChartPageView.h"
#import "XDDateSelectedModel.h"
#import "XDTimeSelectView.h"
#import "XDChartDataClass.h"
#import "XDPieDetailViewController.h"
#import "SettingViewController.h"
@import Firebase;
@interface XDChartMainViewController ()<XDTitleAccountTableViewDelegate,XDTimeSelectViewDelegate,UIScrollViewDelegate,XDChartPageViewDelegate,UIGestureRecognizerDelegate>
{
    Accounts* _selectedAccount;
    UIScrollView* _chartScrollView;
    
    XDChartPageView* _currentPageView;
    XDChartPageView* _lastPageView;
    XDChartPageView* _nextPageView;
    
    DateSelectedType _selectedDateType;
    NSArray* _dateArray;
    BOOL _timeSelectViewShow;
    
    __block NSInteger _index;
    
    
}
@property(nonatomic, strong)ChartTitleBtn* titleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *emptyCoverImageView;

@property(nonatomic, strong)XDTitleAccountTableView * titleAccountTableView;
@property(nonatomic, strong)XDDateSelectedView * dateSelectedView;
@property(nonatomic, strong)XDTimeSelectView * timeSelectedView;

@property(nonatomic, strong)UIView * backgroundView;

@end

@implementation XDChartMainViewController



-(XDTimeSelectView *)timeSelectedView{
    if (!_timeSelectedView) {
        _timeSelectedView = [[XDTimeSelectView alloc]initWithFrame:CGRectMake(0, -178, SCREEN_WIDTH, 30)];
        _timeSelectedView.delegate = self;
    }
    return _timeSelectedView;
}

-(XDDateSelectedView *)dateSelectedView{
    if (!_dateSelectedView) {
        if (IS_IPHONE_X) {
            _dateSelectedView = [[XDDateSelectedView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 24)];
        }else{
            _dateSelectedView = [[XDDateSelectedView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 24)];
        }
//        _dateSelectedView.dateDelegate = self;
    }
    return _dateSelectedView;
}
-(UIView *)backgroundView{
    if (!_backgroundView) {
        if (IS_IPHONE_X) {
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }else{
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.hidden = YES;
        
        [self.tabBarController.view addSubview:_backgroundView];
        [self.tabBarController.view bringSubviewToFront:_backgroundView];
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

-(XDTitleAccountTableView *)titleAccountTableView{
    if (!_titleAccountTableView) {
        _titleAccountTableView = [XDTitleAccountTableView view];
        _titleAccountTableView.centerX = SCREEN_WIDTH / 2;
        _titleAccountTableView.y = -_titleAccountTableView.height;
        _titleAccountTableView.selectedDelegate = self;
//        _titleAccountTableView.alpha = 0;
//        _titleAccountTableView.hidden = YES;


    }
    return _titleAccountTableView;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@NO];
    
    
    NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"state = %@",@"1"] sortDescriptors:nil];
    [self.view bringSubviewToFront:self.emptyCoverImageView];
    
    if (array.count == 0) {
        self.emptyCoverImageView.hidden = NO;
        self.titleBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }else{
        self.emptyCoverImageView.hidden = YES;
        self.titleBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightDrawerButton) image:[UIImage imageNamed:@"time"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingButtonPress) image:[UIImage imageNamed:@"setting_new"]];
    [FIRAnalytics setScreenName:@"chart_main_view_iphone" screenClass:@"XDChartMainViewController"];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];

    self.titleBtn = [ChartTitleBtn buttonWithType:UIButtonTypeCustom];
    [self.titleBtn sizeToFit];
    [self.titleBtn setTitle:@"All Accounts" forState:UIControlStateNormal];
    
    [self.titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleBtn;
    self.navigationController.navigationBar.clipsToBounds = YES;
    [self.view addSubview:self.dateSelectedView];
    [self.backgroundView addSubview:self.titleAccountTableView];
    [self.backgroundView addSubview:self.timeSelectedView];
    
    _selectedDateType = DateSelectedMonth;

    _chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateSelectedView.frame)+1, SCREEN_WIDTH, SCREEN_HEIGHT - self.dateSelectedView.height - 51 - 44)];
    _chartScrollView.delegate = self;
    _chartScrollView.pagingEnabled = YES;
    _chartScrollView.bounces = NO;
    _chartScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_chartScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transactionChange) name:@"TransactionViewRefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transactionChange) name:@"refreshUI" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(accountRefresh) name:@"accountRefresh" object:nil];
    
    
        _currentPageView = [[XDChartPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,_chartScrollView.height)];
        _lastPageView = [[XDChartPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _chartScrollView.height)];
        _nextPageView = [[XDChartPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _chartScrollView.height)];
    
        _currentPageView.delegate = _lastPageView.delegate = _nextPageView.delegate = self;

        [_chartScrollView addSubview:_currentPageView];
        [_chartScrollView addSubview:_lastPageView];
        [_chartScrollView addSubview:_nextPageView];
    
//    _dateArray = [XDDateSelectedModel returnDateSelectedWithType:_selectedDateType completion:^(NSInteger index) {
//    }];
//    for (int i = 0; i < _dateArray.count; i++) {
//        NSDate* date = _dateArray[i];
//
//        XDChartPageView* view = [[XDChartPageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.view.height)];
//        view.type = _selectedDateType;
//        view.date = date;
//
//        [_chartScrollView addSubview:view];
//    }
        [self setupScrollView];

}
-(void)transactionChange{
    
    if (_selectedDateType == DateSelectedCustom) {
        return;
    }
    [self refreshScrollView];
    [self setupChartPageView];
    [self.titleAccountTableView refreshUI];
}

-(void)settingButtonPress{
    
    SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)setupScrollView{
    
    __weak __typeof__(self) weakSelf = self;
    _dateArray = [XDDateSelectedModel returnDateSelectedWithType:_selectedDateType completion:^(NSInteger index) {
        [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
        _index = index;
    }];
    if (_index >= _dateArray.count) {
        if (_dateArray.count > 0) {
            _index = _dateArray.count - 1;
        }else{
            _index = 0;
        }
    }
    self.dateSelectedView.type = _selectedDateType;
    self.dateSelectedView.dateArr = _dateArray;
    _chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_dateArray.count, 0);
    [_chartScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _index, 0)];

    _currentPageView.x = SCREEN_WIDTH*_index;
    _lastPageView.x = SCREEN_WIDTH*(_index-1);
    _nextPageView.x = SCREEN_WIDTH*(_index+1);
    
    _currentPageView.type = _lastPageView.type = _nextPageView.type = _selectedDateType;
    
    if (_selectedDateType == DateSelectedWeek) {
        
        NSDate* currentdate = [_dateArray[_index] firstObject];
        _currentPageView.date = currentdate;
        
        
        if (_index == 0 || _index ==  _dateArray.count-1) {
            return;
        }
        NSDate* lastDate = [_dateArray[_index - 1] firstObject];
        NSDate* nextDate = [_dateArray[_index + 1] firstObject];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
        
    }else{
        NSDate* currentdate = _dateArray[_index];
        _currentPageView.date = currentdate;
        
        if (_index == 0 || _index ==  _dateArray.count-1) {
            return;
        }
        NSDate* lastDate = _dateArray[_index - 1];
        NSDate* nextDate = _dateArray[_index + 1];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
    }
}

#pragma mark - backview animation
-(void)showTitleAccountView{
    self.backgroundView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.titleAccountTableView.y = 0;
    }];
}

-(void)showTimeSelectView{
    self.backgroundView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.timeSelectedView.y = 0;
    }];
}

-(void)dismissAccountTitleView{
    self.titleBtn.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if (_timeSelectViewShow == NO) {
            self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }
        self.titleAccountTableView.y = -self.titleAccountTableView.height;
    }];
}

-(void)dismissTimeSelevtView{
    _timeSelectViewShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.titleBtn.selected == NO) {
            self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }
        self.timeSelectedView.y = -self.timeSelectedView.height;
    }];
}


-(void)rightDrawerButton{
    _timeSelectViewShow = !_timeSelectViewShow;
    if (IS_IPHONE_X) {
        self.backgroundView.y = 88;
    }else{
        self.backgroundView.y = 64;
    }

    if (_timeSelectViewShow) {
        [self dismissAccountTitleView];
        [self showTimeSelectView];
    }else{
        [self dismissTimeSelevtView];
        [self performSelector:@selector(hideBackView) withObject:nil afterDelay:0.2];
       
    }
}
-(void)hideBackView{
    self.backgroundView.hidden = YES;

}



-(void)titleBtnClick{
    self.titleBtn.selected = !self.titleBtn.selected;
    if (IS_IPHONE_X) {
        self.backgroundView.y = 88;
    }else{
        self.backgroundView.y = 64;
    }
    if (self.titleBtn.selected) {
        
        [self dismissTimeSelevtView];
        [self showTitleAccountView];
    }else{
        [self dismissAccountTitleView];
        [self performSelector:@selector(hideBackView) withObject:nil afterDelay:0.2];
    }
    
}

-(void)tapClick{
    self.titleBtn.selected = NO;
    _timeSelectViewShow = NO;
    [self dismissAccountTitleView];
    [self dismissTimeSelevtView];
    [self performSelector:@selector(hideBackView) withObject:nil afterDelay:0.2];
}

#pragma mark -

-(void)refreshScrollView{
//    __weak __typeof__(self) weakSelf = self;
    _dateArray = [XDDateSelectedModel returnDateSelectedWithType:_selectedDateType completion:^(NSInteger index) {
//        [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
//        _index = index;
    }];
    
    
    NSArray* copyArray = [_dateArray copy];
    self.dateSelectedView.type = _selectedDateType;
    self.dateSelectedView.dateArr = copyArray;
    _chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*copyArray.count, 0);
    [_chartScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _index, 0)];
    
    _currentPageView.x = SCREEN_WIDTH*_index;
    _lastPageView.x = SCREEN_WIDTH*(_index-1);
    _nextPageView.x = SCREEN_WIDTH*(_index+1);
    
    _currentPageView.type = _lastPageView.type = _nextPageView.type = _selectedDateType;
    
    if (_index > copyArray.count + 1) {
        return;
    }
    if (_selectedDateType == DateSelectedWeek) {
        
        NSDate* currentdate = [copyArray[_index] firstObject];
        
        _currentPageView.date = currentdate;
        
        
        if (_index == 0 || _index ==  copyArray.count-1) {
            return;
        }
        NSDate* lastDate = [copyArray[_index - 1] firstObject];
        NSDate* nextDate = [copyArray[_index + 1] firstObject];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
        
    }else{
        NSDate* currentdate = copyArray[_index];
        _currentPageView.date = currentdate;
        
        if (_index == 0 || _index ==  copyArray.count-1) {
            return;
        }
        NSDate* lastDate = copyArray[_index - 1];
        NSDate* nextDate = copyArray[_index + 1];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
    }
}



-(void)accountRefresh{
    [self.titleAccountTableView refreshUI];
}

#pragma mark - XDDateSelectedDelegate
-(void)returnSelectedDate:(NSDate *)date index:(NSInteger)index{
    [_chartScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0)];
}

#pragma mark - XDChartPageViewDelegate
-(void)returnPieViewDataArray:(NSArray *)array pieType:(NSString *)string{
    if (_selectedDateType == DateSelectedCustom) {
        XDPieDetailViewController* vc = [[XDPieDetailViewController alloc]initWithNibName:@"XDPieDetailViewController" bundle:nil];
        vc.account = _selectedAccount;
        vc.pieType = string;
        vc.type = _selectedDateType;
        vc.dataArray = array;
        vc.dateArray = _dateArray;
        vc.title = _selectedAccount?_selectedAccount.accName:@"All Accounts";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        XDPieDetailViewController* vc = [[XDPieDetailViewController alloc]initWithNibName:@"XDPieDetailViewController" bundle:nil];
        vc.account = _selectedAccount;
        vc.pieType = string;
        vc.index = _index;
        vc.type = _selectedDateType;
        vc.dataArray = array;
        vc.dateArray = _dateArray;
        vc.title = _selectedAccount?_selectedAccount.accName:@"All Accounts";
        [self.navigationController pushViewController:vc animated:YES];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarDismiss" object:@YES];

    
}

#pragma mark - XDTitleAccountTableViewDelegate
-(void)returnSelectedAccount:(Accounts *)account{
    _selectedAccount = account;
    
    _currentPageView.type = _lastPageView.type = _nextPageView.type = _selectedDateType;
    
    _currentPageView.account = account;
    _lastPageView.account = account;
    _nextPageView.account = account;
    
    if (account != nil) {
        [self.titleBtn setTitle:account.accName forState:UIControlStateNormal];
    }else{
        [self.titleBtn setTitle:@"All Accounts" forState:UIControlStateNormal];
    }
    
    [self tapClick];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x/3;

    [self.dateSelectedView.scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    
    NSInteger integer = (int)round(scrollView.contentOffset.x/SCREEN_WIDTH);
    
    if (_dateArray.count >3) {
        if (integer != _index) {

            if (integer >_index) {

                _lastPageView.x = (integer+1) * SCREEN_WIDTH;
                XDChartPageView* pageView = _lastPageView;

                if (integer >= _dateArray.count - 1) {
                    _index = _dateArray.count - 1;
                    _lastPageView = _currentPageView;
                    _currentPageView = _nextPageView;
                    _nextPageView = pageView;
                    return;
                }
                    NSDate* date;
                    if (_selectedDateType == DateSelectedWeek) {

                        date = [_dateArray[integer+1] firstObject];
                    }else{
                        date = _dateArray[integer+1];
                    }

                    _lastPageView.date = date;
                    _lastPageView.type = _selectedDateType;
                    [_lastPageView scrollToNetworth];

                    _lastPageView = _currentPageView;
                    _currentPageView = _nextPageView;
                    _nextPageView = pageView;

            }else{
                _nextPageView.x = (integer-1) * SCREEN_WIDTH;
                XDChartPageView* pageView = _nextPageView;

                if (integer <= 0) {
                    _nextPageView = _currentPageView;
                    _currentPageView = _lastPageView;
                    _lastPageView = pageView;
                    _index = 0;
                    return;
                }

                    NSDate* date;
                    if (_selectedDateType == DateSelectedWeek) {
                        date = [_dateArray[integer-1] firstObject];
                    }else{
                        date = _dateArray[integer-1];
                    }
                    _nextPageView.date = date;
                    _nextPageView.type = _selectedDateType;
                    [_nextPageView scrollToNetworth];

                    _nextPageView = _currentPageView;
                    _currentPageView = _lastPageView;
                    _lastPageView = pageView;

            }
            _index = integer;
            if (_index >= _dateArray.count) {
                if (_dateArray.count > 0) {
                    _index = _dateArray.count - 1;
                }else{
                    _index = 0;
                }
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger integer = (int)round(scrollView.contentOffset.x/SCREEN_WIDTH);
////    NSLog(@"%ld",integer);
//    _index = integer;
    
}

#pragma mark - XDTimeSelectViewDelegate
-(void)returnSubTime:(NSDate *)date index:(NSInteger)index{
    [self.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
    [_chartScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    
    _index = index;
    if (_index >= _dateArray.count) {
        if (_dateArray.count > 0) {
            _index = _dateArray.count - 1;
        }else{
            _index = 0;
        }
    }
    [self setupChartPageView];
    [self tapClick];
}

-(void)returnFourBtnSelected:(DateSelectedType)type{
    _selectedDateType = type;
    if (type == DateSelectedWeek) {
        [self rightDrawerButton];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        if (IS_IPHONE_X) {
            self.backgroundView.y = 88;
        }else{
            self.backgroundView.y = 64;
        }
        
    }];
    __weak __typeof__(self) weakSelf = self;
    _dateArray = [XDDateSelectedModel returnDateSelectedWithType:_selectedDateType completion:^(NSInteger index) {
        [weakSelf.dateSelectedView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3* index, 0)];
        _index = index;
    }];
    
    if (_index >= _dateArray.count) {
        if (_dateArray.count > 0) {
            _index = _dateArray.count - 1;
        }else{
            _index = 0;
        }
    }
    
    _chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_dateArray.count, 0);
    [_chartScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _index, 0)];

    self.dateSelectedView.type = _selectedDateType;
    self.dateSelectedView.dateArr = _dateArray;
    
    [self setupChartPageView];

    
}

-(void)returnCustomStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    _dateArray = [NSArray arrayWithObjects:startDate,endDate, nil];
    _selectedDateType = DateSelectedCustom;
    
    self.dateSelectedView.type = _selectedDateType;
    self.dateSelectedView.dateArr = _dateArray;
    
    _chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    
    _currentPageView.type = _selectedDateType;
    _currentPageView.dateArr = _dateArray;
    _currentPageView.x = 0;
    
    _lastPageView.x = -SCREEN_WIDTH;
    _nextPageView.x = SCREEN_WIDTH;
    
    
    
  }

-(void)returnSaveBtnClick{
    [self tapClick];
}

-(void)setupChartPageView{
    
    if (_index >= _dateArray.count) {
        if (_dateArray.count > 0) {
            _index = _dateArray.count - 1;
        }else{
            _index = 0;
        }
    }
    _currentPageView.type = _selectedDateType;
    _lastPageView.type = _selectedDateType;
    _nextPageView.type = _selectedDateType;
    
  
    if (_selectedDateType == DateSelectedWeek) {
        
        if (_dateArray.count == 3) {
            NSDate* lastDate = [_dateArray[0] firstObject];
            NSDate* nextDate = [_dateArray[2] firstObject];
            NSDate* currentdate = [_dateArray[1] firstObject];
            
            _currentPageView.date = currentdate;
            _lastPageView.date = lastDate;
            _nextPageView.date = nextDate;
            
            
            _currentPageView.x = SCREEN_WIDTH;
            _lastPageView.x =0;
            _nextPageView.x = SCREEN_WIDTH * 2;
            
            
            return;
        }
        
        _currentPageView.x = SCREEN_WIDTH*_index;
        _lastPageView.x = SCREEN_WIDTH * (_index - 1);
        _nextPageView.x = SCREEN_WIDTH * (_index + 1);
        
        NSDate* currentdate = [_dateArray[_index] firstObject];
        _currentPageView.date = currentdate;

        if (_dateArray.count == 1) {
            return;
        }else{
            if (_index == 0) {
                NSDate* nextDate = [_dateArray[_index + 1] firstObject];
                _nextPageView.date = nextDate;
                return;
            }else if (_index ==  _dateArray.count-1){
                NSDate* lastDate = [_dateArray[_index - 1] firstObject];
                _lastPageView.date = lastDate;
                return;
            }
        }
        
        NSDate* lastDate = [_dateArray[_index - 1] firstObject];
        NSDate* nextDate = [_dateArray[_index + 1] firstObject];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
        
    }else{
       

        if (_dateArray.count == 3) {
            NSDate* lastDate = _dateArray[0];
            NSDate* nextDate = _dateArray[2];
            NSDate* currentdate = _dateArray[1];
            
            _currentPageView.date = currentdate;
            _lastPageView.date = lastDate;
            _nextPageView.date = nextDate;
            
            
            _currentPageView.x = SCREEN_WIDTH;
            _lastPageView.x =0;
            _nextPageView.x = SCREEN_WIDTH * 2;
            
            
            return;
        }
        
        
        _currentPageView.x = SCREEN_WIDTH*_index;
        _lastPageView.x = SCREEN_WIDTH * (_index - 1);
        _nextPageView.x = SCREEN_WIDTH * (_index + 1);
        
        NSDate* currentdate = _dateArray[_index];
        _currentPageView.date = currentdate;
        
        if (_dateArray.count == 1) {
            return;
        }else{
            if (_index == 0) {
                NSDate* nextDate = _dateArray[_index + 1];
                _nextPageView.date = nextDate;
                return;
            }else if (_index ==  _dateArray.count-1){
                NSDate* lastDate = _dateArray[_index - 1];
                _lastPageView.date = lastDate;
                return;
            }
        }
        
        NSDate* lastDate = _dateArray[_index - 1];
        NSDate* nextDate = _dateArray[_index + 1];
        
        _lastPageView.date = lastDate;
        _nextPageView.date = nextDate;
        
    }
}


@end

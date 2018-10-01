//
//  XDChartPageView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/2/26.
//

#import "XDChartPageView.h"
#import "XDChartView.h"
#import "XDChartDataClass.h"
#import "XDPieChartView.h"

@interface XDChartPageView()
{
    UIView* _btnBackView;
    
    XDChartView* _currentChartView;
    XDChartView* _lastChartView;
    XDChartView* _nextChartView;
    
    UIButton* _currentBtn;
    UILabel* _titleLabel;
    
    UIImageView* _redView;
    UIImageView* _greenView;
    UIImageView* _blueView;
    UIView* _moveView;
}

@property(nonatomic, strong)XDPieChartView * expensePieChartView;
@property(nonatomic, strong)XDPieChartView * incomePieChartView;
@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)UIImageView * emptyImageView;


@end
@implementation XDChartPageView
@synthesize type;

-(XDPieChartView *)expensePieChartView{
    if (!_expensePieChartView) {
        _expensePieChartView = [XDPieChartView buttonWithType:UIButtonTypeCustom];
        _expensePieChartView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH/2, self.height - CGRectGetMaxY(self.scrollView.frame));
        _expensePieChartView.tag = 0;
        [_expensePieChartView addTarget:self action:@selector(pieDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expensePieChartView;
}

-(XDPieChartView *)incomePieChartView{
    if (!_incomePieChartView) {
        _incomePieChartView = [XDPieChartView buttonWithType:UIButtonTypeCustom];
        _incomePieChartView.frame = CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH/2, self.height - CGRectGetMaxY(self.scrollView.frame));
        _incomePieChartView.tag = 1;
        [_incomePieChartView addTarget:self action:@selector(pieDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _incomePieChartView;
}

-(UIImageView *)emptyImageView{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty state7"]];
        _emptyImageView.contentMode = UIViewContentModeCenter;
        _emptyImageView.backgroundColor = [UIColor whiteColor];
        _emptyImageView.hidden = YES;
        _emptyImageView.userInteractionEnabled = YES;
        _emptyImageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self bringSubviewToFront:_emptyImageView];
    }
    return _emptyImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
     
       
        if (IS_IPHONE_5) {
            _moveView = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 20)/3+4, 39)];
            _redView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 20)/3+4, 39)];
            _greenView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 20)/3+4, 39)];
            _blueView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 20)/3+4, 39)];
            _blueView.image = [UIImage imageNamed:@"blue_se"];
            _greenView.image = [UIImage imageNamed:@"green_se"];
            _redView.image = [UIImage imageNamed:@"red_se"];
        }else if(IS_IPHONE_X){
            _moveView = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _redView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _greenView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _blueView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _blueView.image = [UIImage imageNamed:@"blue_plus"];
            _greenView.image = [UIImage imageNamed:@"green_plus"];
            _redView.image = [UIImage imageNamed:@"red_plus"];
        }else{
            _moveView = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _redView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _greenView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _blueView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, (SCREEN_WIDTH - 30)/3+4, 39)];
            _blueView.image = [UIImage imageNamed:@"blue_plus"];
            _greenView.image = [UIImage imageNamed:@"green_plus"];
            _redView.image = [UIImage imageNamed:@"red_plus"];
        }
        _redView.hidden = _greenView.hidden = YES;
        _moveView.layer.cornerRadius = 16;
        _moveView.layer.masksToBounds = YES;
        _moveView.backgroundColor = [UIColor clearColor];
        
        _redView.layer.cornerRadius = 16;
        _redView.layer.masksToBounds = YES;
//        _redView.backgroundColor = RGBColor(245, 115, 100);
        
    
        [_moveView addSubview:_redView];
        
        _greenView.layer.cornerRadius = 16;
        _greenView.layer.masksToBounds = YES;
//        _greenView.backgroundColor = RGBColor(57, 216, 139);
        [_moveView addSubview:_greenView];
        
        _blueView.layer.cornerRadius = 16;
        _blueView.layer.masksToBounds = YES;
//        _blueView.backgroundColor = RGBColor(113, 163, 245);
        [_moveView addSubview:_blueView];
        
        [self setupBtn];

        [self addSubview:self.expensePieChartView];
        [self addSubview:self.incomePieChartView];
        
        UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH, 0.5)];
        line1.backgroundColor  = RGBColor(226, 226, 226);
        [self addSubview:line1];

        UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), 0.5, self.height - self.scrollView.height)];
        line2.centerX = self.width/2;
        line2.backgroundColor  = RGBColor(226, 226, 226);
        [self addSubview:line2];
        
        [self addSubview:self.emptyImageView];

    }
    return self;
}

-(void)pieDetailClick:(XDPieChartView*)view{
    
    if (view.tag == 0) {
        if ([self.delegate respondsToSelector:@selector(returnPieViewDataArray:pieType:)]) {
            [self.delegate returnPieViewDataArray:self.expensePieChartView.dataArray pieType:@"EXPENSE"];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(returnPieViewDataArray:pieType:)]) {
            [self.delegate returnPieViewDataArray:self.incomePieChartView.dataArray pieType:@"INCOME"];
        }
    }
}

-(void)setAccount:(Accounts *)account{
    _account = account;
    
    if (_date) {
        _dateArr = nil;
        [[XDDataManager shareManager].backgroundContext performBlock:^{
            XDChartModel* lastModel = [XDChartDataClass modelWithDate:_date dateType:type chartType:0 account:_account];
            
            XDChartModel* currentModel = [XDChartDataClass modelWithDate:_date dateType:type chartType:1 account:_account];
            
            XDChartModel* nextModel = [XDChartDataClass modelWithDate:_date dateType:type chartType:2 account:_account];
            dispatch_async(dispatch_get_main_queue(), ^{
                _nextChartView.model = nextModel;
                _currentChartView.model = currentModel;
                _lastChartView.model = lastModel;
                
                if (nextModel.hasData || lastModel.hasData || currentModel.hasData) {
                    self.emptyImageView.hidden = YES;
                }else{
                    self.emptyImageView.hidden = NO;
                }
            });

        }];
        
       
        
        switch (type) {
            case DateSelectedWeek:
                _titleLabel.text = @"Day";
                break;
            case DateSelectedMonth:
                _titleLabel.text = @"Day";
                break;
            case DateSelectedYear:
                _titleLabel.text = @"Month";
                break;
            default:
                break;
        }
        
        self.expensePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_date endDate:nil dateType:type tranType:@"EXPENSE" account:_account];
        self.incomePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_date endDate:nil dateType:type tranType:@"INCOME" account:_account];
    }
    
    if (_dateArr) {
        XDChartModel* lastModel = [XDChartDataClass modelWithStartDate:_dateArr.firstObject endDate:_dateArr.lastObject chartType: 0 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        XDChartModel* currentModel = [XDChartDataClass modelWithStartDate:_dateArr.firstObject endDate:_dateArr.lastObject chartType: 1 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        XDChartModel* nextModel = [XDChartDataClass modelWithStartDate:_dateArr.firstObject endDate:_dateArr.lastObject chartType: 2 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        _lastChartView.model = lastModel;
        _currentChartView.model = currentModel;
        _nextChartView.model = nextModel;

        double value = 0;
        for (NSNumber* number in lastModel.dataMuArr) {
            if ([number doubleValue] != 0) {
                value = [number doubleValue];
            }
        }
        for (NSNumber* number in currentModel.dataMuArr) {
            if ([number doubleValue] != 0) {
                value = [number doubleValue];
            }
        }
        for (NSNumber* number in nextModel.dataMuArr) {
            if ([number doubleValue] != 0) {
                value = [number doubleValue];
            }
        }
        
        
        if (value == 0) {
            self.emptyImageView.hidden = NO;
        }else{
            self.emptyImageView.hidden = YES;
        }
        
        
        self.expensePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_dateArr.firstObject endDate:_dateArr.lastObject dateType:type tranType:@"EXPENSE" account:_account];
        self.incomePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_dateArr.firstObject endDate:_dateArr.lastObject dateType:type tranType:@"INCOME" account:_account];
    }
    
    
   
}

-(void)setDate:(NSDate *)date{
    _date = date;
    
    if (date) {
        _dateArr = nil;
        
            [[XDDataManager shareManager].backgroundContext performBlock:^{
                //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                XDChartModel* lastModel = [XDChartDataClass modelWithDate:date dateType:type chartType:0 account:_account];
                //            _lastChartView.model = lastModel;
                
                XDChartModel* currentModel = [XDChartDataClass modelWithDate:date dateType:type chartType:1 account:_account];
                //            _currentChartView.model = currentModel;
                
                XDChartModel* nextModel = [XDChartDataClass modelWithDate:date dateType:type chartType:2 account:_account];
                //            _nextChartView.model = nextModel;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _nextChartView.model = nextModel;
                    _currentChartView.model = currentModel;
                    _lastChartView.model = lastModel;
                    _lastChartView.date = _nextChartView.date = _currentChartView.date = _date;
                    _lastChartView.dateArray = _nextChartView.dateArray = _currentChartView.dateArray = nil;
                    if (nextModel.hasData || lastModel.hasData || currentModel.hasData) {
                        self.emptyImageView.hidden = YES;
                    }else{
                        self.emptyImageView.hidden = NO;
                    }
                });
            }];

        };
        
        switch (type) {
            case DateSelectedWeek:
                _titleLabel.text = @"Day";
                break;
            case DateSelectedMonth:
                _titleLabel.text = @"Day";
                break;
            case DateSelectedYear:
                _titleLabel.text = @"Month";
                break;
            default:
                break;
        }
    
    _lastChartView.dateStr = _nextChartView.dateStr = _currentChartView.dateStr = _titleLabel.text;

    
    
    self.expensePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_date endDate:nil dateType:type tranType:@"EXPENSE" account:_account];
    self.incomePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:_date endDate:nil dateType:type tranType:@"INCOME" account:_account];
}

-(void)setDateArr:(NSArray *)dateArr{
    _dateArr = dateArr;
    if (dateArr) {
        _date = nil;
        XDChartModel* lastModel = [XDChartDataClass modelWithStartDate:dateArr.firstObject endDate:dateArr.lastObject chartType: 0 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        _lastChartView.date = _date;
        _lastChartView.dateStr = _titleLabel.text;
        _lastChartView.model = lastModel;
        _lastChartView.dateArray = dateArr;
        XDChartModel* currentModel = [XDChartDataClass modelWithStartDate:dateArr.firstObject endDate:dateArr.lastObject chartType: 1 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        _currentChartView.date = _date;
        _currentChartView.dateStr = _titleLabel.text;
        _currentChartView.model = currentModel;
        _currentChartView.dateArray = dateArr;
        XDChartModel* nextModel = [XDChartDataClass modelWithStartDate:dateArr.firstObject endDate:dateArr.lastObject chartType: 2 account:_account type:^(NSString *title) {
            _titleLabel.text = title;
        }];
        _nextChartView.date = _date;
        _nextChartView.dateStr = _titleLabel.text;
        _nextChartView.dateArray = dateArr;
        _nextChartView.model = nextModel;
        
        self.expensePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:dateArr.firstObject  endDate:dateArr.lastObject dateType:type tranType:@"EXPENSE" account:_account];
        self.incomePieChartView.dataArray = [XDChartDataClass pieCategoryWithDate:dateArr.firstObject endDate:dateArr.lastObject dateType:type tranType:@"INCOME" account:_account];
    }
}

-(void)setupBtn{
    if (IS_IPHONE_5) {
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 13, SCREEN_WIDTH - 20, 30)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 235)];
    }else if(IS_IPHONE_X){
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 29, SCREEN_WIDTH - 30, 30)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 327)];
    }else if(IS_IPHONE_6PLUS){
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 30)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 327)];
    }else{
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 30)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 280)];
    }
    _btnBackView.layer.cornerRadius = 15;
    _btnBackView.layer.masksToBounds = YES;
    _btnBackView.clipsToBounds = NO;
    _btnBackView.backgroundColor = RGBColor(230, 230, 230);
    
    [_btnBackView addSubview:_moveView];
    [self addSubview:_btnBackView];
    
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
    
    
    _lastChartView = [[XDChartView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, self.scrollView.height)];
    _lastChartView.chartType = ExpenseChart;
    
    [self.scrollView addSubview:_lastChartView];
    
    _currentChartView = [[XDChartView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, [UIScreen mainScreen].bounds.size.width, self.scrollView.height)];
    _currentChartView.chartType = IncomeChart;
    
    [self.scrollView addSubview:_currentChartView];
    
    _nextChartView = [[XDChartView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.scrollView.height)];
    _nextChartView.chartType = BalanceChart;
    
    [self.scrollView addSubview:_nextChartView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    _titleLabel.font = [UIFont fontWithName:FontPingFangRegular size:14];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.center = CGPointMake(SCREEN_WIDTH/2, 0);
    if (IS_IPHONE_X) {
         _titleLabel.y = CGRectGetMaxY(self.scrollView.frame)-35;
    }else if(IS_IPHONE_5){
        _titleLabel.y = CGRectGetMaxY(self.scrollView.frame)-18;

    }else{
         _titleLabel.y = CGRectGetMaxY(self.scrollView.frame)-25;
    }
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self bringSubviewToFront:_titleLabel];
    [self addSubview:_titleLabel];
    
    CGFloat width;
    if (IS_IPHONE_5) {
         width = (SCREEN_WIDTH - 20)/3;
    }else if(IS_IPHONE_X){
         width = (SCREEN_WIDTH - 30)/3;
    }else{
         width = (SCREEN_WIDTH - 30)/3;
    }
    
    for (int i = 0; i < 3; i++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 30)];
        btn.layer.cornerRadius = 16;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:FontSFUITextRegular size:14];
        btn.tag = i;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBackView addSubview:btn];
        btn.backgroundColor = [UIColor clearColor];
        
        if (btn.tag == 0) {
            [btn setTitle:NSLocalizedString(@"VC_NetWorth", nil) forState:UIControlStateNormal];
            [_moveView bringSubviewToFront:_blueView];
        }else if (btn.tag == 1){
            [btn setTitle:NSLocalizedString(@"VC_Expense", nil) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"VC_Income", nil) forState:UIControlStateNormal];
        }
        
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;;
    }
}


-(void)btnClick:(UIButton*)btn{
    _redView.hidden = _greenView.hidden = _blueView.hidden = YES;

    [UIView animateWithDuration:0.2 animations:^{
        _moveView.x = btn.x;
        if (btn.tag == 0) {
            [_moveView bringSubviewToFront:_blueView];
            _blueView.hidden = NO;
        }else if (btn.tag == 1){
            [_moveView bringSubviewToFront:_redView];
            _redView.hidden = NO;
        }else{
            [_moveView bringSubviewToFront:_greenView];
            _greenView.hidden = NO;
        }
    }];
    
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * btn.tag, 0) animated:YES];
}

-(void)scrollToNetworth{
    if (self.scrollView.contentOffset.x != 0) {
        _redView.hidden = _greenView.hidden = _blueView.hidden = YES;

        _moveView.x = 0;
        _blueView.hidden = NO;

        [_moveView bringSubviewToFront:_blueView];

        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    
}

@end

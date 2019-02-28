//
//  XDAccountDetailViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/8.
//

#import "XDAccountDetailViewController.h"
#import "Accounts.h"
#import "SCAdView.h"
#import "XDAccountTableView.h"
#import "XDAddTransactionViewController.h"
#import "AccountCount.h"
#import "Transaction.h"
#import "Category.h"
#import "SearchRelatedViewController.h"
#import "PokcetExpenseAppDelegate.h"
@import Firebase;
@interface XDAccountDetailViewController ()<SCAdViewDelegate,XDAccountTableViewDelegate,XDAddTransactionViewDelegate,ADEngineControllerBannerDelegate>
{
    AccountCount* _currentAccount;
    SCAdView * _adView;

}
@property(nonatomic, strong)ADEngineController* interstitial;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, strong)XDAccountTableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton *reconcileBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideCleardBtn;
@property(nonatomic, strong)UIView * backCoverView;
@property(nonatomic, strong)UIView * datePickerView;
@property(nonatomic, strong)UIDatePicker * datePicker;
@property(nonatomic, strong)Transaction * currentTransication;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *adBannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeight;
@property(nonatomic, strong)ADEngineController* adBanner;

@end

@implementation XDAccountDetailViewController

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
}

-(void)setAccount:(AccountCount *)account{
    _account = account;
    _currentAccount = account;
}


-(UIView *)backCoverView{
    if (!_backCoverView) {
        _backCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backCoverView.backgroundColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:1];
        _backCoverView.alpha = 0;
        _backCoverView.hidden = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapClick)];
        [_backCoverView addGestureRecognizer:tap];
        [self.view.window addSubview:_backCoverView];
    }
    return _backCoverView;
}

-(UIView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 256)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH, 180)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePickerView addSubview:_datePicker];
        //        [_datePicker setValue:RGBColor(113, 163, 245) forKey:@"textColor"];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 56)];
        label.centerX = SCREEN_WIDTH/2;
        label.font = [UIFont fontWithName:FontHelveticaNeueReguar size:17];
        label.text = @"Duplicate To Date";
        label.textAlignment = NSTextAlignmentCenter;
        [_datePickerView addSubview:label];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 52, 19, 37, 19)];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [btn setTitleColor: RGBColor(113, 163, 245) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FontHelveticaNeueReguar size:16];
        [btn addTarget: self action:@selector(duplicateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:btn];
        
        [self.view.window addSubview:_datePickerView];
    }
    return _datePickerView;
}
-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.backCoverView.alpha = 0;
        self.datePickerView.y = SCREEN_HEIGHT;
        
    }completion:^(BOOL finished) {
        self.backCoverView.hidden = YES;
        
    }];
    
}

-(void)duplicateBtnClick{
    [self tapClick];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_DUPL"];
    
    [appDelegate.epdc duplicateTransaction:self.currentTransication withDate:self.datePicker.date];
    
    [self addTransactionCompletion];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1103 - iPhone - Banner - AccountDetails" delegate:self];
            [_adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
    }
}


#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        self.tableView.height = SCREEN_HEIGHT - CGRectGetMaxY(_adView.frame) - (IS_IPHONE_X?90:51) - 50;
    }else{
        self.adBannerView.hidden = YES;
        self.tableView.height = SCREEN_HEIGHT - CGRectGetMaxY(_adView.frame) - (IS_IPHONE_X?90:51);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGBColor(218, 218, 218);
    [self.bottomView addSubview:lineView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addTransaction) image:[UIImage imageNamed:@"add_category"]];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [FIRAnalytics setScreenName:@"account_detail_view_iphone" screenClass:@"XDAccountDetailViewController"];

    self.title = _account.accountsItem.accName;
    
    [self setupCollectionView];
    
    [self.reconcileBtn setTitle:NSLocalizedString(@"VC_ReconcileOn", nil) forState:UIControlStateNormal];
    [self.reconcileBtn setTitle:NSLocalizedString(@"VC_ReconcileOff", nil) forState:UIControlStateSelected];
    
    [self.hideCleardBtn setTitle:NSLocalizedString(@"VC_ShowCleared", nil) forState:UIControlStateSelected];
    [self.hideCleardBtn setTitle:NSLocalizedString(@"VC_HideCleared", nil) forState:UIControlStateNormal];

    if (IS_IPHONE_X) {
        self.bottomConstraint.constant = 39;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTransactionCompletion) name:@"refreshUI" object:nil];

}

-(void)addTransaction{
    XDAddTransactionViewController* addVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
    addVc.calSelectedDate = [[NSDate date] initDate];
    addVc.account = _currentAccount.accountsItem;
    addVc.delegate = self;
    //            NSLog(@"selectedDate = %@", weakSelf.date);
    [self presentViewController:addVc animated:YES completion:nil];

}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupCollectionView{
    NSInteger index = [_dataArray indexOfObject:_account];
    
    _adView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
        builder.adArray = _dataArray;
        if (IS_IPHONE_5) {
            builder.viewFrame = (CGRect){0,64,SCREEN_WIDTH,140};
            builder.adItemSize = (CGSize){(SCREEN_WIDTH- 74)*0.9,120};

        }else if(IS_IPHONE_X){
            builder.viewFrame = (CGRect){0,88,SCREEN_WIDTH,170};
            builder.adItemSize = (CGSize){(SCREEN_WIDTH- 74)*0.9,150};

        }else{
            builder.viewFrame = (CGRect){0,64,SCREEN_WIDTH,170};
            builder.adItemSize = (CGSize){(SCREEN_WIDTH- 74)*0.9,150};

        }
        builder.secondaryItemMinAlpha = 0.6;
        builder.threeDimensionalScale = 1.1;
        builder.itemCellNibName = @"XDAccountCollectionViewCell";
        builder.allowedInfinite = NO;
        builder.minimumLineSpacing = 20;
        builder.index = index;
    }];
    _adView.backgroundColor = [UIColor whiteColor];
    _adView.delegate = self;
    [self.view addSubview:_adView];
    
    self.tableView = [[XDAccountTableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_adView.frame) , SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_adView.frame) - (IS_IPHONE_X?90:51)) style:UITableViewStylePlain];
    self.tableView.accounts = _currentAccount;
    self.tableView.xxdDelegate = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - XDAddTransactionViewDelegate
-(void)addTransactionCompletion{
    _currentAccount.defaultAmount = [self getAccountTransaction:_currentAccount.accountsItem] + [_currentAccount.accountsItem.amount doubleValue];
    _currentAccount.totalBalance = [self getAccountFilterTransaction:_currentAccount.accountsItem];
    
    [_adView reloadWithDataArray:self.dataArray];
    [self.tableView refreshUI];
}

-(double)getAccountFilterTransaction:(Accounts*)account{
    NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:account,@"incomeAccount",account,@"expenseAccount",nil];
    
    NSFetchRequest * fetchRequest = [[XDDataManager shareManager].managedObjectModel
                                     fetchRequestFromTemplateWithName:@"getAllTranscationByAccount" substitutionVariables:sub];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO]; // generate a description that describe which field you want to sort by
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError * error=nil;
    NSArray* objects = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSArray* filterArr = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isClear = 0"]];
    double filterAmount = 0;
    for (Transaction *transactions in filterArr) {
        if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
            if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                    filterAmount -= [transactions.amount doubleValue];
                }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
                    filterAmount += [transactions.amount doubleValue];
                }
                
            }else{
                if (transactions.incomeAccount == nil && transactions.expenseAccount) {
                    filterAmount -= [transactions.amount doubleValue];
                }else{
                    filterAmount += [transactions.amount doubleValue];
                }
            }
            
        }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
            if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                if (transactions.incomeAccount == account) {
                    filterAmount += [transactions.amount doubleValue];
                }else if (transactions.expenseAccount == account){
                    filterAmount -= [transactions.amount doubleValue];
                }
            }else{
                filterAmount -= [transactions.amount doubleValue];
            }
            
        }else{
            if (transactions.incomeAccount == account) {
                filterAmount += [transactions.amount doubleValue];
            }else if (transactions.expenseAccount == account){
                filterAmount -= [transactions.amount doubleValue];
            }
        }
    }
    
    return filterAmount;
}

-(double)getAccountTransaction:(Accounts*)account{
    NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:account,@"incomeAccount",account,@"expenseAccount",nil];
    
    NSFetchRequest * fetchRequest = [[XDDataManager shareManager].managedObjectModel
                                     fetchRequestFromTemplateWithName:@"getAllTranscationByAccount" substitutionVariables:sub];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO]; // generate a description that describe which field you want to sort by
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1]; // you can add more than one sort description
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError * error=nil;
    NSArray* objects = [[XDDataManager shareManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    double amount = 0;
    for (Transaction* transactions in objects) {
        if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
            if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                    amount -= [transactions.amount doubleValue];
                }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
                    amount += [transactions.amount doubleValue];
                }
                
            }else{
                if (transactions.incomeAccount == nil && transactions.expenseAccount) {
                    amount -= [transactions.amount doubleValue];
                }else{
                    amount += [transactions.amount doubleValue];
                }
            }
            
        }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
            if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                if (transactions.incomeAccount == account) {
                    amount += [transactions.amount doubleValue];
                }else if (transactions.expenseAccount == account){
                    amount -= [transactions.amount doubleValue];
                }
            }else{
                amount -= [transactions.amount doubleValue];
            }
        }else{
            if (transactions.incomeAccount == account) {
                amount += [transactions.amount doubleValue];
            }else if (transactions.expenseAccount == account){
                amount -= [transactions.amount doubleValue];
            }
        }
    }
    
    return amount;
}
#pragma mark - XDAccountTableViewDelegate
-(void)returnSelectedAccountTransaction:(Transaction *)transaction{
    XDAddTransactionViewController* tranVc = [[XDAddTransactionViewController alloc]initWithNibName:@"XDAddTransactionViewController" bundle:nil];
    tranVc.editTransaction = transaction;
    tranVc.delegate = self;
    [self presentViewController:tranVc animated:YES completion:nil];
}

-(void)returnSwipeBtn:(NSInteger)index withTran:(Transaction *)transaction{
    if (index == 0) {
        self.currentTransication = transaction;

        SearchRelatedViewController *searchRelatedViewController= [[SearchRelatedViewController alloc]initWithNibName:@"SearchRelatedViewController" bundle:nil];
        searchRelatedViewController.transaction = transaction;
        //        searchRelatedViewController.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:searchRelatedViewController animated:YES];
    }else if(index == 1){
        
        self.currentTransication = transaction;

        self.backCoverView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.backCoverView.alpha = 0.5;
            self.datePickerView.y = SCREEN_HEIGHT - 256;
        }];
    }else{
        [self addTransactionCompletion];
    }
}

#pragma mark - scadViewDelegate
-(void)sc_scrollToIndex:(NSInteger)index{
    AccountCount* acc = [_dataArray objectAtIndex:index];
    self.title = acc.accountsItem.accName;
    _currentAccount = acc;
    self.tableView.accounts = _currentAccount;

}

-(void)sc_didClickAd:(id)adModel{
    AccountCount* acc = adModel;
    self.title = acc.accountsItem.accName;
    _currentAccount = acc;
    self.tableView.accounts = _currentAccount;
}


- (IBAction)reconcileBtnClick:(id)sender {
    self.reconcileBtn.selected = !self.reconcileBtn.selected;
    self.tableView.recondile = self.reconcileBtn.selected;
    
    if (!self.reconcileBtn.selected) {
        [self addTransactionCompletion];
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (!self.reconcileBtn.selected) {
         [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_REC"];
        
        [self.interstitial showInterstitialAdWithTarget:self];

    }
}

- (IBAction)hideClearedBtnClick:(id)sender {
    self.hideCleardBtn.selected = !self.hideCleardBtn.selected;
    self.tableView.hide = self.hideCleardBtn.selected;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!self.hideCleardBtn.selected) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_HDCL"];
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //插页广告
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1203 - iPhone - Interstitial - ReconcileOFF"];
        }
    }
    return self;
}

@end

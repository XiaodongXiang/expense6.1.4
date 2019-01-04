//
//  XDAddTransactionViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/12.
//

#import "XDAddTransactionViewController.h"
#import "XDTransactionHelpClass.h"
#import "XDTransactionCatgroyView.h"
#import "XDTransactionAccountView.h"
#import "XDRepeatTableViewController.h"
#import "SelectImageViewController.h"
#import "XDTranscationNoteViewController.h"
#import "XDCategorySplitTableViewController.h"
#import "Transaction.h"
#import "EPNormalClass.h"
#import "Accounts.h"
#import "Category.h"
#import "Payee.h"
#import "CategorySelect.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>

#import "numberKeyboardView.h"
#import "XDTransactionPayeeCollectionView.h"
#import "XDEditTransCategorySplitTableViewController.h"
#import "EPDataBaseModifyClass.h"
#import "XDTransferAccountView.h"
#import "TransactionCategoryViewController.h"
#import "XDAddAccountViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "XDUpgradeViewController.h"
@import  Firebase;
@interface XDAddTransactionViewController ()<XDTransactionAccountViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,SelectImageViewDelegate,UIPickerViewDelegate,XDTransactionCatgroyViewDelegate,XDCategorySplitTableViewDelegate,XDTransactionPayeeCollectionViewDelegate,XDRepeatTableViewDelegate,XDTranscationNoteViewDelegate,SettingTransactionCategoryViewDelegate,XDAddAccountViewDelegate,UITextFieldDelegate>
{
    BOOL _todayShow;
    BOOL _repeatShow;
    BOOL _photoShow;
    BOOL _noteShow;
    
    BOOL _isFromAccount;
    
    UIView* _whiteView;
    UIColor* _threeBtnSelectedColor;
    UIPageControl *_pageControl;
    TransactionType _selectedType;
    NSString* _photoName;
    NSString* _documentsPath;
    NSString* _noteStr;
    
    CGFloat _noteHeight;
    
    Category* _selectedCategory;
    Accounts* _selectedAccount;
    
    NSMutableArray* _splitCategoryArr;
    
    Accounts* _fromAccount;
    Accounts* _toAccount;
    Payee* _selectedPayee;
    
    NSArray* _accountArray;
    
    NSString* _repeatStr;
    NSString* _amountStr;
    
    UIImageView* imageView;
    UIImageView* imageView1;
    UIImageView* imageView2;
    
    XDTransferAccountView* _fromAccountView;
    XDTransferAccountView* _toAccountView;

}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *categroyLbl;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIView *threeBtnCoverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *dayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearedCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *repeatCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noteCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *functionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *transformAccountCell;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UISwitch *clearedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;

@property (weak, nonatomic) IBOutlet UIButton *fromAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *toAccountBtn;


@property (weak, nonatomic) IBOutlet UILabel *clearedLbl;
@property (weak, nonatomic) IBOutlet UILabel *photoLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;


@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountDetailLbl;


@property (weak, nonatomic) IBOutlet UIButton *expenseBtn;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryIconBtn;



@property(nonatomic, strong)XDTransactionCatgroyView * categoryView;
@property(nonatomic, strong)XDTransactionAccountView * accountView;
@property(nonatomic, strong)UIView* accountCoverView;
@property(nonatomic, strong)numberKeyboardView * keyboard;
@property(nonatomic, strong)XDTransactionPayeeCollectionView * payeeView;

@property(nonatomic, strong)XDRepeatTableViewController * repeatVc;
@property (weak, nonatomic) IBOutlet UIView *categoryHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transLblHeight;

@property(nonatomic, strong)Category * otherCategory_expense;
@property(nonatomic, strong)Category* otherCategory_income;

@property (strong, nonatomic) IBOutlet UIView *categoryAccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *categorySplitBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryEditBtn;

@property(nonatomic, strong)UIView * categoryAllView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@property(nonatomic, strong)UIView * accountAllView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeBtnViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBtnTrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBackViewHeight;

@end

@implementation XDAddTransactionViewController
@synthesize calSelectedDate,editTransaction;

-(void)setAccount:(Accounts *)account{
    _account = account;
    
    
}
#pragma mark - lazy


-(XDTransactionPayeeCollectionView *)payeeView{
    if (!_payeeView) {
        _payeeView = [[XDTransactionPayeeCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _payeeView.payeeDelegate = self;
    }
    return _payeeView;
}

-(numberKeyboardView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
        __weak __typeof__(self) weakSelf = self;
        _keyboard.amountBlock = ^(NSString *string) {
//            NSLog(@"amount == %@",string);
            if ([string isEqualToString:@""]) {
                weakSelf.moneyTextField.text = string;
                [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_disabled"] forState:UIControlStateNormal];
                weakSelf.saveBtn.enabled = NO;
            }else if (![string isEqualToString:@"0.00"]) {
                weakSelf.moneyTextField.text = string;
                [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
                weakSelf.saveBtn.enabled = YES;

            }
        };
    }
    return _keyboard;
}

-(UIView *)categoryAllView{
    if (!_categoryAllView) {
        _categoryAllView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH + 78)];
        
        _categoryAllView.backgroundColor = [UIColor whiteColor];
        self.categoryAccessoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        [_categoryAllView addSubview:self.categoryAccessoryView];
        [self.view addSubview:_categoryAllView];
        [self.view bringSubviewToFront:_categoryAllView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH+60);
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:238/255. green:238/255. blue:238/255. alpha:1];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        
        _pageControl.numberOfPages = self.categoryView.numberOfSections;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        [_categoryAllView addSubview:_pageControl];
    }
    return _categoryAllView;
}

-(UIView *)accountAllView{
    if (!_accountAllView) {
        _accountAllView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 285 + 56)];
        _accountAllView.backgroundColor = [UIColor whiteColor];
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 100, 24)];
        lbl.centerX = SCREEN_WIDTH/2;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont fontWithName:FontSFUITextMedium size:17];
        lbl.textColor = RGBColor(85, 85, 85);
        lbl.text = NSLocalizedString(@"VC_Account", nil);
        [_accountAllView addSubview:lbl];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-49, 6, 44, 44);
        [btn setImage:[UIImage imageNamed:@"add-2"] forState:UIControlStateNormal];
        [_accountAllView addSubview:btn];
        [btn addTarget:self action:@selector(addAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_accountAllView addSubview: self.accountView];
        [self.view addSubview:_accountAllView];
        [self.view bringSubviewToFront:_accountAllView];

    }
    return _accountAllView;
}

-(Category *)otherCategory_expense{
    if (!_otherCategory_expense) {
        _otherCategory_expense = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1 and categoryType = %@",@"EXPENSE"] sortDescriptors:nil]lastObject];
        if (!_otherCategory_expense) {
            _otherCategory_expense = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName = %@ and categoryType = %@",@"Others",@"EXPENSE"] sortDescriptors:nil]lastObject];
            if (!_otherCategory_expense) {
                _otherCategory_expense = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryType = %@",@"EXPENSE"] sortDescriptors:nil]firstObject];
            }
        }
    }
    return _otherCategory_expense;
}

-(Category *)otherCategory_income{
    if (!_otherCategory_income) {
        _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1 and categoryType = %@",@"INCOME"] sortDescriptors:nil]lastObject];
        if (!_otherCategory_income) {
            _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryName = %@ and categoryType = %@",@"Others",@"INCOME"] sortDescriptors:nil]lastObject];
            if (!_otherCategory_income) {
                _otherCategory_income = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryType = %@",@"INCOME"] sortDescriptors:nil]firstObject];
            }
        }
    }
    return _otherCategory_income;
}

-(XDTransactionCatgroyView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[XDTransactionCatgroyView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, SCREEN_WIDTH)];
        _categoryView.transactionType = _selectedType;
        _categoryView.categoryDelegate = self;
        [self.categoryAllView addSubview:_categoryView];
    }
    
    return _categoryView;
}

-(XDTransactionAccountView *)accountView{
    if (!_accountView) {
        _accountView = [[XDTransactionAccountView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 285)];
      
        _accountView.accountDelegate = self;
    }
    return _accountView;
}

-(UIView *)accountCoverView{
    if (!_accountCoverView) {
        _accountCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _accountCoverView.backgroundColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:1];
        _accountCoverView.alpha = 0;
        [self.view addSubview:_accountCoverView];
        [self.view bringSubviewToFront:self.accountAllView];
        [self.view bringSubviewToFront:self.categoryAllView];

        _accountCoverView.hidden = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapClick)];
        [_accountCoverView addGestureRecognizer:tap];
    }
    return _accountCoverView;
}

#pragma mark -

- (IBAction)categroyBtnClick:(id)sender {
    [self categroyLblTap];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    for (CategorySelect* cs in _splitCategoryArr) {
//        NSLog(@"cs == %f",cs.amount);
//    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.payeeView reloadData];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.photoImageView.layer.cornerRadius = 10;
    self.photoImageView.layer.masksToBounds = YES;
    self.categroyLbl.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initLblName];

    
    self.moneyTextField.delegate = self;
    self.titleTextField.delegate = self;
    
    [self.moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.moneyTextField.inputView = self.keyboard;
    if (IS_IPHONE_X) {
        self.moneyTextField.inputView.transform = CGAffineTransformMakeTranslation(0, -34);
    }
    [self.titleTextField addTarget:self action:@selector(titleValueChange) forControlEvents:UIControlEventEditingChanged];
    
    _accountArray = [XDTransactionHelpClass getTransactionAccounts];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    _documentsPath = [paths objectAtIndex:0];
    
    [self setupTransferBtn];
    [self setupThreeBtnImageView];
    [self setUpThreeBtnView];
    
    if (!editTransaction) {
        [self newTransactionConfig];
    }else{
        [self editTransactionConfig];
    }
    self.payeeView.tranType = _selectedType;

//    UIScreenEdgePanGestureRecognizer *ges = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick:)];
//    // 指定左边缘滑动
//    ges.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:ges];
    if (IS_IPHONE_5) {
        self.threeBtnViewWidth.constant = 231;
        self.cancelBtnLeading.constant = 0;
        self.saveBtnTrailing.constant = 0;
        [self.threeBtnCoverView layoutSubviews];
    }
    
    if (IS_IPHONE_X) {
        self.navBackViewHeight.constant = 188;
    }
    
    self.titleTextField.inputAccessoryView = self.payeeView;

//    if ([[calSelectedDate initDate] compare:[[NSDate date]initDate]] == NSOrderedSame) {
//        self.datePickerLabel.text = @"Today";
//    }else{
//        self.datePickerLabel.text = [self returnInitDate:calSelectedDate];
//    }
    self.tableView.separatorColor = RGBColor(226, 226, 226);
    [FIRAnalytics setScreenName:@"add_transaction_view_iphone" screenClass:@"XDAddTransactionViewController"];

}



-(void)setupTransferBtn{
    self.fromAccountBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2+10, 115);
    self.toAccountBtn.frame = CGRectMake( SCREEN_WIDTH/2-11, 0, SCREEN_WIDTH/2+10, 115);

    _fromAccountView = [[[NSBundle mainBundle]loadNibNamed:@"XDTransferAccountView" owner:self options:nil]lastObject];
    _fromAccountView.centerX = self.fromAccountBtn.width/2;
    _fromAccountView.y = 0;
    _fromAccountView.isFrom = YES;
    [self.fromAccountBtn addSubview:_fromAccountView];
    
    _toAccountView = [[[NSBundle mainBundle]loadNibNamed:@"XDTransferAccountView" owner:self options:nil]lastObject];
    _toAccountView.centerX = self.toAccountBtn.width/2;
    _toAccountView.y = 0;
    _toAccountView.isFrom = NO;

    [self.toAccountBtn addSubview:_toAccountView];
    
}

-(void)setupThreeBtnImageView{
    
    CGFloat width = SCREEN_WIDTH/3;
    _repeatBtn.frame = CGRectMake(0, 0, width, 56);
    _photoBtn.frame = CGRectMake(width, 0, width, 56);
    _noteBtn.frame = CGRectMake(width*2, 0, width, 56);
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circulation"]];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    imageView.center = CGPointMake(_repeatBtn.width/2, _repeatBtn.height/2);
    [_repeatBtn addSubview:imageView];
    
    imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"camera"]];
    imageView1.frame = CGRectMake(0, 0, 30, 30);
    imageView1.center = CGPointMake(_photoBtn.width/2, _photoBtn.height/2);
    [_photoBtn addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remark"]];
    imageView2.frame = CGRectMake(0, 0, 30, 30);
    imageView2.center = CGPointMake(_noteBtn.width/2, _noteBtn.height/2);
    [_noteBtn addSubview:imageView2];
    
}

-(void)editTransactionConfig{
    
    [self.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];

    self.datePickerLabel.text = [self returnInitDate:editTransaction.dateTime];
    
    self.datePicker.date = editTransaction.dateTime?:[NSDate date];
        
    _clearedSwitch.on = [editTransaction.isClear boolValue];
  
    _selectedPayee = editTransaction.payee;

    if (editTransaction.childTransactions.count > 0) {
        
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_mind_white"] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
        [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:@"icon_mind"]] forState:UIControlStateSelected];
        _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
        
        [self.categroyLbl setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];
        self.repeatBtn.hidden = YES;
//        self.moneyTextField.enabled = NO;
        _splitCategoryArr = [NSMutableArray array];
        NSMutableArray* muArr = [NSMutableArray array];
        for (Transaction* childTrans in editTransaction.childTransactions) {
            if ([childTrans.state isEqualToString:@"1"]) {
                CategorySelect* cs = [[CategorySelect alloc]init];
                cs.category = childTrans.category;
                cs.amount = [childTrans.amount doubleValue];
                [muArr addObject:cs];
            }
        }
        [_splitCategoryArr addObjectsFromArray:[muArr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"category.categoryName" ascending:YES]]]];
        
    }else{
        if (editTransaction.category) {
            _selectedCategory = editTransaction.category;
            [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
            self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
            _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
            [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
        }else{
            _selectedCategory = nil;
        }
    }
    _todayShow = NO;
    
    if (![editTransaction.recurringType isEqualToString:@"Never"]) {
        _repeatShow = YES;
        self.repeatBtn.hidden = YES;
        
        _repeatStr = editTransaction.recurringType;
        self.repeatDetailLabel.text = _repeatStr;
        
    }else{
        _repeatStr = editTransaction.recurringType;
        _repeatShow = NO;
    }
    
    if (editTransaction.photoName) {
        _photoShow = YES;
        _photoName = editTransaction.photoName;
        self.photoBtn.hidden = YES;
        
        UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", _documentsPath, _photoName]];
        UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
        
        self.photoImageView.image = imaged;
    }else{
        _photoShow = NO;
    }
    
    if (editTransaction.notes.length > 0) {
        _noteShow = YES;
        _noteStr = editTransaction.notes;
        self.noteLabel.text = _noteStr;
        _noteHeight = [self returnNoteHeight:editTransaction.notes];
        self.noteBtn.hidden = YES;
    }else{
        _noteShow = NO;
    }
    UIButton* btn ;
    if ([editTransaction.transactionType isEqualToString:@"expense"] || ((editTransaction.expenseAccount != nil && editTransaction.incomeAccount == nil) && [editTransaction.category.categoryType isEqualToString:@"EXPENSE"])) {
        
//        [self itemClick:self.expenseBtn];
        btn = self.expenseBtn;
        _selectedAccount = editTransaction.expenseAccount;
//        self.clearedSwitch.on = _account?[_selectedAccount.autoClear boolValue]:[editTransaction.isClear boolValue];
        self.accountDetailLbl.text = _selectedAccount.accName;
        _selectedType = TransactionExpense;
        _selectedCategory = editTransaction.category?:self.otherCategory_expense;
        
//        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
//        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//        _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//        [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
//        
//        
        if (editTransaction.expenseAccount && editTransaction.incomeAccount && editTransaction.category == nil ) {
            _fromAccount = editTransaction.expenseAccount;
            _toAccount = editTransaction.incomeAccount;
            _selectedType = TranscationTransfer;
            _fromAccountView.account = _fromAccount;
            _toAccountView.account = _toAccount;
            btn = self.balanceBtn;
            [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];
            [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"iocn_transfer"] forState:UIControlStateNormal];

//            if (editTransaction.payee) {
//                if ([editTransaction.payee.category.categoryType isEqualToString:@"EXPENSE"]) {
//                    btn = self.expenseBtn;
//                    _selectedAccount = editTransaction.expenseAccount;
//                    //            self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    self.accountDetailLbl.text = _selectedAccount.accName;
//                    _selectedType = TransactionExpense;
//                    _selectedCategory = editTransaction.payee.category;
//                }else if([editTransaction.payee.category.categoryType isEqualToString:@"INCOME"]){
//                    btn = self.incomeBtn;
//                    _selectedAccount = editTransaction.incomeAccount;
//                    self.accountDetailLbl.text = _selectedAccount.accName;
//                    //                    self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    _selectedType = TransactionIncome;
//                    _selectedCategory = editTransaction.payee.category;
//
//                }
//                
//                [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
//                self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
//                
//            }
        }else if(editTransaction.expenseAccount && editTransaction.category == nil ){
            btn = self.expenseBtn;
            _selectedAccount = editTransaction.expenseAccount;
            self.accountDetailLbl.text = _selectedAccount.accName;
            _selectedType = TransactionExpense;
            _fromAccount = nil;
            _toAccount = nil;
            
            
            [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_mind_white"] forState:UIControlStateNormal];
            self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
            [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:@"icon_mind"]] forState:UIControlStateSelected];
            _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
            [self.categroyLbl setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];;
            self.repeatBtn.hidden = YES;
            self.categoryLblHeight.constant = 17;
//            if (editTransaction.payee) {
//                if ([editTransaction.payee.category.categoryType isEqualToString:@"EXPENSE"]) {
//                    btn = self.expenseBtn;
//                    _selectedAccount = editTransaction.expenseAccount;
//                    //            self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    self.accountDetailLbl.text = _selectedAccount.accName;
//                    _selectedType = TransactionExpense;
//                    _selectedCategory = editTransaction.payee.category;
//
//                }else if([editTransaction.payee.category.categoryType isEqualToString:@"INCOME"]){
//                    btn = self.incomeBtn;
//                    _selectedAccount = editTransaction.incomeAccount;
//                    self.accountDetailLbl.text = _selectedAccount.accName;
//                    //                    self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    _selectedType = TransactionIncome;
//                    _selectedCategory = editTransaction.payee.category;
//
//                }
//
//                [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
//                self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
//
//            }
        }
    }else if ([editTransaction.transactionType isEqualToString:@"income"] || ((editTransaction.expenseAccount == nil && editTransaction.incomeAccount != nil) && [editTransaction.category.categoryType isEqualToString:@"INCOME"])){
//        [self itemClick:self.incomeBtn];
        btn = self.incomeBtn;
        _selectedAccount = editTransaction.incomeAccount;
        self.accountDetailLbl.text = _selectedAccount.accName;
//        self.clearedSwitch.on =_account?[_selectedAccount.autoClear boolValue]:[editTransaction.isClear boolValue];
        _selectedType = TransactionIncome;
        _selectedCategory = editTransaction.category?:self.otherCategory_income;
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
        _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
        [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];

        
        if ([editTransaction.category.categoryType isEqualToString:@"EXPENSE"]) {
            btn = self.expenseBtn;
            _selectedAccount = editTransaction.expenseAccount;
//            self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
            self.accountDetailLbl.text = _selectedAccount.accName;
            _selectedType = TransactionExpense;
        }

        if (editTransaction.expenseAccount && editTransaction.incomeAccount  && editTransaction.category == nil ) {
            _fromAccount = editTransaction.expenseAccount;
            _toAccount = editTransaction.incomeAccount;
            _selectedType = TranscationTransfer;
            _fromAccountView.account = _fromAccount;
            _toAccountView.account = _toAccount;
            btn = self.balanceBtn;
            _selectedCategory = nil;
            [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];
            [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"iocn_transfer"] forState:UIControlStateNormal];
            self.navigationBarView.backgroundColor = [UIColor colorWithHexString:@"71A3F5"];
            [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];
            
            
//            if (editTransaction.payee.category) {
//                if ([editTransaction.payee.category.categoryType isEqualToString:@"EXPENSE"]) {
//                    btn = self.expenseBtn;
//                    _selectedAccount = editTransaction.expenseAccount;
//                    //            self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    self.accountDetailLbl.text = _selectedAccount.accName;
//                    _selectedType = TransactionExpense;
//                    _selectedCategory = editTransaction.payee.category;
//
//                }else if([editTransaction.payee.category.categoryType isEqualToString:@"INCOME"]){
//                    btn = self.incomeBtn;
//                    _selectedAccount = editTransaction.incomeAccount;
//                    self.accountDetailLbl.text = _selectedAccount.accName;
////                    self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
//                    _selectedType = TransactionIncome;
//                    _selectedCategory = editTransaction.payee.category;
//
//                }
//                
//                [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
//                self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
//                [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
//                
//            }
        }
    }else{
        btn = self.balanceBtn;
//        [self itemClick:self.balanceBtn];
        _fromAccount = editTransaction.expenseAccount;
        _toAccount = editTransaction.incomeAccount;
        _fromAccountView.account = _fromAccount;
        _toAccountView.account = _toAccount;
        _selectedType = TranscationTransfer;
        [self.categroyLbl setTitle:nil forState:UIControlStateNormal];

        self.clearedSwitch.on = [_fromAccount.autoClear boolValue];

        [UIView animateWithDuration:0.2 animations:^{
            self.categoryLblHeight.constant = 0.001;
            self.transLblHeight.constant = 35;
        }];
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"iocn_transfer"] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor colorWithHexString:@"71A3F5"];
        [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];
        
        if (editTransaction.expenseAccount && editTransaction.incomeAccount == nil) {
            btn = self.expenseBtn;
            _selectedAccount = editTransaction.expenseAccount;
            self.accountDetailLbl.text = _selectedAccount.accName;
            _selectedType = TransactionExpense;
            _fromAccount = nil;
            _toAccount = nil;
            
            
            [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_mind_white"] forState:UIControlStateNormal];
            self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
            [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:@"icon_mind"]] forState:UIControlStateSelected];
            _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
            [self.categroyLbl setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];;
            self.repeatBtn.hidden = YES;
            self.categoryLblHeight.constant = 17;
        }
    }
    
    for (UIView* view in self.threeBtnCoverView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)view;
            button.selected = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    btn.selected = YES;
    [btn setTitleColor:_threeBtnSelectedColor forState:UIControlStateNormal];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (IS_IPHONE_5) {
            if (btn.tag == 1) {
                _whiteView.centerX = 231/2;
            }else if(btn.tag == 2){
                _whiteView.centerX = 231 - 77/2;
            }
        }else{
            _whiteView.centerX = btn.centerX;
        }
    }];
    
    _amountStr = [NSString stringWithFormat:@"%.2f",[editTransaction.amount doubleValue]];
    self.moneyTextField.text = _amountStr;
    self.keyboard.oldAmountString = _amountStr;
    self.titleTextField.text = editTransaction.payee.name;
    
    NSMutableArray* muArr = [NSMutableArray array];
    for (UIView* view in self.functionCell.contentView.subviews) {
        if (view.hidden == NO) {
            [muArr addObject:view];
        }
    }
    CGFloat width = SCREEN_WIDTH / muArr.count;
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    NSArray* array = [muArr sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = 0; i < array.count; i++) {
        UIView* view = array[i];
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(width*i, 0, width, 56);
            UIImageView* imageview = view.subviews.lastObject;
            imageview.centerX = view.width/2;
        }];
    }
    
    [self.tableView reloadData];
}

-(void)newTransactionConfig{
    [self.titleTextField becomeFirstResponder];
    
    _todayShow = NO;
    _repeatShow = NO;
    _photoShow = NO;
    _noteShow = NO;
    _noteHeight = 26.f;
    _photoName = nil;
    if (_account) {
        _selectedAccount = _account;
    }else{

        _selectedAccount = [[_accountArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"others = %@",@"Default"]]lastObject];
        if (_selectedAccount == nil) {
            _selectedAccount = _accountArray.firstObject;
        }

    }
    self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
    self.accountDetailLbl.text = _selectedAccount.accName?:NSLocalizedString(@"VC_Account", nil);
    self.accountView.transAccount = _selectedAccount;
    _selectedType = TransactionExpense;
    _selectedCategory = self.otherCategory_expense;
    [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
    self.datePicker.date = [calSelectedDate dateAndTime];
    
    self.datePickerLabel.text = [self returnInitDate:calSelectedDate];
    _fromAccount = nil;
    _toAccount = nil;
    _repeatStr = @"Never";
    _selectedPayee = nil;
    self.repeatDetailLabel.text = _repeatStr;
    _selectedCategory = self.otherCategory_expense;
    [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
    self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
    _threeBtnSelectedColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
    [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
}

-(void)initLblName{
    self.dayLabel.text = NSLocalizedString(@"VC_Date", nil);
    self.accountLbl.text = NSLocalizedString(@"VC_Account", nil);
    self.repeatLabel.text = NSLocalizedString(@"VC_Repeat", nil);
    self.clearedLbl.text = NSLocalizedString(@"VC_Cleared", nil);
    self.photoLbl.text = NSLocalizedString(@"VC_Photo", nil);
    self.titleTextField.placeholder =  NSLocalizedString(@"VC_Payee", nil);
    [self.categroyLbl setTitle: NSLocalizedString(@"VC_Category", nil) forState:UIControlStateNormal];

    [self.titleTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    [self.moneyTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];

}


-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.accountAllView.y = self.view.height;
        self.categoryAllView.y = self.view.height;

        self.accountCoverView.alpha = 0;
        
    }completion:^(BOOL finished) {
        self.accountCoverView.hidden = YES;
    }];
}

-(void)setUpThreeBtnView{
    CGFloat height = 25;
    CGFloat width;
    if (IS_IPHONE_5) {
        width = 231;
    }else{
        width = self.threeBtnCoverView.width;
    }
    self.threeBtnCoverView.layer.cornerRadius = height/2;
    self.threeBtnCoverView.layer.masksToBounds = YES;

    self.threeBtnCoverView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.frame = CGRectMake(0, 0, self.threeBtnCoverView.width, height);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(height/2, height/2) radius:height/2 startAngle:M_PI*0.5 endAngle:1.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(width - height/2, 0)];
    [path addArcWithCenter:CGPointMake(width - height/2, height/2) radius:height/2 startAngle:1.5*M_PI endAngle:0.5*M_PI clockwise:YES];
    [path closePath];
    path.lineWidth = 1;
    [[UIColor whiteColor] set];
    layer.path = path.CGPath;
    [self.threeBtnCoverView.layer addSublayer:layer];
    
    if (IS_IPHONE_5) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 77, 25)];
    }else{
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 82, 25)];
    }
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 12.5;
    _whiteView.layer.masksToBounds = YES;
    [self.threeBtnCoverView addSubview:_whiteView];
    [self.threeBtnCoverView sendSubviewToBack:_whiteView];
    self.expenseBtn.selected = YES;
    [self.expenseBtn setTitleColor:_threeBtnSelectedColor forState:UIControlStateSelected];
}

-(CGFloat)returnNoteHeight:(NSString*)note{
    
    CGSize labelSize = [_noteStr boundingRectWithSize:CGSizeMake(self.noteLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    return labelSize.height;
    
}

- (IBAction)cancelBtnClick:(id)sender {
    
    //搜索到以前的图片然后删除
    if (_photoName != nil && !editTransaction)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", _documentsPath, _photoName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)saveBtnClick:(id)sender {
    if (_selectedType != TranscationTransfer){
        
        if (!_selectedAccount) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_Account is required.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }else{
        if (!_fromAccount) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_From Account is required.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        if (!_toAccount) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_To Account is required.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        if (_fromAccount == _toAccount) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"VC_Accounts can not be same.", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    if ([self.moneyTextField.text doubleValue] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (editTransaction) {
        [self saveEditTransaction];
    }else{
        [self addNewTransaction];
    }
    [self flurryConfig];
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TransactionViewRefresh" object:nil];

    [self dismissViewControllerAnimated:YES completion:^{
        
        if ([self.delegate respondsToSelector:@selector(addTransactionCompletion)]) {
            [self.delegate addTransactionCompletion];
        }
     
    }];
}

-(void)flurryConfig{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (_selectedType == TransactionExpense) {
         [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_EXP"];
    }else if(_selectedType == TransactionIncome){
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_INC"];
    }else{
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"03_TRANS_TSF"];
    }
    
    if (!editTransaction) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"02_TRANS_ADD"];
    }
    
    if (!self.clearedSwitch.on) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_UNCL"];
    }
    if (_photoName.length > 0) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_PTO"];
    }
    if (_noteStr.length > 0) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_MEMO"];
    }
    if (_splitCategoryArr.count > 0) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_SPLT"];
    }
    if (![_repeatStr isEqualToString:@"Never"])
    {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"04_TRANS_RECR"];
        
        
        if ([_repeatStr isEqualToString:@"Daily"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_DLY"];
        }
        else if ([_repeatStr isEqualToString:@"Weekly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_WKLY"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 2 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2WK"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 3 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3WK"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 4 Weeks"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4WK"];
            
        }
        else if ([_repeatStr isEqualToString:@"Semimonthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_SMMO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Monthly"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_MON"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 2 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_2MO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 3 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_3MO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 4 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_4MO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 5 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_5MO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every 6 Months"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_6MO"];
            
        }
        else if ([_repeatStr isEqualToString:@"Every Year"])
        {
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"20_RECR_YEAR"];
            
        }
    }
}

-(void)saveEditTransaction{
    
    editTransaction.dateTime =  self.datePicker.date;
    editTransaction.updatedTime = editTransaction.dateTime_sync = [NSDate date];
    editTransaction.amount = [NSNumber numberWithDouble:[self.moneyTextField.text doubleValue]];
    editTransaction.photoName = _photoName;
    editTransaction.notes = _noteStr;
    editTransaction.isClear = @(self.clearedSwitch.on);
    editTransaction.recurringType = _repeatStr;
    
   
    if (_selectedType == TransactionIncome) {
        editTransaction.transactionType = @"income";
        editTransaction.incomeAccount = _selectedAccount;
        editTransaction.expenseAccount = nil;
    }else if (_selectedType == TransactionExpense){
        editTransaction.transactionType = @"expense";
        editTransaction.incomeAccount = nil;
        editTransaction.expenseAccount = _selectedAccount;
    }else{
        editTransaction.transactionType = @"transfer";
        editTransaction.expenseAccount = _fromAccount;
        editTransaction.incomeAccount = _toAccount;
    }
    if (_splitCategoryArr.count < 1 && _selectedType != TranscationTransfer) {
        editTransaction.category = _selectedCategory;
        _selectedCategory.recordIndex = [NSNumber numberWithInteger:[_selectedCategory.recordIndex integerValue]+1];
        
    }else{
        editTransaction.category = nil;
    }
    
    if (_selectedCategory != nil && _splitCategoryArr.count < 1) {
        _selectedCategory.others = @"HASUSE";
        [_selectedCategory addTransactionsObject:editTransaction];
    }
    
    if (self.titleTextField.text.length > 0) {
        Payee* payee = [[[XDDataManager shareManager] getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@ and name = %@ and category.uuid = %@",@"1",self.titleTextField.text,_selectedCategory.uuid] sortDescriptors:nil] lastObject];
        if (!payee) {
            Payee* newPay = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
            newPay.dateTime = newPay.updatedTime = [NSDate date];
            newPay.state = @"1";
            newPay.uuid = [EPNormalClass GetUUID];
            newPay.orderIndex = [NSNumber numberWithInteger:1];
            newPay.name  = self.titleTextField.text;
            
            if (_selectedType == TransactionIncome) {
                newPay.tranType = @"income";
                newPay.category = _selectedCategory;
            }else if (_selectedType == TransactionExpense){
                newPay.tranType = @"expense";
                
                if (_splitCategoryArr.count > 1) {
                    newPay.category = nil;
                }else{
                    newPay.category = _selectedCategory;
                }
            }else{
                newPay.tranType = @"transfer";
                newPay.category = nil;
            }
            
            [[XDDataManager shareManager]saveContext];
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:newPay];
            }
            
            editTransaction.payee = newPay;
        }else{
            if (_selectedType == TransactionIncome) {
                payee.tranType = @"income";
                payee.category = _selectedCategory;
            }else if (_selectedType == TransactionExpense){
                payee.tranType = @"expense";
                payee.category = _selectedCategory;
            }else{
                payee.tranType = @"transfer";
                payee.category = nil;
            }
            payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
            payee.updatedTime = [NSDate date];
            editTransaction.payee = payee;
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:payee];
            }
        }
    }else{
        editTransaction.payee = nil;
        
    }
    
    if (_splitCategoryArr.count > 1 && _selectedType == TransactionExpense) {
        editTransaction.recurringType = @"Never";

        if (editTransaction.childTransactions.count > 0) {
            NSMutableArray* oldSplit = [NSMutableArray arrayWithArray:[editTransaction.childTransactions allObjects]];
            for (Transaction* trans in oldSplit) {
                trans.state = @"0";
                trans.updatedTime = trans.dateTime_sync = [NSDate date];
                
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateTransactionFromLocal:trans];
                }
            }
        }
        
        for (int i = 0; i < _splitCategoryArr.count; i++) {
            CategorySelect* cs = _splitCategoryArr[i];
            Transaction* childTran = [[[XDDataManager shareManager]getObjectsFromTable:@"Transaction" predicate:[NSPredicate predicateWithFormat:@"category = %@ and parTransaction = %@",cs.category, editTransaction] sortDescriptors:nil]lastObject];
            if (childTran) {
                childTran.state = @"1";
                childTran.updatedTime = childTran.dateTime_sync = [NSDate date];
                childTran.amount = [NSNumber numberWithDouble:cs.amount];
                childTran.payee = editTransaction.payee;
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateTransactionFromLocal:childTran];
                }
                
            }else{
                Transaction* splitTransaction = [[XDDataManager shareManager]insertObjectToTable:@"Transaction"];
                splitTransaction.dateTime = self.datePicker.date;
                splitTransaction.updatedTime = splitTransaction.dateTime_sync = [NSDate date];
                splitTransaction.amount = [NSNumber numberWithDouble:cs.amount];
                splitTransaction.category = cs.category;
                splitTransaction.expenseAccount = _selectedAccount;
                splitTransaction.isClear = [NSNumber numberWithBool:YES];
                splitTransaction.recurringType = @"Never";
                splitTransaction.uuid = [EPNormalClass GetUUID];
                splitTransaction.state = @"1";
                splitTransaction.payee = editTransaction.payee;
                splitTransaction.transactionType = @"expense";
                [editTransaction addChildTransactionsObject:splitTransaction];
                [cs.category addTransactionsObject:splitTransaction];
                cs.category.others = @"HASUSE";
                cs.category.recordIndex = [NSNumber numberWithInteger:[_selectedCategory.recordIndex integerValue]+1];
                
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateTransactionFromLocal:splitTransaction];
                }
            }
        }
    }else if(_selectedType != TransactionExpense){
        if (editTransaction.childTransactions.count > 0) {
            NSMutableArray* oldSplit = [NSMutableArray arrayWithArray:[editTransaction.childTransactions allObjects]];
            for (Transaction* trans in oldSplit) {
                trans.state = @"0";
                trans.updatedTime = trans.dateTime_sync = [NSDate date];
                
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateTransactionFromLocal:trans];
                }
            }
        }
    }
    
    if (![editTransaction.recurringType isEqualToString:@"Never"]) {
        [[EPDataBaseModifyClass alloc] autoInsertTransaction:editTransaction];
    }else{
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:editTransaction];
        }
    }
    
    [[XDDataManager shareManager]saveContext];
    
}

-(void)addNewTransaction{

//    for (int i = 0; i < 60; i++) {
//        NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear;
//        NSCalendar* calendar = [NSCalendar currentCalendar];
//        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//
//        NSDateComponents* startComponents = [calendar components:unit fromDate:[NSDate date]];
//        startComponents.month = 1;
//        startComponents.day = i;
//        NSDate* date = [calendar dateFromComponents:startComponents];
    
  
    
    
    Transaction* transaction = [[XDDataManager shareManager] insertObjectToTable:@"Transaction"];
    transaction.dateTime =  self.datePicker.date;
    transaction.updatedTime = transaction.dateTime_sync = [NSDate date];
    transaction.state = @"1";
    transaction.uuid = [EPNormalClass GetUUID];
    transaction.amount = [NSNumber numberWithDouble:[self.moneyTextField.text doubleValue]];
    transaction.photoName = _photoName;
    transaction.notes = _noteStr;
    transaction.isClear = @(self.clearedSwitch.on);
    transaction.recurringType = self.repeatDetailLabel.text;
    
    if (_splitCategoryArr.count < 1 && _selectedType != TranscationTransfer) {
        transaction.category = _selectedCategory;
        _selectedCategory.recordIndex = [NSNumber numberWithInteger:[_selectedCategory.recordIndex integerValue]+1];
    }else{
        transaction.category = nil;
    }
    
    if (_selectedType == TransactionIncome) {
        transaction.transactionType = @"income";
        transaction.incomeAccount = _selectedAccount;
        transaction.expenseAccount = nil;
    }else if (_selectedType == TransactionExpense){
        transaction.transactionType = @"expense";
        transaction.incomeAccount = nil;
        transaction.expenseAccount = _selectedAccount;
    }else{
        transaction.transactionType = @"transfer";
        transaction.expenseAccount = _fromAccount;
        transaction.incomeAccount = _toAccount;
    }
    
    if (_selectedCategory != nil && _splitCategoryArr.count < 1) {
        _selectedCategory.others = @"HASUSE";
        [_selectedCategory addTransactionsObject:transaction];
    }
    
    if (self.titleTextField.text.length > 0) {
        Payee* payee = [[[XDDataManager shareManager] getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@ and name = %@ and category.uuid = %@",@"1",self.titleTextField.text,_selectedCategory.uuid] sortDescriptors:nil] lastObject];
        if (!payee) {
            Payee* newPay = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
            newPay.dateTime = newPay.updatedTime = [NSDate date];
            newPay.state = @"1";
            newPay.uuid = [EPNormalClass GetUUID];
            newPay.orderIndex = [NSNumber numberWithInteger:1];
            newPay.name  = self.titleTextField.text;
            
            if (_selectedType == TransactionIncome) {
                newPay.tranType = @"income";
                newPay.category = _selectedCategory;
            }else if (_selectedType == TransactionExpense){
                newPay.tranType = @"expense";
                if (_splitCategoryArr.count > 1) {
                    newPay.category = nil;
                }else{
                    newPay.category = _selectedCategory;
                }
            }else{
                newPay.tranType = @"transfer";
                newPay.category = nil;
            }
            
            [[XDDataManager shareManager]saveContext];
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updatePayeeFromLocal:newPay];
            }
            
            transaction.payee = newPay;
        }else{
            if (_selectedType == TransactionIncome) {
                payee.tranType = @"income";
                payee.category = _selectedCategory;
            }else if (_selectedType == TransactionExpense){
                payee.tranType = @"expense";
                payee.category = _selectedCategory;
            }else{
                payee.tranType = @"transfer";
                payee.category = nil;
            }
            payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
            payee.updatedTime = [NSDate date];
            transaction.payee = payee;
        }
    }else{
        transaction.payee = nil;
    }
    
    if (_splitCategoryArr.count > 1 && _selectedType == TransactionExpense) {
        transaction.recurringType = @"Never";
        for (int i = 0; i < _splitCategoryArr.count; i++) {
            CategorySelect* cs = _splitCategoryArr[i];
            Transaction* splitTransaction = [[XDDataManager shareManager]insertObjectToTable:@"Transaction"];
            splitTransaction.dateTime = self.datePicker.date;
            splitTransaction.updatedTime = splitTransaction.dateTime_sync = [NSDate date];
            splitTransaction.amount = [NSNumber numberWithDouble:cs.amount];
            splitTransaction.category = cs.category;
            splitTransaction.expenseAccount = _selectedAccount;
            splitTransaction.isClear = [NSNumber numberWithBool:YES];
            splitTransaction.recurringType = @"Never";
            splitTransaction.uuid = [EPNormalClass GetUUID];
            splitTransaction.state = @"1";
            splitTransaction.payee = transaction.payee;
            splitTransaction.transactionType = @"expense";
            [transaction addChildTransactionsObject:splitTransaction];
            [cs.category addTransactionsObject:splitTransaction];
            cs.category.others = @"HASUSE";
            cs.category.recordIndex = [NSNumber numberWithInteger:[_selectedCategory.recordIndex integerValue]+1];
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateTransactionFromLocal:splitTransaction];
            }
        }
    }
    [[XDDataManager shareManager]saveContext];

    if (![transaction.recurringType isEqualToString:@"Never"]) {
        [[EPDataBaseModifyClass alloc] autoInsertTransaction:transaction];
    }else{
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager] updateTransactionFromLocal:transaction];
        }
    }
    
    
    BOOL showRate = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERDONTSHOWAGAIN] boolValue];
    if (!showRate) {
        NSInteger integer = [[[NSUserDefaults standardUserDefaults] objectForKey:XDAPPIRATERIMPORTANTEVENT] integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:@(integer + 1) forKey:XDAPPIRATERIMPORTANTEVENT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)categroyLblTap{
    [self.view endEditing:YES];
    if (_selectedType != TransactionExpense) {
        self.categorySplitBtn.hidden = YES;
    }else{
        self.categorySplitBtn.hidden = NO;
    }
    if (_selectedType == TranscationTransfer) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.categoryView.transactionType = _selectedType;
        self.categoryAllView.y = self.categoryAllView.y == self.view.height?self.view.height - self.categoryAllView.height:self.view.height;
        
        if (self.categoryAllView.y == self.view.height) {
            self.accountCoverView.alpha = 0;
        }else{
            self.accountCoverView.hidden = NO;
            self.accountCoverView.alpha = 0.5;
        }
    }completion:^(BOOL finished) {
        self.categoryAllView.y == self.view.height?(self.accountCoverView.hidden = YES):(self.accountCoverView.hidden = NO);
    }];
}

- (IBAction)categroyIconBtnClick:(id)sender {
    _pageControl.numberOfPages = self.categoryView.numberOfSections;

    [self categroyLblTap];
}

- (IBAction)itemClick:(id)sender {
    UIButton* btn = (id)sender;
  
    for (UIView* view in self.threeBtnCoverView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)view;
            button.selected = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    btn.selected = YES;
    [btn setTitleColor:_threeBtnSelectedColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        _whiteView.centerX = btn.centerX;
    }];
    
    if (btn.tag == 0) {
//        self.titleTextField.placeholder = @"Payee";
        _selectedType = TransactionExpense;
        _selectedCategory = self.otherCategory_expense;
        _selectedAccount =_account?:_accountArray.firstObject;
        self.categoryView.transactionType = _selectedType;
        self.categoryLblHeight.constant =  17;
        self.transLblHeight.constant = 21;
        [self.categoryView reloadData];
        self.accountDetailLbl.text = _selectedAccount.accName;

        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];

        
        [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
        
      }else if( btn.tag == 1){
//          self.titleTextField.placeholder = @"Payee";
        _selectedType = TransactionIncome;
          _selectedAccount =_account?:_accountArray.firstObject;

          if (_splitCategoryArr.count > 1) {
              self.repeatBtn.hidden = NO;
              _repeatShow = NO;
              _repeatStr = @"Never";
              
              [self functionCellBtnConfig];
          }
        _splitCategoryArr = nil;
        
          
          _selectedCategory = self.otherCategory_income;
        self.moneyTextField.enabled = YES;
        self.categoryView.transactionType = _selectedType;
        self.categoryLblHeight.constant =  17;
        self.transLblHeight.constant = 21;
        [self.categoryView reloadData];
          self.accountDetailLbl.text = _selectedAccount.accName;
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
          self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];

        [self.incomeBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];

    }else{
//        self.titleTextField.placeholder = @"Transfer";
        if (_splitCategoryArr.count > 1) {
            self.repeatBtn.hidden = NO;
            _repeatShow = NO;
            _repeatStr = @"Never";
            
            [self functionCellBtnConfig];
        }
        
        _selectedType = TranscationTransfer;
        _selectedAccount = nil;
        _selectedCategory = nil;
        _splitCategoryArr = nil;
        
        self.moneyTextField.enabled = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryLblHeight.constant = 0.001;
            self.transLblHeight.constant = 35;
        }];
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"iocn_transfer"] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor colorWithHexString:@"71A3F5"];
        [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];

    }
    
//    self.titleTextField.text = nil;
    [self.titleTextField becomeFirstResponder];
    self.payeeView.tranType = _selectedType;
    [self.payeeView reloadData];
    [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
    _pageControl.numberOfPages = self.categoryView.numberOfSections;

    self.payeeView.title = self.titleTextField.text;

}

- (IBAction)cellDismissBtnClick:(id)sender {
    UIButton* btn = (id)sender;
    if(btn.tag == 0){
        self.repeatBtn.hidden = NO;
        _repeatStr = @"Never";
        _repeatShow  = NO;
    }else if (btn.tag == 1){
        self.photoBtn.hidden = NO;
        _photoName = nil;
        _photoShow = NO;
    }else if (btn.tag == 2){
        self.noteBtn.hidden = NO;
        _noteShow = NO;
        _noteStr = nil;
    }
  
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    NSMutableArray* muArr = [NSMutableArray array];
    for (UIView* view in self.functionCell.contentView.subviews) {
        if (view.hidden == NO) {
            [muArr addObject:view];
        }
    }
    CGFloat width = SCREEN_WIDTH / muArr.count;
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    NSArray* array = [muArr sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = 0; i < array.count; i++) {
        UIView* view = array[i];
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(width*i, 0, width, 56);
            UIImageView* imageview = view.subviews.lastObject;
            imageview.centerX = view.width/2;
        }];
    }

}
- (IBAction)transformBtnClick:(id)sender {
    UIButton* btn = (id)sender;
    [self.view endEditing:YES];
    if (btn.tag == 0) {
        self.fromAccountBtn.selected = YES;
        self.toAccountBtn.selected = NO;
        
        self.accountView.transAccount = _fromAccount;
        _isFromAccount = YES;
    }else{
        
        self.fromAccountBtn.selected = NO;
        self.toAccountBtn.selected = YES;
        
        self.accountView.transAccount = _toAccount;
        _isFromAccount = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.accountAllView.y = self.accountAllView.y == self.view.height?self.view.height - 336:self.view.height;
        if (self.accountAllView.y == self.view.height) {
            self.accountCoverView.alpha = 0;
        }else{
            self.accountCoverView.hidden = NO;
            self.accountCoverView.alpha = 0.5;
        }
    }completion:^(BOOL finished) {
        self.accountAllView.y == self.view.height?(self.accountCoverView.hidden = YES):(self.accountCoverView.hidden = NO);
    }];
    [self.accountView reloadData];
    
}
- (IBAction)categorySplitClick:(id)sender {
    [self tapClick];
    
    if (editTransaction && _splitCategoryArr.count > 0) {
        
        XDEditTransCategorySplitTableViewController* editSplitVc = [[XDEditTransCategorySplitTableViewController alloc]init];
        editSplitVc.editSplitCategoryMuArr = _splitCategoryArr;
        editSplitVc.addVc = self;
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:editSplitVc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        XDCategorySplitTableViewController* vc = [[XDCategorySplitTableViewController alloc]initWithNibName:@"XDCategorySplitTableViewController" bundle:nil];
        vc.splitDelegate = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }
}

- (IBAction)categoryEditClick:(id)sender {
    TransactionCategoryViewController* vc = [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
    vc.xxdDelegate = self;
    vc.type = _selectedType;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
}

-(void)addAccountBtnClick{
    NSArray* array = [[XDDataManager shareManager] getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"] sortDescriptors:nil];
    if (array.count > 1) {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
        if (appDelegate.isPurchased) {
            XDAddAccountViewController* ac = [[XDAddAccountViewController alloc]initWithNibName:@"XDAddAccountViewController" bundle:nil];
            ac.delegate = self;
            [self presentViewController:ac animated:YES completion:nil];
        }else{
            
            XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
            [self presentViewController:adsVc animated:YES completion:nil];
            
        }
    }
    
}



- (IBAction)functionBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    UIButton* btn = (id)sender;
    
    
    if(btn.tag == 0){
        XDRepeatTableViewController* repeatVc = [[XDRepeatTableViewController alloc]init];
        repeatVc.repeatDelegate = self;
        repeatVc.repeatStr = _repeatStr;
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:repeatVc] animated:YES completion:nil];
        
    }else if (btn.tag == 1){
        [self setupPhotoSheet];
    }else if (btn.tag == 2){
        XDTranscationNoteViewController * noteVc = [[XDTranscationNoteViewController alloc]initWithNibName:@"XDTranscationNoteViewController" bundle:nil];
        noteVc.delegate = self;
        noteVc.noteStr = _noteStr;
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:noteVc] animated:YES completion:nil];
        
    }

    
}
#pragma mark - XDAddAccountViewDelegate
-(void)returnAccount:(Accounts *)account{
    
    [self.accountView refreshData];
    
}

#pragma mark - XDRepeatTableViewDelegate
-(void)returnSelectedRepeat:(NSString *)string{
    _repeatShow = YES;
    _repeatStr = string;
    self.repeatDetailLabel.text = string;
    
    [self functionBtnHidden:self.repeatBtn];

}

#pragma mark - XDTranscationNoteViewDelegate

-(void)returnNote:(NSString *)note{
    
    if (note.length > 0) {
        _noteShow = YES;
        _noteStr =  note;
        self.noteLabel.text = _noteStr;
        _noteHeight = [self returnNoteHeight:_noteStr]>26?[self returnNoteHeight:_noteStr]:26;
        [self functionBtnHidden:self.noteBtn];

    }else{
        _noteShow = NO;
        [self cellDismissBtnClick:self.noteBtn];
        [self.tableView reloadData];
    }
   
}
#pragma mark - XDTransactionPayeeCollectionViewDelegate
-(void)returnSelectedPayee:(Payee *)payee{
    _selectedPayee = payee;
    self.titleTextField.text = payee.name;
    
    if (payee.category) {
        _selectedCategory = payee.category;
        _splitCategoryArr = nil;
        [self.categroyLbl setTitle:[[_selectedCategory.categoryName componentsSeparatedByString:@": "]lastObject] forState:UIControlStateNormal];
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        
        [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
        [self.incomeBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
        
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];
        
      
    }else{
        _selectedCategory = nil;
        _splitCategoryArr = nil;
        [self.categroyLbl setTitle:nil forState:UIControlStateNormal];
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"iocn_transfer"] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor colorWithHexString:@"71A3F5"];
        [self.balanceBtn setTitleColor:[UIColor colorWithHexString:@"71A3F5"] forState:UIControlStateSelected];
        
        [self itemClick:self.balanceBtn];
    }
    [self.moneyTextField becomeFirstResponder];

    self.repeatBtn.hidden = NO;
    _repeatShow = NO;
    _repeatStr = @"Never";
    
    [self functionCellBtnConfig];
}

//#pragma mark - XDEditTransCategorySplitTableViewDelegate
//-(void)returnEditTransCategorySplitCancel{
//
//
//    if (_splitCategoryArr.count > 0) {
//        CGFloat amount = 0;
//        for (int i = 0; i < _splitCategoryArr.count; i++) {
//            CategorySelect* cs = _splitCategoryArr[i];
//            amount += cs.amount;
//        }
//        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",amount];
//        self.categroyLbl.text = NSLocalizedString(@"VC_Split", nil);
//        self.moneyTextField.enabled = NO;
//        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_mind.png"] forState:UIControlStateNormal];
//
//
//    }else{
//        self.moneyTextField.enabled = YES;
//        self.categroyLbl.text = self.otherCategory_expense.categoryName;
//        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:self.otherCategory_expense.iconName] forState:UIControlStateNormal];
//    }
//}

#pragma mark - XDTransactionCatgroyViewDelegate
-(void)returnSelectCategory:(Category *)category{
//    NSLog(@"%@",category);
    _selectedCategory = category;
    _splitCategoryArr = nil;
    [self.categroyLbl setTitle:[[category.categoryName componentsSeparatedByString:@": "]lastObject] forState:UIControlStateNormal];
    [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[category.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
    
    [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
    [self.incomeBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]] forState:UIControlStateSelected];
    
    self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];

    [self categroyIconBtnClick:nil];
    
    [self.moneyTextField becomeFirstResponder];
    
    self.repeatBtn.hidden = NO;
    _repeatShow = NO;
    _repeatStr = @"Never";
    
    [self functionCellBtnConfig];
}
-(void)returnCurrentPage:(NSInteger)index{
    _pageControl.currentPage = index;
}
#pragma mark -  XDTransactionAccountViewDelegate
-(void)returnSelectedAccount:(Accounts *)account{
    _selectedAccount = account;
    [self tapClick];
    self.accountDetailLbl.text = account.accName;
    self.clearedSwitch.on = [_selectedAccount.autoClear boolValue];
    if (_selectedType == TranscationTransfer && _isFromAccount) {
        _fromAccount = account;
        _fromAccountView.account = account;
        self.clearedSwitch.on = [_fromAccount.autoClear boolValue];

    }else if (_selectedType == TranscationTransfer && !_isFromAccount){
        _toAccount = account;
        _toAccountView.account = account;
    }
}




#pragma mark - XDCategorySplitTableViewDelegate
-(void)returnSelectedSplitArray:(NSArray *)array{
    if (array.count == 0) {
        _selectedCategory = self.otherCategory_expense;
        self.moneyTextField.text = @"0.00";
        [self.categroyLbl setTitle:_selectedCategory.categoryName forState:UIControlStateNormal];
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];

        self.repeatBtn.hidden = NO;
        _repeatShow = NO;
        _repeatStr = @"Never";
        
        [self functionCellBtnConfig];
    }else if (array.count == 1) {
        CategorySelect* cs = [array firstObject];
        _selectedCategory = cs.category;
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",cs.amount];
        [self.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
        self.saveBtn.enabled = YES;
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white",[[_selectedCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectedCategory.iconName]];

        self.repeatBtn.hidden = NO;
        _repeatShow = NO;
        _repeatStr = @"Never";
        
        [self functionCellBtnConfig];
    }else{
       
        
        _selectedCategory = nil;
        _splitCategoryArr = [NSMutableArray arrayWithArray:array];
        CGFloat amount = 0;
        for (int i = 0; i < _splitCategoryArr.count; i++) {
            CategorySelect* cs = _splitCategoryArr[i];
            amount += cs.amount;
        }
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",amount];
        [self.categroyLbl setTitle:NSLocalizedString(@"VC_Split", nil) forState:UIControlStateNormal];
        self.moneyTextField.enabled = NO;
        [self.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
        self.saveBtn.enabled = YES;
        
        [self.categoryIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_mind_white"] forState:UIControlStateNormal];
        self.navigationBarView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:@"icon_mind"]];
        [self.expenseBtn setTitleColor:[UIColor mostColor:[UIImage imageNamed:@"icon_mind"]] forState:UIControlStateSelected];
        
        
        self.repeatBtn.hidden = YES;
        _repeatShow = NO;
        _repeatStr = @"Never";
        
        [self functionCellBtnConfig];
        
    }
}

-(void)functionCellBtnConfig{
    NSMutableArray* muArr = [NSMutableArray array];
    for (UIView* view in self.functionCell.contentView.subviews) {
        if (view.hidden == NO) {
            [muArr addObject:view];
        }
    }
    
    CGFloat width = SCREEN_WIDTH / muArr.count;
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    NSArray* array = [muArr sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = 0; i < array.count; i++) {
        UIView* view = array[i];
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(width*i, 0, width, 56);
            UIImageView* imageview = view.subviews.lastObject;
            imageview.centerX = view.width/2;
        }];
    }
    
    [self.tableView reloadData];
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && _selectedType == TranscationTransfer) {
        return 115;
    }
    if (indexPath.row == 1 && _selectedType != TranscationTransfer) {
        return _todayShow?224:0.001;
    }
    
    if (indexPath.row == 2 && _selectedType == TranscationTransfer) {
        return _todayShow?224:0.001;
    }
    
    if (indexPath.row == 4) {
        return _repeatShow?56:0.001;
    }
    
    if (indexPath.row == 5) {
        return _photoShow?56:0.001;
    }
    
    if (indexPath.row == 6) {

        return _noteShow?(_noteHeight + 30):0.001;
    }
    
    if (indexPath.row == 7 && _noteShow && _photoShow && _repeatShow) {
        return 0.001;
    }
    
    return 56;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noteShow && _photoShow && _repeatShow) {
        if (indexPath.row == 6) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
        }
    }else{
        if (indexPath.row == 7) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (_selectedType == TranscationTransfer){
            return  self.transformAccountCell;
        }else{
            return self.dayCell;
        }
    }else if (indexPath.row == 1){
        if (_selectedType == TranscationTransfer){
            return self.dayCell;
        }else{
            return self.datePickCell;
        }
    }else if (indexPath.row == 2){
        if (_selectedType == TranscationTransfer) {
            return self.datePickCell;
        }else{
            return self.accountCell;
        }
    }else if (indexPath.row == 3){
        return self.clearedCell;
    }else if (indexPath.row == 4){
        return self.repeatCell;
    }else if (indexPath.row == 5){
        return self.photoCell;
    }else if (indexPath.row == 6){
        return self.noteCell;
    }else if (indexPath.row == 7){
        return self.functionCell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.view endEditing:YES];
    
    if (indexPath.row == 0) {
        if (_selectedType != TranscationTransfer){
            _todayShow = !_todayShow;
        }
    }else if (indexPath.row == 1){
        if (_selectedType == TranscationTransfer){
            _todayShow = !_todayShow;
        }
    }else if (indexPath.row == 2){
        
        if (cell == self.accountCell) {
            self.accountAllView.y == self.view.height?(self.accountCoverView.hidden = NO):(self.accountCoverView.hidden = YES);
            self.accountView.transAccount = _selectedAccount;
            [self.accountView reloadData];
            [UIView animateWithDuration:0.2 animations:^{
                if (self.accountAllView.y == self.view.height) {
                    self.accountCoverView.alpha = 0.5;
                    self.accountAllView.y = self.view.height - 341;
                }else{
                    self.accountCoverView.hidden = NO;
                    self.accountCoverView.alpha = 0;
                    self.accountAllView.y = self.view.height;
                }
            }completion:^(BOOL finished) {
                
            }];
        }
    }else if( indexPath.row == 4){
        XDRepeatTableViewController* repeatVc = [[XDRepeatTableViewController alloc]init];
        repeatVc.repeatDelegate = self;
        repeatVc.repeatStr = _repeatStr;
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:repeatVc] animated:YES completion:nil];
        
    }else if (indexPath.row == 5){
        [self setupPhotoSheet];
    }else if (indexPath.row == 6){
        
        XDTranscationNoteViewController * noteVc = [[XDTranscationNoteViewController alloc]initWithNibName:@"XDTranscationNoteViewController" bundle:nil];
        noteVc.delegate = self;
        noteVc.noteStr = _noteStr;

        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:noteVc]  animated:YES completion:nil];
    }
    
    
    [self.tableView beginUpdates];
    [self.tableView  endUpdates];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}

#pragma mark - SettingTransactionCategoryViewDelegate
-(void)returnTransactionCategoryChange{
    
    self.categoryView.transactionType = _selectedType;
    [self.categoryView reloadData];
}

#pragma mark - textfieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _moneyTextField) {
        NSString* str = self.moneyTextField.text;
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",[str doubleValue]];
        self.keyboard.needCaculate = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self categroyIconBtnClick:nil];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (_splitCategoryArr && _splitCategoryArr.count>0 && textField == self.moneyTextField) {
        return NO;
    }
    return YES;
}

-(void)titleValueChange{
    
//    NSLog(@"title == %@",self.titleTextField.text);
    self.payeeView.title = self.titleTextField.text;
}


#pragma mark - ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //有摄像机的设备
    if(actionSheet.tag == 0)
    {
        
        if (buttonIndex == 0) //dub不了
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker1.delegate= self;
            
            [self presentViewController:picker1 animated:YES completion:nil];
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];
        }
        if(buttonIndex == 1)
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            
            [self presentViewController:picker1 animated:YES completion:nil];
            
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];
            
        }
        if (buttonIndex == 2)
        {
            return;
        }
    }
    //无摄像头设备
    else if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            [self presentViewController:picker1 animated:YES completion:nil ];
            
            
            [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];
        }
        if (buttonIndex == 1)
        {
            return;
        }
    }
    
    else if (actionSheet.tag==100|| actionSheet.tag==101){
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
        }
        else
            return;
    }
}

#pragma mark - UIImageViewSelectedViewController
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//选中了一个之后 就将这个数据写到本地文件中
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)selectedImage
                  editingInfo:(NSDictionary *)editingInfo
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *imageName =  (__bridge NSString *)string;
    
    //搜索到以前的图片然后删除
    if (_photoName != nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", _documentsPath, _photoName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }
    
    _photoName = imageName;
    
    //    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(selectedImage, 1.f)];
    
    NSData *imageData=UIImageJPEGRepresentation(selectedImage, 0.1);
    
    
    [imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", _documentsPath, imageName] atomically:YES];
    
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", _documentsPath, imageName]];
    UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
    
    self.photoImageView.image = imaged;
    _photoShow = YES;
    [self functionBtnHidden:self.photoBtn];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageFitScreen:(UIImage *)image
{
    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(320,480);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return tempImage;
    
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage withTargetSize: (CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark -  SelectImageViewDelegate
-(void)returnPhotoDelete{
    self.photoImageView.image = nil;
    _photoName = nil;
    
    _photoShow = NO;
    [self cellDismissBtnClick:self.photoBtn];
    [self.tableView reloadData];
}

#pragma mark - UIPickerView

- (IBAction)datePickerValueChanged:(id)sender {
    UIDatePicker* picker = (id)sender;    
    
    if ([[picker.date initDate] compare:[[NSDate date]initDate]] == NSOrderedSame) {
        self.datePickerLabel.text = @"Today";
    }else{
        self.datePickerLabel.text = [self returnInitDate:picker.date];
    }
}
#pragma mark - other

- (IBAction)switchChange:(id)sender {
    if (self.clearedSwitch.on) {
        self.clearedLbl.text = @"Cleared";
        self.clearedSwitch.on = YES;
    }else{
        self.clearedLbl.text = @"Uncleared";
        self.clearedSwitch.on = NO;
    }
}
-(void)functionBtnHidden:(UIButton*)btn{
    dispatch_async(dispatch_get_main_queue(), ^{
        btn.hidden = YES;
        NSMutableArray* muArr = [NSMutableArray array];
        for (UIView* view in self.functionCell.contentView.subviews) {
            if (view.hidden == NO) {
                [muArr addObject:view];
            }
        }
        CGFloat width = SCREEN_WIDTH / muArr.count;
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
        NSArray* array = [muArr sortedArrayUsingDescriptors:@[sort]];
        
        for (int i = 0; i < array.count; i++) {
            UIView* view = array[i];
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(width*i, 0, width, 56);
                UIImageView* imageview = view.subviews.lastObject;
                imageview.centerX = view.width/2;
            }];
        }
        [self.tableView reloadData];
    });
}




-(void)setupPhotoSheet{
    if ( ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) &&  _photoName==nil)
    {
        UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"VC_Photo from Camera", nil),NSLocalizedString(@"VC_Photo from Library", nil),
                                     nil];
        
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
        
    }
    else if(_photoName == nil)
    {
        UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"VC_Photo from Library", nil),
                                     nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
    else if(_photoName !=nil)
    {
        SelectImageViewController *selectImageViewController = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil];
        selectImageViewController.documentsPath = _documentsPath;
        selectImageViewController.imageName = _photoName ;
        selectImageViewController.delegate = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:selectImageViewController] animated:YES completion:nil];
    }
}

-(void)changeStatusBarStyle:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    if ([[date initDate] compare:[[NSDate date]initDate]]==NSOrderedSame) {
        return @"Today";
    }
    
    return dateStr;
    
}


-(void)dealloc{
    
    NSLog(@"transaction dealloc");
}
@end

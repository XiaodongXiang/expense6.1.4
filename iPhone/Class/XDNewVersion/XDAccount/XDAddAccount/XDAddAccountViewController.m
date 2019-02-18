//
//  XDAddAccountViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/6.
//

#import "XDAddAccountViewController.h"
#import "Accounts.h"
#import "numberKeyboardView.h"
#import "XDAccountCategoryView.h"
#import "AccountType.h"
#import "EPNormalClass.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "XDAccountCategoryTableViewController.h"
#import "CategoryBackView.h"
#import "PokcetExpenseAppDelegate.h"

@import Firebase;
@interface XDAddAccountViewController ()<XDAccountCategoryDelegate>
{
    BOOL _dateCellShow;
    BOOL _colorSelectShow;
    
    NSArray* _colorArr;
    NSString* _colorStr;
    
    AccountType* _accountType;
    NSInteger _selecedBtnIndex;
}
@property(nonatomic, strong)CategoryBackView *categoryBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nacBackViewH;
@property (weak, nonatomic) IBOutlet UILabel *startBalanceLbl;

@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountAmountTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearedCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *colorSelectCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *colorCell;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *clearedSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@property(nonatomic, strong)numberKeyboardView * keyboard;
@property(nonatomic, strong)XDAccountCategoryView * accountCategoryView;

@property(nonatomic, strong)UIView * coverView;

@end

@implementation XDAddAccountViewController
@synthesize editAccount;

-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:1];
        _coverView.alpha = 0;
        [self.view addSubview:_coverView];
        _coverView.hidden = YES;
        [self.view bringSubviewToFront:self.accountCategoryView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapClick)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

-(XDAccountCategoryView *)accountCategoryView{
    if (!_accountCategoryView) {
        _accountCategoryView = [[[NSBundle mainBundle]loadNibNamed:@"XDAccountCategoryView" owner:self options:nil]lastObject];
        _accountCategoryView.delegate = self;
        _accountCategoryView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 332);
        _accountCategoryView.selectAccountType = _accountType;
    }
    return _accountCategoryView;
}

-(numberKeyboardView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
        __weak __typeof__(self) weakSelf = self;
        _keyboard.amountBlock = ^(NSString *string) {
            //            NSLog(@"amount == %@",string);
            weakSelf.accountAmountTextField.text = string;
        };
        
        _keyboard.completed = ^{
            [weakSelf saveBtnClick:nil];
        };
    }
    return _keyboard;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryBackView = [[CategoryBackView alloc]initWithFrame:self.categoryBtn.frame];
    [FIRAnalytics setScreenName:@"add_account_view_iphone" screenClass:@"XDAddAccountViewController"];

    if (IS_IPHONE_X) {
        self.nacBackViewH.constant = 188;
        self.categoryBackView.y = 115;
    }
    [self.accountNameTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    [self.accountAmountTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.accountNameTextField becomeFirstResponder];
    self.startBalanceLbl.text = NSLocalizedString(@"VC_StartBalance", nil);
    self.dateLabel.text = [NSString stringWithFormat:@"%@: Today",NSLocalizedString(@"VC_OpenDate", nil)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _colorArr = @[@"8281FF",@"639AF4",@"7AD2FF",@"4CD3B2",@"47D469",@"F2BE44",@"FF965D",@"FD7881",@"D38CF2"];
    self.accountAmountTextField.inputView = self.keyboard;
    if (IS_IPHONE_X) {
        self.accountAmountTextField.inputView.transform = CGAffineTransformMakeTranslation(0, -34);
    }
    _colorView.layer.cornerRadius = 5;
    _colorView.layer.masksToBounds = YES;
    
    if (editAccount) {
        _accountType = editAccount.accountType;
        self.dateLabel.text = [self returnInitDate:editAccount.dateTime];
        self.clearedSwitch.on = [editAccount.autoClear boolValue];
        _colorStr = _colorArr[[editAccount.accountColor integerValue]];
        _selecedBtnIndex = [editAccount.accountColor integerValue];
        
        self.accountAmountTextField.text = [NSString stringWithFormat:@"%.2f",[editAccount.amount doubleValue]];
        self.accountNameTextField.text = editAccount.accName;
        
    }else{
        _accountType = [[[XDDataManager shareManager]getObjectsFromTable:@"AccountType" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1"] sortDescriptors:nil]lastObject];
        _colorStr = _colorArr[1];
        _selecedBtnIndex = 1;
        
    }

    _colorView.backgroundColor = [UIColor colorWithHexString:_colorStr];
    _navigationBarView.backgroundColor = [UIColor colorWithHexString:_colorStr];
    self.categoryBackView.roundColor = [UIColor colorWithHexString:_colorStr];
    self.categoryBtn.imageView.tintColor = [UIColor colorWithHexString:_colorStr];
    
    [self.categoryBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_accountType.iconName componentsSeparatedByString:@"."]firstObject]]] imageWithColor:_colorView.backgroundColor] forState:UIControlStateNormal];
    self.categoryLabel.text = _accountType.typeName;
    [self setUpColorBtn];

    
//    self.categoryBtn.hidden = YES;
    [self.navigationBarView addSubview:self.categoryBackView];
    [self.navigationBarView sendSubviewToBack:self.categoryBackView];

    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categroyLblTap)];
    [self.categoryLabel addGestureRecognizer:tap];
    
    [self.view addSubview:self.accountCategoryView];

}

-(void)categroyLblTap{
    [self.view endEditing:YES];
    
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.5;
        self.accountCategoryView.y = SCREEN_HEIGHT - self.accountCategoryView.height;
    }];
}

-(void)setUpColorBtn{
    
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat xmargin = (SCREEN_WIDTH - 15 * 2 - 30 * 6) / 5;
    CGFloat ymargin = 20;
    for (int i = 0; i < 9; i++) {
        NSString* colorS = _colorArr[i];
        CGFloat x = i % 6;
        CGFloat y = i / 6;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + (xmargin + width) * x, 10 + (height + ymargin)*y, width, height);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        
        btn.backgroundColor = [UIColor colorWithHexString:colorS];
        [btn setImage:[UIImage imageNamed:@"newaccount_selecte"] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_colorSelectCell.contentView addSubview:btn];
        if ([_colorStr isEqualToString:colorS]) {
            btn.selected = YES;
        }
    }
}

-(void)colorBtnClick:(UIButton*)btn{
    for (UIButton* button in _colorSelectCell.contentView.subviews) {
        button.selected = NO;
    }
    btn.selected = YES;
    _colorView.backgroundColor = btn.backgroundColor;
    _navigationBarView.backgroundColor = btn.backgroundColor;
    self.categoryBtn.tintColor = btn.backgroundColor;
    _selecedBtnIndex = btn.tag;
    
    self.categoryBackView.roundColor = btn.backgroundColor;
    
    [self.categoryBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_accountType.iconName componentsSeparatedByString:@"."]firstObject]]] imageWithColor:btn.backgroundColor] forState:UIControlStateNormal];
   
}


#pragma mark - other

- (IBAction)cancelBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)saveBtnClick:(id)sender {
    [self.view endEditing:YES];

    
    
    if (self.accountNameTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Account name is needed.", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!_clearedSwitch.on) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"07_ACC_AUOFF"];
    }
    
    if (!editAccount) {
        Accounts* account = [[[XDDataManager shareManager]getObjectsFromTable:@"Accounts" predicate:[NSPredicate predicateWithFormat:@"accName = %@",self.accountNameTextField.text] sortDescriptors:nil]lastObject];
        NSArray* array = [[XDDataManager shareManager]getObjectsFromTable:@"Accounts"];
        
        if (account) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Account Name already exists.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            Accounts* newAccount = [[XDDataManager shareManager] insertObjectToTable:@"Accounts"];
            newAccount.accName = self.accountNameTextField.text;
            newAccount.amount = @([self.accountAmountTextField.text doubleValue]);
            newAccount.dateTime = [self returnInitDate];
            newAccount.autoClear = @(self.clearedSwitch.on);
            newAccount.uuid = [EPNormalClass GetUUID];
            newAccount.dateTime_sync = newAccount.updatedTime = [NSDate date];
            newAccount.state = @"1";
            newAccount.accountColor = @(_selecedBtnIndex);
            newAccount.orderIndex = @(array.count);
            newAccount.accountType = _accountType;
            [[XDDataManager shareManager]saveContext];
            
            if ([PFUser currentUser]) {
                [[ParseDBManager sharedManager]updateAccountFromLocal:newAccount];
                [appDelegate.epnc setFlurryEvent_WithIdentify:@"05_ACC_ADD"];

            }
            if ([self.delegate respondsToSelector:@selector(returnAccount:)]) {
                [self.delegate returnAccount:newAccount];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        
        editAccount.accName = self.accountNameTextField.text;
        editAccount.amount = @([self.accountAmountTextField.text doubleValue]);
        editAccount.dateTime = [self returnInitDate];
        editAccount.autoClear = @(self.clearedSwitch.on);
        editAccount.dateTime_sync = editAccount.updatedTime = [NSDate date];
        editAccount.state = @"1";
        editAccount.accountColor = @(_selecedBtnIndex);
        editAccount.accountType = _accountType;
        [[XDDataManager shareManager]saveContext];
        
        if ([PFUser currentUser]) {
            [[ParseDBManager sharedManager]updateAccountFromLocal:editAccount];
        }
        if ([self.delegate respondsToSelector:@selector(returnEditAccount:)]) {
            [self.delegate returnEditAccount:editAccount];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
   
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshUI" object:nil];

}
-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0;
        self.accountCategoryView.y = SCREEN_HEIGHT;
    }completion:^(BOOL finished) {
        self.coverView.hidden = YES;
    }];
    
}

- (IBAction)categoryBtnClick:(id)sender {
    [self.view endEditing:YES];

    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.5;
        self.accountCategoryView.y = SCREEN_HEIGHT - self.accountCategoryView.height;
    }];
}
- (IBAction)accontNameTextDidEnd:(id)sender {
    
}
- (IBAction)datePickerValueChanged:(id)sender {

    self.dateLabel.text = [self returnInitDate:self.datePicker.date];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        return _dateCellShow?191:0.001;
    }
    
    if (indexPath.row == 4) {
        return _colorSelectShow?100:0.001;
    }
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.dateCell;
    }else if(indexPath.row == 1){
        return self.datePickerCell;
    }else if (indexPath.row == 2){
        return self.clearedCell;
    }else if (indexPath.row == 3){
        return self.colorCell;
    }else{
        return self.colorSelectCell;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        _dateCellShow = !_dateCellShow;
    }
    
    if (indexPath.row == 3) {
        self.colorView.hidden = !self.colorView.hidden;
        _colorSelectShow = !_colorSelectShow;
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}
#pragma mark -XDAccountCategoryDelegate
-(void)returnSelectedAccountCategory:(AccountType *)accountType{
    _accountType = accountType;
    
    [self.categoryBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[accountType.iconName componentsSeparatedByString:@"."]firstObject]]]imageWithColor:_colorView.backgroundColor] forState:UIControlStateNormal];
    self.categoryBackView.roundColor = _colorView.backgroundColor;
    self.categoryLabel.text = _accountType.typeName;
    
    [self tapClick];
    
    if (self.accountAmountTextField.text.length == 0 || [self.accountAmountTextField.text boolValue] == 0 ) {
        [self.accountAmountTextField becomeFirstResponder];
    }
}

-(void)editBtnClick{
    
    XDAccountCategoryTableViewController * vc = [[XDAccountCategoryTableViewController alloc]init];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
}

#pragma mark - text delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountNameTextField) {
        [self categroyLblTap];
    }
    return YES;
}
#pragma mark - other
-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    
    if ([[date initDate] compare:[[NSDate date]initDate]]==NSOrderedSame) {
        return [NSString stringWithFormat:@"%@: Today",NSLocalizedString(@"VC_OpenDate", nil)];
    }
    
    return [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"VC_OpenDate", nil),dateStr];
    
}

-(NSDate*)returnInitDate{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //4.dateTime
    NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self.datePicker.date];
    [parts1 setHour:0];
    [parts1 setMinute:0];
    [parts1 setSecond:1];
    return [[NSCalendar currentCalendar] dateFromComponents:parts1];
}

@end

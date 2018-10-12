//
//  XDAddBillViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/30.
//

#import "XDAddBillViewController.h"
#import "XDBillRepeatTableViewController.h"
#import "XDBillEndDateTableViewController.h"
#import "XDBillNotifTableViewController.h"
#import "XDTranscationNoteViewController.h"
#import "XDTransactionCatgroyView.h"
#import "Category.h"
#import "numberKeyboardView.h"
#import "Payee.h"
#import "EPNormalClass.h"
#import "EP_BillRule.h"
#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "TransactionCategoryViewController.h"
#import "BillFather.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
@interface XDAddBillViewController ()<XDBillRepeatTableViewDelegate,XDBillEndDateTableViewDelegate,XDTransactionCatgroyViewDelegate,XDBillNotifTableViewDelegate,XDTranscationNoteViewDelegate,SettingTransactionCategoryViewDelegate,UIActionSheetDelegate>
{
    BOOL _repeatShow;
    BOOL _notifShow;
    BOOL _noteShow;
    BOOL _datePickerShow;
    BOOL _functionCellShow;
    
    NSString* _repeatString;
    NSDate* _endDate;
    
    NSString* _remindMeString;
    NSDate* _remindAtDate;
    
    NSString* _noteString;
    
    CGFloat _noteHeight;

    Category* _selectCategory;
}
@property (weak, nonatomic) IBOutlet UIView *navBackView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UILabel *categoryL;
@property (weak, nonatomic) IBOutlet UITextField *amountTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryLHeight;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *repeatCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *noteCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *functionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *notifCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *endDateCell;

@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UIButton *fRepeatBtn;
@property (weak, nonatomic) IBOutlet UIButton *fNotifBtn;
@property (weak, nonatomic) IBOutlet UILabel *notifDetailLabel;

@property (weak, nonatomic) IBOutlet UIButton *fNoteBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property(nonatomic, strong)XDTransactionCatgroyView * categoryView;
@property (strong, nonatomic) IBOutlet UIView *categoryBackView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic, strong)UIView * backView;
@property(nonatomic, strong)numberKeyboardView * keyboard;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBackViewH;

@end

@implementation XDAddBillViewController
@synthesize billFather,selectedDate;

-(numberKeyboardView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
        __weak __typeof__(self) weakSelf = self;
        _keyboard.amountBlock = ^(NSString *string) {
            //            NSLog(@"amount == %@",string);
            weakSelf.amountTextF.text = string;
            [weakSelf.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];
        };
    }
    return _keyboard;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        _backView.hidden = YES;
        
        [self.view addSubview:_backView];
        [self.view bringSubviewToFront:self.categoryBackView];
        
        UITapGestureRecognizer* tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

-(XDTransactionCatgroyView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[XDTransactionCatgroyView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, SCREEN_WIDTH)];
        
        _categoryView.transactionType = TransactionExpense;
        _categoryView.categoryDelegate = self;
    }
    return _categoryView;
}

-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.alpha = 0;
        self.categoryBackView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.navBackViewH.constant = 188;
    }
    [self.nameTextF becomeFirstResponder];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.amountTextF.inputView = self.keyboard;
    [self.nameTextF setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    [self.amountTextF setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    self.categoryBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH+80);
    [self.categoryBackView addSubview:self.categoryView];
    [self.view addSubview:self.categoryBackView];
    
    if (billFather) {
        [self editBillConfig];
    }else{
        [self newBillConfig];
    }

    self.categoryL.text = [[_selectCategory.categoryName componentsSeparatedByString:@": "]lastObject];
    [self.categoryBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
    self.navBackView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectCategory.iconName]];

    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesClick)];
    [self.categoryL addGestureRecognizer:tap];
    
    self.tableView.separatorColor = RGBColor(226, 226, 226);

    
    
}

-(void)tapGesClick{
    [self.view endEditing:YES];
    
    if (self.categoryBackView.y == SCREEN_HEIGHT) {
        self.backView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryBackView.y = SCREEN_HEIGHT - SCREEN_WIDTH - 80;
            self.backView.alpha = 0.5;
        }];
    }else{
        [self tapClick];
    }
}


-(void)newBillConfig{
    if (selectedDate) {
        self.dateLabel.text = [self returnInitDate:selectedDate];
        self.datePicker.date = selectedDate;
    }
    _functionCellShow = YES;
    _repeatString = @"Never";
    _remindMeString = @"None";
    _selectCategory = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"isDefault = 1 and categoryType = %@ and categoryName = %@",@"EXPENSE",@"Others"] sortDescriptors:nil]lastObject];
    if (!_selectCategory) {
        _selectCategory = [[[XDDataManager shareManager]getObjectsFromTable:@"Category" predicate:[NSPredicate predicateWithFormat:@"categoryType = %@ and categoryName = %@",@"EXPENSE",@"Others"] sortDescriptors:nil]lastObject];

    }
    
    [self setupThreeBtnImageView];

}

-(void)editBillConfig{
    self.saveBtn.enabled = YES;
    [self.saveBtn setImage:[UIImage imageNamed:@"done_normal"] forState:UIControlStateNormal];

    EP_BillItem* editBill = billFather.bf_billItem;
    
    _selectCategory = billFather.bf_category;
    _repeatString = billFather.bf_billRecurringType;
    _remindMeString = billFather.bf_billReminderDate;
    _noteString = billFather.bf_billNote;
    _endDate = billFather.bf_billRule.ep_billEndDate;;
    _remindAtDate = billFather.bf_billReminderTime;
    _noteHeight = [self returnNoteHeight:billFather.bf_billNote];

    self.amountTextF.text = [NSString stringWithFormat:@"%.2f",billFather.bf_billAmount];
    self.nameTextF.text = billFather.bf_billName;
    self.dateLabel.text = [self returnInitDate:editBill.dateTime];
    self.repeatDetailLabel.text = _repeatString;
    self.datePicker.date = billFather.bf_billDueDate;
    
    if (billFather.bf_billRule.ep_billEndDate) {
        self.endDateLabel.text = [NSString stringWithFormat:@"End on %@",[self returnInitDate:billFather.bf_billRule.ep_billEndDate]];
    }else{
        self.endDateLabel.text = @"Forever";
    }
    self.notifDetailLabel.text = [NSString stringWithFormat:@"%@ %@",_remindMeString,[self reminderDatePickValueChange:_remindAtDate]];
    self.noteLabel.text = _noteString;
    
    if (![_repeatString isEqualToString:@"Never"]) {
        _repeatShow = YES;
        _fRepeatBtn.hidden = YES;
    }
    if (![_remindMeString isEqualToString:@"None"]) {
        _notifShow = YES;
        _fNotifBtn.hidden = YES;
    }
    if (billFather.bf_billNote.length > 0) {
        _noteShow = YES;
        _fNoteBtn.hidden = YES;
    }
    if (_noteShow && _notifShow && _repeatShow) {
        _functionCellShow = NO;
    }else{
        _functionCellShow = YES;
    }
    
    [self setEditBillThreeBtnImageView];
    [self setFunctionBtnFrame];

}

- (IBAction)cancelBtnClick:(id)sender {
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.nameTextF.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Name is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([self.amountTextF.text doubleValue]  == 0.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_Amount is required.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
  
    
    if (!billFather) {
        [self saveNewBill];
    }else{
        [self saveEditBill];
    }
    [self flurryConfig];

}

-(void)flurryConfig{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([_repeatString isEqualToString:@"Never"]) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_REPT"];
    }
    if (![_remindMeString isEqualToString:@"None"]) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"13_BIL_ALRT"];
    }
    if (!billFather) {
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"11_BIL_ADD"];
    }
}

-(void)saveEditBill{
    
    EP_BillRule* editBill = billFather.bf_billRule;

    if ([editBill.ep_recurringType isEqualToString:@"Never"]) {
      billFather.bf_billName =  editBill.ep_billName = self.nameTextF.text;
        editBill.ep_billAmount = [NSNumber numberWithDouble:[self.amountTextF.text doubleValue]];
        editBill.ep_billDueDate = self.datePicker.date;
        editBill.ep_billEndDate = _endDate;
        editBill.ep_reminderDate = _remindMeString;
        editBill.ep_reminderTime = _remindAtDate;
        editBill.ep_recurringType = _repeatString;
        editBill.ep_note = _noteString;
        editBill.billRuleHasCategory = _selectCategory;
        editBill.dateTime = [NSDate date];
        editBill.updatedTime = [NSDate date];
        
        Payee* payee = [[[XDDataManager shareManager]getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"name = %@ and state = %@",self.nameTextF.text,@"1"] sortDescriptors:nil]lastObject];
        if (!payee) {
            Payee* newPayee = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
            newPayee.name = self.nameTextF.text;
            newPayee.memo = _noteString;
            newPayee.dateTime = self.datePicker.date;;
            newPayee.state = @"1";
            newPayee.uuid = [EPNormalClass GetUUID];
            newPayee.category = _selectCategory;
            newPayee.tranType = @"expense";
            newPayee.orderIndex = @1;
            newPayee.updatedTime = [NSDate date];
            
            
            if ([PFUser currentUser]){
                [[ParseDBManager sharedManager]updatePayeeFromLocal:newPayee];
            }
            editBill.billRuleHasPayee = newPayee;
            
        }else{
            payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
            payee.updatedTime = [NSDate date];
            editBill.billRuleHasPayee = payee;
        }
        [[XDDataManager shareManager]saveContext];
        
        if ([PFUser currentUser]){
            [[ParseDBManager sharedManager]updatePayeeFromLocal:payee];
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:editBill];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([self.delegate respondsToSelector:@selector(returnBillCompletion)]) {
            [self.delegate returnBillCompletion];
        }
        
    }else{
        if (self.billFather.bf_billItem != nil)
        {
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSError *errors = nil;

            NSFetchRequest *fetchBillItem = [[NSFetchRequest alloc]initWithEntityName:@"EP_BillItem"];
            NSMutableArray *billItemArray = [[NSMutableArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetchBillItem error:&errors]];
            
            BOOL hasFound = NO;
            for (long int i=0; i<[billItemArray count]; i++) {
                EP_BillItem *oneBillItem = [billItemArray objectAtIndex:i];
                if (oneBillItem == self.billFather.bf_billItem)
                {
                    hasFound = YES;
                    break;
                }
            }
            if (!hasFound)
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            
        }
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:self.billFather.bf_billName];
        NSString *meg = string1;
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        //在iPhone中最好用这种方法
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        appDelegate.appActionSheet = actionSheet;
    }
    
   
}

-(void)saveNewBill{
    
    EP_BillRule* bill = [[XDDataManager shareManager] insertObjectToTable:@"EP_BillRule"];
    bill.ep_billName = self.nameTextF.text;
    bill.ep_billAmount = [NSNumber numberWithDouble:[self.amountTextF.text doubleValue]];
    bill.ep_billDueDate = self.datePicker.date;
    bill.ep_billEndDate = _endDate;
    bill.ep_reminderDate = _remindMeString;
    bill.ep_reminderTime = _remindAtDate;
    bill.ep_recurringType = _repeatString;
    bill.ep_note = _noteString;
    bill.billRuleHasCategory = _selectCategory;
    bill.dateTime = self.datePicker.date;
    bill.state = @"1";
    bill.uuid = [EPNormalClass GetUUID];
    bill.updatedTime = [NSDate date];
    
    Payee* payee = [[[XDDataManager shareManager]getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"name = %@ and state = %@",self.nameTextF.text,@"1"] sortDescriptors:nil]lastObject];
    if (!payee) {
        Payee* newPayee = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
        newPayee.name = self.nameTextF.text;
        newPayee.memo = _noteString;
        newPayee.dateTime = [NSDate date];
        newPayee.state = @"1";
        newPayee.uuid = [EPNormalClass GetUUID];
        newPayee.category = _selectCategory;
        newPayee.tranType = @"expense";
        newPayee.orderIndex = @1;
        newPayee.updatedTime = [NSDate date];
        
        
        if ([PFUser currentUser]){
            [[ParseDBManager sharedManager]updatePayeeFromLocal:newPayee];
        }
        bill.billRuleHasPayee = newPayee;

    }else{
        payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
        payee.updatedTime = [NSDate date];
        bill.billRuleHasPayee = payee;
    }
    [[XDDataManager shareManager]saveContext];

    if ([PFUser currentUser]){
        [[ParseDBManager sharedManager]updatePayeeFromLocal:payee];
        [[ParseDBManager sharedManager]updateBillRuleFromLocal:bill];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(returnBillCompletion)]) {
        [self.delegate returnBillCompletion];
        [self.delegate newBillSave];
    }
}

- (IBAction)categoryBtnClick:(id)sender {
    [self.view endEditing:YES];

    if (self.categoryBackView.y==SCREEN_HEIGHT) {
        self.backView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryBackView.y = SCREEN_HEIGHT - SCREEN_WIDTH - 80;
            self.backView.alpha = 0.5;
        }];
    }else{
        [self tapClick];
    }
    
}
- (IBAction)categoryEditClick:(id)sender {
    TransactionCategoryViewController* vc = [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
    vc.xxdDelegate = self;
    vc.type = TransactionExpense;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
}

- (IBAction)cellDismiss:(id)sender {
    [self.view endEditing:YES];

    UIButton* btn = sender;
    if (btn.tag == 0) {
        _repeatShow = NO;
        _repeatString = nil;
        self.fRepeatBtn.width = 0.01;
        self.fRepeatBtn.hidden = NO;
    }else if (btn.tag == 1){
        _notifShow = NO;
        _remindAtDate = nil;
        _remindMeString = @"None";
        self.endDateLabel.text = @"End date";
        self.fNotifBtn.width = 0.01;
        self.fNotifBtn.hidden = NO;
    }else{
        _noteShow = NO;
        _noteString = nil;
        self.fNoteBtn.width = 0.01;
        self.fNoteBtn.hidden = NO;
    }
    
    _functionCellShow = YES;
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

- (IBAction)functionBtnClick:(id)sender {
    [self.view endEditing:YES];

    UIButton* btn = sender;

    UINavigationController* nav;
    
    if (btn.tag == 0) {
        _repeatShow = !_repeatShow;
        
        XDBillRepeatTableViewController* vc = [[XDBillRepeatTableViewController alloc]init];
        vc.repeatString = _repeatString;
        vc.xxdDelegate = self;
        nav = [[UINavigationController alloc]initWithRootViewController:vc];
    }else if (btn.tag == 1){
        _notifShow = !_notifShow;
        
        XDBillNotifTableViewController* vc = [[XDBillNotifTableViewController alloc]initWithNibName:@"XDBillNotifTableViewController" bundle:nil];
        vc.xxdDelegate = self;
        nav = [[UINavigationController alloc]initWithRootViewController:vc];
    }else{
        _noteShow = !_noteShow;
        
        XDTranscationNoteViewController* vc = [[XDTranscationNoteViewController alloc]initWithNibName:@"XDTranscationNoteViewController" bundle:nil];
        vc.delegate = self;
        nav = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    [self presentViewController:nav animated:YES completion:nil];

}


-(void)setupThreeBtnImageView{
    CGFloat width = SCREEN_WIDTH/3;
   UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circulation"]];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    imageView.center = CGPointMake(self.fRepeatBtn.width/2, self.fRepeatBtn.height/2);
    [self.fRepeatBtn addSubview:imageView];
    self.fRepeatBtn.frame = CGRectMake(0, 0, width, 56);
    
   UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remind"]];
    imageView1.frame = CGRectMake(0, 0, 30, 30);
    imageView1.center = CGPointMake(self.fNotifBtn.width/2, self.fNotifBtn.height/2);
    [self.fNotifBtn addSubview:imageView1];
    self.fNotifBtn.frame =CGRectMake(width, 0, width, 56);
    
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remark"]];
    imageView2.frame = CGRectMake(0, 0, 30, 30);
    imageView2.center = CGPointMake(self.fNoteBtn.width/2, self.fNoteBtn.height/2);
    [self.fNoteBtn addSubview:imageView2];
    self.fNoteBtn.frame =CGRectMake(width*2, 0, width, 56);
}

-(void)setEditBillThreeBtnImageView{
    
    CGFloat width = SCREEN_WIDTH/3;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circulation"]];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    self.fRepeatBtn.frame = CGRectMake(0, 0, 0, 56);
    imageView.center = CGPointMake(self.fRepeatBtn.width/2, self.fRepeatBtn.height/2);
    [self.fRepeatBtn addSubview:imageView];

    UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remind"]];
    imageView1.frame = CGRectMake(0, 0, 30, 30);
    self.fNotifBtn.frame =CGRectMake(width, 0, width, 56);
    imageView1.center = CGPointMake(self.fNotifBtn.width/2, self.fNotifBtn.height/2);
    [self.fNotifBtn addSubview:imageView1];
    
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remark"]];
    imageView2.frame = CGRectMake(0, 0, 30, 30);
    self.fNoteBtn.frame =CGRectMake(width*2, 0, width, 56);
    imageView2.center = CGPointMake(self.fNoteBtn.width/2, self.fNoteBtn.height/2);
    [self.fNoteBtn addSubview:imageView2];
}

#pragma mark - edit category delegate
-(void)returnTransactionCategoryChange{
    self.categoryView.transactionType = TransactionExpense;
    [self.categoryView reloadData];
}

#pragma mark - text delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTextF) {
        [self tapGesClick];
    }
    return YES;
}

#pragma mark - XDTransactionCatgroyViewDelegate
-(void)returnSelectCategory:(Category *)category{
    _selectCategory = category;
    
    self.categoryL.text = [[_selectCategory.categoryName componentsSeparatedByString:@": "]lastObject];
    [self.categoryBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[_selectCategory.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
    self.navBackView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:_selectCategory.iconName]];


    [self tapClick];
    [self.amountTextF becomeFirstResponder];
}

- (void)returnCurrentPage:(NSInteger)index {
    self.pageControl.currentPage = index;
}

#pragma mark - XDBillNotifTableViewDelegate
-(void)returnBillNotifRemindMe:(NSString *)remindMe remindAt:(NSDate *)remindAt{
    
    if ([remindMe isEqualToString:@"None"]) {
        _remindMeString = remindMe;
        _remindAtDate = nil;
        
        _notifShow = NO;
        self.fNotifBtn.hidden = NO;
        [self.tableView reloadData];
        [self setFunctionBtnFrame];
        self.notifDetailLabel.text = nil;
        
        return;
    }
    
    _remindMeString = remindMe;
    _remindAtDate = remindAt;
    
    self.notifDetailLabel.text = [NSString stringWithFormat:@"%@ %@",remindMe,[self reminderDatePickValueChange:remindAt]];
    
    _notifShow = YES;
    self.fNotifBtn.hidden = YES;
    [self.tableView reloadData];
    
    [self setFunctionBtnFrame];
}

#pragma mark - XDBillRepeatTableViewDelegate
-(void)returnBillRepeatSelect:(NSString *)string{
    _repeatString = string;
    self.repeatDetailLabel.text = [self coverRepeatString:string];
    
    if (_repeatString && ![_repeatString isEqualToString:@""]) {
        _repeatShow = YES;
    }else{
        _repeatShow = NO;
    }
    
    self.fRepeatBtn.hidden = YES;
    [self.tableView reloadData];
    
    [self setFunctionBtnFrame];
}


-(NSString*)coverRepeatString:(NSString*)recurringText{
    
    if ([recurringText isEqualToString:@"Never"])
    {
        return  NSLocalizedString(@"VC_Never", nil);
    }
    else if ([recurringText isEqualToString:@"Weekly"])
    {
        return NSLocalizedString(@"VC_Weekly", nil);
    }
    else if ([recurringText isEqualToString:@"Two Weeks"])
    {
        return  NSLocalizedString(@"VC_Every2Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Every 4 Weeks"])
    {
        return  NSLocalizedString(@"VC_Every4Weeks", nil);
    }
    else if ([recurringText isEqualToString:@"Semimonthly"])
    {
        return  NSLocalizedString(@"VC_Semimonthly", nil);
    }
    else if ([recurringText isEqualToString:@"Monthly"])
    {
        return  NSLocalizedString(@"VC_Monthly", nil);
    }
    else if ([recurringText isEqualToString:@"Every 2 Months"])
    {
        return  NSLocalizedString(@"VC_Every2Months", nil);
    }
    else if ([recurringText isEqualToString:@"Every 3 Months"])
    {
        return  NSLocalizedString(@"VC_Every3Months", nil);
    }
    else
    {
        return  NSLocalizedString(@"VC_EveryYear", nil);
    }
}

#pragma mark - XDBillEndDateTableViewDelegate
-(void)returnEndDate:(NSDate *)endDate{
    _endDate = endDate;
    if (endDate == nil) {
        self.endDateLabel.text = NSLocalizedString(@"VC_Forever",nil);
    }else{
        self.endDateLabel.text = [NSString stringWithFormat:@"End on %@",[self returnInitDate:_endDate]];
    }
}

#pragma mark - XDTranscationNoteViewDelegate
-(void)returnNote:(NSString *)note
{
    _noteString = note;
    
    if (note.length > 0) {
        self.fNoteBtn.hidden = YES;
        _noteShow = YES;
        _noteHeight = [self returnNoteHeight:note];
        self.noteLabel.text = _noteString;
        [self.tableView reloadData];
        
        [self setFunctionBtnFrame];
    }else{
        self.fNoteBtn.hidden = NO;
        _noteShow = NO;
        _noteHeight = 56;
        self.noteLabel.text = nil;
        
        [self cellDismiss:self.fNoteBtn];
        
//        [self.tableView reloadData];

    }
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noteShow && _notifShow && _repeatShow) {
        if (indexPath.row == 5) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
        }
    }else{
        if (indexPath.row == 6) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            }
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return _datePickerShow?224:0.01;
    }else  if (indexPath.row == 2) {
        return _repeatShow?56:0.01;
    }else if (indexPath.row == 3) {
        if (billFather) {
            return 0.01;
        }else{
            if (![_repeatString isEqualToString:@"Never"] && _repeatString) {
                return 56;
            }else{
                return 0.01;
            }
        }
    }else if (indexPath.row == 4) {
        return _notifShow?56:0.01;
    }else if (indexPath.row == 5) {
        if (_noteShow) {
            if (_noteHeight>56) {
                return _noteHeight;
            }else{
                return 56;
            }
        }else{
            return 0.01;
        }
    }else if (indexPath.row == 6) {
        return _functionCellShow?56:0.01;
    }
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
            return self.dateCell;
            break;
        case 1:
            return self.datePickerCell;
            break;
        case 2:
            return self.repeatCell;
            break;
        case 3:
            return self.endDateCell;
            break;
        case 4:
            return self.notifCell;
            break;
        case 5:
            return self.noteCell;
            break;
        case 6:
            return self.functionCell;
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];

    if (indexPath.row == 0) {
        _datePickerShow = !_datePickerShow;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }else if (indexPath.row == 2){
        XDBillRepeatTableViewController* vc = [[XDBillRepeatTableViewController alloc]init];
        vc.repeatString = _repeatString;
        vc.xxdDelegate = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }else if (indexPath.row == 3){
        XDBillEndDateTableViewController* vc = [[XDBillEndDateTableViewController alloc]initWithNibName:@"XDBillEndDateTableViewController" bundle:nil];
        vc.endDate = _endDate;
        vc.xxdDelegate = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        
    }else if(indexPath.row == 4){
        XDBillNotifTableViewController* vc = [[XDBillNotifTableViewController alloc]initWithNibName:@"XDBillNotifTableViewController" bundle:nil];
        vc.xxdDelegate = self;
        vc.remindDate = _remindAtDate;
        vc.remindStr = _remindMeString;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        
    }else if(indexPath.row == 5){
        
        XDTranscationNoteViewController* vc = [[XDTranscationNoteViewController alloc]initWithNibName:@"XDTranscationNoteViewController" bundle:nil];
        vc.delegate = self;
        vc.noteStr = _noteString;
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}

- (IBAction)datePickerValueChanged:(id)sender {
    UIDatePicker* picker = (id)sender;
    
    self.dateLabel.text = [self returnInitDate:picker.date];
}

-(NSString*)returnInitDate:(NSDate*)date{
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:dayInfoUnits fromDate:date];
    
    NSDate* newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"ccc, LLL d, yyyy";
    NSString* dateStr = [formatter stringFromDate:newDate];
    if ([[date initDate] compare:[[NSDate date]initDate]] == NSOrderedSame) {
        return @"Today";
    }
    
    return dateStr;
    
}

-(void)setFunctionBtnFrame{
    NSMutableArray* muArr =[NSMutableArray array];
    for (UIButton* btn in self.functionCell.contentView.subviews) {
        if (btn.hidden == NO) {
            [muArr addObject:btn];
        }
    }
    
    if (muArr.count == 0) {
        _functionCellShow = NO;
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    
    CGFloat width = SCREEN_WIDTH/muArr.count;
    
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    NSArray* array = [muArr sortedArrayUsingDescriptors:@[sort]];
    
    
    for (int i = 0; i < array.count; i++) {
        UIButton* btn = array[i];
        btn.frame = CGRectMake(i * width, 0, width, 56);
        UIImageView* imgv = btn.subviews.lastObject;
        imgv.centerX = btn.width/2;
    }
}

-(NSString*)reminderDatePickValueChange:(NSDate*)date;
{
    if (!date) {
        return nil;
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeStyle=NSDateFormatterShortStyle;
    dateFormatter.dateStyle=NSDateFormatterNoStyle;
    return  [dateFormatter stringFromDate:date];
}


-(CGFloat)returnNoteHeight:(NSString*)note{
    
    CGSize labelSize = [note boundingRectWithSize:CGSizeMake(self.noteLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    return labelSize.height+30;
    
}

#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    if (buttonIndex==2)
    {
        return;
    }
    //更改掉后面所有的bill
    else if (buttonIndex==1)
    {
        Payee* payee = [[[XDDataManager shareManager]getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"name = %@ and state = %@",self.nameTextF.text,@"1"] sortDescriptors:nil]lastObject];
        if (!payee) {
            Payee* newPayee = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
            newPayee.name = self.nameTextF.text;
            newPayee.memo = _noteString;
            newPayee.dateTime = self.datePicker.date;;
            newPayee.state = @"1";
            newPayee.uuid = [EPNormalClass GetUUID];
            newPayee.category = _selectCategory;
            newPayee.tranType = @"expense";
            newPayee.orderIndex = @1;
            newPayee.updatedTime = [NSDate date];
            
            
            if ([PFUser currentUser]){
                [[ParseDBManager sharedManager]updatePayeeFromLocal:newPayee];
            }
            
        }else{
            payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
            payee.updatedTime = [NSDate date];
        }
        
        //首先判断当前修改的bill是不是这个bill1中的第一个，如果是第一个的话，就不需要重新创建bill1
        EP_BillRule *anotherBill;
        if ([appDelegate.epnc dateCompare:self.billFather.bf_billDueDate withDate:self.billFather.bf_billRule.ep_billDueDate]==0)
        {
            //------------修改这个循环bill1中的数据
            anotherBill = self.billFather.bf_billRule;
            //修改billItem
            self.billFather.bf_billItem.ep_billItemName = self.nameTextF.text;
            self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:[self.amountTextF.text doubleValue]];
            self.billFather.bf_billItem.ep_billItemNote = _noteString;
            
            self.billFather.bf_billItem.ep_billItemReminderDate = _remindMeString;
            self.billFather.bf_billItem.ep_billItemReminderTime = _remindAtDate;
            self.billFather.bf_billItem.billItemHasCategory = _selectCategory;
            
            
            self.billFather.bf_billItem.billItemHasPayee = payee;
            
            self.billFather.bf_billItem.dateTime = [NSDate date];
            //transaction还保持原来的
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
            
            //            if (appDelegate.dropbox.drop_account.linked){
            //                [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
            //            }
            
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:self.billFather.bf_billItem];
            }
        }
        else
        {
            EP_BillRule *theOldBill = self.billFather.bf_billRule;
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [cal components:flags fromDate:self.billFather.bf_billDueDate];
            [components setMonth:components.month];
            [components setDay:components.day -1 ];
            NSDate *endDate =[[NSCalendar  currentCalendar]dateFromComponents:components];
            
            theOldBill.ep_billEndDate = endDate;
            theOldBill.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
            //            if (appDelegate.dropbox.drop_account.linked)
            //            {
            //                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:theOldBill];
            //            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:theOldBill];
            }
            //-------------重新创建 bill1 对象
            anotherBill = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
            anotherBill.uuid = [EPNormalClass GetUUID];
        }
        
        anotherBill.ep_billName = self.nameTextF.text;
        anotherBill.ep_billAmount = [NSNumber numberWithDouble:[self.amountTextF.text doubleValue]];
        
        anotherBill.ep_billDueDate = self.datePicker.date;
        anotherBill.ep_recurringType = _repeatString;
        anotherBill.ep_billEndDate = _endDate;
        
        anotherBill.ep_reminderDate = _remindMeString;
        anotherBill.ep_reminderTime = _remindAtDate;
        anotherBill.ep_note = _noteString;
        
        
        //        anotherBill.billRuleHasBillItem = nil;
        anotherBill.billRuleHasCategory = _selectCategory;
        anotherBill.billRuleHasPayee = payee;
        anotherBill.billRuleHasTransaction = nil;
        
        anotherBill.state = @"1";
        anotherBill.dateTime = [NSDate date];
        if (![appDelegate.managedObjectContext save:&error])
        {
            
        }
        //        if (appDelegate.dropbox.drop_account.linked)
        //        {
        //            [appDelegate.dropbox updateEveryBillRuleDataFromLocal:anotherBill];
        //        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillRuleFromLocal:anotherBill];
        }
        //删除旧的bk_billItem对象，将对应的Transaction的外键保存好。
        if ([[self.billFather.bf_billRule.billRuleHasBillItem allObjects]count]>0)
        {
            NSMutableArray *tmpBilloArray = [[NSMutableArray alloc]initWithArray:[self.billFather.bf_billRule.billRuleHasBillItem allObjects]];
            
            for (int tmpi=0; tmpi<[tmpBilloArray count]; tmpi ++)
            {
                EP_BillItem *tmpBillO = [tmpBilloArray objectAtIndex:tmpi];
                
                //如果这个billItem比当前修改的时间迟的话，就将billItem归入newBill中
                if ([tmpBillO.ep_billItemDueDate compare:self.datePicker.date] == NSOrderedDescending) {
                    if ([[tmpBillO.billItemHasTransaction allObjects]count]>0)
                    {
                        //删除后期的billItem
                        tmpBillO.state = @"0";
                        tmpBillO.dateTime = [NSDate date];
                        if (![appDelegate.managedObjectContext save:&error])
                        {
                            
                        }
                        //                            if (appDelegate.dropbox.drop_account.linked)
                        //                            {
                        //                                [appDelegate.dropbox updateEveryBillItemDataFromLocal:tmpBillO];
                        //                            }
                        if ([PFUser currentUser])
                        {
                            [[ParseDBManager sharedManager]updateBillItemFormLocal:tmpBillO];
                        }
                    }
                    
                }
                
            }
            
        }
    }else{
        
        
        Payee* payee = [[[XDDataManager shareManager]getObjectsFromTable:@"Payee" predicate:[NSPredicate predicateWithFormat:@"name = %@ and state = %@",self.nameTextF.text,@"1"] sortDescriptors:nil]lastObject];
        if (!payee) {
            Payee* newPayee = [[XDDataManager shareManager]insertObjectToTable:@"Payee"];
            newPayee.name = self.nameTextF.text;
            newPayee.memo = _noteString;
            newPayee.dateTime = self.datePicker.date;;
            newPayee.state = @"1";
            newPayee.uuid = [EPNormalClass GetUUID];
            newPayee.category = _selectCategory;
            newPayee.tranType = @"expense";
            newPayee.orderIndex = @1;
            newPayee.updatedTime = [NSDate date];
            
            
            if ([PFUser currentUser]){
                [[ParseDBManager sharedManager]updatePayeeFromLocal:newPayee];
            }
            
        }else{
            payee.orderIndex = [NSNumber numberWithInteger:[payee.orderIndex integerValue]+1];
            payee.updatedTime = [NSDate date];
        }
        
        
        //----------1.创建bill2 类
        if (self.billFather.bf_billItem == nil) {
            self.billFather.bf_billItem = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
            //如果是新建一个BillO,那么需要设定他对应Bill中某一天，如果是老的就不需要设定，就是原始的billDuedate
            self.billFather.bf_billItem.ep_billItemDueDate = self.billFather.bf_billDueDate;
            self.billFather.bf_billItem.billItemHasTransaction = nil;
            
            self.billFather.bf_billItem.ep_billItemString1 = [NSString stringWithFormat:@"%@ %@",self.billFather.bf_billRule.uuid,[appDelegate.epnc getUUIDFromData:self.billFather.bf_billDueDate]];
            
            self.billFather.bf_billItem.state=@"1";
            self.billFather.bf_billItem.uuid = [EPNormalClass GetUUID];
            
        }
        self.billFather.bf_billItem.ep_billItemName = self.nameTextF.text;
        self.billFather.bf_billItem.ep_billItemAmount = [NSNumber numberWithDouble:[self.amountTextF.text doubleValue]];
        self.billFather.bf_billItem.ep_billItemDueDateNew = self.datePicker.date;
        self.billFather.bf_billItem.ep_billItemRecurringType = _repeatString;
        self.billFather.bf_billItem.ep_billItemEndDate = _endDate;
        self.billFather.bf_billItem.ep_billItemNote = _noteString;
        
        self.billFather.bf_billItem.ep_billItemReminderDate = _remindMeString;
        self.billFather.bf_billItem.ep_billItemReminderTime = _remindAtDate;
        
        self.billFather.bf_billItem.billItemHasBillRule = self.billFather.bf_billRule;
        self.billFather.bf_billItem.billItemHasCategory = _selectCategory;
        self.billFather.bf_billItem.billItemHasPayee = payee;
        
        self.billFather.bf_billItem.dateTime = [NSDate date];
        //transaction还保持原来的
        
        if (![appDelegate.managedObjectContext save:&error]) {
            
        }
        
        //        if (appDelegate.dropbox.drop_account.linked){
        //            [appDelegate.dropbox updateEveryBillItemDataFromLocal:self.billFather.bf_billItem];
        //        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateBillItemFormLocal:self.billFather.bf_billItem];
        }
        
        [appDelegate.epdc saveBillItem:self.billFather.bf_billItem];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(returnBillCompletion)]) {
        [self.delegate returnBillCompletion];
    }
}



@end

//
//  XDAddPayViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/10.
//

#import "XDAddPayViewController.h"
#import "XDTransactionHelpClass.h"
#import "Accounts.h"
#import "Transaction.h"
#import "EPNormalClass.h"
#import "EP_BillItem.h"
#import "Category.h"
#import "Payee.h"
#import <Parse/Parse.h>
#import "EP_BillRule.h"
#import "ParseDBManager.h"
#import "numberKeyboardView.h"
#import "AppDelegate_iPhone.h"
@import Firebase;
@interface XDAddPayViewController ()
{
    NSMutableArray* _accountMuArr;
    
    Accounts* _selectAccount;
    
    BOOL _showAccountPick;
    BOOL _showDatePick;
    
}
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIView *navBackView;

@property(nonatomic, strong)numberKeyboardView * keyboard;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pickCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *accountPick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBackViewH;
@property(nonatomic, strong)ADEngineController* interstitial;

@end

@implementation XDAddPayViewController
@synthesize billFather,transaction;

-(numberKeyboardView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[[NSBundle mainBundle]loadNibNamed:@"numberKeyboardView" owner:self options:nil]lastObject];
        __weak __typeof__(self) weakSelf = self;
        _keyboard.amountBlock = ^(NSString *string) {
            //            NSLog(@"amount == %@",string);
            weakSelf.amountTF.text = string;
        };
    }
    return _keyboard;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (billFather) {
        
        [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[billFather.bf_category.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navBackView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:billFather.bf_category.iconName]];
        self.nameLabel.text = billFather.bf_billName;
        if (_accountMuArr.count > 0) {
            _selectAccount = _accountMuArr[0];
        }
        self.accountLabel.text = _selectAccount.accName;
        
//        AppDelegate_iPhone *appDeleagte_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

        NSMutableArray* dataMuArr = [NSMutableArray array];

        double paymentAmount = 0.00;
        NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
        if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else{
            [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
        }
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTime" ascending:NO];
        
        NSArray *sortedArray = [paymentArray sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sort, nil]];
        
        [paymentArray setArray:sortedArray];
        if ([paymentArray count]>0) {
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *oneTrans = [paymentArray objectAtIndex:i];
                if ([oneTrans.state isEqualToString:@"1"]) {
                    [dataMuArr addObject:oneTrans];
                }
            }
        }
        for (int i=0; i<[dataMuArr count]; i++) {
            Transaction *payment = [dataMuArr objectAtIndex:i];
            paymentAmount += [payment.amount doubleValue];
        }
        double unpaidAmount = 0;
        if (billFather.bf_billAmount > paymentAmount) {
            unpaidAmount = billFather.bf_billAmount - paymentAmount;
        }
        self.amountTF.text = [NSString stringWithFormat:@"%.2f",unpaidAmount];
    }
    
    if (transaction) {
        [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png",[[transaction.category.iconName componentsSeparatedByString:@"."]firstObject]]] forState:UIControlStateNormal];
        self.navBackView.backgroundColor = [UIColor mostColor:[UIImage imageNamed:transaction.category.iconName]];
        self.nameLabel.text = transaction.payee.name;
        self.amountTF.text = [NSString stringWithFormat:@"%.2f",[transaction.amount doubleValue]];
        self.dateLabel.text = [self returnInitDate:transaction.dateTime];
        self.datePicker.date = transaction.dateTime;
        _selectAccount = transaction.expenseAccount;
        self.accountLabel.text = transaction.expenseAccount.accName;
        NSInteger index = [_accountMuArr indexOfObject:_selectAccount];
        [self.accountPick selectRow:index inComponent:0 animated:NO];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.navBackViewH.constant = 188;
    }
    _accountMuArr = [NSMutableArray arrayWithArray:[XDTransactionHelpClass getTransactionAccounts]];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.amountTF setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.amountTF.inputView = self.keyboard;
    self.tableView.separatorColor = RGBColor(226, 226, 226);

    //插页广告
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.isPurchased) {
        [self.interstitial nowShowInterstitialAdWithTarget:self];
    }
    [FIRAnalytics setScreenName:@"bill_add_payment_view_iphone" screenClass:@"XDAddPayViewController"];

}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveClick:(id)sender {
    if ([self.amountTF.text doubleValue] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_Amount is required.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!_selectAccount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"VC_To Account is required.", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    if (billFather) {
        EP_BillItem* item = billFather.bf_billItem;
        if (![billFather.bf_billRecurringType isEqualToString:@"Never"]) {
            if (!item) {
                item = [[XDDataManager shareManager]insertObjectToTable:@"EP_BillItem"];
                item.ep_billItemName = billFather.bf_billName;
                item.ep_billItemAmount = @(billFather.bf_billAmount);
                item.dateTime = [NSDate date];
                item.billItemHasPayee = billFather.bf_payee;
                item.billItemHasBillRule = billFather.bf_billRule;
                item.billItemHasCategory = billFather.bf_category;
                item.ep_billItemRecurringType = billFather.bf_billRecurringType;
                item.state = @"1";
                item.uuid = [EPNormalClass GetUUID];
                item.updatedTime = [NSDate date];
                
                item.ep_billItemString1 = [NSString stringWithFormat:@"%@ %@",billFather.bf_billRule.uuid,[self getUUIDFromData:billFather.bf_billDueDate]];
                item.ep_billItemDueDate = billFather.bf_billDueDate;
                item.ep_billItemDueDateNew = billFather.bf_billDueDate;
                item.ep_billItemReminderDate = billFather.bf_billReminderDate;
                item.ep_billItemReminderTime = billFather.bf_billReminderTime;
                item.ep_billItemNote = billFather.bf_billNote;
                
                billFather.bf_billItem = item;
                
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:item];
                }
            }
        }
        
        Transaction* tran = [[XDDataManager shareManager]insertObjectToTable:@"Transaction"];
        tran.payee = billFather.bf_payee;
        tran.dateTime = self.datePicker.date;
        tran.dateTime_sync = tran.updatedTime = [NSDate date];
        tran.expenseAccount = _selectAccount;
        tran.photoName = nil;
        tran.isClear = @YES;
        tran.recurringType = @"Never";
        tran.incomeAccount = nil;
        tran.amount = @([self.amountTF.text doubleValue]);
        tran.category = billFather.bf_category;
        tran.uuid = [EPNormalClass GetUUID];
        tran.state = @"1";
        tran.notes = @"Payment of Bill";
        tran.transactionHasBillRule = billFather.bf_billRule;
        tran.transactionHasBillItem = billFather.bf_billItem;
        tran.transactionType = @"expense";
        [[XDDataManager shareManager] saveContext];
        
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:tran];
        }
        
    }
    
    if (transaction){
        transaction.amount = @([self.amountTF.text doubleValue]);
        transaction.dateTime = self.datePicker.date;
        transaction.dateTime_sync = transaction.updatedTime = [NSDate date];
        transaction.expenseAccount = _selectAccount;
        
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:transaction];
        }
        [[XDDataManager shareManager] saveContext];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TransactionViewRefresh" object:nil];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate.epnc setFlurryEvent_WithIdentify:@"11_BIL_PAY"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)getUUIDFromData:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMddyyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (IBAction)pickerValueChanged:(id)sender {
    self.dateLabel.text = [self returnInitDate:self.datePicker.date];
}

#pragma mark -tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return self.firstCell;
            break;
        case 1:
            return self.accountCell;
            break;
        case 2:
            return self.secondCell;
            break;
        case 3:
            return self.pickCell;
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return _showAccountPick?224:0.01;
    }
    if (indexPath.row == 3) {
        return _showDatePick?191:0.01;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        _showAccountPick = !_showAccountPick;
    }
    
    if (indexPath.row == 2) {
        _showDatePick = !_showDatePick;
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}



#pragma mark - picker


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _accountMuArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    _selectAccount = _accountMuArr[row];
    
    self.accountLabel.text = _selectAccount.accName;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    Accounts* account = _accountMuArr[row];
    return account.accName;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{

    return 40;
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //插页广告
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        if (!appDelegate.isPurchased) {
            self.interstitial = [[ADEngineController alloc] initLoadADWithAdPint:@"PE1205 - iPhone - Interstitial - BillAddPaid"];
            
        }
    }
    return self;
}

@end

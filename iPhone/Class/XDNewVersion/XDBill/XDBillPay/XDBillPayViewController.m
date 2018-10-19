//
//  XDBillPayViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/4/9.
//

#import "XDBillPayViewController.h"
#import "Category.h"
#import "XDAddPayViewController.h"
#import "EP_BillItem.h"
#import "AppDelegate_iPhone.h"
#import "XDBillItemTableViewCell.h"
#import "EP_BillRule.h"
#import "XDAddBillViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"
@import Firebase;

@interface XDBillPayViewController ()<XDAddBillViewDelegate>
{
    NSMutableArray* _dataMuArr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeading;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addPayBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom2Leading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeading;
@property (weak, nonatomic) IBOutlet UIView *paidBackView;

@property (weak, nonatomic) IBOutlet UILabel *paidBackLabel;

@end

@implementation XDBillPayViewController
@synthesize billFather;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self getDataSource];
}

-(void)getDataSource{
    AppDelegate_iPhone *appDeleagte_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    self.icon.image = [UIImage imageNamed:billFather.bf_category.iconName];
    self.nameLabel.text = billFather.bf_billName;
    
    self.totalLabel.text = [XDDataManager moneyFormatter:billFather.bf_billAmount];
    
    _dataMuArr = [NSMutableArray array];
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
                [_dataMuArr addObject:oneTrans];
            }
        }
    }
    for (int i=0; i<[_dataMuArr count]; i++) {
        Transaction *payment = [_dataMuArr objectAtIndex:i];
        paymentAmount += [payment.amount doubleValue];
    }
    self.paidLabel.text = [appDeleagte_iPhone.epnc formatterString:paymentAmount];
    double unpaidAmount = 0;
    if (billFather.bf_billAmount > paymentAmount) {
        unpaidAmount = billFather.bf_billAmount - paymentAmount;
    }
//    self.amountLabel.text = [appDeleagte_iPhone.epnc formatterString:unpaidAmount];
    self.amountLabel.attributedText = [[NSAttributedString alloc]initWithString:[XDDataManager moneyFormatter:unpaidAmount] attributes:@{NSKernAttributeName:@(-2.5f)}];
    
    if (unpaidAmount == 0) {
        self.paidBackLabel.text = NSLocalizedString(@"VC_Paid", nil);
        self.addPayBtn.hidden = YES ;
    }else{
        self.addPayBtn.hidden = NO;
        if (sortedArray.count == 0) {
            [self.addPayBtn setTitle:NSLocalizedString(@"VC_PayBill", nil) forState:UIControlStateNormal];
        }else{
            [self.addPayBtn setTitle:NSLocalizedString(@"VC_AddPayment", nil) forState:UIControlStateNormal];
        }
    }
    
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FIRAnalytics setScreenName:@"bill_pay_payment_view_iphone" screenClass:@"XDBillPayViewController"];

    if (IS_IPHONE_X) {
        self.topViewLeading.constant = 88;
        self.bottomLeading.constant = 34;
        self.bottom2Leading.constant = 34;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnClick) image:[UIImage imageNamed:@"Group 2 Copy 33"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.tableView.separatorColor = RGBColor(226, 226, 226);
    
}

- (IBAction)addClick:(id)sender {
    XDAddPayViewController* vc = [[XDAddPayViewController alloc]initWithNibName:@"XDAddPayViewController" bundle:nil];
    vc.billFather = billFather;
    [self presentViewController:vc animated:YES completion:nil];
  
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    XDAddBillViewController* addVc = [[XDAddBillViewController alloc]initWithNibName:@"XDAddBillViewController" bundle:nil];
    addVc.delegate = self;
    addVc.billFather = billFather;
    [self presentViewController:addVc animated:YES completion:nil];
}


#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataMuArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    XDBillItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDBillItemTableViewCell" owner:self options:nil]lastObject];
    }
    
    Transaction* tran = _dataMuArr[indexPath.row];
    cell.transaction = tran;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Transaction *trans = _dataMuArr[indexPath.row];
    AppDelegate_iPhone *appDelegate_iPhoen = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    trans.dateTime_sync = [NSDate date];
    trans.state = @"0";
    if (![appDelegate_iPhoen.managedObjectContext save:&error]) {
    }
    //    if (appDelegate_iPhoen.dropbox.drop_account.linked) {
    //        [appDelegate_iPhoen.dropbox updateEveryTransactionDataFromLocal:trans];
    //        [appDelegate_iPhoen.managedObjectContext deleteObject:trans];
    //    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:trans];
        [appDelegate_iPhoen.managedObjectContext deleteObject:trans];
    }
    
    [_dataMuArr removeObject:trans];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self getDataSource];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XDAddPayViewController* vc = [[XDAddPayViewController alloc]initWithNibName:@"XDAddPayViewController" bundle:nil];
    vc.transaction = _dataMuArr[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    view.backgroundColor = RGBColor(246, 246, 246);
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 36)];
    label.textColor = RGBColor(200, 200, 200);
    label.text = @"Payment History";
    label.font = [UIFont fontWithName:FontSFUITextRegular size:12];
    [view addSubview:label];
    return view;
}



#pragma mark - XDAddBillViewDelegate
-(void)returnBillCompletion{
    
}




@end

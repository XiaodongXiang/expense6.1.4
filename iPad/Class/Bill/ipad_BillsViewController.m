//
//  ipad_BillsViewController.m
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_BillsViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "KalTileView.h" 
#import "EventKitDataSource.h"

#import "ipad_BillsCell.h" 
#import "AppDelegate_iPad.h"
#import "BudgetTransfer.h"
//#import "ipad_DateSelBillsViewController.h"
#import "EP_BillRule.h"
#import "EP_BillItem.h"
#import "BillFather.h"
#import "ipad_BillEditViewController.h"
#import "ipad_PaymentViewController.h"
#import "HMJButton.h"
#import "ipad_BillEditViewController.h"

#import "ipad_DateSelBillsViewController.h"
#import "CustomDateRangeViewController.h"

#import "ParseDBManager.h"
#import <Parse/Parse.h>
#import "Custom_iPad_BillsCell.h"


@interface ipad_BillsViewController ()<ADEngineControllerBannerDelegate>

@property (weak, nonatomic) IBOutlet UIView *adBannerView;
@property(nonatomic, strong)ADEngineController* adBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContainViewBottomConstant;

@end

@implementation BillCusBtn
@synthesize sectionindex,rowindex;

@end

@implementation ipad_BillsViewController
@synthesize calendarContainView,kalViewController,dataSource,myTableview,outputFormatter,outputFormatterCell,bvc_MonthStartDate,bvc_MonthEndDate,noRemnderView;
@synthesize  totalPastAmount,totalSevenDayAmount,totalThirthDayAmount;
@synthesize selectedMonthBill1Array,selectedMonthbill2Array,selectedMonthBillAllArray,selectedMonthunpaidArray,selectedMonthpaidArray,bill1Array,bill2Array,totalBillsArray,pastMutableArray,sevenMutableArray,thiredMutableArray;
@synthesize thirtyDaysLater,yestary,sevendaysLater;
@synthesize swipIndex;
@synthesize totalExpenseAmount,totalExpensePaidAmount;
@synthesize iBillEditVoewController;
@synthesize addBtn;
@synthesize iPaymentViewController;
@synthesize upcomingLabelText,noRecordLabelText;
@synthesize needShowSelectedDateBillViewController;

#pragma mark View Life Style
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.isPurchased) {
        if(!_adBanner) {
            
            _adBanner = [[ADEngineController alloc] initLoadADWithAdPint:@"PE2106 - iPad - Banner - Bills" delegate:self];
            [self.adBanner showBannerAdWithTarget:self.adBannerView rootViewcontroller:self];
        }
    }else{
        self.adBannerView.hidden = YES;
        self.calendarContainViewBottomConstant.constant = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refleshUI];
        });
    }
}

#pragma mark - ADEngineControllerBannerDelegate
- (void)aDEngineControllerBannerDelegateDisplayOrNot:(BOOL)result ad:(ADEngineController *)ad {
    if (result) {
        self.adBannerView.hidden = NO;
        self.calendarContainViewBottomConstant.constant = 50;

    }else{
        self.adBannerView.hidden = YES;
        self.calendarContainViewBottomConstant.constant = 0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refleshUI];
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPoint];
    [self initKalView];
    
    //这一步可以省略
//    [self reFlashBillModuleViewData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.iBillEditVoewController = nil;
    [self reFlashBillModuleViewData];

}


#pragma mark View Didload Method
-(void)initPoint
{
    
    _middleLineW.constant=EXPENSE_SCALE;
    needShowSelectedDateBillViewController = NO;
    upcomingLabelText.text = NSLocalizedString(@"VC_Upcoming", nil);
    noRecordLabelText.text = NSLocalizedString(@"VC_NoBills", nil);
    _rightDateLabel.text=NSLocalizedString(@"VC_Date", nil);
    _rightPayeeLaebl.text=NSLocalizedString(@"VC_Payee", nil);
    _rightAMountLabel.text=NSLocalizedString(@"VC_Amount", nil);
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate*)[[UIApplication sharedApplication]delegate];
    self.bvc_MonthStartDate = [appDelegate.epnc getStartDateWithDateType:2 fromDate:[NSDate  date]];
    self.bvc_MonthEndDate = [appDelegate.epnc getEndDateDateType:2 withStartDate:self.bvc_MonthStartDate];
    
    selectedMonthBill1Array = [[NSMutableArray alloc]init];
    selectedMonthbill2Array = [[NSMutableArray alloc]init];
    selectedMonthBillAllArray = [[NSMutableArray alloc]init];
    selectedMonthpaidArray = [[NSMutableArray alloc]init];
    selectedMonthunpaidArray = [[NSMutableArray alloc]init];
    
    bill1Array = [[NSMutableArray alloc]init];
    bill2Array = [[NSMutableArray alloc]init];
    totalBillsArray = [[NSMutableArray alloc]init];
    pastMutableArray = [[NSMutableArray alloc]init];
    sevenMutableArray = [[NSMutableArray alloc]init];
    thiredMutableArray = [[NSMutableArray alloc]init];
    
    //获取日历
    NSCalendar *cal = [NSCalendar currentCalendar];
    //当天
    NSDate *tempToday = [NSDate date];
    //日历组成单元标识
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //日历组成单元
    NSDateComponents *components = [cal components:flags fromDate:tempToday];
    //设置组成单元
    [components setMonth:components.month];
    [components setDay:components.day + 30];
    self.thirtyDaysLater =[[NSCalendar  currentCalendar]dateFromComponents:components];
    
    NSDateComponents*  parts1 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [parts1 setHour:0];
    [parts1 setMinute:0];
    [parts1 setSecond:0];
    self.yestary= [[NSCalendar currentCalendar] dateFromComponents:parts1];
    
    NSDateComponents *parts2 = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [parts2 setHour:0];
    [parts2 setMinute:0];
    [parts2 setSecond:0];
    [parts2 setDay:parts2.day+7];
    self.sevendaysLater= [[NSCalendar currentCalendar] dateFromComponents:parts2];
    
    outputFormatterCell = [[NSDateFormatter alloc] init];
	outputFormatterCell.dateStyle = NSDateFormatterMediumStyle;
    outputFormatterCell.timeStyle = NSDateFormatterNoStyle;
    [outputFormatterCell setLocale:[NSLocale currentLocale]];
    
    swipIndex = nil;

    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initKalView
{
	kalViewController=[[KalViewController alloc]init];
    dataSource = [[EventKitDataSource alloc] init];
    kalViewController.dataSource=dataSource;
    kalViewController.delegate=dataSource;
    [kalViewController.dataSource getCalendarView:dataSource];
    [kalViewController.dataSource getTableView:kalViewController.kalView.tableView];
    kalViewController.view.tag =2;
    [calendarContainView addSubview:kalViewController.view];
}

-(void)refleshUI
{
    if (self.iBillEditVoewController != nil)
    {
        [self.iBillEditVoewController refleshUI];
    }
    else if (self.iPaymentViewController != nil)
    {
        [self.iPaymentViewController refleshUI];
    }
    else
    {
        [self reFlashBillModuleViewData];
    }
}
-(void)reFlashBillModuleViewData
{
    [self getBillListArray];
    [self getSelectedMonthData];
    [kalViewController showSelectedMonth];
    
    [kalViewController reloadData];
}

#pragma mark Btn Action
-(void)addBtnPressed:(UIButton *)sender
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    ipad_BillEditViewController *billEditViewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    billEditViewController.typeOftodo = @"IPAD_ADD";
    billEditViewController.iBillsViewController = appDelegate_iPad.mainViewController.iBillsViewController;
    billEditViewController.starttime = self.kalViewController.selectedDate ;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:billEditViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    
//    [appDelegate_iPad.mainViewController.iBillsViewController presentViewController:navigationController animated:YES completion:nil];
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
    
    
	navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;


}


-(void)celleditBtnPressed:(NSIndexPath *)indexPath{
    self.swipIndex = nil;
    
    iBillEditVoewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    
    BillFather *oneBillFather;
    if (indexPath.section==0) {
        oneBillFather = [pastMutableArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==1)
        oneBillFather = [sevenMutableArray objectAtIndex:indexPath.row];
    else{
        oneBillFather = [thiredMutableArray objectAtIndex:indexPath.row];
    }
    self.iBillEditVoewController .typeOftodo = @"IPAD_EDIT";
    self.iBillEditVoewController .billFather = oneBillFather;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:iBillEditVoewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
    
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
}
-(void)celldeleteBtnPressed:(NSIndexPath *)indexPath isCalenderTableViewBill:(BillFather *)calendarBillFather{
    BillFather *billFather;
//    self.swipIndex = nil;
    
    //其实是可以不用自定义的btn的
    if (indexPath.section==0) {
        billFather = [pastMutableArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section==1)
        billFather = [sevenMutableArray objectAtIndex:indexPath.row];
    else
        billFather = [thiredMutableArray objectAtIndex:indexPath.row];
    
    if (![billFather.bf_billRecurringType isEqualToString:@"Never"])
    {
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to delete this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:billFather.bf_billName];
        NSString *meg = string1;
        
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        actionsheet.tag = 201;
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        UITableViewCell *selectedCell = [myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        CGPoint point1 = [myTableview convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
        [actionsheet showFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
        
        appDelegate.appActionSheet = actionsheet;
        
        return;
    }
    //非循环 删除BK_Bill BK_Payment
    else{
        if (billFather.bf_billRule != nil)
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            NSError *error = nil;
            
            billFather.bf_billRule.state = @"0";
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        
        self.swipIndex = nil;
        [self reFlashBillModuleViewData];
    }
  
  
}

//日历页面点击日期出现list,点击出现payment页面
- (void)payBillWithBills:(BillFather *)tmpBills
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.pvt = nonePopup;
    
 	UINavigationController *navigationController;
    
	ipad_PaymentViewController *billsPaymentController = [[ipad_PaymentViewController alloc] initWithNibName:@"ipad_PaymentViewController" bundle:nil];
    billsPaymentController.billFather = tmpBills;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:billsPaymentController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate1.mainViewController.popViewController = navigationController;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
    
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
    
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           100,
//                                                           480,
//                                                           490
//                                                           );

}

-(void)resetCalendarStyle
{
    NSDate *tmpSelectedDate = kalViewController.selectedDate;
    id tmp = [kalViewController.logic  initForDate:tmpSelectedDate];
    [kalViewController.kalView resetWeekStyle:kalViewController.kalView.kalheaderView];
    [kalViewController.kalView jumpToSelectedMonth];
    NSLog(@"%@",tmp);
}

#pragma mark DataSource
#pragma mark /////Get BillListArray
-(void)getBillListArray
{
    [bill1Array removeAllObjects];
    [bill2Array removeAllObjects];
    [totalBillsArray removeAllObjects];
    [pastMutableArray removeAllObjects];
    [sevenMutableArray removeAllObjects];
    [thiredMutableArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    //1.查询bill1中所有的bill
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EP_BillRule" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch setPredicate:predicate];
    NSArray *bill1tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    [bill1Array setArray:bill1tempArray];

    
    //2.查询bill2中所有数据
    NSFetchRequest *fetch2 = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch2 setEntity:entity2];
    NSPredicate * predicate2 =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetch2 setPredicate:predicate2];
    NSArray *bill2tempArray = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch2 error:&error]];
    [bill2Array setArray:bill2tempArray];

    
    //3.分析，产生新的数据
    [self useTemlateCreateBill];
    [self useBill2createRealAllArray];
    
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [totalBillsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [totalBillsArray setArray:ar];

    
    [self setArraybyPast_7day_30daysType];
    
    [myTableview reloadData];
}

-(void)useTemlateCreateBill{
    for (int i=0; i<[bill1Array count]; i++) {
        EP_BillRule *oneBill = [bill1Array objectAtIndex:i];
        [self setBillFathferbyBill:oneBill];
    }
}

-(void)setBillFathferbyBill:(EP_BillRule *)bill{
    
    PokcetExpenseAppDelegate *appDelegate_iphone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"] ){
        double paymentAmount = 0.00;
        
        
        if ([appDelegate_iphone.epnc dateCompare:bill.ep_billDueDate withDate:thirtyDaysLater]<=0) {
            NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[bill.billRuleHasTransaction allObjects]];
            for (int n=0; n<[paymentarray count]; n++) {
                Transaction *onepayment = [paymentarray objectAtIndex:n];
                if ([onepayment.state isEqualToString:@"1"]) {
                    paymentAmount = paymentAmount +[onepayment.amount doubleValue];
                    
                }
            }
            if (paymentAmount<[bill.ep_billAmount doubleValue]) {
                BillFather *billFateher = [[BillFather alloc]init];
                [appDelegate_iphone.epdc editBillFather:billFateher withBillRule:bill withDate:nil];
                [totalBillsArray addObject:billFateher];
            }
        }
        
        return;
    }
    //如果是循环账单
    else{
        //如果账单开始的时间在30天之后，过掉
        if ([appDelegate_iphone.epnc  dateCompare:bill.ep_billDueDate withDate:thirtyDaysLater] == 1) {
            return;
        }
        
        NSDate *lastDate = bill.ep_billDueDate;
        
        NSDate *endDateorBillEndDate = [appDelegate_iphone.epnc dateCompare:thirtyDaysLater withDate:bill.ep_billEndDate]<0?thirtyDaysLater : bill.ep_billEndDate;
        if ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]>0) {
            return;
        }
        else{
            //循环创建账单
            while ([appDelegate_iphone.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                BillFather *oneBillfather = [[BillFather alloc]init];
                
                [appDelegate_iphone.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                
                [totalBillsArray  addObject:oneBillfather];
                //获取下一次循环的时间
                lastDate= [appDelegate_iphone.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}
-(void)useBill2createRealAllArray{
    
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    for (int i=0; i<[bill2Array count]; i++) {
        EP_BillItem *billObject = [bill2Array objectAtIndex:i];
        
        //在30天之后的去掉
        if ([appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDateNew withDate:thirtyDaysLater]==1)
            continue;
        else{
            
            //如果被删除了，就从all中删除这个数据
            if ([billObject.ep_billisDelete boolValue])
            {
                for (int j=0; j<[totalBillsArray count]; j++) {
                    BillFather   *checkedBill = [totalBillsArray objectAtIndex:j];
                    if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                        [totalBillsArray removeObject:checkedBill];
                    }
                }
            }
            else
            {
                double paymentAmount = 0.00;
                NSArray *paymentarray = [[NSMutableArray alloc]initWithArray:[billObject.billItemHasTransaction allObjects]];
                for (int n=0; n<[paymentarray count]; n++) {
                    Transaction *onepayment = [paymentarray objectAtIndex:n];
                    if ([onepayment.state isEqualToString:@"1"]) {
                        paymentAmount = paymentAmount +[onepayment.amount doubleValue];
                        
                    }
                }
                if (paymentAmount < [billObject.ep_billItemAmount doubleValue])
                {
                    for (int j=0; j<[totalBillsArray count]; j++) {
                        BillFather *oneBillfather = [totalBillsArray objectAtIndex:j];
                        //相等的话说明是同一件事情，此时需要修改
                        if (oneBillfather.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:oneBillfather.bf_billDueDate withDate:billObject.ep_billItemDueDate]==0)
                        {
                            [appDelegate_iPhone.epdc editBillFather:oneBillfather withBillItem:billObject];
                        }
                    }
                }
                else
                {
                    for (int j=0; j<[totalBillsArray count]; j++) {
                        BillFather   *checkedBill = [totalBillsArray objectAtIndex:j];
                        if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate_iPhone.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                            [totalBillsArray removeObject:checkedBill];
                        }
                    }
                }
            }
            
        }
        
    }
    
}

-(void)setArraybyPast_7day_30daysType{
    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    totalPastAmount = 0;
    totalSevenDayAmount = 0;
    totalThirthDayAmount = 0;
    
    for (int i=0; i<[totalBillsArray count]; i++) {
        BillFather *selecBillFather = [totalBillsArray objectAtIndex:i];
        if ([appDelegate_iPhone.epnc dateCompare:selecBillFather.bf_billDueDate withDate:self.yestary]==-1) {
            [pastMutableArray addObject:selecBillFather];
            
            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else{
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"]) {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalPastAmount += selecBillFather.bf_billAmount-paidAmount;

            
        }
        else if([appDelegate_iPhone.epnc dateCompare:selecBillFather.bf_billDueDate withDate:self.sevendaysLater]==-1)
        {
            [sevenMutableArray addObject:selecBillFather];
            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else{
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"]) {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalSevenDayAmount += selecBillFather.bf_billAmount-paidAmount;
        }
        else
        {
            [thiredMutableArray addObject:selecBillFather];
            //计算lest amount
            double paidAmount = 0.00;
            NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
            if ([selecBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
                [paymentArray setArray:[selecBillFather.bf_billRule.billRuleHasTransaction allObjects]];
            }
            else{
                [paymentArray setArray:[selecBillFather.bf_billItem.billItemHasTransaction allObjects]];
            }
            for (int i=0; i<[paymentArray count]; i++) {
                Transaction *onePayment = [paymentArray objectAtIndex:i];
                if ([onePayment.state isEqualToString:@"1"]) {
                    paidAmount += [onePayment.amount doubleValue];
                }
            }
            totalThirthDayAmount += selecBillFather.bf_billAmount-paidAmount;

        }
    }
}

#pragma mark get selected month data
-(void)getSelectedMonthData
{
    [selectedMonthBill1Array removeAllObjects];
    [selectedMonthbill2Array removeAllObjects];
    [selectedMonthBillAllArray removeAllObjects];
    [selectedMonthpaidArray removeAllObjects];
    [selectedMonthunpaidArray removeAllObjects];
    
    
    totalExpenseAmount = 0;
    totalExpensePaidAmount = 0;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //获取bill1中的数据
    [self getBillRuleArray:bvc_MonthStartDate endDate:bvc_MonthEndDate array:selectedMonthBill1Array];
    [self useBill1CreateAllBill:selectedMonthBill1Array totalArray:selectedMonthBillAllArray startDate:self.bvc_MonthStartDate endDate:self.bvc_MonthEndDate];
    //获取bill2中的数据
    [self getBillItemArray:self.bvc_MonthStartDate endDate:self.bvc_MonthEndDate array:selectedMonthbill2Array];
    [self useBill2CreateAllBill:selectedMonthbill2Array allArray:selectedMonthBillAllArray];
    
//    BOOL  hasExpiredBill = NO;
    int num = 0;
    //把数组按照时间排一下
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"bf_billDueDate" ascending:YES];
    NSArray *ar = [selectedMonthBillAllArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByDate, nil]];
    [selectedMonthBillAllArray setArray:ar];
    
    for (int i=0; i<[selectedMonthBillAllArray count]; i++) {
        BillFather *oneBillFather = [selectedMonthBillAllArray objectAtIndex:i];
        
        NSMutableArray *paymentarray = [[NSMutableArray alloc]init];
        
        if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"]) {
            [paymentarray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
        }
        else
            [paymentarray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
        
        double paymentAmount = 0;
        totalExpenseAmount += oneBillFather.bf_billAmount;//totalExpenseAmount
        for (int k=0; k<[paymentarray count]; k++) {
            Transaction *oneTransaction = [paymentarray objectAtIndex:k];
            if ([oneTransaction.state isEqualToString:@"1"]) {
                paymentAmount += [oneTransaction.amount doubleValue];
                totalExpensePaidAmount += [oneTransaction.amount doubleValue];//totalExpensePaidAmount
                
            }
            
        }
        
        
        if (paymentAmount < oneBillFather.bf_billAmount)
        {
            if ([appDelegate.epnc dateCompare:[NSDate date] withDate:oneBillFather.bf_billDueDate]>0) {
//                hasExpiredBill = YES;
                num ++ ;
            }
            [selectedMonthunpaidArray addObject:oneBillFather];
        }
        else
            [selectedMonthpaidArray addObject:oneBillFather];
    }
    
    kalViewController.kalView.totalAmountLabel.text = [appDelegate.epnc formatterString:totalExpenseAmount];
    kalViewController.kalView.paidAmountLabel.text = [appDelegate.epnc formatterString:totalExpensePaidAmount];
    double dueAmount = 0;
    if (totalExpensePaidAmount<totalExpenseAmount) {
        dueAmount = totalExpenseAmount-totalExpensePaidAmount;
    }
    kalViewController.kalView.dueAmountLabel.text = [appDelegate.epnc formatterString:dueAmount];
    
}

//获取bill1中的数据
-(void)getBillRuleArray:(NSDate *)startDate endDate:(NSDate *)endDate array:(NSMutableArray *)array{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:endDate,@"startDate",nil];
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBillRulebyDate" substitutionVariables:sub];
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    [array setArray:objects];
 
    
    for (int i=0; i<[selectedMonthBill1Array count]; i++) {
        EP_BillRule *oneBill = [selectedMonthBill1Array objectAtIndex:i];
        if ([appDelegate.epnc dateCompare:oneBill.ep_billEndDate withDate:startDate]<0) {
            [selectedMonthBill1Array removeObjectAtIndex:i];
        }
    }
}

-(void)getBillItemArray:(NSDate *)startDate endDate:(NSDate *)endDate array:(NSMutableArray *)array{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBill2byDate" substitutionVariables:sub];
    
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    [array setArray:objects];
 
}

//通过bill1创建billfather
-(void)useBill1CreateAllBill:(NSMutableArray *)tmpbill1Array totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    for (int i=0; i<[tmpbill1Array count]; i++) {
        EP_BillRule *oneBill = [tmpbill1Array objectAtIndex:i];
        [self setBillFathferbyBillRule:oneBill totalArray:totalArray  startDate:startDate endDate:endDate];
    }
}

-(void)setBillFathferbyBillRule:(EP_BillRule *)bill totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //如果是不循环的，就直接赋值然后返回，因为不循环的bill只会存在与bill1表中
    if([bill.ep_recurringType isEqualToString:@"Never"]){
        
        if (([appDelegate.epnc  dateCompare:bill.ep_billDueDate withDate:startDate]>=0 && [appDelegate.epnc dateCompare:bill.ep_billDueDate withDate:endDate]<=0)) {
            BillFather *billFateher = [[BillFather alloc]init];
            
            [appDelegate.epdc editBillFather:billFateher withBillRule:bill withDate:nil];
            
            [totalArray addObject:billFateher];
            return;
        }
        
    }
    //如果是循环账单
    else{
        NSDate *lastDate = [appDelegate.epnc getCycleStartDateByMinDate:startDate withCycleStartDate:bill.ep_billDueDate withCycleType:bill.ep_recurringType isRule:YES] ;
        
        NSDate *endDateorBillEndDate = [appDelegate.epnc dateCompare:endDate withDate:bill.ep_billEndDate]<0?endDate : bill.ep_billEndDate;
        if ([appDelegate.epnc dateCompare:lastDate withDate:endDateorBillEndDate]>0) {
            return;
        }
        else{
            //循环创建账单
            while ([appDelegate.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                BillFather *oneBillfather = [[BillFather alloc]init];
                
                [appDelegate.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                if([appDelegate.epnc dateCompare:lastDate withDate:bvc_MonthStartDate]>=0)
                    [totalArray  addObject:oneBillfather];
                //获取下一次循环的时间
                lastDate= [appDelegate.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}

-(void)useBill2CreateAllBill:(NSMutableArray *)tmpBill2Array allArray:(NSMutableArray *)tmpAllArray{
    for (int i=0; i<[tmpBill2Array count]; i++) {
        EP_BillItem *billObject = [tmpBill2Array objectAtIndex:i];
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //如果被删除了，就从all中删除这个数据
        if ([billObject.ep_billisDelete boolValue]){
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather   *checkedBill = [tmpAllArray objectAtIndex:j];
                if (checkedBill.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:billObject.ep_billItemDueDate withDate:checkedBill.bf_billDueDate]==0) {
                    [tmpAllArray removeObject:checkedBill];
                }
            }
        }
        else{
            for (int j=0; j<[tmpAllArray count]; j++) {
                BillFather *oneBillfather = [tmpAllArray objectAtIndex:j];
                //相等的话说明是同一件事情，此时需要修改
                if (oneBillfather.bf_billRule == billObject.billItemHasBillRule && [appDelegate.epnc dateCompare:oneBillfather.bf_billDueDate withDate:billObject.ep_billItemDueDate]==0)
                {
                    [appDelegate.epdc editBillFather:oneBillfather withBillItem:billObject];
                }
            }
        }
        
    }
}

#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
	if (section==0 && [pastMutableArray count]>0) {
        return 30;
    }
    else if (section==1 && [sevenMutableArray count]>0)
        return 30;
    else if(section==2 && [thiredMutableArray count]>0)
        return 30;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
  	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([pastMutableArray count]==0 && [sevenMutableArray count]==0 && [thiredMutableArray count]==0)
    {
        myTableview.hidden = YES;
        noRemnderView.hidden = NO;
    }
    else
    {
        noRemnderView.hidden = YES;
        myTableview.hidden = NO;
    }
    
    if (section==0)
        return [pastMutableArray count];
    else if (section==1)
        return [sevenMutableArray count];
    return [thiredMutableArray count];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
	PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 22)];
    headerView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 140, 30)];
    if (section==0) {
        typeLabel.text = NSLocalizedString(@"VC_Overdue", nil);
    }
    else if (section==1)
        typeLabel.text = NSLocalizedString(@"VC_DueWithin7Days", nil);
    else
        typeLabel.text = NSLocalizedString(@"VC_DueWithin30Days", nil);
    
    typeLabel.textColor = [appDelegate_iPhone.epnc getAmountGrayColor];
    [typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    typeLabel.adjustsFontSizeToFitWidth = YES;
    [typeLabel setMinimumScaleFactor:0];
    typeLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:typeLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(566-15-155, 0, 155, 30)];
    if (section==0) {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalPastAmount];
        
    }
    else if (section==1)
    {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalSevenDayAmount];
    }
    else
    {
        numLabel.text = [appDelegate_iPhone.epnc formatterString:totalThirthDayAmount];
    }
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    numLabel.textColor = [appDelegate_iPhone.epnc getAmountGrayColor];;
    [numLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    numLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:numLabel];
    
    return headerView;

}
- (void)configureBillCell:(Custom_iPad_BillsCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    BillFather *billFather;
    if(indexPath.section == 0)
    {
        billFather= [pastMutableArray objectAtIndex:indexPath.row];
        cell.amountLabel.textColor = [appDelegate.epnc getAmountRedColor];
    }
    else if(indexPath.section==1)
    {
        billFather= [sevenMutableArray objectAtIndex:indexPath.row];
        cell.amountLabel.textColor = [appDelegate.epnc getAmountBlackColor];
    }
    else
    {
        billFather = [thiredMutableArray objectAtIndex:indexPath.row];
        cell.amountLabel.textColor = [appDelegate.epnc getAmountBlackColor];

    }
    
    //category
    if (billFather.bf_category != nil)
	{
 		cell.categoryIconImage.image = [UIImage imageNamed:billFather.bf_category.iconName];
	}
    
	//name
	cell.nameLabel.text = billFather.bf_billName;
    
    //date
    NSString* time = [outputFormatterCell stringFromDate:billFather.bf_billDueDate];
	cell.dateLabel.text = time;
    
    //amount
    double lestAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[billFather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else{
        [paymentArray setArray:[billFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    for (int i=0; i<[paymentArray count]; i++) {
        Transaction *onePayment = [paymentArray objectAtIndex:i];
        if ([onePayment.state isEqualToString:@"1"]) {
            lestAmount += [onePayment.amount doubleValue];
        }
    }
	cell.amountLabel.text = [appDelegate.epnc formatterString:(billFather.bf_billAmount-lestAmount)];

    
    //cycle
    if ([billFather.bf_billNote length]>0) cell.memoImage.hidden = NO;
    else
        cell.memoImage.hidden = YES;
    
    //stateImage
    NSInteger dataCount=0;
    if (indexPath.section==0)
    {
        dataCount=pastMutableArray.count;
    }
    else if(indexPath.section==1)
    {
        dataCount=sevenMutableArray.count;
    }
    else
    {
        dataCount=thiredMutableArray.count;
    }

    if (indexPath.row%2)
    {
        if (indexPath.row==dataCount-1)
        {
            cell.bgImageView.image=[UIImage imageNamed:@"bill_form_bottom_gray"];
        }
        else
        {
            cell.bgImageView.image=[UIImage imageNamed:@"bill_form_gray"];
        }
    }
    else
    {
        if (indexPath.row==dataCount-1)
        {
            cell.bgImageView.image=[UIImage imageNamed:@"bill_form_bottom_white"];
        }
        else
        {
            cell.bgImageView.image=[UIImage imageNamed:@"bill_form_white"];
        }
    }
    
    
    
}




 




 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"Cell";
     Custom_iPad_BillsCell *cell = (Custom_iPad_BillsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[Custom_iPad_BillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.delegate=self;
    }
    [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:53];
    [self configureBillCell:cell atIndexPath:indexPath];
    return cell;
	
}	
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_revise_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (self.swipIndex != nil) {
        self.swipIndex = nil;
        [myTableview reloadData];
        return;
    }
    BillFather *oneBillFather;
    if (indexPath.section==0) {
        oneBillFather = [pastMutableArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section==1)
        oneBillFather = [sevenMutableArray objectAtIndex:indexPath.row];
    else
        oneBillFather = [thiredMutableArray objectAtIndex:indexPath.row];
    
    iPaymentViewController = [[ipad_PaymentViewController alloc]initWithNibName:@"ipad_PaymentViewController" bundle:nil];
    self.iPaymentViewController.billFather = oneBillFather;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iPaymentViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
    
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
    
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           100,
//                                                           480,
//                                                           490
//                                                           );
    
    
    
    
    
    
    
    
    
    
    
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.pvt = dateRangePopup;
//    CustomDateRangeViewController *customDateRangeViewController =[[CustomDateRangeViewController alloc] initWithNibName:@"CustomDateRangeViewController" bundle:nil];
//    customDateRangeViewController.moduleString = @"ACCOUNT";
////    customDateRangeViewController.iAccountViewController = self;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customDateRangeViewController];
//    appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
//    appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,360.0);
//    appDelegate.AddPopoverController.delegate = self;
//[appDelegate.AddPopoverController presentPopoverFromRect:CGRectMake(20 ,  80, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	if(tableView.editing == FALSE)
	{
		style = UITableViewCellEditingStyleDelete;
	}
	return style;
}

#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
        return;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    BillFather *billFather;
    if (swipIndex.section==0) {
        billFather = [pastMutableArray objectAtIndex:swipIndex.row];
    }
    else if (swipIndex.section==1)
        billFather = [sevenMutableArray objectAtIndex:swipIndex.row];
    else
        billFather = [thiredMutableArray objectAtIndex:swipIndex.row];
    
    if (buttonIndex==2) {
        self.swipIndex = nil;
        [self reFlashBillModuleViewData];
        return;
    }
    //删除后面所有的bill,billItem，修改transaction
    else if (buttonIndex==1)
    {
        //如果是循环的第一条bill，需要删除这个循环,bill2中相关连的数据
        if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
        {
            
            //删除bill2数组
            NSMutableArray *tmpbill2Array =[[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
            for (int i=0; i<[tmpbill2Array count]; i++) {
                EP_BillItem *billo = [tmpbill2Array objectAtIndex:i];
                
                billo.dateTime = [NSDate date];
                billo.state = @"0";
                if (![appDelegate.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                    
                }
//                if (appDelegate.dropbox.drop_account.linked) {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
//                    //                    [appDelegate.managedObjectContext deleteObject:billo];
//                    
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                }
            }
            
            //删除bill
            billFather.bf_billRule.dateTime = [NSDate date];
            billFather.bf_billRule.state = @"0";
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        else
        {
            //---给老bill设置截止日期,删除这日期以后的bill2
            NSMutableArray *bill2array = [[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
            NSMutableArray *deleteBill2array = [[NSMutableArray alloc]init];
            //获取要删除的bill2
            for (int i=0; i<[bill2array count]; i++)
            {
                EP_BillItem *billo = [bill2array objectAtIndex:i];
                if ([appDelegate.epnc dateCompare:billo.ep_billItemDueDateNew withDate:billFather.bf_billDueDate]>=0) {
                    [deleteBill2array addObject:billo];
                }
            }
            //删除bill2
            for (int i=0; i<[deleteBill2array count]; i++)
            {
                EP_BillItem *billo = [deleteBill2array objectAtIndex:i];
                billo.state = @"0";
                billo.dateTime = [NSDate date];
                [appDelegate.managedObjectContext save:&error];
//                if (appDelegate.dropbox.drop_account.linked) {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billo];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                }
            }
            //修改由 billBrose中的billfather
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *components = [cal components:flags fromDate:billFather.bf_billDueDate];
            [components setMonth:components.month];
            [components setDay:components.day -1 ];
            NSDate *billFatherendDate =[[NSCalendar  currentCalendar]dateFromComponents:components];
            //-----当删除后面所有的账单的时候，要把永久循环设置为NO
            billFather.bf_billRule.ep_billEndDate = billFatherendDate;
            billFather.bf_billRule.dateTime = [NSDate date];
            
            if (![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
            
        }
        
        
    }
    //只是本次的bill
    else
    {
        //循环BK_Bill的第一个BK_BillObject,修改BK_Bill duedate
        if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
        {
            if (billFather.bf_billItem!=nil)
            {
                billFather.bf_billItem.state = @"0";
                billFather.bf_billItem.dateTime = [NSDate date];
                if (![appDelegate.managedObjectContext save:&error])
                {
                    NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                }
//                if (appDelegate.dropbox.drop_account.linked)
//                {
//                    [appDelegate.dropbox updateEveryBillItemDataFromLocal:billFather.bf_billItem];
//                    //                    [appDelegate.managedObjectContext deleteObject:billFather.bf_billItem];
//                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billFather.bf_billItem];
                }
            }
            
            billFather.bf_billRule.ep_billDueDate = [appDelegate.epnc getDate:billFather.bf_billDueDate byCycleType:billFather.bf_billRecurringType];
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate.dropbox.drop_account.linked)
//            {
//                [appDelegate.dropbox updateEveryBillRuleDataFromLocal:billFather.bf_billRule];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
        }
        else
        {
            //----------在bill2中记下一条记录，并且删除这个bill2对应的payment
            EP_BillItem *deleteBillobject;
            if (billFather.bf_billItem == nil)
            {
                
                deleteBillobject = [NSEntityDescription insertNewObjectForEntityForName:@"EP_BillItem" inManagedObjectContext:appDelegate.managedObjectContext];
                deleteBillobject.uuid = [EPNormalClass GetUUID];
            }
            else{
                deleteBillobject =billFather.bf_billItem;
            }
            //配置被删除的bill2对象
            deleteBillobject.ep_billisDelete = [NSNumber numberWithBool:YES];
            deleteBillobject.ep_billItemName = billFather.bf_billName;
            deleteBillobject.ep_billItemAmount = [NSNumber numberWithDouble:billFather.bf_billAmount];
            deleteBillobject.ep_billItemDueDate = billFather.bf_billDueDate;
            if (deleteBillobject.ep_billItemDueDateNew == nil) {
                deleteBillobject.ep_billItemDueDateNew = billFather.bf_billDueDate;
            }
            deleteBillobject.ep_billItemRecurringType = billFather.bf_billRecurringType;
            deleteBillobject.ep_billItemEndDate = billFather.bf_billEndDate;
            deleteBillobject.ep_billItemNote = billFather.bf_billNote;
            deleteBillobject.ep_billItemReminderDate = billFather.bf_billReminderDate;
            deleteBillobject.ep_billItemReminderTime = billFather.bf_billReminderTime;
            
            deleteBillobject.billItemHasBillRule = billFather.bf_billRule;
            deleteBillobject.billItemHasCategory = billFather.bf_category;
            deleteBillobject.billItemHasPayee = billFather.bf_payee;
            deleteBillobject.billItemHasTransaction = nil;
            
            deleteBillobject.dateTime = [NSDate date];
            deleteBillobject.state = @"1";
            if (![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
                
            }
//            if (appDelegate.dropbox.drop_account.linked) {
//                [appDelegate.dropbox updateEveryBillItemDataFromLocal:deleteBillobject];
//            }
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteBillobject];
            }
            
        }
    }
    self.swipIndex = nil;
    [self reFlashBillModuleViewData];
    return;
}
#pragma mark - SWTableView Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[myTableview indexPathForCell:cell];
    switch (index) {
        case 0:
            [self celleditBtnPressed:indexPath];
            break;
        default:
            self.swipIndex = indexPath;
            [self celldeleteBtnPressed:indexPath isCalenderTableViewBill:nil];
            break;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end


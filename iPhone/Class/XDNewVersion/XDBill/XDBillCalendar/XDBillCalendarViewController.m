//
//  XDBillCalendarViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/3/30.
//

#import "XDBillCalendarViewController.h"
#import "XDBillCalView.h"
#import "AppDelegate_iPhone.h"
#import "EP_BillRule.h"
#import "BillFather.h"
#import "EP_BillItem.h"
#import "CustomBillCell.h"
#import "BillsViewController.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@import Firebase;
@interface XDBillCalendarViewController ()<UITableViewDelegate,UITableViewDataSource,XDBillCalViewDelegate,SWTableViewCellDelegate,UIActionSheetDelegate>
{
    NSMutableArray* _totalMuArray;
    XDBillCalView* _calView;
    NSDate* _selectDate;
    
    BillFather* _deleteBillFather;
    NSIndexPath* _deleteIndexPath;
}
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic, strong)NSMutableArray * dataMuArr;

@end

@implementation XDBillCalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     _calView = [[XDBillCalView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 338)];
    [self.view addSubview:_calView];
    _calView.xxdDelegate = self;
    [self setUpTableView];
    
    [self returnCurrentMonth:[NSDate date]];
    [self returnSelectedDate:[[NSDate date]initDate]];
    _selectDate = [[NSDate date]initDate];
    
    [FIRAnalytics setScreenName:@"bill_calendar_view_iphone" screenClass:@"XDBillCalendarViewController"];

}

-(void)setUpTableView{
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calView.frame), SCREEN_WIDTH, 10)];
    lineView.backgroundColor = RGBColor(246, 246, 246);
    [self.view addSubview:lineView];
    if (IS_IPHONE_X) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 348, SCREEN_WIDTH, SCREEN_HEIGHT - 348 - 49 - 88) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 348, SCREEN_WIDTH, SCREEN_HEIGHT - 348 - 49 - 64) style:UITableViewStylePlain];
    }
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = RGBColor(226, 226, 226);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMuArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"BillsCell";
    CustomBillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[CustomBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.delegate=self;
//        [self configureBillsCell:cell atIndexPath:indexPath];

        float width;
        if (IS_IPHONE_4 || IS_IPHONE_5)
        {
            width=53;
        }
        else
        {
            width=63;
        }
        [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:width];
    }
    
    [self configCell:cell atIndex:indexPath];
    
    return cell;
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:RGBColor(113, 163, 245) normalIcon:[UIImage imageNamed:@"bianji"] selectedIcon:[UIImage imageNamed:@"bianji"]];
    [btns sw_addUtilityButtonWithColor:RGBColor(254, 59, 47) normalIcon:[UIImage imageNamed:@"del"] selectedIcon:[UIImage imageNamed:@"del"]];
    return btns;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BillFather* father = self.dataMuArr[indexPath.row];
    if ([self.xxdDelegate respondsToSelector:@selector(returnSelectBillFather:)]) {
        [self.xxdDelegate returnSelectBillFather:father];
    }
}

#pragma mark - XDBillCalViewDelegate
-(void)returnSelectedDate:(NSDate *)date{
    _selectDate = date;
    [self loadItemsforselectedDay:date];
    [self.tableView reloadData];
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedDate:)]) {
        [self.xxdDelegate returnSelectedDate:_selectDate];
    }
}


-(void)returnCurrentMonth:(NSDate *)date{
    
    
    NSDate* startDate = [self getMonthStartDay:date];
    NSDate* endDate = [self getMonthEndDay:date];
    
    
    NSMutableArray* muArray = [self getBillRuleArray:startDate endDate:endDate];

    _totalMuArray = [NSMutableArray array];
    [self useBill1CreateAllBill:muArray totalArray:_totalMuArray startDate:startDate endDate:endDate];
    
    NSMutableArray* muArray2 = [NSMutableArray arrayWithArray:[self getBillItemArray:startDate endDate:endDate]];
    
    
    [self useBill2CreateAllBill:muArray2 allArray:_totalMuArray];
    
    if ([self.xxdDelegate respondsToSelector:@selector(returnCurrentMonthDate:)]) {
        [self.xxdDelegate returnCurrentMonthDate:date];
    }
    
}

#pragma mark - SWTableView Delegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            if ([self.xxdDelegate respondsToSelector:@selector(returnSelectedBillEdit:)]) {
                [self.xxdDelegate returnSelectedBillEdit:self.dataMuArr[indexPath.row]];
            }
            break;
            
        default:
            [self celldeleteBtnPressed:indexPath isCalenderTableViewBill:self.dataMuArr[indexPath.row]];
            break;
    }
    
}

-(void)celldeleteBtnPressed:(NSIndexPath *)indexPath isCalenderTableViewBill:(BillFather *)calendarBillFather
{
    BillFather * billFather = calendarBillFather;
    
    _deleteBillFather = billFather;
    
    if (![billFather.bf_billRecurringType isEqualToString:@"Never"]) {
        //        NSString *meg = [NSString stringWithFormat:@"This is a repeating bill. Do you want to delete this bill, or all future bills for name'%@'?",billFather.bf_billName];
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to change this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:billFather.bf_billName];
        NSString *meg = string1;
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        _deleteIndexPath = indexPath;
        return;
    }
    //非循环 删除BK_Bill BK_Payment
    else{
        if (billFather.bf_billRule != nil)
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            NSError *error = nil;
            
            billFather.bf_billRule.state = @"0";
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
        
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillRuleFromLocal:billFather.bf_billRule];
            }
            
            [self.dataMuArr removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            [self returnCurrentMonth:_selectDate];
            [self returnSelectedDate:[_selectDate initDate]];

            [_calView refreshUI];
        }
    }
    
    
}

#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==2)
        return;
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    BillFather *  billFather = _deleteBillFather;
 if (buttonIndex==1)
    {
        //如果是循环的第一条bill，需要删除这个循环,bill2中相关连的数据
        if ([appDelegate.epnc dateCompare:billFather.bf_billDueDate withDate:billFather.bf_billRule.ep_billDueDate]==0)
        {
            
            //删除bill2数组
            NSMutableArray *bill2Array =[[NSMutableArray alloc]initWithArray:[billFather.bf_billRule.billRuleHasBillItem allObjects]];
            for (int i=0; i<[bill2Array count]; i++) {
                EP_BillItem *billo = [bill2Array objectAtIndex:i];
                
                billo.dateTime = [NSDate date];
                billo.state = @"0";
                if (![appDelegate.managedObjectContext save:&error]) {
                    
                }
       
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billo];
                }
            }
            
            //删除bill
            billFather.bf_billRule.dateTime = [NSDate date];
            billFather.bf_billRule.state = @"0";
            if (![appDelegate.managedObjectContext save:&error]) {
                
            }
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
                
            }
          
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
                }
                if ([PFUser currentUser])
                {
                    [[ParseDBManager sharedManager]updateBillItemFormLocal:billFather.bf_billItem];
                }
            }
            
            billFather.bf_billRule.ep_billDueDate = [appDelegate.epnc getDate:billFather.bf_billDueDate byCycleType:billFather.bf_billRecurringType];
            billFather.bf_billRule.dateTime = [NSDate date];
            if (![appDelegate.managedObjectContext save:&error])
            {
                
            }
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
                
            }
           
            if ([PFUser currentUser])
            {
                [[ParseDBManager sharedManager]updateBillItemFormLocal:deleteBillobject];
            }
        }
    }
    
    [self.dataMuArr removeObjectAtIndex:_deleteIndexPath.row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self returnCurrentMonth:_selectDate];
    [self returnSelectedDate:[_selectDate initDate]];
    
    [_calView refreshUI];
}

#pragma mark - other
-(void)refreshCalendarAndBill{
    [_calView refreshUI];
    [self returnCurrentMonth:_selectDate];
    [self returnSelectedDate:_selectDate];
    [self.tableView reloadData];

}

-(void)configCell:(CustomBillCell *)cell atIndex:(NSIndexPath *)path
{
    BillFather *onebillfather = [self.dataMuArr objectAtIndex:path.row];
    cell.categoryIconImage.image = [UIImage imageNamed:onebillfather.bf_category.iconName];
    cell.nameLabel.text = onebillfather.bf_billName;
    cell.dateLabel.text = [self stringWithDate:onebillfather.bf_billDueDate];
    //amount
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    double lestAmount = 0.00;
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([onebillfather.bf_billRecurringType isEqualToString:@"Never"]) {
        [paymentArray setArray:[onebillfather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else{
        [paymentArray setArray:[onebillfather.bf_billItem.billItemHasTransaction allObjects]];
    }
    for (int i=0; i<[paymentArray count]; i++) {
        Transaction *onePayment = [paymentArray objectAtIndex:i];
        if ([onePayment.state isEqualToString:@"1"]) {
            lestAmount += [onePayment.amount doubleValue];
        }
    }
    
    double dueAmount = onebillfather.bf_billAmount-lestAmount;
    if (dueAmount<0) {
        dueAmount = 0;
    }
    cell.amountLabel.text = [appDelegate.epnc formatterString:dueAmount];
}

-(NSString*)stringWithDate:(NSDate*)date{
    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    return [dateFormatter stringFromDate:date];
}

//获取选中的这一天的数据
-(void)loadItemsforselectedDay:(NSDate*)date
{
    self.dataMuArr = [NSMutableArray array];
    AppDelegate_iPhone *appdelegateiphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    for (int i=0; i<[_totalMuArray count]; i++)
    {
        BillFather *billfather = [_totalMuArray objectAtIndex:i];
        
        if ([appdelegateiphone.epnc dateCompare:[date initDate] withDate:billfather.bf_billDueDate]==0)
        {
            [self.dataMuArr addObject:billfather];
        }
    }
    
    NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"bf_billDueDate" ascending:NO];
    [self.dataMuArr sortUsingDescriptors:[[NSArray alloc] initWithObjects:sort, nil]];
}



-(NSArray*)getBillItemArray:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",nil];
    
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBill2byDate" substitutionVariables:sub];
    
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    return objects;
    
}

-(void)useBill2CreateAllBill:(NSMutableArray *)tmpBill2Array allArray:(NSMutableArray *)tmpAllArray{
    for (int i=0; i<[tmpBill2Array count]; i++) {
        EP_BillItem *billObject = [tmpBill2Array objectAtIndex:i];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        
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

//获取bill1中的数据
-(NSMutableArray*)getBillRuleArray:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *sub = [[NSDictionary alloc]initWithObjectsAndKeys:endDate,@"startDate",nil];
    NSFetchRequest *fetch = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"searchBillRulebyDate" substitutionVariables:sub];
    NSError *error = nil;
    NSArray *objects = [[NSArray alloc]initWithArray:[appDelegate.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    NSMutableArray *tmpBill1Array = [[NSMutableArray alloc]init];
    for (int i=0; i<[objects count]; i++) {
        EP_BillRule *oneBill = [objects objectAtIndex:i];
        if ([appDelegate.epnc dateCompare:oneBill.ep_billEndDate withDate:startDate]>=0) {
            [tmpBill1Array insertObject:oneBill atIndex:[tmpBill1Array count]];
            //            [_bvc_Bill1Array removeObjectAtIndex:i];
        }
    }
    
    return tmpBill1Array;
}


//通过bill1创建billfather
-(void)useBill1CreateAllBill:(NSMutableArray *)bill1Array totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    for (int i=0; i<[bill1Array count]; i++) {
        EP_BillRule *oneBill = [bill1Array objectAtIndex:i];
        [self setBillFathferbyBillRule:oneBill totalArray:totalArray  startDate:startDate endDate:endDate];
    }
}

-(void)setBillFathferbyBillRule:(EP_BillRule *)bill totalArray:(NSMutableArray *)totalArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
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
        if ([appDelegate.epnc dateCompare:startDate withDate:endDateorBillEndDate]>0) {
            return;
        }
        else{
            //循环创建账单
            while ([appDelegate.epnc dateCompare:lastDate withDate:endDateorBillEndDate]<=0)
            {
                
                if ([appDelegate.epnc dateCompare:lastDate withDate:startDate]>=0)
                {
                    BillFather *oneBillfather = [[BillFather alloc]init];
                    
                    [appDelegate.epdc editBillFather:oneBillfather withBillRule:bill withDate:lastDate];
                    [totalArray  addObject:oneBillfather];
                }
                
                //获取下一次循环的时间
                lastDate= [appDelegate.epnc getDate:lastDate byCycleType:bill.ep_recurringType];
            }
        }
    }
}


-(NSDate*)getMonthStartDay:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
    comps.day = 1;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

-(NSDate*)getMonthEndDay:(NSDate*)date{
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
    comps.month += 1;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = -1;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
}

@end

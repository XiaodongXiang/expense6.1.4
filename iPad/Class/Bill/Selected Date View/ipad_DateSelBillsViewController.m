//
//  ipad_DateSelBillsViewController.m
//  PocketExpense
//
//  Created by MV on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipad_DateSelBillsViewController.h"
#import "ipad_BillsCell.h"
#import "PokcetExpenseAppDelegate.h" 
#import "BillFather.h"
#import "EP_BillItem.h"
#import "EP_BillRule.h"
#import "HMJButton.h"
#import "ipad_BillEditViewController.h"
#import "AppDelegate_iPad.h"

#import <Parse/Parse.h>
#import "ParseDBManager.h"

@implementation ipad_DateSelBillsViewController
@synthesize iBillsViewController;
@synthesize selDate,outputFormatterCell,selDateBillsArray,swipIndex;

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    outputFormatterCell = [[NSDateFormatter alloc] init];
//    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[outputFormatterCell setDateFormat:@"MMM dd"];	
    self.title = [outputFormatterCell stringFromDate:selDate];
    outputFormatterCell.dateStyle = NSDateFormatterMediumStyle;
    outputFormatterCell.timeStyle = NSDateFormatterNoStyle;
    [outputFormatterCell setLocale:[NSLocale currentLocale]];
    [super viewDidLoad];
    
    swipIndex = nil;
 }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate.mainViewController.iBillsViewController.needShowSelectedDateBillViewController = NO;
}


#pragma mark Btn Action
-(void)celleditBtnPressed:(HMJButton *)sender{
    self.swipIndex = nil;
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.AddPopoverController isPopoverVisible])
    {
        [appDelegate.AddPopoverController dismissPopoverAnimated:NO];
    }
    
    BillFather *billFather = [selDateBillsArray objectAtIndex:sender.btnIndex.row];
    [self performSelector:@selector(showBillEditViewController:) withObject:billFather afterDelay:0.1];
    
    
    
    //    [self.tableView reloadData];
}

-(void)celldeleteBtnPressed:(HMJButton *)sender isCalenderTableViewBill:(BillFather *)calendarBillFather
{
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.AddPopoverController isPopoverVisible])
    {
        [appDelegate.AddPopoverController dismissPopoverAnimated:NO];
    }
    
    BillFather *billFather = [selDateBillsArray objectAtIndex:sender.btnIndex.row];
    [self performSelector:@selector(showActionView:) withObject:billFather afterDelay:0.1];
}

-(void)showBillEditViewController:(BillFather *)billFather
{
    ipad_BillEditViewController *iBillEditVoewController = [[ipad_BillEditViewController alloc]initWithNibName:@"ipad_BillEditViewController" bundle:nil];
    
    
    iBillEditVoewController .typeOftodo = @"IPAD_EDIT";
    iBillEditVoewController .billFather = billFather;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:iBillEditVoewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
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
    
    
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.AddPopoverController dismissPopoverAnimated:YES];

}
-(void)showActionView:(BillFather *)billFather
{
    if (![billFather.bf_billRecurringType isEqualToString:@"Never"])
    {
        
        NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_This is a repeating bill. Do you want to delete this bill, or all future bills for name'%@'?", nil)];
        NSString *searchString = @"%@";
        //range是这个字符串的位置与长度
        NSRange range = [string1 rangeOfString:searchString];
        [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:billFather.bf_billName];
        NSString *meg = string1;
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:meg delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Just This Bill", nil) otherButtonTitles:NSLocalizedString(@"VC_All Future Bills", nil), nil];
        //        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
//        CGPoint point1 = [self.tableView convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
//        [actionsheet showFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
        [actionsheet showFromRect:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-50,[UIScreen mainScreen].bounds.size.height/2.0-50, 100,100) inView:appDelegate.mainViewController.view animated:YES];
        
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
        
        [selDateBillsArray removeObjectAtIndex:self.swipIndex.row];
        self.swipIndex = nil;
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        
        [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
        
    }
    
    [self.tableView reloadData];
}


#pragma mark Table view methods - config cell
- (void)configureBillCell:(ipad_BillsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
	BillFather *oneBillFather= [selDateBillsArray objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	cell.nameLabel.text = oneBillFather.bf_billName;
	

    //计算支付的金额
    NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
    if ([oneBillFather.bf_billRecurringType isEqualToString:@"Never"])
    {
        [paymentArray setArray:[oneBillFather.bf_billRule.billRuleHasTransaction allObjects]];
    }
    else
    {
        [paymentArray setArray:[oneBillFather.bf_billItem.billItemHasTransaction allObjects]];
    }
    
    
    double paymentAmount = 0;
    for (int i=0; i<[paymentArray count]; i++) {
        Transaction *oneTrans = [paymentArray objectAtIndex:i];
        if ([oneTrans.state isEqualToString:@"1"]) {
            paymentAmount += [oneTrans.amount doubleValue];
            
        }
    }
    
    cell.paidStateImageView.hidden = NO;
    //过期没支付完
    if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)) {
        cell.paidStateImageView.image = [UIImage imageNamed:@"mark_red.png"];
    }
    //过期支付完
    else if ((paymentAmount >= oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]<0)){
        cell.paidStateImageView.image = [UIImage imageNamed:@"mark_green.png"];
    }
    //没过期一点没支付
    else if((paymentAmount ==0) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
        cell.paidStateImageView.image = [UIImage imageNamed:@"mark_gray.png"];

    }
    //没过期 没支付完
    else if ((paymentAmount < oneBillFather.bf_billAmount) && ([appDelegate.epnc dateCompare:oneBillFather.bf_billDueDate withDate:[NSDate date]]>=0)){
        cell.paidStateImageView.image = [UIImage imageNamed:@"mark_green2.png"];
    }
    else{
        cell.paidStateImageView.image = [UIImage imageNamed:@"mark_green.png"];
    }

    if (oneBillFather.bf_category != nil)
	{
 		cell.categoryIconImage.image = [UIImage imageNamed:oneBillFather.bf_category.iconName];
	}
	NSString* time = [outputFormatterCell stringFromDate:oneBillFather.bf_billDueDate];
	cell.dateLabel.text = time;
	cell.amountLabel.text = [appDelegate.epnc formatterString:oneBillFather.bf_billAmount];
    
    cell.celleditBtn.btnIndex = indexPath;
    cell.celldeleteBtn.btnIndex = indexPath;
    
    if (indexPath.row==[selDateBillsArray count]-1) {
        cell.bgImageView.image = [UIImage imageNamed:@"ipad_cell2_bill_330_60.png"];
    }
    else
        cell.bgImageView.image = [UIImage imageNamed:@"ipad_cell1_bill_330_60.png"];
  }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    return [selDateBillsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    ipad_BillsCell *cell = (ipad_BillsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[ipad_BillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.iDateSelBillsViewController = self;
        [cell.celleditBtn addTarget:self action:@selector(celleditBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.celldeleteBtn addTarget:self action:@selector(celldeleteBtnPressed:isCalenderTableViewBill:) forControlEvents:UIControlEventTouchUpInside];
    }
	cell.indePath = indexPath;
    cell.celldeleteBtn.btnIndex = indexPath;
    cell.celleditBtn.btnIndex = indexPath;
    [self configureBillCell:cell atIndexPath:indexPath];
    if (self.swipIndex.section==indexPath.section && self.swipIndex.row==indexPath.row && self.swipIndex != nil) {
        [cell layoutShowTwoCellBtns:YES];
    }
    else
        [cell layoutShowTwoCellBtns:NO];
    return cell;
}

//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    BillItemClass *tmpBill= [selDateBillsArray objectAtIndex:indexPath.row];
//    
//    [self.iBillsViewController showBillEditViewBill:tmpBill]; 
//    PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; 
//	[appDelegate.AddPopoverController dismissPopoverAnimated:YES];
//
// }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.swipIndex != nil)
    {
        self.swipIndex = nil;
        [tableView reloadData];
        return;
    }
    BillFather *oneBillFather= [selDateBillsArray objectAtIndex:indexPath.row];
    PokcetExpenseAppDelegate * pckDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //先让pop消失，然后再弹出新的东西
    if([pckDelegate.AddPopoverController isPopoverVisible])
    {
        [pckDelegate.AddPopoverController dismissPopoverAnimated:YES];
    }

    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainViewController.iBillsViewController payBillWithBills:oneBillFather];
    
    
}



#pragma mark ActionSheet delegaet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    BillFather *billFather = [selDateBillsArray objectAtIndex:swipIndex.row];
    
    if (buttonIndex==2) {
        self.swipIndex = nil;
        [self.tableView reloadData];
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

    [selDateBillsArray removeObjectAtIndex:swipIndex.row];
    self.swipIndex = nil;

    [self.tableView reloadData];
    
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
    
}


@end

//
//  BillFather.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-2.
//
//

#import <Foundation/Foundation.h>

@class EP_BillRule,EP_BillItem,Payee,Category;

@interface BillFather : NSObject{
    NSString    *bf_billName;
    double       bf_billAmount;
    NSDate      *bf_billDueDate;
    NSDate      *bf_billEndDate;
    NSString    *bf_billRecurringType;
    NSString    *bf_billReminderDate;
    NSDate      *bf_billReminderTime;
    NSString    *bf_billNote;
    
    
    EP_BillRule *bf_billRule;
    EP_BillItem *bf_billItem;
    Category    *bf_category;
    Payee       *bf_payee;
}

@property(nonatomic,strong)NSString    *bf_billName;
@property(nonatomic,assign)double       bf_billAmount;
@property(nonatomic,strong)NSDate      *bf_billDueDate;
@property(nonatomic,strong)NSDate      *bf_billEndDate;
@property(nonatomic,strong)NSString    *bf_billRecurringType;
@property(nonatomic,strong)NSString    *bf_billReminderDate;
@property(nonatomic,strong)NSDate      *bf_billReminderTime;
@property(nonatomic,strong)NSString    *bf_billNote;


@property(nonatomic,strong)EP_BillRule *bf_billRule;
@property(nonatomic,strong)EP_BillItem *bf_billItem;
@property(nonatomic,strong)Category    *bf_category;
@property(nonatomic,strong)Payee       *bf_payee;

@end

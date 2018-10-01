//
//  XDAddPayViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/4/10.
//

#import <UIKit/UIKit.h>
#import "BillFather.h"
#import "Transaction.h"
@interface XDAddPayViewController : UIViewController

@property(nonatomic, strong)BillFather * billFather;
@property(nonatomic, strong)Transaction * transaction;

@end

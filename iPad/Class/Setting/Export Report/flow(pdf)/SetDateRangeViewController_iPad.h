//
//  SetDateRangeViewController_iPad.h
//  PocketExpense
//
//  Created by humingjing on 14-5-20.
//
//

#import <UIKit/UIKit.h>

@class ipad_RepTransactionFilterViewController,ipad_RepCashflowFilterViewController;

@interface SetDateRangeViewController_iPad : UITableViewController
{
    ipad_RepTransactionFilterViewController *iRepTransactionFilterViewController;
    ipad_RepCashflowFilterViewController *iRepCashflowFilterViewController;
	NSString *moduleString;
	NSString *dateRangeString;
    
	NSInteger currentSelect;
	BOOL isSubPopView;
}

@property (nonatomic, strong) ipad_RepTransactionFilterViewController *iRepTransactionFilterViewController;
@property (nonatomic, strong) ipad_RepCashflowFilterViewController *iRepCashflowFilterViewController;
//@property (nonatomic, strong) RepBillFilterViewController     *repBillFilterViewController;

@property (nonatomic, copy ) NSString *moduleString;
@property (nonatomic, copy ) NSString *dateRangeString;

@property (nonatomic, assign ) NSInteger currentSelect;
@property (nonatomic, assign ) BOOL isSubPopView;


@end

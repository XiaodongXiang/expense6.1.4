//
//  MonthCalDataView.h
//  PocketExpense
//
//  Created by humingjing on 14/12/2.
//
//

#import <UIKit/UIKit.h>

@interface MonthCalDataView : UIView
{
    NSMutableArray              *dailyAmountArray;
    NSDateFormatter            *dateFormatter;

}
-(void)fetchTransactionFromDate:(NSDate *)fDate endDate:(NSDate *)tDate refreshTask:(BOOL)refreshTask;
@end

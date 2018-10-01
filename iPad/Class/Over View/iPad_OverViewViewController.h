//
//  iPad_OverViewViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-8.
//
//

#import <UIKit/UIKit.h>

#import "KalViewController.h"
#import "KalView.h"
#import "KalLogic.h"
#import "NSDateAdditions.h"
#import "KalDate.h"
#import "budgetBar_iPad.h"

#import "OverViewcategoryViewController.h"

#import "FYChartView.h"

@class ipad_TranscactionQuickEditViewController;
@class ipad_ADSDeatailViewController;
@interface iPad_OverViewViewController : UIViewController<FYChartViewDataSource,FYChartViewDelegate>
{
    //日历
    UIView                      *calendarContainView;
    KalViewController           *kalViewController;
    id                          dataSource;
    
    //选中月份的起始时间
    NSDate *monthStartDate;
    NSDate  *monthEndDate;
    NSMutableArray  *monthTransactionArray;//存放选中这个月的交易数组，用来（1）统计expense,income,net worth（2）日历的trans
    
    UILabel                     *expenseAmountLabel;
    UILabel                     *incomeAmountLabel;
    UILabel                     *netWorthAmountLabel;
    
    //budget
    UILabel                     *availableBudgetAmountLabel;
    UIButton                    *budgetBtn;
    UILabel                     *leftLabel;
    
    //cash flow
    UIView                      *cashFlowContainView;
    FYChartView                 *cahsFlowView;
    NSFetchedResultsController *fetchedResultsByDateController;
    NSMutableArray              *transactionByDateArray;//存放一个月所有天数的交易数组
    NSMutableArray              *cashFlowTransactionArray;//
    UILabel                     *noRecordLabel;
    
    //category report
    UIView                          *categoryContainView;
    OverViewcategoryViewController *overviewCategoryViewController;
    ipad_ADSDeatailViewController *adsViewController;
    
    UILabel             *budgetLabelText;
    UILabel             *cashFlowLabelText;
    UILabel             *categoryLabelText;

    
}
@property (nonatomic,strong) IBOutlet UIView  *calendarContainView;
@property (nonatomic,strong) KalViewController*kalViewController;
@property (nonatomic,strong) id               dataSource;

@property (nonatomic,strong) NSDate *monthStartDate;
@property (nonatomic,strong) NSDate  *monthEndDate;
@property (nonatomic,strong) NSMutableArray  *monthTransactionArray;

@property (nonatomic,strong) IBOutlet UILabel *expenseAmountLabel;
@property (nonatomic,strong) IBOutlet UILabel *incomeAmountLabel;
@property (nonatomic,strong) IBOutlet UILabel *netWorthAmountLabel;

@property (nonatomic,strong) IBOutlet UILabel *availableBudgetAmountLabel;
@property (nonatomic,strong) IBOutlet UILabel                     *leftLabel;
@property (nonatomic,strong) IBOutlet UIButton                    *budgetBtn;

@property (nonatomic,strong) IBOutlet UIView                      *cashFlowContainView;
@property (nonatomic,strong) FYChartView                 *cahsFlowView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsByDateController;
@property (nonatomic,strong)NSMutableArray              *transactionByDateArray;
@property (nonatomic,strong)NSMutableArray              *cashFlowTransactionArray;
@property (nonatomic,strong) IBOutlet UILabel                     *noRecordLabel;

@property (nonatomic,strong) IBOutlet UIView                          *categoryContainView;
@property (nonatomic,strong) OverViewcategoryViewController *overviewCategoryViewController;
@property (nonatomic,strong)ipad_TranscactionQuickEditViewController *iTransactionViewController;
@property(nonatomic,strong)IBOutlet UIButton *adsBtn;
@property(nonatomic,strong)IBOutlet UIView  *adsView;
@property(nonatomic,strong)IBOutlet UILabel *purchaseLabelText;
@property(nonatomic,strong)IBOutlet UILabel *noadsLabelText;

@property(nonatomic,strong)IBOutlet UILabel             *budgetLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *cashFlowLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *categoryLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *expenseLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *incomeLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *networthLabelText;
@property (strong, nonatomic) IBOutlet UIView *budgetContainView;
@property (strong, nonatomic) IBOutlet UILabel *budgetRemainLabel;
@property (strong, nonatomic) IBOutlet UILabel *budgetExpenseLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *budgetBottomToRight;


@property(nonatomic,strong)ipad_ADSDeatailViewController *adsViewController;

-(void)refleshUI;
-(void)refleshData;
//-(void)refleshDataWhenCalenderUPorDown;
-(void)hideorShowAds;

-(void)resetCalendarStyle;
@end

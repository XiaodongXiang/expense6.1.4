//
//  ExpenseViewController.h
//  PokcetExpense
//
//  Created by ZQ on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

//---------------------Transaction 饼状图页面------------------------------
#import <UIKit/UIKit.h>
#import "PiChartView.h"
#import <CoreData/CoreData.h>
#import "SubCateRect.h"
#import "Category.h"

#import "ChildCategoryCount.h"

@class ExpenseSecondCategoryViewController,CashDetailTransactionViewController;
@class ADSDeatailViewController;



@class HMJBrokenLineView;
@interface ExpenseViewController : UIViewController
<NSFetchedResultsControllerDelegate,PiChartViewDelegate,SubCateRectDelegate,UITableViewDataSource,UITableViewDelegate>
{
    double totalCategoryExpenseAmount;
    double totalCategoryIncomeAmount;
    UILabel        *expenseFrontLabel;
    UILabel        *expenseBackLabel;
    UILabel        *incomeFrontLabel;
    UILabel        *incomeBackLabel;
}

//nav left
@property (strong, nonatomic) IBOutlet UIView       *leftBarView;
@property (weak, nonatomic) IBOutlet UILabel        *leftBarLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *leftBarArrow;
@property (weak, nonatomic) IBOutlet UIButton       *leftBarBtn;

//nav right
@property (strong, nonatomic) IBOutlet UIView       *rightBarView;
@property (weak, nonatomic) IBOutlet UILabel        *rightBarLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *rightBarArrow;
@property (weak, nonatomic) IBOutlet UIButton       *rightBarBtn;

//report type
@property (weak, nonatomic) IBOutlet UIView         *typeView;
@property (weak, nonatomic) IBOutlet UIButton       *categoryBtn;
@property (weak, nonatomic) IBOutlet UIButton       *cashFlowBtn;


@property (weak, nonatomic) IBOutlet UIView         *cateandcashContainView;

//category部分
@property (weak, nonatomic) IBOutlet UIView         *categoryPartView;
@property (weak, nonatomic) IBOutlet UIButton       *expenseBtn;
@property (weak, nonatomic) IBOutlet UIButton       *incomeBtn;
@property (nonatomic, strong)IBOutlet PiChartView   *pichartView;
@property (nonatomic, strong)IBOutlet UITableView   *categorytableview;
@property (nonatomic,weak)IBOutlet   UILabel        *categoryDateLabel;

@property (nonatomic, strong)NSMutableArray         *transactionArray;
@property (nonatomic, strong)NSMutableArray         *detailTranArray;
@property (nonatomic, strong)NSMutableArray         *piViewDateArray;//存放Expensele类型的category
@property (nonatomic, strong)NSMutableArray         *piViewDateArray_Income;//存放Income类型的category信息
@property (nonatomic, strong)NSMutableArray         *categoryArrayList;
@property (nonatomic, strong)NSFetchedResultsController	   *fetchedResultsController;

//category time
@property (weak, nonatomic) IBOutlet UIView *categoryLine;

@property(nonatomic,strong)IBOutlet UIView                  *dateRangeView;
@property(nonatomic,strong)IBOutlet UIButton                *date1Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date2Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date3Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date4Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date5Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date6Btn;
@property(nonatomic,strong)IBOutlet UIButton                *date7Btn;

//cash flow
@property (nonatomic, weak)IBOutlet UIView                *cashFlowPartView;


//cash time
@property (weak, nonatomic) IBOutlet UIScrollView *barChartView;
@property (weak, nonatomic) IBOutlet UIView *cashFlowLine;
@property (weak, nonatomic) IBOutlet UIView *cashTimeView;
@property (weak, nonatomic) IBOutlet UIButton *thisYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *LastTweleveBtn;
@property (weak, nonatomic) IBOutlet UITableView *cashflowTableView;
@property (nonatomic,weak)IBOutlet   UILabel        *cashFlowDateLabel;


@property (nonatomic, strong)NSMutableArray                 *transactionByDateArray;
@property(nonatomic,strong)NSMutableArray                   *tmpTransactionByDateArray;
@property (nonatomic, strong)NSFetchedResultsController     *fetchedResultsByDateController;

//public
@property (nonatomic, strong)NSDateFormatter                *dateFormatter1;
@property (nonatomic, strong)NSDateFormatter                *dateFormatter;
@property (nonatomic, strong)NSDateFormatter                *monthFormatter;
@property (nonatomic, strong)NSDateFormatter                *yearFormatter;
@property(nonatomic,strong)NSDate                           *customStartDate;
@property(nonatomic,strong)NSDate                           *customEndDate;
@property (nonatomic, assign)NSInteger                      dateType;
@property (nonatomic, strong)NSDate                         *categoryStartDate;
@property (nonatomic, strong)NSDate                         *categoryEndDate;
@property (nonatomic, strong)NSDate                         *cashStartDate;
@property (nonatomic, strong)NSDate                         *cashEndDate;
@property (strong, nonatomic) IBOutlet UIView *shadowView;


@property(nonatomic,strong)ExpenseSecondCategoryViewController *expenseSecondCategoryViewController;
@property(nonatomic,strong)CashDetailTransactionViewController    *cashDetailTransactionViewController;


-(void)getSegmentDataFromeCustomeDataNextPart;
-(void)getSegmentDataFromeCustomeDataLastPart;

-(void)refleshUI;
-(void)resetStyleWithAds;
@end

//
//  ipad_ReportCashFlowViewController.h
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BrokenLineObject.h"
#import "ReportBrokenLineView.h"

@interface BarChartData : NSObject {
  	double totalAmount;
    NSMutableArray *tranArray;
    NSString *titleString;
    NSDate  *startDate;
    NSDate *endDate;
    NSString    *brokenLineTitle;
}
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong) NSMutableArray *tranArray;
@property (nonatomic, strong)  NSString *titleString;
@property (nonatomic, strong)  NSDate  *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong)NSString    *brokenLineTitle;

@end

@interface ipad_ReportCashFlowViewController : UIViewController

<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,NSFetchedResultsControllerDelegate,UIScrollViewDelegate>
{
    double totalExpenseAmount;
    double  totalIncomeAmount;
}

@property (strong, nonatomic) IBOutlet UIButton    *dateDurBtn;
@property (weak,nonatomic)    IBOutlet UIImageView  *bgImageView;
@property (strong, nonatomic) IBOutlet UIView      *dateRangeSelView;
@property (strong, nonatomic) IBOutlet UIButton    *thisYearBtn;
@property (strong, nonatomic) IBOutlet UIButton    *lastYearBtn;
@property (strong, nonatomic) IBOutlet UIButton    *LastTweleveBtn;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic)IBOutlet UILabel     *dateLabel;

@property (strong, nonatomic) IBOutlet UITableView *cashFlowTable;;

@property (weak, nonatomic) IBOutlet UIScrollView *barChartView;
@property (strong, nonatomic)NSDate						   *cashStartDate;
@property (strong, nonatomic)NSDate						   *cashEndDate;
@property (strong, nonatomic)NSMutableArray *transactionByDateArray;

@property (nonatomic, assign) NSInteger numOfBarColumn;

@property (strong, nonatomic)IBOutlet UILabel *yValue1;
@property (strong, nonatomic)IBOutlet UILabel *yValue2;
@property (strong, nonatomic)IBOutlet UILabel *yValue3;
@property (strong, nonatomic)IBOutlet UILabel *yValue4;
@property (strong, nonatomic)IBOutlet UILabel *yValue5;
@property (strong, nonatomic)IBOutlet UILabel *yValue6;

@property   (weak,nonatomic)IBOutlet    UILabel     *totalTextLabel;
@property (strong, nonatomic)IBOutlet UILabel     *totalIncomeLabel;
@property (weak,nonatomic)  IBOutlet    UILabel     *totalExpenseLabe;
@property (nonatomic, strong)NSFetchedResultsController     *fetchedResultsByDateController;


-(void)reFlashTableViewData;

@end

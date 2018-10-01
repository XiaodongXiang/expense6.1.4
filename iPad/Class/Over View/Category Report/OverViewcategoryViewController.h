//
//  OverViewcategoryViewController.h
//  PocketExpense
//
//  Created by appxy_dev on 14-4-23.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "PiChartView.h"
#import "Category.h"


@class ChildCategoryCount,TranscationCategoryCount;
@interface OverViewcategoryViewController : UIViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PiChartView                     *piCahrView;
    UITableView                     *myTableView;
    NSDate                          *startDate;
    NSDate                          *endDate;
    UIButton                        *expenseOrIncomeBtn;
    
    NSMutableArray                  *transactionArray;//选定时间范围的交易数组
    NSMutableArray                  *piViewDateArray;//圆饼图的数组
    NSMutableArray                  *categoryArrayList;//
    NSFetchedResultsController      *fetchedResultsController;
    
    UILabel                         *noRecordView;
}

@property(nonatomic,retain)IBOutlet PiChartView *piCahrView;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
@property(nonatomic,retain)NSDate *startDate;
@property(nonatomic,retain)NSDate *endDate;
@property(nonatomic,retain)IBOutlet UIButton            *expenseOrIncomeBtn;

@property(nonatomic,retain)NSMutableArray                 *transactionArray;//选定时间范围的交易数组
@property(nonatomic,retain)NSMutableArray				   *piViewDateArray;//圆饼图的数组
@property(nonatomic,retain)NSMutableArray				   *categoryArrayList;//
@property(nonatomic,retain)NSFetchedResultsController	   *fetchedResultsController;

@property(nonatomic,retain)IBOutlet UILabel                         *noRecordView;

- (void)getDateSouce_category;

@end

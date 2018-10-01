//
//  CategoryViewController_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/26.
//
//

#import <UIKit/UIKit.h>
#import "PiChartView.h"
#import "PokcetExpenseAppDelegate.h"
#import "TranscationCategoryCount.h"
#import "ChildCategoryCount.h"

@interface CategoryViewController_iPad : UIViewController

@property (nonatomic, strong)NSMutableArray         *piViewDateArray;//存放Expensele类型的category
@property (nonatomic, strong)NSMutableArray         *piViewDateArray_Income;//存放Income类型的category信息
@property (nonatomic, strong)NSMutableArray         *categoryArrayList;
@property (nonatomic, strong)NSFetchedResultsController	   *fetchedResultsController;
@property (strong, nonatomic) NSDate						   *endDate;
@property (strong, nonatomic) NSDate						   *startDate;
-(void)refreshView;
@end

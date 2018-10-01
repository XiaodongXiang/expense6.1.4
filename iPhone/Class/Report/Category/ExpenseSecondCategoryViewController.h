//
//  ExpenseSecondCategoryViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-25.
//
//

#import <UIKit/UIKit.h>
#import "PiChartView.h"
#import <CoreData/CoreData.h>
#import "Category.h"
#import "SubCateRect.h"
#import "ExpenseViewController.h"
#import "TranscationCategoryCount.h"

@class TransactionEditViewController;
@interface ExpenseSecondCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
	
    UITableView                    *categoryTableView;
    
	NSDate						   *startDate;
	NSDate						   *endDate;
    NSInteger                      dateType;
    
	NSMutableArray				   *piViewDateArray;
    
    
    BOOL                        isExpenseType;
    Category                       *c;
    TranscationCategoryCount        *cc;
    //4.5.1检测是否有category相关连的transaction被删除了
    NSMutableArray                  *categoryArray;
    BOOL                            thisCategoryisBeenDelete;
    
    
    
    NSDateFormatter         *dateFormatter;

    
}

@property(nonatomic,strong) IBOutlet UITableView        *trantableview;
@property(nonatomic,strong) NSDate                      *startDate;
@property(nonatomic,strong) NSDate                      *endDate;
@property(nonatomic,assign) NSInteger                   dateType;

@property(nonatomic,strong) NSMutableArray              *piViewDateArray;

@property(nonatomic,assign)  BOOL                        isExpenseType;


@property(nonatomic,strong) Category                    *c;
@property(nonatomic,strong) TranscationCategoryCount    *cc;

@property(nonatomic,strong)NSMutableArray               *categoryArray;

@property(nonatomic,strong)TransactionEditViewController *transactionEditViewController;

@property(nonatomic,strong)NSDateFormatter         *dateFormatter;



- (void)getDateSouce;
-(void)refleshUI;
@end

//
//  SearchRelatedViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 14-1-14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DuplicateTimeViewController.h"

@class Transaction;
@interface SearchRelatedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DuplicateTimeViewControllerDelegate,UIActionSheetDelegate>
{
    Transaction     *transaction;
    
    UIButton        *categoryBtn;
    UIButton        *payeeBtn;
    
    UITableView     *myTableView;
    NSMutableArray  *transactionArray;
    NSInteger       swipCellIndex;
    NSDate     *duplicateDate;

    NSDateFormatter *dateTimeFormatter;
}


@property (weak, nonatomic) IBOutlet UIImageView *line;
@property(nonatomic,strong)Transaction              *transaction;
@property(nonatomic,strong)IBOutlet UIButton        *categoryBtn;
@property(nonatomic,strong)IBOutlet UIButton        *payeeBtn;
@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)NSMutableArray           *transactionArray;
@property(nonatomic,assign)NSInteger       swipCellIndex;
@property(nonatomic,strong)NSDateFormatter *dateTimeFormatter;
@property(nonatomic,strong)NSDate     *duplicateDate;
@property(nonatomic,strong)DuplicateTimeViewController *duplicateDateViewController;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

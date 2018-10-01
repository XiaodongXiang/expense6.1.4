//
//  ipad_SearchRelatedViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class Transaction;

@interface ipad_SearchRelatedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    Transaction     *transaction;
    
    UIButton        *categoryBtn;
    UIButton        *payeeBtn;
    
    UITableView     *myTableView;
    NSMutableArray  *transactionArray;
    NSInteger       swipCellIndex;
    
    NSDateFormatter *dateTimeFormatter;
}

@property(nonatomic,strong)Transaction              *transaction;
@property(nonatomic,strong)IBOutlet UIButton        *categoryBtn;
@property(nonatomic,strong)IBOutlet UIButton        *payeeBtn;
@property(nonatomic,strong)IBOutlet UITableView     *myTableView;
@property(nonatomic,strong)NSMutableArray           *transactionArray;
@property(nonatomic,assign)NSInteger       swipCellIndex;
@property(nonatomic,strong)NSDateFormatter *dateTimeFormatter;

@end

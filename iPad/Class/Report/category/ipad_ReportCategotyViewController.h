//
//  ipad_ReportCategotyViewController.h
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import <UIKit/UIKit.h>
#import "PiChartView.h"
#import "CategoryCount.h"

//typedef enum {
//    noneType =0,
//	parentWithChild = 1,
//	childOnly =2,
//	parentNoChild =3
// 	
//}CategoryPCType;

@class Category,Transaction,Payee;
@interface DateRangeCount : NSObject {
    NSString *titleString;
    NSDate   *startDate;
    NSDate    *endDate;
}
@property (nonatomic, copy)  NSString *titleString;
@property (nonatomic, strong) NSDate   *startDate;
@property (nonatomic, strong)  NSDate    *endDate;
@end

//@interface CategoryCount : NSObject {
//	Category *categoryItem;
// 	double cellHeight;
//    CategoryPCType pcType;
//    NSString *cateName;
//}
//@property (nonatomic, copy)  NSString *cateName;
//
//@property (nonatomic, strong)  Category *categoryItem;
//@property (nonatomic, assign) double cellHeight;
//@property (nonatomic, assign)  CategoryPCType pcType;
//
//@end

@interface CategoryTotal : NSObject {
    NSString *cateName;
    double totalAmount;
    BOOL hasChildCategory;
    NSMutableArray *categoryArray;
}
@property (nonatomic, copy)  NSString *cateName;

@property (nonatomic, assign) double totalAmount;
@property (nonatomic, assign)  BOOL hasChildCategory;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@end


@interface CategoryItem : NSObject {
    double categoryAmount;
    Category *c;
    NSString *cName;
    NSMutableArray *transArray;
}


@property (nonatomic, strong) Category *c;
@property (nonatomic, strong) NSMutableArray *transArray;

@property (nonatomic, assign) double categoryAmount;
@property (nonatomic, strong) NSString *cName;
@end

@interface ipad_ReportCategotyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>
{
    NSDateFormatter *outputFormatter;
    
    
    NSMutableArray                 *subDateRangeArray;//存放第二时间选择的数组
    NSMutableArray *categoryArrayList;//存放哪些category有transaction的数组
    NSMutableArray *piViewDateArray;//存放picharview需要的数组
    NSMutableArray  *categoryTransactionArray;//存放tableview需要的数组
    
}
@property (strong, nonatomic) NSDate						   *categoryStartDate;
@property (strong, nonatomic) NSDate						   *categoryEndDate;
@property (strong, nonatomic) IBOutlet UIButton    *reportTypeBtn;
@property (strong, nonatomic) IBOutlet UIView      *reportTypeView;
@property (strong, nonatomic) IBOutlet UIButton    *expenseBtn;
@property (strong, nonatomic) IBOutlet UIButton    *incomeBtn;
@property (strong, nonatomic) IBOutlet UILabel  *dateDurDesc;

@property (strong, nonatomic) IBOutlet UIButton    *dateDurBtn;
@property (strong, nonatomic) IBOutlet UIView      *dateRangeSelView;
@property (strong, nonatomic) IBOutlet UIButton    *date1Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date2Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date3Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date4Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date5Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date6Btn;
@property (strong, nonatomic) IBOutlet UIButton    *date7Btn;

@property (strong, nonatomic)UILabel     *dateLabel;

@property (strong, nonatomic) IBOutlet PiChartView	*piExpchartView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel     *totalAmountLabel;

-(void)reFlashTableViewData;
-(void)reFlashTableViewDataInThisViewController;
-(void)hidePopView;
-(void)resetDateRangeBtnState;
@end

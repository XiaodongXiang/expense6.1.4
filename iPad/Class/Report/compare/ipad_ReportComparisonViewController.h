//
//  ipad_ReportComparisonViewController.h
//  PocketExpense
//
//  Created by appxy_dev on 14-5-5.
//
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoryCmp : NSObject {
    double categoryAmount1;
    double categoryAmount2;
    double diffCategoryAmount;
    Category *category;
}

@property (nonatomic, assign)   double categoryAmount1;
@property (nonatomic, assign)  double categoryAmount2;
@property (nonatomic, assign)  double diffCategoryAmount;
@property (nonatomic, strong)  Category *category;

@end

@interface ipad_ReportComparisonViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>
{
    NSString *dateRangeString;
    UIButton    *dateDurBtn;
    UIView      *dateRangeSelView;
    UIButton    *dataSelBtn;
    UIButton    *dataSelBtn1;
    UIButton    *dataSelBtn2;
    UIButton    *dataSelBtn3;
    UIButton    *dataSelBtn4;
    UIButton    *dataSelBtn5;
    UIButton    *dataSelBtn6;
    NSDateFormatter *outputFormatter;
    UILabel  *dateDurDesc;

    
    //当选择month时牵引出来的
    UIButton    *subdateDurBtn;
    UIView      *subdateRangeSelView;
    UILabel     *dateLabel;
    
    UITableView *myTableView;
    NSString    *reportTypeString;
    UIView      *reportTypeView;
    UIButton     *categoryBtn;
    UIButton     *accountBtn;
    UILabel     *vsLabel;
    UIButton    *compareBtn;
    
    NSDate						   *startDate;
	NSDate						   *endDate;
    NSMutableArray                 *subDateRangeArray;//存放第二时间选择的数组
    NSMutableArray *compareArrayList;//存放哪些category有transaction的数组
    NSMutableArray  *compareConditionArray;
    
    
    NSInteger numOfBarColumn;
    
    
    
}
@property (strong, nonatomic) NSString *dateRangeString;
@property (strong, nonatomic) IBOutlet UIButton    *dateDurBtn;
@property (strong, nonatomic) IBOutlet UIView      *dateRangeSelView;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn1;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn2;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn3;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn4;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn5;
@property (strong, nonatomic) IBOutlet UIButton    *dataSelBtn6;
@property (strong, nonatomic) NSDateFormatter *outputFormatter;
@property (strong, nonatomic) IBOutlet UILabel  *dateDurDesc;

//当选择month时牵引出来的
@property (strong, nonatomic) IBOutlet UIButton    *subdateDurBtn;
@property (strong, nonatomic) IBOutlet UIView      *subdateRangeSelView;
@property (strong, nonatomic)UILabel     *dateLabel;


@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  NSString    *reportTypeString;
@property (strong, nonatomic) IBOutlet UIView      *reportTypeView;
@property (strong, nonatomic) IBOutlet UIButton     *categoryBtn;
@property (strong, nonatomic) IBOutlet UIButton     *accountBtn;
@property (strong, nonatomic) IBOutlet UILabel     *vsLabel;
@property (strong, nonatomic) IBOutlet UIButton    *compareBtn;

@property (strong, nonatomic)NSDate						   *startDate;
@property (strong, nonatomic)NSDate						   *endDate;
@property (strong, nonatomic)NSMutableArray                 *subDateRangeArray;
@property (strong, nonatomic)NSMutableArray  *compareArrayList;
@property (strong, nonatomic)NSMutableArray  *compareConditionArray;

-(void)reFlashTableViewData;
-(void)reFlashTableViewDataInThisViewController;


@end

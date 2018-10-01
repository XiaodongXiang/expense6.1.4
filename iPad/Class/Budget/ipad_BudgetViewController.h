//
//  ipad_BudgetViewController.h
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BudgetItem;
@interface BudgetHistoryCount : NSObject {
	NSString *dateString;
 	double totalAmount;
	double rollover;
	double availableAmount;
	double usedAmount;
	double incomeAmount;
	NSInteger dateType;
    BudgetItem *bi;
}

@property (nonatomic, copy)  NSString *dateString;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, assign) double rolloverAmount;
@property (nonatomic, assign) double availableAmount;
@property (nonatomic, assign) double usedAmount;
@property (nonatomic, assign) double incomeAmount;
@property (nonatomic, assign) NSInteger dateType;

@property (nonatomic, strong)BudgetItem *bi;

@end

@class ipad_BudgetSettingViewController;
@interface ipad_BudgetViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>{

    //left
	UITableView         *leftTableView;
    UIButton            *timeBtn;
    UILabel             *titleStringLabel;
    UIImageView         *dateBtntateImageView;
	UILabel             *availLabel;
    UILabel             *leftorSpentLabel;
    UIImageView         *spentImage;
    UIImageView         *spentImageLeftArc;
    UIImageView         *spentImageRightArc;
    
    NSMutableArray          *dateArray;
    UIView                  *dateRangeSelView;
    UIButton                *dataSelBtn;
    UIButton                *dataSelBtn1;
    UIButton                *dataSelBtn2;
    UIButton                *dataSelBtn3;
    UIButton                *dataSelBtn4;
    UIButton                *dataSelBtn5;
    NSInteger                 selectedBtnInterger;
    
    //right
	UITableView         *rightTableView;
    UIView              *noRecordViewLeft;

    UIView              *noRecordViewRight;
    

	NSMutableArray		*budgetArray;//存放budget的数组
    NSMutableArray      *transactionArray;
	NSInteger            deleteIndex;//选中右边哪一个交易
	NSInteger            indexOfBudgetArray;//选中左边哪一个budget
 
 	NSDateFormatter		*monthandYearDateFormatter;
	NSDateFormatter		*dateFormatter;
    NSDateFormatter     *dateFormatterWithOutYear;
	NSDate              *startDate;
    NSDate              *endDate;
    BOOL    hasBudget;
    

    UIView         *todayView;
    
    UILabel         *noBudgetRecordLabelText;
    UILabel         *noTransactionRecordLabelText;

    NSString        *budgetRepeatType;
    UILabel *currentBudgetNameLabel;
    UILabel *spentLabel;
}

@property(nonatomic,strong)IBOutlet UITableView         *leftTableView;
@property(nonatomic,strong)IBOutlet UIButton            *timeBtn;
@property(nonatomic,strong)IBOutlet UILabel             *titleStringLabel;
@property(nonatomic,strong)IBOutlet UIImageView         *dateBtntateImageView;
@property(nonatomic,strong)IBOutlet UILabel             *availLabel;
@property(nonatomic,strong)IBOutlet UILabel             *leftorSpentLabel;
@property(nonatomic,strong)IBOutlet UIImageView         *spentImage;
@property(nonatomic,strong)IBOutlet UIImageView         *spentImageLeftArc;
@property(nonatomic,strong)IBOutlet UIImageView         *spentImageRightArc;

@property(nonatomic,strong)NSMutableArray      *dateArray;
@property(nonatomic,strong)IBOutlet UIView                  *dateRangeSelView;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn1;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn2;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn3;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn4;
@property(nonatomic,strong)IBOutlet UIButton                *dataSelBtn5;
 @property(nonatomic,assign)NSInteger                 selectedBtnInterger;
//right
@property(nonatomic,strong)IBOutlet UITableView         *rightTableView;
@property(nonatomic,strong)IBOutlet UIView              *noRecordViewLeft;

@property(nonatomic,strong)IBOutlet UIView              *noRecordViewRight;

@property(nonatomic,strong)NSMutableArray		*budgetArray;//存放budget的数组
@property(nonatomic,strong)NSMutableArray      *transactionArray;
@property(nonatomic,assign)NSInteger deleteIndex;//选中右边哪一个交易
@property(nonatomic,assign)NSInteger indexOfBudgetArray;//选中左边哪一个budget

@property(nonatomic,strong)NSDateFormatter		*monthandYearDateFormatter;
@property(nonatomic,strong)NSDateFormatter		*dateFormatter;

@property(nonatomic,strong)NSDate              *startDate;
@property(nonatomic,strong)NSDate              *endDate;

@property(nonatomic,assign)BOOL    hasBudget;

@property(nonatomic,strong)IBOutlet UILabel         *todayLabel;
@property(nonatomic,strong)IBOutlet     UIView         *todayView;

@property(nonatomic,strong)IBOutlet UILabel         *noBudgetRecordLabelText;
@property(nonatomic,strong)IBOutlet UILabel         *noTransactionRecordLabelText;
@property(nonatomic,strong) UIView  *headView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *preMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *latterMonthBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (weak, nonatomic) IBOutlet UILabel *topViewLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineLabelToRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewFirstLabelToRight;
@property (weak, nonatomic) IBOutlet UIButton *adjustBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLineWidth;


@property(nonatomic,strong)ipad_BudgetSettingViewController *budgetSettingViewController;
-(void)reFlashTableViewData;
-(void)refleshUI;
-(void)changeBudgetRepeatStyle;
@end

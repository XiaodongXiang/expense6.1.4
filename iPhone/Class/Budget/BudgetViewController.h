//
//  BudgetViewController.h
//  Expense 5
//
//  Created by BHI_James on 4/21/10.
//  Copyright 2010 BHI. All rights reserved.
//

/*-----------------------------------budget 列表界面---------------------------*/
#import <UIKit/UIKit.h>
 #import "Setting+CoreDataClass.h"

@class BudgetListViewController,BudgetDetailViewController;
@class BudgetSettingViewController;

@interface BudgetViewController : UIViewController 
<NSFetchedResultsControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    float          spentimage_with;
    float          budgetbar_with;
    
    NSString        *budgetRepeatType;
    NSDateFormatter         *dateFormatterWithYear;
    NSDateFormatter         *dateFormatter;
    NSDateFormatter         *monthFormatter;
 }

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewB;


@property(nonatomic,strong)IBOutlet UIButton                *setupBtn;
@property(nonatomic,strong)IBOutlet UIView                  *rightBtnContainView;
@property(nonatomic,strong)IBOutlet UIButton				*transferButton;
@property(nonatomic,strong)IBOutlet UIImageView             *bgImage;
@property(nonatomic,strong)IBOutlet UIView                  *bvc_headerView;

@property(nonatomic,strong)IBOutlet UILabel                 *dateTitleLabel;
@property(nonatomic,strong)IBOutlet UILabel					*availLabel;

@property(nonatomic,strong)UISwipeGestureRecognizer         *bvc_leftSwip;
@property(nonatomic,strong)UISwipeGestureRecognizer         *bvc_rightSwip;

@property(nonatomic,strong)IBOutlet UIButton                *bvc_leftBtn;
@property(nonatomic,strong)IBOutlet UIButton                *bvc_rightBtn;
@property(nonatomic,strong)IBOutlet UILabel                 *bvc_allBudgetAmountLabel;

@property(nonatomic,strong)IBOutlet UITableView				*bc_TableView;
@property(nonatomic,strong)NSMutableArray                   *budgetArray;

@property(nonatomic,assign)NSInteger                        deleteIndex;
@property(nonatomic,strong)IBOutlet UIView                  *noRecordView;
@property(nonatomic,assign)NSInteger                        currentBudgetItem;
@property(nonatomic,strong)IBOutlet UILabel                 *norecordString;
@property (weak, nonatomic) IBOutlet UILabel *totalBudget;
@property(nonatomic,strong)UIView                           *todayView;
/////////////////////////
@property(nonatomic,strong)NSDate                           *startDate;
@property(nonatomic,strong)NSDate                           *endDate;
@property(nonatomic,assign)NSInteger                        swipCellIndex;
@property(nonatomic,strong)BudgetListViewController *budgetListViewController;

@property(nonatomic,strong)BudgetSettingViewController  *budgetSettingViewController;

-(void)refleshUI;
-(void)resetStyleWithAds;
-(void)refleshRecurringStyle;

@end

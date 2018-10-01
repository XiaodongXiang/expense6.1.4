//
//  ipad_MainViewController.h
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//540 x 620 

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <iAd/iAd.h>

#import "iPad_OverViewViewController.h"
#import "ipad_AccountViewController.h"
#import "ipad_BillsViewController.h"
#import "ipad_BudgetViewController.h"
#import "ipad_ReportRootViewController.h"
//#import "ipad_ReportModelViewController.h"
#import "ipad_SettingViewController.h"
#import "ipad_SearchViewController.h"
#import "ipad_ReportViewController.h"
#import "NetWorthViewController_iPad.h"
#import "CashFlowViewController_iPad.h"
#import "summaryVC_iPad.h"
#import "CategoryViewController_iPad.h"


typedef enum {
    overView=0,
	accountView = 1,
    budgetView = 2,
    reportView = 3,
	billsView =4,
    summaryView=5,
    cashflowView=6,
    networthView=7,
    categoryView=8,
}ViewModuleType;

@interface ipad_MainViewController : UIViewController<UIPopoverControllerDelegate,ADBannerViewDelegate,SKRequestDelegate>

@property (strong, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchModudleBtn;
@property (strong, nonatomic) IBOutlet UIButton *overViewModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *budgetModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *reportModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *billsModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *networthModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *cashflowModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *summaryModuleBtn;
@property (strong, nonatomic) IBOutlet UIButton *categoryModuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@property (nonatomic, assign)  ViewModuleType currentViewSelect;
@property(nonatomic,strong)IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *sideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (weak, nonatomic) IBOutlet UIButton *syncBtn;
- (IBAction)syncBtnPressed:(id)sender;

@property (strong, nonatomic) iPad_OverViewViewController *overViewController;
@property (strong, nonatomic) ipad_AccountViewController *iAccountViewController;
@property (strong, nonatomic) ipad_BudgetViewController   *iBudgetViewController;
@property (strong, nonatomic) ipad_BillsViewController    *iBillsViewController;
@property (strong, nonatomic) NetWorthViewController_iPad *iNetworthViewController;
@property (strong, nonatomic) CashFlowViewController_iPad *iCashflowViewController;
@property (strong , nonatomic) summaryVC_iPad *iSummaryViewController;
@property (strong , nonatomic) CategoryViewController_iPad
*iCategoryViewController;
@property (strong, nonatomic) ipad_SettingViewController     *iSettingViewController;
@property (strong, nonatomic)ipad_SearchViewController *searchViewController;
//@property (strong, nonatomic)   ipad_ReportModelViewController   *reportViewController;
@property (strong, nonatomic) ipad_ReportRootViewController     *iReportRootViewController;

@property (assign, nonatomic) BOOL           lasViewSelectisBillView;
@property (strong, nonatomic) UIViewController *popViewController;
@property(strong,nonatomic)UIPopoverController *avatatInfoVC;
-(void)budgetModuleBtnAction:(id)sender;
-(void)refleshData;
-(void)refleshUI;
-(void)presentaTransactionViewController:(Transaction *)trans;
-(void)syncAnimationStart;
-(void)syncAnimationStop;
@end

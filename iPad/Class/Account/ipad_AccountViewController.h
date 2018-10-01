//
//  ipad_AccountViewController.h
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*---------------Account 主界面-------------*/
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Accounts.h"
#import "DuplicateTimeViewController.h"
#import "AccountCount.h"
#import "noshadowTableView.h"
#import "SWTableViewCell.h"

//@interface TransactionCount : NSObject {
//	Accounts *ac;
//    Transaction *t;
//    NSDate *dateTime;
//}
//@property (nonatomic, strong) 	Accounts *ac;
//@property (nonatomic, strong) Transaction *t;
//@property (nonatomic, strong) NSDate *dateTime;
//
//
//@end


@class ipad_AccountEditViewController,ipad_TranscactionQuickEditViewController;
@interface ipad_AccountViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIPopoverControllerDelegate,DuplicateTimeViewControllerDelegate,SWTableViewCellDelegate>

//左半部分account list
@property (nonatomic, strong) IBOutlet UIView        *leftTitleView;
@property (nonatomic, strong) NSMutableArray         *accountArray;
@property (nonatomic, strong) IBOutlet UIButton      *editAccountModuleBtn;
@property (nonatomic, strong) IBOutlet UIButton      *addNewAccountBtn;
@property (nonatomic, strong) IBOutlet UIView        *noRecordViewLeft;
@property (nonatomic, assign) NSInteger              indexOfAccount;//左边选中的account
@property (nonatomic, assign) NSInteger indexofCategory;
@property (nonatomic, assign) NSInteger              accountandTransactionDeleteIndex;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;


//right
@property (nonatomic, strong) IBOutlet UIView       *dateRangeSelView;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn1;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn2;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn3;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn4;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn5;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn6;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn7;
@property (nonatomic, strong) IBOutlet UIButton     *dataSelBtn8;
@property (nonatomic, strong) IBOutlet UIButton     *dateDurBtn;
@property (nonatomic, strong) IBOutlet UIButton     *addNewTranscationBtn;
@property (nonatomic, strong) IBOutlet UILabel      *transactionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel      *dateLabel;

@property (nonatomic, strong) IBOutlet UITableView  *rightTableView;

@property (nonatomic, strong) IBOutlet UILabel		*totalCleared;
@property (nonatomic, strong) IBOutlet UILabel		*totalUnCleared;

@property (nonatomic, strong) IBOutlet UIButton     *reconcileBtn;
@property (nonatomic, strong) IBOutlet UIView       *reconcileView;
@property (nonatomic, strong) IBOutlet UIButton     *reconcileonBtn;
@property (nonatomic, strong) IBOutlet UIButton     *hideClearedBtn;
@property (nonatomic, strong) IBOutlet UILabel      *accountsLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *clearedLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *unclearedLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *dateLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *payeeLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *amountLabelText;
@property (nonatomic, strong) IBOutlet UILabel      *balanceLabelText;
@property (weak, nonatomic) IBOutlet UIView *leftBottomView;
@property (weak, nonatomic) IBOutlet UILabel *allAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allAccountAmountLabel;

@property (nonatomic, assign) BOOL                  isShowReconcile;
@property (nonatomic, assign) BOOL                  isShowCleared;
@property (nonatomic, assign) double                accClear;
@property (nonatomic, assign) double                accUnClear ;
@property (nonatomic, strong) NSMutableArray        *transactionArray;
@property (nonatomic, strong) NSMutableArray        *runningBalanceArray;

@property (nonatomic, strong) NSDate                *startDate;
@property (nonatomic, strong) NSDate                *endDate;
@property (nonatomic, strong) NSDate                *duplicateDate;
@property (nonatomic, strong) NSDateFormatter       *outputFormatter;
@property (nonatomic, strong) NSString              *dateRangeString;
@property (nonatomic, assign)NSInteger              swipCellIndex;

@property (nonatomic, assign)BOOL                   tableViewEditState;
@property (nonatomic, strong) IBOutlet UILabel      *accountReminderText;

@property(nonatomic,strong)ipad_AccountEditViewController *iAccountEditViewController;
@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *iTransactionQuickEditViewController;
@property(nonatomic,strong)DuplicateTimeViewController *duplicateDateViewController;

//category View
@property (nonatomic, strong) IBOutlet UIView           *titleContainView;
@property (nonatomic, strong) IBOutlet UIView           *accountAndCategoryContainView;
@property (nonatomic, strong) IBOutlet UIButton         *accountBtn;
@property (nonatomic, strong) IBOutlet UIButton         *categoryBtn;
@property (nonatomic, strong) NSMutableArray            *categoryArray;
@property (nonatomic, strong) IBOutlet UITableView      *categoryTableView;
@property (nonatomic, strong) NSIndexPath               *categoryDeleteIndexPath;
@property (nonatomic, strong) IBOutlet UIImageView      *progressImageView;
@property (nonatomic, strong) IBOutlet  UILabel         *categoryPayeeLabelText;
@property (nonatomic, strong) IBOutlet UILabel          *categoryDateLabelText;
@property (nonatomic, strong) IBOutlet UILabel          *categoryAmountLabelText;
@property (nonatomic, strong) IBOutlet UILabel          *categoryMemoLableText;
@property (nonatomic, strong) IBOutlet UITableView      *categoryTransactionTableView;
@property (nonatomic, strong) IBOutlet UIView           *rightViewContainView;
@property (nonatomic, strong) IBOutlet UIView           *categoryContainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLineWidth;
@property (weak, nonatomic) IBOutlet UIView *coverView;



//method
-(void)refleshUI;
-(void)reFlashTableViewData;
-(void)reFleshTableViewData_withoutReset;
-(void)setDateDurDescByDate;
@end

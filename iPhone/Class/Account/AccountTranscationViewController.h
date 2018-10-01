//
//  AccountTranscationViewController.h
//  PokcetExpense
//
//  Created by Tommy on 2/24/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"
#import "Transaction.h"
#import "DuplicateTimeViewController.h"
#import "SWTableViewCell.h"


@class AccountCount,AccountsViewController,TransactionEditViewController;
@interface AccountTranscationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,DuplicateTimeViewControllerDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outstandingX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceTextX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outstandingTextL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@property (nonatomic,weak) IBOutlet UITableView    *mytableview;
@property (nonatomic,weak) IBOutlet UIView         *detailPanelView;
@property (nonatomic,weak) IBOutlet UILabel        *outStandingLabel;
@property (nonatomic,weak) IBOutlet UILabel        *balanceLabel;
@property (nonatomic,weak) IBOutlet UILabel        *balanceTextLabel;
@property (nonatomic,weak) IBOutlet UILabel        *outstandingTextLabel;
@property (nonatomic,weak) IBOutlet UIButton       *dropBtn;
@property (nonatomic,weak) IBOutlet UIView         *noRecordView;

- (IBAction)hideBtnClick:(id)sender;
- (IBAction)reconcileBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reconcileBtnWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleLineToLeft;




@property (nonatomic,assign) NSInteger   initOrderIndex;
@property (nonatomic,strong) Accounts    *account;
@property (nonatomic,strong) NSIndexPath *swipCellIndex;
@property (nonatomic,assign) BOOL        isShowReconcile;
@property (nonatomic,assign) BOOL        isShowCleared;
@property (nonatomic,strong) NSString    *type;

@property (strong, nonatomic)  UICollectionView *collectionView;



@property (nonatomic,strong) NSDateFormatter        *sectionFormatter;
@property (nonatomic,strong) NSDateFormatter		*outputFormatter;

@property (nonatomic,strong) NSFetchedResultsController     *fetchRequestResultsController;
@property (nonatomic,strong)NSMutableArray                  *transactionArray;
@property (nonatomic,strong)NSMutableArray                  *runningBalanceArray;
@property (nonatomic,strong)NSMutableArray                  *accountArray;
@property (nonatomic,assign)double                          startAmount;
@property (strong, nonatomic) IBOutlet UIButton *reconcileBtn;

@property (strong, nonatomic) IBOutlet UIButton *hiedeBtn;

@property (nonatomic,strong)TransactionEditViewController   *transactionEditViewController;
@property (nonatomic,strong)DuplicateTimeViewController     *duplicateDateViewController;
@property (nonatomic,strong) AccountsViewController         *accountsViewController;

@property(nonatomic,strong)NSDate                           *duplicateDate;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;



-(void)refleshUI;

@end


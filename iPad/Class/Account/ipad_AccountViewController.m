//
//  ipad_AccountViewController.m
//  PocketExpense
//
//  Created by Tommy on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ipad_AccountViewController.h"
#import "ipad_AccountCell.h"
#import "CustomDateRangeViewController.h"
#import "TransactionRule.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_AccountEditViewController.h"
#import "BudgetTransfer.h" 
#import "ipad_TranscactionQuickEditViewController.h"
#import "ClearCusBtn.h"

#import "iPad_Account_TransactionCell.h"
#import "DropboxSyncTableDefine.h"
#import "ipad_SearchRelatedViewController.h"


//category needed
#import "ipad_CategoryEditViewController.h"
#import "ipad_CategoryTransactionCell.h"
#import "AccountCategoryCount.h"
#import "ipad_AccountCategoryCell.h"
#import "newAcountCell.h"
#import <Parse/Parse.h>
#import "ParseDBManager.h"
#import "BHI_Utility.h"

#import "Custom_iPad_Account_TransactionCell.h"

#pragma mark Custom Class Define - CategoryCount


/*actionsheet
 tag == 201 delete recurring transaction
 tag == 202 delete account
 tag == 2	delete category
*/

@interface ipad_AccountViewController ()
{
    newAcountCell *selectedLeftCell;
    NSInteger firstInSel;
}
@end
 
@implementation ipad_AccountViewController
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark ViewController Cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPoint];
    [self initDateRangeMemoryDefine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.iAccountEditViewController = nil;
    self.iTransactionQuickEditViewController = nil;
	[self reFlashTableViewData];
}

-(void)refleshUI
{
    if (self.iAccountEditViewController != nil)
    {
        [self.iAccountEditViewController refleshUI];
    }
    else if (self.iTransactionQuickEditViewController != nil)
    {
        [self.iTransactionQuickEditViewController refleshUI];
    }
    else
    {
        [self reFleshTableViewData_withoutReset];
    }
    [_leftTableView reloadData];
    
}

#pragma mark view didload method
-(void)initPoint
{
    _accountsLabelText.text = NSLocalizedString(@"VC_Accounts", nil);
    _clearedLabelText.text = [NSLocalizedString(@"VC_Cleared", nil) uppercaseString];
    _unclearedLabelText.text= [NSLocalizedString(@"VC_Uncleared", nil)uppercaseString];
    _dateLabelText.text= NSLocalizedString(@"VC_Date", nil);
    _payeeLabelText.text= NSLocalizedString(@"VC_Payee", nil);
    _amountLabelText.text= NSLocalizedString(@"VC_Amount", nil);
    _balanceLabelText.text= NSLocalizedString(@"VC_Balance", nil);
    
    _categoryDateLabelText.text= NSLocalizedString(@"VC_Date", nil);
    _categoryPayeeLabelText.text= NSLocalizedString(@"VC_Payee", nil);
    _categoryAmountLabelText.text= NSLocalizedString(@"VC_Amount", nil);
    _categoryMemoLableText.text= NSLocalizedString(@"VC_Memo", nil);
    
    [_dataSelBtn8 setTitle:NSLocalizedString(@"VC_ipadAllDates", nil) forState:UIControlStateNormal];
    [_dataSelBtn setTitle:NSLocalizedString(@"VC_ThisMonth", nil) forState:UIControlStateNormal];
    [_dataSelBtn1 setTitle:NSLocalizedString(@"VC_LastMonth", nil) forState:UIControlStateNormal];
    [_dataSelBtn2 setTitle:NSLocalizedString(@"VC_ThisQuarter", nil) forState:UIControlStateNormal];
    [_dataSelBtn3 setTitle:NSLocalizedString(@"VC_LastQuarter", nil) forState:UIControlStateNormal];
    [_dataSelBtn4 setTitle:NSLocalizedString(@"VC_ThisYear", nil) forState:UIControlStateNormal];
    [_dataSelBtn5 setTitle:NSLocalizedString(@"VC_LastYear", nil) forState:UIControlStateNormal];
    [_dataSelBtn6 setTitle:NSLocalizedString(@"VC_Last 12 Months", nil) forState:UIControlStateNormal];
    [_dataSelBtn7 setTitle:NSLocalizedString(@"VC_Custom", nil) forState:UIControlStateNormal];
    
    [_reconcileBtn setTitle:NSLocalizedString(@"VC_Reconcile", nil) forState:UIControlStateNormal];
    [_hideClearedBtn setTitle:NSLocalizedString(@"VC_HideCleared", nil) forState:UIControlStateNormal];
    
    [_reconcileonBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:93/255.0 green:199/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateNormal];
    [_hideClearedBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:93/255.0 green:199/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateNormal];
    
    [_reconcileonBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:79/255.0 green:169/255.0 blue:217/255.0 alpha:1]] forState:UIControlStateSelected];
    [_hideClearedBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:79/255.0 green:169/255.0 blue:217/255.0 alpha:1]] forState:UIControlStateSelected];

    
    _reconcileonBtn.layer.cornerRadius=6;
    _reconcileonBtn.layer.masksToBounds=YES;
    _hideClearedBtn.layer.cornerRadius=6;
    _hideClearedBtn.layer.masksToBounds=YES;
    
    
    
    
    [_hideClearedBtn setTitle:NSLocalizedString(@"VC_ShowCleared", nil) forState:UIControlStateSelected];
    [_reconcileonBtn setTitle:NSLocalizedString(@"VC_ReconcileOn", nil) forState:UIControlStateNormal];
    [_reconcileonBtn setTitle:NSLocalizedString(@"VC_ReconcileOff", nil) forState:UIControlStateSelected];


    _accountReminderText.text = NSLocalizedString(@"VC_You need to create at least one account before starting using this app. You can create them by tap the \"Add\" button.", nil);

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_totalCleared  setFont:[appDelegate.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:14]];
    [_totalUnCleared setFont:[appDelegate.epnc getMoneyFont_Avenir_LT_85_Heavy_withSzie:14]];
    
    _dateRangeString=  @"All Dates";
    _indexOfAccount =0;
    _indexofCategory = 0;
    _isShowReconcile=NO;
    _isShowCleared = YES;
    
    if([_dateRangeString isEqualToString:@"Custom"])
    {
        self.startDate = appDelegate.settings.accDRstartDate;
        self.endDate = appDelegate.settings.accDRendDate ;
    }
    else
    {
        self.startDate =[appDelegate.epnc getStartDate:_dateRangeString];
        self.endDate = [appDelegate.epnc getEndDate:_startDate withDateString:_dateRangeString];
    }
    
  	_accountArray = [[NSMutableArray alloc] init];
	_transactionArray =  [[NSMutableArray alloc] init];
    _runningBalanceArray = [[NSMutableArray alloc] init];
	
    
	_outputFormatter = [[NSDateFormatter alloc] init];
 	[_outputFormatter setDateFormat:@"MMM dd, yyyy"];
    _swipCellIndex =-1;
    
    //按钮的事件
    _tableViewEditState  = NO;
    _editAccountModuleBtn.selected = NO;
    [_editAccountModuleBtn addTarget:self action:@selector(editAccountModuleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[_addNewAccountBtn addTarget:self action:@selector(addNewAccountBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[_addNewTranscationBtn addTarget:self action:@selector(addNewTranscationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _middleLineWidth.constant=EXPENSE_SCALE;

    
	[_dateDurBtn addTarget:self action:@selector(dateDurBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dataSelBtn addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn1 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn2 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn3 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn4 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn5 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn6 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn7 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dataSelBtn8 addTarget:self action:@selector(dataRangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //选中时背景
    [_dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn6 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn7 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
    [_dataSelBtn8 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];

    
    //高亮时背景
    [_dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn6 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn7 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];
    [_dataSelBtn8 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted];

    
    [_dataSelBtn setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn1 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn2 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn3 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn4 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn5 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn6 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn7 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_dataSelBtn8 setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateHighlighted|UIControlStateSelected];

    
    //未选中时候的颜色
    [_dataSelBtn setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn1 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn2 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn3 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn4 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn5 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn6 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn7 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
    [_dataSelBtn8 setTitleColor:[UIColor colorWithRed:177.f/255.f green:178.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
   
    
    
    [_dataSelBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn1 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn2 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn3 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn4 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn5 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn6 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn7 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];
    [_dataSelBtn8 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateSelected];

    //dataSelBtn textLabel Fram
    [_dataSelBtn setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn1 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn2 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn3 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn4 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn5 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn6 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    [_dataSelBtn7 setTitleColor:[UIColor colorWithRed:54.f/255.f green:76.f/255.f blue:117.f/255.f alpha:1] forState:UIControlStateHighlighted];
    
    _reconcileView.hidden = YES;
    _reconcileonBtn.selected = NO;
    _hideClearedBtn.selected = NO;
    [_reconcileBtn addTarget:self action:@selector(dropBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_reconcileonBtn addTarget:self action:@selector(reconcileonBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_hideClearedBtn addTarget:self action:@selector(hideClearedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _addNewAccountBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_addNewAccountBtn.titleLabel setMinimumScaleFactor:0];
    _editAccountModuleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_editAccountModuleBtn.titleLabel setMinimumScaleFactor:0];
    _reconcileBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_reconcileBtn.titleLabel setMinimumScaleFactor:0];
    _reconcileonBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_reconcileonBtn.titleLabel setMinimumScaleFactor:0];
    _hideClearedBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_hideClearedBtn.titleLabel setMinimumScaleFactor:0];
    
    
    [_accountBtn addTarget:self action:@selector(accountBtnOrCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_accountBtn setBackgroundImage:[UIImage imageNamed:@"account_choose_left_click"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [_accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];

    
    [_categoryBtn addTarget:self action:@selector(accountBtnOrCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_categoryBtn setBackgroundImage:[UIImage imageNamed:@"account_choose_right_click"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [_categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    _accountBtn.selected = YES;
    _categoryBtn.selected = NO;
    _leftTableView.frame = CGRectMake(0, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height-60);
    _categoryTableView.frame = CGRectMake(_accountAndCategoryContainView.frame.size.width, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height);
    _categoryArray = [[NSMutableArray alloc]init];
    _progressImageView.frame = CGRectMake(0, 44-2-EXPENSE_SCALE, _progressImageView.frame.size.width, _progressImageView.frame.size.height);
    _rightViewContainView.hidden = NO;
    _categoryContainView.hidden = YES;
    firstInSel=0;
    
    //
    _allAccountLabel.text=@"All Accounts";
    
    _dateRangeSelView.layer.cornerRadius=6;
    _dateRangeSelView.layer.masksToBounds=YES;
}

-(void)reSetDateRangeViewBtnStyle
{
    _dataSelBtn.selected = NO;
    _dataSelBtn1.selected = NO;
    _dataSelBtn2.selected = NO;
    _dataSelBtn3.selected = NO;
    _dataSelBtn4.selected = NO;
    _dataSelBtn5.selected = NO;
    _dataSelBtn6.selected = NO;
    _dataSelBtn7.selected = NO;
    _dataSelBtn8.selected = NO;
    
    [_dataSelBtn.titleLabel setHighlighted:FALSE];
    [_dataSelBtn1.titleLabel setHighlighted:FALSE];
    [_dataSelBtn2.titleLabel setHighlighted:FALSE];
    [_dataSelBtn3.titleLabel setHighlighted:FALSE];
    [_dataSelBtn4.titleLabel setHighlighted:FALSE];
    [_dataSelBtn5.titleLabel setHighlighted:FALSE];
    [_dataSelBtn6.titleLabel setHighlighted:FALSE];
    [_dataSelBtn7.titleLabel setHighlighted:FALSE];
    [_dataSelBtn8.titleLabel setHighlighted:FALSE];
}

-(void)initDateRangeMemoryDefine
{
    [self reSetDateRangeViewBtnStyle];
    if([_dateRangeString isEqualToString:@"This Month"])
    {
        _dataSelBtn.selected = YES;
        [_dataSelBtn.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"Last Month"])
    {
        _dataSelBtn1.selected = YES;
        [_dataSelBtn1.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"This Quarter"])
    {
        _dataSelBtn2.selected = YES;
        [_dataSelBtn2.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"Last Quarter"])
    {
        _dataSelBtn3.selected = YES;
        [_dataSelBtn3.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"This Year"])
    {
        _dataSelBtn4.selected = YES;
        [_dataSelBtn4.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"Last Year"])
    {
        _dataSelBtn5.selected = YES;
        [_dataSelBtn5.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"Last 12 Months"])
    {
        _dataSelBtn6.selected = YES;
        [_dataSelBtn6.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"Custom"])
    {
        _dataSelBtn7.selected = YES;
        [_dataSelBtn7.titleLabel setHighlighted:YES];
        
    }
    else if([_dateRangeString isEqualToString:@"All Dates"])
    {
        _dataSelBtn8.selected = YES;
        [_dataSelBtn8.titleLabel setHighlighted:YES];
    }
    
    else
    {
        _dateRangeString =@"Last 12 Months";
        _dataSelBtn6.selected = YES;
        [_dataSelBtn6.titleLabel setHighlighted:YES];
        
    }
    
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;
}

#pragma mark  Data Source
-(void)reFlashTableViewData
{
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;

	[self reFleshTableViewData_withoutReset];
}

-(void)reFleshTableViewData_withoutReset
{
    if (_accountBtn.selected)
    {
        _swipCellIndex = -1;
        [self getDataSouce];
        //当选中最后一个account，然后删除一个account之后，需要更新选中的account的标识，不然刷新的时候肯定会失败。因为超出了数组的最大值
        if (_indexOfAccount > [_accountArray count]-1) {
            _indexOfAccount = [_accountArray count]-1;
        }
        [self getTranscationDateSouce];
        //设置右边的标题与时间
        [self setDateLabelText];
        
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
        if ([_accountArray count]>0)
        {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_indexOfAccount inSection:0];
            [_leftTableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
        }
        _dateRangeSelView.hidden = YES;
        _coverView.hidden=YES;

        _reconcileView.hidden = YES;

    }
    else
    {
        [self getCategoryDataSource];
        //设置category 模块
        if ([_categoryArray count]>0)
        {
            if (_indexofCategory > [_categoryArray count]-1)
            {
                    _indexofCategory= [NSIndexPath indexPathForRow:[_categoryArray count]-1 inSection:0];
            }
//            [_categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexofCategory inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionTop];
        }

        //设置右边的标题与时间
        [self setDateLabelText];
        
        [self getCategoryTransactionDataSource];
    }

}

- (void)getDataSouce
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

	[_accountArray removeAllObjects];
 	NSError *error =nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"accName" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor2, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
	
 	NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
 	NSMutableArray *tmpAccountArray = [[NSMutableArray alloc] initWithArray:objects];
    
    double tmpDefaultAmount=0.00;
    double totalSpend = 0;
	double totalIncome =0;
    
	for (int i=0; i<[tmpAccountArray count]; i++)
	{
 		double oneSpent = 0;
		double oneIncome = 0;
		double onetotal =0;
        
		Accounts *tmpAccount = (Accounts *)[tmpAccountArray objectAtIndex:i];
		
		onetotal = [tmpAccount.amount doubleValue];
        totalIncome+=[tmpAccount.amount doubleValue];

        //获取旗下的所有的trans,判断是不是有子 trans
		NSMutableArray *tmpArrays = [[NSMutableArray alloc] initWithArray:[tmpAccount.expenseTransactions allObjects]];
		
		for (int j=0; j<[tmpArrays count];j++)
		{
			Transaction *transactions = (Transaction *)[tmpArrays objectAtIndex:j];
            if ([transactions.state isEqualToString:@"1"]) {
                if(transactions.parTransaction == nil)
                {
//                    if (transactions.incomeAccount && transactions.expenseAccount && [transactions.category.categoryType isEqualToString:@"INCOME"]) {
//
//                    }
                    
                    if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
                        if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                            if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
//                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                                
                            }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
//                                amount += [transactions.amount doubleValue];
                                
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }
                            
                        }else{
                            if (transactions.incomeAccount == nil && transactions.expenseAccount) {
//                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                            }else{
//                                amount += [transactions.amount doubleValue];
                                
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }
                        }
                        
                    }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
                        if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                            if (transactions.incomeAccount == tmpAccount) {
//                                amount += [transactions.amount doubleValue];
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }else if (transactions.expenseAccount == tmpAccount){
//                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                            }
                        }else{
//                            amount -= [transactions.amount doubleValue];
                            onetotal -= [transactions.amount doubleValue];
                            oneSpent += [transactions.amount doubleValue];
                            totalSpend+=[transactions.amount doubleValue];
                        }
                    }else{
                        if (transactions.incomeAccount == tmpAccount) {
//                            amount += [transactions.amount doubleValue];
                            onetotal += [transactions.amount doubleValue];
                            oneIncome += [transactions.amount doubleValue];
                            totalIncome+=[transactions.amount doubleValue];
                        }else if (transactions.expenseAccount == tmpAccount){
//                            amount -= [transactions.amount doubleValue];
                            onetotal -= [transactions.amount doubleValue];
                            oneSpent += [transactions.amount doubleValue];
                            totalSpend+=[transactions.amount doubleValue];
                        }
                    }

                    
//                    onetotal -= [transactions.amount doubleValue];
//                    oneSpent += [transactions.amount doubleValue];
//                    totalSpend+=[transactions.amount doubleValue];
                    
                }
            }
			
		}
		
		NSMutableArray *tmpArrays1 = [[NSMutableArray alloc] initWithArray:[tmpAccount.incomeTransactions allObjects]];
		for (int j=0; j<[tmpArrays1 count];j++)
		{
            Transaction *transactions = (Transaction *)[tmpArrays1 objectAtIndex:j];
            
            if ([transactions.state isEqualToString:@"1"]) {
                if(transactions.parTransaction == nil)
                {
//                    onetotal += [transactions.amount doubleValue];
//                    oneIncome += [transactions.amount doubleValue];
//                    totalIncome+=[transactions.amount doubleValue];
                    if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
                        if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                            if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                                //                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                                
                            }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
                                //                                amount += [transactions.amount doubleValue];
                                
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }
                            
                        }else{
                            if (transactions.incomeAccount == nil && transactions.expenseAccount) {
                                //                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                            }else{
                                //                                amount += [transactions.amount doubleValue];
                                
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }
                        }
                        
                    }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
                        if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                            if (transactions.incomeAccount == tmpAccount) {
                                //                                amount += [transactions.amount doubleValue];
                                onetotal += [transactions.amount doubleValue];
                                oneIncome += [transactions.amount doubleValue];
                                totalIncome+=[transactions.amount doubleValue];
                            }else if (transactions.expenseAccount == tmpAccount){
                                //                                amount -= [transactions.amount doubleValue];
                                onetotal -= [transactions.amount doubleValue];
                                oneSpent += [transactions.amount doubleValue];
                                totalSpend+=[transactions.amount doubleValue];
                            }
                        }else{
                            //                            amount -= [transactions.amount doubleValue];
                            onetotal -= [transactions.amount doubleValue];
                            oneSpent += [transactions.amount doubleValue];
                            totalSpend+=[transactions.amount doubleValue];
                        }
                    }else{
                        if (transactions.incomeAccount == tmpAccount) {
                            //                            amount += [transactions.amount doubleValue];
                            onetotal += [transactions.amount doubleValue];
                            oneIncome += [transactions.amount doubleValue];
                            totalIncome+=[transactions.amount doubleValue];
                        }else if (transactions.expenseAccount == tmpAccount){
                            //                            amount -= [transactions.amount doubleValue];
                            onetotal -= [transactions.amount doubleValue];
                            oneSpent += [transactions.amount doubleValue];
                            totalSpend+=[transactions.amount doubleValue];
                        }
                    }
                }
            }
		}
		
        AccountCount *ac = [[AccountCount alloc] init];
		ac.accountsItem = tmpAccount ;
		ac.totalExpense  = oneSpent;
        ac.totalIncome = oneIncome;
        ac.totalBalance = onetotal;
        
        //新加
        tmpDefaultAmount += [tmpAccount.amount doubleValue];
        ac.defaultAmount = [tmpAccount.amount doubleValue];
        
 		[_accountArray addObject:ac];
        
  	}
	
//    if([_accountArray count]>1)
//    {
//        AccountCount *ac = [[AccountCount alloc] init];
//		ac.accountsItem = nil ;
//		ac.totalExpense  = totalSpend;
//        ac.totalIncome = totalIncome;
//        ac.totalBalance = totalIncome - totalSpend;
//
//        
//        //新加
//        ac.defaultAmount = tmpDefaultAmount;
//        
// 		[_accountArray insertObject:ac atIndex:0];
//        
//    }
    
	if([_accountArray count] == 0)
	{
		_noRecordViewLeft.hidden = NO;
        _addNewAccountBtn.hidden = NO;
		_editAccountModuleBtn.hidden = YES;
		_editAccountModuleBtn.selected = NO;
//		[editAccountModuleBtn setImage:[UIImage imageNamed:@"ipad_btn_edit.png"] forState:UIControlStateNormal];
		[self.leftTableView setEditing:NO animated:YES];
        
	}
	else {
		_noRecordViewLeft.hidden = YES;
		_editAccountModuleBtn.hidden = NO;
		_dateDurBtn.hidden = NO;
	}
    _allAccountAmountLabel.text=[[appDelegate epnc]formatterString:totalIncome-totalSpend];
    _allAccountAmountLabel.font=[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:17];
    if (totalIncome>totalSpend)
    {
        _allAccountAmountLabel.textColor=[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1];
    }
    else
    {
        _allAccountAmountLabel.textColor=[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1];
    }
}

-(void)getCategoryDataSource
{
    
    //get account array
    [_categoryArray removeAllObjects];
    
    NSError *error = nil;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *sub = [[NSDictionary alloc]init];
    NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchParentCategoryAll" substitutionVariables:sub];
    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    BOOL hasSequence = NO;
    for (int i=0; i<[objects count]; i++)
    {
        Category *oneCategory = [objects objectAtIndex:i];
        if (oneCategory.recordIndex != nil && [oneCategory.recordIndex integerValue]>0)
        {
            hasSequence = YES;
            break;
        }
    }
    
    for (int i=0; i<[objects count]; i++)
    {
        Category *oneCategory = [objects objectAtIndex:i];
        
        NSMutableArray *selectedTimeTransaction = [[NSMutableArray alloc]init];
        
        for (int k=0; k<[[oneCategory.transactions allObjects] count]; k++)
        {
            Transaction *oneTrans = [[oneCategory.transactions allObjects]objectAtIndex:k];
            if ([appDelegate.epnc dateCompare:oneTrans.dateTime withDate:self.startDate]>=0 && [appDelegate.epnc dateCompare:oneTrans.dateTime withDate:self.endDate]<=0)
            {
                [selectedTimeTransaction addObject:oneTrans];
            }
        }
        AccountCategoryCount *accountCC = [[AccountCategoryCount alloc]initWithCategory:oneCategory num:[selectedTimeTransaction count]];
        [_categoryArray addObject:accountCC];
    }
    NSSortDescriptor *sort=nil;
    
    if (hasSequence)
    {
        sort =[[NSSortDescriptor alloc]initWithKey:@"categoryItem.recordIndex" ascending:YES];
    }
    else
        sort = [[NSSortDescriptor alloc]initWithKey:@"transNumber" ascending:NO];
    
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc]initWithKey:@"categoryItem.categoryName" ascending:YES];

    NSArray *sorts = [[NSArray alloc]initWithObjects:sort,sort2, nil];
    [_categoryArray sortUsingDescriptors:sorts];
    [_categoryTableView reloadData];

}

//获取选中账户下的 transactions
- (void)getTranscationDateSouce
{
	[self.transactionArray removeAllObjects];
    if([_accountArray count] == 0)return;
    
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
 	NSError * error=nil;
    
    _accClear =0;
    _accUnClear=0;
    
    if ([_accountArray count]>0)
    {
        AccountCount *ac = [_accountArray objectAtIndex:_indexOfAccount ];
        NSMutableArray *tmpTransaction = [[NSMutableArray alloc] init];
        
        if(ac.accountsItem == nil)
        {
            NSDictionary *subs =nil;
            NSString *fetchName=@"";
            
            
            subs = [NSDictionary dictionaryWithObjectsAndKeys: _startDate,@"startDate",_endDate,@"endDate",[NSNull null],@"EMPTY", nil];
            fetchName =@"iPad_fetchTransactionByDate";
            
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            //获取一个临时的交易数据
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [tmpTransaction setArray:objects];

        }
        //具体某个account
        else {
            Accounts *accounts = ac.accountsItem;
            
            NSDictionary *subs=nil ;
            NSString *fetchName =@"";
            
            subs = [NSDictionary dictionaryWithObjectsAndKeys:accounts,@"incomeAccount",accounts,@"expenseAccount", _startDate,@"startDate",_endDate,@"endDate",[NSNull null],@"EMPTY", nil];
            fetchName =@"iPad_fetchTranscationByAccountWithDate";
            
            NSFetchRequest *fetchRequest = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:fetchName substitutionVariables:subs];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [tmpTransaction setArray:objects];

            
        }
        //当是All Account的时候，计算所有Account的金额
        double lastAmount=ac.defaultAmount;
        
        //用临时的 transaction(只是交易 transaction),创建TransactionCount 类型的交易数据，然后放到真正的保存交易的数组中
        for (long i=[tmpTransaction count]-1; i>=0; i--)
        {
            double currentAmount=0;
            
            Transaction *transactions = [tmpTransaction objectAtIndex:i];
            
            
            if ([transactions.transactionType isEqualToString:@"income"] || ((transactions.expenseAccount == nil && transactions.incomeAccount != nil)&&[transactions.category.categoryType isEqualToString:@"INCOME"])) {
                if (transactions.incomeAccount && transactions.expenseAccount && transactions.category) {
                    if ([transactions.category.categoryType isEqualToString:@"EXPENSE"]) {
                        if([transactions.isClear boolValue])
                        {
                            _accClear -=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear +=[transactions.amount doubleValue];
                            
                        }
                        currentAmount = 0-[transactions.amount doubleValue];
                        
//                        amount -= [transactions.amount doubleValue];
                    }else if([transactions.category.categoryType isEqualToString:@"INCOME"]){
//                        amount += [transactions.amount doubleValue];
                        if([transactions.isClear boolValue])
                        {
                            _accClear+=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear -= [transactions.amount doubleValue];
                            
                        }
                        currentAmount = [transactions.amount doubleValue];
                    }
                }else{
                    if (transactions.incomeAccount == nil && transactions.expenseAccount) {
//                        amount -= [transactions.amount doubleValue];
                        if([transactions.isClear boolValue])
                        {
                            _accClear -=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear +=[transactions.amount doubleValue];
                            
                        }
                        currentAmount = 0-[transactions.amount doubleValue];
                        
                    }else{
//                        amount += [transactions.amount doubleValue];
                        if([transactions.isClear boolValue])
                        {
                            _accClear+=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear -= [transactions.amount doubleValue];
                            
                        }
                        currentAmount = [transactions.amount doubleValue];
                    }
                }
            }else if([transactions.transactionType isEqualToString:@"expense"] || ((transactions.expenseAccount != nil && transactions.incomeAccount == nil)&&[transactions.category.categoryType isEqualToString:@"EXPENSE"])){
                if (transactions.category == nil && transactions.incomeAccount && transactions.expenseAccount) {
                    if (transactions.incomeAccount == ac.accountsItem) {
//                        amount += [transactions.amount doubleValue];
                        if([transactions.isClear boolValue])
                        {
                            _accClear+=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear -= [transactions.amount doubleValue];
                            
                        }
                        currentAmount = [transactions.amount doubleValue];
                    }else if (transactions.expenseAccount == ac.accountsItem){
//                        amount -= [transactions.amount doubleValue];
                        if([transactions.isClear boolValue])
                        {
                            _accClear -=[transactions.amount doubleValue];
                        }
                        else
                        {
                            _accUnClear +=[transactions.amount doubleValue];
                            
                        }
                        currentAmount = 0-[transactions.amount doubleValue];
                        
                    }
                }else{
//                    amount -= [transactions.amount doubleValue];
                    if([transactions.isClear boolValue])
                    {
                        _accClear -=[transactions.amount doubleValue];
                    }
                    else
                    {
                        _accUnClear +=[transactions.amount doubleValue];
                        
                    }
                    currentAmount = 0-[transactions.amount doubleValue];
                    
                }
            }else{
                if (transactions.incomeAccount == ac.accountsItem) {
//                    amount += [transactions.amount doubleValue];
                    if([transactions.isClear boolValue])
                    {
                        _accClear+=[transactions.amount doubleValue];
                    }
                    else
                    {
                        _accUnClear -= [transactions.amount doubleValue];
                        
                    }
                    currentAmount = [transactions.amount doubleValue];
                }else if (transactions.expenseAccount == ac.accountsItem){
//                    amount -= [transactions.amount doubleValue];
                    if([transactions.isClear boolValue])
                    {
                        _accClear -=[transactions.amount doubleValue];
                    }
                    else
                    {
                        _accUnClear +=[transactions.amount doubleValue];
                        
                    }
                    currentAmount = 0-[transactions.amount doubleValue];
                    
                }
            }
            
            
//            if([transactions.category.categoryType isEqualToString:@"EXPENSE"]|| [[transactions.childTransactions allObjects]count]>0)
//            {
//                if([transactions.isClear boolValue])
//                {
//                    _accClear -=[transactions.amount doubleValue];
//                }
//                else
//                {
//                    _accUnClear +=[transactions.amount doubleValue];
//        
//                }
//                currentAmount = 0-[transactions.amount doubleValue];
//                
//            }
//            else if([transactions.category.categoryType isEqualToString:@"INCOME"])
//            {
//                if([transactions.isClear boolValue])
//                {
//                    _accClear+=[transactions.amount doubleValue];
//                }
//                else
//                {
//                    _accUnClear -= [transactions.amount doubleValue];
//                    
//                }
//                currentAmount = [transactions.amount doubleValue];
//                
//            }
//            else
//            {
//                if(transactions.expenseAccount == ac.accountsItem)
//                {
//                    if([transactions.isClear boolValue])
//                    {
//                        _accClear -=[transactions.amount doubleValue];
//                    }
//                    else
//                    {
//                        _accUnClear +=[transactions.amount doubleValue];
//                        
//                    }
//                    
//                    currentAmount = 0-[transactions.amount doubleValue];
//                    
//                }
//                else    if(transactions.incomeAccount == ac.accountsItem)
//                {
//                    if([transactions.isClear boolValue])
//                    {
//                        _accClear+=fabs([transactions.amount doubleValue]);
//                    }
//                    else
//                    {
//                        
//                        _accUnClear -=fabs([transactions.amount doubleValue]);
//                        
//                    }
//                    currentAmount = fabs([transactions.amount doubleValue]);
//                }
//            }

            
            if (_isShowCleared)
            {
                [_transactionArray insertObject:transactions atIndex:0];
                [_runningBalanceArray insertObject:[NSNumber numberWithDouble:lastAmount +currentAmount] atIndex:0];
            }
            else if (!_isShowCleared && ![transactions.isClear boolValue])
            {
                [_transactionArray insertObject:transactions atIndex:0];
                [_runningBalanceArray insertObject:[NSNumber numberWithDouble:lastAmount +currentAmount] atIndex:0];
            }
            
            lastAmount =lastAmount + currentAmount;
            
        }



            
    }

    self.totalCleared.text = [appDelegate.epnc formatterString:_accClear];
    self.totalUnCleared.text = [appDelegate.epnc formatterString:_accUnClear];
}

-(void)getCategoryTransactionDataSource
{
    [_transactionArray removeAllObjects];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    AccountCategoryCount *oneCategoryCount;
    //crashlytics上显示有一个数组越界，可能是同步引起的。概率很低。
    if ([_categoryArray count]>= _indexofCategory)
    {
        oneCategoryCount = (AccountCategoryCount *)[_categoryArray objectAtIndex:_indexofCategory];
    }
    else
        return;
    
    NSFetchRequest *fetchTrans;
    if (!self.startDate && !self.endDate)
    {
        NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:oneCategoryCount.categoryItem,@"iCategory",nil];
        fetchTrans = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchTransactionbyCategory" substitutionVariables:sub];
 
    }
    else
    {
        NSDictionary *sub = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"startDate",self.endDate,@"endDate",oneCategoryCount.categoryItem,@"iCategory",nil];
        
        fetchTrans = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchBudgetTrsaction" substitutionVariables:sub];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES ];
    NSMutableArray *sorts = [[NSMutableArray alloc] initWithObjects:&sort count:1];
    
    fetchTrans.sortDescriptors = sorts;
    
    NSError *error = nil;
    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchTrans error:&error];
    if ([objects count]>0)
    {
        [_transactionArray setArray:objects];
    }
    
    
    
    
    
    
    //2.获取该父category底下所有的子category
    NSString *parentCatgoryString = [NSString stringWithFormat:@"%@:",oneCategoryCount.categoryItem.categoryName];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:parentCatgoryString,@"CATEGORYNAME",oneCategoryCount.categoryItem.categoryType,@"CATEGORYTYPE",nil];
    NSFetchRequest *fetchChildCategory = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:@"fetchChildCategoryByName" substitutionVariables:dic];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES ];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchChildCategory setSortDescriptors:sortDescriptors];
    NSArray *objects1 = [appDelegate.managedObjectContext executeFetchRequest:fetchChildCategory error:&error];
    NSMutableArray *tmpChildCategoryArray  = [[NSMutableArray alloc] initWithArray:objects1];
    
    for (int i=0; i<[tmpChildCategoryArray count]; i++)
    {
        Category *oneC = [tmpChildCategoryArray objectAtIndex:i];
        if ([oneC.transactions count]>0)
        {
            PiChartViewItem *oneCategoryItem  = [[PiChartViewItem alloc] initWithName:oneC.categoryName==nil? @"Not Sure":oneC.categoryName color:[UIColor clearColor]  data:0];
            oneCategoryItem.category = oneC;
            
            
            for (int j = 0;j<[[oneC.transactions allObjects] count];j++)
            {
                Transaction *t = [[oneC.transactions allObjects] objectAtIndex:j];
                if([t.state isEqualToString:@"1"])
                    [_transactionArray addObject:t];
            }
            
//            if ([oneCategoryItem.transactionArray count]>0)
//                [_categoryArray addObject:oneCategoryItem];
            
        }
        
    }

    
    
    [_categoryTransactionTableView reloadData];
    
                         
}

-(void)setDateDurDescByDate
{
    
//    if([dateRangeString isEqualToString:@"All Dates"])
//    {
//        dateDurDesc.text = @"";
//    }
//    else
//    {
//        NSDateFormatter *tmpFmt = [[NSDateFormatter alloc] init];
//        [tmpFmt setDateStyle:NSDateFormatterLongStyle];
//        [tmpFmt setDateFormat:@"MMM dd, yyyy"];
//        dateDurDesc.text =[NSString stringWithFormat:@"%@ - %@",[tmpFmt stringFromDate:self.startDate],[tmpFmt stringFromDate:self.endDate]];
//        [tmpFmt release];
//    }
    
}

-(void)setDateLabelText
{
    
    if(_accountBtn.selected)
    {
        if ([_accountArray count]>0)
        {
            AccountCount *ac = [_accountArray objectAtIndex:_indexOfAccount ];
            if (ac.accountsItem == nil || [_accountArray count]==1)
            {
                _transactionTitleLabel.text = NSLocalizedString(@"VC_AllTransactions", nil);
            }
            else
                _transactionTitleLabel.text = ac.accountsItem.accName;
        }
        else
        {
            _transactionTitleLabel.text = NSLocalizedString(@"VC_AllTransactions", nil);
        }
    }
    else
    {
        if ([_categoryArray count]>0)
        {
            AccountCategoryCount *accountCC = [_categoryArray objectAtIndex:_indexofCategory];
                _transactionTitleLabel.text = accountCC.categoryItem.categoryName;
        }
        else
        {
            _transactionTitleLabel.text = @"";
        }
    }
   
    
    //设置date
    if ([_dateRangeString isEqualToString:@"All Dates"]) {
        _dateLabel.text = @"";
        _transactionTitleLabel.frame = CGRectMake(_transactionTitleLabel.frame.origin.x, 0, _transactionTitleLabel.frame.size.width, 44);
    }
    else
    {
        _dateLabel.text =[NSString stringWithFormat:@"%@ - %@",[_outputFormatter stringFromDate:self.startDate],[_outputFormatter stringFromDate:self.endDate]];
        _transactionTitleLabel.frame = CGRectMake(_transactionTitleLabel.frame.origin.x, 0, _transactionTitleLabel.frame.size.width, 30);


    }

}


#pragma mark Btn Action
-(void)changeRangeBtnImageNomal:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateSelected];
}
-(void)dataRangeBtnAction:(UIButton *)sender
{
//    [sender setBackgroundImage:[UIImage imageNamed:@"ipad_pop_cell_140_36_sel.png"] forState:UIControlStateNormal];

    
    
//     dateRangeString = [[(UIButton *)sender titleLabel] text];
    if (sender.tag==8)
    {
        _dateRangeString = @"All Dates";
    }
    else if (sender.tag==0)
    {
        _dateRangeString = @"This Month";

    }
    else if (sender.tag==1)
    {
        _dateRangeString = @"Last Month";
        
    }
    else if (sender.tag==2)
    {
        _dateRangeString = @"This Quarter";
        
    }
    else if (sender.tag==3)
    {
        _dateRangeString = @"Last Quarter";
        
    }
    else if (sender.tag==4)
    {
        _dateRangeString = @"This Year";
        
    }
    else if (sender.tag==5)
    {
        _dateRangeString = @"Last Year";
        
    }
    else if (sender.tag==6)
    {
        _dateRangeString = @"Last 12 Months";
        
    }
    else if (sender.tag==7)
    {
        _dateRangeString = @"Custom";
        
    }
    
    [self reSetDateRangeViewBtnStyle];
    [(UIButton *)sender setSelected:YES];
    [[(UIButton *)sender titleLabel] setHighlighted:YES];

     PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(![_dateRangeString isEqualToString:@"Custom"])
    {
        self.startDate =[appDelegate.epnc getStartDate:_dateRangeString];
        self.endDate = [appDelegate.epnc getEndDate:_startDate withDateString:_dateRangeString];
        [self reFlashTableViewData];
        [self setDateLabelText];
        appDelegate.settings.accDRstring = _dateRangeString;
        appDelegate.settings.accDRstartDate = self.startDate;
        appDelegate.settings.accDRendDate = self.endDate;
        NSError *errors =nil;
        if(![appDelegate.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        }
      
    }
    else
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.pvt = dateRangePopup;
        CustomDateRangeViewController *customDateRangeViewController =[[CustomDateRangeViewController alloc] initWithNibName:@"CustomDateRangeViewController" bundle:nil];
	 	customDateRangeViewController.moduleString = @"ACCOUNT";
		customDateRangeViewController.iAccountViewController = self;
      	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customDateRangeViewController];
        appDelegate.AddPopoverController= [[UIPopoverController alloc] initWithContentViewController:navigationController] ;
        appDelegate.AddPopoverController.popoverContentSize = CGSizeMake(320.0,360.0);
        appDelegate.AddPopoverController.delegate = self;
        [appDelegate.AddPopoverController presentPopoverFromRect:_dateDurBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;



}

-(void)dateDurBtnAction:(id)sender
{
    _dateRangeSelView.hidden = !_dateRangeSelView.hidden;
    _coverView.hidden=!_coverView.hidden;
}

-(void)dropBtnPressed:(id)sender{
    _dateRangeSelView.hidden = YES;
    _reconcileView.hidden = !_reconcileView.hidden;
    _coverView.hidden=YES;

}

#pragma mark ------account tableview btn action
-(void)editAccountModuleBtnAction:(id)sender
{
   
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;

	_editAccountModuleBtn.selected = !_editAccountModuleBtn.selected;
    

    UIButton *editBtn = (UIButton *)sender;
	if(_editAccountModuleBtn.selected)
	{
        [editBtn setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        _addNewAccountBtn.hidden=NO;
        
        _tableViewEditState = YES;
        
   
        [_categoryTableView setEditing:YES animated:YES];
        [_categoryTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
        [_leftTableView setEditing:YES animated:YES];
        [_leftTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
        
	}
	else
    {
        [editBtn setImage:[UIImage imageNamed:@"navigation_edit.png"] forState:UIControlStateNormal];
        [editBtn setTitle:@"" forState:UIControlStateNormal];
        _addNewAccountBtn.hidden=YES;

        _tableViewEditState = NO;

        [_leftTableView setEditing:NO animated:YES];
        [_categoryTableView setEditing:NO animated:YES];

        if (_indexOfAccount > [_accountArray count]-1)
        {
            _indexOfAccount = [_accountArray count]-1;
        }
        if(_indexofCategory > [_categoryArray count]-1)
            _indexofCategory = [_categoryArray count]-1;
        
        if(_indexOfAccount>=0&&_indexOfAccount<[_accountArray count])
        {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexOfAccount inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if(_indexofCategory>=0 && _indexofCategory < [_categoryArray count])
        {
            [_categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexofCategory inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }

	}
    
    
}

-(void)setSelectedAccountBg
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexOfAccount inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionTop];

}

-(void)addNewAccountBtnAction:(id)sender
{
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;
    _reconcileView.hidden = YES;

    if (_accountBtn.selected)
    {
        _iAccountEditViewController =[[ipad_AccountEditViewController alloc] initWithNibName:@"ipad_AccountEditViewController" bundle:nil];
        self.iAccountEditViewController.typeOftodo = @"IPAD_ADD";
        self.iAccountEditViewController.iAccountViewController = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iAccountEditViewController];
        AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        appDelegate1.mainViewController.popViewController = navigationController;
        [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
        //    navigationController.view.superview.frame = CGRectMake(
        //                                                           272,
        //                                                           0,
        //                                                           480,
        //                                                           490
        //                                                           );
        
        navigationController.view.superview.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | 
        UIViewAutoresizingFlexibleBottomMargin;    

    }
    else
    {
        ipad_CategoryEditViewController *categoryEditViewController = [[ipad_CategoryEditViewController alloc]initWithNibName:@"ipad_CategoryEditViewController" bundle:nil];
        categoryEditViewController.editModule = @"IPAD_ACCOUNT_ADD";
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:categoryEditViewController];
        
        AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        appDelegate1.mainViewController.popViewController = navigationController;
        [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
    }
	
}

-(void)cellDeleteBtnPressed_account:(UIButton *)sender{
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:sender.tag];
    Accounts *tmpAccount = [ac accountsItem];
    _accountandTransactionDeleteIndex =sender.tag;
    
//    NSString *msg  = [NSString  stringWithFormat:
//                      @"Delete %@ will cause to also delete its transactions. Are you sure want to delete it?"
//                      , tmpAccount.accName];
    
    NSMutableString *string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete its transactions. Are you sure want to delete it?", nil)];
    
    NSString *searchString = @"%@";
    //range是这个字符串的位置与长度
    NSRange range = [string1 rangeOfString:searchString];
    [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpAccount.accName];
    NSString *msg = string1;
    
    UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                 initWithTitle:msg
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                 destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil)
                                 otherButtonTitles:nil,
                                 nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    actionSheet.tag = 202;
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    UITableViewCell *selectedCell = [_leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    CGPoint point1 = [_leftTableView convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
    [actionSheet showFromRect:CGRectMake(point1.x,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
    appDelegate.appActionSheet = actionSheet;
    
}

-(void)cellDetailBtnPressed_account:(UIButton *)sender{
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:sender.tag];
    _indexOfAccount = sender.tag;
    
	Accounts *tmpAccount = ac.accountsItem;
 	
	self.iAccountEditViewController =[[ipad_AccountEditViewController alloc] initWithNibName:@"ipad_AccountEditViewController" bundle:nil];
	
	self.iAccountEditViewController.hidesBottomBarWhenPushed = YES;
	
	self.iAccountEditViewController.accounts = tmpAccount;
	self.iAccountEditViewController.typeOftodo = @"IPAD_EDIT";
	self.iAccountEditViewController.iAccountViewController = self;
	
 	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iAccountEditViewController];
	AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
 	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
 	appDelegate1.mainViewController.popViewController = navigationController;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
	navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
}

#pragma mark ------transaction tableview btn action


-(void)addNewTranscationBtnAction:(id)sender
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];

    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;
    //1.creat the present viewcontroller
	self.iTransactionQuickEditViewController = [[ipad_TranscactionQuickEditViewController alloc] initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    //2.configure
    self.iTransactionQuickEditViewController.typeoftodo = @"IPAD_ADD";
	self.iTransactionQuickEditViewController.iAccountViewController = self;
    
    if ([_accountArray count]>0)
    {
        Accounts *accounts = [[_accountArray objectAtIndex:_indexOfAccount ] accountsItem];
        
        self.iTransactionQuickEditViewController.accounts = accounts;
        self.iTransactionQuickEditViewController.fromAccounts = accounts;
    }
    
    //2.1
    if ([_categoryArray count]>0 && _indexofCategory<=[_categoryArray count])
    {
        AccountCategoryCount *accountCC = [_categoryArray objectAtIndex:_indexofCategory];
        self.iTransactionQuickEditViewController.categories = accountCC.categoryItem;
    }
	
	//3.Create the navigation controller and present it modally.
 	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iTransactionQuickEditViewController];

    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;

//    [self presentViewController:navigationController animated:YES completion:nil];

    //We should call presentViewController in that view controller which is part of rootViewController.
    [appDelegate_iPad.mainViewController presentViewController:navigationController animated:YES completion:nil];
}



-(void)reconcileonBtnPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isShowReconcile = sender.selected;
    
    _reconcileView.hidden = YES;
    [_rightTableView reloadData];
    
    if(_isShowReconcile)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_REC"];
    }

}

-(void)hideClearedBtnPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isShowCleared = !sender.selected;
    
    _reconcileView.hidden = YES;

    [self getTranscationDateSouce];
    [_rightTableView reloadData];
    
    if (!_isShowCleared)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"08_ACC_HDCL"];
    }
}

-(void)cellSearchBtnPressed:(NSIndexPath *)indexPath
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    ipad_SearchRelatedViewController *searchRelatedViewController= [[ipad_SearchRelatedViewController alloc]initWithNibName:@"ipad_SearchRelatedViewController" bundle:nil];
//    TransactionCount *tc =(TransactionCount *) [self.transactionArray objectAtIndex:sender.tag];
    
    

    searchRelatedViewController.transaction = [self.transactionArray objectAtIndex:indexPath.row];;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchRelatedViewController];
    
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [appDelegate_iPad.mainViewController.iAccountViewController presentViewController:navigationController animated:YES completion:nil];
    appDelegate_iPad.mainViewController.popViewController = navigationController;
    

}

-(void)cellDuplicateBtnPressed:(NSIndexPath *)indexPath
{
    
    self.duplicateDate = [NSDate date];
    AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    self.duplicateDateViewController= [[DuplicateTimeViewController alloc]initWithNibName:@"DuplicateTimeViewController" bundle:nil];
    _duplicateDateViewController.delegate = self;
    _duplicateDateViewController.view.frame = CGRectMake(0, 0, 1024,768);
    [appDelegate_iPhone.mainViewController.view addSubview:_duplicateDateViewController.view];
   
}

-(void)cellDeleteBtnPresses:(NSIndexPath *)indexPath
{
    Transaction *trans =[self.transactionArray objectAtIndex:indexPath.row];
    
    if(trans != nil)
    {
        
        if(![trans.recurringType isEqualToString:@"Never"])
        {
            
            UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                         initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil)
                                         delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"VC_Remove", nil)
                                         otherButtonTitles:nil,
                                         nil];
            _accountandTransactionDeleteIndex = indexPath;
            actionSheet.tag = 201;
            
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            UITableViewCell *selectedCell = [_rightTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            CGPoint point1 = [_rightTableView convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
            [actionSheet showFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
            
            appDelegate.appActionSheet = actionSheet;
            
            return;
        }
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.epdc deleteTransactionRel:trans];
        
        _swipCellIndex = -1;
        [self reFlashTableViewData];
        
    }
}

-(void)clearTranAction:(id)sender
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [(ClearCusBtn *)sender setSelected:![(ClearCusBtn *)sender isSelected]];
    Transaction *t =  [(ClearCusBtn *)sender t] ;
    t.isClear =[NSNumber numberWithBool:[(ClearCusBtn *)sender isSelected]];
    NSError *errors;
    t.dateTime_sync = [NSDate date];
    if (![appDelegate.managedObjectContext save:&errors]) {
        NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
        
    }
//    if (appDelegate.dropbox.drop_account)
//    {
//        [appDelegate.dropbox updateEveryTransactionDataFromLocal:t];
//    }
    if ([PFUser currentUser])
    {
        [[ParseDBManager sharedManager]updateTransactionFromLocal:t];
    }
    for (int i=0; i<[[t.childTransactions allObjects]count]; i++)
    {
        Transaction *childTransaction = [[t.childTransactions allObjects]objectAtIndex:i];
        childTransaction.dateTime_sync = [NSDate date];
        [appDelegate.managedObjectContext save:&errors];
        
//        if (appDelegate.dropbox.drop_account)
//        {
//            [appDelegate.dropbox updateEveryTransactionDataFromLocal:childTransaction];
//        }
        if ([PFUser currentUser])
        {
            [[ParseDBManager sharedManager]updateTransactionFromLocal:childTransaction];
        }
    }
    
    
 
    
    [self getTranscationDateSouce];
    [_rightTableView reloadData];

    [self setDateLabelText];
    
    
}

-(void)accountBtnOrCategoryBtnPressed:(UIButton *)sender
{
    if (!sender.selected)
    {
        
        if (sender == _accountBtn)
        {
            _accountBtn.selected = YES;
            _categoryBtn.selected = NO;
            [self reFleshTableViewData_withoutReset];
            
            _leftTableView.frame = CGRectMake(-_accountAndCategoryContainView.frame.size.width, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height - 60);
            _categoryTableView.frame = CGRectMake(0, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height);
            _leftBottomView.frame=CGRectMake(0, 600, 378, 60);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            _leftTableView.frame = CGRectMake(0, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height-60);
            _categoryTableView.frame = CGRectMake(_accountAndCategoryContainView.frame.size.width, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height);
            _progressImageView.frame = CGRectMake(0, 44-2-EXPENSE_SCALE, _progressImageView.frame.size.width, _progressImageView.frame.size.height);
            
            [UIView commitAnimations];
            _rightViewContainView.hidden = NO;
            _categoryContainView.hidden = YES;
        }
        else
        {
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate.epnc setFlurryEvent_WithIdentify:@"06_ACCP_CAT"];
            
            _accountBtn.selected = NO;
            _categoryBtn.selected = YES;
            
            [self getCategoryDataSource];
            
            if ([_categoryArray count]>0)
            {
                _indexofCategory = 0;
                [_categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexofCategory inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self getCategoryTransactionDataSource];
            }
            
            _leftTableView.frame = CGRectMake(0, 0, _accountAndCategoryContainView.frame.size.width, _leftTableView.frame.size.height-60);
            _categoryTableView.frame = CGRectMake(_accountAndCategoryContainView.frame.size.width, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height);
            _leftBottomView.frame=CGRectMake(-_leftBottomView.frame.size.width, 600, 378, 60);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            _leftTableView.frame = CGRectMake(-_accountAndCategoryContainView.frame.size.width, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height-60);
            _categoryTableView.frame = CGRectMake(0, 0, _accountAndCategoryContainView.frame.size.width, _accountAndCategoryContainView.frame.size.height);
            _progressImageView.frame = CGRectMake(_progressImageView.frame.size.width, 44-2-EXPENSE_SCALE, _progressImageView.frame.size.width, _progressImageView.frame.size.height);
            
            [UIView commitAnimations];
            _rightViewContainView.hidden = YES;
            _categoryContainView.hidden = NO;
        }
        
        //设置右边的标题与时间
        [self setDateLabelText];
    }
}

#pragma mark Table PopoverController methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;
{
	PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.pvt = nonePopup;
//    if( isShowAccListPop )
//    {
//        isShowAccListPop = FALSE;
//        return TRUE;
//    }
    
	return FALSE;
}


#pragma mark Table view methods - select cell
//选择一个Trans
- (void)SelectTransactinAtIndexPath:(NSIndexPath *)indexPath
{
    Transaction *oneTrans = [self.transactionArray objectAtIndex:indexPath.row];
    if (oneTrans.parTransaction != nil) {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_This is a part of a transaction split, and it can not be edited alone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil, nil];
        appDelegate_iPad.appAlertView = alertView;
        [alertView show];
        return;
    }
    
    _iTransactionQuickEditViewController=[[ipad_TranscactionQuickEditViewController alloc]initWithNibName:@"ipad_TranscactionQuickEditViewController" bundle:nil];
    
    self.iTransactionQuickEditViewController.transaction = [self.transactionArray objectAtIndex:indexPath.row];
    self.iTransactionQuickEditViewController.typeoftodo = @"IPAD_EDIT";
    
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.iTransactionQuickEditViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate1.mainViewController.popViewController = navigationController;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    

    


}

//foot btn action
-(void)editAccountFromRightTableViewFotter{
    
    if (_swipCellIndex != -1) {
        _swipCellIndex = -1;
        [_rightTableView reloadData];
        return;
    }
    AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];

    AccountCount *oneAccountccount = [_accountArray objectAtIndex:_indexOfAccount ];
    Accounts *tmpAccount = oneAccountccount.accountsItem;
    
    ipad_AccountEditViewController *addController =[[ipad_AccountEditViewController alloc] initWithNibName:@"ipad_AccountEditViewController" bundle:nil];
    
    addController.accounts = tmpAccount;
    addController.typeOftodo = @"IPAD_EDIT";
    addController.iAccountViewController = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate1.mainViewController.popViewController = navigationController ;
    [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
    navigationController.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
//    navigationController.view.superview.frame = CGRectMake(
//                                                           272,
//                                                           100,
//                                                           480,
//                                                           490
//                                                           );

}

-(void)editAccountTouchDown:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"ipad_cell_630_50_sel.png"] forState:UIControlStateNormal];
}
-(void)editAccountTouchOutSide:(UIButton *)sender
{
    [sender setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];

}
- (void)SelectAccountAtIndexPath:(NSIndexPath *)indexPath
{
    _indexOfAccount =indexPath.row;
    [_leftTableView reloadData];
    if (_indexOfAccount<=[_leftTableView numberOfRowsInSection:0])
    {
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
    }
    
    [self setDateLabelText];
    [self getTranscationDateSouce];
 

    [self.rightTableView reloadData];

}

-(void)selectedCategoryAtIndexPath:(NSIndexPath *)indexPath
{
    _indexofCategory = indexPath.row;
    //设置右边的标题与时间
    [self setDateLabelText];
    [self getCategoryTransactionDataSource];
}


#pragma mark TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == _leftTableView)
        return 75;
    else if (tableView == _categoryTableView)
        return 44;
    else if (tableView == _categoryTransactionTableView)
        return 44;
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    if ([_accountArray count]==0) {
        return 0;
    }
    if (tableView==_rightTableView) {
        return 44;
    }
    else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_rightTableView || tableView==_categoryTransactionTableView)
    {
        return 30;
    }
    else
    {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView)
        return [_accountArray count];
	else if(tableView == _rightTableView)
        return [_transactionArray count];
    else if (tableView == _categoryTableView)
        return [_categoryArray count];
    else
        return [_transactionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //transaction cell
	if(tableView == _rightTableView)
	{
		static NSString *tCellIdentifier = @"transcationCell";
		Custom_iPad_Account_TransactionCell *cell = (Custom_iPad_Account_TransactionCell *)[tableView dequeueReusableCellWithIdentifier:tCellIdentifier];
		if(cell == nil)
		{
			cell = [[Custom_iPad_Account_TransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tCellIdentifier] ;
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.delegate=self;
            [cell.clearBtn addTarget:self action:@selector(clearTranAction:) forControlEvents:UIControlEventTouchUpInside];
		}
        
//        cell.cellSearchBtn.tag = indexPath.row;
//        cell.cellDeleteBtn.tag = indexPath.row;
//        cell.cellDuplicateBtn.tag = indexPath.row;
//        cell.accountViewController_iPad = self;
        [cell setRightUtilityButtons:[self cellEditBtnsSet] WithButtonWidth:53];
        
		[self configureTransactinCell:cell atIndexPath:indexPath];
		return cell;
        
        
	}
    else if (tableView == _categoryTableView)
    {
        static NSString *CellIdentifier = @"CategoryCell";
        ipad_AccountCategoryCell *cell = (ipad_AccountCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ipad_AccountCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureCategoryCell:cell atIndexPath:indexPath];
        return cell;
    }
    else if (tableView == _categoryTransactionTableView)
    {
        static NSString *tCellIdentifier = @"categoryTransactionCell";
        ipad_CategoryTransactionCell*cell = (ipad_CategoryTransactionCell *)[tableView dequeueReusableCellWithIdentifier:tCellIdentifier];
        if(cell == nil)
        {
            cell = [[ipad_CategoryTransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tCellIdentifier] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        [self configureCategoryTransactinCell:cell atIndexPath:indexPath];
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        newAcountCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"newAcountCell" owner:self options:nil]lastObject];
            
            cell.deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 24, 30, 30)];
            [cell addSubview:cell.deleteBtn];
            cell.deleteBtn.alpha=0;
            cell.deleteBtn.tag=indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(cellDeleteBtnPressed_account:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //
    
            cell.detailButton=[[UIButton alloc]initWithFrame:CGRectMake(378-52*2, 0, 52, 75)];
            [cell.detailButton setImage:[UIImage imageNamed:@"account_edit_edit"] forState:UIControlStateNormal];
            [cell addSubview:cell.detailButton];
            cell.detailButton.alpha=0;
            cell.detailButton.tag=indexPath.row;
            [cell.detailButton addTarget:self action:@selector(cellDetailBtnPressed_account:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [self configureNewAccountCell:cell atIndexIndexPath:indexPath];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;

        
    }
    
}
-(NSArray *)cellEditBtnsSet
{
    NSMutableArray *btns=[[NSMutableArray alloc]init];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_relation_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_copy_click"]]];
    [btns sw_addUtilityButtonWithColor:[UIColor clearColor] normalIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete"]] selectedIcon:[UIImage imageNamed:[NSString customImageName:@"sideslip_delete_click"]]];
    return btns;
}
- (void)configureTransactinCell:(Custom_iPad_Account_TransactionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Transaction *transactions = [self.transactionArray objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (_isShowReconcile)
    {
        cell.clearBtn.t=transactions;
        cell.categoryIcon.hidden = YES;
        cell.clearBtn.hidden = NO;
        cell.clearBtn.selected = [transactions.isClear boolValue];
    }
    else
    {
        cell.clearBtn.hidden = YES;
        cell.categoryIcon.hidden = NO;
        cell.categoryIcon.image=[UIImage imageNamed:transactions.category.iconName];
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    cell.timeLabel.text = [dateFormatter stringFromDate:transactions.dateTime];

    
    
    //payee
    if(transactions.payee !=nil)
        cell.payeeLabel.text = transactions.payee.name;
    else
        cell.payeeLabel.text = @"-";
    if ([transactions.notes length]>0)
    {
        cell.payeeLabel.frame = CGRectMake(186, 6, 100, 17);
        cell.memoLabel.frame = CGRectMake(186, 23, 100, 17);
    }
    else
    {
        cell.payeeLabel.frame = CGRectMake(186, 13, 100, 17);
        cell.memoLabel.frame = CGRectMake(186, 6, 100, 17);
    }
    
    //memo
    cell.memoLabel.text = transactions.notes;
    
    //cycle
    if ([transactions.recurringType isEqualToString:@"Never"])
    {
        cell.cycleImage.hidden = YES;
    }
    else
    {
        cell.cycleImage.hidden = NO;
    }
    
    //photo
    if ([transactions.photoName length]>0) {
        cell.photoImageView.hidden = NO;
    }
    else
        cell.photoImageView.hidden = YES;
    if (cell.cycleImage.hidden)
    {
        cell.photoImageView.frame = CGRectMake(cell.cycleImage.frame.origin.x,cell.photoImageView.frame.origin.y, cell.photoImageView.frame.size.width, cell.photoImageView.frame.size.height);
    }
    else
    {
        cell.photoImageView.frame = CGRectMake(cell.cycleImage.frame.origin.x+20,cell.photoImageView.frame.origin.y, cell.photoImageView.frame.size.width, cell.photoImageView.frame.size.height);
    }
    
    
    
    //amount
    if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transactions.amount  doubleValue]];
        cell.categoryIcon.image = [UIImage imageNamed:transactions.category.iconName];
        [cell.spentLabel setTextColor:[UIColor colorWithRed:28.0/255 green:201.0/255 blue:70.0/255 alpha:1.0]];
    }
    else if([transactions.category.categoryType isEqualToString:@"EXPENSE"]||[transactions.childTransactions count]>0)
    {
        if ([transactions.childTransactions count]>0) {
            cell.categoryIcon.image = [UIImage imageNamed:@"icon_mind.png"];
            NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[transactions.childTransactions allObjects]];
            double childTotalAmount = 0;
            for (int child=0; child<[childArray count]; child ++) {
                Transaction *oneChild = [childArray objectAtIndex:child];
                if ([oneChild.state isEqualToString:@"1"]) {
                    childTotalAmount += [oneChild.amount doubleValue];
                }
            }
            cell.spentLabel.text =  [appDelegate.epnc formatterStringWithOutPositive:0-childTotalAmount];
            
        }
        else
        {
            cell.categoryIcon.image = [UIImage imageNamed:transactions.category.iconName];
            cell.spentLabel.text =  [appDelegate.epnc formatterStringWithOutPositive:0-[transactions.amount  doubleValue]];
            
        }
        
        [cell.spentLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
    }
    else
    {
        AccountCount *ac = [_accountArray objectAtIndex:_indexOfAccount ];
        Accounts *selectedAccount = ac.accountsItem;
        
        if (ac.accountsItem == nil) {
            cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transactions.amount  doubleValue]];
            [cell.spentLabel setTextColor:[UIColor colorWithRed:54.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1.f]];
        }
        else
        {
            if(transactions.expenseAccount == selectedAccount)
            {
                cell.spentLabel.text =  [appDelegate.epnc formatterStringWithOutPositive:0-[transactions.amount  doubleValue]];
                [cell.spentLabel setTextColor:[UIColor colorWithRed:243.0/255 green:61.0/255 blue:36.0/255 alpha:1]];
                
            }
            else    if(transactions.incomeAccount == selectedAccount)
            {
                cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transactions.amount  doubleValue]];
                [cell.spentLabel setTextColor:[UIColor colorWithRed:102.0/255 green:175.0/255 blue:54.0/255 alpha:1.0]];
                
            }
        }
        
        cell.categoryIcon.image = [UIImage imageNamed:@"iocn_transfer.png"];
        cell.payeeLabel.text = [NSString stringWithFormat:@"%@ > %@",transactions.expenseAccount.accName,transactions.incomeAccount.accName ];
        
    }
    
    //running balance
    double runningBalance = 0;
    if ([_runningBalanceArray count]>0)
    {
        runningBalance =[[_runningBalanceArray objectAtIndex:indexPath.row] doubleValue];
    }
    if(runningBalance <0)
    {
        cell.runningBalanceLabel.text = [appDelegate.epnc formatterString:runningBalance];
        [cell.runningBalanceLabel setTextColor:[UIColor colorWithRed:255/255.0 green:93/255.0 blue:106/255.0 alpha:1]];
        
    }
    else
    {
        cell.runningBalanceLabel.text = [appDelegate.epnc formatterString:runningBalance];
        [cell.runningBalanceLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
        
    }

    
    if (indexPath.row%2==0)
    {
        if (indexPath.row==self.transactionArray.count-1)
        {
            cell.bgImageView.image=[UIImage imageNamed:@"account_form_bottom_white.png"];
        }
        else
        {
            cell.bgImageView.image=[UIImage imageNamed:@"account_form_white.png"];
        }
    }
    else
    {
        if (indexPath.row==self.transactionArray.count-1)
        {
            cell.bgImageView.image=[UIImage imageNamed:@"account_form_bottom_gray.png"];

        }
        else
        {
            cell.bgImageView.image=[UIImage imageNamed:@"account_form_gray.png"];

        }
    }
}

- (void)configureCategoryTransactinCell:(ipad_CategoryTransactionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    Transaction *transactions = [self.transactionArray objectAtIndex:indexPath.row];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    cell.timeLabel.text = [dateFormatter stringFromDate:transactions.dateTime];
    
    
    
    //payee
    if(transactions.payee !=nil)
        cell.payeeLabel.text = transactions.payee.name;
    else
        cell.payeeLabel.text = @"-";
    
    //account
    if ([transactions.category.categoryType isEqualToString:@"EXPENSE"])
    {
        cell.accountLabel.text = transactions.expenseAccount.accName;
    }
    else
        cell.accountLabel.text = transactions.incomeAccount.accName;
    
    //memo
    cell.memoLabel.text = transactions.notes;
    
    
    //amount
    if([transactions.category.categoryType isEqualToString:@"INCOME"])
    {
        cell.spentLabel.text =[appDelegate.epnc formatterStringWithOutPositive:[transactions.amount  doubleValue]];
        [cell.spentLabel setTextColor:[UIColor colorWithRed:28/255.0 green:201/255.0 blue:70/255.0 alpha:1]];
    }
    else if([transactions.category.categoryType isEqualToString:@"EXPENSE"]||[transactions.childTransactions count]>0)
    {
        if ([transactions.childTransactions count]>0) {
            NSMutableArray *childArray = [[NSMutableArray alloc]initWithArray:[transactions.childTransactions allObjects]];
            double childTotalAmount = 0;
            for (int child=0; child<[childArray count]; child ++) {
                Transaction *oneChild = [childArray objectAtIndex:child];
                if ([oneChild.state isEqualToString:@"1"]) {
                    childTotalAmount += [oneChild.amount doubleValue];
                }
            }
            cell.spentLabel.text =  [appDelegate.epnc formatterStringWithOutPositive:0-childTotalAmount];
            
        }
        else
        {
            cell.spentLabel.text =  [appDelegate.epnc formatterStringWithOutPositive:0-[transactions.amount  doubleValue]];
            
        }
        
        [cell.spentLabel setTextColor:[UIColor colorWithRed:255.0/255 green:93.0/255 blue:106.0/255 alpha:1]];
    }
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_cell_b3_add_transactions.png"]];
    
    if (indexPath.row%2==0)
    {
        if (indexPath.row==self.transactionArray.count-1)
        {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_category_form_bottom_white.png"]];
        }
        else
        {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_category_form_white.png"]];
        }
    }
    else
    {
        if (indexPath.row==self.transactionArray.count-1)
        {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_category_form_bottom_gray.png"]];
        }
        else
        {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"account_category_form_gray.png"]];
        }
    }
}

- (void)configureAccountCell:(ipad_AccountCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:indexPath.row];
    cell.typeImageView.image = [UIImage imageNamed:ac.accountsItem.accountType.iconName];
	if(ac.accountsItem ==nil)
	{
		cell.nameLabel.text = @"All";
        cell.titleLabel.text =@"All Accounts";
    }
	else
    {
 		cell.nameLabel.text = ac.accountsItem.accName;
        if(ac.accountsItem.accountType!=nil)
            cell.titleLabel.text =ac.accountsItem.accountType.typeName;
	}
    
    cell.blanceLabel.text = [appDelegate.epnc formatterString: ac.totalBalance];
    if(ac.totalBalance>=0)
    {
        [cell.blanceLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
    }
    else
    {
        [cell.blanceLabel setTextColor:[appDelegate.epnc getAmountRedColor]];
    }
}
-(void)configureNewAccountCell:(newAcountCell *)cell atIndexIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AccountCount *ac = (AccountCount *)[_accountArray objectAtIndex:indexPath.row];
    cell.accountIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"account_iconbg_%@",ac.accountsItem.accountType.iconName]];
    cell.typeLabel.text=ac.accountsItem.accountType.typeName;
    cell.nameLabel.text=ac.accountsItem.accName;
    
    
    
    UIColor *col1=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:255/255.0 alpha:1];
    UIColor *col2=[UIColor colorWithRed:107/255.0 green:156/255.0 blue:255/255.0 alpha:1];
    UIColor *col3=[UIColor colorWithRed:122/255.0 green:210/255.0 blue:254/255.0 alpha:1];
    UIColor *col4=[UIColor colorWithRed:75/255.0 green:211/255.0 blue:177/255.0 alpha:1];
    UIColor *col5=[UIColor colorWithRed:44/255.0 green:204/255.0 blue:81/255.0 alpha:1];
    UIColor *col6=[UIColor colorWithRed:239/255.0 green:185/255.0 blue:53/255.0 alpha:1];
    UIColor *col7=[UIColor colorWithRed:253/255.0 green:133/255.0 blue:68/255.0 alpha:1];
    UIColor *col8=[UIColor colorWithRed:252/255.0 green:83/255.0 blue:96/255.0 alpha:1];
    UIColor *col9=[UIColor colorWithRed:200/255.0 green:115/255.0 blue:239/255.0 alpha:1];
    NSArray *colorArray=@[col1,col2,col3,col4,col5,col6,col7,col8,col9];
    
    Accounts *account=ac.accountsItem;
    
    
    NSString *imageName=[NSString stringWithFormat:@"account_bg_%@",ac.accountsItem.accountType.iconName];
    
    UIImage *backImge=[UIImage imageNamed:[NSString customImageName:imageName]];
    
    NSInteger colorNum;
    if (account.accountColor!=nil)
    {
        colorNum=[account.accountColor integerValue];
    }
    else
    {
        if ([account.accountType.typeName isEqualToString:@"Credit Card"])
        {
            colorNum=0;
        }
        else if ([account.accountType.typeName isEqualToString:@"Debit Card"])
        {
            colorNum=2;
        }
        else if ([account.accountType.typeName isEqualToString:@"Asset"])
        {
            colorNum=3;
        }
        else if ([account.accountType.typeName isEqualToString:@"Savings"])
        {
            colorNum=4;
        }
        else if ([account.accountType.typeName isEqualToString:@"Cash"])
        {
            colorNum=5;
        }
        else if ([account.accountType.typeName isEqualToString:@"Checking"])
        {
            colorNum=6;
        }
        else if ([account.accountType.typeName isEqualToString:@"Loan"])
        {
            colorNum=7;
        }
        else if ([account.accountType.typeName isEqualToString:@"Investing"])
        {
            colorNum=8;
        }
        else
        {
            colorNum=1;
        }
    }
    CGColorRef color=[[colorArray objectAtIndex:colorNum] CGColor];
    UIImage *image=[UIImage imageFromMaskImage:backImge withColor:color];
    
    cell.backgroundImage.image=image;
    
    double balanceAmount=ac.defaultAmount+ac.totalIncome-ac.totalExpense;
//    NSLog(@"balanceAmount == %f",balanceAmount);
    if (balanceAmount>999999999 || balanceAmount<-999999999)
    {
        cell.balanceLabel.text=[NSString stringWithFormat:@"%@k",[appDelegate.epnc formatterString:balanceAmount/1000]];
    }
    else
    {
        cell.balanceLabel.text = [appDelegate.epnc formatterString:balanceAmount];
    }
    
    if (indexPath.row==firstInSel)
    {
        [self setCell:cell seleceted:YES];
        selectedLeftCell=cell;
    }
    
}
-(void)configureCategoryCell:(ipad_AccountCategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Category *oneCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:indexPath.row]).categoryItem;
    cell.headImageView.image = [UIImage imageNamed:oneCategory.iconName];
    cell.nameLabel.text = oneCategory.categoryName;
    if(![oneCategory.isSystemRecord boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    
//    if (indexPath.row == [categoryArray count]-1)
//    {
//        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_b2_320_44.png"]];
//        
//    }
//    else
//        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_AccountCategory_310_44.png"]];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView)
    {
        Category *oneCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:indexPath.row]).categoryItem;
        ipad_CategoryEditViewController *categoryEditViewController = [[ipad_CategoryEditViewController alloc]initWithNibName:@"ipad_CategoryEditViewController" bundle:nil];
        categoryEditViewController.editModule = @"IPAD_ACCOUNT_EDIT";
        categoryEditViewController.categories = oneCategory;
        
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:categoryEditViewController];
        AppDelegate_iPad * appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        appDelegate1.mainViewController.popViewController = navigationController;
        [appDelegate1.mainViewController presentViewController:navigationController animated:YES completion:nil];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header;
    header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 566, 30)];
    header.backgroundColor=[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    if (tableView==_rightTableView)
    {
        
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(58, 0, 113, 30)];
        dateLabel.text=NSLocalizedString(@"VC_Date", nil);
        dateLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        dateLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        dateLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:dateLabel];
        
        UILabel *payeeLabel=[[UILabel alloc]initWithFrame:CGRectMake(58+113, 0, 168, 30)];
        payeeLabel.text=NSLocalizedString(@"VC_Payee", nil);
        payeeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        payeeLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        payeeLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:payeeLabel];
        
        UILabel *amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(58+113+168, 0, 114, 30)];
        amountLabel.text=NSLocalizedString(@"VC_Amount", nil);
        amountLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        amountLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        amountLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:amountLabel];
        
        UILabel *balanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(58+113+168+114, 0, 113, 30)];
        balanceLabel.text=NSLocalizedString(@"VC_Balance", nil);
        balanceLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        balanceLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        balanceLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:balanceLabel];
        
        UIView *firstLine=[[UIView alloc]initWithFrame:CGRectMake(58, 0, EXPENSE_SCALE, 30)];
        firstLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:firstLine];
        
        UIView *secondLine=[[UIView alloc]initWithFrame:CGRectMake(58+113, 0, EXPENSE_SCALE, 30)];
        secondLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:secondLine];
        
        UIView *thirdLine=[[UIView alloc]initWithFrame:CGRectMake(58+113+168, 0, EXPENSE_SCALE, 30)];
        thirdLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:thirdLine];
        
        UIView *forthLine=[[UIView alloc]initWithFrame:CGRectMake(58+113+168+114, 0, EXPENSE_SCALE, 30)];
        forthLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:forthLine];

    }
    else if (tableView==_categoryTransactionTableView)
    {
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 113, 30)];
        dateLabel.textColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        dateLabel.text=NSLocalizedString(@"VC_Date", nil);
        dateLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        dateLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:dateLabel];
        
        UILabel *payeeLabel=[[UILabel alloc]initWithFrame:CGRectMake(113, 0, 168, 30)];
        payeeLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        payeeLabel.text=NSLocalizedString(@"VC_Payee", nil);
        payeeLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        payeeLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:payeeLabel];
        
        UILabel *amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(113+168, 0, 114, 30)];
        amountLabel.textColor=[UIColor colorWithRed: 168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        amountLabel.text=NSLocalizedString(@"VC_Amount", nil);
        amountLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        amountLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:amountLabel];
        
        UILabel *memoLabel=[[UILabel alloc]initWithFrame:CGRectMake(113+168+114, 0, 171, 30)];
        memoLabel.textColor=[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
        memoLabel.text=NSLocalizedString(@"VC_Memo", nil);
        memoLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        memoLabel.textAlignment=NSTextAlignmentCenter;
        [header addSubview:memoLabel];
        
        UIView *firstLine=[[UIView alloc]initWithFrame:CGRectMake(113, 0, EXPENSE_SCALE, 30)];
        firstLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:firstLine];
        
        UIView *secondLine=[[UIView alloc]initWithFrame:CGRectMake(113+168, 0, EXPENSE_SCALE, 30)];
        secondLine.backgroundColor=[UIColor colorWithRed: 218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:secondLine];
        
        UIView *thirdLine=[[UIView alloc]initWithFrame:CGRectMake(113+168+114, 0, EXPENSE_SCALE, 30)];
        thirdLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [header addSubview:thirdLine];
    }
    return header;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _rightTableView)
    {
        if ([_accountArray count]>0) {
            AccountCount *seletedAccount = [_accountArray objectAtIndex:_indexOfAccount ];
            if (tableView==_rightTableView) {
                
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
                UIView *tmpFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 566, 44)];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 566, 44)];
                [btn addTarget:self action:@selector(editAccountFromRightTableViewFotter) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(editAccountTouchOutSide:) forControlEvents:UIControlEventTouchDragOutside];
                [tmpFooterView addSubview:btn];
                
                
                
                
                
                
                UILabel *nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(186, 0, 168,44)];
                [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
                [nameLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
                [nameLabel setTextAlignment:NSTextAlignmentLeft];
                [nameLabel setBackgroundColor:[UIColor clearColor]];
                nameLabel.text = NSLocalizedString(@"VC_StartBalance", nil);
                [tmpFooterView addSubview:nameLabel];
                
                double startAmount = 0;
                NSDate *earlyDate;
                if (!seletedAccount.accountsItem)
                {
                    //get account array
                    NSError *error = nil;
                    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:appDelegate.managedObjectContext];
                    [fetchRequest setEntity:entity];
                    NSPredicate * predicate =[NSPredicate predicateWithFormat:@"state contains[c] %@",@"1"];
                    [fetchRequest setPredicate:predicate];
                    
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
                    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
                    
                    [fetchRequest setSortDescriptors:sortDescriptors];
                    NSArray* objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    
                    earlyDate = ((Accounts *)[objects firstObject]).dateTime;
                    for (int i=0; i<[objects count]; i++)
                    {
                        Accounts *tmpAccount = (Accounts *)[objects objectAtIndex:i];
                        startAmount+=[tmpAccount.amount doubleValue];
                    }
                    
                    
                }
                else
                {
                    startAmount = [seletedAccount.accountsItem.amount doubleValue];
                    earlyDate = seletedAccount.accountsItem.dateTime;
                }
                
                UILabel *tmpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 0, 113, 44)];
                [tmpdateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
                [tmpdateLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
                [tmpdateLabel setTextAlignment:NSTextAlignmentLeft];
                tmpdateLabel.text =  [_outputFormatter stringFromDate:earlyDate];
                [tmpFooterView addSubview:tmpdateLabel];
                
                
                
                UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(438-107, 0, 107, 44)];
                [amountLabel setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
                [amountLabel setTextAlignment:NSTextAlignmentRight];
                [amountLabel setTextColor:[appDelegate.epnc getAmountBlackColor]];
                [amountLabel setBackgroundColor:[UIColor clearColor]];
                [amountLabel setHighlightedTextColor:[UIColor whiteColor]];
                amountLabel.text = [appDelegate.epnc formatterString:startAmount];
                [tmpFooterView addSubview:amountLabel];
                
                UILabel *runningBalance = [[UILabel alloc] initWithFrame:CGRectMake(566-15-110, 0, 110.0, 44)];
                [runningBalance setFont:[appDelegate.epnc getMoneyFont_exceptInCalendar_WithSize:14]];
                [runningBalance setTextAlignment:NSTextAlignmentRight];
                [runningBalance setTextColor:[appDelegate.epnc getAmountBlackColor]];
                [runningBalance setBackgroundColor:[UIColor clearColor]];
                [runningBalance setHighlightedTextColor:[UIColor whiteColor]];
                runningBalance.text =[appDelegate.epnc formatterString:startAmount];
                [tmpFooterView addSubview:runningBalance];
                
                if (self.transactionArray.count%2)
                {
                    tmpFooterView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"account_form_bottom_gray.png"]];
                }
                else
                {
                    tmpFooterView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"account_form_bottom_white.png"]];
                }
                
                return tmpFooterView;
                
            }
            else
                return nil;
            
        }
    }
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectZero];
    return tmpView;
}



//点击交易的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    _dateRangeSelView.hidden = YES;
    _coverView.hidden=YES;
	if(tableView == _rightTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        if (_swipCellIndex != -1)
        {
            _swipCellIndex = -1;
            [_rightTableView reloadData];
            return;
        }
        
        [self SelectTransactinAtIndexPath:indexPath];
    }
    else if (tableView==_categoryTableView)
    {
        _swipCellIndex = -1;
        [self selectedCategoryAtIndexPath:indexPath];

    }
    else if(tableView == _categoryTransactionTableView)
    {
        _swipCellIndex = -1;
        [_categoryTransactionTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self SelectTransactinAtIndexPath:indexPath];
    }
	else
    {
        _swipCellIndex = -1;
        [self SelectAccountAtIndexPath:indexPath];
    }

    if ( tableView==_leftTableView)
    {
        //自定义selected状态转换
        [self setCell:selectedLeftCell seleceted:NO];
        firstInSel=indexPath.row;
        selectedLeftCell=[tableView cellForRowAtIndexPath:indexPath];
        [self setCell:selectedLeftCell seleceted:YES];
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//当移动一个category去某一个cell的时候，就要将array中的数据顺序进行颠倒，并且重新保存数据库
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    if (tableView == _leftTableView)
    {
        //首先保存数据库
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        
        
        //首先保存数据库
        AccountCount *oneAccount = [_accountArray objectAtIndex:sourceIndexPath.row];
        
        [_accountArray  removeObjectAtIndex:sourceIndexPath.row];
        [_accountArray insertObject:oneAccount atIndex:destinationIndexPath.row];
        for (int i=0; i<[_accountArray count]; i++) {
            AccountCount *oneA = [_accountArray objectAtIndex:i];
            oneA.accountsItem.orderIndex = [NSNumber numberWithLong: i];
            oneA.accountsItem.dateTime_sync = [NSDate date];
            
            [appDelegate.managedObjectContext save:&error];
        }
        //sync

        if ([PFUser currentUser])
        {
            for (int i=0; i<_accountArray.count; i++)
            {
                AccountCount *oneA=[_accountArray objectAtIndex:i];
                [[ParseDBManager sharedManager]updateAccountFromLocal:oneA.accountsItem];
            }
        }

    }
    else
    {
        
        //首先保存数据库
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        
        
        //首先保存数据库
        AccountCategoryCount *oneCateC = ((AccountCategoryCount *)[_categoryArray objectAtIndex:sourceIndexPath.row]);
        
        [_categoryArray  removeObjectAtIndex:sourceIndexPath.row];
        [_categoryArray insertObject:oneCateC atIndex:destinationIndexPath.row];
        for (int i=0; i<[_categoryArray count]; i++) {
            AccountCategoryCount *acc = (AccountCategoryCount *)[_categoryArray objectAtIndex:i];
            Category *oneCategory = acc.categoryItem;
            oneCategory.recordIndex  = [NSNumber numberWithInt: i];
            oneCategory.dateTime = [NSDate date];
            [appDelegate.managedObjectContext save:&error];
            
            //sync
//            if (appDelegate.dropbox.drop_account.linked) {
//                
//                
//                for (int i=0; i<[_categoryArray count]; i++) {
//                    Category *oneCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:i]).categoryItem;
//                    [appDelegate.dropbox updateEveryCategoryDataFromLocal:oneCategory];
//                    
//                }
//                
//            }
            if ([PFUser currentUser])
            {
                for (int i=0; i<_categoryArray.count; i++) {
                    Category *oneCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:i]).categoryItem;
                    [[ParseDBManager sharedManager]updateCategoryFromLocal:oneCategory];
                }
            }
        }
        
        
        
        
    }
//    else
//    {
//        
//        //首先保存数据库
//        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        NSError *error = nil;
//        
//        
//        //首先保存数据库
//        AccountCategoryCount *oneCateC = ((AccountCategoryCount *)[categoryArray objectAtIndex:sourceIndexPath.row]);
//        
//        [categoryArray  removeObjectAtIndex:sourceIndexPath.row];
//        [categoryArray insertObject:oneCateC atIndex:destinationIndexPath.row];
//        for (int i=0; i<[categoryArray count]; i++) {
//            AccountCategoryCount *acc = (AccountCategoryCount *)[categoryArray objectAtIndex:i];
//            Category *oneCategory = acc.categoryItem;
//            oneCategory.recordIndex  = [NSNumber numberWithLong: i];
//            oneCategory.dateTime = [NSDate date];
//            [appDelegate.managedObjectContext save:&error];
//        }
//        
//        //sync
//        if (appDelegate.dropbox.drop_account.linked) {
//            
//            
//            for (int i=0; i<[categoryArray count]; i++) {
//                Category *oneCategory = ((AccountCategoryCount *)[categoryArray objectAtIndex:i]).categoryItem;
//                [appDelegate.dropbox updateEveryCategoryDataFromLocal:oneCategory];
//                
//            }
//            
//        }
//        
//        
//    }
    
    
}

//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;

    if (tableView == _categoryTableView)
    {
            style = UITableViewCellEditingStyleDelete;

    }
    else if(tableView == _categoryTransactionTableView)
        style = UITableViewCellEditingStyleDelete;

	return style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (tableView == _categoryTransactionTableView)
        {
            
            Transaction *trans = [_transactionArray objectAtIndex:indexPath.row];
            PokcetExpenseAppDelegate *appDelegete = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if (![trans.recurringType isEqualToString:@"Never"]) {
                
                UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VC_This is a repeating transaction, delete it will also delete its all future repeats. Are you sure to delete?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"VC_Delete", nil) otherButtonTitles:nil];
                actionsheet.tag = 201;
                AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                UITableViewCell *selectedCell = [_categoryTransactionTableView cellForRowAtIndexPath:indexPath];
                CGPoint point1 = [_rightTableView convertPoint:selectedCell.frame.origin toView:appDelegate.mainViewController.view];
                [actionsheet showFromRect:CGRectMake(point1.x+selectedCell.frame.size.width/2,point1.y, selectedCell.frame.size.width,selectedCell.frame.size.height) inView:appDelegate.mainViewController.view animated:YES];
                
                appDelegate.appActionSheet = actionsheet;

                return;
                
            }
            else
            {
                [appDelegete.epdc deleteTransactionRel:trans];
                
                [self getCategoryTransactionDataSource];
                [_categoryTransactionTableView reloadData];
            }
            
        }
        else if(tableView == _categoryTableView)
        {
            self.categoryDeleteIndexPath = indexPath;
            Category *tmpCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:indexPath.row]).categoryItem;
            
            
            NSMutableString *string1 = nil;
            string1 = [[NSMutableString alloc] initWithString:NSLocalizedString(@"VC_Delete %@ will cause to also delete all its transactions, sub-categories ,related bills and budgets.", nil)];
            NSString *searchString = @"%@";
            //range是这个字符串的位置与长度
            NSRange range = [string1 rangeOfString:searchString];
            [string1 replaceCharactersInRange:NSMakeRange(range.location, [searchString length]) withString:tmpCategory.categoryName];
            NSString *msg = string1;
            
            if(editingStyle == UITableViewCellEditingStyleDelete)
            {
                UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                             initWithTitle:msg
                                             delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                             destructiveButtonTitle:NSLocalizedString(@"VC_Remove", nil)
                                             otherButtonTitles:nil,
                                             nil];
                [actionSheet showInView:self.view];
                actionSheet.tag = 2;
                
                AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                //获取这个cell在appDelegate.mainViewController.view中的fram
                UITableViewCell *selectedCell = [_categoryTableView cellForRowAtIndexPath:indexPath];
                CGPoint point1 = [_categoryTableView convertPoint:CGPointMake(selectedCell.frame.origin.x, selectedCell.frame.origin.y)  toView:appDelegate.mainViewController.view];
                [actionSheet showFromRect:CGRectMake(point1.x,point1.y, 100,44) inView:appDelegate.mainViewController.view animated:YES];
            }

        }

    }

    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView==_rightTableView) {
        if (_swipCellIndex!=-1) {
            _swipCellIndex=-1;
            _rightTableView.scrollEnabled = NO;
            [_rightTableView reloadData];
            _rightTableView.scrollEnabled = YES;
        }
    }
}

#pragma mark Duplicate Delegate
-(void)setDuplicateDateDelegate:(NSDate *)date{
    self.duplicateDate = date;
}

-(void)setDuplicateGoOnorNotDelegate:(BOOL)goon{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    PokcetExpenseAppDelegate *appDelegate_iPhone = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (goon) {
//        TransactionCount *selectedTransaction = [transactionArray objectAtIndex:swipCellIndex];
//        Transaction *selectedTrans =  selectedTransaction.t;
        
        Transaction *selectedTrans = [_transactionArray objectAtIndex:_swipCellIndex];
        
        [appDelegate.epdc duplicateTransaction:selectedTrans withDate:self.duplicateDate];
        /*
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *errors;
        Transaction *oneTrans = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
        //配置新的  Transaction
        oneTrans.dateTime = self.duplicateDate;
        oneTrans.amount = selectedTrans.amount;
        oneTrans.photoName = selectedTrans.photoName;
        oneTrans.notes = selectedTrans.notes;
//        oneTrans.transactionType = selectedTrans.transactionType;
        oneTrans.expenseAccount = selectedTrans.expenseAccount;
        oneTrans.incomeAccount = selectedTrans.incomeAccount;
        oneTrans.payee = selectedTrans.payee;
        oneTrans.isClear = selectedTrans.isClear;
        oneTrans.recurringType = selectedTrans.recurringType;
        
        oneTrans.dateTime_sync = [NSDate date];
        oneTrans.state = @"1";
        oneTrans.uuid = [EPNormalClass GetUUID];
        [appDelegate_iPhone.managedObjectContext save:&errors];
        if (appDelegate_iPhone.dropbox.drop_account.linked) {
            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneTrans];
        }
        
        //如果是多category循环，就需要添加子category
        if ([selectedTrans.childTransactions count]>0) {
            for (int i=0; i<[selectedTrans.childTransactions count]; i++) {
                Transaction *oneSelectedChildTransaction = [[selectedTrans.childTransactions allObjects]objectAtIndex:i];
                
                Transaction *childTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
                //--------配置 childTransaction的所有信息-----/
                childTransaction.dateTime = self.duplicateDate;
                childTransaction.amount = oneSelectedChildTransaction.amount;
                //在添加子category的时候，将note也保存进来
                childTransaction.notes=oneSelectedChildTransaction.notes;
                childTransaction.category = oneSelectedChildTransaction.category;
                
//                childTransaction.transactionType = oneSelectedChildTransaction.transactionType;
                childTransaction.incomeAccount =oneSelectedChildTransaction.incomeAccount;
                childTransaction.expenseAccount = oneSelectedChildTransaction.expenseAccount;
                
                childTransaction.isClear = [NSNumber numberWithBool:YES];
                childTransaction.recurringType = @"Never";
                childTransaction.state = @"1";
                childTransaction.dateTime_sync = [NSDate date];
                childTransaction.uuid = [EPNormalClass GetUUID];
                //给这个子category做标记
                if(oneSelectedChildTransaction.category!=nil)
                    childTransaction.category.others = @"HASUSE";
                childTransaction.payee =oneSelectedChildTransaction.payee;
                if(oneSelectedChildTransaction.category!=nil)
                {
                    //给当前的这个category下增加一个交易，添加关系而已
                    [oneSelectedChildTransaction.category addTransactionsObject:childTransaction];
                }
                //给当前这个 transaction 添加 childtransaction关系
                [oneTrans addChildTransactionsObject:childTransaction];
                if (![appDelegate_iPhone.managedObjectContext save:&errors])
                {
                    NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
                    
                }
                if (appDelegate_iPhone.dropbox.drop_account.linked) {
                    [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneSelectedChildTransaction];
                }
            }
            
            
        }
        else
            oneTrans.category = selectedTrans.category;
        
        [appDelegate.epdc autoInsertTransaction:oneTrans];
        
        if (![appDelegate_iPhone.managedObjectContext save:&errors])
        {
            NSLog(@"Unresolved error %@, %@",errors, [errors userInfo]);
            
        }
        if (appDelegate_iPhone.dropbox.drop_account.linked)
        {
            [appDelegate_iPhone.dropbox updateEveryTransactionDataFromLocal:oneTrans];
        }
        */
        
    }
    _swipCellIndex=-1;
    [self reFlashTableViewData];
}


#pragma mark 
#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //delete recurring transaction
	if(actionSheet.tag == 201)
	{
		if(buttonIndex == 1)
        {
            return ;
        }
        
        Transaction *trans = nil;
        if (_accountBtn.selected)
        {
            trans = [self.transactionArray objectAtIndex:buttonIndex];
        }
        else
        {
            NSIndexPath *transSelectedIndex = [_categoryTransactionTableView indexPathForSelectedRow];
            trans = [self.transactionArray objectAtIndex:transSelectedIndex.row];

        }
        
        if(trans != nil)
        {
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.epdc deleteTransactionRel:trans];
            
            _swipCellIndex = -1;
            
            [self reFlashTableViewData];
            return ;
        }
	}
    //delete account
    else if (actionSheet.tag == 202)
    {
        if(buttonIndex == 1)
            return;
        AccountCount *ac = [_accountArray objectAtIndex:_accountandTransactionDeleteIndex];
        if(ac.accountsItem == nil) return;
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.epdc deleteAccountRel:ac.accountsItem];
        
        [self reFleshTableViewData_withoutReset];
        return;
    }
    //delete category
    else if (actionSheet.tag == 2)
    {
        if(buttonIndex == 1)
            return;
        
        //获取要删除的category
        Category *oneCategory = ((AccountCategoryCount *)[_categoryArray objectAtIndex:self.categoryDeleteIndexPath.row]).categoryItem;
        
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:appDelegate.managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
        NSString *searchString = [NSString stringWithFormat:@"%@:",oneCategory.categoryName];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"categoryName contains [c] %@",searchString];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:pre];
        
        NSError *error = nil;
        NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (int i=0; i<[objects count]; i++)
        {
            Category *childCategory = [objects objectAtIndex:i];
            [appDelegate.epdc deleteCategoryAndDeleteRel:childCategory];
        }
        
        [appDelegate.epdc deleteCategoryAndDeleteRel:oneCategory];
        
        
        self.categoryDeleteIndexPath = nil;
        
        [self reFleshTableViewData_withoutReset];
        //        [self getCategoryDataSource];
        //        [categoryTableView reloadData];
        return;
    }
}
#pragma mark 
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
	 	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];		
 		
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return YES;
	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

#pragma mark - 调用方法
-(void)setCell:(newAcountCell *)cell seleceted:(BOOL)sel
{
    if (sel==YES)
    {
        cell.backgroundColor=[UIColor colorWithRed:196/255.0 green:198/255.0 blue:199/255.0 alpha:1];
        cell.bgView.backgroundColor=[UIColor colorWithRed:196/255.0 green:198/255.0 blue:199/255.0 alpha:1];
        cell.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        cell.typeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        cell.balanceLabel.font=[UIFont fontWithName:@"Avenir LT 65 Medium" size:17];

        

    }
    else
    {
        cell.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell.bgView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
        cell.typeLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:12];
        cell.balanceLabel.font=[UIFont fontWithName:@"Avenir Next Demi Bold" size:17];

    }
 
}
#pragma mark - SWTableview
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath=[_rightTableView indexPathForCell:cell];
    _swipCellIndex=indexPath.row;
    switch (index) {
        case 0:
            [self cellSearchBtnPressed:indexPath];
            
            break;
        case 1:
            [self cellDuplicateBtnPressed:indexPath];
            break;
        default:
            [self cellDeleteBtnPresses:indexPath];
            break;
    }
}

@end

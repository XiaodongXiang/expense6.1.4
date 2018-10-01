//
//  Expense.h
//  PokcetExpense
//
//  Created by ZQ on 9/27/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClearCusBtn.h"

@class AccountTranscationViewController;
@class HMJButton;

@interface ExpenseCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel		*nameLabel;
@property (nonatomic,strong) UILabel        *spentLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UIImageView    *cycleImage;
@property (nonatomic,strong) UIImageView    *memoImage;
@property (nonatomic,strong) UIImageView    *photoImage;
@property (nonatomic,strong) UIImageView    *categoryIcon;
@property (nonatomic,strong) UIView         *line;



@property (nonatomic,strong)  ClearCusBtn *clearBtn;

@property (nonatomic,strong) UIView     *cellBtnContainView;
@property (nonatomic,strong) UIImageView *threeBtnViewBgImage;
@property (nonatomic,strong) HMJButton *cellsearchBtn;
@property (nonatomic,strong) HMJButton   *cellDuplicateBtn;
@property (nonatomic,strong) HMJButton   *cellDeleteBtn;
@property (nonatomic,strong) UILabel                                 *runningBalaceLabel;

@property (nonatomic,strong) UISwipeGestureRecognizer *swipGestureFromLeft;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipGuetureFromRight;
@property (nonatomic,strong) AccountTranscationViewController *accountTransactionViewController;

-(void)layoutShowTwoCellBtns:(BOOL)showTwoBtns;
@end

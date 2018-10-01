//
//  AccountsViewController.h
//  PokcetExpense
//
//  Created by ZQ on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountEditViewController.h"
#import "AccountCell.h"
#import "Transaction.h"
#import "Accounts.h"
//#import "GADBannerView.h"
#import <iAd/iAd.h>
#import <QuartzCore/QuartzCore.h>

@class AccountTranscationViewController,AccountSearchViewController;
@interface AccountsViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ADBannerViewDelegate>
{
    //数值部分
    double  netWorthAmount;
    double  unclearedAmount;
    UIButton *rightBtn2;
}

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewB;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewB;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewL;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewL;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressImageViewL;

@property (nonatomic, strong) IBOutlet UITableView          *mytableview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView	* indicatorView;

@property (nonatomic, strong) NSMutableArray                *accountArray;

@property (nonatomic, assign) NSInteger deleteIndex;
@property (nonatomic, assign) NSInteger selAccountIndex;
//判断当前页面是在Account列表中，还是seachViewController中
@property (nonatomic, assign) BOOL hasBeenViewDidLoad;
@property (nonatomic, assign)BOOL    righBtnPressed;

@property(nonatomic,strong)AccountEditViewController *accountEditViewController;
@property(nonatomic,strong)AccountTranscationViewController *accountTransactionViewController;
@property(nonatomic,strong)AccountSearchViewController *accountSearchViewController;
- (void)getAccountDataSouce;

@property(nonatomic,strong)IBOutlet UIView          *accountContainView;
-(void)reflashUI;
-(void)resetStyleWithAds;
@end

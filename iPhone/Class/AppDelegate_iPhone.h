
//
//  AppDelegate_iPad.h
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokcetExpenseAppDelegate.h"
#import <ParseUI/ParseUI.h>
#import <iAd/iAd.h>
#import "menuViewController.h"
#import "SignViewController.h"
#import "MMDrawerController.h"
#import "touchIDView.h"


@class OverViewWeekCalenderViewController;
@class AccountsViewController;
@class BudgetViewController;
@class ExpenseViewController;
@class BillsViewController;
@class PasscodeCheckViewController_iPhone;
@class TransactionEditViewController;

@interface AppDelegate_iPhone : PokcetExpenseAppDelegate <UIAlertViewDelegate,ADBannerViewDelegate>
{
    NSMutableArray *accountArray;
}

@property (nonatomic, assign) BOOL isNeedCalData;



@property(nonatomic,strong) OverViewWeekCalenderViewController *overViewController;

@property(nonatomic,strong)IBOutlet UITabBarController                  *mainVC;
@property(nonatomic,strong)IBOutlet AccountsViewController              *accountsController;
@property(nonatomic,strong)IBOutlet BudgetViewController                *budgetController;
@property(nonatomic,strong)IBOutlet ExpenseViewController               *expenseViewController;
@property(nonatomic,strong)TransactionEditViewController    *transactionEditViewController;
@property(nonatomic,strong)MMDrawerController *drawerVC;

@property(nonatomic,strong)IBOutlet UIView   *customerTabbarView;
@property(nonatomic,strong)IBOutlet UIButton *calendarBtn;
@property(nonatomic,strong)IBOutlet UIButton *accountBtn;
@property(nonatomic,strong)IBOutlet UIButton *budgetBtn;
@property(nonatomic,strong)IBOutlet UIButton *reportBtn;
@property(nonatomic,strong)IBOutlet UIButton *addBtn;

@property (strong, nonatomic)  UIView *adsView;
@property (weak, nonatomic) IBOutlet UIImageView *adsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noadsLabel;
@property (weak, nonatomic) IBOutlet UIButton *adsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noadsL;
@property(nonatomic,strong)    PasscodeCheckViewController_iPhone *passCodeCheckView;
@property(nonatomic,strong) touchIDView *touchBack;
@property(nonatomic,strong)UIAlertView *transferAlertview;

@property(nonatomic,strong)UIView *close_PopView;
@property(nonatomic,strong)UIImagePickerController *m_pickerController;

@property(nonatomic,strong)UINavigationController *navCtrl;
@property(nonatomic,strong)menuViewController *menuVC;
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property(nonatomic,strong)SignViewController *logInViewController;

- (void)saveContext;

-(void)hideAds:(id)sender;

-(void)reflashUI;
-(void)afterpassword;

-(void)succededInLogIn;
-(void)succededInSignUp;

@end


//
//  AppDelegate_iPad.h
//  PocketExpense
//
//  Created by Tommy on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokcetExpenseAppDelegate.h"
#import "ipad_MainViewController.h"
#import <Foundation/Foundation.h>
#import "LogInViewController_ipad.h"
#import "SignViewController_iPad.h"

@class PasscodeCheckViewController_iPad;
@class ipad_DateSelBillsViewController;
//--------iPad中最主要的代理
@interface AppDelegate_iPad : PokcetExpenseAppDelegate{
	
    ipad_MainViewController *mainViewController;
    PasscodeCheckViewController_iPad *passCodeCheckView;
//    ipad_DateSelBillsViewController *dateSelectedViewController;
  
}
@property(nonatomic,strong) UIView *touchBack;
@property (nonatomic, strong) ipad_MainViewController   *mainViewController;
@property (nonatomic, strong) PasscodeCheckViewController_iPad *passCodeCheckView;
@property(nonatomic,strong)UIView *close_PopView;
@property(nonatomic,strong)SignViewController_iPad *loginViewController;
//@property (nonatomic, strong) ipad_DateSelBillsViewController *dateSelectedViewController;

@property(nonatomic,strong)UIAlertView *transferAlertview;

-(void)afterpassword_IPAD;

-(void)succededInLogIn;
-(void)succededInSignUp;
@end


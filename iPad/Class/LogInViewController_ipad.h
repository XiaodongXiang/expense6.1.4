//
//  LogInViewController_ipad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/6/30.
//
//

#import <UIKit/UIKit.h>
#import "DRDynamicSlideShow_ipad.h"
#import <ParseUI/ParseUI.h>
@interface LogInViewController_ipad : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL isKeyboardUp;
    BOOL isNextTextFieldTouch;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *topBgLine;
@property (weak, nonatomic) IBOutlet UIView *bottomBgLine;
@property (weak, nonatomic) IBOutlet UIView *leftBgLine;
@property (weak, nonatomic) IBOutlet UIView *rightBgLine;
@property (weak, nonatomic) IBOutlet UIView *middleBgLine;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *forgetpasswordBtn;




@property (weak, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

-(IBAction)bgTouch;

@property (strong, nonatomic) DRDynamicSlideShow_ipad * slideShow;
@property (strong, nonatomic) NSArray * viewsForPages;

//@property(nonatomic,strong)id <PFLogInViewControllerDelegate> delegate;

@end

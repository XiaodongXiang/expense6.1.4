//
//  SettingViewController.h
//  PokcetExpense
//
//  Created by ZQ on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ParseUI/ParseUI.h>
@class SyncViewController;
@class SettingPayeeViewController,TransactionCategoryViewController;
@class ADSDeatailViewController;

@interface SettingViewController : UITableViewController 
<MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreLine1High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreLine2High;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passcodeLine1High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passcodeLine2High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currencyLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *generalLineHigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payeeLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payeeLine2High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryLineHigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syncLine1High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syncLine2High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exportLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backupLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataLineHigh;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionLine1High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionLine2High;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedbackLineHigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewLineHigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backupLineX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutLineHeight1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutLineHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exportLineWidth;



 
@property (nonatomic, strong) IBOutlet  UITableView         *settingTableView;
@property (nonatomic, strong) IBOutlet  UITableViewCell     *restorePurchaseCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*passcodeCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell     *currencyCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell     *generalCell;

@property (nonatomic, strong) IBOutlet  UITableViewCell		*payeeCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*categoryCell;

@property (nonatomic, strong) IBOutlet  UITableViewCell     *exportCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell     *backUpCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell     *transferDataCell;
@property (nonatomic, strong) IBOutlet  UIImageView         *exportImage;

@property (nonatomic, strong) IBOutlet  UITableViewCell		*appVersionCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*feedbackCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*reviewCell;
@property (nonatomic, strong) IBOutlet  UIImageView         *proImageViewl2;
@property (nonatomic, strong) IBOutlet  UIImageView         *proImageViewl3;

@property (strong, nonatomic) IBOutlet UITableViewCell *dropboxRestoreCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropboxRestoreLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropboxRestoreLineX;




//收费版
@property (nonatomic, strong) IBOutlet  UITableViewCell     *syncCell;
@property (weak, nonatomic) IBOutlet UISwitch *syncSwitch;

@property (strong, nonatomic) IBOutlet UITableViewCell *logOutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncNowCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syncNowLineX;
@property (weak, nonatomic) IBOutlet UIView *syncNowLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syncNowLineHeight;
@property (weak, nonatomic) IBOutlet UILabel *syncNowLabel;



@property (nonatomic, strong) IBOutlet  UILabel             *passcodeLabel;
@property (nonatomic, strong) IBOutlet  UILabel             *currencyLabel;
@property (nonatomic, strong) IBOutlet  UILabel             *symbolLabel;
@property (nonatomic, strong) IBOutlet  UILabel				*appVerseionLabel;
@property (nonatomic, strong) IBOutlet  UIActivityIndicatorView		* indicatorView;

@property (nonatomic, strong) IBOutlet  UILabel             *restoreLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *passcodeLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *currencyLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *generalText;
@property (nonatomic, strong) IBOutlet  UILabel             *payeeLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *categoryLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *syncLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *exportLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *backupLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *migrateDateLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *appVersionLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *sendFeedbackLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *reviewLabelText;

@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;


@property(nonatomic,strong)UIImageView *selectedImageView;

@property (nonatomic, strong) NSURL				* urlOpen;
@property(nonatomic,strong)SettingPayeeViewController *settingPayeeViewController;
@property(nonatomic,strong)TransactionCategoryViewController *transactionCategoryViewController;
@property(nonatomic,strong)SyncViewController *syncViewController;
@property(nonatomic,strong)ADSDeatailViewController *adsDetailViewController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actIndView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoutTopLineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoutBottomLineHeight;

- (void)passcodeViewControllerTurnOff;
-(void)refleshUI;
-(void)resetStyleWithAds;


 @end

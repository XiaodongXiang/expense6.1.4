//
//  ipad_SettingViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ipad_SettingPayeeViewController.h"
#import "ipad_TranscationCategorySelectViewController.h"
#import <ParseUI/ParseUI.h>
#import "XDIpad_ADSViewController.h"

@class ipad_SyncViewController;
@interface ipad_SettingViewController : UITableViewController<MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
{
    
    UITableView         *settingTableView;
    UITableViewCell     *restorePurchaseCell;
	UITableViewCell		*passcodeCell;
    UITableViewCell     *currencyCell;
    UITableViewCell     *generalCell;

    

    
	UITableViewCell		*payeeCell;
    UITableViewCell		*categoryCell;
    
    UITableViewCell     *exportCell;
    UITableViewCell     *backUpCell;
    UITableViewCell     *transferDataCell;
    
    UITableViewCell		*appVersionCell;
	UITableViewCell		*feedbackCell;
	UITableViewCell		*reviewCell;
    

    //收费版
    UITableViewCell     *syncCell;
    
    UIImageView         *backupandRestoreImage;
    UILabel             *passcodeLabel;
    UILabel             *currencyLabel;
    UILabel             *symbolLabel;
	UILabel				*appVerseionLabel;
	UIActivityIndicatorView		* indicatorView;
    
    UILabel             *restoreLabelText;
    UILabel             *passcodeLabelText;
    UILabel             *currencyLabelText;
    UILabel             *faqLabelText;
    UILabel             *payeeLabelText;
    UILabel             *categoryLabelText;
    UILabel             *syncLabelText;
    UILabel             *exportLabelText;
    UILabel             *backupLabelText;
    UILabel             *migrateDateLabelText;
    UILabel             *appVersionLabelText;
    UILabel             *sendFeedbackLabelText;
    UILabel             *reviewLabelText;
    UILabel             *generalText;
    
  	
	NSURL				* urlOpen;
    
    ipad_SettingPayeeViewController *iSettingPayeeViewController;
    ipad_TranscationCategorySelectViewController  *iTransactionCategoryViewController;
    ipad_ADSDeatailViewController *adsDetailViewController;
    
}

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

@property (nonatomic, strong) IBOutlet  UITableViewCell		*appVersionCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*feedbackCell;
@property (nonatomic, strong) IBOutlet  UITableViewCell		*reviewCell;
@property (nonatomic, strong) IBOutlet  UIImageView         *exportImage;
@property (weak, nonatomic) IBOutlet UILabel *syncNowLabel;

@property (strong, nonatomic) IBOutlet UITableViewCell *dropboxRestoreCell;
//收费版
@property (nonatomic, strong) IBOutlet  UITableViewCell     *syncCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;

@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;


@property (nonatomic, strong) IBOutlet  UILabel             *passcodeLabel;
@property (nonatomic, strong) IBOutlet  UILabel             *currencyLabel;
@property (nonatomic, strong) IBOutlet  UILabel             *symbolLabel;
@property (nonatomic, strong) IBOutlet  UILabel				*appVerseionLabel;
@property (nonatomic, strong) IBOutlet  UIActivityIndicatorView		* indicatorView;


@property (nonatomic, strong) IBOutlet  UILabel             *restoreLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *passcodeLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *currencyLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *faqLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *payeeLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *categoryLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *syncLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *exportLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *backupLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *migrateDateLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *appVersionLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *sendFeedbackLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *reviewLabelText;
@property (nonatomic, strong) IBOutlet  UILabel             *generalText;

@property (weak, nonatomic) IBOutlet UISwitch *syncSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncNowCell;

@property (nonatomic, strong) NSURL				* urlOpen;
@property(nonatomic,strong)ipad_SettingPayeeViewController *iSettingPayeeViewController;
@property(nonatomic,strong)ipad_TranscationCategorySelectViewController  *iTransactionCategoryViewController;
@property(nonatomic,strong)ipad_SyncViewController *iSyncViewController;
@property (nonatomic, strong) IBOutlet  UIImageView         *proImageViewl2;
@property (nonatomic, strong) IBOutlet  UIImageView         *proImageViewl3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appVersionLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exportLineH;


- (void)passcodeViewControllerTurnOff;
-(void)refleshUI;
-(void)hideOrShowAds;


@end

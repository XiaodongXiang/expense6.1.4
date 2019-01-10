//
//  SettingViewController.m
//  PokcetExpense
//
//  Created by ZQ on 9/7/10.
//  Copyright 2010 BHI Technologies, Inc. All rights reserved.
//

#import "SettingViewController.h"
#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"

//#import "SupportViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "OverViewWeekCalenderViewController.h"
#import "CurrencyTypeViewController.h"
#import "GTMBase64.h"

#import "BackUpAndRestoreViewController.h"

//#import "SettingGeneralViewController.h"
#import "SettingPayeeViewController.h"
//#import "SettingCategoryViewController.h"

#import "TransactionCategoryViewController.h"
#import "EmailViewController.h"

#import "AppDelegate_iPhone.h"

#import "ReportViewController.h"
#import "ADSDeatailViewController.h"

#import "PasscodeViewController_iPhone.h"
#import "PasscodeSettingViewController_iPhone.h"
#import "PasscodeStyle_iPhoneViewController.h"


#import "UIDevice.h"
#import "OverViewWeekCalenderViewController.h"
#import "KalViewController_week.h"
#import "KalLogic_week.h"
#import "KalDate_week.h"
#import "GeneralViewController.h"
#import <ParseUI/ParseUI.h>
#import "AboutViewController.h"
#import <Parse/Parse.h>
#import "FSMediaPicker.h"
#import "User.h"
#import "AppDelegate_iPhone.h"
#import "ParseDBManager.h"
#import "HMJActivityIndicator.h"
#import "XDSignInViewController.h"
#import "XDUpgradeViewController.h"
#import "XDOurAppsViewController.h"
#import "XDShareLinkViewController.h"

@import Firebase;

@interface SettingViewController()<FSMediaPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *profileIconBtn;

@property (weak, nonatomic) IBOutlet UILabel *profileEmail;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLbl;
@property (strong, nonatomic) IBOutlet UITableViewCell *upgradeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncChildCell;
@property (weak, nonatomic) IBOutlet UILabel *syncingLbl;
@property (weak, nonatomic) IBOutlet UILabel *exprieDateLbl;
@property (strong, nonatomic) IBOutlet UITableViewCell *ourAppCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *profileCell;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UIButton *noPurchasedProfileIcon;
@property (weak, nonatomic) IBOutlet UILabel *noPurchasedEmail;
@property (weak, nonatomic) IBOutlet UILabel *noPurchasedSyncTimeLbl;
@property (strong, nonatomic) IBOutlet UITableViewCell *noPurchasedProfileCell;

@property (weak, nonatomic) IBOutlet UIView *redPointView;
@property (weak, nonatomic) IBOutlet UIView *shareRedPointView;

@property (strong, nonatomic) IBOutlet UITableViewCell *signOutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sharelinkCell;
@property (weak, nonatomic) IBOutlet UIImageView *unUpgradeImgV;

@end

@implementation SettingViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark view life cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(settingReloadData) name:@"settingReloadData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetStyleWithAds) name:@"hideProImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingReloadData) name:@"refreshSettingUI" object:nil];
    [FIRAnalytics setScreenName:@"setting_view_iphone" screenClass:@"SettingViewController"];

    [self initPoint];
    [self initNavStyle];
    [self initTableCellStyle];
    [self initSwitch];
	_appVerseionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    AppDelegate_iPhone *appdelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appdelegate.overViewController.settingViewController = self;

    //logout

    [_logOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];

    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
    
    self.profileIconBtn.layer.cornerRadius = self.noPurchasedProfileIcon.layer.cornerRadius = 20;
    self.profileIconBtn.layer.masksToBounds = self.noPurchasedProfileIcon.layer.masksToBounds = YES;
    
    PFUser *user=[PFUser currentUser];
    self.profileEmail.text = self.noPurchasedEmail.text = user.username;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
    UIImage *image=[[UIImage alloc]initWithData:imageData];
    if (imageData) {
        [self.profileIconBtn setImage:image forState:UIControlStateNormal];
        [self.noPurchasedProfileIcon setImage:image forState:UIControlStateNormal];
    }
    
    
    User* ur = [[[XDDataManager shareManager]getObjectsFromTable:@"User"]lastObject];
    
    self.lastTimeLbl.text = self.noPurchasedSyncTimeLbl.text = [self returnDateFormatter:ur.syncTime];
    [self.noPurchasedProfileIcon addTarget:self action:@selector(profileIconClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE_X) {
        self.profileImgView.image = [UIImage imageNamed:@"purchase_lifetime_vip_8"];
        self.unUpgradeImgV.image = [UIImage imageNamed:@"setting_ads_2"];

    }else if (IS_IPHONE_6){
        self.profileImgView.image = [UIImage imageNamed:@"purchase_lifetime_vip_8"];
        self.unUpgradeImgV.image = [UIImage imageNamed:@"setting_ads_2"];

    }else if (IS_IPHONE_6PLUS){
        self.profileImgView.image = [UIImage imageNamed:@"purchase_lifetime_vip_plus"];
        self.unUpgradeImgV.image = [UIImage imageNamed:@"setting_ads_plus"];

    }else{
        self.profileImgView.image = [UIImage imageNamed:@"purchase_lifetime_vip_se"];
        self.unUpgradeImgV.image = [UIImage imageNamed:@"setting_ads_se"];

    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstEnterOursApp"]) {
        self.redPointView.layer.cornerRadius = 5;
        self.redPointView.layer.masksToBounds = YES;
        self.redPointView.hidden = NO;
    }else{
        self.redPointView.hidden = YES;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstEnterShareLink"]) {
        self.shareRedPointView.layer.cornerRadius = 5;
        self.shareRedPointView.layer.masksToBounds = YES;
        self.shareRedPointView.hidden = NO;
    }else{
        self.shareRedPointView.hidden = YES;
    }
    
}



-(void)settingReloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];

    });
    //
//    Setting* setting = [[XDDataManager shareManager] getSetting];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
//
//    self.exprieDateLbl.text  = [NSString stringWithFormat:@"Renews :%@",expiredString];
}


-(NSString*)returnDateFormatter:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([date compare:[NSDate dateWithTimeIntervalSince1970:0]] == NSOrderedSame) {
        return [NSString stringWithFormat:@"Last Sync: %@",[formatter stringFromDate:[NSDate date]]];
    }
    
    return [NSString stringWithFormat:@"Last Sync: %@",[formatter stringFromDate:date]];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_logOutBtn setTitle:NSLocalizedString(@"VC_LOG OUT", nil) forState:UIControlStateNormal];

    [super viewWillAppear:animated];
    self.settingPayeeViewController = nil;
    self.transactionCategoryViewController = nil;
    
    [self setContex];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.adsView.hidden = YES;
    [self resetStyleWithAds];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

}





-(void)resetStyleWithAds
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate_iPhone.isPurchased)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        _proImageViewl2.hidden = NO;
        _proImageViewl3.hidden = NO;
        if ([appDelegate.settings.others17 isEqualToString:@"4.5"])
        {
//            _proImageViewl3.hidden = YES;
        }
    }
    //如果内购成功，三种功能都要被使用
    else
    {
        _proImageViewl2.hidden = YES;
        _proImageViewl3.hidden = YES;
    }
    [_settingTableView reloadData];
    
}

- (IBAction)profileIconClick:(id)sender {
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = (FSMediaType)0;
    mediaPicker.editMode = (FSEditMode)0;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];

}

-(void)refleshUI{
    if (self.settingPayeeViewController != nil) {
        [self.settingPayeeViewController refleshUI];
    }
    else if (self.transactionCategoryViewController != nil){
        [self.transactionCategoryViewController refleshUI];
    }
    else
    {
        self.transactionCategoryViewController = nil;
        self.settingPayeeViewController = nil;
    }
}



#pragma mark custom API
-(void)initSwitch
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [_syncSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    if (appDelegate.autoSyncOn)
    {
        [_syncSwitch setOn:YES];
    }
    else
    {
        [_syncSwitch setOn:NO];
    }
}
-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_Setting", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];

    [self.tableView setSeparatorColor:RGBColor(230, 230, 230)];
    
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
//    flexible.width = 6.f;
//
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 80, 44);
//    [back setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
//    [back.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
////    back.titleLabel.adjustsFontSizeToFitWidth = YES;
////    [back.titleLabel setMinimumScaleFactor:0];
//    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [back setBackgroundColor:[UIColor clearColor]];
//    [back setTitleColor:[UIColor colorWithRed:99/255.0 green:206/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [back setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
//    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.rightBarButtonItems = @[flexible,leftButton];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:[UIImage imageNamed:@"Return_icon_normal_setting"]];
}

-(void)initTableCellStyle
{
    _passcodeCell.textLabel.text = @"PASSCODE";
    _currencyCell.textLabel.text = @"CURRENCY";
    
    _payeeCell.textLabel.text =@"PAYEE";
    _categoryCell.textLabel.text =@"CATEGORY";

    _backUpCell.textLabel.text =@"BACKUP";
    _transferDataCell.textLabel.text =@"TRANSFER";
    
    _appVersionCell.textLabel.text = @"APPVERSION";
 	_feedbackCell.textLabel.text =@"FEEDBACK";
	_reviewCell.textLabel.text =@"REVIEW";
    
    _syncCell.textLabel.text = @"SYNC";

	_passcodeCell.textLabel.hidden = YES;
    _currencyCell.textLabel.hidden = YES;
    
	_payeeCell.textLabel.hidden =YES;
    _categoryCell.textLabel.hidden =YES;
    
    _transferDataCell.textLabel.hidden =YES;
	_backUpCell.textLabel.hidden =YES;
    
    _appVersionCell.textLabel.hidden = YES;
	_feedbackCell.textLabel.hidden =YES;
	_reviewCell.textLabel.hidden =YES;
    
    _syncCell.textLabel.hidden = YES;
 	

}

-(void)initPoint{
//    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

    _restoreLabelText.text = NSLocalizedString(@"VC_RestorePurchased", nil);
    
    _passcodeLabelText.text = NSLocalizedString(@"VC_Passcode", nil);
    _currencyLabelText.text= NSLocalizedString(@"VC_Currency", nil);
    _generalText.text = NSLocalizedString(@"VC_General", nil);
    
    _payeeLabelText.text = NSLocalizedString(@"VC_Payee", nil);
    _categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    
    _syncLabelText.text = NSLocalizedString(@"VC_Auto Sync", nil);
    _exportLabelText.text = NSLocalizedString(@"VC_Export Report", nil);
    _backupLabelText.text = NSLocalizedString(@"VC_Backup_Restore", nil);
    _migrateDateLabelText.text = NSLocalizedString(@"VC_MigrateData", nil);
    
    _appVersionLabelText.text = NSLocalizedString(@"VC_About", nil);
    _sendFeedbackLabelText.text = NSLocalizedString(@"VC_SendFeedback", nil);
    _reviewLabelText.text = NSLocalizedString(@"VC_WriteReview", nil);
    
    

  //  migrateDateLabelText.adjustsFontSizeToFitWidth = YES;
  //  [migrateDateLabelText setMinimumScaleFactor:0];
    _passcodeLabel.adjustsFontSizeToFitWidth = YES;
    [_passcodeLabel setMinimumScaleFactor:0];

    
    //设置背景图片
    self.restoreLine1High.constant = EXPENSE_SCALE;
    self.restoreLine2High.constant = EXPENSE_SCALE;

    self.passcodeLine1High.constant = EXPENSE_SCALE;
    self.passcodeLine2High.constant = EXPENSE_SCALE;
    self.currencyLineHigh.constant = EXPENSE_SCALE;
    self.generalLineHigh.constant = EXPENSE_SCALE;

    self.payeeLineHigh.constant = EXPENSE_SCALE;
    self.payeeLine2High.constant = EXPENSE_SCALE;
    self.categoryLineHigh.constant = EXPENSE_SCALE;

    self.syncLine1High.constant = EXPENSE_SCALE;
    self.syncLine2High.constant = EXPENSE_SCALE;
    self.exportLineHigh.constant = EXPENSE_SCALE;
    self.backupLineHigh.constant = EXPENSE_SCALE;
    self.dataLineHigh.constant = EXPENSE_SCALE;
    
    self.versionLine1High.constant = EXPENSE_SCALE;
    self.versionLine2High.constant = EXPENSE_SCALE;
    self.feedbackLineHigh.constant = EXPENSE_SCALE;
    self.reviewLineHigh.constant = EXPENSE_SCALE;
    
    self.logoutLineHeight1.constant=1/EXPENSE_SCALE;
    self.logoutLineHeight2.constant=1/EXPENSE_SCALE;
    
    self.logoutBottomLineHeight.constant=1/EXPENSE_SCALE;
    self.logoutTopLineHeight.constant=1/EXPENSE_SCALE;
    
    self.syncNowLineHeight.constant=1/EXPENSE_SCALE;
    self.dropboxRestoreLineHeight.constant=1/EXPENSE_SCALE;
//    selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_cell_j_320_44_sel.png"]];
//    selectedImageView.frame = CGRectMake(0, 0, restorePurchaseCell.frame.size.width, restorePurchaseCell.frame.size.height);
//
//    
//    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    [restorePurchaseCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j4_320_44.png"]]];
//
//    [passcodeCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j1_320_44.png"]]];
//    [currencyCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j2_320_44.png"]]];
//    [generalCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j2_320_44.png"]]];
//
//    
//    [helpCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j3_320_45.png"]]];
//    [payeeCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j1_320_44.png"]]];
//    [categoryCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j3_320_45.png"]]];
//
//    [syncCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j1_320_44.png"]]];
//    [exportCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j2_320_44.png"]]];
//
//    if (!appDelegate.isPurchased)
//    {
//        [backUpCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j2_320_44.png"]]];
//    }
//    else
//        [backUpCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j3_320_45.png"]]];
//
//    [transferDataCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j3_320_45.png"]]];
//    [appVersionCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j1_320_44.png"]]];
//    [feedbackCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j2_320_44.png"]]];
//    [reviewCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_j3_320_45.png"]]];



    
//    [restorePurchaseCell setSelectedBackgroundView:selectedImageView];
//    [passcodeCell setSelectedBackgroundView:selectedImageView];
//    [currencyCell setSelectedBackgroundView:selectedImageView];
//    [budgetCell setSelectedBackgroundView:selectedImageView];
//    [helpCell setSelectedBackgroundView:selectedImageView];
//    [payeeCell setSelectedBackgroundView:selectedImageView];
//    [categoryCell setSelectedBackgroundView:selectedImageView];
//    [syncCell setSelectedBackgroundView:selectedImageView];
//    [exportCell setSelectedBackgroundView:selectedImageView];
//    [backUpCell setSelectedBackgroundView:selectedImageView];
//    [transferDataCell setSelectedBackgroundView:selectedImageView];
//    [appVersionCell setSelectedBackgroundView:selectedImageView];
//    [feedbackCell setSelectedBackgroundView:selectedImageView];
//    [reviewCell setSelectedBackgroundView:selectedImageView];

    
    

    
    
//    [LTHPasscodeViewController sharedUser].delegate = self;
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    _passcodeLabel.textColor = [appDelegate_iphone.epnc getGrayColor_156_156_156];
    _currencyLabel.textColor =[appDelegate_iphone.epnc getGrayColor_156_156_156];
    
    
    _proImageViewl2.hidden = YES;
    _proImageViewl3.hidden = YES;
    
    
    _backupLabelText.adjustsFontSizeToFitWidth = YES;
    [_backupLabelText setMinimumScaleFactor:0];
}

-(void)setContex{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.settings.passcodeStyle isEqualToString:@"none"] || appDelegate.settings.passcodeStyle == nil)
		self.passcodeLabel.text = NSLocalizedString(@"VC_OFF", nil);
	else if([appDelegate.settings.passcodeStyle isEqualToString:@"number"])
        self.passcodeLabel.text = NSLocalizedString(@"VC_Passcode", nil);
    else if ([appDelegate.settings.passcodeStyle isEqualToString:@"touchid"]){
        if (IS_IPHONE_X) {
            self.passcodeLabel.text=@"Face ID";
        }else{
            self.passcodeLabel.text=@"Touch ID";
        }
    }
        
    
    
	NSArray * seprateSrray = [appDelegate.settings.currency componentsSeparatedByString:@" - "];
	self.currencyLabel.text = [seprateSrray objectAtIndex:1];
    self.backupLineX.constant = 46.f;
    self.syncNowLineX.constant=46;
    self.dropboxRestoreLineX.constant=46;
}






#pragma mark Btn Action
-(void)showhHelp:(id)sender
{
//	HelpViewController *helpController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
// 	[self.navigationController pushViewController:helpController animated:YES];
//	[helpController release];

}

- (void) back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    AppDelegate_iPhone *appDelegate=(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    [appDelegate.menuVC reloadView];
}

#pragma mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{       
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Btn Action
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Pocket Expense Feedback"];
	[picker setToRecipients:[NSArray arrayWithObject:@"expense5@appxy.com"]];
	[picker setCcRecipients:nil];
	[picker setCcRecipients:nil];
    
	NSString * versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * deviceType = [[UIDevice currentDevice] systemName];
    NSString * deviceVersion = [[UIDevice currentDevice] systemVersion];
    NSString * deviceStr = [UIDevice platformString];
    
    NSString *liteorpro;
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(appDelegate.isPurchased)
    {
        liteorpro = @"Pur";
    }
    else
    {
        liteorpro = @"Lite";
    }
    NSString *mailBody = [NSString stringWithFormat:@"<html><body>App:v%@ %@<br/>%@：v%@<br/>Device: %@<br/>Feedback here: </body></html>", versionStr,liteorpro, deviceType, deviceVersion, deviceStr];
    
	
	[picker setMessageBody:mailBody isHTML:YES];
	[self presentViewController:picker animated:YES completion:nil];
}



#pragma mark passcode view Method
- (void)passcodeViewControllerTurnOff
{
    AppDelegate_iPhone *appDelegate =  (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	if ([appDelegate.settings.passcode length]>0) {
        _passcodeLabel.text = NSLocalizedString(@"VC_ON", nil);
    }
    else
        _passcodeLabel.text = NSLocalizedString(@"VC_OFF", nil);
}
//数据转移
-(void)CopyDataToFullVersion
{
        //获取本地文件的地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
    
        //创建一个压缩包
        ZipArchive *zip = [[ZipArchive alloc] init];
    
        NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:@"Expense5.zip"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
        }
        //压缩添加文件
        if ([zip CreateZipFile2:zipPath])
        {
            [zip addFileToZip:[NSString stringWithFormat:@"%@/Expense5.0.0.sqlite",documentsDirectory] newname:@"Expense5.0.0.sqlite"];
            NSString *path = [NSString stringWithFormat:@"%@/Expense5.0.0.sqlite-shm",documentsDirectory];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [zip addFileToZip:[NSString stringWithFormat:@"%@/Expense5.0.0.sqlite-shm",documentsDirectory] newname:@"Expense5.0.0.sqlite-shm"];
            }
            path = [NSString stringWithFormat:@"%@/Expense5.0.0.sqlite-wal",documentsDirectory];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [zip addFileToZip:[NSString stringWithFormat:@"%@/Expense5.0.0.sqlite-wal",documentsDirectory] newname:@"Expense5.0.0.sqlite-wal"];
            }
        }
        [zip CloseZipFile2];
    
    
    
        //将压缩文件转化成NSData数据类型进行转化
        NSData *fileData = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"Expense5.zip"]];
        NSLog(@"fileData:%@",fileData);
    
        NSString *encodedString = [GTMBase64 stringByWebSafeEncodingData:fileData padded:YES];
    
        NSString *urlString = [NSString stringWithFormat:@"Expense5://localhost/importDatabase?%@", encodedString];
    
        self.urlOpen = [NSURL URLWithString:urlString];
    
    	if([[UIApplication sharedApplication] canOpenURL:self.urlOpen])
    	{
    		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_Data Transfer", nil)
    															message:NSLocalizedString(@"VC_Please make sure that both the latest free and full version are on your device. Warning: This will replace all data in the Full Version!", nil)
    														   delegate:self
    												  cancelButtonTitle:nil
    												  otherButtonTitles:NSLocalizedString(@"VC_Cancel", nil),NSLocalizedString(@"VC_Transfer", nil),nil];
    		alertView.tag = 0;
    		[alertView show];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alertView;
    	}
    	else
    	{
    		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_No Full Version was found on this device!", nil)
    															message:NSLocalizedString(@"VC_Would you like to get the Full Version and then transfer data to it?", nil)
    														   delegate:self 
    												  cancelButtonTitle:NSLocalizedString(@"VC_No, thanks", nil)
    												  otherButtonTitles:NSLocalizedString(@"VC_OK", nil),nil];
    		alertView.tag = 1;
    		[alertView show];
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.appAlertView = alertView;
    	}
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 5;

}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    if (section==0)
    {
        return 4;
    }
    if(section ==1 )
        return 2;
    else if(section ==2)
        return 3;
    else if (section==3)
    {
        return 2;
    }
    else if(section==4)
    {
        return 2;
    }
    else
    
        return 1;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    //没购买
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(53, 50, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(230, 230, 230);
    
    if (!appDelegate.isPurchased) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return self.noPurchasedProfileCell;
            }else if(indexPath.row == 1){
                [self.sharelinkCell addSubview:view];
                return self.sharelinkCell;
                
            }else if (indexPath.row == 2){
                [_syncCell addSubview:view];
                return _syncCell;
            }else if (indexPath.row == 3){
//                [self.syncChildCell addSubview:view];
                return self.syncChildCell;
            }else if (indexPath.row == 4){
                [self.upgradeCell addSubview:view];
                return self.upgradeCell;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                [_payeeCell addSubview:view];
                return _payeeCell;
            }else if (indexPath.row == 1){
                [_categoryCell addSubview:view];
                return _categoryCell;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [_passcodeCell addSubview:view];
                return _passcodeCell;
            }else if (indexPath.row == 1){
                [_currencyCell addSubview:view];
                return _currencyCell;
            }else if (indexPath.row == 2){
                [_generalCell addSubview:view];
                return _generalCell;
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                [self.ourAppCell addSubview:view];
                return self.ourAppCell;
            }
            if (indexPath.row == 1){
                [_exportCell addSubview:view];
                return _exportCell;
            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                [_appVersionCell addSubview:view];
                return _appVersionCell;
            }else{
                return self.signOutCell;
            }
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (appDelegate.isPurchased) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG]) {
                        self.exprieDateLbl.text = @"";
                    }else{
                        Setting* setting = [[XDDataManager shareManager] getSetting];
                        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                        self.exprieDateLbl.text = [NSString stringWithFormat:@"Renews :%@",expiredString];
                        
                        if ([setting.otherBool18 boolValue] && [setting.otherBool16 boolValue]) {
                            self.exprieDateLbl.text = [NSString stringWithFormat:@"Expire Date :%@",expiredString];
                        }
                        
                        
                        NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:[NSDate date]];
                        comp.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                        comp.year = 2100;
                        comp.month = 1;
                        comp.day = 1;
                        NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comp];
                        if ([date compare:setting.purchasedEndDate] == NSOrderedAscending) {
                            self.exprieDateLbl.text = @"";
                        }
                    }
                }
                return self.profileCell;
            }else if(indexPath.row == 1){
                [self.sharelinkCell addSubview:view];
                return self.sharelinkCell;
                
            }else if (indexPath.row == 2){
                [_syncCell addSubview:view];
                return _syncCell;
            }else if (indexPath.row == 3){
                //                [self.syncChildCell addSubview:view];
                return self.syncChildCell;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                [_payeeCell addSubview:view];
                return _payeeCell;
            }else if (indexPath.row == 1){
                [_categoryCell addSubview:view];
                return _categoryCell;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [_passcodeCell addSubview:view];
                return _passcodeCell;
            }else if (indexPath.row == 1){
                [_currencyCell addSubview:view];
                return _currencyCell;
            }else if (indexPath.row == 2){
                [_generalCell addSubview:view];
                return _generalCell;
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                [self.ourAppCell addSubview:view];
                return self.ourAppCell;
            }
            if (indexPath.row == 1){
                [_exportCell addSubview:view];
                return _exportCell;
            }else{
                [self.sharelinkCell addSubview:view];
                return self.sharelinkCell;

            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                [_appVersionCell addSubview:view];
                return _appVersionCell;
            }else{
                return self.signOutCell;
            }
        }
        
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                [self sync];
            }
            if (indexPath.row == 0) {
                XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
                [self presentViewController:adsVc animated:YES completion:nil];
                
            }
            if (indexPath.row == 1) {
                XDShareLinkViewController* linkVc = [[XDShareLinkViewController alloc]initWithNibName:@"XDShareLinkViewController" bundle:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstEnterShareLink"];
                self.shareRedPointView.hidden = YES;
                [self presentViewController:linkVc animated:YES completion:nil];
            }
        }else if (indexPath.section == 1 ){
            if (indexPath.row == 0) {
                SettingPayeeViewController* vc = [[SettingPayeeViewController alloc] initWithNibName:@"SettingPayeeViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                TransactionCategoryViewController* vc = [[TransactionCategoryViewController alloc]initWithNibName:@"TransactionCategoryViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [self passcodeSetting];
            }else if (indexPath.row == 1){
                CurrencyTypeViewController* currencyController = [[CurrencyTypeViewController alloc] initWithStyle:UITableViewStylePlain];
                PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                currencyController.selectedCurrency = appDelegate.settings.currency;
                [self.navigationController pushViewController:currencyController animated:YES];
            }else{
                GeneralViewController *generalViewController = [[GeneralViewController alloc]initWithNibName:@"GeneralViewController" bundle:nil];
                [self.navigationController pushViewController:generalViewController animated:YES];
                
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                XDOurAppsViewController* ourVc = [[XDOurAppsViewController alloc]initWithNibName:@"XDOurAppsViewController" bundle:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstEnterOursApp"];
                self.redPointView.hidden = YES;
                [self presentViewController:ourVc animated:YES completion:nil];
            }
            if (appDelegate.isPurchased) {
                if (indexPath.row == 1) {
                    ReportViewController *reportViewController = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
                    [self.navigationController pushViewController:reportViewController animated:YES];
                }

            }else{

                if (indexPath.row == 1) {
                    XDUpgradeViewController* adsVc = [[XDUpgradeViewController alloc]initWithNibName:@"XDUpgradeViewController" bundle:nil];
                    [self presentViewController:adsVc animated:YES completion:nil];
                    
                }
                
            }
           
        }else if(indexPath.section == 4){
            if (indexPath.row == 0) {
                
                AboutViewController *aboutVC=[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }else{
                [self logout];
            }
        }else if (indexPath.section == 5){
             [self logout];
        }
    
    
	
 }
-(void)logout
{
    PokcetExpenseAppDelegate * appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isSyncing==YES && appDelegate.autoSyncOn==NO)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Data is syncing, please don't disconnect the internet and wait a moment, then try to sign out again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Sure to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign out", nil];
    [alertView show];
    alertView.tag=100;
}

//密码设定界面
-(void)passcodeSetting
{
    PasscodeStyle_iPhoneViewController *passcodeStyleVC=[[PasscodeStyle_iPhoneViewController alloc]initWithNibName:@"PasscodeStyle_iPhoneViewController" bundle:nil];
    [self.navigationController pushViewController:passcodeStyleVC animated:YES];
}
//进入到数字密码设定界面
-(void)handlePasscode
{
    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegete.settings.passcode length] > 0)
        
    {
        PasscodeViewController_iPhone* passcodeController = [[PasscodeViewController_iPhone alloc] initWithNibName:@"PasscodeViewController_iPhone" bundle:nil];
        passcodeController.setting = appDelegete.settings;
        passcodeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passcodeController animated:YES];
        
    }
    else
    {
        PasscodeSettingViewController_iPhone* passcodeSettingController = [[PasscodeSettingViewController_iPhone alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
        passcodeSettingController.setting = appDelegete.settings;
        passcodeSettingController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:passcodeSettingController animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (appDelegate.isPurchased) {
                return 145;
            }else{
                return 181;
                
            }
        }
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        if (_syncSwitch.on) {
            return 0.01;
        }else{
            return 51;
        }
    }
    
//    Setting * setting = [[XDDataManager shareManager]getSetting];
//    if ([setting.otherBool18 boolValue]) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            return 0.01;
        }
//    }

    return 51;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section==0) {
        return 0;
    }
    
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = RGBColor(246, 246, 246);
    return view;
    
}

#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (alertView.tag==200)
    {
        //restore dropbox
        if (buttonIndex==1)
        {
            if (appDelegate.dropbox.drop_account.isLinked)
            {
                
            }
            else
            {
                [appDelegate.dropbox.drop_accountManager linkFromController:self];
            }
        }
    }
    if(alertView.tag ==1000) return;
    if (alertView.tag==100)
    {
        if (buttonIndex == 1)
        {
            HMJActivityIndicator *indicatorView=[[HMJActivityIndicator alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, (SCREEN_HEIGHT-50)/2, 50, 50)];
            [indicatorView.indicator startAnimating];
            self.view.userInteractionEnabled=NO;
            [appDelegate.window addSubview:indicatorView];
            
            //在parse登出前记录下objectId
            NSString *lastUser=[[PFUser currentUser]objectId];
            
            [PFUser logOutInBackgroundWithBlock:^(NSError *error)
            {
                NSFetchRequest *requestLocal=[[NSFetchRequest alloc]init];
                NSEntityDescription *descLocal=[NSEntityDescription entityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
                requestLocal.entity=descLocal;
                NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:requestLocal error:&error];
                User *user=array[0];
                user.lastUser=lastUser;
                [appDelegate.managedObjectContext save:&error];
                
                
                //登出dropbox
                if ([appDelegate.dropbox.drop_account isLinked])
                {
                    [appDelegate.dropbox.drop_account unlink];
                    appDelegate.dropbox.drop_dataStore=nil;
                }
                
                [indicatorView removeFromSuperview];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                
                
            }];
            XDSignInViewController *signVC=[[XDSignInViewController alloc]init];
            appDelegate.window.rootViewController=signVC;
            
            Setting* setting = [[XDDataManager shareManager] getSetting];
            setting.purchasedProductID = nil;
            setting.purchasedStartDate = nil;
            setting.purchasedEndDate = nil;
            setting.dateTime = nil;
            setting.otherBool17 = nil;
            setting.purchasedIsSubscription = nil;
            setting.purchaseOriginalProductID = nil;
            setting.purchasedUpdateTime = nil;
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LITE_UNLOCK_FLAG];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_FIRST_UPLOAD_SETTING];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"invitedby"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shortURL"];

            
            appDelegate.isPurchased = NO;

            [[XDDataManager shareManager] saveContext];
            
            [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
        }
        return;
    }
	[self.indicatorView stopAnimating];
	
	if(buttonIndex == 0)
	{
		[self.indicatorView stopAnimating];
		return;
	}
	else
	{
        if(alertView.tag ==1)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
        else
            [[UIApplication sharedApplication] openURL:self.urlOpen];
	}
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - UISwitch事件
-(void)switchValueChanged
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.autoSyncOn=[_syncSwitch isOn];
    if (appDelegate.autoSyncOn)
    {
        if (!appDelegate.isSyncing)
        {
            [[ParseDBManager sharedManager]dataSyncWithServer];
            
            User* ur = [[[XDDataManager shareManager]getObjectsFromTable:@"User"]lastObject];
            
            self.lastTimeLbl.text = self.noPurchasedSyncTimeLbl.text = [self returnDateFormatter:ur.syncTime];
            
        }
        appDelegate.settings.syncAuto=[NSNumber numberWithBool:YES];
    }
    else
    {
        appDelegate.settings.syncAuto=[NSNumber numberWithBool:NO];
    }

    NSError *error;
    [appDelegate.managedObjectContext save:&error];
//
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)syncNowAnimation
{
    [self performSelector:@selector(animate1) withObject:nil afterDelay:0.0f];
    [self performSelector:@selector(animate2) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(animate3) withObject:nil afterDelay:0.6f];
    [self performSelector:@selector(animate4) withObject:nil afterDelay:0.9f];
    [self performSelector:@selector(judge) withObject:nil afterDelay:0.9f];
    
}
-(void)judge
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isSyncing)
    {
        [self performSelector:@selector(syncNowAnimation) withObject:nil afterDelay:0.3f];
    }
    else
    {
        [self performSelector:@selector(animate) withObject:nil afterDelay:0.1f];
    }
}
-(void)animate
{
    _syncNowLabel.text=@"Sync now";
}
-(void)animate1
{
    _syncNowLabel.text=@"Syncing";
}
-(void)animate2
{
    _syncNowLabel.text=@"Syncing.";
}
-(void)animate3
{
    _syncNowLabel.text=@"Syncing..";
}
-(void)animate4
{
    _syncNowLabel.text=@"Syncing...";
}

#pragma mark - FSMediaPickerDelegate
#pragma mark - FSMediaPicker Delegate
-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self.profileIconBtn setImage:mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage forState:UIControlStateNormal];
    [self.noPurchasedProfileIcon setImage:mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage forState:UIControlStateNormal];
    
    UIImage *avatarImage=mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage;
    //    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    
    NSData *imageData=UIImageJPEGRepresentation(avatarImage, 0.5);
    [imageData writeToFile:imageFile atomically:YES];
    
    PFUser *user=[PFUser currentUser];
    PFFile *photo=[PFFile fileWithName:[NSString stringWithFormat:@"avatar.jpg"] data:imageData];
    user[@"avatar"]=photo;
    [user saveInBackground];
}
-(void)setAvatarImage:(UIImage *)image
{
    [self.profileIconBtn setImage:image forState:UIControlStateNormal];
    [self.noPurchasedProfileIcon setImage:image forState:UIControlStateNormal];
}

#pragma mark - ..
-(void)restoreFromDropbox
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isSyncing)
    {
        NSLog(@"jjj");
        return;
    }
    
    UIAlertView *transferAlertview=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_It is highly recommended that transfer your data from Dropbox to new Expense if you have your latest data synced by Dropbox before.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) otherButtonTitles:NSLocalizedString(@"VC_Transfer", nil), nil];
    transferAlertview.tag=200;
    [self.view addSubview:transferAlertview];
    [transferAlertview show];
    
}

-(void)sync
{
    self.syncingLbl.text=@"Syncing...";

    [[ParseDBManager sharedManager]dataSyncWithSyncBtn:^(BOOL complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.syncingLbl.text=@"Sync";
            
            User* ur = [[[XDDataManager shareManager]getObjectsFromTable:@"User"]lastObject];
            
            self.lastTimeLbl.text = self.noPurchasedSyncTimeLbl.text = [self returnDateFormatter:ur.syncTime];
            
        });

    }];
    
    
}
@end

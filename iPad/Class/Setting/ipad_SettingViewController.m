//
//  ipad_SettingViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-5-19.
//
//

#import "ipad_SettingViewController.h"
#import "AppDelegate_iPad.h"
#import "PokcetExpenseAppDelegate.h"

#import "ipad_CurrencyTypeViewController.h"
#import "ipad_ReportViewController.h"
#import "BackUpAndRestoreViewController.h"
#import "GTMBase64.h"
#import "ipad_SyncViewController.h"

#import "PasscodeViewController_iPad.h"
#import "PasscodeSettingViewController_iPad.h"
#import "UIDevice.h"
#import "iPad_GeneralViewController.h"
#import "SignViewController_iPad.h"

#import <Parse/Parse.h>

#import "User.h"
#import "AppDelegate_iPad.h"
#import "ParseDBManager.h"
#import "HMJActivityIndicator.h"
#import "NSStringAdditions.h"
#import "PasscodeStyle_iPhoneViewController_iPad.h"
#import "AboutViewController_iPad.h"
#import "AppDelegate_iPhone.h"
#import "XDOurAppsViewController.h"
#import "XDShareLinkViewController.h"
#import "FSMediaPicker.h"
@import Firebase;
@interface ipad_SettingViewController ()<FSMediaPickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *profileIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *profileEmailLbl;
@property (weak, nonatomic) IBOutlet UILabel *renewsLbl;


@property (strong, nonatomic) IBOutlet UITableViewCell *premiumCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *oursAppCell;
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (strong, nonatomic) IBOutlet UITableViewCell *shareLinkCell;

@end

@implementation ipad_SettingViewController
@synthesize settingTableView,restorePurchaseCell,passcodeCell,currencyCell,payeeCell,exportCell,categoryCell,backUpCell,transferDataCell,appVersionCell,feedbackCell,reviewCell,syncCell,generalCell,passcodeLabel,currencyLabel,symbolLabel,appVerseionLabel,indicatorView,urlOpen,exportImage;
@synthesize iSettingPayeeViewController,iTransactionCategoryViewController;
@synthesize iSyncViewController;
@synthesize proImageViewl2,proImageViewl3;
@synthesize restoreLabelText,passcodeLabelText,currencyLabelText,faqLabelText,payeeLabelText,categoryLabelText,syncLabelText,exportLabelText,backupLabelText,migrateDateLabelText,appVersionLabelText,sendFeedbackLabelText,reviewLabelText,generalText;

- (IBAction)profileBtnClick:(id)sender {
    
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = (FSMediaType)0;
    mediaPicker.editMode = (FSEditMode)0;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.profileIconBtn];
}

#pragma mark - FSMediaPicker Delegate
-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self.profileIconBtn setImage:mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage forState:UIControlStateNormal];
    
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
}

#pragma mark view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initPoint];
    [self initNavStyle];
    [self initTableCellStyle];
    [self initSwitch];
	appVerseionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [_syncSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [_logOutBtn setBackgroundImage:[UIImage imageNamed:[NSString customImageName:@"btn_sign_out.png"]] forState:UIControlStateNormal];
    _logOutBtn.titleLabel.text=@"Log Out";
    [_logOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [FIRAnalytics setScreenName:@"setting_main_view_ipad" screenClass:@"ipad_SettingViewController"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstEnterOursApp"]) {
        self.redPoint.layer.cornerRadius = 5;
        self.redPoint.layer.masksToBounds = YES;
        self.redPoint.hidden = NO;
    }else{
        self.redPoint.hidden = YES;
    }
    
    self.profileEmailLbl.text = [PFUser currentUser].email;
    self.profileIconBtn.layer.cornerRadius = self.profileIconBtn.width/2;
    self.profileIconBtn.layer.masksToBounds = YES;
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageFile=[documentsDirectory stringByAppendingPathComponent:@"/avatarImage.jpg"];
    NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
    UIImage *image=[[UIImage alloc]initWithData:imageData];
    if (imageData) {
        [self.profileIconBtn setImage:image forState:UIControlStateNormal];
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.iTransactionCategoryViewController = nil;
    self.iSettingPayeeViewController = nil;
    [self setContex];
    [self hideOrShowAds];
}

-(void)refleshUI{
    if (self.iSettingPayeeViewController != nil) {
        [self.iSettingPayeeViewController refleshUI];
    }
    else if (self.iTransactionCategoryViewController!= nil){
        [self.iTransactionCategoryViewController refleshUI];
    }
}

#pragma mark InAppPurchase
//添加内购观察者
-(void)hideOrShowAds
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate_iPad.isPurchased)
    {
        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
        proImageViewl2.hidden = NO;
        proImageViewl3.hidden = NO;
        if ([appDelegate.settings.others17 isEqualToString:@"4.5"])
        {
//            proImageViewl3.hidden = YES;
        }
    }
    //如果内购成功，三种功能都要被使用
    else
    {
        proImageViewl2.hidden = YES;
        proImageViewl3.hidden = YES;
    }
    [settingTableView reloadData];
}


#pragma mark custom API
-(void)initSwitch
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
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
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible.width = -2.f;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	back.frame = CGRectMake(0, 0, 90, 30);
    [back setTitle:NSLocalizedString(@"VC_Done", nil) forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [back setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [back setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.rightBarButtonItems = @[flexible,leftButton];
    
   	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Setting", nil);
    self.navigationItem.titleView = titleLabel;
}

-(void)initTableCellStyle
{
    passcodeCell.textLabel.text = @"PASSCODE";
    currencyCell.textLabel.text = @"CURRENCY";
    
    payeeCell.textLabel.text =@"PAYEE";
    categoryCell.textLabel.text =@"CATEGORY";
    
    backUpCell.textLabel.text =@"BACKUP";
    transferDataCell.textLabel.text =@"TRANSFER";
    
    appVersionCell.textLabel.text = @"APPVERSION";
 	feedbackCell.textLabel.text =@"FEEDBACK";
	reviewCell.textLabel.text =@"REVIEW";
    
    syncCell.textLabel.text = @"SYNC";
    
	passcodeCell.textLabel.hidden = YES;
    currencyCell.textLabel.hidden = YES;
    
	payeeCell.textLabel.hidden =YES;
    categoryCell.textLabel.hidden =YES;
    
    transferDataCell.textLabel.hidden =YES;
	backUpCell.textLabel.hidden =YES;
    
    appVersionCell.textLabel.hidden = YES;
	feedbackCell.textLabel.hidden =YES;
	reviewCell.textLabel.hidden =YES;
    
    syncCell.textLabel.hidden = YES;
 	
    
}

-(void)initPoint{
    
    _syncNowLabel.text=NSLocalizedString(@"VC_Sync Now", nil);
    
//    restoreLabelText.text = NSLocalizedString(@"VC_RestorePurchased", nil);
    
    passcodeLabelText.text = NSLocalizedString(@"VC_Passcode", nil);
    currencyLabelText.text= NSLocalizedString(@"VC_Currency", nil);
    faqLabelText.text = NSLocalizedString(@"VC_FAQ", nil);
    
    payeeLabelText.text = NSLocalizedString(@"VC_Payee", nil);
    categoryLabelText.text = NSLocalizedString(@"VC_Category", nil);
    
    syncLabelText.text = NSLocalizedString(@"VC_Auto Sync", nil);
    exportLabelText.text = NSLocalizedString(@"VC_Export Report", nil);
    backupLabelText.text = NSLocalizedString(@"VC_Backup_Restore", nil);
    migrateDateLabelText.text = NSLocalizedString(@"VC_MigrateData", nil);
    
    appVersionLabelText.text = NSLocalizedString(@"VC_AppVersion", nil);
    sendFeedbackLabelText.text = NSLocalizedString(@"VC_SendFeedback", nil);
    reviewLabelText.text = NSLocalizedString(@"VC_WriteReview", nil);
    generalText.text = NSLocalizedString(@"VC_General", nil);
    


    _logOutBtn.titleLabel.text=NSLocalizedString(@"VC_LOG OUT", nil);
    
    PokcetExpenseAppDelegate *appdelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    passcodeLabel.textColor = [appdelegate.epnc getGrayColor_156_156_156];
    currencyLabel.textColor =[appdelegate.epnc getGrayColor_156_156_156];
    _appVersionLineH.constant=EXPENSE_SCALE;
    _exportLineH.constant=EXPENSE_SCALE;
    proImageViewl2.hidden = YES;
    proImageViewl3.hidden = YES;

    
    //这里要判断是不是给老用户权限
    proImageViewl2.hidden = NO;
    proImageViewl3.hidden = NO;
    if ([appdelegate.settings.others17 isEqualToString:@"4.5"])
    {
//        proImageViewl3.hidden = YES;
    }
    
}

-(void)setContex{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.settings.passcodeStyle isEqualToString:@"none"] || appDelegate.settings.passcodeStyle == nil)
        self.passcodeLabel.text = NSLocalizedString(@"VC_OFF", nil);
    else if([appDelegate.settings.passcodeStyle isEqualToString:@"number"])
        self.passcodeLabel.text = NSLocalizedString(@"VC_Passcode", nil);
    else if ([appDelegate.settings.passcodeStyle isEqualToString:@"touchid"])
        self.passcodeLabel.text=@"Touch ID";
    
    
	NSArray * seprateSrray = [appDelegate.settings.currency componentsSeparatedByString:@" - "];
    //	self.symbolLabel.text = [NSString stringWithFormat:@"%@ -",[seprateSrray objectAtIndex:0]];
	self.currencyLabel.text = [seprateSrray objectAtIndex:1];
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
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    appDelegate_iPad.mainViewController.iSettingViewController = nil;
    if (appDelegate_iPad.mainViewController.currentViewSelect==0) {
        [appDelegate_iPad.mainViewController.overViewController refleshData];
    }
    else if (appDelegate_iPad.mainViewController.currentViewSelect==1){
        [appDelegate_iPad.mainViewController.iAccountViewController reFlashTableViewData];
    }
    else if(appDelegate_iPad.mainViewController.currentViewSelect ==2)
    {
        [appDelegate_iPad.mainViewController.iBudgetViewController reFlashTableViewData];
    }
    else if (appDelegate_iPad.mainViewController.currentViewSelect==3)
    {
        ;
    }
    else
    {
        [appDelegate_iPad.mainViewController.iBillsViewController reFlashBillModuleViewData];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *) [[UIApplication sharedApplication]delegate];
	if ([appDelegate.settings.passcode length]>0) {
        passcodeLabel.text = NSLocalizedString(@"VC_ON", nil);
    }
    else
        passcodeLabel.text = NSLocalizedString(@"VC_OFF", nil);
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
        return 6;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return 2;
    }
    if(section ==1 )
        return 3;
    else if(section ==2)
        return 2;
    else if (section==3)
    {
        return 2;
    }
    else if(section==4)
    {
        return 2;
    }else
        
        return 1;
    

    
}

-(NSString*)returnDateFormatter:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([date compare:[NSDate dateWithTimeIntervalSince1970:0]] == NSOrderedSame) {
        return [NSString stringWithFormat:@"Last Sync: %@",[formatter stringFromDate:[NSDate date]]];
    }
    
    return [NSString stringWithFormat:@"Last Sync: %@",[formatter stringFromDate:date]];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _topLineH.constant=EXPENSE_SCALE;
    _bottomLineH.constant=EXPENSE_SCALE;

    //购买了
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!appDelegate.isPurchased){
                return restorePurchaseCell;
            }else{
                if (appDelegate.isPurchased) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:LITE_UNLOCK_FLAG]) {
                        self.renewsLbl.text = @"";
                    }else{
                        Setting* setting = [[XDDataManager shareManager] getSetting];
                        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSString* expiredString = [formatter stringFromDate:setting.purchasedEndDate];
                        self.renewsLbl.text = [NSString stringWithFormat:@"Renews :%@",expiredString];
                        
                        if ([setting.otherBool18 boolValue] && [setting.otherBool16 boolValue]) {
                            self.renewsLbl.text = [NSString stringWithFormat:@"Expire Date :%@",expiredString];
                        }
                    }
                }
                
                return self.premiumCell;
            }
        }else{
            return self.shareLinkCell;
        }
    }else if(indexPath.section ==1)
    {
        
        if(indexPath.row == 0)
            return passcodeCell;
        else if(indexPath.row == 1)
            return currencyCell;
        else
            return generalCell;
    }
    else if(indexPath.section ==2)
        
    {
        if(indexPath.row == 0)
            return payeeCell;
        else if(indexPath.row == 1)
            return categoryCell;
    } else  if(indexPath.section==3)
    {
        if(indexPath.row==0)
            return syncCell;
        else if(indexPath.row==1)
        {
            return exportCell;
        }
        
    }else if (indexPath.section==4)
    {
        if (indexPath.row == 0) {
            return appVersionCell;
        }else{
            return self.oursAppCell;
        }
    }
    
    
    return _logoutCell;


    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0) {
            [self backWithPopAdasDetailViewController];
        }else{
            
            XDShareLinkViewController* linkVc = [[XDShareLinkViewController alloc]initWithNibName:@"XDShareLinkViewController" bundle:nil];
            
            linkVc.modalPresentationStyle = UIModalPresentationFormSheet;
            linkVc.preferredContentSize = CGSizeMake(375, 667);
            AppDelegate_iPad *appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            [self dismissViewControllerAnimated:YES completion:nil];
            [appDelegate1.mainViewController presentViewController:linkVc animated:YES completion:nil];
            
        }
    }
    
    if(indexPath.section ==1)
    {
        if(indexPath.row == 0)
        {
            [self handlePasscode];
        }
        else if(indexPath.row == 1)
        {
            ipad_CurrencyTypeViewController* currencyController = [[ipad_CurrencyTypeViewController alloc] initWithStyle:UITableViewStylePlain];
            currencyController.selectedCurrency = appDelegate.settings.currency;
            [self.navigationController pushViewController:currencyController animated:YES];
        }
        else
        {
            iPad_GeneralViewController *generalViewController = [[iPad_GeneralViewController alloc]initWithNibName:@"iPad_GeneralViewController" bundle:nil];
            [self.navigationController pushViewController:generalViewController animated:YES];
        }
    }
    
    if(indexPath.section == 3 && indexPath.row == 1)
    {
        if (appDelegate.isPurchased) {
            ipad_ReportViewController *reportViewController = [[ipad_ReportViewController alloc]initWithNibName:@"ipad_ReportViewController" bundle:nil];
            [self.navigationController pushViewController:reportViewController animated:YES];
        }else{
            [self backWithPopAdasDetailViewController];
        }
    }
    //第四section
    if(indexPath.section==4)
    {
        if (indexPath.row==0)
        {
            AboutViewController_iPad *aboutViewController=[[AboutViewController_iPad alloc]initWithNibName:@"AboutViewController_iPad" bundle:nil];
            [self.navigationController pushViewController:aboutViewController animated:YES];
            
        }else if (indexPath.row==1){
            
            XDOurAppsViewController* ourVc = [[XDOurAppsViewController alloc]initWithNibName:@"XDOurAppsViewController" bundle:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstEnterOursApp"];
            self.redPoint.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isFirstEnterPOursAppVc" object:nil];
            
            [self.navigationController pushViewController:ourVc animated:YES];
            
        }
        
    }
    
    if (indexPath.section == 5) {
        if (indexPath.row==0)
        {
            [self logout];
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)handlePasscode
{
    PasscodeStyle_iPhoneViewController_iPad *passcodeStyleVC=[[PasscodeStyle_iPhoneViewController_iPad alloc]initWithNibName:@"PasscodeStyle_iPhoneViewController_iPad" bundle:nil];
    [self.navigationController pushViewController:passcodeStyleVC animated:YES];}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.isPurchased)
    {
        if (indexPath.section==0 && indexPath.row==0)
        {
            return 45;
        }
        else if (indexPath.section==0 && indexPath.row==2)
            return 45;
        else if (indexPath.section==1 && indexPath.row==2)
            return 45;
        else if (indexPath.section==2 && indexPath.row==1)
            return 45;
        else if (indexPath.section==4 && indexPath.row==2)
            return 45;
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 145;
        }
        if (indexPath.section==0 && indexPath.row==2)
        {
            return 45;
        }
        else if (indexPath.section==1 && indexPath.row==1)
            return 45;

        else if (indexPath.section==3 && indexPath.row==2)
            return 45;
        else if (indexPath.section==2 &&indexPath.row==3)
            return 45;
  
    }
    
    
    return 45;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01f;
    }
    else
        return 25.f;
}

-(void)backWithPopAdasDetailViewController
{
    AppDelegate_iPad *appDelegate1 = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    XDIpad_ADSViewController* adsDetailViewController = [[XDIpad_ADSViewController alloc]initWithNibName:@"XDIpad_ADSViewController" bundle:nil];
    adsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    adsDetailViewController.preferredContentSize = CGSizeMake(390, 600);
    [appDelegate1.mainViewController presentViewController:adsDetailViewController animated:YES completion:nil];
}
#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (alertView.tag==200)
    {
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

            HMJActivityIndicator *indicatorview=[[HMJActivityIndicator alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, (SCREEN_HEIGHT-50)/2, 50, 50)];
            [indicatorview.indicator startAnimating];
            self.view.userInteractionEnabled=NO;
            [appDelegate.window addSubview:indicatorview];
            
            NSString *lastUser=[[PFUser currentUser]objectId];


            
            [PFUser logOutInBackgroundWithBlock:^(NSError *error)
             {
                 PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
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
                
                 [self.navigationController popToRootViewControllerAnimated:YES];
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                 
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

                 [[XDDataManager shareManager] saveContext];
                 
                 [[XDDataManager shareManager] openWidgetInSettingWithBool14:NO];
                 
                 appDelegate.isPurchased = NO;
                 [indicatorview removeFromSuperview];
                 
                 SignViewController_iPad *loginViewController=[[SignViewController_iPad alloc]init];
                 AppDelegate_iPad *appDelegate_iPhone = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
                 appDelegate_iPhone.window.rootViewController=loginViewController;

                 
             }];
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
#pragma mark - SingUpVC delegate

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - UISwitch 方法
-(void)switchValueChanged
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.autoSyncOn=[_syncSwitch isOn];
    if (appDelegate.autoSyncOn)
    {
        if (!appDelegate.isSyncing)
        {
            [[ParseDBManager sharedManager]dataSyncWithServer];
        }
        appDelegate.settings.syncAuto=[NSNumber numberWithBool:YES];
    }
    else
    {
        appDelegate.settings.syncAuto=[NSNumber numberWithBool:NO];
    }
    [self.settingTableView reloadData];
    NSError *error;
    [appDelegate.managedObjectContext save:&error];
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
    _syncNowLabel.text=NSLocalizedString(@"VC_Sync Now", nil);;
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
-(void)restoreFromDropbox
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isSyncing)
    {
        return;
    }
    
    UIAlertView *transferAlertview=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"VC_It is highly recommended that transfer your data from Dropbox to new Expense if you have your latest data synced by Dropbox before.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil) otherButtonTitles:NSLocalizedString(@"VC_Transfer", nil), nil];
    transferAlertview.tag=200;
    [self.view addSubview:transferAlertview];
    [transferAlertview show];
    
}

@end

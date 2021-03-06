//
//  XDShareLinkViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/12/26.
//

#import "XDShareLinkViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <Parse/Parse.h>
#import "PokcetExpenseAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
//#import <FirebaseDatabase/FirebaseDatabase.h>

@import Firebase;

typedef void(^SucceessBlock)(BOOL success, NSString* text);

@interface XDShareLinkViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bj;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTopL;
@property (weak, nonatomic) IBOutlet UILabel *shareLinkCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeLeading;

@property(nonatomic, strong)NSURL* url;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *alphaView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end

@implementation XDShareLinkViewController

- (IBAction)cancelShareClick:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomView.y = ISPAD?667:SCREEN_HEIGHT;
        self.alphaView.alpha = 0;
    }completion:^(BOOL finished) {
        self.alphaView.hidden = YES;
    }];
    
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapDismiss:(id)sender {
    [self cancelShareClick:nil];
}

- (IBAction)shareLinkClick:(id)sender {
    self.alphaView.hidden = NO;

    [UIView animateWithDuration:0.2 animations:^{
        if (IS_IPHONE_X) {
            self.bottomView.y = SCREEN_HEIGHT - 211;
        }else{
            if (ISPAD) {
                self.bottomView.y = 490;
            }else{
                self.bottomView.y = SCREEN_HEIGHT - 177;
            }
        }
        
        self.alphaView.alpha = 1;
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        self.bj.image = [UIImage imageNamed:@"sharelink_bj_x"];
        self.cancelTopL.constant = 40;
    }else if (IS_IPHONE_5){
        self.bj.image = [UIImage imageNamed:@"sharelink_bj_se"];
    }else if (IS_IPHONE_6PLUS){
        self.bj.image = [UIImage imageNamed:@"sharelink_bj_plus"];
    }else{
        self.bj.image = [UIImage imageNamed:@"sharelink_bj_8"];
    }
    
    [self.view addSubview:self.bottomView];
    
    if (ISPAD) {
        self.bottomView.frame = CGRectMake(0, 667, 375, 211);
    }else{
        self.bottomView.frame = CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH, 211);
    }
    
    NSURL* url = [[NSUserDefaults standardUserDefaults] URLForKey:@"shortURL"];
    if (url.absoluteString.length > 0 && url) {
        self.shareLinkCode.text = url.absoluteString;
        self.url = url;
    }else{
        [self createLink];
    }
}

-(void)createLink{
    NSString* uid = [PFUser currentUser].objectId;
    NSURL *link = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://pocketexpenselite.page.link/EBMe/?invitedby=%@",uid]];
    NSString *dynamicLinksDomain = @"pocketexpenselite.page.link";
    FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc] initWithLink:link domain:dynamicLinksDomain];
    linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
                                 initWithBundleID:@"com.btgs.pocketexpenselite"];
//    linkBuilder.iOSParameters.minimumAppVersion = @"6.2.4";
    linkBuilder.iOSParameters.appStoreID = @"424575621";
    
    
    linkBuilder.socialMetaTagParameters = [[FIRDynamicLinkSocialMetaTagParameters alloc] init];
    linkBuilder.socialMetaTagParameters.title = @"Pocket Expense 6";
    linkBuilder.socialMetaTagParameters.descriptionText = @"See where your money goes.";
    linkBuilder.socialMetaTagParameters.imageURL = [NSURL URLWithString:@"http://onemoreuserheaderimage.oss-cn-beijing.aliyuncs.com/expense.png"];
    
    [linkBuilder shortenWithCompletion:^(NSURL * _Nullable shortURL,
                                         NSArray<NSString *> * _Nullable warnings,
                                         NSError * _Nullable error) {
        if (error || shortURL == nil) { return; }
        
        [[NSUserDefaults standardUserDefaults] setURL:shortURL forKey:@"shortURL"];
        self.shareLinkCode.text = shortURL.absoluteString;
        self.url = shortURL;
    }];
}



-(void)invite:(NSURL*)url{
    NSString* subject = @"Join me at Pocket Expense";
    NSString* inviteLink = url.absoluteString;
    
    NSString* message = [NSString stringWithFormat:@"<p>I'm using Pocket Expense. Join me and see how easy to manage personal finance. <a href=\"\%@\" target=%@>%@</a></p>",inviteLink,inviteLink,inviteLink];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:subject];
        [picker setMessageBody:message isHTML:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)MessageClick:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController* vc = [[MFMessageComposeViewController alloc]init];
        vc.body = [NSString stringWithFormat:@"%@",self.url.absoluteString];
        vc.messageComposeDelegate = self;
        vc.title = @"I'm using Pocket Expense. Join me and see how easy to manage personal finance.";
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

- (IBAction)mailClick:(id)sender {
    [self invite:self.url];
}

- (IBAction)copyClick:(id)sender {
    if (self.url) {
        
        UIPasteboard* paste = [UIPasteboard generalPasteboard];
        paste.URL = self.url;
        
        MBProgressHUD* hub = [[MBProgressHUD alloc]initWithView:self.view];
        hub.label.text = @"Copy Success";
        hub.mode = MBProgressHUDModeText;
        [self.view addSubview:hub];
        [hub showAnimated:YES];
        [hub hideAnimated:YES afterDelay:1.5];
        [self cancelShareClick:nil];
    }
    

}

- (IBAction)moreClick:(id)sender {
    [self cancelShareClick:nil];
    if (self.url) {
        
        NSString *textToShare = @"I'm using Pocket Expense. Join me and see how easy to manage personal finance.";
        NSURL *urlToShare = self.url;
        NSArray *items = @[textToShare,urlToShare];
        
        [self mq_share:items target:self success:^(BOOL success, NSString *text) {
            if (success) {
                
//                MBProgressHUD* hub = [[MBProgressHUD alloc]initWithView:self.view];
//                hub.label.text = @"Share Success";
//                hub.mode = MBProgressHUDModeText;
//                [self.view addSubview:hub];
//                [hub showAnimated:YES];
//                [hub hideAnimated:YES afterDelay:1.0];
                
                [self cancelShareClick:nil];
            }
            
        }];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)mq_share:(NSArray *)items target:(id)target success:(SucceessBlock)successBlock {
    if (items.count == 0 || target == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll];
    //    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
    //        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    //    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
    //        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeOpenInIBooks];
    //    }else {
    //        activityVC.excludedActivityTypes = @[UIActivityTypeMessage];
    //    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        if (completed) {
            if (successBlock) {
                successBlock(YES, [NSString stringWithFormat:@"%@",activityType]);
            }
        }else {
            if (successBlock) {
                successBlock(NO, @"");
            }
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = target;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = self.shareBtn.frame;
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

@end

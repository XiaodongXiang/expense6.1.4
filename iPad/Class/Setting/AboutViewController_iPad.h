//
//  AboutViewController_iPad.h
//  PocketExpense
//
//  Created by 刘晨 on 16/2/16.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController_iPad : UIViewController
<MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableViewCell *reviewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *privacyCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTopLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedbackBottomLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateTopLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyBottomLineH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedbackBottomLineDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyBottomLineDown;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDetail;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackDetail;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyLabel;

@end

//
//  AboutViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/12/17.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface AboutViewController : UIViewController
<MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *topBg;
@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property (strong, nonatomic) IBOutlet UITableViewCell *reviewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *shareCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *disclaimerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *privacyCell;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (strong, nonatomic) IBOutlet UIView *reviewTopLine;
@property (strong, nonatomic) IBOutlet UIView *feedbackBottomLine;
@property (strong, nonatomic) IBOutlet UIView *updateTopLine;
@property (strong, nonatomic) IBOutlet UIView *policyBottomLine;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewtoplineW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *feedbackbottomlineW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *updatetoplineW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *policybottomlineW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewbottomlineH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *feedbackbottomlineH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *updatetoplineH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *privacybottomlineH;

@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDetail;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackDetail;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyLabel;



@end

//
//  AboutViewController_iPad.m
//  PocketExpense
//
//  Created by 刘晨 on 16/2/16.
//
//

#import "AboutViewController_iPad.h"
#import "UIDevice.h"
#import "policyViewController.h"
#import "iPad_historyViewController.h"
#import "AppDelegate_iPad.h"

@interface AboutViewController_iPad ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AboutViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableviewSet];
    [self initPoint];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1]];

}
-(void)initPoint
{
    _reviewLabel.text=NSLocalizedString(@"VC_WriteReview", nil);
    _reviewDetail.text=NSLocalizedString(@"VC_If you like this app, please rate and review.", nil);
    _feedbackLabel.text=NSLocalizedString(@"VC_SendFeedback", nil);
    _feedbackDetail.text=NSLocalizedString(@"VC_Send us some questions and suggestions.", nil);
    _updateLabel.text=NSLocalizedString(@"VC_Update History", nil);
    _policyLabel.text=NSLocalizedString(@"VC_Privacy Policy", nil);
}
-(void)tableviewSet
{
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
#pragma mark - TabelVeiew方法
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 53;
    }
    else
    {
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                _reviewTopLineH.constant=EXPENSE_SCALE;
                return _reviewCell;
                break;
            default:
                _feedbackBottomLineH.constant=EXPENSE_SCALE;
                _feedbackBottomLineDown.constant=-EXPENSE_SCALE;
                return _feedbackCell;
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                _updateTopLineH.constant=EXPENSE_SCALE;
                return _updateCell;
                break;
            default:
                _privacyBottomLineH.constant=EXPENSE_SCALE;
                _privacyBottomLineDown.constant=-EXPENSE_SCALE;
                return _privacyCell;
                break;
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor=[UIColor blackColor];
    return view;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor=[UIColor blackColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate_iPad *appdelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
//            if (appdelegate.isPurchased)
//            {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense-lite/id830063876?mt=8"]];
//            }
//            else
//            {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/pocket-expense-personal-finance/id424575621?mt=8"]];
//            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/pocket-expense-personal-finance/id424575621?action=write-review"]];


        }
        else if (indexPath.row==1)
        {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_No Mail Accounts", nil) message:NSLocalizedString(@"VC_Please set up a mail account in order to send mail.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
                    [alertView show];
                    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
                    appDelegate.appAlertView = alertView;
                }
            }
            
        }
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==1)
        {
            policyViewController *policyVC=[[policyViewController alloc]initWithNibName:@"policyViewController" bundle:nil];
            [self.navigationController pushViewController:policyVC animated:YES];
        }
        if (indexPath.row==0)
        {
            iPad_historyViewController *historyVC=[[iPad_historyViewController alloc]initWithNibName:@"iPad_historyViewController" bundle:nil];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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

#pragma mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

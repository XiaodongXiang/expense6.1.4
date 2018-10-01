//
//  AccountSearchViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV on 13-12-18.
//
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class HMJTextField;
@interface AccountSearchViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,SWTableViewCellDelegate>
{
    BOOL                    firsttobeHere;
}
@property (weak, nonatomic) IBOutlet UIImageView *searchBg;

@property(nonatomic,strong)IBOutlet UITableView             *asvc_tableView;
@property(nonatomic,strong)NSDateFormatter                  *outputFormatter;

@property (weak, nonatomic) IBOutlet UITextField *asvc_textField;


@property(nonatomic,strong)NSMutableArray                   *asvc_transactionArray;
@property(nonatomic,assign)NSInteger               swipCellIndex;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtnClick:(id)sender;

-(void)refleshUI;
-(IBAction)textfieldTextChanged:(HMJTextField *)textField;
@end

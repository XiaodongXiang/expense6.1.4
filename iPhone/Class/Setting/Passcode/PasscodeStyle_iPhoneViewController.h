//
//  PasscodeStyle_iPhoneViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/8.
//
//

#import <UIKit/UIKit.h>

@interface PasscodeStyle_iPhoneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *noneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *numberCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *touchIDCell;
@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
-(void)checkmarkInit;
@end

//
//  PasscodeStyle_iPhoneViewController_iPad.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/20.
//
//

#import <UIKit/UIKit.h>

@interface PasscodeStyle_iPhoneViewController_iPad : UIViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *noneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *touchIDCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *numberCell;
@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;

@end

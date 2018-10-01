//
//  PersonalnfoViewController.h
//  PocketExpense
//
//  Created by 刘晨 on 16/2/1.
//
//

#import <UIKit/UIKit.h>

@interface PersonalnfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *netWorthLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *netWorthRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetRightLabel;

@end

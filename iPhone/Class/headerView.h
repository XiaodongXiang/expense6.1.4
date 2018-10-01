//
//  headerView.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/23.
//
//

#import <UIKit/UIKit.h>

@interface headerView : UIView
@property (strong, nonatomic) IBOutlet UILabel *networthLabel;
@property (strong, nonatomic) IBOutlet UILabel *budgetleftLabel;
@property (strong, nonatomic) IBOutlet UILabel *budgetLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *netWorth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userNameToTop;

@end

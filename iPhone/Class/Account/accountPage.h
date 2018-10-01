//
//  accountPage.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/11/2.
//
//

#import <UIKit/UIKit.h>

@interface accountPage : UIView
{
    NSInteger cellNum;
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *accountType;
@property (strong, nonatomic) IBOutlet UILabel *accountName;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeName;
@property (strong, nonatomic) IBOutlet UILabel *unclearMoney;
@property (strong, nonatomic) IBOutlet UILabel *totalMoney;

@end

//
//  AlertPasscodeViewController.h
//  CarbMaster
//
//  Created by BHI_H04 on 4/1/10.
//  Copyright 2010 BHI. All rights reserved.
//

/*当选中了 任何一个 tableViewCell表示是关闭还是修改密码 就进入到了这个界面*/
#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
@class SettingSplitViewController;
@interface AlertPasscodeViewController_iPhone : UIViewController<UITextFieldDelegate>
{
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	UITextField*											txtPasscode;
	UILabel*												lblNotification;
	Setting*												setting;
	NSString *												openType;
    BOOL                                                    isPasscode;
    NSString  *                                             oldString;
    UILabel     *faildLabelText;
    UILabel         *enterLabelText;
    

}	
@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) IBOutlet UILabel*				lblNotification;
@property (nonatomic, strong) Setting*					setting;
@property (nonatomic, strong) NSString *					openType;

@property (nonatomic, strong) IBOutlet UILabel     *faildLabelText;
@property (nonatomic, strong) IBOutlet UILabel         *enterLabelText;


-(void)cancelPressed:(id)sener;
-(IBAction)charEntered;
@end

//
//  PasscodeSettingViewController_iPad.h
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"
#import "ipad_SettingViewController.h"
#import "PasscodeReenterViewController_iPad.h"

@interface PasscodeSettingViewController_iPad : UIViewController
<UITextFieldDelegate,PasscodeReenterDelegate_iPad,
UIPopoverControllerDelegate
>
{
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	
	UITextField*											txtPasscode;
	
	UILabel*												lblNotification;
	
	Setting*												setting;
	
	NSString												*typeOftodo;
    ipad_SettingViewController                            *settingSVC;
    UILabel         *faildLabelText;
    
    
}

@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) IBOutlet UILabel*				lblNotification;
@property (nonatomic, strong) Setting*						setting;

@property (nonatomic, strong) NSString						*typeOftodo;
@property (nonatomic, strong) ipad_SettingViewController *settingSVC;
@property (nonatomic, strong) IBOutlet UILabel         *faildLabelText;



-(void)cancelPressed:(id)sender;
-(IBAction)charEntered;
@end

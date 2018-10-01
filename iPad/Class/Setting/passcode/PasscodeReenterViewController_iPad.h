//
//  PasscodeReenterViewController_iPad.h
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import <UIKit/UIKit.h>
@protocol PasscodeReenterDelegate_iPad;

@interface PasscodeReenterViewController_iPad : UIViewController
<
UITextFieldDelegate,UIPopoverControllerDelegate
>
{
	id <PasscodeReenterDelegate_iPad>							delegate;
	
	UITextField*											txtP1;
	UITextField*											txtP2;
	UITextField*											txtP3;
	UITextField*											txtP4;
	
	UITextField*											txtPasscode;
	
	NSString*												passcode;
	
	NSString *typetodo;
    UILabel         *faildLabelText;
}

@property (nonatomic, strong) id <PasscodeReenterDelegate_iPad>	delegate;

@property (nonatomic, strong) IBOutlet UITextField*			txtP1;
@property (nonatomic, strong) IBOutlet UITextField*			txtP2;
@property (nonatomic, strong) IBOutlet UITextField*			txtP3;
@property (nonatomic, strong) IBOutlet UITextField*			txtP4;
@property (nonatomic, strong) IBOutlet UITextField*			txtPasscode;
@property (nonatomic, strong) NSString*						passcode;
@property (nonatomic, strong) NSString*						typetodo;
@property (nonatomic, strong) IBOutlet UILabel         *faildLabelText;

-(IBAction)charEntered;

@end

@protocol PasscodeReenterDelegate_iPad

-(void)passcodeDidReentered:(NSString*)passcode;
@end

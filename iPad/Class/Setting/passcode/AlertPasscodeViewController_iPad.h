//
//  AlertPasscodeViewController_iPad.h
//  PocketExpense
//
//  Created by humingjing on 14-8-5.
//
//

#import <UIKit/UIKit.h>
#import "Setting+CoreDataClass.h"

@interface AlertPasscodeViewController_iPad : UIViewController
<UITextFieldDelegate>
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

-(void)cancelPressed:(id)sener;
-(IBAction)charEntered;

@end

//
//  ipad_SelectImageViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-6-4.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@class ipad_TranscactionQuickEditViewController;
@interface ipad_SelectImageViewController : UIViewController
<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate>{
    
	UIImageView *viewImage;
	NSString *imageName;
	NSString *documentsPath;
    UIButton    *sendBtn;
    UIButton    *deleteBtn;
    
	BOOL isIpadShow;
    
    ipad_TranscactionQuickEditViewController *iTransactionEditViewController;
    
}
@property (nonatomic,strong) IBOutlet UIImageView*			  viewImage;

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *documentsPath;
@property (nonatomic,strong)IBOutlet UIButton    *sendBtn;
@property (nonatomic,strong)IBOutlet UIButton    *deleteBtn;
@property (nonatomic,assign) BOOL isIpadShow;

@property(nonatomic,strong)ipad_TranscactionQuickEditViewController *iTransactionEditViewController;


@end

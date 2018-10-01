//
//  SelectImageViewController.h
//  PokcetExpense
//
//  Created by Tommy on 2/24/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

//--------------------------------Edit Transaction中选择 图片的页面---------------------------------------
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol SelectImageViewDelegate <NSObject>

-(void)returnPhotoDelete;

@end

@class TransactionEditViewController;
@interface SelectImageViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (nonatomic,strong) IBOutlet UIImageView   *viewImage;

@property (nonatomic,copy) NSString                 *imageName;
@property (nonatomic,copy) NSString                 *documentsPath;
@property (nonatomic,strong)IBOutlet UIButton       *sendBtn;
@property (nonatomic,strong)IBOutlet UIButton       *deleteBtn;
@property (nonatomic,assign) BOOL                   isIpadShow;
@property(nonatomic, weak)id<SelectImageViewDelegate> delegate;

@property(nonatomic,strong)TransactionEditViewController *sivc_transactionEditViewController;


@end

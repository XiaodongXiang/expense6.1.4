//
//  SelectImageViewController.m
//  PokcetExpense
//
//  Created by Tommy on 2/24/11.
//  Copyright 2011 BHI Technologies, Inc. All rights reserved.
//

#import "SelectImageViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "TransactionEditViewController.h"
#import "AppDelegate_iPhone.h"


#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@implementation SelectImageViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStyle];
    [self initPoint];
	
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar doSetNavigationBar];
    self.navigationItem.title = NSLocalizedString(@"VC_View Photo", nil);

    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible2.width = -12.f;

    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	changeBtn.frame = CGRectMake(0, 0, 80, 30);
    [changeBtn setTitle:NSLocalizedString(@"VC_Change", nil) forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor clearColor];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    [changeBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];
	[changeBtn addTarget:self action:@selector(changBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBar =[[UIBarButtonItem alloc] initWithCustomView:changeBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];
}

-(void)initPoint
{
    _lineH.constant = EXPENSE_SCALE;
    
    [_sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark BtnAction
-(void)sendBtnPressed:(id)sender{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VC_No Mail Accounts", nil) message:NSLocalizedString(@"VC_Please set up a mail account in order to send mail.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"VC_OK", nil) otherButtonTitles:nil];
            [alertView show];
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.appAlertView = alertView;
        }

    }
}


-(void)deleteBtnPressed:(id)sender{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.imageName];
    [fileManager removeItemAtPath:oldImagepath error:&error];
    
    if ([self.delegate respondsToSelector:@selector(returnPhotoDelete)]) {
        [self.delegate returnPhotoDelete];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    _viewImage.image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath,  _imageName]];
}
	
-(void)cancel:(id)sender
{
	if(_isIpadShow)
	{
		PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.AddSubPopoverController dismissPopoverAnimated:YES];

	}
		else
            [self.navigationController popViewControllerAnimated:YES];
}

-(void)changBtnPressed:(UIButton *)sender{
    
    if ( ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]))
    {
        UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"VC_Photo from Camera", nil),NSLocalizedString(@"VC_Photo from Library", nil),
                                     nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionSheet;
    }
    else
    {
        UIActionSheet *actionSheet= [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"VC_Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"VC_Photo from Library", nil),
                                     nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionSheet;
    }

}

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];


	//有摄像机的设备
	if(actionSheet.tag == 0)
	{
		if (buttonIndex == 0)
		{
			UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
			picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker1.delegate= self;
            
            UIImage *image = [[UIImage alloc]init];
            self.navigationController.navigationBar.shadowImage = image;
            
            [self presentViewController:picker1 animated:YES completion:nil];

		}
		if(buttonIndex == 1)
		{
			UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
			picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			picker1.delegate= self;

            [self presentViewController:picker1 animated:YES completion:nil];

		}
		if (buttonIndex == 2)
		{
			return;
		}
	}
    //无摄像头设备
	else if(actionSheet.tag == 1)
	{
		if(buttonIndex == 0)
		{
 			UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
			//[picker1.navigationBar setTintColor:[UIColor colorWithRed:68.0/255 green:143.0/255 blue:167.0/255 alpha:1.0]];
			picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

			picker1.delegate= self;
			[self presentViewController:picker1 animated:YES completion:nil ];

		}
		if (buttonIndex == 1)
		{
			return;
		}
	}
	
    else if (actionSheet.tag==100|| actionSheet.tag==101){
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/pocket-expense/id417328997?mt=8"]];
        }
        else
            return;
        
    }
}

-(void)changeStatusBarStyle:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}
#pragma mark UIImageViewSelectedViewController
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

//选中了一个之后 就将这个数据写到本地文件中
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)selectedImage
				  editingInfo:(NSDictionary *)editingInfo
{
    //搜索到以前的图片然后删除
    if (self.imageName != nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.imageName];
        [fileManager removeItemAtPath:oldImagepath error:&error];
    }

    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
    NSString *tmpimageName =  (__bridge NSString *)string;
    
    //修改这个viewController的名字
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(selectedImage, 1.f)];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, tmpimageName] atomically:YES];
    self.imageName = (__bridge NSString *)(string);

    //修改transaction中的名字
 	UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, tmpimageName]];
	UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
    self.sivc_transactionEditViewController.phontoImageView.image = imaged;
    self.sivc_transactionEditViewController.photosName = _imageName;

    [picker dismissViewControllerAnimated:YES completion:nil];
}


//选中了一个之后 就将这个数据写到本地文件中
//- (void)imagePickerController:(UIImagePickerController *)picker
//		didFinishPickingImage:(UIImage *)selectedImage
//				  editingInfo:(NSDictionary *)editingInfo
//{
//    NSData *imgData = UIImageJPEGRepresentation(selectedImage, 0);
//    NSLog(@"Size of Image(bytes):%d",[imgData length]);
//    
////    UIImage *scaledImage = [self imageByScalingAndCroppingForSize:selectedImage withTargetSize:CGSizeMake(320, 480)];
//    
//    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0.25);
//    UIImage *finalSelectImage = [UIImage imageWithData:imageData];
//
//    self.sivc_transactionEditViewController.photoImageData = finalSelectImage;
//    
//    [picker  dismissModalViewControllerAnimated:YES];
//}

#pragma mark - View Handle select image
- (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage withTargetSize: (CGSize)targetSize
{
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else
			if (widthFactor < heightFactor)
			{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark mail delegete
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	[picker setSubject:@"Expense 5 Transaction Pictures"];
	[picker setToRecipients:nil];
	[picker setCcRecipients:nil];
	[picker setCcRecipients:nil];
    NSString *emailBody;
    if (isPad) {
        emailBody = @"<html> The attachment is exported from PocketExpense for the iPad.</html>";
    }
    else
        emailBody = @"<html> The attachment is exported from PocketExpense for the iPhone.</html>";
	
	[picker setMessageBody:emailBody isHTML:YES];
    
    
    NSData *tmpimageData = UIImagePNGRepresentation(_viewImage.image);            // png
    [picker addAttachmentData:tmpimageData mimeType:@"image/png" fileName:@"photo.png"];
	[self presentViewController:picker animated:YES completion:nil];
}

//mail 代理
#pragma mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end

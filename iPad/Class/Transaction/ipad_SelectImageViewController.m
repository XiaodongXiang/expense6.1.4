//
//  ipad_SelectImageViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-6-4.
//
//

#import "ipad_SelectImageViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "ipad_TranscactionQuickEditViewController.h"
#import "AppDelegate_iPad.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface ipad_SelectImageViewController ()

@end

@implementation ipad_SelectImageViewController
@synthesize viewImage,imageName,documentsPath,sendBtn,deleteBtn;
@synthesize isIpadShow;
@synthesize iTransactionEditViewController;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStyle];
    [self initPoint];
	
}

-(void)initNavStyle{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -11.f;
    
    UIBarButtonItem *flexible2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    flexible2.width = -12.f;
    
    //back
    UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customerButton.frame = CGRectMake(0, 0, 30, 30);
	[customerButton setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
	[customerButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:customerButton];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	changeBtn.frame = CGRectMake(0, 0, 90, 30);
    [changeBtn setTitle:NSLocalizedString(@"VC_Change", nil) forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor clearColor];
    [changeBtn setTitleColor:[appDelegate.epnc getiPADNavigationBarBtnColor] forState:UIControlStateNormal];
    [changeBtn setTitleColor:[appDelegate.epnc getNavigationBarGray_Highlighted ] forState:UIControlStateHighlighted];

	[changeBtn addTarget:self action:@selector(changBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBar =[[UIBarButtonItem alloc] initWithCustomView:changeBtn];
	self.navigationItem.rightBarButtonItems = @[flexible2,rightBar];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_View Photo", nil);
    self.navigationItem.titleView = 	titleLabel;
    
	
    
    
   }

-(void)initPoint{
    [sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
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
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
            appDelegate.appAlertView = alertView;
        }
        
    }
}


-(void)deleteBtnPressed:(id)sender{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *oldImagepath = [NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, self.imageName];
    [fileManager removeItemAtPath:oldImagepath error:&error];
    
    if (self.iTransactionEditViewController != nil) {
        self.iTransactionEditViewController.photosName = nil;
        self.iTransactionEditViewController.phontoImageView.image = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    viewImage.image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath,  imageName]];
    
}

-(void)cancel:(id)sender
{
	if(isIpadShow)
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
        
//        CGPoint point1 = [self.view convertPoint:selectedCell.frame.origin toView:self.view];
        [actionSheet showFromRect:sender.frame inView:self.view
                         animated:YES];
        
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
//        [actionSheet showInView:self.view];
        [actionSheet showFromRect:sender.frame inView:self.view
                         animated:YES];
        PokcetExpenseAppDelegate    *appDelegate = (PokcetExpenseAppDelegate    *)[[UIApplication sharedApplication]delegate];
        appDelegate.appActionSheet = actionSheet;
    }
    
}

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(changeStatusBarStyle:) withObject:nil afterDelay:0.5];
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];

}

-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
   	//有摄像机的设备
    if(actionSheet.tag == 0)
    {
        if (buttonIndex == 0) //dub不了
        {
            AppDelegate_iPad *appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            [appDelegate_ipad.appActionSheet dismissWithClickedButtonIndex:2 animated:NO];
            
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker1.delegate= self;
            
            //新加
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(0, 0, 501, 416.0)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
 
        }
        else if(buttonIndex == 1)
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501.0, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(0, 0, 501.0,416)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            
            return;
            
            
        }
        else if (buttonIndex == 2)
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
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.delegate= self;
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.AddSubPopoverController= [[UIPopoverController alloc] initWithContentViewController:picker1] ;
            appDelegate.AddSubPopoverController.popoverContentSize = CGSizeMake(501.0, 480.0);
            appDelegate.AddSubPopoverController.delegate = self;
            [appDelegate.AddSubPopoverController presentPopoverFromRect:CGRectMake(0, 0, 501.0,416)
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            
            
            
            
            
            
        }
        else if (buttonIndex == 1)
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
    self.imageName = tmpimageName;
    viewImage.image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath,  imageName]];
	
    //修改transaction中的名字
 	UIImage *tmpImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg", self.documentsPath, tmpimageName]];
	UIImage * imaged = [self imageByScalingAndCroppingForSize:tmpImage withTargetSize:CGSizeMake(40, 40)];
    self.iTransactionEditViewController.phontoImageView.image = imaged;
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
	[picker setSubject:@"Pocket Expense Transaction Pictures"];
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
    
    
    NSData *tmpimageData = UIImagePNGRepresentation(viewImage.image);            // png
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

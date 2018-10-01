//
//  BackUpAndRestoreViewController.m
//  PokcetExpense
//
//  Created by ZQ on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BackUpAndRestoreViewController.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "AppDelegate_iPad.h"
#import "PokcetExpenseAppDelegate.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@implementation BackUpAndRestoreViewController
@synthesize displayUrlLabel;
@synthesize http;
@synthesize isIpad;
@synthesize webServerLabelText,backLabelText1,backLabelText2,backLabelText3,backLabelText4,backLabelText5;
@synthesize activityIndicator;

#pragma mark lifeStyle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib. 当打开了这个view的时候，电脑端才会对于backup的ID有效
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化一个back up
    http=[[Http alloc] initWithServer];
    http.delegate=self;

    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
//    [self.navigationController.navigationBar doSetNavigationBar];
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = NSLocalizedString(@"VC_Backup_Restore", nil);
    
    if (isPad) {
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        flexible.width = -11;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        //left btn
        [btn setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
        //back tbn
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItems = @[flexible,leftBar];
        
        //title
        [titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
        self.activityIndicator.frame = CGRectMake((480-20)/2, 67, 20, 20);
    }
    else
    {
        [titleLabel setTextColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1]];
        self.activityIndicator.frame = CGRectMake((320-20)/2, 67, 20, 20);

    }
    //title
    self.navigationItem.titleView = 	titleLabel;

    webServerLabelText.text = NSLocalizedString(@"VC_WebServerAddress", nil);
    backLabelText1.text =NSLocalizedString(@"VC_BackNotes1", nil);
    backLabelText2.text =NSLocalizedString(@"VC_BackNotes2", nil);
    backLabelText3.text =NSLocalizedString(@"VC_BackNotes3", nil);
    backLabelText4.text =NSLocalizedString(@"VC_BackNotes4", nil);
    backLabelText5.text =NSLocalizedString(@"VC_BackNotes5", nil);
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark BtnAction
- (void) back:(id)sender{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

//-----------获取压缩文件
-(void)createZipFile
{
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    //获得指定文件夹中的所有文件
 	NSArray *array = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
	//将路径中的代字符扩展成用户主目录(~)或指定用户的主目录(~user)
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	//创建一个以PocketExpenseBak.zip命名的压缩包文件
	NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/PocketExpenseBak.zip"];
    //创建一个文件压缩工具
	ZipArchive* zipFile = [[ZipArchive alloc] init];
    //由文件压缩工具创建一个压缩包
	BOOL ret=[zipFile CreateZipFile2:path2];
    //如果创建压缩文件没成功就一直创建
	while(!ret)
	{
		[fileManager createFileAtPath:path2 contents:nil attributes:nil];
		ret=[zipFile CreateZipFile2:path2];
	}
    //将指定文件夹中所有的文件压缩重新设定名称
    for (NSString *fname in array)
    {
		NSString* a=[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", fname]];
		ret =[zipFile addFileToZip:a newname:[fname stringByAppendingString:@".p"]];
	}
	if( ret)
	{
		[zipFile CloseZipFile2];
	}
	else
	{
        
	}

}
#pragma mark system method
-(void)displayInfo:(NSString*)info
{
	[displayUrlLabel setText:info];
    
    [self.activityIndicator endEditing:YES];
    self.activityIndicator.hidden = YES;
}



@end

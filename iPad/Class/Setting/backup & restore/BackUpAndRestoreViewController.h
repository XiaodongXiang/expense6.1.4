//
//  BackUpAndRestoreViewController.h
//  PokcetExpense
//
//  Created by ZQ on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*--------------------------------back up的功能view----------------------*/
#import <UIKit/UIKit.h>
#import "Http.h"

@interface BackUpAndRestoreViewController : UIViewController
<
HttpDelegate
>
{
	Http*			http;
    //显示 与该台设备关联的 backup ID
	UILabel *		displayUrlLabel;
    //判断设备是不是iPad
	BOOL isIpad;
    
    UILabel     *webServerLabelText;
    UILabel     *backLabelText1;
    UILabel     *backLabelText2;
    UILabel     *backLabelText3;
    UILabel     *backLabelText4;
    UILabel     *backLabelText5;
}
@property (nonatomic, strong) IBOutlet UILabel *	displayUrlLabel;
@property (nonatomic, strong) Http*					http;
@property (nonatomic, assign) BOOL isIpad;

@property (nonatomic, strong) IBOutlet UILabel     *webServerLabelText;
@property (nonatomic, strong) IBOutlet UILabel     *backLabelText1;
@property (nonatomic, strong) IBOutlet UILabel     *backLabelText2;
@property (nonatomic, strong) IBOutlet UILabel     *backLabelText3;
@property (nonatomic, strong) IBOutlet UILabel     *backLabelText4;
@property (nonatomic, strong) IBOutlet UILabel     *backLabelText5;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;

//创建一个压缩包
-(void)createZipFile;
//显示信息
-(void)displayInfo:(NSString*)info;

@end

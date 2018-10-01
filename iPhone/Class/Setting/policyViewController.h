//
//  policyViewController.h
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/12.
//
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface policyViewController : UIViewController <UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (strong, nonatomic)  UIWebView *webView;

@end

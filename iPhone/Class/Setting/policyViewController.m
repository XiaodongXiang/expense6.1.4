//
//  policyViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/12.
//
//

#import "policyViewController.h"
#import "NJKWebViewProgressView.h"

@interface policyViewController ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@end

@implementation policyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float width;
    if (ISPAD)
    {
        width=540;
    }
    else
    {
        width=SCREEN_WIDTH;
    }
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT-64)];
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0, SCREEN_WIDTH, progressBarHeight);
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [self.view addSubview:_progressView];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.iubenda.com/privacy-policy/7775087"]];
    [_webView loadRequest:req];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    


}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@" %@ ",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

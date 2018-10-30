//
//  XDTermsOfUseViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/6.
//

#import "XDTermsOfUseViewController.h"

@import Firebase;

@interface XDTermsOfUseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation XDTermsOfUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"TermsOfUse_expense" ofType:@"rtf"];
    //    NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    textView.text  = myText;
    NSURL * txtUrl = [[NSURL alloc] initFileURLWithPath:filePath];
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithURL:txtUrl options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    
    self.textView.attributedText = attributeStr;
    [FIRAnalytics setScreenName:@"terms_of_use_view_iphone" screenClass:@"XDTermsOfUseViewController"];
    self.textView.editable = NO;
    
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

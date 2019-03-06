//
//  XDFireLoginClass.m
//  PocketExpense
//
//  Created by 晓东项 on 2019/3/5.
//

#import "XDFireLoginClass.h"

#define EmailLink @"https://appxyauthsandbox.page.link"
@import Firebase;

@interface XDFireLoginClass()
@property(nonatomic, strong)FIRApp* app;


@end
@implementation XDFireLoginClass

+(XDFireLoginClass*)share{
    static XDFireLoginClass* g_class = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_class = [[XDFireLoginClass alloc]init];
    });
    return g_class;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.app = [FIRApp appNamed:@"login"];
    }
    return self;
}

-(void)sendEmail:(NSString*)email{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://pocketexpenselite.page.link/EBMe/?email=%@",@"1075183334@qq.com"]];
    
    FIRActionCodeSettings *actionCodeSettings = [[FIRActionCodeSettings alloc] init];
    [actionCodeSettings setURL:url];
    // The sign-in operation has to always be completed in the app.
    actionCodeSettings.handleCodeInApp = YES;
    [actionCodeSettings setIOSBundleID:[[NSBundle mainBundle] bundleIdentifier]];
    
    [[FIRAuth auth] sendSignInLinkToEmail:@"18217705518@163.com"
                       actionCodeSettings:actionCodeSettings
                               completion:^(NSError *_Nullable error) {
                                   // ...
                                   if (error) {
                                       NSLog(@"error == %@",error.localizedDescription);
                                       return;
                                   }
                                   // The link was successfully sent. Inform the user.
                                   // Save the email locally so you don't need to ask the user for it again
                                   // if they open the link on the same device.
                                   NSLog(@"Check your email for link");
                                   // ...
                               }];
}


@end

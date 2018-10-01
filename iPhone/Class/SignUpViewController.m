//
//  SignUpViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/4/28.
//
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate_iPhone.h"
#import "User.h"
@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *affirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordconfirmTextfield;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextfield setSecureTextEntry:YES];
    [_passwordconfirmTextfield setSecureTextEntry:YES];
    [_affirmBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)signUp
{
    PFUser *user=[PFUser user];
    if (![_passwordconfirmTextfield.text isEqualToString:_passwordTextfield.text])
    {
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"信息错误" message:@"密码信息不一致" delegate:self cancelButtonTitle:@"重新注册" otherButtonTitles:nil, nil];
        [alterView show];
        _passwordconfirmTextfield.text=nil;
        _passwordTextfield.text=nil;
        return;
    }
    else
    {
        user.password=_passwordTextfield.text;
        user.email=_emailTextField.text;
        user.username=_emailTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeded,NSError *error)
        {
            if (!error)
            {
                //将本地信息与云端信息同步
                NSLog(@"注册成功");
                PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
                User *userLocal=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
                
                userLocal.userName=user.username;
                
                //将同步时间设置为1970年
                userLocal.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
                NSLog(@"%@",userLocal.syncTime);
                NSError *errorAdmit;
                [appDelegate.managedObjectContext save:&errorAdmit];

            }
            else
            {
                NSString *errorString=[error userInfo][@"error"];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"信息错误" message:errorString delegate:self cancelButtonTitle:@"重新注册" otherButtonTitles:nil, nil];
                [alertView show];
                _passwordconfirmTextfield.text=nil;
                _passwordTextfield.text=nil;
                return;
            }
        }];
    }
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

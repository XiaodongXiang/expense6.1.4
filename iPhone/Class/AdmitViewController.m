//
//  AdmitViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/4/28.
//
//

#import "AdmitViewController.h"

#import <Parse/Parse.h>

#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPhone.h"
#import "User.h"
@interface AdmitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *admitBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation AdmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextfield setSecureTextEntry:YES];
    [_admitBtn addTarget:self action:@selector(admit) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
}
-(void)check
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *requestUser=[[NSFetchRequest alloc]init];
    NSEntityDescription *descUser=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:appDelegate.managedObjectContext];
    requestUser.entity=descUser;
    
    NSError *error;
    
    NSArray *arrayUser=[appDelegate.managedObjectContext executeFetchRequest:requestUser error:&error];
    NSLog(@"%li",arrayUser.count);
}
-(void)admit
{
    [PFUser logInWithUsernameInBackground:_userNameTextfield.text password:_passwordTextfield.text block:^(PFUser *user,NSError *error)
    {
        if (user)
        {
            PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];
            User *userLocal=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
            
            userLocal.userName=user.username;
            
            //将同步时间设置为1970年
            userLocal.syncTime=[NSDate dateWithTimeIntervalSince1970:0];
            NSLog(@"%@",userLocal.syncTime);
            NSError *errorAdmit;
            [appDelegate.managedObjectContext save:&errorAdmit];
            //立即进行同步操作,因为同步时间为1970年,因而将会同步所有数据
            //
            
        }
        else
        {
            _userNameTextfield.text=nil;
            _passwordTextfield.text=nil;
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"登陆信息有误" message:@"请重试" delegate:self cancelButtonTitle:@"重新输入信息" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    
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

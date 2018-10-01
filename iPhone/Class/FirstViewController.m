//
//  FirstViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/4/28.
//
//

#import "FirstViewController.h"

#import "SignUpViewController.h"

#import "AdmitViewController.h"

#import "AppDelegate_iPhone.h"

#import <Parse/Parse.h>

#import "ParseDBManager.h"

@interface FirstViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *AdmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *SignUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *syncBtn;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.AdmitBtn addTarget:self action:@selector(Admit) forControlEvents:UIControlEventTouchUpInside];
    [self.SignUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.syncBtn addTarget:self action:@selector(dataSync) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)dataSync
{
//    [[ParseDBManager sharedManager];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.networkConnected)
    {
        [[ParseDBManager sharedManager]dataSyncWithServer];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"The network is not available" message:@"Connect to the network and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
        [alertView show];
    }
}
-(void)logOut
{
    [PFUser logOut];
    //删除本地缓存文件
    
}
-(void)signUp
{
    SignUpViewController *vc=[[SignUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)Admit
{
    AdmitViewController *vc=[[AdmitViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%li",buttonIndex);
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

//
//  PasscodeStyle_iPhoneViewController_iPad.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 16/1/20.
//
//

#import "PasscodeStyle_iPhoneViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AlertPasscodeViewController_iPad.h"
#import "PasscodeSettingViewController_iPad.h"
#import "touchIDViewController_iPad.h"
#import "PasscodeViewController_iPad.h"

@interface PasscodeStyle_iPhoneViewController_iPad ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation PasscodeStyle_iPhoneViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"密码保护";
    [self createTableView];
    
    [self checkmarkInit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkmarkInit) name:@"touchVCBack" object:nil];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:99/255.0 green:203/255.0 blue:255/255.0 alpha:1]];
    
    _passcodeLabel.text=NSLocalizedString(@"VC_Passcode", nil);
    _offLabel.text=NSLocalizedString(@"VC_OFF", nil);   
}
-(void)checkmarkInit
{
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([appDelegate.settings.passcodeStyle isEqualToString:@"none"] || appDelegate.settings.passcodeStyle == nil)
    {
        _noneCell.accessoryType=UITableViewCellAccessoryCheckmark;
        _numberCell.accessoryType=nil;
        _touchIDCell.accessoryType=nil;
    }
    else if ([appDelegate.settings.passcodeStyle isEqualToString:@"number"])
    {
        _noneCell.accessoryType=nil;
        _numberCell.accessoryType=UITableViewCellAccessoryCheckmark;
        _touchIDCell.accessoryType=nil;
    }
    else
    {
        _noneCell.accessoryType=nil;
        _numberCell.accessoryType=nil;
        _touchIDCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 540,620) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [self.view addSubview:_tableView];
}
#pragma tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0)
    {
        return _noneCell;
    }
    if (indexPath.row==1)
    {
        return _numberCell;
    }
    else
    {
        return _touchIDCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    LAContext *context=[LAContext new];
    context.localizedFallbackTitle=@"";
    
    NSError *error;
    
    NSString *formerPasscodeStyle=appDelegate.settings.passcodeStyle;
    if (indexPath.row==0)
    {
        if ([formerPasscodeStyle isEqualToString:@"number"])
        {
            AlertPasscodeViewController_iPad * alertPasscodeViewController = [[AlertPasscodeViewController_iPad alloc] initWithNibName:@"AlertPasscodeViewController_iPad" bundle:nil];
            appDelegate.settings.passcodeStyle=@"none";
            alertPasscodeViewController.setting = appDelegate.settings;
            alertPasscodeViewController.openType=@"OFF";
            [self.navigationController pushViewController:alertPasscodeViewController animated:YES];
            
        }
        
        if ([formerPasscodeStyle isEqualToString:@"touchid"])
        {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"VC_CloseTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    appDelegate.settings.passcodeStyle=@"none";
                    [appDelegate.managedObjectContext save:&error];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
            }];
        }
        
    }
    if (indexPath.row==1)
    {
        if ([formerPasscodeStyle isEqualToString:@"none"] || formerPasscodeStyle == nil)
        {
            
            PasscodeSettingViewController_iPad* passcodeSettingController = [[PasscodeSettingViewController_iPad alloc] initWithNibName:@"PasscodeSettingViewController_iPad" bundle:nil];
            passcodeSettingController.setting = appDelegate.settings;
            passcodeSettingController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:passcodeSettingController animated:YES];
            
        }
        if ([formerPasscodeStyle isEqualToString:@"number"])
        {
            AlertPasscodeViewController_iPad * alertPasscodeViewController = [[AlertPasscodeViewController_iPad alloc] initWithNibName:@"AlertPasscodeViewController_iPad" bundle:nil];
            alertPasscodeViewController.setting = appDelegate.settings;
            alertPasscodeViewController.openType=@"CHANGE";
            [self.navigationController pushViewController:alertPasscodeViewController animated:YES];
            
        }
        if ([formerPasscodeStyle isEqualToString:@"touchid"])
        {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"VC_CloseTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        PasscodeSettingViewController_iPad* passcodeSettingController = [[PasscodeSettingViewController_iPad alloc]initWithNibName:@"PasscodeSettingViewController_iPad" bundle:nil];
                        passcodeSettingController.setting = appDelegate.settings;
                        passcodeSettingController.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:passcodeSettingController animated:YES];
                    });
                }
            }];
        }
    }
    if (indexPath.row==2)
    {
        if ([formerPasscodeStyle isEqualToString:@"none"] ||formerPasscodeStyle == nil)
        {
            BOOL success=[context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
            if (success)
            {
                //可以使用TouchID
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"VC_OpenTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                    if (success)
                    {
                        appDelegate.settings.passcodeStyle=@"touchid";
                        NSError *touchidError;
                        [appDelegate.managedObjectContext save:&touchidError];
              
                    }
                }];
            }
            else
            {
                //无法使用touchID
            }
        }
        
        if ([formerPasscodeStyle isEqualToString:@"number"])
        {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"VC_OpenTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    appDelegate.settings.passcodeStyle=@"touchid";
                    [appDelegate.managedObjectContext save:&error];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
            }];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)handlePasscode
{
    AppDelegate_iPad *appDelegete = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegete.settings.passcode length] > 0)
        
    {
        PasscodeViewController_iPad* passcodeController = [[PasscodeViewController_iPad alloc] initWithNibName:@"PasscodeViewController_iPhone" bundle:nil];
        passcodeController.setting = appDelegete.settings;
        passcodeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passcodeController animated:YES];
        
    }
    else
    {
        PasscodeSettingViewController_iPad* passcodeSettingController = [[PasscodeSettingViewController_iPad alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
        passcodeSettingController.setting = appDelegete.settings;
        passcodeSettingController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:passcodeSettingController animated:YES];
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

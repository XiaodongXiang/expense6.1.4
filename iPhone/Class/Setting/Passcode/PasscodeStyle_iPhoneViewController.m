//
//  PasscodeStyle_iPhoneViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/10/8.
//
//

#import "PasscodeStyle_iPhoneViewController.h"
#import "PokcetExpenseAppDelegate.h"
#import "PasscodeViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "PasscodeSettingViewController_iPhone.h"
#import "AlertPasscodeViewController_iPhone.h"
#import "TouchIdViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface PasscodeStyle_iPhoneViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@end

@implementation PasscodeStyle_iPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"VC_Passcode", nil);
    [self createTableView];
    
    [self checkmarkInit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkmarkInit) name:@"touchVCBack" object:nil];
    _passcodeLabel.text=NSLocalizedString(@"VC_Passcode", nil);
    _offLabel.text=NSLocalizedString(@"VC_OFF", nil);

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    if (IS_IPHONE_X) {
        self.thirdLabel.text = @"Face ID";
    }
    _tableView.separatorColor = RGBColor(226, 226, 226);
    
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
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
            AlertPasscodeViewController_iPhone * alertPasscodeViewController = [[AlertPasscodeViewController_iPhone alloc] initWithNibName:@"AlertPasscodeViewController_iPhone" bundle:nil];
            alertPasscodeViewController.setting = appDelegate.settings;
            alertPasscodeViewController.openType=@"OFF";
            [self.navigationController pushViewController:alertPasscodeViewController animated:YES];
            
        }
        
        if ([formerPasscodeStyle isEqualToString:@"touchid"])
        {
            [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?NSLocalizedString(@"VC_CloseFaceID", nil):NSLocalizedString(@"VC_CloseTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
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
            
            PasscodeSettingViewController_iPhone* passcodeSettingController = [[PasscodeSettingViewController_iPhone alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
            passcodeSettingController.setting = appDelegate.settings;
            passcodeSettingController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:passcodeSettingController animated:YES];
        }
        if ([formerPasscodeStyle isEqualToString:@"number"])
        {
            AlertPasscodeViewController_iPhone * alertPasscodeViewController = [[AlertPasscodeViewController_iPhone alloc] initWithNibName:@"AlertPasscodeViewController_iPhone" bundle:nil];
            alertPasscodeViewController.setting = appDelegate.settings;
            alertPasscodeViewController.openType=@"CHANGE";
            [self.navigationController pushViewController:alertPasscodeViewController animated:YES];
        }
        if ([formerPasscodeStyle isEqualToString:@"touchid"])
        {
            [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?NSLocalizedString(@"VC_CloseFaceID", nil):NSLocalizedString(@"VC_CloseTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        PasscodeSettingViewController_iPhone* passcodeSettingController = [[PasscodeSettingViewController_iPhone alloc]initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
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
            BOOL success=[context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
            if (success)
            {
                //可以使用TouchID
                [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?NSLocalizedString(@"VC_OpenFaceID", nil):NSLocalizedString(@"VC_OpenTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
                    if (success)
                    {
                        appDelegate.settings.passcodeStyle=@"touchid";
                        NSError *touchidError;
                        [appDelegate.managedObjectContext save:&touchidError];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            TouchIdViewController *touchVC=[[TouchIdViewController alloc]initWithNibName:@"TouchIdViewController" bundle:nil];
                            [self.navigationController pushViewController:touchVC animated:YES];
                        });
                        
                    }
                    else
                    {
                        NSLog(@"失败");
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
            [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:IS_IPHONE_X?NSLocalizedString(@"VC_OpenFaceID", nil):NSLocalizedString(@"VC_OpenTouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
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
    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegete.settings.passcode length] > 0)
        
    {
        PasscodeViewController_iPhone* passcodeController = [[PasscodeViewController_iPhone alloc] initWithNibName:@"PasscodeViewController_iPhone" bundle:nil];
        passcodeController.setting = appDelegete.settings;
        passcodeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passcodeController animated:YES];
        
    }
    else
    {
        PasscodeSettingViewController_iPhone* passcodeSettingController = [[PasscodeSettingViewController_iPhone alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
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
